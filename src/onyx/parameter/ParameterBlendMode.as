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
package onyx.parameter {
	

	import onyx.core.*;
	import onyx.display.BlendModes;
	
	/**
	 * 	This control will display available blend modes.  This will dispatch a string value to the IParameterObject
	 * 
	 * 	@see onyx.core.IParameterObject
	 */
	public final class ParameterBlendMode extends ParameterArray {
		
		/**
		 * 	@constructor
		 */
		public function ParameterBlendMode(name:String, displayName:String, defaultBlend:String = null):void {
			super(name, displayName, BlendModes, defaultBlend || BlendModes[0]);
		}
	}
}