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
package ui.controls {
	
	import onyx.events.*;
	import onyx.parameter.*;
	
	/**
	 * 	Slider Frame Rate
	 */
	public final class SliderVFrameRate extends SliderV {
		
		/**
		 * 	@private
		 */
		override protected function _onControlChange(event:ParameterEvent = null):void {
			value = event ? event.value.toFixed(2) : (parameter.value as Number).toFixed(2);
		}
		
		/**
		 * 
		 */
		override protected function set value(value:String):void {
			label.text = value + 'x';
		}
		
		/**
		 * 
		 */
		override public function reflect():Class {
			return SliderVFrameRate;
		}
	}
}