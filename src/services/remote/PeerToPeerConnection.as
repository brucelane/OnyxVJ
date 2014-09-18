package services.remote
{
	import flash.events.*;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	public class PeerToPeerConnection implements IEventDispatcher
	{
		private var dispatcher:EventDispatcher;
		private static var netConnection:NetConnection;
		private static var _ipAddresses:String = "";
		private static var _isConnected:Boolean = false;
		private var group:NetGroup;	
		
		/**
		 * Method that should be executed when data is recieved (should have one argument to hold the object returned from the NetStatusEvent : event.info.message)
		 */		
		public var onDataReceive:Function;
		/**
		 * Method that should be executed once the connection is established (should have one argument to hold the object returned from the NetStatusEvent : event.info.message)
		 */		
		public var onConnect:Function;
		
		private static var cnxInstance:PeerToPeerConnection;
		private static var numLayers:int = 0;
		
		public static function getInstance():PeerToPeerConnection
		{
			if (cnxInstance == null)
			{
				cnxInstance = new PeerToPeerConnection();
				cnxInstance.onConnect = handleConnectToService;
				cnxInstance.onDataReceive = handleGetObject;
			}
			
			return cnxInstance;
		}	
		public function PeerToPeerConnection()
		{
			dispatcher = new EventDispatcher(this);
		}
		protected static function handleConnectToService(user:Object):void
		{
			trace("handleConnectToService");
			cnxInstance.sendData({type:"peername", value:"Onyx-VJ-"+ ipAddresses });			
		}
		protected static function handleGetObject(dataReceived:Object):void
		{
			//Console.output("handleGetObject, dataReceived from " + _clientName + " type: " + dataReceived.type.toString());
			// received
			switch ( dataReceived.type.toString() ) 
			{ 
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
					trace("handleGetObject, dataReceived sending");
					PeerToPeerConnection.getInstance().dispatchEvent( new P2PEvent(P2PEvent.ON_RECEIVED, dataReceived) );
					
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
					trace("NetConnection.Connect.Success, setUpGroup" );
					setUpGroup();
					break;
				
				case "NetGroup.Connect.Success":
					trace("NetGroup.Connect.Success" );
					isConnected = true;
					if(onConnect != null)
						onConnect.apply(null, [event.info.message]);
					break;
				
				case "NetGroup.SendTo.Notify":
					if(onDataReceive != null)
						onDataReceive.apply(null, [event.info.message]);
					break;
				case "NetConnection.Call.Failed":
					trace("NetConnection.Call.Failed");
					break;
				default: 
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
		
		public static function get isConnected():Boolean
		{
			return _isConnected;
		}
		
		public static function set isConnected( value:Boolean ):void
		{
			_isConnected = value;
		}
		
		public static function get ipAddresses():String
		{
			return _ipAddresses;
		}
		
		public static function set ipAddresses(value:String):void
		{
			_ipAddresses = value;
		}
		
	}
}