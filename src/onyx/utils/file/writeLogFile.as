/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
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
	
	import onyx.core.Console;
	import onyx.plugin.*;

	/**
	 * 	Simple utility to write a log file synchronously
	 */
	public function writeLogFile( contents:String, clear:Boolean=false ):void
	{
		/*if ( DEBUG::SPLASHTIME==0 )
		{
			Console.output( contents );
			trace( contents );
		}*/
		var now:Date = new Date();
		
		var file:File = File.documentsDirectory.resolvePath( "onyx.log" );
		var fileMode:String = ( clear ? FileMode.WRITE : FileMode.APPEND );
		
		var fileStream:FileStream = new FileStream();
		fileStream.open( file, fileMode );
		
		fileStream.writeMultiByte( now.toString() + ": " + contents + "\n", File.systemCharset );
		fileStream.close();

		
	} 
}