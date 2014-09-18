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
	
	import flash.display.DisplayObject;
	
	import onyx.plugin.*;
	import onyx.parameter.*;
	import onyx.events.*;
	
	import ui.assets.AssetLayerRegPoint;
	import ui.controls.UIControl;

	public final class LayerRegPoint extends UIControl {
		
		/**
		 * 	@private
		 */
		private static const OFFSET_X:int	= -4;

		/**
		 * 	@private
		 */
		private static const OFFSET_Y:int	= -4;
		
		/**
		 * 	
		 */
		private static const SCALE:Number	= 192 / DISPLAY_WIDTH;
		
		/**
		 * 
		 */
		public var controlX:ParameterNumber;
		
		/**
		 * 
		 */
		public var controlY:ParameterNumber;
		
		/**
		 * 	@constructor
		 */
		public function LayerRegPoint(control:ParameterProxy, mask:DisplayObject):void {
			//super(null, control);
			
			addChild(new AssetLayerRegPoint());
			
			// store controls
			controlX = control.controlX as ParameterNumber,
			controlY = control.controlY as ParameterNumber;
			
			// add listeners
			controlX.addEventListener(ParameterEvent.CHANGE, _onControlXChange);
			controlY.addEventListener(ParameterEvent.CHANGE, _onControlYChange);
			
			this.mask = mask;
		}
		
		/**
		 * 	@private
		 */
		private function _onControlXChange(event:ParameterEvent):void {
			x = event.value * DISPLAY_WIDTH * SCALE + OFFSET_X;
		}
		
		/**
		 * 	@private
		 */
		private function _onControlYChange(event:ParameterEvent):void {
			y = event.value * DISPLAY_HEIGHT * SCALE + OFFSET_Y;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			super.dispose();
		}
	}
}