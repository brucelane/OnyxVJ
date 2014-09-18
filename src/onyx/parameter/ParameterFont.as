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
	
	import flash.text.Font;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	This control will display available fonts to the user.  This will dispatch a flash.text.Font value to the IParameterObject
	 * 
	 * 	@see onyx.core.IParameterObject
	 */
	public final class ParameterFont extends ParameterArray {
		
		/**
		 * 	@constructor
		 */
		public function ParameterFont(name:String, display:String):void {
			super(name, display, PluginManager.fonts, 0, 'fontName');
		}
		
		/**
		 * 	Loads the value from xml
		 */
		override public function loadXML(xml:XML):void {
			value = PluginManager.createFont(xml);
		}
		
		/**
		 * 
		 */
		override public function toXML():XML {
			var xml:XML = <{name}/>;
			var font:Font = this.value;
			xml.appendChild((font) ? font.fontName : font);
			
			return xml;
		}
	}
}