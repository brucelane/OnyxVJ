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
	
	/**
	 * 	Clear Button
	 */
	public final class ButtonClear extends SimpleButton {
		
		/**
		 * 
		 */
		public function initialize(width:int, height:int, show:Boolean = true):void {
			
			// upState = new OverState(width, height);
			
			if (show) {
				overState = new OverState(width, height);
			}
			hitTestState = new HitState(width, height);
			
		}
	}
}

import flash.display.Shape;
import flash.display.Graphics;
import ui.styles.*;

/**
 * 	Hitstate
 */
final class HitState extends Shape {
	
	final public function HitState(width:int, height:int):void {

		const graphics:Graphics = this.graphics;
		
		graphics.beginFill(0);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
	}
}

/**
 * 	overstate
 */
final class OverState extends Shape {
	
	final public function OverState(width:int, height:int):void {

		const graphics:Graphics = this.graphics;
		
		graphics.beginFill(BUTTON_OVER, .2);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();

	}
}

/**
 * 	Downstate
 */
final class DownState extends Shape {
	
	final public function DownState(width:int, height:int):void {

		const graphics:Graphics	= this.graphics;
		graphics.beginFill(BUTTON_DOWN, .1);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
	}
}