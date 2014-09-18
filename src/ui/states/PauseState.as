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
	
	import flash.events.*;
	import flash.filesystem.File;
	import flash.utils.*;
	
	import onyx.asset.AssetFile;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.jobs.LoadONXJob;
	import onyx.plugin.*;
	
	import ui.window.*;
	
	/**
	 * 
	 */
	public final class PauseState extends ApplicationState {
		
		public static var useTransition:Transition;
		/**
		 * 	@private
		 */
		private var startTime:int;
		
		/**
		 * 
		 */
		override public function initialize():void {
			startTime = getTimer();
			
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME,		pauseHandler);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_DOWN,	pauseHandler);
		}
		
		/**
		 * 	@private
		 */
		private function pauseHandler(event:Event):void {
			//if (event.type === MouseEvent.MOUSE_DOWN || getTimer() - startTime > DEBUG::SPLASHTIME) {
			if (event.type === MouseEvent.MOUSE_DOWN || getTimer() - startTime > 0) {
				
				DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, pauseHandler);
				DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, pauseHandler);
	
				// register the default state
				WindowState.load(
					WindowState.getState('DEFAULT')
				);
				
				// create the bottom buttons
				var window:MenuWindow = new MenuWindow(null);
				window.createButtons(6, 716);
				
				// load menu bar
				DISPLAY_STAGE.addChild(window);
				
				// we're initialized
				INITIALIZED = true;
				 
				// create layers
				(Display as OutputDisplay).createLayers(6);
				
				//load default.onx
				var defaultFile:File = new File( AssetFile.resolvePath( 'library/default.onx' ) );
				if ( defaultFile.exists )
				{
					const layer:LayerImplementor = (Display as OutputDisplay).getLayerAt(0) as LayerImplementor;
					(Display as OutputDisplay).load(defaultFile.url, layer, useTransition);
					
				}
				
				// remove this
				StateManager.removeState(this);
			}
		}
	}
}