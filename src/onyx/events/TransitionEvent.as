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
	
	import onyx.display.*;
	import onyx.plugin.*;
	
	/**
	 * 	Dispatched from a ContentTransition when a transition has finished
	 */
	public final class TransitionEvent extends Event {
		
		/**
		 * 	Dispatched from a ContentTransition when a transition has finished
		 */
		public static const TRANSITION_END:String		= 'tend';
		
		/**
		 * 	The content to replace in the layer
		 */
		public var content:Content;
		
		/**
		 * 	@constructor
		 */
		public function TransitionEvent(type:String, content:Content):void {
			this.content = content;
			super(type);
		}
		
		/**
		 * 	Clones the transition event
		 */
		override public function clone():Event {
			return new TransitionEvent(super.type, content);
		}
	}
}