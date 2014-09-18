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
package onyx.display {
	
	import flash.display.*;
	
	import onyx.core.*;
	import onyx.events.InteractionEvent;
	import onyx.plugin.*;
	
	public interface IDisplay extends Content, ISerializable {

		function forwardEvent(event:InteractionEvent):void;
		
		function get loadedLayers():Array;
		function get layers():Array;
		
		function moveLayer(layer:Layer, index:int):void;
		function copyLayer(layer:Layer, index:int):void;
		
		function set channelMix(value:Number):void;
		function get channelMix():Number;
		
		function get channelA():BitmapData;
		function get channelB():BitmapData;
		
		function createLayers(numLayers:int):void;
		function getLayerAt(index:int):Layer;
		
		function set channelBlend(t:Transition):void;
		function get channelBlend():Transition;
		
		function set backgroundColor(value:uint):void;
		function get backgroundColor():uint;
		
		function get width():Number;
		function get height():Number;
	}
}