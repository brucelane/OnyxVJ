/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package ui.controls.layer {
	
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.assets.AssetRightArrow;

	public final class LoopEnd extends Sprite {
		
		private var _control:Parameter;
		
		public function initialize(control:Parameter):void {
			
			buttonMode = useHandCursor = cacheAsBitmap = true, _control = control;
			
			_control.addEventListener(ParameterEvent.CHANGE, _onChanged);

			addChild(new AssetRightArrow());
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMarkerDown);
		}
		
		/**
		 * 	@private
		 */
		private function _onChanged(event:ParameterEvent):void {
			x = event.value * 226 + 8;
		}

		/**
		 * 	@private
		 */
		private function _onMarkerDown(event:MouseEvent):void {
			
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onMarkerMove);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _onMarkerUp);
			
			_onMarkerMove(event);
		}

		/**
		 * 	@private
		 */
		private function _onMarkerMove(event:MouseEvent):void {
			_control.value = (parent.mouseX - 8) / 226;
		}

		/**
		 * 	@private
		 */
		private function _onMarkerUp(event:MouseEvent):void {
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onMarkerMove);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onMarkerUp);
		}

		/**
		 * 	Override set x so that we can draw a background on it
		 */
		override public function set x(value:Number):void {
			super.x = value;
			
			const graphics:Graphics = this.graphics;
			graphics.clear();
			graphics.beginFill(0x000000, .9);
			graphics.drawRect(0,0,242 - super.x,7);
			graphics.endFill();
		}

	}
}