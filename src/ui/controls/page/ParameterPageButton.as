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
package ui.controls.page {
	
	import flash.display.SimpleButton;
	
	/**
	 * 	Page tab
	 */
	public final class ParameterPageButton extends SimpleButton {
		
		/**
		 * 	Stores index of the button
		 */
		public var index:int

		/**
		 * 	@constructor
		 */
		final public function ParameterPageButton(index:int):void {
			
			this.index		= index;
			hitTestState	= new HitState(34, 14);
			
		}
		
	}
}

import flash.display.Shape;
import flash.display.Graphics;

final class HitState extends Shape {
	
	final public function HitState(width:int, height:int):void {

		var graphics:Graphics = this.graphics;
		
		graphics.beginFill(0);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();

	}
}