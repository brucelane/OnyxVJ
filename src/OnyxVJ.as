/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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
package {
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	
	import onyx.asset.AssetFile;
	import onyx.core.ApplicationState;
	import onyx.core.Console;
	import onyx.core.Factory;
	import onyx.core.StateManager;
	import onyx.core.TempoImplementer;
	
	import onyx.plugin.DISPLAY_STAGE;
	import onyx.plugin.Display;
	import onyx.plugin.Tempo;
	import onyx.utils.file.writeLogFile;
	import onyx.utils.file.writeTextFile;
	
	import ui.controls.ButtonControl;
	import ui.controls.ColorPicker;
	import ui.controls.DropDown;
	import ui.controls.SliderV;
	import ui.controls.SliderV2;
	import ui.controls.SliderVFrameRate;
	import ui.controls.Status;
	import ui.controls.TextControl;
	import ui.controls.layer.LayerVisible;
	import ui.states.FirstRunState;
	import ui.states.InitializationState;
	import ui.states.KeyListenerState;
	import ui.states.ShowOnyxState;
	import ui.states.PauseState;
	import ui.states.QuitState;
	import ui.states.SettingsApplyState;
	import ui.states.SettingsLoadState;
	import ui.text.TextFieldCenter;
	import ui.text.TextFieldOnyx;
	
	//report the width and height values in Onyx-AIR-UI FirstRunState.as: window.width = 1280;
	[SWF(width="1600", height="900", backgroundColor="#141515", frameRate='60', systemChrome='none')]
	public final class OnyxVJ extends Sprite {
		
		/**
		 * 	@private
		 */
		private const states:Array	= [
			new FirstRunState(),
			new SettingsLoadState(),
			new InitializationState(),
			new SettingsApplyState(),
			new PauseState()
		];
		
		/**
		 * 	@constructor
		 */
		public function OnyxVJ():void {
			
			//global error handling for uncaught errors
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			writeLogFile( 'OnyxVJ start', true );
			// register classes for re-use
			Factory.registerClass(ButtonControl);
			Factory.registerClass(ColorPicker);
			Factory.registerClass(DropDown);
			Factory.registerClass(SliderVFrameRate);
			Factory.registerClass(SliderV);
			Factory.registerClass(SliderV2);
			Factory.registerClass(TextControl);
			Factory.registerClass(Status);
			Factory.registerClass(LayerVisible);
			Factory.registerClass(TextFieldOnyx);
			Factory.registerClass(TextFieldCenter);
			
			// init
			init();
			
		}
		
		/**
		 *	@private 
		 */
		private function init():void {
			
			// store stage
			DISPLAY_STAGE		= this.stage;
			Tempo				= new TempoImplementer();
			
			// quit on close
			stage.nativeWindow.addEventListener(Event.CLOSE, closeChildren);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, closeChildren);
			// check first run and setup
			checkFirstRun();
		}
		
		/**
		 * 	@private
		 */
		private function checkFirstRun():void {
			
			// load the initial states
			StateManager.loadState(new ShowOnyxState());
			
			// start the states
			queueState();
			
		}
		
		/**
		 * 	@private
		 */
		private function queueState(event:Event = null):void {
			
			if (event) {
				var state:ApplicationState = event.currentTarget as ApplicationState;
				state.removeEventListener(Event.COMPLETE, queueState);
			}
			
			state = states.shift() as ApplicationState;
			if (state) {
				state.addEventListener(Event.COMPLETE, queueState);
				StateManager.loadState(state);
			} else {
				
				// run the app
				start();
			}
		}
		
		/**
		 * 	@private
		 */
		private function start():void {
			
			const setup:ShowOnyxState = StateManager.getStates('startup')[0];
			
			// write to the startup.log file
			writeTextFile(new File(AssetFile.resolvePath('logs/start.log')), setup.getLogText());
			
			// remove the startup state
			StateManager.removeState(setup);
			
			// load default states
			StateManager.loadState(new KeyListenerState());		// listen for keyboard
			
			Display.pause(false);
		}
		
		/**
		 * 	@private
		 */
		private function closeChildren(event:Event):void {
			StateManager.loadState(new QuitState());
		}
		
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			var errorMessage:String; 
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				errorMessage = "Global Error: " + error.message + "\nType: " + error.name + "\nStack: " + error.getStackTrace();
				Console.output( errorMessage );
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				errorMessage = "global ErrorEvent:" + errorEvent.text;
				Console.output( errorMessage );
				
			}
			else
			{
				errorMessage = "global other error:" + event.toString();
				Console.output( errorMessage );
			}
			event.preventDefault();
			writeTextFile(new File(AssetFile.resolvePath('logs/errors.log')), errorMessage);
		}
		
		
		
	}
}
/*package  
{
	import benkuper.nativeExtensions.Spout;
	import benkuper.nativeExtensions.SpoutReceiver;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	public class OnyxVJ extends Sprite 
	{
		//spout stuff
		private var spout:Spout;
		private var sendName:String = "AIR Sender";
		private var receiver:SpoutReceiver;
		
		//drawing sprite
		private var s:Sprite;
		private var bd:BitmapData;
		private var bm:Bitmap;
		
		
		
		public function OnyxVJ() 
		{
			super();
			
			
			spout = new Spout();
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			bm = new Bitmap();
			
			stage.nativeWindow.x = 800;
			
			graphics.beginFill(0x00ffff);
			graphics.drawCircle(300, 300, 200);
			graphics.endFill();
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.SPACE: 
					spout.extContext.call("showPanel");
					break;
					
				case Keyboard.R:
					if(receiver != null) removeChild(receiver);
					receiver = spout.createReceiver("UniSpout2");
					if(receiver != null) addChild(receiver);
					break;
			}
		}
		
		private function enterFrame(e:Event):void 
		{
			if (receiver == null)
			{
				//receiver = spout.createReceiver("Reymenta Sphere Sender");
				receiver = spout.createReceiver("");
				trace("receiver Found ? ", receiver);
				if(receiver != null) addChild(receiver);
			}else
			{
				spout.receiveTexture(receiver);
			}
			
		}
		
	}

}*/