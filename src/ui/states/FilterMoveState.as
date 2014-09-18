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
	import flash.utils.Dictionary;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import ui.controls.filter.LayerFilter;

	public final class FilterMoveState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var _origin:LayerFilter;

		/**
		 * 	@private
		 */
		private var _filters:Dictionary;
		
		/**
		 * 	@constructor
		 */
		public function FilterMoveState(origin:LayerFilter, filters:Dictionary):void {
			_origin = origin;
			_filters = filters;
			
			super('FilterMove');
		}
		
		override public function initialize():void {

			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);

			for each (var filter:LayerFilter in _filters) {
				if (filter !== _origin) {
					filter.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				}
			}
		}
		
		/**
		 * 	@private
		 */
		private function mouseOver(event:MouseEvent):void {
			var control:LayerFilter = event.currentTarget as LayerFilter;
			
			_origin.filter.moveFilter(control.filter.index);
		}
		
		/**
		 * 	@private
		 */
		private function _mouseUp(event:MouseEvent):void {
			StateManager.removeState(this);
		}
		
		/**
		 * 	Terminate
		 */
		override public function terminate():void {
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);

			for each (var filter:LayerFilter in _filters) {
				filter.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			}
			
			_origin = null;
			_filters = null;
		}
	}
}