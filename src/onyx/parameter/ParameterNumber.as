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
	 * 	Number Control that stores and constrains numeric values.
	 */
	public class ParameterNumber extends Parameter {
		
		/**
		 * 	@private
		 */
		private var _min:Number;

		/**
		 * 	@private
		 */
		private var _max:Number;
		
		/**
		 * 	Multiplier
		 * 	100 will make 0.1 appear as 10 in the ui
		 */
		public var multiplier:Number;
		
		/**
		 * 	The sensitivity of the mouse
		 */
		public var factor:Number;
		
		/**
		 * 	@constructor
		 */
		public function ParameterNumber(name:String, display:String, min:Number, max:Number, defaultvalue:Number, multiplier:Number = 100, factor:Number = 1):void {
			
			_min			= min,
			_max			= max,
			this.multiplier = multiplier,
			this.factor		= factor;
			
			super(name, display, defaultvalue);
		}

		/**
		 * 	Resets
		 */
		override public function reset():void {
			_target[name] = REUSABLE_EVENT.value = defaultValue;
			dispatchEvent(REUSABLE_EVENT);
		}
		
		/**
		 * 
		 */
		override public function dispatch(v:*):* {

			var value:Number = Math.min(Math.max(v, _min), _max);
			REUSABLE_EVENT.value = value;
			dispatchEvent(REUSABLE_EVENT);
			
			return value;
		}
		
		/**
		 * 	Returns min value
		 */
 		public function get min():* {
 			return _min;
 		}
 		
		/**
		 * 	Returns max value
		 */
 		public function get max():* {
 			return _max;
 		}
 		
 		/**
 		 * 
 		 */
 		override public function loadXML(xml:XML):void {
 			super.value	= Number(xml);
 		}
 		
 		/**
 		 * 
 		 */
 		override public function toXML():XML {
 			
 			var xml:XML			= <{name}/>;
 			var value:Number	= this.value;
			
			/* if(	name!='time' && 
				parent.hashMap[name]!=0 && 
				parent.hashMap[name]!=null) {
					
				xml.@midihash = parent.hashMap[name];
			} */

 			if (!isNaN(value)) {
 				xml.appendChild(value.toFixed(3));
 			}
 			
			return xml;
 		}
 		 				
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterNumber;
		}
	}
}