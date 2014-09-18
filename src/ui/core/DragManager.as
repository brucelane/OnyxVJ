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
package ui.core {

	import flash.display.*;
	import flash.events.MouseEvent;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.events.DragEvent;
	import ui.styles.*;
	
	/**
	 * 	Drag Manager
	 */
	public class DragManager {
		
		/**
		 * 	@private
		 * 	Targets that I can drop onto
		 */
		private static var _targets:Object;
		
		/**
		 * 	@private
		 */
		private static var _dragTarget:Bitmap;
		
		/**
		 * 	@private
		 */
		private static var _currentTarget:DisplayObject;
		
		/**
		 * 	@private
		 */
		private static var _offsetX:int;
		
		/**
		 * 	@private
		 */
		private static var _offsetY:int;
		
		/**
		 * 	@private
		 */
		private static var _origin:UIObject;
		
		/**
		 * 	@private
		 */
		private static var _dragOver:Function;
		
		/**
		 * 	@private
		 */
		private static var _dragOut:Function;
		
		/**
		 * 	@private
		 */
		private static var _dragDrop:Function;
		
		/**
		 * 	Starts a drag
		 */
		public static function startDrag(origin:UIObject, targets:Object, dragOver:Function, dragOut:Function, dragDrop:Function):void {
			
			// save variables
			_origin = origin;
			_targets = targets;
			
			_dragOver = dragOver;
			_dragOut = dragOut;
			_dragDrop = dragDrop;
			
			// mouse offset
			_offsetX = origin.mouseX;
			_offsetY = origin.mouseY;
			
			// we want the event to happen everywhere
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onObjectFirstMove);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _onObjectUp);

		}
		
		/**
		 * 	Enables a UIObject to be dragged
		 */
		public static function setDraggable(uiobject:UIObject, enable:Boolean = true):void {
			if (enable) {
				uiobject.addEventListener(MouseEvent.MOUSE_DOWN, _dragMouseDown, false, 0, true);
			} else {
				uiobject.removeEventListener(MouseEvent.MOUSE_DOWN, _dragMouseDown);
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _dragMouseDown(event:MouseEvent):void {
			var target:UIObject = event.currentTarget as UIObject;
			
			/* check to see if thet mouse is hitting the title bar */
			if (target.mouseY < 13) {
				target.startDrag();
				target.addEventListener(MouseEvent.MOUSE_UP, _dragMouseUp, false, 0, true);
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _dragMouseUp(event:MouseEvent):void {
			var target:UIObject = event.currentTarget as UIObject;
			
			target.stopDrag();
			target.removeEventListener(MouseEvent.MOUSE_UP, _dragMouseUp);
		}
		
		/**
		 * 	@private
		 */
		private static function _onObjectFirstMove(event:MouseEvent):void {

			// add a mirrored bitmap to the stage
			var bmp:BitmapData = new BitmapData(_origin.width || 1, _origin.height || 1, true, 0x00000000);
			bmp.draw(_origin, null, DRAG_DRAW);
			_dragTarget = new Bitmap(bmp,PixelSnapping.ALWAYS,false);
			
			// place it
			_dragTarget.x = DISPLAY_STAGE.mouseX - _offsetX;
			_dragTarget.y = DISPLAY_STAGE.mouseY - _offsetY;
			
			// add to stage
			DISPLAY_STAGE.addChild(_dragTarget);

			// set listeners for the dragged bitmap			
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onObjectFirstMove);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _onObjectMove);
			
			// in each target, we're going to look for rollover, rollout events
			for each (var target:DisplayObject in _targets) {
				
				target.addEventListener(DragEvent.DRAG_OVER, _dragOver);
				target.addEventListener(DragEvent.DRAG_OUT, _dragOut);
				target.addEventListener(DragEvent.DRAG_DROP, _dragDrop);
				target.addEventListener(MouseEvent.ROLL_OVER, _onRollTarget);
				target.addEventListener(MouseEvent.ROLL_OUT, _onRollOutTarget);
			}
		}
		
		/**
		 * 	@private
		 */
		private static function _onObjectMove(event:MouseEvent):void {
			_dragTarget.x = event.stageX - _offsetX;
			_dragTarget.y = event.stageY - _offsetY;
			
			event.updateAfterEvent();
		}
		
		/**
		 * 	@private
		 */
		private static function _onObjectUp(event:MouseEvent):void {
			
			// remove the event listeners
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onObjectFirstMove);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _onObjectMove);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, _onObjectUp);

			if (_dragTarget != null) {
				DISPLAY_STAGE.removeChild(_dragTarget);
				_dragTarget.bitmapData.dispose();
			}
			
			if (_currentTarget) {
				
				var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_DROP);
				dragEvent.ctrlKey = event.ctrlKey;
				dragEvent.shiftKey = event.shiftKey;

				dragEvent.origin = _origin;
				
				_currentTarget.dispatchEvent(dragEvent);
			}

			// remove the target listeners			
			for each (var target:DisplayObject in _targets) {
				target.removeEventListener(MouseEvent.ROLL_OUT, _onRollOutTarget);
				target.removeEventListener(MouseEvent.ROLL_OVER, _onRollTarget);
				target.removeEventListener(DragEvent.DRAG_OVER, _dragOver);
				target.removeEventListener(DragEvent.DRAG_OUT, _dragOut);
				target.removeEventListener(DragEvent.DRAG_DROP, _dragDrop);
			}
			
			// delete references;
			_targets = null;
			_origin = null;
			_currentTarget = null;
			_dragTarget = null;
			_dragDrop = null;
			_dragOut = null;
			_dragOver = null;
		}
		
		/**
		 * 	@private
		 */
		private static function _onRollTarget(event:MouseEvent):void {
			if (event.currentTarget !== _currentTarget) {
				_currentTarget = event.currentTarget as DisplayObject;
				
				var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_OVER);
				dragEvent.ctrlKey = event.ctrlKey;
				dragEvent.shiftKey = event.shiftKey;

				_currentTarget.dispatchEvent(dragEvent);
			}
		}

		/**
		 * 	@private
		 */
		private static function _onRollOutTarget(event:MouseEvent):void {

			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_OUT);
			dragEvent.ctrlKey = event.ctrlKey;
			dragEvent.shiftKey = event.shiftKey;
			
			if (_currentTarget) {
				_currentTarget.dispatchEvent(dragEvent);
				_currentTarget = null;
			}
		}

	}
}