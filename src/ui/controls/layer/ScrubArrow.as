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
package ui.controls.layer
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import ui.assets.AssetLayerMarker;

	public final class ScrubArrow extends Sprite {
		
		/**
		 * 
		 */
		public function ScrubArrow():void {
			
			mouseEnabled = false;
			
			var sprite:DisplayObject = addChild(new AssetLayerMarker());
			sprite.x -= sprite.width >> 1;
			
			this.cacheAsBitmap = true;
		}
		
	}
}