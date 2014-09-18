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
package onyx.plugin {
	
	import flash.display.*;
	import flash.events.*;
	
	import onyx.core.*;
	import onyx.parameter.Parameter;
	
	[Event(name="close", type="flash.events.Event")]
	
	/**
	 * 
	 */
	public class Module extends PluginBase {
		
		/**
		 * 	Does it have interface options?
		 */
		public var interfaceOptions:ModuleInterfaceOptions;
		
		/**
		 * 	@constructor
		 */
		public function Module(interfaceOptions:ModuleInterfaceOptions = null):void {
			this.interfaceOptions = interfaceOptions;
		}
		
		/**
		 * 	Method called when you type a command into the console with the module name
		 */
		public function command(... args:Array):String {
			return '';
		}
		
		/**
		 * 
		 */
		public function close():void {
			
			// dispatches a close event
			super.dispatchEvent(new Event(Event.CLOSE));
			
		}
	}
}