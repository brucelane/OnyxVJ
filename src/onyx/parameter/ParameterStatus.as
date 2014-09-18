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
	
	public final class ParameterStatus extends Parameter {

		/**
		 * 
		 */
		public function ParameterStatus(name:String, display:String):void {
			super(name, display, null);
		}

		override public function dispatch(v:*):* {
			return value;
		}

		override public function set value(v:*):void {
			REUSABLE_EVENT.value = v;
			super.dispatchEvent(REUSABLE_EVENT);
		}
 		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterStatus;
		}
		
 		/**
 		 * 
 		 */
 		override public function toXML():XML {
			return null;
 		}
				
	}
}