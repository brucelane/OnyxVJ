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
package onyx.plugin {
	
	import flash.events.*;
	
	import onyx.display.LayerSettings;
	import onyx.events.*;
	import onyx.parameter.Parameters;
	
	[Event(name="filter_added",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
	[Event(name="layer_loaded",		type="onyx.events.LayerEvent")]
	[Event(name="layer_moved",		type="onyx.events.LayerEvent")]
	[Event(name="progress",			type="flash.events.Event")]

	/**
	 * 
	 */
	public interface Layer extends Content {

		function getProperties():Parameters;
		function load(path:String, settings:LayerSettings = null, transition:Transition = null):void;
		function get index():int;
		function forwardEvent(event:InteractionEvent):void;

	}
}