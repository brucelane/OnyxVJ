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
	
	import flash.display.Loader;
	
	import onyx.core.*;
	
	final public class ContentRegistration {
		
		/**
		 * 	how many objects are looking at this loader?
		 */
		public var refCount:int;
		
		/**
		 * 
		 */
		public var loader:Loader;
	
		/**
		 * 	Dispose and kill the content
		 */
		public function dispose():void {
			loader.unload();
			loader	= null;
		}
	}
}