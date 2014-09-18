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
package services.midi {
	
	import onyx.parameter.ParameterNumber;
	
	internal final class NumericBehavior implements IMidiControlBehavior {
		
		/**
		 * 	@private
		 */
		public var control:ParameterNumber;
		
		/**
		 * 
		 */
		public function NumericBehavior(control:ParameterNumber):void {
			this.control = control;
		}
		
		/**
		 * 
		 */
		public function setValue(value:int):void {
			control.value = (control.max - control.min) * (value / 127) + control.min; 
		}
		
	}
}