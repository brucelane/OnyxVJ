/**
 * Copyright (c) 2003-2011 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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
	 * 	Simple utility to write a text file synchronously
	 */
	public function writeTextFile(file:File, contents:String):void {
		
		// create connection
		const stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		
		// write
		stream.writeUTFBytes(contents);
		
		// close the file
		stream.close();
		
	}
}