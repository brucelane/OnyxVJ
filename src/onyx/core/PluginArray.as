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
	
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	/**
	 * 
	 */
	dynamic public final class PluginArray extends Array {
		
		/**
		 * 	@private
		 * 	Stores plugins by name
		 */
		onyx_ns const nameLookup:Object = {};
		
		/**
		 * 	Constructor
		 */
		public function PluginArray(... args:Array):void {
			
			for each (var plugin:Plugin in args) {
				this.register(plugin);
			}
		}
		
		/**
		 * 	@internal
		 * 	Registers a plugin
		 */
		onyx_ns function register(plugin:Plugin):void {
			nameLookup[plugin.name] = plugin;
			push(plugin);
		}
	}
}