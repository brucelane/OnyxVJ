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
	 * 	This control is a pointer to child controls -- it is used to display multiple values in a control (such as x/y, or scaleX/scaleY)
	 */
	public final class ParameterProxy extends Parameter {
		
		/**
		 * 	ControlY
		 */
		public var controlY:ParameterNumber;
		
		/**
		 * 	ControlX
		 */
		public var controlX:ParameterNumber;
		
		/**
		 * 	
		 */
		public var invert:Boolean;
		
		/**
		 * 	@constructor
		 */
		public function ParameterProxy(property:String, displayName:String, controlX:ParameterNumber, controlY:ParameterNumber, invert:Boolean = false):void {
			
			this.controlY	= controlY,
			this.controlX	= controlX,
			this.invert		= invert;
			
			super(property, displayName, null);
			
		}
		
		/**
		 * 
		 */
		override public function set target(value:IParameterObject):void {
			controlY.target = value;
			controlX.target = value;
		}
		
		/**
		 * 
		 */
		override public function dispatch(v:*):* {
			if (v is Array) {
				controlX.value = v[0];
				controlY.value = v[1];
			}
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			dispatch(v);
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			return [controlX.value, controlY.value];
		}
		
		/**
		 * 
		 */
		override public function toXML():XML {
			
			const valueY:* = controlY.value;
			const valueX:* = controlX.value;
			
			if (controlY.defaultValue != valueY || controlX.defaultValue != valueX) {
				var xml:XML = <{name}/>;
				xml.appendChild(controlX.toXML());
				xml.appendChild(controlY.toXML());
				return xml
			}
			return null;
		}
		
		/**
		 * 
		 */
		override public function loadXML(xml:XML):void {
			
			controlY.loadXML(xml.child(controlY.name)[0]);
			controlX.loadXML(xml.child(controlX.name)[0]);
			
		}
		
		/**
		 * 	@public
		 */
		override public function reset():void {
			controlY.reset();
			controlX.reset();
		}
		
		/**
		 * 
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			controlY.removeEventListener(type, listener, useCapture);
			controlX.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterProxy;
		}
	}
}