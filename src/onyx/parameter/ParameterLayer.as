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
	import onyx.display.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	This class will display available layers and their path names.  Use this control if you'd like
	 * 	your filter or plug-in to use another layer as its' source.  For example, once you have a layer, you can
	 * 	read the layer.source (bitmapdata) or layer.source (bitmapdata before rendering filters)
	 * 
	 * 	@see onyx.core.IParameterObject
	 */
	public final class ParameterLayer extends ParameterArray {
		
		/**
		 * 	@constructor
		 */
		public function ParameterLayer(name:String, displayName:String):void {
			super(name, displayName, Display ? Display.layers : null, null);

		}
		
		/**
		 * 
		 */
		override public function toXML():XML {
			const xml:XML			= <{name}/>;
			const layer:Layer	= this.value;
			
			if (value) {
				xml.appendChild(layer.index);
			}
			
			return xml;
		}
		
		/**
		 * 
		 */
		override public function loadXML(xml:XML):void {
			const num:int = int(xml.toString());
			const layer:Layer = Display.layers[num];
			if (layer) {
				value = layer;
			} 
		}

		/**
		 * 
		 */
		override public function set value(v:*):void {
			_target[name] = REUSABLE_EVENT.value = v;
			dispatchEvent(REUSABLE_EVENT);
		}
 		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterLayer;
		}
	}
}