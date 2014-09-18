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
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;

	[Event(name="filter_added",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
	[Event(name="transition_end",	type="onyx.events.TransitionEvent")]
	
	public interface Content extends ITimeObject, IFilterObject, IParameterObject, IRenderObject, IEventDispatcher {

		function get source():BitmapData;
		function get path():String;

		function set anchorX(value:Number):void;
		function get anchorX():Number;
		
		function set anchorY(value:Number):void;
		function get anchorY():Number;
		
		function get alpha():Number;
		function set alpha(value:Number):void;

		function get scaleX():Number;
		function set scaleX(value:Number):void;

		function get scaleY():Number;
		function set scaleY(value:Number):void;

		function get rotation():Number;
		function set rotation(value:Number):void;

		function get x():Number;
		function set x(value:Number):void;

		function get y():Number;
		function set y(value:Number):void;
		
		function get blendMode():String;
		function set blendMode(value:String):void;
		
		function get channel():Boolean;
		function set channel(value:Boolean):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function pause(value:Boolean):void;
		function get paused():Boolean;

		function get brightness():Number;
		function set brightness(value:Number):void;

		function get contrast():Number;
		function set contrast(value:Number):void;
		
		function get saturation():Number;
		function set saturation(value:Number):void;

		function get hue():Number;
		function set hue(value:Number):void;

		function getColorTransform():ColorTransform;
		
		function get contentWidth():Number;
		function get contentHeight():Number;

	}
}