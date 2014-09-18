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
package onyx.events {
	
	import flash.events.Event;

	/**
	 * 	This event handles global application events for startup, and displays
	 */
	public final class ApplicationEvent extends Event {
		
		/**
		 * 	Event dispatched when onyx starts initializing
		 */
		public static const ONYX_STARTUP_START:String	= 'onyxstartstart';

		/**
		 * 	Event dispatched when onyx ends initializing
		 */
		public static const ONYX_STARTUP_END:String		= 'onyxstartend';
		
		/**
		 * 	@constructor
		 */
		public function ApplicationEvent(type:String):void {
			super(type);
		}
		
	}
}