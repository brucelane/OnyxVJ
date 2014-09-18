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
	
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * 	Vertical Ordering Policy
	 */
	public final class VOrderPolicy extends Policy {
		
		/**
		 * 	The padding between objects
		 */
		public var padding:int;
		public var paddingTop:int;
		
		/**
		 * 	@constructor
		 */
		public function VOrderPolicy(padding:int = 1, paddingTop:int = 0):void {
			this.padding 	= padding;
			this.paddingTop = paddingTop;
		}
		
		/**
		 * 	Initialized to a target
		 */
		override public function initialize(target:IEventDispatcher):void {

			target.addEventListener(Event.ADDED, _onAdded,		false, 0, true);
			target.addEventListener(Event.REMOVED, _onRemoved,	false, 0, true);
		}
		
		/**
		 * 	Terminated
		 */
		override public function terminate(target:IEventDispatcher):void {
		}
		
		/**
		 * 	@private
		 */
		private function _onAdded(event:Event):void {

			var parent:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
			var y:int = paddingTop;

			for (var count:int = 0; count < parent.numChildren; count ++) {
				var child:DisplayObject = parent.getChildAt(count);
				child.y	= y;
				
				y += child.height + padding;
			}

		}
		
		
		/**
		 * 	@private
		 */
		private function _onRemoved(event:Event):void {

			var parent:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
			var y:int = paddingTop;

			for (var count:int = 0; count < parent.numChildren; count ++) {
				var child:DisplayObject = parent.getChildAt(count);
				child.y	= y;
				
				y += child.height + padding;
			}

		}
	}
}