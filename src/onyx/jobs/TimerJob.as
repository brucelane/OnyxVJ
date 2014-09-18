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
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 	Base Job that runs on a timer
	 */
	public class TimerJob extends Job {
			
		/**
		 * 	@private
		 */
		private var _timer:Timer;
		
		/**
		 * 
		 */
		override public function initialize(... args:Array):void {

			var delay:int = args[0];
			
			_timer = new Timer(delay);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			
		}

		/**
		 * 	When the timer is finished running
		 */
		private function _onTimer(event:TimerEvent):void {
			terminate();
		}
		
		/**
		 * 
		 */
		override public function terminate():void {
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer.stop();
			_timer = null;
		}
		
		
	}
}