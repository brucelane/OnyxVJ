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
package onyx.core {
	
	import flash.events.EventDispatcher;
	
	import onyx.events.ConsoleEvent;
	

	[Event(name="output",	type="onyx.events.ConsoleEvent")]
	
	/**
	 * 	This class dispatches messages dispatched from the Onyx core
	 */
	public final class Console extends EventDispatcher {
		
		/**
		 * 	@private
		 */
		private static const REUSABLE_EVENT:ConsoleEvent	= new ConsoleEvent('');

		/**
		 * 	@private
		 */
		private static const dispatcher:Console				= new Console();
		
		/**
		 * 	Returns the console instance
		 */
		public static function getInstance():Console {
			return dispatcher;
		}
		
		/**
		 * 	Outputs an event to the console
		 */
		public static function output(... args:Array):void {
			
			REUSABLE_EVENT.message	= args.join(' ');
			dispatcher.dispatchEvent(REUSABLE_EVENT);
			
		}
		
		/**
		 * 	Outputs an error event to the console
		 */
		public static function error(e:Error):void {
			
			REUSABLE_EVENT.message = e.message;
			dispatcher.dispatchEvent(REUSABLE_EVENT);
		}
		
		/**
		 * 	Executes a command
		 */
		public static function executeCommand(command:String):void {
			
			const args:Array = command.split(' ');
			
			if (args.length) {
				
				// we need to check the command qualifier
				const name:String		= args.shift();
				
				// grab the output
				const commandReturn:Object = Command.execute(name, args) || 'COMMAND "' + name + '" NOT SUPPORTED.';
				
				(commandReturn is String) ? output(commandReturn as String) : error(commandReturn as Error);
			}
		}
	}
}