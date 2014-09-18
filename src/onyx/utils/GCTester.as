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
package onyx.utils {
	
	import flash.events.*;
	import flash.utils.*;

	/**
	 * 	Tests an object for it's garbage collection
	 */
	public final class GCTester {
		
		// DEBUG::START
		// We need to make sure this class doesn't execute

		/**
		 * 	@private
		 */		
		private var dict:Dictionary = new Dictionary(true);
		
		/**
		 * 	@private
		 */
		private var _timer:Timer = new Timer(150);
		
		/**
		 * 	@private
		 */
		private var lastTrace:String;

		/**
		 * 	@constructor
		 */
		public function GCTester(obj:Object):void {
			
			dict[obj] = 1;
			
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:TimerEvent):void {
			for (var i:Object in dict) {
				lastTrace = i.toString();
				return;
			}
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer.stop();
			
			trace('GC:', lastTrace);
		}
		
		// DEBUG::END
	}
}