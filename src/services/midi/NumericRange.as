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
	
	import onyx.parameter.ParameterArray;
	
	internal final class NumericRange implements IMidiControlBehavior {
		
		/**
		 * 	@private
		 */
		public var control:ParameterArray;
		
		/**
		 * 
		 */
		public function NumericRange(control:ParameterArray):void {
			this.control = control;			
		}
		
		/**
		 * 
		 */
		public function setValue(value:int):void {
			var data:Array	= control.data;
			
			control.value = data[int((value / 127) * (data.length - 1))];
		}
	}
}