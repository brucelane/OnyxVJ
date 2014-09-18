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
package onyx.plugin {

	import flash.display.BitmapData;
	
	import onyx.core.PluginBase;
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;
	
	/**
	 * 	Base class for external files
	 */
	public final class Plugin {
		
		/**
		 * 	Stores the name for the plug-in
		 */
		public var name:String;
		
		/**
		 * 
		 */
		public var thumbnail:BitmapData;
		
		/**
		 * 	@private
		 * 	Class definition for the object
		 */
		onyx_ns var definition:Class;
		
		/**
		 * 	Stores the description for the plug-in (for use in UI)
		 */
		public var description:String;
		
		/**
		 * 	@private
		 * 	Store metadata about the plugin
		 */
		private const metadata:Object	= {};
		
		/**
		 * 	@constructor
		 */
		public function Plugin(id:String, definition:Class, description:String = null, thumbnail:BitmapData = null):void {

			this.name			= id,
			this.description	= description || '',
			this.thumbnail		= thumbnail,
			this.definition		= definition;
			
		}
		
		/**
		 * 	Returns a new object based on the plugin definition
		 */
		public function createNewInstance():PluginBase {
			
			const obj:PluginBase	= new definition();
			obj._plugin 			= this;
			
			return obj;
		}
		
		/**
		 * 	Registers metadata with the object
		 */
		public function registerData(name:String, value:*):void {
			metadata[name] = value;
		}
		
		/**
		 * 	Gets metadata for the object
		 */
		public function getData(name:String):* {
			return metadata[name];
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return '[Plugin: ' + name + ']';
		}

	}
}