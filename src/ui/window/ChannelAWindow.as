package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.events.*;
	import onyx.plugin.*;
	
	import ui.controls.TextButton;
	import ui.controls.UIOptions;
	import ui.core.DragManager;
	
	public final class ChannelAWindow extends Window {
		
		/**
		 * 	@private
		 */
		private const channelA:Bitmap	= new Bitmap(Display.channelA, PixelSnapping.ALWAYS, true);
				
		/**
		 * 	Constructor
		 */
		public function ChannelAWindow(reg:WindowRegistration):void {
			
			super(reg, true, 240, 215);
			
			channelA.x		= 5;
			channelA.y		= 17;
			channelA.width	= 230;
			channelA.height	= 192;
			addChild(channelA);
			
			// make draggable
			DragManager.setDraggable(this);
			
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			//
			super.dispose();
		}
	}
}