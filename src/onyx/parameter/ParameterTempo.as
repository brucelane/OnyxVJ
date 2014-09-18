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
	import onyx.events.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;

	/**
	 * 	Displays available tempo beats that the user-defined object can sync to.  Current values are: 16th note, eighth note, quarter note, half note, whole note.
	 * 
	 * 	@see onyx.core.IParameterObject
	 */
	public final class ParameterTempo extends ParameterArray {
		
		/**
		 * 	@private
		 */
		private var _defaultvalue:uint;
		
		/**
		 * 
		 */

		/**
		 * 	@constructor
		 */
		public function ParameterTempo(name:String, display:String, showGlobal:Boolean = true):void {
			
			super(name, display, showGlobal ? ONYX_TEMPOS_WITHGLOBAL : ONYX_TEMPOS, 0, null);
			
		}

		/**
		 * 
		 */
		override public function dispatch(v:*):* {
			REUSABLE_EVENT.value = v;
			dispatchEvent(REUSABLE_EVENT);
			return v;
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			REUSABLE_EVENT.value = v; 
			dispatchEvent(REUSABLE_EVENT);
			_target[name] = v;
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ParameterTempo;
		}
		
		/**
		 * 	Loads xml
		 */
		override public function loadXML(xml:XML):void {
			var beat:TempoBeat = TempoBeat.BEATS[xml.toString()];
			value = beat;
		}
	}
}