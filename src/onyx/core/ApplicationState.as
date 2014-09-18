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
	
	[ExcludeSDK]
	
	[Event(name='complete', type='flash.events.Event')]
	
	/**
	 * 	Base class for application states
	 */
	public class ApplicationState extends EventDispatcher {
		
		/**
		 * 	Key for keyboard states
		 */
		public static const REMOTE:String			= 'Remote';

		/**
		 * 	Key for keyboard states
		 */
		public static const KEYBOARD:String			= 'Keyboard';
		
		/**
		 * 	Key for midi states
		 */
		public static const MIDI:String				= 'Midi';
		
		/**
		 * 	Stores the type of state it is.  Only one state of any type may be present at any time
		 * 	(implemented now for different types of KeyListener states).  null types never override each
		 * 	other
		 */
		public var type:String;
		
		/**
		 * 
		 */
		public function ApplicationState(type:String = null):void {
			this.type = type;
		}
		
		/**
		 * 	Called when the application state is initialized
		 */
		public function initialize():void {
		}
		
		/**
		 * 	Called when the application state is removed
		 */
		public function terminate():void {
		}
		
		/**
		 * 
		 */
		public function pause():void {
		}
	}
}