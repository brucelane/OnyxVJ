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
	
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	
	use namespace onyx_ns;

	/**
	 * 	parameters Array.  This class stores all possible user-defined parameters for a filter,
	 * 	transition, or other plugins.  Must be defined for any user-defined object.
	 */
	dynamic final public class Parameters extends Array implements IEventDispatcher {
		
		/**
		 * 	@private
		 */
		private static const GLOBAL_LOOKUP:Dictionary = new Dictionary(true); 
		
		/**
		 * 
		 */
		public static function getGlobalRegisteredParameters():Dictionary {
			return GLOBAL_LOOKUP;
		}
		
		/**
		 * 
		 */
		public static function getRegisteredParameter(id:String):Parameters {
			return GLOBAL_LOOKUP[id];
		}

		/**
		 * 	@private
		 */
		private const nameLookup:Object				= {};
		
		/**
		 * 	@private
		 */
		private const dispatcher:EventDispatcher	= new EventDispatcher();
		
		/**
		 * 	@private
		 */
		private var _target:IParameterObject;
		
		/**
		 * 	@private
		 */
		private var _id:String;
		
		/**
		 * 	@constructor
		 */
		public function Parameters(target:IParameterObject, ... params:Array):void {
			
			_target		= target;

			// add parameters
			addParameters.apply(this, params);
		}
		
		/**
		 * 	@public
		 * 	This register the parameters object to be visible to any other control
		 */
		final public function registerGlobal(id:String):void {
			GLOBAL_LOOKUP[id]	= this;
			this._id			= id;
		}
		
		/**
		 * 	
		 */
		final public function addEventListener(type:String, method:Function, useCapture:Boolean = false, priority:int = 0, weak:Boolean = false):void {
			dispatcher.addEventListener(type, method, useCapture, priority, weak);
		}
		
		/**
		 * 
		 */
		final public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 
		 */
		final public function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * 	Dispatch event
		 */
		final public function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		
		/**
		 * 
		 */
		final public function willTrigger(type:String):Boolean{
			return dispatcher.willTrigger(type);
		}
		
		/**
		 * 	Adds parameters, if the control does 
		 */
		final public function addParameters(... parameters:Array):void {
			
			// loop through and add them parameters
			for each (var param:Parameter in parameters) {
				
				// store the target
				if (!param._target) {
					param.target	= _target,
					param.parent	= this;
				}
								
				// store a name index
				nameLookup[param.name] = param;
				
				if (param is ParameterProxy) {
					var proxy:ParameterProxy = param as ParameterProxy;
					nameLookup[proxy.controlY.name] = proxy.controlY;
					nameLookup[proxy.controlX.name] = proxy.controlX;
				}
				super.push(param);
			}
		}
		
		/**
		 * 
		 */
		final public function setNewTarget(target:IParameterObject):void {
			_target = target;
			for each (var control:Parameter in this) {
				control.target = target;
			}
		}
		
		/**
		 * 
		 */
		final public function removeParameter(... parameters:Array):void {
			
			var changed:Boolean = false;
			
			// loop through and add them parameters
			for each (var control:Parameter in parameters) {
				
				// delete the name index
				delete nameLookup[control.name];
				
				// if it's a proxy, remove the child indexes as well
				if (control is ParameterProxy) {
					var proxy:ParameterProxy = control as ParameterProxy;
					delete nameLookup[proxy.controlY.name];
					delete nameLookup[proxy.controlX.name];
				}

				// remove from array
				var index:int = super.indexOf(control);
				if (index >= 0) {
					super.splice(index, 1);
					changed = true;
				}
			}
			
			if (changed) {

				// dispatch an update event
				dispatcher.dispatchEvent(new Event(Event.CHANGE));
				
			}
		}
		
		/**
		 * 	Returns a control by name
		 */
		final public function getParameter(name:String):Parameter {
			return nameLookup[name];
		}
		
		/**
		 * 
		 */
		final public function getTarget():IParameterObject {
			return _target;
		}
		
		/**
		 * 	Returns the control array as an xml object
		 * 	@param	An array of control names to exclude from the xml 
		 */
		public function toXML(nodeName:String = 'parameters', ... excludeparameters:Array):XML {
			
			var exclude:Array = excludeparameters || [];
			var xml:XML = <{nodeName}/>;
			
			for each (var control:Parameter in this) {
				
				// if it's not excluded
				if (exclude.indexOf(control.name) === -1 && (control.value != control.defaultValue) && !(control is ParameterExecuteFunction)) {
					var value:XML = control.toXML();
					if (value) {
						xml.appendChild(value);
					}
				}
				
			}
			
			return xml;
		}
		
		/**
		 * 	Loads from xml
		 */
		final public function loadXML(xml:XMLList):void {
			
			var name:String, control:Parameter;
			
			// loop through each control
			for each (var controlXML:XML in xml.*) {
				
				try {

					// check to see if it's complex content, if so, loop
					if (controlXML.hasComplexContent()) {
						
						for each (var childXML:XML in controlXML.*) {

							name		= childXML.name();
							control		= getParameter(name);
							
							control.loadXML(childXML);

						}
						
					} else {
						
						name			= controlXML.name();
						control			= getParameter(name);

						control.loadXML(controlXML);

					}
				} catch (e:Error) {

					Console.error(e);
			
				}
			}
		}
		
		/**
		 * 
		 */
		final public function get id():String {
			return _id;
		}
	}
}