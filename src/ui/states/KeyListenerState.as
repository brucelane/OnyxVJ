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
package ui.states {
	
	import flash.events.KeyboardEvent;
	import flash.ui.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import ui.core.*;
	
	// TBD, this should be a hash map to the key codes
	// - Keys should have down and up states
	// All key definitions should be mapped to macros (how do we deal with ui macros?)

	/**
	 * 	Listens for keyboard events
	 */
	public final class KeyListenerState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private static const forward:Object		= {};
		
		/**
		 * 
		 */
		private static const reverse:Object		= {};
		
		/**
		 * 	@private
		 */
		private static const keyUpHash:Object	= {};
		
		/**
		 * 
		 */
		public static function registerKey(id:int, plugin:Plugin):void {
			
			if (plugin) {
				
				var last:Plugin = forward[id];
				if (last) {
					delete reverse[last];
				}

				// store forward and reverse hash
				forward[id] = plugin;
				reverse[plugin] = id;
			
			} else {
				
				var plugin:Plugin = forward[id];
				delete forward[id];
				if (plugin) {
					delete reverse[plugin];
				}
				
			}
		}
		
		/**
		 * 
		 */
		public static function getKeyDefinition(id:int):Plugin {
			return forward[id];
		}
		
		/**
		 * 
		 */
		public static function getMacroKeys(plugin:Plugin):int {
			return reverse[plugin];
		}
		
		/**
		 * 	Returns an array of xml for the key settings
		 */
		public static function toXML():XML {
			const xml:XML = <keys/>;
			
			for each (var plugin:Plugin in forward) {
				var id:int = reverse[plugin];
				xml.appendChild(<key code={id}>{plugin.name}</key>);
			}
			
			return xml;
		}

		/**
		 * 
		 */
		public function KeyListenerState():void {
			super(ApplicationState.KEYBOARD);
		}
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			// listen for keys
			DISPLAY_STAGE.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
		}
		
		/**
		 * 
		 */
		override public function pause():void {

			// remove listener
			DISPLAY_STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,	keyDown);
			DISPLAY_STAGE.removeEventListener(KeyboardEvent.KEY_UP,		keyUp);
			
		}
		
		/**
		 * 	Terminates the keylistener
		 */
		override public function terminate():void {
		}
		
		/**
		 * 	@private
		 */
		private function keyDown(event:KeyboardEvent):void {
			
			const modifier:int	= (event.shiftKey ? 4 : 0) + (event.altKey ? 2 : 0) + (event.ctrlKey ? 1 : 0);
			
			const code:int		= modifier << 8 | event.keyCode;
			const plugin:Plugin	= forward[code];
			
			if (plugin && !keyUpHash[code]) {
				
				var macro:Macro	= plugin.createNewInstance() as Macro;
				keyUpHash[code] = macro;
				
				// execute the macro
				macro.keyDown();
				
				// add a listener for the key up
				DISPLAY_STAGE.addEventListener(KeyboardEvent.KEY_UP, keyUp);
				
			}
		}
		
		/**
		 * 	@private
		 */
		private function keyUp(event:KeyboardEvent):void {
			
			if (/*event.keyCode !== Keyboard.ALTERNATE &&*/ event.keyCode !== Keyboard.SHIFT && event.keyCode !== Keyboard.CONTROL) {
				
				// 4 shift
				// 2 alt
				// 1 ctrl
				
				for (var modifier:int = 0; modifier < 8; modifier++) {
					const code:int			= modifier << 8 | event.keyCode;
					
					const macro:Macro = keyUpHash[code];
					if (macro) {
						macro.keyUp();
					}
					
					delete keyUpHash[code];
				}
			}
		}
	}
}