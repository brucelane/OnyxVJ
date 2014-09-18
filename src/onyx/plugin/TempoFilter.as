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
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.core.TempoBeat;
	import onyx.core.onyx_ns;
	import onyx.events.ParameterEvent;
	import onyx.events.TempoEvent;
	import onyx.parameter.Parameter;
	import onyx.parameter.ParameterInteger;
	import onyx.parameter.ParameterTempo;
	
	use namespace onyx_ns;
	
	/**
	 * 	Base Tempo Filter class.  Extend this class if you'd like your filter to respond to the tempo.
	 * 
	 * 	@see onyx.plugin.Filter
	 * 	@see onyx.core.Tempo
	 */
	public class TempoFilter extends Filter {
		
		/**
		 * 	@private
		 */
		protected static const GLOBAL_TEMPO_CONTROL:Parameter	= Tempo.getParameter('snapTempo');
		
		/**
		 * 	@private
		 */
		protected var timer:Timer;
		
		/**
		 * 	@private
		 */
		protected var _delay:int					= 100;
		
		/**
		 * 	@private
		 * 	The beat signature to snap to
		 */
		private var _snapBeat:int;
		
		/**
		 * 	@private
		 * 	The control that handles tempo
		 */
		private const snapControl:ParameterTempo	= new ParameterTempo('snapTempo', 'Snap Tempo')

		/**
		 *	@private 
		 */
		private const GLOBAL_TEMPO:TempoBeat		= TempoBeat.BEATS['global'];
		
		/**
		 * 	@private
		 */
		private var _snapTempo:TempoBeat			= GLOBAL_TEMPO;
				
		/**
		 * 	@private
		 * 	The delay control
		 */
		private var delayControl:ParameterInteger	= new ParameterInteger('delay', 'delay', 1, 5000, 0, .001, 25);

		/**
		 * 	@private
		 */
		protected const BEATS:Array					= [GLOBAL_TEMPO].concat(ONYX_TEMPOS);;
		
		/**
		 * 	@constructor
		 */
		public function TempoFilter():void {
			
			// add params
			parameters.addParameters(snapControl, delayControl);
			
		}
		
		/**
		 * 
		 */
		override final public function set muted(value:Boolean):void {
			super.muted = value;
			initialize();
		}
		
		/**
		 * 	listen
		 */
		override public function initialize():void {
			
			// remove handlers, start from scratch
			_cleanHandlers();
			
			// if valid tempo, listen for clicks, otherwise, it's set to none
			// and we should use the timer delay
			if (_snapTempo) {

				// if the tempo is the global tempo, grab it's value, and listen for the global
				// tempo events
				if (_snapTempo === GLOBAL_TEMPO) {
					
					// listen for changes
					GLOBAL_TEMPO_CONTROL.addEventListener(ParameterEvent.CHANGE, _globalTempoHandler);
						
					// sync to the global tempo
					_setTempo(GLOBAL_TEMPO_CONTROL.value);

				}
				
			} else {
				
				// remove listener
				GLOBAL_TEMPO_CONTROL.removeEventListener(ParameterEvent.CHANGE, _globalTempoHandler);
				
				_setTempo(null);

			}
		}

		/**
		 * 	@private
		 */
		private function _setTempo(value:TempoBeat):void {
			
			// only listen for events if we're not muted
			if (content && !_muted) {
				
				if (value) {
					
					_snapBeat = value.mod;
					Tempo.addEventListener(TempoEvent.CLICK, onTempo);
					
				} else {
				
					timer = new Timer(_delay);
					timer.start();
					timer.addEventListener(TimerEvent.TIMER, onTimer);
					
				}
			}
		}

		/**
		 * 	@private
		 */
		private function _cleanHandlers():void {
			
			// remove tempo stuff
			Tempo.removeEventListener(TempoEvent.CLICK, onTempo);
			
			// remove timer
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer.stop();
				timer = null;
			}
		}
		
		/**
		 * 	@private
		 * 	When the global tempo changes
		 */
		private function _globalTempoHandler(event:ParameterEvent):void {
			
			_cleanHandlers();
			
			// set the beat
			const tempo:TempoBeat = event.value;
			_snapBeat	= tempo ? tempo.mod : null;
			
			// update all effects listening for tempo
			snapControl.dispatch(GLOBAL_TEMPO);
			
			// re-initialize the filter
			_setTempo(event.value);
		}
		
		/**
		 * 	Sets delay
		 */
		final public function set delay(value:int):void {
			_delay = delayControl.dispatch(value);
			
			if (timer) {
				timer.delay = _delay;
			}
		}
		
		/**
		 * 	Sets delay
		 */
		final public function get delay():int {
			return _delay;
		}
		
		/**
		 * 	Whether or not the filter snaps to beat
		 */
		final public function set snapTempo(value:TempoBeat):void {
						
			// remove handlers, start from scratch
			_cleanHandlers();
			
			// if the global tempo is being passed in, store it
			if (value === GLOBAL_TEMPO) {
				
				// store it in the control, so it can dispatch a change event
				_snapTempo	= snapControl.dispatch(value);
				
				// listen for global tempo changes
				GLOBAL_TEMPO_CONTROL.addEventListener(ParameterEvent.CHANGE, _globalTempoHandler);
				
				// set our tempo to the global
				_setTempo(GLOBAL_TEMPO_CONTROL.value);

			} else {
				
				// remove listener
				GLOBAL_TEMPO_CONTROL.removeEventListener(ParameterEvent.CHANGE, _globalTempoHandler);

				_snapTempo	= snapControl.dispatch(value);
				_setTempo(value);
				
			}
		}
		
		/**
		 * 	Used by other filters to determine when the next firing will happen
		 */
		final protected function get nextDelay():int {
			return _snapTempo ? (_snapBeat * _delay) : timer.delay;
		}
		
		/**
		 * 	Get the associated beat it's snapping on
		 */
		final public function get snapTempo():TempoBeat {
			return _snapTempo;
		}
		
		/**
		 * 	@private
		 */
		final protected function onTempo(event:TempoEvent):void {
			if (event.beat % _snapBeat === 0) {
				onTrigger(event.beat, event);
			}
		}
		
		/**
		 * 	@private
		 */
		final protected function onTimer(event:TimerEvent):void {
			onTrigger((event.currentTarget as Timer).currentCount, event);
		}

		/**
		 * 	@private
		 */
		protected function onTrigger(beat:int, event:Event):void {
		}

		/**
		 * 	Dispose
		 */
		override public function dispose():void {

			_cleanHandlers();
			
			super.dispose();
			
		}
		
		/**
		 * 
		 */
		final override onyx_ns function clean():void {

			// remove listener
			GLOBAL_TEMPO_CONTROL.removeEventListener(ParameterEvent.CHANGE, _globalTempoHandler);

		}
	}
}