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
package ui.events {
	
	import flash.errors.StackOverflowError;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import ui.core.UIObject;

	public final class DragEvent extends Event {
		
		public static const DRAG_OVER:String	= 'dragover';
		public static const DRAG_OUT:String		= 'dragout';
		public static const DRAG_DROP:String	= 'dragdrop';
		
		/**
		 * 	The object that started the drag
		 */
		public var origin:UIObject;
		public var ctrlKey:Boolean;
		public var shiftKey:Boolean;
		
		/**
		 * 
		 */
		public function DragEvent(type:String):void {
			super(type);
		}
		
		/**
		 * 
		 */
		override public function clone():Event {
			var event:DragEvent = new DragEvent(super.type);

			event.origin		= origin,
			event.ctrlKey		= ctrlKey,
			event.shiftKey		= shiftKey;

			return event;
		}
		
	}
}