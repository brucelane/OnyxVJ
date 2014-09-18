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
package onyx.utils.string {

	/**
	 * 	Returns a filename without it's extension
	 */
	public function removeExtensionOnly(path:String):String {
		
		var end:int = path.lastIndexOf('.');
		
		if (end) {
			return path.substr(0, end);
		}
		
		return path;
	}
}