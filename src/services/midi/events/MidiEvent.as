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
 package services.midi.events {
 	
 	import flash.events.Event;
 	import flash.utils.ByteArray;
 	
	/**
	 * 	Midi event
	 */
	final public class MidiEvent extends Event {
		
		public static const DATA:String = 'midi_data';
		public static const BACK:String = 'midi_back';
		
		public var command:uint;
		public var channel:uint;
		public var data1:uint;
		public var data2:uint;
		
		public var midihash:uint;
		
		/**
		 * 
		 */
		public function MidiEvent(type:String):void {
			super(type);
		}
		
		/**
		 * 
		 */
		override public function clone():Event {
			
			var event:MidiEvent = new MidiEvent(type);
			event.command		 = command;
			event.channel		 = channel;
			event.data1          = data1;
			event.data2			 = data2;
			
			event.midihash       = midihash;
						
			return event; 
		}
	}
}