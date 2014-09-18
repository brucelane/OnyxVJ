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
package ui.text {
	
	import flash.text.*;
	
	import onyx.core.*;
	
	import ui.styles.TEXT_DEFAULT;
	
	/**
	 * 	Default TextField -- This class exists because there is a Flash Player Bug with centered text and 
	 * 	anti-aliasing.  This class centers text based on the width of an auto-sized textfield
	 */
	public class TextFieldCenter extends flash.text.TextField implements IDisposable {
		
		/**
		 * 	@private
		 * 	The x value to snap to
		 */
		private var _x:int;
		
		/**
		 * 
		 */
		private var _width:int;
		
		/**
		 * 	@constructor
		 *  appear in white input textfields
		 */
		public function TextFieldCenter():void {
			
			super.selectable		= false,
			super.defaultTextFormat	= TEXT_DEFAULT,
			super.gridFitType		= GridFitType.PIXEL,
			super.antiAliasType		= AntiAliasType.NORMAL,
			super.autoSize			= TextFieldAutoSize.LEFT,
			super.embedFonts		= true,
			super.mouseEnabled		= false,
			super.mouseWheelEnabled	= false;
			//super.textColor			= 0x0000FF;
		}
		
		/**
		 * 
		 */
		override public function set width(value:Number):void {
			super.width = _width = value;
			
			// autocenter based on width / size of the textfield
			super.x = _x + (_width >> 1) - (super.width >> 1);
		}

		/**
		 * 
		 */		
		override public function set text(value:String):void {
			super.text = value;
			
			// autocenter based on width / size of the textfield
			// << 0 is for floor
			// >> 1 is division by 2
			super.x = _x + (_width >> 1) - (super.width >> 1);
		}
		
		/**
		 * 
		 */
		override public function set x(value:Number):void {
			
			_x = value;

			// autocenter based on width / size of the textfield
			super.x = _x + (_width >> 1) - (super.width >> 1);
		}
		
		/**
		 * 
		 */
		public function dispose():void {
			Factory.release(ui.text.TextFieldCenter, this);
		}
	}
}