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
package ui.policy {

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class Policy {
		
		/**
		 * 	@private
		 */
		private static var _dict:Dictionary = new Dictionary(true);
		
		/**
		 * 	Adds a policy to an object
		 */
		public static function addPolicy(target:IEventDispatcher, policy:Policy):void {
			
			// no policies for object
			if (!_dict[target]) {
				var policies:Array = []
				_dict[target] = policies;
			} else {
				policies = _dict[target];
			}
			
			// add the policy
			policies.push(policy);
			
			// initialize
			policy.initialize(target);
			
		}
		
		public static function removePolicies(target:IEventDispatcher):void {
			var policies:Array = _dict[target];
			
			for each (var policy:Policy in policies) {
				policy.terminate(target);
			}
		}
		
		/**
		 * 
		 */
		public function initialize(target:IEventDispatcher):void {
		}
		
		/**
		 * 
		 */
		public function terminate(target:IEventDispatcher):void {
		}
	}
}