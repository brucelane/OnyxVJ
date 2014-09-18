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
	
	import flash.events.*;
	import flash.utils.Timer;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	
	import services.sound.*;
	import services.sound.events.*;
	
	use namespace onyx_ns;
	
	
	// 2011.03.13 SC : TODO !!!!
	
	/**
	 * 	Base Sound Filter class.  Extend this class if you'd like your filter to respond to the sound.
	 * 
	 * 	@see onyx.plugin.Filter
	 * 
	 */
	public class SoundFilter extends Filter implements ISoundImplementer {
		
		public var mod:Object = PluginManager.modules[ID];
		
		/**
		 * 	@constructor
		 */
		public function SoundFilter():void {
			
			// add params
			//parameters.addParameters(snapControl, delayControl);
			parameters.addParameters(
				/*new ParameterInteger('bass', 'bass', 0, 100, 30),
				new ParameterInteger('mid', 'mid', 0, 100, 30),
				new ParameterInteger('high', 'high', 0, 100, 30)*/
			);
			
			
			
		}
		
		override public function initialize():void {
			// add event listener
			mod.SP.addEventListener(SoundEvent.SOUND, _onSndEvent);
		}
		
		private function _onSndEvent(e:SoundEvent):void {
			onPeak(e.lr[0],e.lr[1]);
		}
		
		public function onPeak(l:Array,r:Array):void {
		}
		
				
		/**
		 * 
		 */
		override final public function set muted(value:Boolean):void {
			super.muted = value;
			initialize();
		}
		
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			mod.SP.removeEventListener(SoundEvent.SOUND, _onSndEvent);
		}
		
		/**
		 * 
		 */
		final override onyx_ns function clean():void {
			// remove listener
			//GLOBAL_TEMPO_CONTROL.removeEventListener(ParameterEvent.CHANGE, _globalTempoHandler);
		}
	}
}