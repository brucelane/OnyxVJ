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
	 * 	Control that executed a method on the target object
	 */
	public final class ParameterExecuteFunction extends Parameter {
		
		/**
		 * 	@constructor
		 */
		public function ParameterExecuteFunction(name:String, display:String = null):void {
			super(name, display, null);
		}
		
		/**
		 * 	Execute
		 */
		public function execute():void {
			const fn:Function = super._target[name];
			if (fn !== null) {
				fn.apply(super._target);
			}
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			return '';
		}
		
		/**
		 * 
		 */
		override public function reflect():Class {
			return ParameterExecuteFunction;
		}
		
	}
}