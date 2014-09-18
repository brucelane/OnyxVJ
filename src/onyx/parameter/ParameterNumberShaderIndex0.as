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
	
	import flash.display.*;
	
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;
	
	[ExcludeClass]
	
	/**
	 * 	Number Control that stores and constrains numeric values.
	 */
	public final class ParameterNumberShaderIndex0 extends ParameterNumber {
		
		/**
		 * 	@private
		 */
		private var param:ShaderParameter;
		
		/**
		 * 	@constructor
		 */
		public function ParameterNumberShaderIndex0(param:ShaderParameter):void {
			
			// save
			this.param	= param;
			
			// param
			super(param.name, param.name, param.minValue[0], param.maxValue[0], param.defaultValue[0], 250 / (param.maxValue[0] - param.minValue[0]));
			
		}

		/**
		 */
		override public function reset():void {

			var oldValue:Array	= param.value;
			param.value = [dispatch(param.defaultValue[1]), oldValue[1]];
			
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			var oldValue:Array	= param.value;
			param.value = [dispatch(v), oldValue[1]];
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			return param.value[0];
		}
		
 		/**
 		 * 
 		 */
 		override public function loadXML(xml:XML):void {
 			value = Number(xml);
 		}
 			
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterNumber;
		}
	}
}