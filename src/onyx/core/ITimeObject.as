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
	 
	import flash.events.IEventDispatcher;
	
	[ExcludeClass]
	
	public interface ITimeObject extends IEventDispatcher {

		function get time():Number;
		function set time(value:Number):void;

		function get totalTime():int;

		function get framerate():Number;
		function set framerate(value:Number):void;
		
		function get loopStart():Number;
		function set loopStart(value:Number):void;

		function get loopEnd():Number;
		function set loopEnd(value:Number):void;
		
	}
}