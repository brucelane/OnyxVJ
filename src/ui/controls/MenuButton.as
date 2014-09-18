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
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	
	import ui.assets.AssetBitmap;
	import ui.styles.*;
	import ui.text.*;
	import ui.window.*;
	
	/**
	 * 	Text Button
	 */
	public final class MenuButton extends Sprite {
		
		/**
		 * 	@private
		 */
		private var background:Bitmap;

		/**
		 * 	@private
		 */
		private var reg:WindowRegistration;
		
		/**
		 * 	@constsructor
		 */
		final public function MenuButton(reg:WindowRegistration, options:UIOptions, textColor:uint = TEXT_LABEL):void {
			
			const options:UIOptions		= options || UI_OPTIONS;
			const width:int				= options.width;
			const height:int			= options.height;
			const label:TextFieldCenter	= Factory.getNewInstance(TextFieldCenter);

			label.width		= width + 3;
			label.height	= height;
			label.x			= 0;
			label.y			= ((height / 2) - 4) >> 0;
			
			label.text					= reg.name.toUpperCase(),
			label.textColor				= textColor,
			label.mouseEnabled			= false;

			// add a button
			const clear:ButtonClear		= new ButtonClear();
			clear.initialize(width, height);

			addChild(label);
			addChild(clear);
			
			// add background
			addChildAt(background = new AssetBitmap(width, height), 0);
			
			// save registration and set enabled / disabled
			this.reg		= reg;
			this.enabled	= reg.enabled;
			
			// add listener
			addEventListener(MouseEvent.MOUSE_DOWN, _onClick);
		}
		
		/**
		 * 	Sets enabled
		 */
		public function set enabled(value:Boolean):void {
			background.transform.colorTransform = (value) ? LAYER_HIGHLIGHT : DEFAULT;
		}
		
		/**
		 * 	@private
		 */
		private function _onClick(event:MouseEvent):void {
			this.enabled = reg.enabled = !reg.enabled;
		}
	}
}