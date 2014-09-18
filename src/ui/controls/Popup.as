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
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import ui.assets.AssetWindow;
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.TextFieldOnyx;

	/**
	 * 	Popup class
	 */
	public final class Popup extends UIObject {
		
		/**
		 * 	@private
		 */
		private var _text:TextFieldOnyx;
		
		/**
		 * 	@constructor
		 */
		public function Popup(width:int, height:int, text:String):void {

			// add the background
			var asset:AssetWindow = new AssetWindow(width, height);
			asset.draw('');
			addChild(asset);

			// add the textfield
			_text			= Factory.getNewInstance(ui.text.TextFieldOnyx);
			_text.width		= width;
			_text.height	= height;
			_text.y			= 14,
			_text.multiline	= true,
			_text.wordWrap	= true,
			_text.text		= text;
			
			// add it
			addChild(_text);
		}	
		
		public function addToStage(add:Boolean = true):void {
			// add or remove from stage?
			(add) ? DISPLAY_STAGE.addChild(this) : DISPLAY_STAGE.removeChild(this);
			
			x = (DISPLAY_STAGE.stageWidth >> 1) - (this.width >> 1);
			y = (DISPLAY_STAGE.stageHeight >> 1) - (this.height >> 1);
		}
	}
}