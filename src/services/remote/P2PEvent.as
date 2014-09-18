package services.remote
{
	import flash.events.Event;
	
	public class P2PEvent extends Event
	{
		public static const DEFAULT_NAME:String = "com.onyx-vj.P2PEvent";
		
		// event constants
		public static const ON_RECEIVED:String = "onReceived";
		
		
		public var params:Object;
		
		public function P2PEvent(type:String, params:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.params = params;
		}
		
		public override function clone():Event
		{
			return new P2PEvent(type, this.params, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("P2PEvent", "params", "type", "bubbles", "cancelable");
		}
		
	}
}