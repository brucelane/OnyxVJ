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
	
	import onyx.core.onyx_ns;
	import onyx.plugin.*;
	
	use namespace onyx_ns;

	public final class FilterEvent extends Event {
		
		public static const FILTER_ADDED:String		= 'fapply';
		public static const FILTER_REMOVED:String		= 'fremove';
		public static const FILTER_MOVED:String			= 'fmove';
		public static const FILTER_MUTED:String			= 'fmute';
		
		/**
		 * 	The filter
		 */
		public var filter:Filter;
		
		/**
		 * 	@constructor
		 */
		public function FilterEvent(type:String, filter:Filter):void {
			this.filter = filter;
			super(type);
		}
		
		/**
		 * 	Clone
		 */
		override public function clone():Event {
			return new FilterEvent(super.type, filter);
		}
	}
}