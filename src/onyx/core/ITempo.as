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
	
	import flash.events.*;
	
	import onyx.parameter.*;
	
	public interface ITempo extends IParameterObject, IEventDispatcher {
	
		function get delay():int;
		function set delay(value:int):void;
		
		function getParameter(name:String):Parameter;

		function start():void;	
	}
}