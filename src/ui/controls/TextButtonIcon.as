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
	
	import ui.core.UIObject;

	public final class TextButtonIcon extends UIObject {
		
		/**
		 * 	@constructor
		 */
		public function TextButtonIcon(options:UIOptions, name:String, icon:Bitmap):void {
			
			const width:int 	= options.width;
			const height:int	= options.height;
			
			// add a label
			addLabel(name.toUpperCase(), width + 3, height, 1, 14, 'left');

			// add a button
			const sprite:DisplayObject = addChild(icon);
			sprite.x = 3;
			sprite.y = 2;
			
			const btn:ButtonClear	= new ButtonClear();
			btn.initialize(width, height);
			
			addChild(btn);
		}
	}
}