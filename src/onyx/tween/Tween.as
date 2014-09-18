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
package onyx.tween {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.tween.easing.*;
	import onyx.utils.*;
	import onyx.utils.event.*;
	
	use namespace onyx_ns;

	[Event(name='complete', type='flash.events.Event')]

	/**
	 * 		Custom Tween Class
	 */
	public final class Tween extends EventDispatcher {
		
		/**
		 * 	@private
		 * 	Stores definitions for tweens
		 */
		private static const _definition:Dictionary	= new Dictionary(true);
		
		/**
		 * 	Stops tween for a particular object
		 */
		public static function stopTweens(target:Object):void {
			const existing:Dictionary = _definition[target];
			
			if (existing) {
				for each (var tween:Tween in existing) {
					tween.stop();
				}
				
				delete _definition[target];
			}
		}
		
		/**
		 * 	Stops all existing tweens
		 */
		public static function stopAllTweens():void {
			for (var target:Object in _definition) {
				for each (var tween:Tween in _definition[target]) {
					tween.stop();
				}
				delete _definition[target];
			}
		}
		
		/**
		 * 	@private
		 * 	Target object the tween should be applied to
		 */
		private var _target:Object;

		/**
		 * 	@private
		 * 	Target object the tween should be applied to
		 */
		private var _props:Array;

		/**
		 * 	@private
		 * 	Target object the tween should be applied to
		 */
		private var _startTime:int;

		/**
		 * 	@private
		 * 	Target object the tween should be applied to
		 */
		private var _ms:int;
		
		/**
		 * 	@constructor
		 */
		public function Tween(target:Object, ms:int, ... args:Array):void {
			
			// register the tween to the _definitions array
			const existing:Dictionary = _definition[target];
			
			if (existing) {
				existing[this]		= this;
			} else {
				var dict:Dictionary = new Dictionary(true);
				dict[this]			= this;
				_definition[target] = dict;
			}
			
			_props = args;
			_target = target;
			_ms = ms;
			
			restart();
		}
		
		/**
		 * 
		 */
		public function restart():void {
			
			// listen every frame
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, _onTimer, false, 1000);
			_startTime = getTimer();
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:Event):void {
			
			const curTime:int = getTimer() - _startTime;
			
			// apply values
			for each (var prop:TweenProperty in _props) {
				var args:Array		= [Math.min(curTime, _ms), 0, prop.end - prop.start, _ms];
				var fn:Function		= prop.easing || Linear.easeIn;
				var value:Number 	= fn.apply(null, args) + prop.start;
			
				_target[prop.property] = value;
			}
			
			if (curTime >= _ms) {
				
				stop();
				dispatchEvent(EVENT_COMPLETE);
			}
		}
		
		/**
		 * 	Stops the tween
		 */
		public function stop():void {

			const existing:Dictionary = _definition[_target];
			
			if (existing) {
				delete existing[this];
			}
			
			DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, _onTimer);
		}
		
		/**
		 * 
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void {
			super.addEventListener(type, listener, useCapture, priority, true);
		}
		
		/**
		 * 
		 */
		public function get target():Object {
			return _target;
		}
		
		/**
		 * 
		 */
		public function get props():Array {
			return _props;
		}
	}
}