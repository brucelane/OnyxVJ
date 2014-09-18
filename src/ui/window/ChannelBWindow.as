package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.events.*;
	import onyx.plugin.*;
	
	import ui.controls.TextButton;
	import ui.controls.UIOptions;
	import ui.core.DragManager;
	
	public final class ChannelBWindow extends Window {
		
		/**
		 * 	@private
		 */
		private const channelB:Bitmap	= new Bitmap(Display.channelB, PixelSnapping.ALWAYS, true);
		
		/**
		 * 	Constructor
		 */
		public function ChannelBWindow(reg:WindowRegistration):void {
			
			super(reg, true, 240, 215);
			
			channelB.x		= 5;
			channelB.y		= 17;
			channelB.width	= 230;
			channelB.height	= 192;
			addChild(channelB);
			
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