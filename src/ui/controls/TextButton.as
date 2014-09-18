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
	
	import ui.core.UIObject;
	import ui.styles.*;
	
	/**
	 * 	Text Button
	 */
	public final class TextButton extends UIObject {
		
		//private var _label:String;
		
		/**
		 * 	@constsructor
		 */
		public function TextButton(options:UIOptions, name:String, textColor:uint = TEXT_LABEL):void {
			
			//_label = name;
			
			const options:UIOptions = options || UI_OPTIONS;
			const width:int	= options.width;
			const height:int	= options.height;

			// create a background color			
			displayBackground(width, height);
			
			// add a label
			addLabel(name.toUpperCase(), width, height, ((height / 2) - 4) >> 0, 0, null, 0xFFFFFF);

			const btn:ButtonClear	= new ButtonClear();
			btn.initialize(width, height);

			// add a button
			addChild(btn);
		}
		// BL 27/11/12
		public function label(text:String):void
		{
			addLabel(text.toUpperCase(), width, height, ((height / 2) - 4) >> 0, 0, null, 0xFFFFFF);
		}
		/*public function get label():String {
			return label;
		}
		
		public function set label(value:String):void {
			_label = value;
		}*/
	}
}