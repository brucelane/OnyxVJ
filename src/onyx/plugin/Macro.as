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
	
	import onyx.core.*;
	
	use namespace onyx_ns;

	/**
	 * 
	 */
	public class Macro extends PluginBase {

		/**
		 * 
		 */
		public var repeatable:Boolean			= false;
		
		/**
		 * 
		 */
		public function keyUp():void {
			
		}
		
		/**
		 * 
		 */
		public function keyDown():void {
			
		}
		
		/**
		 * 
		 */
		final override public function toString():String {
			return 'onyx-macro://' + _plugin.name;
		}
	}
}