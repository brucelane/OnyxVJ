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
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Returns a list of plugins.  These can either be filters, macros, transitions, or visualizers.
	 * 	This control will dispatch an actual instance of the plugin, rather than the plugin definition itself.
	 * 
	 * 	@see onyx.plugin.Filter
	 * 	@see onyx.plugin.Transition
	 * 	@see onyx.plugin.Visualizer
	 */
	public final class ParameterPlugin extends ParameterArray {
		
		/**
		 * 	@constructor
		 */
		public function ParameterPlugin(name:String, display:String, data:PluginArray, defaultValue:PluginBase = null):void {

			super(name, display, data, defaultValue ? defaultValue._plugin : data[0], 'name');
			
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			var obj:PluginBase = target[name];
			return (obj) ? obj._plugin : null;
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {

			const currentTarget:PluginBase	= target[name];
			if (v) {
				const plugin:Plugin				= v as Plugin;
				
				if (!currentTarget || currentTarget._plugin !== plugin) {
					
					if (currentTarget) {
						currentTarget.dispose();
					}
					
					const newPlug:PluginBase	= plugin.createNewInstance();
					newPlug.initialize();
					
					target[name] = dispatch(newPlug);
				} 

			} else {
				
				if (currentTarget) {
					currentTarget.dispose();
				}
				
				target[name] = dispatch(null);
			}
		}
		
		/**
		 * 
		 */
		override public function reset():void {
			value = dispatch(defaultValue);
		}
		
		/**
		 * 	Load xml (return a new object of type='id')
		 */
		override public function loadXML(xml:XML):void {
			
		}
		
		/**
		 * 	Returns xml representation of the control
		 */
		override public function toXML():XML {
			
			const xml:XML				= <{name}/>;
			
			const plugin:Plugin			= this.value;
			if (plugin) {
				xml.appendChild(plugin.name);
			}
			
			return xml;
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterPlugin;
		}
	}
}