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
package ui.window {
	
	/**
	 * 
	 */
	public final class WindowStateReg {
		
		/**
		 * 	The name of the window to affect
		 */
		public var name:String;
		
		/**
		 * 	The x location of the window
		 */
		public var x:int;
		
		/**
		 * 	The y location of the window
		 */
		public var y:int;
		
		/**
		 * 	Whether the window shows up when the state is loaded
		 */
		public var enabled:Boolean;
		
		/**
		 * 	@constructor
		 */
		public function WindowStateReg(name:String, x:int, y:int, enabled:Boolean = true):void {

			this.name		= name,
			this.x			= x,
			this.y			= y,
			this.enabled	= enabled;
			
		}
	}
}