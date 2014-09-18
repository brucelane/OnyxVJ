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
package ui.window {
	

	import onyx.display.*;
	import onyx.events.DisplayEvent;
	import onyx.plugin.*;
	
	import ui.layer.UILayer;

	
	/**
	 * 	Layer Container - stores layer objects
	 */
	public final class LayerWindow extends Window {
		
		/**
		 * 	@constructor
		 */
		public function LayerWindow(reg:WindowRegistration):void {
			
			// position and create window
			super(reg, false, 0, 0);

			// listen and create layer controls
			Display.addEventListener(DisplayEvent.LAYER_CREATED, _onLayerCreate);
			
			// create already created layers
			for each (var layer:LayerImplementor in Display.layers) {
				_onLayerCreate(null, layer);
			}

		}
		
		/**
		 * 	@private
		 */
		private function _onLayerCreate(event:DisplayEvent = null, layer:LayerImplementor = null):void {
			
			var layer:LayerImplementor = (event) ? event.layer as LayerImplementor : layer;
			
			var uilayer:UILayer = new UILayer(layer);
			uilayer.position();

			addChildAt(uilayer, 0);
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {

			// listen and create layer controls
			Display.removeEventListener(DisplayEvent.LAYER_CREATED, _onLayerCreate);
			
			while (UILayer.layers.length) {
				var layer:UILayer = removeChildAt(0) as UILayer;
				layer.dispose();
			}
			
			super.dispose();
		}
	}
}