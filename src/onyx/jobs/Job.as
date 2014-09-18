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
package onyx.jobs {
	
	[ExcludeClass]
	
	import flash.events.EventDispatcher;
	
	import onyx.utils.event.*;
	
	[Event(name='complete', type='flash.events.Event')]
	[Event(name='progress', type='flash.events.ProgressEvent')]
	
	/**
	 * 	Base class for application states
	 */
	public class Job extends EventDispatcher {
		
		/**
		 * 	Boolean whether the job will override another job that the target has
		 */
		public var overrideJob:Boolean	= false;
		
		/**
		 * 	Called when the application state is initialized
		 */
		public function initialize(... args:Array):void {
		}
		
		/**
		 * 	Called when the application state is removed
		 */
		public function terminate():void {
			dispatchEvent(EVENT_COMPLETE);
		}
		
	}
}