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
	
	/**
	 * 	Stores a page inside a layer/display control (such as basic, filters, custom)
	 */
	public final class LayerPage {
		
		/**
		 * 
		 */
		public var name:String;

		/**
		 * 
		 */
		public var controls:Array;
		
		/**
		 * 	@constructor
		 */
		public function LayerPage(name:String, ... args:Array):void {
			this.name			= name,
			this.controls		= args || [];
		}
	}
}