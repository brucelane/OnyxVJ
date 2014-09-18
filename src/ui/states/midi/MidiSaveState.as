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
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.ui.*;
	//import onyx.utils.file.*;
	
	import ui.window.*;
	
	/**
	 * 
	 */
	public final class MidiSaveState extends ApplicationState {
		
		/**
		 * 	@private
		 */
		private var xml:XML;
		
		/**
		 * 	@private
		 */
		private var data:BitmapData;
		
		/**
		 * 	@private
		 */
		private var dbSave:Boolean;
		private static var nowDate:String;
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
						
			// remove midi learn state, if there
			if(!StateManager.getStates('MidiLearnState')) {
				StateManager.removeState(StateManager.getStates('MidiLearnState')[0]);
			}
			
			// pause rendering
			StateManager.pauseStates(ApplicationState.KEYBOARD);
			
			// choose a directory
			const file:File = new File(AssetFile.resolvePath(ONYX_LIBRARY_PATH));
			file.browseForSave('Select the name and location of the mix file to save.');
			file.addEventListener(Event.SELECT, action);
			file.addEventListener(Event.CANCEL, action);
			
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
				
				var xml:XML = <midi/>;
				
				var meta:XML = <metadata />
				meta.appendChild(<version>{VERSION}</version>);
				xml.appendChild(meta);
				
				//Display.layers(0).
				
				/*var ctrlXML:XML = <controls />;
				var controls:Dictionary = UserInterface.getAllControls();
				var control:UserInterfaceControl;
				var i:Object;*/
					
				//xml.appendChild(Midi.toXML());
				
				/*for (i in Midi.controlsSet) {
					if (i!='null') {
						control	= i as UserInterfaceControl;
						//ctrlXML.appendChild(control.getParameter().name);
						//control.getParameter().getMetaData(Midi.tag));
						//ctrlXML.appendChild(control.getParameter().value);
						ctrlXML.appendChild(control.getParameter().toXML());
						//control.getParameter().parent.
							
						
						/* transform					= control.transform;
						_storeTransform[control]	= Midi.controlsSet[control];
						transform.colorTransform	= _storeTransform[control]; //MIDI_HIGHLIGHT_SET;
					}
				}
				xml.appendChild(ctrlXML);*/
				
				xml.appendChild(MidiWindow.toXML());
				
				/* var x:XML;
				for (var p:String in Parameters.getGlobalRegisteredParameters()) {
					 x = new XML( Parameters.getRegisteredParameter(p).toXML() );
					log("p:"+p)
					log("ptoXML:"+Parameters.getRegisteredParameter(p).toXML())
					//x.nodeValue = Parameters.getRegisteredParameter(p).getMetaData('midi');
					x.@paramspace = p;
					xml.appendChild(x); 
					var x1:XML = <parameters/>
					x1.@paramspace = p;
					var ti:int=0;
					for (var par:String in Parameters.getRegisteredParameter(p) ) {
						Console.output(par);
						log(ti.toString()+"par:"+par+"Parameters.getRegisteredParameter(par)"+Parameters.getRegisteredParameter(par));
						if (Parameters.getRegisteredParameter(par)) {
							var xp:XML;
							
							xp = new XML( Parameters.getRegisteredParameter(par).toXML() );
							xp.appendChild( (Parameters.getRegisteredParameter(par) as Parameter).getMetaData('midi'));
							x1.appendChild(xp);
						}
						else log("Parameters.getRegisteredParameter(par) null");
						ti++;
					}
				} */
				/*var x:XML;
				for (var p:String in Parameters.getGlobalRegisteredParameters()) {
					/* x = new XML( Parameters.getRegisteredParameter(p).toXML() );
					x.nodeValue = Parameters.getRegisteredParameter(p).getMetaData('midi');
					x.@paramspace = p;
					xml.appendChild(x); //* /
					var x1:XML = <parameters/>
					x1.@paramspace = p;
					for (var par:String in Parameters.getRegisteredParameter(p) ) {
						Console.output(par);
					//	x = new XML( Parameters.getRegisteredParameter(par).toXML() );
					//	x.appendChild( (Parameters.getRegisteredParameter(par) as Parameter).getMetaData('midi'));
					//	x1.appendChild(x);
					}
					//xml.appendChild(x1);
					xml.appendChild(x1);
				}
				xml.appendChild(x);	*/			
				// BL writeTextFile(file, xml);
				
			}
			
			StateManager.removeState(this);
			
		}
		
		/**
		 * 	@private
		 */
		private function onSave(query:AssetQuery, list:Array):void {

			/*var browser:Browser = WindowRegistration.getWindow('FILE BROWSER') as Browser;
			if (browser) {
				browser.updateFolders();
			}*/
			
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