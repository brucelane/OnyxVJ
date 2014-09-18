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
package onyx.core {

	import flash.events.EventDispatcher;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;

	/**
	 * 	Base class for all plug-ins
	 */
	public class PluginBase extends EventDispatcher implements IParameterObject {
		
		/**
		 * 	Stores the related plugin
		 */
		onyx_ns var _plugin:Plugin;
		
		/**
		 * 	Returns the related plugin (Factory)
		 */
		final public function getRelatedPlugin():Plugin {
			return _plugin;
		}
		
		/**
		 * 	@private
		 */
		protected const parameters:Parameters	= new Parameters(this as IParameterObject);
		
		/**
		 * 
		 */
		public function initialize():void {
		}
		
		/**
		 * 
		 */
		final public function get name():String {
			return _plugin.name;
		}
		
		/**
		 * 	Disposes the filter
		 */
		final public function getParameters():Parameters {
			return parameters;
		}

		/**
		 * 	Clones the filter
		 */
		final public function clone():PluginBase {
			
			const base:PluginBase		= _plugin.createNewInstance();

			for each (var control:Parameter in parameters) {
				var newControl:Parameter = base.getParameters().getParameter(control.name);
				if (!(newControl is ParameterExecuteFunction)) {
					newControl.value = control.value;
				}
			}
			
			return base;
		}
		
		/**
		 * 	@private
		 *	Called by layer when a filter is added to it
		 */
		onyx_ns function clean():void {
		}
		
		/**
		 * 	Disposes the filter
		 */
		public function dispose():void {
		}
	}
}