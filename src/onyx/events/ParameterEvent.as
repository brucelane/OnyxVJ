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
	
	import flash.events.*;

	/**
	 * 	Event dispatched when a control has changed (so objects listening to the control
	 * 	can change or update)
	 */
	public final class ParameterEvent extends Event {
		
		/**
		 * 	Changed
		 */
		public static const CHANGE:String	= 'ce_ch';
		
		/**
		 * 	The value changed to
		 */
		public var value:*;
		
		/**
		 * 	Dispatched when a control has changed
		 */
		public function ParameterEvent():void {
			super(CHANGE);
		}
		
		/**
		 * 	Control Event
		 */
		override public function clone():Event {
			const event:ParameterEvent = new ParameterEvent();
			event.value = value;
			return event;
		}
	}
}