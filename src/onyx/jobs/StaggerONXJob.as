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
	
	[ExcludeSDK]
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.display.*;
	import onyx.events.*;
	import onyx.jobs.onx.*;
	import onyx.plugin.*;
	
	/**
	 * 	Staggers loading of a mix file
	 */
	public final class StaggerONXJob extends Job {
		
		/**
		 * 	@private
		 */
		private var _transition:Transition;
		
		/**
		 * 	@private
		 */
		private var _jobs:Array;
		
		/**
		 * 
		 */
		private var _timer:Timer;

		/**
		 * 	@constructor
		 */
		public function StaggerONXJob(transition:Transition, jobs:Array):void {
			
			_transition = transition;

			var newJobs:Array = [];
			
			// load jobs immediately if they have no path
			for each (var job:LayerLoadSettings in jobs) {
				var layer:LayerImplementor = job.layer;
				
				if (!layer.path) {
					layer.load(job.settings.path, job.settings);
				} else {
					newJobs.push(job);
				}
			}
			
			_jobs = newJobs;
			
			if (_jobs.length > 0) {
				_timer = new Timer(_transition.duration);
				_timer.addEventListener(TimerEvent.TIMER, _loadJob);
			}

			_loadJob();
		}
		
		/**
		 * 	@private
		 */
		private function _loadJob(event:Event = null):void {
			
			var job:LayerLoadSettings = _jobs.shift() as LayerLoadSettings;
			
			if (job) {
	
				var layer:LayerImplementor			= job.layer;
				var settings:LayerSettings	= job.settings;
				layer.load(settings.path, settings, _transition);
				
				if (_timer) {
					_timer.start();
				}
				
				return;
			}

			dispose();
		}
		
		/**
		 * 
		 */
		public function dispose():void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER, _loadJob);
				_timer.stop();
				_timer		= null;
			}
			_transition	= null,
			_jobs		= null;
		}
		
	}
}