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
	
	import flash.events.MouseEvent;
	
	import onyx.parameter.*;
	import onyx.core.*;
	
	import ui.styles.*;
	import ui.text.TextFieldCenter;
	
	/**
	 * 
	 */
	public final class TextControl extends UIControl {
		
		/**
		 * 	@private
		 */
		private var field:TextFieldCenter;
		
		/**
		 * 	@constructor
		 */
		public function TextControl():void {
			this.setMovesToTop(true);
		}

		/**
		 * 
		 */		
		override public function initialize(control:Parameter, options:UIOptions = null):void {
			
			super.initialize(control, options);
		
			field			= Factory.getNewInstance(TextFieldCenter);
			field.x			= 0,
			field.y			= 0,
			field.width		= options.width + 3,
			field.height	= options.height,
			field.textColor	= 0x999999,
			field.text		= 'CLICK TO EDIT';
				
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			// add
			addChild(field); 
		}

		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			
			var popup:TextControlPopUp	= new TextControlPopUp(this, null, 60, 16, parameter.value, parameter);
			event.stopPropagation();
		}
		
		/**
		 * 
		 */
		override public function reflect():Class {
			return TextControl;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			// remove listener
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			// remove the control
			parameter	= null;
			
			// dispose
			super.dispose();
		}
	}
}