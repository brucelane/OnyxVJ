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
	
	import flash.utils.Dictionary;
	
	/**
	 * 	Manages jobs on targets
	 */
	public final class JobManager {
		
		/**
		 * 	@private
		 */
		private static var _registration:Dictionary = new Dictionary(true);;
		
		/**
		 * 	Registers a job with an object
		 */
		public static function register(target:Object, job:Job, ... args:Array):void {
			
			// destroy current job
			const currentJob:Job = _registration[target];
			if (currentJob) {
				currentJob.terminate();
			}
			
			// register current job
			_registration[target] = job;
			
			// initialize job
			job.initialize.apply(job, args);
			
		}
		
	}
}