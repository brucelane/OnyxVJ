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
	 * 	Returns absolute paths based on relative paths
	 */
	public function pathUpOneLevel(folder:String):String {

		// check folder for ..'s
		var index:int		= folder.indexOf('../');
		var ext:String		= folder.substr(index+3);
		
		while (index >= 0) {
			
			var last:int	= folder.lastIndexOf('/', index - 2);
			folder			= folder.substr(0, last) + '/' + ext;
	
			index			= folder.indexOf('../');
			
		}
		
		return folder;
	}
}