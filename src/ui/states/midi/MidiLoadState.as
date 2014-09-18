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
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import services.midi.*;
	import services.midi.events.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.UserInterface;
	import onyx.ui.UserInterfaceControl;
	import onyx.utils.string.*;
	import onyx.utils.file.*;
	
	import ui.window.MidiWindow;
		
	/**
	 * 
	 */
	public final class MidiLoadState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var data:BitmapData;
		
		/**
		 * 	@private
		 */
		private var dbSave:Boolean;
		private var xml:XML;
		
		/**
		 * 
		 */
		public static var MIDI_XML:XML;
		private static var nowDate:String;
		
		private var _control:UserInterfaceControl;
		private var controls:Dictionary;
		/**
		 * 	@constructor
		 */
		public function MidiLoadState():void {
			super('MidiLoadState');					
		}
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			
			if(!Midi.controlsSet) {
				Midi.controlsSet = new Dictionary(true);	
			}
			
			// pause rendering
			//StateManager.pauseStates(ApplicationState.DISPLAY_RENDER);
			StateManager.pauseStates(ApplicationState.KEYBOARD);
			
			controls = UserInterface.getAllControls();
			
			// choose a directory
			var file:File = new File(AssetFile.resolvePath(ONYX_LIBRARY_PATH));
			file.browseForOpen('Select the name and location of the MIDI file to load.');
			file.addEventListener(Event.SELECT, action);
			file.addEventListener(Event.CANCEL, action);
			
			StateManager.removeState(this);
			
		}
				
		/**
		 * 	@private
		 */
		private function action(event:Event):void {
			
			if (event.type === Event.SELECT) {
				var file:File = event.currentTarget as File;
				
				if (file.type !== '.mid') {
					file = new File(file.nativePath + '.mid');
				}
				
				MidiWindow.fromXML(new XML(readTextFile(file)));
									
			}
			
			StateManager.removeState(this);
		}
						
		/**
		 * 
		 */
		override public function terminate():void {
			StateManager.resumeStates(ApplicationState.KEYBOARD);
		}
	}
}
