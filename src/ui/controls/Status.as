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
	

	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	
	import ui.text.TextFieldCenter;
	
	/**
	 * 	Slider
	 */
	public class Status extends UIControl {
		
		/**
		 * 	@private
		 */
		protected const field:TextFieldCenter	= Factory.getNewInstance(TextFieldCenter);
		
		/**
		 * 
		 */
		override public function initialize(input:Parameter, options:UIOptions = null):void {
			
			// set defaults
			field.width		= options.width + 3;
			field.height	= options.height;
			field.x			= 0;
			field.y			= 2;
			
			// save input
			parameter	= input as ParameterStatus;

			// set label, etc
			super.initialize(input, options);
			
			// listen for changes
			parameter.addEventListener(ParameterEvent.CHANGE, _onControlChange);
			
			// add field
			addChild(field);
			
		}
		
		/**
		 * 	@private
		 */
		protected function _onControlChange(event:ParameterEvent = null):void {
			field.text = String(event.value);
		}
		
		/**
		 * 
		 */
		override public function reflect():Class {
			return Status;
		}
		
		/**
		 * 	@method		cleans up references
		 */
		override public function dispose():void {
			
			// remove listeners
			parameter.removeEventListener(ParameterEvent.CHANGE, _onControlChange);

			// remove display objects
			removeChild(field);
			
			// dispose
			super.dispose();
		}
	}
}