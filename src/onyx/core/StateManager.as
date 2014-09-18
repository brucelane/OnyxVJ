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
	
	import flash.events.*;
	
	import onyx.core.*;
	import onyx.utils.event.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Manager class that loads and removes states
	 */
	public final class StateManager {
		
		/**
		 * 	@private
		 * 	Stores states	
		 */
		onyx_ns static const _states:Array			= [];

		/**
		 * 	Loads an application state
		 */
		public static function loadState(state:ApplicationState):void {

			_states.push(state);
			state.initialize();

		}
		
		/**
		 * 	Removes an application state
		 */
		public static function removeState(state:ApplicationState):void {
			
			// pause
			state.pause();
			
			// destroy
			state.terminate();
			
			// remove state
			_states.splice(_states.indexOf(state), 1);
			
			// dispatch an event
			state.dispatchEvent(EVENT_COMPLETE);
			
		}
		
		/**
		 * 	Returns state matches
		 */
		public static function getStates(type:String):Array {
			
			const matches:Array = [];
			
			for each (var state:ApplicationState in _states) {
				if (state.type === type) {
					matches.push(state);
				}
			}
			
			return matches;
		}
		
		/**
		 * 	Pauses all states of type
		 * 	@param		the type of class to pause, if null, all states are paused
		 */
		public static function pauseStates(type:String):void {
			for each (var state:ApplicationState in _states) {
				if (state.type === type) {
					state.pause();
				}
			}
		}
		
		
		/**
		 * 	Pauses all states of type
		 * 	@param		the type of class to pause, if null, all states are paused
		 */
		public static function resumeStates(type:String = null):void {
			for each (var state:ApplicationState in _states) {
				
				if (state.type === type) {
					state.initialize();
				}
			}
		}
	}
}