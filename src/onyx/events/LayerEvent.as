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
	
	import flash.events.Event;
	
	import onyx.display.*;

	/**
	 * 
	 */
	public final class LayerEvent extends Event {
		
		/**
		 * 	Dispatched when a layer loads
		 */
		public static const LAYER_LOADED:String			= 'layerLoad';

		/**
		 * 	Dispatched when a layer loads
		 */
		public static const LAYER_UNLOADED:String		= 'layerUnload';

		/**
		 * 	Dispatched when a layer moves
		 */
		public static const LAYER_MOVE:String			= 'layerMove';
		
		/**
		 * 	Dispatched when a layer renders
		 */
		public static const LAYER_RENDER:String			= 'layerRender';

		/**
		 * 	@constructor
		 */
		public function LayerEvent(type:String):void {
			super(type);
		}
		
		/**
		 * 
		 */
		override public function clone():Event {
			return new LayerEvent(super.type);
		}
	}
}