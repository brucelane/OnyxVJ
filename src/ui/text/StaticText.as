/**
 * Copyright (c) 2003-2011 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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
	
	import ui.styles.TEXT_DEFAULT;

	public final class StaticText extends flash.text.TextField 
	{
		/**
		 * 	@constructor
		 *  example: on GLOBAL TEMPO label
		 */
		public function StaticText():void 
		{
			
			super.autoSize			= TextFieldAutoSize.LEFT,
			super.selectable		= false,
			super.defaultTextFormat	= TEXT_DEFAULT,
			//super.defaultTextFormat	= new TextFormat('Pixel', 7, 0xe4eaef),
			super.gridFitType		= GridFitType.PIXEL,
			super.height			= 11,
			super.embedFonts		= true,
			super.antiAliasType		= AntiAliasType.NORMAL,
			super.textColor			= 0xb3c4d2,
			super.text				= text;
		}
	}
}