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
package ui.assets {
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.TextFieldAutoSize;
	
	import onyx.core.*;
	
	import ui.text.*;
	

	/**
	 * 
	 */
	public final class AssetWindow extends Bitmap {

		/**
		 * 	@constructor
		 */
		public function AssetWindow(width:int, height:int):void {
			
			// super
			super(new BitmapData(width || 1, height || 1, true, 0), PixelSnapping.ALWAYS, false);
		}
		
		/**
		 * 
		 */
		public function draw(title:String):void {
			
			var bmp:BitmapData	= this.bitmapData;
			var n:BitmapData	= new AssetWindowTab().bitmapData;
			
			// create a rectangle for filling the border and inners 
			var rect:Rectangle	= new Rectangle(0, 14, width, height - 14);

			// fill border
			bmp.fillRect(rect, 0xFF6b7680);
			
			// contract 1 and fill
			rect.inflate(-1, -1);
			bmp.fillRect(rect, 0xFF2e3943);
			
			// remove corners
			bmp.setPixel32(width - 1, 14, 0);
			bmp.setPixel32(0, height - 1, 0);
			bmp.setPixel32(width - 1, height - 1, 0);
			
			// copy the tab
			bmp.copyPixels(n, n.rect, new Point(0, 0));
			
			if (title) {
				var text:TextFieldOnyx	= Factory.getNewInstance(TextFieldOnyx);
				text.autoSize		= TextFieldAutoSize.LEFT;
				text.height			= 14;
				text.text			= title;
				
				bmp.draw(text, new Matrix(1,0,0,1, (35 - (text.width / 2)) >> 0,2));
			}
			
			// lock the bitmap
			bmp.lock();
		}
	}
}