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
package onyx.ui {
	
	import flash.display.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	
	use namespace onyx_ns;
	
	public final class UserInterface {
		
		/**
		 * 	@private
		 */
		onyx_ns static var adapter:IUserInterfaceAdapter;
		
		/**
		 * 
		 */
		public static function createControl(param:Parameter, options:Object):UserInterfaceControl {
			return adapter.createControl(param, options);
		}
		
		/**
		 * 
		 */
		public static function getAllControls():Dictionary {
			return adapter.getAllControls();
		}
	}	
}