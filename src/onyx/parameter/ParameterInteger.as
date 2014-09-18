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
	 * 	Number Control that stores and constrains integer values.
	 */
	public final class ParameterInteger extends ParameterNumber {
		
		private var _min:int;
		private var _max:int;
		
		/**
		 * 	@constructor
		 */
		public function ParameterInteger(	property:String,
									display:String,
									min:int,
									max:int,
									defaultvalue:int,
									multiplier:Number = 1,
									factor:Number = 1
		):void {
			
			_min = min,
			_max = max;
			
			super(property, display, min, max, defaultvalue, multiplier, factor);
			
		}
		
		/**
		 * 
		 */
		override public function dispatch(v:*):* {
			var value:int = Math.min(Math.max(v, _min), _max);
			REUSABLE_EVENT.value = value;
			dispatchEvent(REUSABLE_EVENT);
			
			return value;
		}
		
		
 		/**
 		 * 
 		 */
 		override public function loadXML(xml:XML):void {
 			super.value	= int(xml);
 		}
 		
 		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterInteger;
		}
		
 		/**
 		 * 
 		 */
 		override public function toXML():XML {
 			var xml:XML			= <{name}/>;
 			var value:int		= this.value;

 			if (!isNaN(value)) {
 				xml.appendChild(value);
 			}
 			
			return xml;
 		}
 		
	}
}