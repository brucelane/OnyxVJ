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
	
	import flash.net.*;

	/**
	 * 	Core NetConnection Class
	 */
	public class Connection extends NetConnection {
		
		/**
		 * 	Stores the default connection for all netconnections
		 */
		internal static const DEFAULT_CONNECTION:Connection = new Connection();
		
		/**
		 * 	@constructor
		 */
		public function Connection(server:String = null):void {
			
			objectEncoding = ObjectEncoding.AMF0;
			connect(server);
		}
	}
}