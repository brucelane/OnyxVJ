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
package onyx.plugin {
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	A Visualizer plug-in is a plugin that will respond to audio events
	 */
	public class Visualizer extends PluginBase implements IRenderObject {

		/**
		 * 
		 */
		public function render(info:RenderInfo):void {
		}
		
		/**
		 * 
		 */
		final override public function toString():String {
			var rt:String;
			if (_plugin) rt=_plugin.name;
			return 'onyx-visualizer://' + rt;
		}
	}
}