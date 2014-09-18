/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
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
package onyx.asset.http {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.plugin.*;
	
	
	/**
	 * 
	 */
	public final class HttpDirectoryQuery extends AssetQuery {
		
		/**
		 * 	@internal
		 */
		internal var list:Array;
		
		/**
		 * 	@private
		 */
		private var files:Array;
		
		/**
		 * 
		 */
		public function HttpDirectoryQuery(path:String, callback:Function):void {
			
			// super
			super(path, callback);
			
			// query
			query();
			
		} 
		
		/**
		 * 	@private
		 */
		public function query():void {
			list = [];
			
		}
		
	}
}