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
	
	import flash.display.Sprite;
	
	import ui.styles.*;

	public final class ScrollBar extends Sprite {
	
		/**
		 * 	@constructor
		 */	
		public function ScrollBar():void {
			graphics.beginFill(SCROLLBAR_COLOR);
			graphics.drawRect(0,0,6,100);
			graphics.endFill();
		}
	}
}