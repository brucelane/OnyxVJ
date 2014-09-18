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
	
	import onyx.plugin.*;

	/**
	 * 
	 */
	public final class DisplayEvent extends Event {
		
		/**
		 * 	Layer Created
		 */
		public static const LAYER_CREATED:String	= 'layer_create';
		
		/**
		 * 
		 */
		public static const DISPLAY_RENDER:String	= 'display_render';
		
		/**
		 * 
		 */
		public static const MIX_LOADING:String		= 'mix_loading';
		
		/**
		 * 
		 */
		public static const MIX_LOADED:String		= 'mix_loaded';
		
		/**
		 * 	The layer created
		 */
		public var layer:Layer;
		
		/**
		 * 	@constructor
		 */
		public function DisplayEvent(type:String, layer:Layer = null):void {
			this.layer = layer;
			super(type);
		}
		
		/**
		 * 	Clones the event
		 */
		override public function clone():Event {
			return new DisplayEvent(type, layer);
		}
		
	}
}