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
	import onyx.events.*;
	
	use namespace onyx_ns;

	/**
	 * 	Control that has a confined set of values.
	 */
	public class ParameterArray extends Parameter {
		
		/**
		 * 	@private
		 */
		protected var _data:Array;
		
		/**
		 * 	The property name to bind to when displaying
		 */
		public var binding:String;
		
		/**
		 * 	@constructor
		 */
		public function ParameterArray(name:String, display:String, data:Array, defaultValue:Object, binding:String = null):void {
			
			this.binding  		= binding,
			this._data			= data;
			
			// super
			super(name, display, defaultValue);
		}
		
		/**
		 * 
		 */
		override public function reset():void {
			_target[name] = dispatch(defaultValue);
		}

		/**
		 * 	Returns all data
		 */
		public function get data():Array {
			return _data;
		}
		
		/**
		 * 
		 */
		override public function loadXML(xml:XML):void {
			super.loadXML(xml);
		}
 		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterArray;
		}
	}
}