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
	
	import flash.display.BitmapData;
	
	public class UIOptions {
		
		public var background:Boolean;
		public var labelAlign:String;
		public var width:int;
		public var height:int;
		public var label:Boolean;
		
		/**
		 * 	@constructor
		 */
		public function UIOptions(background:Boolean = true, label:Boolean = true, labelAlign:String = null, width:int = 44, height:int = 12):void {
			this.background	= background,
			this.label		= label,
			this.labelAlign = labelAlign,
			this.width		= width,
			this.height		= height;
		}
	}
}