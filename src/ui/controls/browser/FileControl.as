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
package ui.controls.browser {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	
	import ui.controls.*;
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.*;
	
	/**
	 * 	Thumbnail for file
	 */
	public final class FileControl extends UIObject {
		
		/**
		 * 	@private
		 */
		private static const DROP_SHADOW:Array			= [new DropShadowFilter(1, 45, 0x000000,1,0,0,1)];
		
		/**
		 * 	@private
		 */
		private static const DEFAULT_BITMAP:BitmapData	= new BitmapData(THUMB_WIDTH, THUMB_HEIGHT, true, 0);

		/**
		 * 	@private
		 */
		private const button:ButtonClear				= new ButtonClear();

		/**
		 * 	@private
		 */		
		public var asset:AssetFile;
		
		/**
		 * 	@constructor
		 */
		public function FileControl(asset:AssetFile, thumbnail:Bitmap):void {
			
			// store asset
			this.asset				= asset;
			
			// init
			init(thumbnail);
		}
		
		/**
		 * 	@private
		 */
		private function init(bmp:Bitmap):void {
			
			addChild(bmp);
				
			// set
			button.doubleClickEnabled	= true;
			button.initialize(THUMB_WIDTH, THUMB_HEIGHT);
			addChild(button);
			
			mouseEnabled				= false;
			mouseChildren				= true;
		}
		
		/**
		 * 	Destroys control
		 */
		override public function dispose():void {
			
			removeChild(button);
			
			super.dispose();
		}
	}
}