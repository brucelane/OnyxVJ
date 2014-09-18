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
	
	/**
	 *  Beats
	 */
	public final class TempoBeat {
		
		/**
		 * 	Stores a dictionary of available beats
		 * 	This is also used for a lookup for xml serialization
		 */
		public static const BEATS:Object = {
			'global': new TempoBeat('global', 0),
			'1/16': new TempoBeat('1/16', 1),
			'1/8': new TempoBeat('1/8', 2),
			'1/4': new TempoBeat('1/4', 4),
			'1/2': new TempoBeat('1/2', 8),
			'1': new TempoBeat('1', 16),
			'2': new TempoBeat('2', 32),
			'4': new TempoBeat('4', 64)
		}

		/**
		 * 	Name
		 */
		public var name:String;
		
		/**
		 * 	Beat
		 */
		public var mod:int;
		
		/**
		 * 	@constructor
		 */
		public function TempoBeat(name:String, mod:int):void {
			this.name	= name,
			this.mod	= mod;
		}
		
		/**
		 * 	override toString();
		 */
		public function toString():String {
			return name;
		}
	}
}