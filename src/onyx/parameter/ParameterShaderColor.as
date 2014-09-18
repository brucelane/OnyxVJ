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
	public final class ParameterShaderColor extends ParameterColor {
		
		/**
		 * 	@private
		 */
		private var param:ShaderParameter;
		
		/**
		 * 	@constructor
		 */
		public function ParameterShaderColor(param:ShaderParameter):void {
			
			// get value
			this.param	= param;
			
			// param
			super(param.name, param.name);
			
		}

		/**
		 */
		override public function reset():void {
			param.value = [dispatch(param.defaultValue)];
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			
			var color:uint = v;
			var r:int, g:int, b:int;
			
			r = ((v & 0xFF0000) >> 16),
			g = ((v & 0x00FF00) >> 8),
			b = (v & 0x0000FF);
			
			param.value = [r / 255, g / 255, b / 255];
			
			dispatch(v);
			

		}
		
		/**
		 * 
		 */
		override public function get value():* {
			return param.value;
		}
		
 		/**
 		 * 
 		 */
 		override public function loadXML(xml:XML):void {
 			value = uint(xml);
 		}
 			
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterColor;
		}
	}
}