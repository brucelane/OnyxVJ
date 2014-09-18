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
package ui.layer {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.events.FilterEvent;
	import onyx.plugin.*;
	
	import ui.controls.filter.*;
	import ui.controls.page.*;
	import ui.core.UIObject;
	import ui.window.*;

	/**
	 * 
	 */
	public class UIFilterControl extends UIObject {
		
		/**
		 * 	@private
		 */
		private var _target:IFilterObject;
		
		/**
		 * 
		 */
		protected var selectedPage:int						= -1;

		/**
		 * 
		 */
		protected const filterPane:FilterPane				= new FilterPane();
		
		/**	
		 * 	@private
		 */
		protected const controlPage:ParameterPage			= new ParameterPage();
		
		/**
		 *  @private
		 */
		protected const controlTabs:ParameterPageSelected	= new ParameterPageSelected();
		
		/**
		 * 	@private
		 */
		protected const tabContainer:Sprite					= new Sprite();
		
		/**
		 * 
		 */
		protected var pages:Array;
		
		/**
		 * 	@constructor
		 */
		public function UIFilterControl(target:IFilterObject, ... pages:Array):void {

			// move to top
			this.setMovesToTop(true);
			
			this.pages = pages || [];
			
			// listen for events
			_target = target;
			_target.addEventListener(FilterEvent.FILTER_ADDED, _onFilterApplied);
			_target.addEventListener(FilterEvent.FILTER_REMOVED, _onFilterRemoved);
			_target.addEventListener(FilterEvent.FILTER_MOVED, _onFilterMove);
			_target.addEventListener(FilterEvent.FILTER_MUTED, _onFilterMute);
			
			// set location
			tabContainer.mouseChildren	= true;
			tabContainer.mouseEnabled	= false;
			
			// add filter objects
			addChild(filterPane);
			addChild(controlPage);
			tabContainer.addChild(controlTabs);
			
			// create buttons for pages
			_registerPages();
			
			// select page
			selectPage(0);
			
			// register this as a drop target for filters
			Filters.registerTarget(this, true);
		}
		
		/**
		 * 	Returns the currently selected filter
		 */
		public function get selectedFilter():LayerFilter {
			return filterPane.selectedFilter;
		}
		
		/**
		 * 	Selects a page
		 */
		public function selectPage(index:int, controls:Array = null):void {
			
			var page:LayerPage = pages[index];
			
			if (controls) {
				page.controls = controls;
				controlPage.addControls(page.controls);
			}
			
			if (index !== selectedPage) {
				
				controlPage.addControls(page.controls);
				controlTabs.text	= page.name;
				controlTabs.x		= index * 45;
				
				selectedPage = index;
				
			}
		}
		

		/**
		 * 	Gets a page
		 */
		public function getPage(index:int):LayerPage {
			return pages[index];
		}
		
		/**
		 * 	Adds a page
		 */
		private function _registerPages():void {
			
			var len:int = pages.length;
			for (var count:int = 0; count < len; count++) {
				var page:LayerPage = pages[count];

				var button:ParameterPageButton = new ParameterPageButton(count);
				button.x		= (count * 45);

				tabContainer.addChild(button);
	
				button.addEventListener(MouseEvent.MOUSE_DOWN, _onPageSelect);
			}
		}

		/**
		 * 	@private
		 */
		private function _onPageSelect(event:MouseEvent):void {
			
			var target:ParameterPageButton = event.currentTarget as ParameterPageButton;
			
			// if it's the filter page
			if (target.index === 1) {
				
				var filter:LayerFilter = filterPane.getFilter(_target.filters[0]);
				
				if (filter && !filter.filter.muted) {
					filterPane.selectFilter(filter);
				}
			} else {
				
				filterPane.selectFilter(null);
				selectPage(target.index);
			}
		}
		
		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			_target.addFilter(filter);
		}
		
		/**
		 * 	Removes a filter
		 */
		public function removeFilter(filter:Filter):void {
			_target.removeFilter(filter);
		}
		
		/**
		 * 	@private
		 * 	Event when filter is added
		 */
		private function _onFilterApplied(event:FilterEvent):void {
			filterPane.register(event.filter);
		}
		
		/**
		 * 	@private
		 * 	Called when a filter is removed
		 */
		private function _onFilterRemoved(event:FilterEvent):void {
			filterPane.unregister(event.filter);
		}

		/**
		 * 	@private
		 * 	When a filter is moved
		 */		
		private function _onFilterMove(event:FilterEvent):void {
			filterPane.reorder();
		}

		/**
		 * 	@private
		 * 	When a filter is moved
		 */		
		private function _onFilterMute(event:FilterEvent):void {
			filterPane.mute(event.filter);
		}
		
		/**
		 * 	Returns the target
		 */
		public function get target():IFilterObject {
			return _target;
		}
		
		/**
		 * 	Selects a filter based on it's plugin
		 */
		final public function selectFilter(type:Plugin):void {
			
			var filters:Array = _target.filters;
			for each (var filter:Filter in filters) {
				if (filter.getRelatedPlugin() === type) {
					filterPane.selectFilter(filterPane.getFilter(filter), true);
					break;
				}
			}			
		}
		
		/**
		 * 	Selects a filter based on it's plugin
		 */
		final public function deleteFilter(type:Plugin):void {
			
			var filters:Array = _target.filters;
			for each (var filter:Filter in filters) {
				if (filter.getRelatedPlugin() === type) {
					removeFilter(filter);
					break;
				}
			}			
		}
		
		/**
		 * 	Disposes content
		 */
		override public function dispose():void {
			
			// tell the filters that we are unregistering
			Filters.registerTarget(this, false);
			
			// unlisten events
			_target.removeEventListener(FilterEvent.FILTER_ADDED, _onFilterApplied);
			_target.removeEventListener(FilterEvent.FILTER_REMOVED, _onFilterRemoved);
			_target.removeEventListener(FilterEvent.FILTER_MOVED, _onFilterMove);
			_target.removeEventListener(FilterEvent.FILTER_MUTED, _onFilterMute);
			
			// remove listeners
			while (tabContainer.numChildren) {
				var button:ParameterPageButton = tabContainer.removeChildAt(0) as ParameterPageButton;
				if (button) {
					button.removeEventListener(MouseEvent.MOUSE_DOWN, _onPageSelect);
				}
			}
			
			// dispose
			super.dispose();
		}
	}
}