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
package ui.window {
	
	import onyx.plugin.*;

	/**
	 * 	Window Registration
	 */
	public final class WindowRegistration {
		
		/*{	register(
				new WindowRegistration('FILE BROWSER',	Browser),
				new WindowRegistration('CONSOLE',		ConsoleWindow),
				new WindowRegistration('FILTERS',		Filters),
				new WindowRegistration('LAYERS',		LayerWindow),
				new WindowRegistration('DISPLAY',		DisplayWindow),
				new WindowRegistration('KEY MAPPING',	KeysWindow),
				new WindowRegistration('SETTINGS',		SettingsWindow),
				new WindowRegistration('VIDEOPONG',		VideopongWindow),
			new WindowRegistration('PREVIEW',		PreviewWindow),
			new WindowRegistration('CHANNELA',		ChannelAWindow),
			new WindowRegistration('CHANNELB',		ChannelBWindow)
			);
		}*/
		
		/**
		 * 	All window registrations
		 */
		public static const registrations:Array	= [];
		
		/**
		 * 	@private
		 * 	Stores the window registration name indexes
		 */
		private static const definition:Object	= {};
		
		/**
		 * 	Returns a window based on name
		 */
		public static function getWindow(name:String):Window {
			const reg:WindowRegistration = definition[name];
			return reg ? reg.window : null;
		}
		
		/**
		 * 	Returns a class based on name
		 */
		public static function getDefinition(name:String):Class {
			const reg:WindowRegistration = definition[name];
			return reg ? reg.definition : null;
		}
		
		/**
		 * 
		 */
		public static function getRegistration(name:String):WindowRegistration {
			return definition[name];
		}
		
		/**
		 * 	@private
		 * 	Registers windows
		 */
		public static function register(... rest:Array):void {
			
			for each (var reg:WindowRegistration in rest) {
				definition[reg.name] = reg;
				registrations.push(reg);
			}
			
		}
		
		/**
		 * 
		 */
		public static function initialize(state:WindowState):void {
			
			for each (var reg:WindowStateReg in state.windows) {

				var def:WindowRegistration = definition[reg.name];
				
				// create the window only if the registration exists
				if (def) {
					def.x		= reg.x,
					def.y		= reg.y,
					def.enabled = reg.enabled;
				}
			}
		}
		
		/**
		 * 	The name of the window to put on the button
		 */
		public var name:String;
		
		/**
		 * 	The x location of the window
		 */
		public var x:int;
		
		/**
		 * 	The y location of the window
		 */
		public var y:int;
		
		/**
		 * 	@private
		 * 	The definition for the window type
		 */
		internal var definition:Class;
		
		/**
		 * 	@private
		 * 	The actual window definition
		 */
		internal var window:Window;
		
		/**
		 * 	@constructor
		 */
		public function WindowRegistration(name:String, definition:Class):void {
			
			this.name			= name,
			this.definition		= definition;
			
		}
		
		/**
		 * 	Whether the window has been created or not
		 */
		public function get enabled():Boolean {
			return (window !== null);
		}
		
		/**
		 * 
		 */
		public function getWindow():Window {
			return window;
		}
		
		/**
		 * 
		 */
		public function getDefinition():Class {
			return definition;
		}
		
		/**
		 * 	Sets whether the window is visible or not
		 */
		public function set enabled(value:Boolean):void {
		
			// create the window
			if (value && !window) {
				
				window = DISPLAY_STAGE.addChild(new definition(this)) as Window;
				window.x = x;
				window.y = y;
				
			// remove the window
			} else if (!value && window) {

				window.parent.removeChild(window);
				window.dispose();
				window = null;

			}
		}
		
		/**
		 * 	Returns index
		 */
		public function get index():int {
			return registrations.indexOf(this);
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return '[WindowRegistration: ' + name + ']';
		}
	}
}