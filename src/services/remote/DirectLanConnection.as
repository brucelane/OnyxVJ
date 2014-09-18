package services.remote
{
	import flash.events.*;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	import onyx.core.Console;
	import onyx.events.InteractionEvent;
	import onyx.plugin.Display;
	import onyx.plugin.Layer;
	
	/**
	 * Creates a direct connection over wifi and is totally independant from any other class in this library 
	 * @author reyco1
	 * 
	 */	
	[Event(name="connected", type="flash.events.TextEvent")]
	public class DirectLanConnection implements IEventDispatcher
	{
		private var dispatcher:EventDispatcher;
		private static var netConnection:NetConnection;
		private var group:NetGroup;

		/**
		 * Boolean value indicating if the connection is establised 
		 */		
		private static var _isConnected:Boolean = false;

		/**
		 * Method that should be executed when data is recieved (should have one argument to hold the object returned from the NetStatusEvent : event.info.message)
		 */		
		public var onDataReceive:Function;
		/**
		 * Method that should be executed once the connection is established (should have one argument to hold the object returned from the NetStatusEvent : event.info.message)
		 */		
		public var onConnect:Function;
		
		private static var cnxInstance:DirectLanConnection;
		private static var numLayers:int = 0;
		
		public static function getInstance():DirectLanConnection
		{
			if (cnxInstance == null)
			{
				Console.output("new cnxInstance");
				cnxInstance = new DirectLanConnection();
				cnxInstance.onConnect = handleConnectToService;
				cnxInstance.onDataReceive = handleGetObject;
			}
			
			return cnxInstance;
		}		
		/**
		 * Creates an instance of DirectLanConnection  
		 * 
		 */		
		public function DirectLanConnection()
		{
				dispatcher = new EventDispatcher(this);
		}
		protected static function handleConnectToService(user:Object):void
		{
			Console.output("handleConnectToService");
			//null cnxInstance.sendData({type:"layers", value:Display.layers.length });			
			cnxInstance.sendData({type:"layers", value:3 });			
		}
		protected static function handleGetObject(dataReceived:Object):void
		{
			trace("dlc: " +dataReceived.type.toString() + " = "+dataReceived.value);
			//Console.output("handleGetObject, dataReceived from " + _clientName + " type: " + dataReceived.type.toString());
			// received
			switch ( dataReceived.type.toString() ) 
			{ 
				case "x-y":
					var _xy:uint = dataReceived.value;
					var e:InteractionEvent = new InteractionEvent(MouseEvent.MOUSE_DOWN);
					
					e.localX	= _xy / 1048576;
					e.localY	= _xy % 1048576;
					
					// forward the event
					Display.forwardEvent(e);
					break;
				/*case "xyp":
					var xyp:uint = dataReceived.value;

					//size = (xyp % 1048576) % 1024;
					var e:InteractionEvent = new InteractionEvent(MouseEvent.MOUSE_DOWN);
					
					e.localX	= xyp / 1048576;
					e.localY	= (xyp % 1048576) / 1024;
					
					// forward the event
					Display.forwardEvent(e);
					break;*/
				/*case "layers":
					numLayers = dataReceived.value;					
					cnxInstance.sendData( {type:"layerbtn", value:"created" }  );
					break;*/
				default: 
					//trace("handleGetObject, dataReceived sending");
					DirectLanConnection.getInstance().dispatchEvent( new DLCEvent(DLCEvent.ON_RECEIVED, dataReceived) );

					break;
			}
		}		
			
		public function connect(url:String = "rtmfp:"):void//"rtmfp://localhost/"):void
		{ 
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, handleStatus);
			// same subnet 
			netConnection.connect(url);
		}
		
		protected function handleStatus(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					Console.output("NetConnection.Connect.Success, setUpGroup" );
					setUpGroup();
					break;
				
				case "NetGroup.Connect.Success":
					Console.output("NetGroup.Connect.Success" );
					isConnected = true;
					if(onConnect != null)
						onConnect.apply(null, [event.info.message]);
					break;
				
				case "NetGroup.SendTo.Notify":
					//Console.output("NetGroup.SendTo.Notify" );
					if(onDataReceive != null)
						onDataReceive.apply(null, [event.info.message]);
					break;
				case "NetConnection.Call.Failed":
					Console.output("NetConnection.Call.Failed" );
					trace("NetConnection.Call.Failed");
					break;
				default: 
					Console.output(event.info.code );
					trace(event.info.code);
					break;
			}
		}
		
		/**
		 * Sends an object 
		 * @param obj
		 * 
		 */		
		public function sendData(obj:Object):void
		{
			if ( group ) group.sendToAllNeighbors(obj);
		}
		
		/**
		 * Closes the connection 
		 * 
		 */		
		public function close():void
		{
			isConnected = false;
			netConnection.close();
		}
		
		/**
		 * Clears the connection and all internal listeners 
		 * 
		 */		
		public function clear():void
		{
			if(netConnection)
			{
				close();
				netConnection.removeEventListener(NetStatusEvent.NET_STATUS, handleStatus);
				netConnection = null;
			}
			
			if(group)
			{
				group.close();
				group.removeEventListener(NetStatusEvent.NET_STATUS, handleStatus);
				group = null;
			}
			
			onDataReceive = null;
			onConnect = null;
		}
		
		private function setUpGroup():void
		{
			var groupSpec:GroupSpecifier = new GroupSpecifier("Onyx-VJ-60000");
			groupSpec.routingEnabled = true;
			groupSpec.ipMulticastMemberUpdatesEnabled = true;
			groupSpec.addIPMulticastAddress("224.255.0.0:60000");
			groupSpec.multicastEnabled = true;
			
			group = new NetGroup(netConnection, groupSpec.groupspecWithAuthorizations());
			group.addEventListener(NetStatusEvent.NET_STATUS, handleStatus);
		}
		public function memberCount():String
		{
			return group == null ? "no group" : group.estimatedMemberCount.toString();
		}
		public function groupInfo():String
		{
			return group == null ? "no group" : group.info.toString();
		}
		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}

		public function get isConnected():Boolean
		{
			return _isConnected;
		}
		
		public function set isConnected( value:Boolean ):void
		{
			_isConnected = value;
		}
	}
}