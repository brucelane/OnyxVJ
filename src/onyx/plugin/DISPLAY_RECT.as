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

	import flash.display.*;
	import flash.geom.Rectangle;

	/**
	 * 	A "constant" used to determine the rectangle of a display or layer.  This value 
	 * 	changes based on the value changed in the settings.xml.  You can increase or
	 * 	decrease the height and width via the settings.xml -- this value should *NOT*
	 * 	be changed at runtime.
	 */
	public const DISPLAY_RECT:Rectangle = new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);

}