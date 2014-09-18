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
package onyx.plugin {
	
	import flash.text.Font;
	
	import onyx.core.*;
	
	use namespace onyx_ns;
	
	public final class PluginManager {
		
		/**
		 * 
		 */
		public static const blendModes:PluginArray		= new PluginArray();
		
		/**
		 * 
		 */
		public static const filters:PluginArray			= new PluginArray();
		
		/**
		 * 
		 */
		public static const macros:PluginArray			= new PluginArray();
		
		/**
		 * 
		 */
		public static const transitions:PluginArray		= new PluginArray(new Plugin('DISSOLVE', Transition, 'Dissolve'));
		
		/**
		 * 
		 */
		public static const modules:Object				= {};
		
		/**
		 * 
		 */
		public static const visualizers:PluginArray		= new PluginArray();
		
		/**
		 * 
		 */
		public static const fonts:Array					= new Array();
		
		/**
		 * 	Registers a font
		 */
		public static function registerFont(font:Font):void {
			fonts[font.fontName.toUpperCase()] = font;
			fonts.push(font);
		}
		
		/**
		 * 	Registers a font
		 */
		public static function registerFilter(plugin:Plugin):void {
			filters.register(plugin);
		}
		
		/**
		 * 	Registers a macro
		 */
		public static function registerMacro(plugin:Plugin):void {
			macros.register(plugin);
		}
		
		/**
		 * 	Registers a font
		 */
		public static function registerTransition(plugin:Plugin):void {
			transitions.register(plugin);
		}
		
		/**
		 * 	Registers a font
		 */
		public static function registerModule(plugin:Plugin):void {

			const module:Module = plugin.createNewInstance() as Module;
			modules[module.name] = module;
			
			// start the module
			module.initialize();
			
			// registers the module with a command
			Command.registerModule(plugin.name, module);
		}
		
		/**
		 * 	Registers a font
		 */
		public static function registerVisualizer(plugin:Plugin):void {
			visualizers.register(plugin);
		}
		
		/**
		 * 	Registers a font
		 */
		public static function getFilterDefinition(name:String):Plugin {
			return filters.nameLookup[name];
		}
		
		/**
		 * 	Registers a font
		 */
		public static function getModuleDefinition(name:String):Plugin {
			return modules.nameLookup[name];
		}
		
		/**
		 * 	Registers a font
		 */
		public static function getTransitionDefinition(name:String):Plugin {
			return transitions.nameLookup[name];
		}
		
		/**
		 * 	Registers a font
		 */
		public static function getMacroDefinition(name:String):Plugin {
			return macros.nameLookup[name];
		}
		
		/**
		 * 	Registers a font
		 */
		public static function getVisualizerDefinition(name:String):Plugin {
			return visualizers.nameLookup[name];
		}
		
		/**
		 * 	Registers a font
		 */
		public static function createFilter(type:Object):Filter {
			
			const plugin:Plugin = (type is Number) ? filters[int(type)] : filters.nameLookup[type];

			return plugin ? plugin.createNewInstance() as Filter : null;
		}

		/**
		 * 	Registers a font
		 */
		public static function createTransition(type:Object):Transition {

			const plugin:Plugin = (type is Number) ? transitions[int(type)] : transitions.nameLookup[type];
			
			return plugin ? plugin.createNewInstance() as Transition : null;
		}
		
		/**
		 * 	Registers a font
		 */
		public static function createMacro(type:Object):Macro {

			const plugin:Plugin = (type is Number) ? macros[int(type)] : macros.nameLookup[type];

			return plugin ? plugin.createNewInstance() as Macro : null;
		}
		
		/**
		 * 	Registers a font
		 */
		public static function createVisualizer(type:Object):Visualizer {

			const plugin:Plugin = (type is Number) ? visualizers[int(type)] : visualizers.nameLookup[type];

			return plugin ? plugin.createNewInstance() as Visualizer : null;
		}
		
		/**
		 * 	Registers a font
		 */
		public static function createFont(name:String):Font {
			return fonts[name.toUpperCase()];
		}
	}
}