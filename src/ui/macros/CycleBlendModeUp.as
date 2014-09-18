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
package ui.macros {

	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	
	import ui.core.*;
	import ui.layer.*;

	[ExcludeClass]
	
	/**
	 * 
	 */
	public final class CycleBlendModeUp extends Macro {
		
		/**
		 * 
		 */
		override public function keyDown():void {
			var layer:Layer	= (UIObject.selection as UILayer).layer;
			layer.blendMode		= BlendModes[Math.max(BlendModes.indexOf(layer.blendMode)-1,0)];
		}
	}
}