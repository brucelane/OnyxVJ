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
	
	import ui.core.*;
	
	/**
	 * 	Stores states of windows
	 */
	public final class WindowState {

		// auto-register the default window state
		/*{	register(
				new WindowState('DEFAULT', [
					new WindowStateReg('FILE BROWSER',	6,		345),
					new WindowStateReg('FILTERS',		518,	345),
					new WindowStateReg('LAYERS',		6,		6),
					new WindowStateReg('KEY MAPPING',	615,	319, 	false),
					new WindowStateReg('DISPLAY',		518,	565),
					new WindowStateReg('CONSOLE',		6,		565),
					new WindowStateReg('SETTINGS',		200,	565),
					new WindowStateReg('VIDEOPONG',		360,	565),
					new WindowStateReg('RECORDER',		7,		756),
					new WindowStateReg('PREVIEW',		775,	345)
				])
			)
		}*/
		
		/**
		 * 
		 */
		public static function save(name:String = 'DEFAULT'):void {
			const state:WindowState = lookup[name];
			if (state) {
				for each (var window:WindowStateReg in state.windows) {
					var reg:WindowRegistration	= WindowRegistration.getRegistration(window.name);
					if (reg) {
						
						if (reg.window) {
							window.enabled	= true; 
							window.x		= reg.window.x;
							window.y		= reg.window.y;
						} else {
							window.enabled	= false;
							window.x		= reg.x;
							window.y		= reg.y;
						}
					}
				}
			}
		}
		
		/**
		 * 	@private
		 */
		public static const states:Array = [];
		
		/**
		 * 	@private
		 * 	Look-up for states by name
		 */
		internal static const lookup:Object	= {};
		
		/**
		 * 	@private
		 * 	The current window state
		 */
		public static var currentState:WindowState;
		
		/**
		 * 	Registers a window state
		 */
		public static function register(state:WindowState):void {
			states.push(state);
			lookup[state.name] = state;
		}
		
		/**
		 * 	Registers a state for use
		 */
		public static function load(state:WindowState):void {
			currentState = state || lookup.DEFAULT;
			WindowRegistration.initialize(currentState);
		}
		
		/**
		 * 	Returns a window state based upon name
		 */
		public static function getState(name:String = 'DEFAULT'):WindowState {
			return lookup[name];
		}
		
		/**
		 * 
		 */
		public static function toXML():XML {
			
			save();
			
			var xml:XML = <windows />;
			for each (var state:WindowState in lookup) {
				var stateXML:XML = <state name={state.name} />;
				for each (var reg:WindowStateReg in state.windows) {
					stateXML.appendChild(
						<window name={reg.name} x={reg.x} y={reg.y} enabled={reg.enabled}/>
					);
				}
				xml.appendChild(stateXML);
			}
			return xml;
		}
		
		/**
		 * 	The states of the windows to arrange
		 */
		public var windows:Array;
		
		/**
		 * 	Name of the state
		 */
		public var name:String;
		
		/**
		 * 	@constructor
		 */
		public function WindowState(name:String, windows:Array):void {
			this.name		= name,
			this.windows	= windows;
		}
	}
}