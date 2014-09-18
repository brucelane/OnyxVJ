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


	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;

	/**
	 * 	Stores values of true/false
	 */
	public final class ParameterBoolean extends ParameterArray {
		
		/**
		 * 	@private
		 */
		private static const BOOLEAN:Array = [false, true];
		
		/**
		 * 	@constructor
		 */
		public function ParameterBoolean(name:String, display:String, defaultvalue:uint = 0, binding:String = null):void {

			super(name, display, BOOLEAN, defaultvalue, binding);

		}
		
		/**
		 * 
		 */
		override public function loadXML(xml:XML):void {
			value = new Boolean(xml);
		}

		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterBoolean;
		}
	}
}