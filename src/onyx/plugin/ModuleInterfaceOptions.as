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
	
	import flash.display.*;
	
	/**
	 * 
	 */
	public final class ModuleInterfaceOptions extends Object {
		
		/**
		 * 	The user interface definition
		 */
		public var definition:Class;
		
		/**
		 * 	The default width of the window
		 */
		public var width:int;
		
		/**
		 * 	The default height of the window
		 */
		public var height:int;
		
		/**
		 * 	The default x location of the window
		 */
		public var x:int;
		
		/**
		 * 	The default y location of the window
		 */
		public var y:int;
		
		/**
		 * 	Whether the window should be draggable
		 */
		public var draggable:Boolean;
		
		/**
		 * 	@constructor
		 */
		public function ModuleInterfaceOptions(definition:Class, width:int, height:int, x:int = 0, y:int = 0, draggable:Boolean = true):void {
			
			this.definition	= definition,
			this.width		= width,
			this.height		= height,
			this.x			= x,
			this.y			= y,
			this.draggable	= draggable;
			
		}
	}
}