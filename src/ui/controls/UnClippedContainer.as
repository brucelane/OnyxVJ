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
package ui.controls {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.plugin.*;
	
	import ui.assets.*;

	/**
	 * 
	 */
	public final class UnClippedContainer extends Sprite {
		
		/**
		 * 	Display
		 */
		public function display(object:DisplayObject, addObject:DisplayObject):void {

			var local:Point = object.localToGlobal(ONYX_POINT_IDENTITY);
			super.x			= Math.max(local.x, 0);
			super.y			= Math.max(local.y, 0);
			
			DISPLAY_STAGE.addChild(this);
			
			// add the item to this
			addChild(addObject);
		}
		
		/**
		 * 	Remove
		 */
		public function remove():void {
			
			// clear graphics
			graphics.clear();
			
			// remove everything
			if (super.parent) {
				DISPLAY_STAGE.removeChild(this);
			}
			
			while (super.numChildren) {
				super.removeChildAt(0);
			}
		}
		
	}
}