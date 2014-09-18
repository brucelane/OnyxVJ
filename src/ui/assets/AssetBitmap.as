/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
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
	import flash.utils.*;
	
	/**
	 * 	Stores shape
	 */
	public final class AssetBitmap extends Bitmap {
		
		/**
		 * 	@private
		 */
		private static const _dict:Dictionary	= new Dictionary(true);
		
		/**
		 * 	@constructor
		 */
		public function AssetBitmap(width:int, height:int):void {

			var lookup:int			= width * 1000 + height;
			var data:BitmapData		= _dict[lookup];
			
			// check for bitmap cache
			if (!data) {
				data = new BitmapData(width, height, false, 0x45525c);
				
				var rect:Rectangle	= data.rect;
				rect.inflate(-1, -1);
				
				data.fillRect(rect, 0x0e0f0f);
				data.lock();
				
				_dict[lookup] = data;
			}
			
			super(data, PixelSnapping.ALWAYS, false);
		}
	}
}