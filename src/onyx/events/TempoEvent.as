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
	 * 	Dispatched when bpm meter is on a beat
	 */
	public final class TempoEvent extends Event {
		
		/**
		 * 	Click
		 */
		public static const CLICK:String		= 'click';
		
		/**
		 * 
		 */
		public var beat:int;
		
		/**
		 * 	@constructor
		 */
		public function TempoEvent(beat:int = 0):void {
			this.beat = beat;
			super(CLICK);
		}
	}
}