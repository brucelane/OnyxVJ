package services.remote
{
	import flash.events.Event;
	
	public class DLCEvent extends Event
	{
		public static const DEFAULT_NAME:String = "com.onyx-vj.DLCEvent";
		
		// event constants
		public static const ON_RECEIVED:String = "onReceived";
		
		
		public var params:Object;
		
		public function DLCEvent(type:String, params:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.params = params;
		}
		
		public override function clone():Event
		{
			return new DLCEvent(type, this.params, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("DLCEvent", "params", "type", "bubbles", "cancelable");
		}
		
	}
}