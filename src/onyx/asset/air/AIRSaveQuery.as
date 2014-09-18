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
package onyx.asset.air {
	
	import flash.utils.ByteArray;
	
	import onyx.asset.*;
	import onyx.utils.file.*;
	

	/**
	 * 
	 */
	public final class AIRSaveQuery extends AssetQuery {
		
		/**
		 * 
		 */
		public function AIRSaveQuery(path:String, callback:Function, bytes:ByteArray):void {
			super(path, callback);
			
			init(bytes);
		}
		
		/**
		 * 	@private
		 */
		private function init(bytes:ByteArray):void {
			writeBinaryFile(AIR_ROOT.resolvePath(path), bytes);
		}
	}
}