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
package ui.controls.filter {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.*;
	import ui.styles.*;
	import ui.text.TextFieldOnyx;

	/**
	 * 
	 */
	public final class LayerFilter extends UIObject {
		
		/**
		 * 	Stores the filter associated to the control
		 */
		public var filter:Filter;

		/**
		 * 	@private
		 */
		private const label:TextFieldOnyx			= Factory.getNewInstance(ui.text.TextFieldOnyx);

		/**
		 * 	@private
		 */
		private const btnDelete:ButtonClear		= new ButtonClear();

		/**
		 * 	@private
		 */
		private const bg:Bitmap					= new AssetLayerFilter();
		
		/**
		 * 	@constructor
		 */
		public function LayerFilter(filter:Filter):void {
			
			this.filter	= filter;
			
			draw();
			
			btnDelete.initialize(11, 11);
			btnDelete.addEventListener(MouseEvent.MOUSE_DOWN, deleteFn, false, -1);
			
			// TODO
			//this.addEventListener(MouseEvent.RIGHT_CLICK, mute);
			
			muted = filter.muted;
			addChildAt(bg, 0);

		}
		
		/**
		 * 	@private
		 */
		private function mute(event:MouseEvent):void {
			filter.muted = !filter.muted;
		}
		
		/**
		 * 
		 */
		public function set muted(value:Boolean):void {
			transform.colorTransform = value ? FILTER_DISABLED : DEFAULT;
		}
		
		/**
		 * 	@private
		 */
		private function deleteFn(event:MouseEvent):void {
			
			if (event.ctrlKey) {
				UILayer.deleteFilterPlugin(filter.getRelatedPlugin());
			} else {
				this.filter.removeFilter();
			}
		}
		
		/**
		 * 	@private
		 */
		private function draw():void {
			
			label.x				= 2,
			label.y				= 4,
			label.width			= 70,
			label.height		= 10,
			label.text			= filter.name,
			btnDelete.x 		= 85,
			btnDelete.y 		= 3;

			addChild(label);
			addChild(btnDelete);
		}
		
		/**
		 * 	Disposes
		 */
		override public function dispose():void {
			
			btnDelete.removeEventListener(MouseEvent.MOUSE_DOWN, deleteFn);
			//this.removeEventListener(MouseEvent.RIGHT_CLICK, mute);
			
			super.dispose();
		}
	}
}