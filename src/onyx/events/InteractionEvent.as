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

	/**
	 * 
	 */
	public final class InteractionEvent extends MouseEvent {
		
		public static const RIGHT_MOUSE_CLICK:String	= 'rightClick';
		public static const RIGHT_MOUSE_DOWN:String		= 'rightMouseDown';
		public static const RIGHT_MOUSE_UP:String		= 'rightMouseUp';
		
		public static const MIDDLE_MOUSE_CLICK:String	= 'middleMouseClick';
		public static const MIDDLE_MOUSE_DOWN:String	= 'middleMouseDown';
		public static const MIDDLE_MOUSE_UP:String		= 'middleMouseUp';
		public static const XY:String					= 'xy';
		
		public static const CLICK:String				= MouseEvent.CLICK;
		public static const MOUSE_DOWN:String			= MouseEvent.MOUSE_DOWN;
		public static const MOUSE_UP:String				= MouseEvent.MOUSE_UP;
		public static const MOUSE_MOVE:String			= MouseEvent.MOUSE_MOVE;
		
		/**
		 * 	@param
		 * 	How hard the item is being pressed -- defaults to 1 if it's a mouse interaction
		 * 	0-1 if coming from a wacom event
		 */
		public var amount:Number	= 1;

		/**
		 * 	@constructor
		 */
		public function InteractionEvent(type:String):void {
			super(type, false, true);
		}
		
		/**
		 * 
		 */
		override public function clone():Event {
			var e:InteractionEvent = new InteractionEvent(type);
			e.localX		= localX;
			e.localY		= localY;
			e.ctrlKey		= ctrlKey;
			e.shiftKey		= shiftKey;
			e.delta			= delta;
			e.buttonDown	= buttonDown;
			e.altKey		= altKey;
			return e;
		}
	}
}