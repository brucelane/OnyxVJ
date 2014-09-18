package services.osc {
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.net.XMLSocket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import onyx.asset.AssetQuery;
	import onyx.core.Console;
	import onyx.core.onyx_ns;
	import onyx.ui.UserInterface;
	
	/**
	 *  
	 */
	public final class OSCProvider extends EventDispatcher {
		
		/**
		 * 	@private
		 */
		private const controls:Dictionary	= UserInterface.getAllControls();
		
		//public var    conn:Socket;
		public var    host:String;
		public var    port:String;
		
		private var   _timer:Timer;
		private var   _attempts:int;
		private var   _maxAttempts:int = 3;
		
		public var xmlConn:XMLSocket;

		/**
		 * 	@constructor
		 */		
		public function OSCProvider():void {		
			init();	
		}
		
		
		/**
		 * 
		 */
		private function init():void {
			
			_attempts = 0;
			/*conn = new Socket();		
			conn.addEventListener(Event.CONNECT, handleSocketConnected);
			conn.addEventListener(Event.CLOSE, handleSocketClose);
			conn.addEventListener(ProgressEvent.SOCKET_DATA, handleProgress);
			conn.addEventListener(IOErrorEvent.IO_ERROR, handleSocketIOError);
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSocketSecurityError);*/
			//ARG conn.writeByte(0xFe);
			xmlConn = new XMLSocket();
			xmlConn.addEventListener(Event.CONNECT, handleConnect);
			xmlConn.addEventListener(Event.CLOSE, handleClose);
			xmlConn.addEventListener(DataEvent.DATA, handleIncoming);
			xmlConn.addEventListener(ProgressEvent.SOCKET_DATA, handleProgress);
		}
		
		public function connect():void {
			// 10sec timeout
			if(_attempts<_maxAttempts) {
				_attempts += 1;
				try{
					Console.output('OSC Module: attempt '+_attempts+' on '+host+'@'+port);
					//conn.connect(host, int(port));
					xmlConn.connect(host, int(port));
				} catch (e : SecurityError) {
					_scheduleReconnect()
				}
			} else {
				Console.output('OSC Module: network down');
				_attempts = 0;
			}
		}
		
		public function get connected():Boolean {
			//return conn.connected;
			return xmlConn.connected;
		}
		private function _reconnect(event:Event): void {
			_timer.removeEventListener(TimerEvent.TIMER, _reconnect);
			_timer.stop();
			_timer = null;
			connect();
		}
		private function _scheduleReconnect():void {
			_timer = new Timer(1000,1);
			_timer.addEventListener(TimerEvent.TIMER, _reconnect);
			_timer.start();
		}
		
		
		// *** disconnect from the server
		public function disconnect ():void {
			xmlConn.close();
		}
		
		// *** event handler for incoming XML-encoded OSC packets
		public function handleIncoming (event:DataEvent):void {//xmlIn:XML):void {
			Console.output("dataHandler: " + event.data);
			var xmlIn:XML = XML(event.data);
			// USEFUL DEBUG - display the raw xml data in the output window
			Console.output( xmlIn.toString() +"\n" );
			
			// parse out the packet information
			var e:XMLList = new XMLList(xmlIn);
			if (e != null && e.nodeName == "OSCPACKET") {
				var packet:OSCPacket = new OSCPacket(e.attributes.address, e.attributes.port,
					e.attributes.time, xmlIn);
				displayPacketHeaders(packet);
				parseMessages(xmlIn);
			}
		}
		private function handleProgress(event:ProgressEvent):void {
			
			var n:int 				= event.bytesLoaded;
			var buffer:ByteArray 	= new ByteArray();
			
			buffer = null;
			
		}
		
		// *** event handler to respond to successful connection attempt
		private function handleConnect (succeeded:Boolean):void {
			if(succeeded) {
				Console.output( "Connected to " + host + " on port " + port + "\n" );
				//xmlConn.connected = true;
			} else {
				//xmlConn.connected = false;
			}
		}		
		// *** event handler called when server kills the connection
		private function handleClose ():void {
			Console.output( "The server at " + host + " has terminated the connection.\n" );
			//xmlConn.connected = false;
			//numClients = 0;
		}
		
		// *** display text information about an OSCPacket object
		private function displayPacketHeaders( packet:OSCPacket):void {
			Console.output( "** OSC Packet from " + packet.address +
				", port " + packet.port +
				" for time " + packet.time + "\n");
		}
		// *** parse the messages from some XML-encoded OSC packet
		//
		//     THIS IS WHERE YOU COULD DO SOMETHING COOL
		//     (probably based on the value of the arguments)
		
		private function parseMessages(node):void {
			
			if (node.nodeName == "MESSAGE") {
				Console.output( "Message name: " + node.attributes.NAME + "\n" );
				// loop over the arguments of the message
				for (var child = node.firstChild; child != null; child=child.nextSibling) {
					if (child.nodeName == "ARGUMENT") {
						Console.output( "\tArg type " + child.attributes.TYPE );
						Console.output( ", value " + child.attributes.VALUE + "\n" );
					}
				}
			}
			else { // look recursively for a message node
				for (var child = node.firstChild; child != null; child=child.nextSibling) {
					parseMessages(child);
				}
			}
		}
		// *** build and send XML-encoded OSC
		//
		//		THIS IS ANOTHER PLACE TO DO SOMETHING COOL
		
		private function sendOSC(name, arg, destAddr, destPort):void {
			var xmlOut:XML = new XML();
			
			var osc:XML = xmlOut.createElement("OSCPACKET");
			osc.attributes.TIME = 0;
			osc.attributes.PORT = destPort;
			osc.attributes.ADDRESS = destAddr;
			
			var message:XML = xmlOut.createElement("MESSAGE");
			message.attributes.NAME = name;
			
			var argument:XML = xmlOut.createElement("ARGUMENT");
			// NOTE : the server expects all strings to be encoded
			// with the escape function.
			argument.attributes.VALUE = escape(arg);
			argument.attributes.TYPE = "s";
			
			// NOTE : to send more than one argument, just create
			// more elements and appendChild them to the message.
			// the same goes for multiple messages in a packet.
			message.appendChild(argument);
			osc.appendChild(message);
			xmlOut.appendChild(osc);
			
			if (xmlConn && xmlConn.connected) {
				xmlConn.send(xmlOut);
				Console.output("Sent XML-encoded OSC destined for "
					+ destAddr
					+ ", port "
					+ destPort
					+ "\n" );
			}
		}

		/**
		 * 	@private
		 */
		private function _onFileSaved(query:AssetQuery):void {
			Console.output(query.path + ' saved.');
		}
		
		/*private function handleSocketConnected(e : Event) : void {
			Console.output('OSC Module: connected');
			_attempts = 0;
		}
		private function handleSocketIOError(e : IOErrorEvent) : void {
			Console.output("OSC Module: unable to connect, socket error");
			_scheduleReconnect();
		}
		private function handleSocketSecurityError(e : SecurityErrorEvent) : void {
			Console.output('OSC Module: security error');
		}
		private function handleSocketClose(e:Event):void {
			Console.output('OSC Module: connection lost');
			_scheduleReconnect();
		}*/
		
		
		/*private function handleProgress(event:ProgressEvent):void {
			
			var n:int 				= event.bytesLoaded;
			var buffer:ByteArray 	= new ByteArray();
			
			
			// SC: TODO...n==3 very restrictive due to startup errors!!
			// if(n==3)
			while(conn.bytesAvailable>=3) {
				buffer.clear();
				conn.readBytes(buffer,0,3);
				OSC.rxMessage(buffer);
			}
			
			buffer = null;
			
		}
		
		public function sendData(bytes:ByteArray):void {
			if(conn.connected) {
				conn.writeBytes(bytes);
				conn.flush();
				//Console.output('MIDI Module: sendData bytes:' + bytes.toString());
			}
		}*/
	}
}
