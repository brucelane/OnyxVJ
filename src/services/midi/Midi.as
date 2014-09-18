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
package services.midi {
	
	import services.midi.events.MidiEvent;
	
	import flash.geom.*;
	import flash.utils.*;
	import flash.events.*;

	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
						
	import services.midi.ui.styles.*;
	
	final public class Midi extends Module {
		
		public static const NOTE_OFF:int                  = 0x80;//128
		public static const NOTE_ON:int                   = 0x90;//144
        public static const POLYPHONIC_KEY_PRESSURE:int   = 0xa0;//160
        public static const CONTROL_CHANGE:int            = 0xb0;//176
        public static const PROGRAM_CHANGE:int            = 0xc0;//192 
        public static const KEY_PRESSURE:int              = 0xd0;//208
        public static const PITCH_WHEEL:int               = 0xe0;//224
        public static const SYSTEM_MESSAGE:int            = 0xe0;
                           
		/**
		 * 	Instance
		 */
		public static const instance:Midi 		= new Midi();
		private static const REUSABLE:MidiEvent	= new MidiEvent(MidiEvent.DATA);
				
		/**
		 * 	Move layer's MIDI
		 */
		private static var _moveEvents:int = 0;
		private static var _layerFrom:Layer;
		private static var _layerTo:Layer;
		private static var _backupTo:Dictionary;
		
		/**
		 * 	Store styles for already set UIcontrol
		 */
		public static var controlsSet:Dictionary;
		
		/**
		 * 	Behavior/midihash crossmap
		 */
		private static var _map:Dictionary;
		
		/**
		 * 	Busy flag
		 */
		private static var busy:Boolean		= false;
		private static var started:Boolean 	= false;
		        
		private static var _timer:Timer;
		
		/**
		 * 	@constructor
		 */
		public function Midi():void {
			
			// check unique
			if (instance)
				throw new Error('');
						
			_map = new Dictionary(false);
			
			_timer = new Timer(1000,10);
			_timer.addEventListener(TimerEvent.TIMER, _addListeners);
			_timer.start();
						
			busy 	= false;
			started = true;			
		}
									        
		private static function _addListeners(e:Event):void {
			if(Display) {
				// add listeners
				for each(var layer:LayerImplementor in Display.layers) {
					layer.addEventListener(LayerEvent.LAYER_MOVE, _swapLayers);
					for each(var ctrl:Parameter in layer.getProperties())
					ctrl.addEventListener(ParameterEvent.CHANGE, _parChanged);
				}
				// remove timer
				_timer.removeEventListener(TimerEvent.TIMER, _addListeners);
				_timer.stop();
				_timer = null;
			} else {
				
			}
		}
		
		public static function registerControl(control:Parameter, midihash:uint):ColorTransform {
			
			if(control && midihash) {
            	// check if alredy have this midihash
				for (var val:Object in _map) {
					if(val==midihash.toString() ) {
						if (_map[val]) {
							//controlsSet[(_map[val].control as Parameter).getMetaData(ID)] = MIDI_HIGHLIGHT;
							unregisterControl(midihash);
						}
					}
				}
								
	            // store the hash inside CONTROL
	            control.setMetaData(ID, midihash);
				//controlsSet[control] = MIDI_HIGHLIGHT_SET;
				
	            // based on the control and the command type, create behaviors
	            var behavior:IMidiControlBehavior;
	                                          
				switch((midihash>>8)&0xF0) {
					case NOTE_OFF:	// toggle messages -- need to add note on, note off behavior
						break;
					case NOTE_ON:
						if (control is ParameterExecuteFunction) {
							behavior = new ExecuteBehavior(control as ParameterExecuteFunction);
						} else if (control is ParameterNumber) {
							behavior = new NumericBehavior(control as ParameterNumber);
						} else if (control is ParameterArray) {
							behavior = new NumericRange(control as ParameterArray);
						}
						_map[midihash] = behavior;
						break;
					case CONTROL_CHANGE: // slider value messages
					case PITCH_WHEEL:
						if (control is ParameterNumber) {
							behavior = new NumericBehavior(control as ParameterNumber);
						} else if (control is ParameterArray) {
							behavior = new NumericRange(control as ParameterArray);
						}
						_map[midihash] = behavior;
				
						break;
					case SYSTEM_MESSAGE: // system message -- what to do?
						break;
				}	
				//do style
				return MIDI_HIGHLIGHT_SET;	
            }
            // error
            return null;
		}
		
		public static function unregisterControl(midihash:uint):void {
			if (_map[midihash]) {
				delete _map[midihash].control.getMetaData(ID);			
				delete _map[midihash];
			}           
		}
			
				
		/**
		 *  swap layers
		 **/
		public static function _swapLayers(event:LayerEvent):void {
			
			_moveEvents++;
                           
            if(_moveEvents==1) {
            	
            	_layerTo 	= event.target as LayerImplementor;
            	_backupTo 	= _backupControls(_layerTo.getProperties());
            		
            } else if(_moveEvents==2) {
            	
            	_layerFrom 	= event.target as LayerImplementor;	
            	
            	for each(var controlTo:Parameter in _layerTo.getProperties()) {
            		controlTo.setMetaData(ID, _layerFrom.getProperties().getParameter(controlTo.name).getMetaData(ID));
            		registerControl( controlTo,
            						 controlTo.getMetaData(ID) as uint );	
            	}
            	for each(var controlFrom:Parameter in _layerFrom.getProperties()) {
            		controlFrom.setMetaData(ID, _backupTo[controlFrom.name]);
            		registerControl( controlFrom,
            						 controlFrom.getMetaData(ID) as uint );
            	}
            		
            	_moveEvents = 0; 
            }
            
        }
        
		
		
		/**
		 *      RX/TX MIDI message to controller(via proxy)
		 */		
		public static function rxMessage(data:ByteArray):void {
			
			// this avoid loops on 2way communication: this tells that changes in parameter's value are coming from midi
			// so we avoid (see private _parChange()) to send back signal to midi controller in loop
			busy = true;
			
			var status:uint      = data.readUnsignedByte();
			var command:uint     = status&0xF0;
			var channel:uint     = status&0x0F; 
			var data1:uint       = data.readUnsignedByte(); // SC: if CC this contains MIDI Channel Number
			var data2:uint       = data.readUnsignedByte();
			
			var midihash:uint    = ((status<<8)&0xFF00) | data1&0xFF; // SC: was ((status<<8)&0xFF00);
			
			var behavior:IMidiControlBehavior = _map[midihash]; 
						
			if(behavior) {
				switch(command) {
					case NOTE_OFF:
						break;
					case NOTE_ON:
						behavior.setValue(data1);
						break;
					case PITCH_WHEEL:
						behavior.setValue(data1);
						break;
					case CONTROL_CHANGE: // SC: if CC then "channel" has values 0-15 for midi channels 1-16 
						behavior.setValue(data2);
						break;
					default:
						behavior.setValue(data1);
				}
			}
			
			if(instance.hasEventListener(MidiEvent.DATA)) {
				REUSABLE.command        = command;
				REUSABLE.channel        = channel;
				REUSABLE.data1          = data1;
				REUSABLE.data2          = data2;
				REUSABLE.midihash       = midihash;
				instance.dispatchEvent(REUSABLE);
			}
			
			// this tells that the incoming midi is up
			busy = false;
		}
		
		public static function txMessage(midihash:uint, value:Number):void {
			var bytes:ByteArray = new ByteArray();
			bytes[0] = ((midihash>>8)&0xFF);
			bytes[1] = midihash&0xFF;
			bytes[2] = value;
			PluginManager.modules[ID].sendData(bytes);
		}  
		
		/**
		 *  parameter changed
		 **/
		public static function _parChanged(event:ParameterEvent):void {
			
			// ok, change is not coming from midi controller, so we send to it to allow 2way communication
			if(busy==false) {
				var par:Parameter = event.target as Parameter;
				Midi.txMessage(par.getMetaData(ID) as uint, event.value*127);
			}
						
		}
		
        private static function _backupControls(controls:Parameters):Dictionary {
			
        	var _hashes:Dictionary = new Dictionary(false);
        	for each(var control:Parameter in controls) {
        		_hashes[control.name] = control.getMetaData(ID); 
        	}
        	return _hashes;
        	
        }
		
	}
}
	