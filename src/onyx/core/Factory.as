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
	
	import flash.utils.*;
	
	/**
	 * 
	 */
	public final class Factory extends Dictionary {
		
		/**
		 * 	@private
		 */
		private static const hash:Object	= {};
		
		/**
		 * 
		 */
		public static function release(type:Class, object:IDisposable):void {
			if (type) {
				// store object
				const dict:Dictionary = hash[type];
				dict[object] = null;
			}
		}
		
		/**
		 * 
		 */
		public static function registerClass(type:Class):void {
			if (!hash[type]) {
				hash[type] = new Dictionary(true);
			}
		}
		
		/**
		 * 
		 */
		public static function getNewInstance(type:Class):* {
			const dict:Dictionary = hash[type];
			for (var i:Object in dict) {
				delete dict[i];
			//	trace('reuse', type);
				return i;
			}
			//trace('newobj', type);
			i = new type();
			return i;
		}
	}
}