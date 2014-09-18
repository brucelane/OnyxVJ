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
	
	import onyx.events.*;
	
	/**
	 * 	Open-ended Text control
	 */
	public final class ParameterString extends Parameter {
		
		/**
		 * 	@constructor
		 */
		public function ParameterString(name:String, display:String, defaultValue:String = ''):void {
			
			super(name, display, defaultValue);
		}
		
		/**
		 * 	Loads the value from xml
		 */
		override public function loadXML(xml:XML):void {
			target[name] = xml.toString().split('\r\n').join('\n');
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterString;
		}
		
	}
}