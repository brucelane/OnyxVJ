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

package onyx.tween {
	
	import onyx.tween.easing.*;
	
	/**
	 * 	Tween property
	 */
	public final class TweenProperty {
		
		/**
		 * 	The property to affect
		 */
		public var property:String;
		
		/**
		 * 	The easing equation
		 */
		public var easing:Function;
		
		/**
		 * 	The start value
		 */
		public var start:Number;
		
		/**
		 * 	The end value
		 */
		public var end:Number;
		
		/**
		 * 	@constructor
		 */
		public function TweenProperty(property:String, start:Number, end:Number, easing:Function = null):void {
			this.property	= property,
			this.start		= start,
			this.end		= end,
			this.easing		= easing || Linear.easeIn;
		}
	}
}