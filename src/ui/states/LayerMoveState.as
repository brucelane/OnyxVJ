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
package ui.states {
	
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.layer.UILayer;

	/**
	 * 	When a layer is clicked and dragged, this state allows the layer to be moved by dragging
	 */
	public final class LayerMoveState extends ApplicationState {

		/**
		 * 	@private
		 */		
		private var _origin:UILayer;
		
		/**
		 * 	@constructor
		 */
		public function LayerMoveState(origin:UILayer):void {
			_origin = origin;
		}
		
		/**
		 * 
		 */
		override public function initialize():void {

			// listen for rollover events for all layers except the one that originated the layer
			for each (var layer:UILayer in UILayer.layers) {
				if (layer !== _origin) {
					layer.addEventListener(MouseEvent.MOUSE_OVER, _onLayerOver);
				}
			}

			// listen for mouse up
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
		}
		
		/**
		 * 	@private
		 * 	When mouse is hovered over another layer
		 */
		private function _onLayerOver(event:MouseEvent):void {
			var layer:UILayer = event.currentTarget as UILayer;
			_origin.moveLayer(layer.index);

			// if control key is down, swap the blendModes			
			if (event.shiftKey) {
				var originBlend:String	= _origin.blendMode;
				var newBlend:String		= layer.blendMode;
				
				var originControl:Parameter = _origin.layer.getProperties().getParameter('blendMode');
				var newControl:Parameter = layer.layer.getProperties().getParameter('blendMode');
				
				originControl.value = newBlend;
				newControl.value = originBlend;
			}
		}
		
		/**
		 * 	@private
		 */
		private function _mouseUp(event:MouseEvent):void {
			StateManager.removeState(this);
		}

		/**
		 * 	Terminates state
		 */
		override public function terminate():void {
			if (_origin) {
				DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			}

			for each (var layer:UILayer in UILayer.layers) {
				layer.removeEventListener(MouseEvent.MOUSE_OVER, _onLayerOver);
			}
			
			_origin = null;
		}
	}
}