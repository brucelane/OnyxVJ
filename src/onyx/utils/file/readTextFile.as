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
	 * 	Simple utility to read a text file synchronously
	 */
	public function readTextFile(file:File):String {
		
		// create connection
		const stream:FileStream = new FileStream();
		stream.open(file, FileMode.READ);
		
		const value:String = stream.readUTFBytes(stream.bytesAvailable);
		
		// close the file
		stream.close();

		// return		
		return value;
	}
}