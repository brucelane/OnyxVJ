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

	import flash.events.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import ui.controls.*;
	import ui.layer.*;
	import ui.states.*;
	import ui.styles.*;

	/**
	 * 
	 */
	public final class FilterPane extends ScrollPane {
		
		/**
		 * 	The currently selected filter
		 */
		public var selectedFilter:LayerFilter;
		
		/**
		 * 	@private
		 */
		private const dict:Dictionary			= new Dictionary(true);
		
		/**
		 * 	@constructor
		 */
		public function FilterPane():void {
			super(100, 115);
		}
		
		/**
		 * 	Registers a filter for display
		 */
		public function register(filter:Filter):void {
			
			// create the control
			var control:LayerFilter = new LayerFilter(filter);
			
			// add control
			dict[filter] = control;
			
			// add it
			addChild(control);
		
			// reorder	
			reorder();
			
			// add the event handler
			control.addEventListener(MouseEvent.MOUSE_DOWN, _filterMouseHandler);
			
			if (!selectedFilter && filter.index === 0) {
				selectFilter(control);
			}
		}
		
		/**
		 * 	Unregisters a filter from display
		 */
		public function unregister(filter:Filter):void {
			
			var control:LayerFilter = dict[filter];

			if (control) {

				// remove and delete reference
				removeChild(control);
				delete dict[filter];

				// reorder
				reorder();

				// destroy
				control.dispose();

				// add the event handler
				control.removeEventListener(MouseEvent.MOUSE_DOWN, _filterMouseHandler);
				
				if (control === selectedFilter) {
					selectFilter(null);
				}
			}
		}
		
		/**
		 * 	Gets the control related to the filter
		 */
		public function getFilter(filter:Filter):LayerFilter {
			return dict[filter];
		}
		
		/**
		 * 	Reorders filters
		 */
		public function reorder():void {
			for each (var control:LayerFilter in dict) {
				control.y = control.filter.index * 18;
			}
		}

		/**
		 * 	Mutes a filter
		 */
		public function mute(filter:Filter):void {
			var layerFilter:LayerFilter = dict[filter];
			
			if (filter.muted && layerFilter == selectedFilter) {
				selectFilter(null);
			}
			
			layerFilter.muted = filter.muted;
			
		}

		/**
		 * 	@private
		 */
		private function _filterMouseHandler(event:MouseEvent):void {

			var filter:LayerFilter	= event.currentTarget as LayerFilter;
			var muted:Boolean		= filter.filter.muted;
			
			// alt mutes
			if (event.altKey) {
				
				filter.filter.muted = !muted;
			
			// ctrl selects all
			} else if (event.ctrlKey && !muted) {
				
				UILayer.selectFilterPlugin(filter.filter.getRelatedPlugin());
			
			} else {
				
				if (!muted) {
	
					selectFilter(filter);
					
					var state:FilterMoveState = new FilterMoveState(filter, dict);
					StateManager.loadState(state);

				}
			}
		}
		
		/**
		 * 	Selects a filter
		 */
		public function selectFilter(control:LayerFilter, forceSelection:Boolean = false):void {

			var uilayer:UIFilterControl = parent as UIFilterControl;
			
			if (selectedFilter) {
				selectedFilter.transform.colorTransform = DEFAULT;
				
				// unselect if it's selected
				if (control === selectedFilter && !forceSelection) {
					control = null;
				}
			}
			
			selectedFilter = control;
			
			if (control) {
				
				if (!control.filter.muted) {
					control.transform.colorTransform = FILTER_HIGHLIGHT;
				}
				uilayer.selectPage(1, control.filter.getParameters());
			
			// select nothing
			} else {
				
				uilayer.selectPage(0);
			}
		}
		
		/**
		 * 	Returns the control for a filter
		 */
		public function getControl(filter:Filter):LayerFilter {
			return dict[filter];
		}
	}
}