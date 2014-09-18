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
	 * 	Similar to a ControlNumber Control, however, this control will display as 1.00x instead of just 1
	 */	
	public final class ParameterFrameRate extends ParameterNumber {
		
		/**
		 * 	@constructor
		 */
		public function ParameterFrameRate(name:String, display:String):void {
			
			super(name, display, -20, 20, 1, 10, 6);

		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterFrameRate;
		}
	}
}