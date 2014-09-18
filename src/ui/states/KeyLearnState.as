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
	
	import flash.events.*;
	import flash.ui.Keyboard;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import ui.controls.Popup;

	public final class KeyLearnState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var _plugin:Plugin;
		
		/**
		 * 	@private
		 */
		private var _popup:Popup;
		
		/**
		 * 	@private
		 */
		private var _state:KeyListenerState;
		
		/**
		 * 	@constructor
		 */
		public function KeyLearnState(plugin:Plugin):void {

			// store definitions
			_plugin = plugin;
			
			// 
			super('keyLearn');
		}
		
		/**
		 * 	Start listening and override mouse events
		 */
		override public function initialize():void {
			
			// pause keyboard states
			StateManager.pauseStates(ApplicationState.KEYBOARD);
			
			// display a pop-up
			_popup = new Popup(150, 100, 'Press a key for:\n\n' + _plugin.description);
			_popup.addToStage();
			
			// listen for a key
			DISPLAY_STAGE.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, true, 9999);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, true, 9999);

		}
		
		/**
		 * 	@private
		 * 	The user pressed a button
		 */
		private function _onKeyDown(event:KeyboardEvent):void {
			
			if (event.keyCode === Keyboard.ESCAPE) {
		
				// remove the learn state
				StateManager.removeState(this);
					
			} else {
				
				const modifier:int	= (event.shiftKey ? 4 : 0) + (event.altKey ? 2 : 0) + (event.ctrlKey ? 1 : 0);
				
				if (event.keyCode !== Keyboard.ALTERNATE && event.keyCode !== Keyboard.CONTROL && event.keyCode !== Keyboard.SHIFT) { 
					
					// register	
					KeyListenerState.registerKey(modifier << 8 | event.keyCode, _plugin);
					
					// don't let the event through
					event.stopPropagation();
		
					// remove the learn state
					StateManager.removeState(this);
					
				}
			}
		}
		
		/**
		 * 	@private
		 * 	Captures mouse events (to cancel the state if a mouse press is detected)
		 */
		private function mouseDown(event:MouseEvent):void {

			// don't let the event through
			event.stopPropagation();

			// remove the state
			StateManager.removeState(this);
		}
		
		/**
		 * 	Terminate the key learn state
		 */
		override public function terminate():void {
			
			// pause keyboard states
			StateManager.resumeStates(ApplicationState.KEYBOARD);
			
			// remove keyboard listener
			DISPLAY_STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, true);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown, true);
			
			// remove the popup
			if (_popup) {
				DISPLAY_STAGE.removeChild(_popup);
			}
			_plugin = null,
			_popup	= null;
		}

	}
}