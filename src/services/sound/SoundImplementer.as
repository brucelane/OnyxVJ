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
package services.sound {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import services.sound.*;
	
	//use namespace onyx_ns;
	
	/**
	 * 
	 */
	public class SoundImplementer extends Sprite implements IParameterObject,ISoundImplementer {
		
		/**
		 * 	@private
		 */
		private var parameters:Parameters	= new Parameters(this as IParameterObject);
		
		//public var SP:SoundProvider = PluginManager.modules[ID].SP;
		public var mod:Object = PluginManager.modules[ID];
		
		/**
		 * 	@constructor
		 */
		public function SoundImplementer():void {
			
			//Console.output((SP is SoundProvider)+' / '+(PluginManager.modules[ID].SP is SoundProvider) );
			//SP = PluginManager.modules[ID].SP;// as SoundProvider;
			
			// add event listener
			mod.SP.addEventListener('sound', _onSndEvent);

		}
		
		private function _onSndEvent(e:Object):void {
			//onPeak(mod.SP.floatLR[0],mod.SP.floatLR[0]);
			onPeak(e.lr[0],e.lr[1]);
		}
		
		public function onPeak(l:Array,r:Array):void {
		}
		
		final public function getParameters():Parameters {
			return parameters;
		}
				
		public function dispose():void {
			mod.SP.removeEventListener('sound', _onSndEvent);
		}
				
	}
}
