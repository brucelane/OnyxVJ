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
package onyx.parameter {
	
	/**
	 * 	This control allows the user to change the color of an object with a color chooser.
	 */
	public class ParameterColor extends ParameterUINT {
		
		/**
		 * 	@constructor
		 */
		public function ParameterColor(property:String, display:String, defaultValue:uint = 0):void {
			super(property, display, defaultValue);
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterColor;
		}
		
		/**
		 * 	toXML
		 */
		override public function toXML():XML {
			var xml:XML = <{name}/>;
			xml.appendChild(value);
			
			return xml;
		}

	}
}