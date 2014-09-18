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
package ui.states.midi {
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.utils.Dictionary;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;
		
	import services.midi.ui.styles.*;
	
	import services.midi.*;
	import services.midi.events.*;
	
	public final class MidiLearnState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var _control:UserInterfaceControl;
		
		/**
		 * 	@private
		 */
		//private var _layer:UILayer;
		
		/**
		 * 	@private
		 * 	Store the transformations for all UIControls
		 */
		//private var _storeTransform:Dictionary;
		
		/**
		 * 	@constructor
		 */
		public function MidiLearnState():void {
			super('MidiLearnState');							
		}
		
		public var controls:Dictionary = UserInterface.getAllControls();
		
		/**
		 * 	initialize
		 */
		override public function initialize():void {

			// check for state registered, reload
			if(!StateManager.getStates('MidiLearnState')) {
				Console.output('reloaded');
				StateManager.loadState(this);
			}
						
			var i:Object;
			var control:UserInterfaceControl;
			var transform:Transform;
			
			//if(_storeTransform)
			//	_storeTransform = new Dictionary(true);
			
			if(!Midi.controlsSet)
				Midi.controlsSet = new Dictionary(true);

			// Highlight all the controls
			for (i in controls) {
				(i as UserInterfaceControl).transform.colorTransform = 
					MIDI_HIGHLIGHT;
			}		
			// Highlight already set
			for(i in Midi.controlsSet) {
				if (i!='null') {
					(i as UserInterfaceControl).transform.colorTransform = Midi.controlsSet[control];
				}
			}
						
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true, 9999);
		}
		
		
		/**
		 * 	@private
		 */
		private function _onControlSelect(event:MouseEvent):void {
			var clicked:DisplayObject = event.target as DisplayObject;

			_control = null;
			Midi.instance.removeEventListener(MidiEvent.DATA, _onMidi);

			while (clicked !== DISPLAY_STAGE) {
				if (clicked is UserInterfaceControl) {
					_control = clicked as UserInterfaceControl;
					break;
				}
				clicked = clicked.parent;
			}
			
			// success, start the next process
			if (_control) {
				Midi.instance.addEventListener(MidiEvent.DATA, _onMidi);
				_control.addEventListener(KeyboardEvent.KEY_DOWN, _onKey);
				
				// un-highlight everything
				_unHighlight();
				
				// re-highlight the selected control
				//var transform:Transform		= _control.transform;
				//_storeTransform[_control]	= transform.colorTransform;
				_control.transform.colorTransform	= MIDI_HIGHLIGHT;
							
			} else {
				// Clicked outside any control - abort learning
				StateManager.removeState(this);
			}
			// stop propagation
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 */
		private function _onMidi(event:MidiEvent):void {
			// new register
			Midi.controlsSet[_control] = 
				Midi.registerControl(_control.getParameter(), event.midihash);
			
			_control.transform.colorTransform = Midi.controlsSet[_control];
			
			// reset and wait for another midi control
			_control.removeEventListener(KeyboardEvent.KEY_DOWN, _onKey);
			StateManager.removeState(this);
			initialize();
		}
		
		/**
		 * 	Remove state
		 */
		override public function terminate():void {
			
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _onControlSelect, true);
			Midi.instance.removeEventListener(MidiEvent.DATA, _onMidi);
			_unHighlight();
	   		
	   		//_storeTransform = null;	
			
		}
		
		/**
		 * 	@private
		 */
		private function _onKey(event:KeyboardEvent):void {
					
			// if DELETE
			if(event.charCode == 127) {
				
				// if mapped
				if(_control.getParameter().getMetaData(services.midi.ID)) {
					
					Midi.controlsSet[_control] = MIDI_HIGHLIGHT;
					Midi.unregisterControl(_control.getParameter().getMetaData(services.midi.ID) as uint);
					
					StateManager.removeState(this);
					initialize();
						
				}
				
			}
			
		}

    	/**
    	 * 	@private
    	 */
		private function _unHighlight():void {
			
			//var controls:Dictionary = UserInterface.getAllControls();
			var control:UserInterfaceControl
			var i:Object;
			
			for (i in controls) {
				control = i as UserInterfaceControl;
				//var color:ColorTransform	= _storeTransform[control];
				//if (color) {
					//var transform:Transform		= control.transform;
					control.transform.colorTransform	= new ColorTransform(1,1,1,1);
					//delete _storeTransform[control];
				//}
			} 
			
		}
		
	}
}