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
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	internal final class ContentNull implements Content {
		
		/**
		 * 	Return paused
		 */
		public function get paused():Boolean {
			return false;
		}
		/**
		 * 
		 */
		final public function getColorTransform():ColorTransform {
			return null;
		}
		
		public function get source():BitmapData {
			return null;
		}
		
		public function get totalTime():int
		{
			return 0;
		}
		
		public function get filters():Array
		{	return [];
		}
		
		public function removeFilter(filter:Filter):void
		{
		}
		
		public function get loopStart():Number
		{
			return 0;
		}
		
		public function set loopStart(value:Number):void
		{
		}
		
		public function set time(value:Number):void
		{
		}
		
		public function get time():Number
		{
			return 0;
		}
		
		public function get loopEnd():Number
		{
			return 0;
		}
		
		public function set loopEnd(value:Number):void
		{
		}
		
		public function get channel():Boolean
		{
			return false;
		}
		public function set channel(value:Boolean):void
		{
		}
		
		public function addFilter(filter:Filter):void
		{
		}
		
		public function getFilterIndex(filter:Filter):int
		{
			return -1;
		}
		
		public function set framerate(value:Number):void
		{
		}
		
		public function get framerate():Number
		{
			return 0;
		}
		
		public function moveFilter(filter:Filter, index:int):void
		{
		}
		
		public function set matrix(value:Matrix):void
		{
		}
		
		public function pause(b:Boolean):void
		{
		}
		
		public function getParameters():Parameters
		{
			return null;
		}
		
		public function dispose():void
		{
		}
		
		public function set alpha(value:Number):void
		{
		}
		
		public function get alpha():Number
		{
			return 0;
		}
		
		public function set y(value:Number):void
		{
		}
		
		public function get y():Number
		{
			return 0;
		}
		
		public function get blendMode():String
		{
			return 'normal';
		}
		
		public function set blendMode(value:String):void
		{
		}
		
		public function set x(value:Number):void
		{
		}
		
		public function get x():Number
		{
			return 0;
		}
		
		public function get scaleY():Number
		{
			return 0;
		}
		
		public function set scaleY(value:Number):void
		{
		}
		
		public function get scaleX():Number
		{
			return 0;
		}
		
		public function set scaleX(value:Number):void
		{
		}
		
		public function set rotation(value:Number):void
		{
		}
		
		public function get rotation():Number
		{
			return 0;
		}
		
		public function render(info:RenderInfo):void {
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
		public function get path():String {
			return null;
		}

		/**
		 * 	Sets matrix
		 */
		public function get matrix():Matrix {
			return null;
		}
		
		/**
		 * 
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
		}
		
		/**
		 * 
		 */
		public function get properties():Parameters {
			return null;
		}

		/**
		 * 
		 */
		public function get visible():Boolean {
			return false;
		}
		
		/**
		 * 
		 */
		public function get anchorX():Number {
			return 0;
		}
		
		/**
		 * 
		 */
		public function set anchorX(value:Number):void {
		}
		
		/**
		 * 
		 */
		public function get anchorY():Number {
			return 0;
		}
		
		/**
		 * 
		 */
		public function set anchorY(value:Number):void {
		}

		/**
		 * 
		 */
		public function set visible(value:Boolean):void {
		}
		
		/**
		 * 	Applies a filter to the rendered output
		 */
		public function applyFilter(filter:IBitmapFilter):void {
		}
		
		/**
		 * 	The base color transform to use for the layer (for crossfader)
		 */
		public function get baseColor():ColorTransform {
			return null;
		}
		
		final public function set brightness(value:Number):void {
		}
		final public function get brightness():Number {
			return 0;
		}
		
		
		final public function set contrast(value:Number):void {
		}
		final public function get contrast():Number {
			return 0;
		}
		
		
		final public function set saturation(value:Number):void {
		}
		final public function get saturation():Number {
			return 1;
		}
		
		final public function get contentWidth():Number {
			return DISPLAY_WIDTH;
		}
		
		final public function get contentHeight():Number {
			return DISPLAY_HEIGHT;
		}
		
		final public function set hue(value:Number):void {
		}
		final public function get hue():Number {
			return 0;
		}
	}
}