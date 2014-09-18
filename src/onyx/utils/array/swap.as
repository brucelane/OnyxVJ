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
package onyx.utils.array {
	
	/**
	 * 	Swaps array elements
	 */
	public function swap(array:Array, item:Object, itemIndex2:int):Boolean {
		
		const itemIndex:int	= array.indexOf(item);
		const item2:Object	= array[itemIndex2];
		
		if (item2 && itemIndex >= 0 && itemIndex !== itemIndex2) {
			array[itemIndex]	= item2;
			array[itemIndex2]	= item;

			return true;
		}
		
		return false;
	}
}