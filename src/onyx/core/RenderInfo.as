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
package onyx.core {
	
	import flash.display.*;
	import flash.geom.*;
	
	import onyx.plugin.*;
	
	public final class RenderInfo extends Object {
		
		public var currentFrame:int;
		public var matrix:Matrix;
		public var source:BitmapData;
		
		/**
		 * 	@constructor
		 */
		public function RenderInfo(source:BitmapData, matrix:Matrix):void {
			this.matrix			= matrix;
			this.source			= source;
		}
		
		/**
		 * 
		 *
		 */
		public function render(item:IBitmapDrawable):void {
			source.draw(item, matrix, null, null, null, true);
		}
		
		/**
		 * 
		 */
		public function copyPixels(data:BitmapData):void {
			source.copyPixels(data, DISPLAY_RECT, ONYX_POINT_IDENTITY);
		}
	}
}