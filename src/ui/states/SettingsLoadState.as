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
package ui.states {
	
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.system.Capabilities;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.asset.air.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.utils.file.*;
	
	import ui.assets.StartupDisplay;
	import ui.controls.*;
	import ui.window.*;
	
	/**
	 * 
	 */
	public final class SettingsLoadState extends ApplicationState {

		/**
		 * 
		 */
		public static var SETTINGS_XML:XML;
				
		/**
		 * 
		 */
		override public function initialize():void {
			
			Console.output('*  LOADING SETTINGS  *\n');

			try 
			{
				var folderPath:String = File.documentsDirectory.resolvePath("Onyx-VJ/settings").nativePath;
				var folder:File = new File( folderPath );
				// creates folder if it does not exists
				if (!folder.exists) 
				{
					writeLogFile('Creating folder: ' + folderPath);
					// create the directory
					folder.createDirectory();
					if (!folder.exists) writeLogFile('Could not create folder: ' + folderPath);
				}
			
				var file:File = new File(AssetFile.resolvePath('settings/settings.xml'));
				writeLogFile('try loading: ' + AssetFile.resolvePath('settings/settings.xml'));
				
				// load settings file
				if (!file.exists) 
				{
					writeLogFile('does not exist: ' + AssetFile.resolvePath('settings/settings.xml'));
					writeLogFile('try loading: ' + AssetFile.resolvePath('settings/default.xml'));

					file = new File(AssetFile.resolvePath('settings/default.xml'));
					if (!file.exists) 
					{
						writeLogFile('does not exist: ' + AssetFile.resolvePath('settings/default.xml'));
						//try to copy from ProgramFiles
						var srcFile:File = File.documentsDirectory.resolvePath('Onyx-VJ' + File.separator + 'root/settings/default.xml' );
						if ( srcFile.exists )
						{
							srcFile.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
							srcFile.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );							
							srcFile.copyTo( file );	
							srcFile.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
							srcFile.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );							
							
						}					
						var sourceFile:File = File.documentsDirectory.resolvePath('Onyx-VJ' + File.separator + 'root/settings/settings.xml' );
						if ( sourceFile.exists )
						{
							sourceFile.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
							sourceFile.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );							
							sourceFile.copyTo( file );							
							sourceFile.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
							sourceFile.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );							
						}
					}
				}
				if (!file.exists) 
				{				
					throw new Error('settings.xml (or default.xml) file doesn\'t exist');
				}
				// read settings file
				SETTINGS_XML		= new XML(readTextFile(file));

				// create display width/height
				applyCoreSettings();
				
			} 
			catch (e:Error) 
			{
				writeLogFile('ERROR LOADING SETTINGS FILE:\n' + e.message);
				Console.output('ERROR LOADING SETTINGS FILE:\n', e.message);

			}
			
			// kill the state
			StateManager.removeState(this);
		}
		
		/**
		 * 	@private
		 */
		private function quitHandler(event:Event):void {

			// start quit cycle
			StateManager.loadState(new QuitState());

		}
		
		/**
		 * 	
		 */
		public function applyCoreSettings():void 
		{
			var targetWidth:int = 320;
			var newWidth:int	= Capabilities.screenResolutionX - 200;
			var newHeight:int	= Capabilities.screenResolutionY - 200;
			var newX:int		= 50;
			var newY:int		= 50;
			var ratio:int 		= 1;
			DISPLAY_FULLSCREEN	= 1;
			const core:XMLList	= SETTINGS_XML.core;
			var list:XMLList;			
			// store screens
			const screens:Array			= Screen.screens;
			const singleScreen:Boolean	= (screens.length === 1);

			// set default core settings
			if (core.hasOwnProperty('render')) 
			{
				list = core.render;
				if (list.hasOwnProperty('bitmapData'))
				{
					newWidth	= targetWidth = list.bitmapData.width;
					newHeight	= list.bitmapData.height;
					newX	= list.bitmapData.x;
					newY	= list.bitmapData.y;
					DISPLAY_FULLSCREEN = list.bitmapData.fullscreen;
				}										
			}	
			
			if (!singleScreen)
			{
				const screen:Screen		= screens[1];
				if (targetWidth > screen.bounds.width) targetWidth = screen.bounds.width;
				ratio 					= screen.bounds.width / targetWidth;
				if ( DISPLAY_FULLSCREEN == 1 )
				{
					newWidth				= screen.bounds.width / ratio;
					newHeight				= screen.bounds.height / ratio;				
				}
				if (newHeight > screen.bounds.height) newHeight = screen.bounds.height;
			}
			Onyx.initialize(DISPLAY_STAGE, newWidth, newHeight, list.quality || StageQuality.MEDIUM);
			
			// create the output display
			Display			= new OutputDisplay();		
		
			// if we have more than one screen present, we create a fullscreen output window
			// else we create a moveable window
			
			// create a new window to put the output window
			const options:NativeWindowInitOptions = new NativeWindowInitOptions();
			// BL options.systemChrome	= singleScreen ? NativeWindowSystemChrome.ALTERNATE : NativeWindowSystemChrome.NONE;
			options.systemChrome	= NativeWindowSystemChrome.NONE;
			options.transparent		= false;
			// BL options.type			= singleScreen ? NativeWindowType.UTILITY : NativeWindowType.LIGHTWEIGHT;
			options.type			= NativeWindowType.LIGHTWEIGHT;
			// BL 
			options.renderMode = 'direct';		
			writeLogFile('Capabilities.screenResolutionX and Y:' + Capabilities.screenResolutionX + " " + Capabilities.screenResolutionY);
			// create the window
			const displayWindow:NativeWindow	= new NativeWindow(options);
			displayWindow.width				= DISPLAY_WIDTH;
			displayWindow.height			= DISPLAY_HEIGHT;
			displayWindow.alwaysInFront		= true;
			
			const stage:Stage				= displayWindow.stage;//NULL on android
			if (stage) 
			{
				// no scale please thanks
				stage.align						= StageAlign.TOP_LEFT;
				stage.scaleMode 				= StageScaleMode.NO_SCALE;
				DISPLAY_STAGE.quality 			= stage.quality	= StageQuality.MEDIUM;
			}
			else
			{
				DISPLAY_STAGE.quality 			= StageQuality.MEDIUM;
			}
			// check how to create the output screen
			
				
			if (singleScreen)
			{
				// when NativeWindowType.UTILITY: displayWindow.bounds = new Rectangle( 0, 0, newWidth + 16, newHeight + 34 );
				displayWindow.bounds = new Rectangle( 0, 0, newWidth, newHeight );
				displayWindow.x = DISPLAY_X	= newX;
				displayWindow.y = DISPLAY_Y	= newY;
			}
			else
			{
				const screen1:Screen		= screens[1];	
				
				if ( DISPLAY_FULLSCREEN == 1 )
				{
					displayWindow.bounds = screen1.bounds;
				}
				else
				{
					displayWindow.bounds = new Rectangle( 0, 0, newWidth, newHeight );
					displayWindow.x = DISPLAY_X	= newX;
					displayWindow.y = DISPLAY_Y	= newY;
				}
				
			}
			
			// listen for a close
			displayWindow.addEventListener(Event.CLOSING, quitHandler, false, 0, true);
			
			if (stage)
			{
				// add the display to our new window
				stage.addChild(Display as DisplayObject);
				
				// turn on hardware accelleration for the output window
				// stage.displayState			= singleScreen ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN_INTERACTIVE;
				stage.fullScreenSourceRect	= new Rectangle(0, 0, DISPLAY_WIDTH, DISPLAY_HEIGHT);
				if ( singleScreen )
				{
					stage.displayState = StageDisplayState.NORMAL;					
				}
				else
				{
					if ( DISPLAY_FULLSCREEN == 1 )
					{
						stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;						
					}
					else
					{						
						stage.displayState = StageDisplayState.NORMAL;
					}
					
				}
			}
			displayWindow.activate();
			
			
//FIN
			/*if ( !singleScreen )
			{
				const screen:Screen		= screens[1];
				if (targetWidth > screen.bounds.width) targetWidth = screen.bounds.width;
				ratio 					= screen.bounds.width / targetWidth;
				newWidth				= screen.bounds.width / ratio;
				newHeight				= screen.bounds.height / ratio;
				if (newHeight > screen.bounds.height) newHeight = screen.bounds.height;
				
				Onyx.initialize(DISPLAY_STAGE, newWidth, newHeight, list.quality || StageQuality.MEDIUM);
				
			}
			else
			{
				// only one screen
				Onyx.initialize(DISPLAY_STAGE, newWidth, newHeight , list.quality || StageQuality.MEDIUM);

			}	
			const core:XMLList	= SETTINGS_XML.core;
			var list:XMLList;
			
			// set default core settings
			if (core.hasOwnProperty('render')) {
				
				list = core.render;
				
				var targetWidth:int 	= 320;
				var ratio:int 			= 1;
				var newWidth:int		= 320;
				var newHeight:int		= 240;
				if (list.hasOwnProperty('bitmapData'))
				{
					newWidth	= targetWidth = list.bitmapData.width;
					newHeight	= list.bitmapData.height;
				}
				//BL adapt bounds to real screen size
				
				
			}*/

			// add custom order for blendmodes
			if (core.hasOwnProperty('blendModes')) {
				
				list = core.blendModes;

				// remove all previous blend modes
				while (BlendModes.length) {
					BlendModes.pop();
				}
				
				// make new blend modes
				for each (var mode:XML in list.*) {
					BlendModes.push(String(mode.name()));
				}
				
			}
			
			list = core.cameras;
			if (list.length()) {
				ContentCamera.loadXML(list[0]);
			}
			list = core.videopong;
			if (list.length()) {
				ContentVideoPong.loadXML(list[0]);
			}
		}
		private function ioErrorHandler( event:IOErrorEvent ):void
		{
			writeLogFile( 'SettingLoadState, An IO Error has occured: ' + event.text );
		}    
		// only called if a security error detected by flash player such as a sandbox violation
		private function securityErrorHandler( event:SecurityErrorEvent ):void
		{
			writeLogFile( "SettingLoadState, securityErrorHandler: " + event.text );
		}
	}
}