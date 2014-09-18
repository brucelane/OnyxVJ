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
package onyx.display {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	

	import onyx.parameter.*;
	import onyx.core.*;
	import onyx.display.*;
	
	[Event(name="filter_added",		type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
	
	public final class ContentSprite extends ContentBase {
		
		/**
		 * 	@private
		 * 	Stores the loader object where the content was loaded into
		 */
		private var loader:Loader;

		/**
		 * 	@constructor
		 */		
		public function ContentSprite(layer:LayerImplementor, path:String, loader:Loader):void {
			
			this.loader = loader;
			
			// pass parameters
			super(layer, path, loader.content, loader.contentLoaderInfo.width, loader.contentLoaderInfo.height);
			
		}
		
		/**
		 * 	Destroys the content
		 */
		override public function dispose():void {
			
			// dispose
			super.dispose();
			
			// destroy content
			loader.unload();
			loader	= null;
			
		}
	}
}