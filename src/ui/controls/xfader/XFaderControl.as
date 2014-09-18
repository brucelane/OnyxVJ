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
package ui.controls.xfader {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.assets.*;
	import ui.controls.*;


	/**
	 * 
	 */
	public final class XFaderControl extends UIControl {
		
		/**
		 * 	@private
		 */
		private const fader:AssetCrossFader		= new AssetCrossFader();
		
		/**
		 * 	@private
		 */
		private const button:ButtonClear		= new ButtonClear();
		
		/**
		 * 
		 */
		override public function initialize(param:Parameter, options:UIOptions = null):void {
			
			// super
			super.initialize(param);

			button.initialize(210, 22);

			addChild(fader);
			addChild(button);
			
			button.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			parameter.addEventListener(ParameterEvent.CHANGE, change);
		}
		
		/**
		 * 	@private
		 */
		private function change(event:ParameterEvent):void {
			fader.x				= Number(event.value) * 198;
		}
		
		/**
		 * 	@private
		 */
		private function downHandler(event:MouseEvent):void {
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			moveHandler(event);
		}
		
		/**
		 * 	@private
		 */
		private function moveHandler(event:MouseEvent):void {
			parameter.value = Math.min(Math.max((((button.mouseX >> 0) - 5) / 198), 0), 1);
		}
		
		/**
		 * 	@private
		 */
		private function upHandler(event:MouseEvent):void {
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			button.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			parameter.removeEventListener(ParameterEvent.CHANGE, change);
			
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			super.dispose();

		}
	}
}