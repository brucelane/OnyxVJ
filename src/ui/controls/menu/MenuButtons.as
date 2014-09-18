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
package ui.controls.menu {
	
	import flash.display.Sprite;
	
	import ui.controls.UIControl;
	import ui.controls.UIOptions;
	import ui.core.UIObject;

	public final class MenuButtons extends UIControl {
		
		/**
		 * 	@constructor
		 */
		public function MenuButtons():void {
			
			var options:UIOptions	= new UIOptions();
			options.background		= true;
			
			//super(options, true);   //
		}
		
	}
}