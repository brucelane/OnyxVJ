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
package onyx.utils.bitmap {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import onyx.plugin.DISPLAY_HEIGHT;
	import onyx.plugin.DISPLAY_RECT;
	import onyx.plugin.DISPLAY_WIDTH;
	import onyx.plugin.ONYX_POINT_IDENTITY;
	
	public final class Distortion {
		
		private static const BUFFER:BitmapData		= new BitmapData(DISPLAY_WIDTH,DISPLAY_HEIGHT,true,0);
		private static const SHAPE:Shape			= new Shape();
		private static const DISTORT:DistortImage	= new DistortImage(DISPLAY_WIDTH,DISPLAY_HEIGHT,3,3);
		
		public static function render(source:BitmapData, distortion:Distortion, matrix:Matrix = null, transform:ColorTransform = null, blendMode:String = null):void {
			BUFFER.copyPixels(source, source.rect, ONYX_POINT_IDENTITY);
			DISTORT.setTransform(SHAPE.graphics, BUFFER, distortion.topLeft, distortion.topRight, distortion.bottomRight, distortion.bottomLeft)
			source.fillRect(DISPLAY_RECT, 0);
			source.draw(SHAPE, matrix, transform, blendMode, null, true);
		}
		
		public var topLeft:Point;
		public var topRight:Point;
		public var bottomLeft:Point;
		public var bottomRight:Point;
		
		public function Distortion(topLeft:Point = null, topRight:Point = null, bottomLeft:Point = null, bottomRight:Point = null):void {
			this.topLeft		= topLeft || new Point(0,0);
			this.topRight		= topRight || new Point(DISPLAY_WIDTH, 0);
			this.bottomLeft		= bottomLeft || new Point(0, DISPLAY_HEIGHT);
			this.bottomRight 	= bottomRight || new Point(DISPLAY_WIDTH, DISPLAY_HEIGHT);
		}
		
		public function isIdentity():Boolean {
			return (topLeft.y != 0 && topRight.y != 0 && topLeft.x != 0 && bottomLeft.x != 0 && bottomRight.x != DISPLAY_WIDTH && topRight.x != DISPLAY_WIDTH && bottomLeft.y != DISPLAY_HEIGHT && bottomRight.y != DISPLAY_HEIGHT);
		}
		
		public function toString():String {
			return topLeft.toString() + ':' + topRight.toString() + ':' + bottomLeft.toString() + ':' + bottomRight.toString(); 
		}
	}
}