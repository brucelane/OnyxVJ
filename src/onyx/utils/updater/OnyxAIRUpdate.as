/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
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
package onyx.utils.updater 
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import onyx.core.Console;
	
	public final class OnyxAIRUpdate 
	{
		private static var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI(); 

		/**
		 * 	checks website for update
		 */
		public static function checkForUpdate():void 
		{ 
			Console.output( 'checkForUpdate' );
			// set the URL for the update.xml file
			appUpdater.updateURL = "http://www.batchass.fr/onyx-vj/update/update.xml"; // Server-side XML file describing update  
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate);
			appUpdater.addEventListener(ErrorEvent.ERROR, onUpdaterError);
			// Hide the dialog asking for permission for checking for a new update.
			appUpdater.isCheckForUpdateVisible = false;
			appUpdater.initialize();
		} 
		
		// Handler function triggered by the ApplicationUpdater.initialize.
		// The updater was initialized and it is ready to take commands.
		protected static function onUpdate(event:UpdateEvent):void 
		{
			appUpdater.removeEventListener(UpdateEvent.INITIALIZED, onUpdate);
			appUpdater.removeEventListener(ErrorEvent.ERROR, onUpdaterError);
			// start the process of checking for a new update and to install
			appUpdater.checkNow();
		}
		
		// Handler function for error events triggered by the ApplicationUpdater.initialize
		protected static function onUpdaterError(event:ErrorEvent):void
		{
			Console.output( "appUpdater,onError: " + event.toString() );  		
		}

	}
	
}