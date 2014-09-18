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
package ui.controls {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.core.*;
	import ui.styles.*;

	/**
	 * 	ScrollPane class
	 */
	public class ScrollPane extends UIObject {

		/**
		 * 	@private
		 */		
		private const holder:Sprite	= new Sprite();

		/**
		 * 	@private
		 */		
		private var clickY:int;

		/**
		 * 	@private
		 */		
		private var _width:int;

		/**
		 * 	@private
		 */
		private var _height:int;

		/**
		 * 	@private
		 */		
		private var scrollY:ScrollBar;
		
		/**
		 *	@private 
		 */
		private var track:Sprite;
		
		/**
		 * 	@constructor
		 */
		public function ScrollPane(width:int, height:int):void {
			
			mouseEnabled	= false;
			mouseChildren	= true;
			
			// create holder
			super.addChild(holder);
			
			// set width / height
			_width	= width;
			_height = height;
			
			scrollRect = new Rectangle(0, 0, _width + 6, _height);
			
			// listen for mouse over
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			
		}
		
		/**
		 * 	@see DisplayObject.addChild
		 */
		final override public function addChild(child:DisplayObject):DisplayObject {
			var child:DisplayObject = holder.addChild(child);
			if (holder.height > _height) {
				_displayScrollBar();
			}
			
			return child;
		}
		
		/**
		 * 	@see DisplayObjectContainer.addChildAt
		 */
		final override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			var child:DisplayObject = holder.addChildAt(child, index);
			if (holder.height > _height) {
				_displayScrollBar();
			}

			return child;
		}
		
		/**
		 * 	Gets the child at index
		 */
		final override public function getChildAt(index:int):DisplayObject {
			return holder.getChildAt(index);		
		}
		
		/**
		 * 	@see DisplayObjectContainer.addChildAt
		 */
		final override public function getChildIndex(child:DisplayObject):int {
			return holder.getChildIndex(child);;
		}
		
		/**
		 * 	@see DisplayObjectContainer.removeChild
		 */
		final override public function removeChild(child:DisplayObject):DisplayObject {
			
			var child:DisplayObject = holder.removeChild(child);
			_calculateRemove();
			
			return child;
		}
		
		/**
		 * 	@see DisplayObjectContainer.removeChildAt
		 */
		final override public function removeChildAt(index:int):DisplayObject {
			var child:DisplayObject = holder.removeChildAt(index);
			_calculateRemove();
			return child;
		}

		/**
		 * 	@see DisplayObjectContainer.removeChildAt
		 */
		final override public function contains(child:DisplayObject):Boolean {
			return holder.contains(child);
		}
		
		/**
		 * 	@see DisplayObjectContainer.numChildren
		 */
		final override public function get numChildren():int {
			return holder.numChildren;
		}
		
		/**
		 * 	@private
		 * 	Calculates the rectangle when an item is removed
		 */
		final private function _calculateRemove():void {

			if (scrollY) {
				if (holder.height < _height) {
					_destroyScrollBar();
				}
			}

		}
		
		/**
		 * 	@private
		 * 	Listens for the mouse wheel
		 */
		final private function mouseOver(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		/**
		 * 	@private
		 * 	Listens for mouse out
		 */
		final private function mouseOut(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		/**
		 * 	Handles mousewheel events
		 */
		final private function mouseWheel(event:MouseEvent):void {
			if (scrollY) {
				scroll(scrollY.y - (event.delta * 3));
				event.updateAfterEvent();
			}
		}
		
		/**
		 * 	Displays scroll bar
		 */
		final private function _displayScrollBar():void {
			
			if (!scrollY) {
				
				scrollY = new ScrollBar();
				scrollY.x = _width;
				scrollY.addEventListener(MouseEvent.MOUSE_DOWN, scrollPress);

				// add the track				
				track	= new Sprite();
				track.x = _width;
				
				var graphics:Graphics = track.graphics;
				graphics.beginFill(0x45525c);
				graphics.drawRect(0,0,6,_height);
				graphics.endFill();
				
				track.addEventListener(MouseEvent.MOUSE_DOWN, trackPress);
				
				//add track
				super.addChild(track);
				
				// add it
				super.addChild(scrollY);
			}
			
			scrollY.height = (_height / holder.height) * _height;
		}
		
		/**
		 * 	@private
		 */
		final private function _destroyScrollBar():void {
			
			// remove listener
			scrollY.removeEventListener(MouseEvent.MOUSE_DOWN, scrollPress);
			track.removeEventListener(MouseEvent.MOUSE_DOWN, trackPress);
			
			// remove the scroll bar
			super.removeChild(scrollY);
			super.removeChild(track);
			
			// remove reference
			scrollY	= null,
			track	= null;
			
			// set the holder to default
			holder.y = 0;
			
		}
		
		/**
		 * 	@private
		 * 	Handler when a scroll bar is pressed
		 */
		final private function scrollPress(event:MouseEvent):void {
			var scrollbar:ScrollBar = event.currentTarget as ScrollBar;
			
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, scrollMove);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, scrollUp);
			
			clickY = mouseY - scrollY.y;
			
			scrollMove(event);
		}
		
		/**
		 * 	@private
		 * 	Handler when a scroll bar is moved
		 */
		final private function scrollMove(event:MouseEvent):void {
			scroll(mouseY - clickY);
			event.updateAfterEvent();
		}

		
		/**
		 * 	Scrolls
		 */
		final private function scroll(y:int):void {

			scrollY.y = Math.min(Math.max(y, 0), _height - scrollY.height);
			
			var ratio:Number = (scrollY.y / (_height - scrollY.height));
			holder.y = (-ratio * (holder.height - _height)) >> 0;
		}
		
		/**
		 * 	@private
		 * 	Handler when a scroll bar is moved
		 */
		final private function scrollUp(event:MouseEvent):void {
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, scrollMove);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, scrollUp);
		}
		
		/**
		 * 	Resets
		 */
		final public function reset():void {
			holder.y = 0;
		}
		
		/**
		 * 	Resets
		 */
		final private function trackPress(event:MouseEvent):void {
			scroll(mouseY - clickY);
		}
		
		/**
		 * 	Disposes
		 */
		override public function dispose():void {
			
			if (scrollY) {
				scrollY.removeEventListener(MouseEvent.MOUSE_DOWN, scrollPress);
				track.removeEventListener(MouseEvent.MOUSE_DOWN, trackPress);
			}

			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);

			super.dispose();
		}		
	}
}