package services.osc.events {
	
	import flash.events.Event;
	
	/**
	 * 	Midi event
	 */
	final public class OSCEvent extends Event {
		
		public static const DATA:String = 'osc_data';
		public static const BACK:String = 'osc_back';
		
		public var command:uint;
		public var channel:uint;
		public var data1:uint;
		public var data2:uint;
		
		public var OSChash:uint;
		
		/**
		 * 
		 */
		public function OSCEvent(type:String):void {
			super(type);
		}
		
		/**
		 * 
		 */
		override public function clone():Event {
			
			var event:OSCEvent = new OSCEvent(type);
			event.command		 = command;
			event.channel		 = channel;
			event.data1          = data1;
			event.data2			 = data2;
			
			event.OSChash       = OSChash;
			
			return event; 
		}
	}
}

