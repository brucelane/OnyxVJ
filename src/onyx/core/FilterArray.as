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
package onyx.core {

	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.*;
	
	import onyx.display.*;
	import onyx.events.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	import onyx.utils.array.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Filter array
	 */
	dynamic public final class FilterArray extends Array implements IEventDispatcher {
		
		/**
		 * 	@private
		 */
		private static const REUSABLE_APPLY:FilterEvent		= new FilterEvent(FilterEvent.FILTER_ADDED, null);
		private static const REUSABLE_MOVE:FilterEvent		= new FilterEvent(FilterEvent.FILTER_MOVED, null);
		private static const REUSABLE_MUTED:FilterEvent		= new FilterEvent(FilterEvent.FILTER_MUTED, null);
		private static const REUSABLE_REMOVE:FilterEvent	= new FilterEvent(FilterEvent.FILTER_REMOVED, null);
		
		/**
		 * 	@private
		 */
		private var _parent:Content;
		
		/**
		 * 	@private
		 */
		private const dispatcher:EventDispatcher			= new EventDispatcher();
		
		/**
		 * 	@constructor
		 */
		public function FilterArray(parent:Content):void {
			_parent		= parent;
		}
		
		/**
		 * 	Add listener
		 */
		public function addEventListener(type:String, method:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, method, useCapture, priority, useWeakReference);
		}
		
		/**
		 * 
		 */
		public function removeEventListener(type:String, method:Function, useCapture:Boolean = false):void {
			dispatcher.removeEventListener(type, method, useCapture);
		}
		
		/**
		 * 
		 */
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
		
		/**
		 * 
		 */
		public function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		
		/**
		 * 
		 */
		public function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * 	Removes a filter
		 */
		public function addFilter(filter:Filter):void {

			// check for unique filters
			if (filter._unique) {
				
				const plugin:Plugin = PluginManager.getFilterDefinition(filter.name);
				
				for each (var otherFilter:Filter in this) {
					if (otherFilter is plugin.definition) {
						return;
					}
				}
			}
			
			// it's alive!
			filter.setContent(_parent);
			
			// push the layer into the array
			super.push(filter);
			
			// tell the filter it has started
			filter.initialize();

			// dispatch event
			REUSABLE_APPLY.filter = filter;
			dispatcher.dispatchEvent(REUSABLE_APPLY);
		}
		
		/**
		 * 	Moves a filter
		 */
		public function moveFilter(filter:Filter, index:int):void {
			if (swap(super, filter, index)) {
				REUSABLE_MOVE.filter = filter;
				dispatcher.dispatchEvent(REUSABLE_MOVE);
			}
		}
		
		/**
		 * 	Removes a filter
		 * 	@returns	true if the removed filter existed in the array
		 */
		public function removeFilter(filter:Filter):void {

			// now remove it
			const index:int = super.indexOf(filter);
			
			if (index >= 0) {
				
				// remove all tweens related to the filter
				// Tween.stopTweens(filter);

				// remove the filter
				splice(index, 1);

				// dispose the filter
				filter.dispose();
				
				// clean up our references
				filter.clean();
				
				// dispatch event
				REUSABLE_REMOVE.filter = filter;
				dispatcher.dispatchEvent(REUSABLE_REMOVE);
			}
		}
		
		/**
		 * 	Mutes a filter
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			filter._muted = toggle;

			// dispatch
			REUSABLE_MUTED.filter = filter;
			dispatcher.dispatchEvent(REUSABLE_MUTED);
		}
		
		/**
		 * 	Renders all filters to the source bitmap
		 */
		public function render(source:BitmapData):void {
			
			for each (var filter:Filter in this) {
				var bmp:IBitmapFilter = filter as IBitmapFilter;
				
				if (bmp && !filter._muted) {
					bmp.applyFilter(source);
				}
			}
		}
		
		/**
		 * 	Loads xml
		 */
		public function loadXML(xml:XMLList):void {
			
			for each (var filterXML:XML in xml.*) {
				
				var name:String			= filterXML.@id;
				var plugin:Plugin		= PluginManager.getFilterDefinition(name);
				
				if (plugin) {
					
					var filter:Filter	= plugin.createNewInstance() as Filter;
					filter._muted		= String(filterXML.@muted) === 'true';
					filter.getParameters().loadXML(filterXML.parameters);

					// add the filter					
					addFilter(filter);
				}
			}
		}
		
		/**
		 * 
		 */
		public function clear():void {
			while (super.length) {
				removeFilter(this[0] as Filter);
			}
		}
		
		/**
		 * 	Returns the filters in an xml format
		 */
		public function toXML():XML {
			const xml:XML = <filters />;
			
			for each (var filter:Filter in this) {
				xml.appendChild(filter.toXML());
			}
			
			return xml;
		}
	}
}