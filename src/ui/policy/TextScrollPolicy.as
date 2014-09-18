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
	
	import flash.display.DisplayObjectContainer;
	import flash.events.*;
	
	import ui.controls.ScrollBar;
	import ui.text.TextFieldOnyx;
	
	/**
	 * 	Scroll policy
	 */
	public final class TextScrollPolicy extends Policy {
		
		/**
		 * 	@private
		 */
		private var _scrollBar:ScrollBar;
		
		/**
		 * 	@private
		 */
		private var _target:TextFieldOnyx;
		
		/**
		 * 	Initialize
		 */
		override public function initialize(target:IEventDispatcher):void {
			_target = target as TextFieldOnyx;
			target.addEventListener(Event.SCROLL, _onScroll, false, 0, true);
		}
		
		/**
		 * 	@private
		 * 	Handler for when a scroll event is fired from the textfield
		 */
		private function _onScroll(event:Event):void {
			
			var target:TextFieldOnyx				= event.currentTarget as TextFieldOnyx;
			var parent:DisplayObjectContainer	= target.parent;
			
			// check for scrollbar first
			if (!_scrollBar) {

				_scrollBar = new ScrollBar();
				_scrollBar.x = target.x + target.width - _scrollBar.width;
				_scrollBar.addEventListener(MouseEvent.MOUSE_DOWN, _onScrollPress);
				
				// add the scrollbar
				parent.addChild(_scrollBar);

				// listen for the textfield removal, if so, remove the scrollbar too
				target.addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved, false, 0, true);
			}
			
//			_scrollBar.scaleY	= target.target.maxScrollV;
			_scrollBar.y = target.y;
		}
		
		/**
		 * 	@private
		 */
		private function _onScrollPress(event:MouseEvent):void {
		}
		
		/**
		 * 	@private
		 */
		private function _onRemoved(event:Event):void {
			_scrollBar.parent.removeChild(_scrollBar);
		}
		
		/**
		 * 	Removes the listener
		 */
		override public function terminate(target:IEventDispatcher):void {
			target.removeEventListener(Event.SCROLL, _onScroll);
		}
	}
}