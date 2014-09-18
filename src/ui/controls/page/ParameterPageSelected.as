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
	
	import flash.display.Sprite;
	
	import onyx.core.*;
	
	import ui.assets.AssetLayerTab;
	import ui.styles.*;
	import ui.text.TextFieldCenter;

	public final class ParameterPageSelected extends Sprite {
		
		/**
		 * 	Store the tab
		 */
		private var background:AssetLayerTab	= new AssetLayerTab();

		/**
		 * 	@private
		 */
		private var _label:TextFieldCenter;
		
		/**
		 * 	@constructor
		 */
		public function ParameterPageSelected():void {
			
			
			// add a label
			_label = Factory.getNewInstance(TextFieldCenter);
			_label.width	= 45,
			_label.height	= 10,
			_label.x		= 0,
			_label.y		= 2;
			
			mouseEnabled	= false;
			mouseChildren	= false;

			addChild(background);
			addChild(_label);
			
		}
		
		/**
		 * 	Set the display value
		 */
		public function set text(value:String):void {
			_label.text = value;
		}

	}
}