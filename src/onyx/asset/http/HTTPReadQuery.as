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
package onyx.asset.http {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import onyx.asset.*;
	import onyx.core.Console;
	import onyx.display.OutputDisplay;
	
	internal final class HTTPReadQuery extends AssetQuery {
		
		/**
		 * 
		 */
		public function HTTPReadQuery(path:String, callback:Function):void 
		{
			super(path, callback);
		}
		
		/**
		 * 
		 */
		public function query():void 
		{
		}
		
		/**
		 * 
		 */
		private function onRead(event:Event):void 
		{
		}
	}
}