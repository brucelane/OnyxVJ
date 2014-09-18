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
package onyx.utils.file {
	
	import flash.filesystem.*;
	
	/**
	 * 	Simple utility to list a folder structure
	 */
	public function getDirectoryTree(file:File, filter:Function):Array {
		
		const array:Array		= file.getDirectoryListing();
		var returnarr:Array	= [];
		
		for each (var child:File in array) {
			if (child.isDirectory) {
				returnarr = returnarr.concat(getDirectoryTree(child, filter));
			} else {
				if (filter(child)) {
					returnarr.push(child);
				}
			}
		}
		
		// return		
		return returnarr;
	}
}