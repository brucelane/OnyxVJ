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
	
	public class TelnetEvent extends Event {
		
		/**
		 * 	@private
		 */
		public static const STATE:String 	= 'state';
		public static const DATA:String 	= 'data';
		
		/**
		 * 	The message dispatched
		 */
		public var message:String;
		
		/**
		 * 	@constructor
		 */
		public function TelnetEvent(type:String, message:String):void {
			
			this.message	= message;
			
			super(type);

		}

		/**
		 * 	Clones the event
		 */		
		override public function clone():Event {
			return new TelnetEvent(super.type, message);
		}
		
	}
}