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
	import flash.events.*;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.layer.*;
	import ui.styles.*;

	/**
	 * 	The visibility control
	 */
	public final class LayerVisible extends UIControl {
		
		/**
		 * 
		 */
		public static const LAYER_VISIBLE:BitmapData	= new AssetEyeIcon();
		
		/**
		 * 
		 */
		private static const LAYER_DISABLED:BitmapData	= new AssetEyeIconDisabled();
		
		/**
		 * 	@private
		 */
		private var icon:Bitmap						= new Bitmap(LAYER_VISIBLE);
		
		/**
		 * 	@private
		 */
		private const button:ButtonClear			= new ButtonClear();
		
		/**
		 * 
		 */
		override public function initialize(parameter:Parameter, options:UIOptions = null):void {
			
			//
			super.initialize(parameter);
			
			parameter.addEventListener(ParameterEvent.CHANGE, _controlHandler);
			button.addEventListener(MouseEvent.MOUSE_DOWN, _mouseHandler);
			
			icon.x = 1;
			icon.y = 1;
			
			button.initialize(10, 10);
			
			addChild(icon);
			addChild(button);
		}
		
		/**
		 * 	@private
		 */
		private function _mouseHandler(event:Event):void {
			parameter.value = !parameter.value;
		}
		
		/**
		 * 	@private
		 */
		private function _controlHandler(event:ParameterEvent):void {
			
			icon.bitmapData = event.value ? LAYER_VISIBLE : LAYER_DISABLED;
			
		}
		
		/**
		 * 
		 */
		override public function reflect():Class {
			return LayerVisible;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			parameter.removeEventListener(ParameterEvent.CHANGE, _controlHandler);
			button.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseHandler);
			
			// dispose
			super.dispose();
		}
	}
}