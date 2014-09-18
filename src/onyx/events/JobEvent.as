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
	
	[ExcludeClass]
	
	import flash.events.Event;

	public final class JobEvent extends Event {
		
		public static const JOB_FINISHED:String = 'job_finished';
		
		public var value:*;
		
		public function JobEvent(type:String):void {
			super(type);
		}
		
		override public function clone():Event {
			const event:JobEvent = new JobEvent(super.type);
			event.value = value;
			return event;
		}
	}
}