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
package onyx.core {
	
	import flash.events.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	[ExcludeClass]
	
	/**
	 * 	Interface that defines whether an object can add or remove filters
	 */
	public interface IFilterObject extends IParameterObject, IEventDispatcher {
		
		function get filters():Array;
		function addFilter(filter:Filter):void;
		function removeFilter(filter:Filter):void;
		function getFilterIndex(filter:Filter):int;
		function moveFilter(filter:Filter, index:int):void;
		function muteFilter(filter:Filter, toggle:Boolean = true):void;
		function applyFilter(filter:IBitmapFilter):void;

	}
}