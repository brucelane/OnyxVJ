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
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import onyx.parameter.*;
	
	/**
	 * 	Interface for defining whether a filter will alter the bitmap.
	 * 	Apply this interface if you would like to create your own custom filter.
	 * 
	 *  @see onyx.plugin.Filter
	 */
	public interface IBitmapFilter extends IParameterObject {
		
		function applyFilter(bitmapData:BitmapData):void;
		
	}
}