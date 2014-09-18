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
package ui.controls.filter {

	import flash.display.*;
	import flash.filters.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import ui.controls.ButtonClear;
	import ui.core.UIObject;
	import ui.text.TextFieldOnyx;
	
	/**
	 * 
	 */
	public final class LibraryFilter extends UIObject {
		
		/**
		 * 	@private
		 */
		private static const DROP_SHADOW:Array	= [new DropShadowFilter(1, 45, 0x000000,1,0,0,1)];
		
		/**
		 * 	@private
		 * 	Associated Plugin
		 */
		private var _plugin:Plugin;
		
		/**
		 * 	@private
		 */
		private const label:TextFieldOnyx = Factory.getNewInstance(ui.text.TextFieldOnyx)

		/**
		 * 	@private
		 */
		private const btn:ButtonClear = new ButtonClear();
		
		/**
		 * 	@constructor
		 */
		public function LibraryFilter(plugin:Plugin):void {
			
			_plugin = plugin;

			const bmp:Bitmap	= new Bitmap(_plugin.thumbnail);
			bmp.x = bmp.y	= 1;
			
			// draw shit
			addChild(bmp);
			
			label.width				= 41,
			label.height			= 31,
			label.wordWrap			= true,
			label.text				= _plugin.name,
			label.y					= 2,
			label.x					= 2,
			label.filters			= DROP_SHADOW;
			
			btn.initialize(42,32);
			btn.doubleClickEnabled	= true;
			
			addChild(label);
			addChild(btn);
			
			const graphics:Graphics = this.graphics;
			graphics.beginFill(0x45525c);
			graphics.drawRect(0,0,42,32);
			graphics.endFill();

		}
		
		/**
		 * 	Returns the plugin
		 */
		public function get filter():Plugin {
			return _plugin;
		}
	}
}