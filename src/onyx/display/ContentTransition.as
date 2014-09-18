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
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	[ExcludeClass]
	public final class ContentTransition extends ContentBase {
		
		/**
		 * 	@private
		 * 	Stores old content
		 */
		onyx_ns var oldContent:Content;

		/**
		 * 	@private
		 * 	Stores new content
		 */
		onyx_ns var newContent:Content;

		/**
		 * 	@private
		 * 	Stores transition
		 */
		private var _transition:Transition;
		
		/**
		 * 	@private
		 * 	Stores the start of the transition
		 */
		private var _startTime:uint;
		
		/**
		 * 	@constructor
		 */
		public function ContentTransition(layer:LayerImplementor, transition:Transition, current:Content, loaded:Content):void {

			// super!
			super(layer, null, null, DISPLAY_WIDTH, DISPLAY_HEIGHT);

			// store transition			
			_transition = transition;
			
			// store content
			oldContent	= current,
			newContent	= loaded;
			
			// add listeners for filter events
			newContent.addEventListener(FilterEvent.FILTER_ADDED,		super.dispatchEvent);
			newContent.addEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
			newContent.addEventListener(FilterEvent.FILTER_REMOVED,		super.dispatchEvent);
			oldContent.addEventListener(FilterEvent.FILTER_ADDED,		super.dispatchEvent);
			oldContent.addEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
			oldContent.addEventListener(FilterEvent.FILTER_REMOVED,		super.dispatchEvent);
			
			// change the target properties to the new content
			layer.getProperties().setNewTarget(newContent);

			// set time			
			_startTime = getTimer();

		}
		
		/**
		 * 	Renders the bitmap
		 */
		override public function render(info:RenderInfo):void {
			
			// get the time of the transition
			var ratio:Number = (getTimer() - _startTime) / _transition.onyx_ns::_duration;
			
			// get out!
			if (ratio > 1) {
				return endTransition();
			}
			
			// fill, and render transition
			_source.fillRect(DISPLAY_RECT, 0);
			
			// render both content files
			oldContent.render(null);
			newContent.render(null);
			
			// render transition
			_transition.render(_source, oldContent.source, newContent.source, ratio);
			
		}
		
		/**
		 * 	Gets alpha
		 */
		override public function get alpha():Number {
			return newContent.alpha;
		}

		/**
		 * 	Sets alpha
		 */
		override public function set alpha(value:Number):void {
			newContent.alpha = value;
		}
		
		/**
		 * 	Sets x
		 */
		override public function set x(value:Number):void {
			newContent.x = value;
		}

		/**
		 * 	Sets y
		 */
		override public function set y(value:Number):void {
			newContent.y = value;
		}

		override public function set scaleX(value:Number):void {
			newContent.scaleX = value;
		}

		override public function set scaleY(value:Number):void {
			newContent.scaleY = value;
		}
		
		override public function get scaleX():Number {
			return newContent.scaleX;
		}

		override public function get scaleY():Number {
			return newContent.scaleY;
		}

		override public function get x():Number {
			return newContent.x;
		}

		override public function get y():Number {
			return newContent.y;
		}
		
		override public function set brightness(value:Number):void {
			newContent.brightness = value;
		}
		override public function get brightness():Number {
			return newContent.brightness;
		}
		override public function set contrast(value:Number):void {
			newContent.contrast = value;
		}
		override public function get contrast():Number {
			return newContent.contrast;
		}
		override public function set saturation(value:Number):void {
			newContent.saturation = value;
		}
		override public function get saturation():Number {
			return newContent.saturation;
		}
		override public function set hue(value:Number):void {
			newContent.hue = value;
		}
		override public function get hue():Number {
			return newContent.saturation;
		}
		/**
		 *	Returns rotation
		 */
		override public function get rotation():Number {
			return newContent.rotation;
		}

		/**
		 *	@private
		 * 	Sets rotation
		 */
		override public function set rotation(value:Number):void {
			newContent.rotation = value;
		}

		/**
		 * 	Adds a filter
		 */
		override public function addFilter(filter:Filter):void {
			newContent.addFilter(filter);
		}

		/**
		 * 	Removes a filter
		 */		
		override public function removeFilter(filter:Filter):void {
			newContent.removeFilter(filter);
		}
		
		/**
		 * 	Returns filters
		 */
		override public function get filters():Array {
			return newContent.filters;
		}
		
		/**
		 * 	Gets a filter's index
		 */
		override public function getFilterIndex(filter:Filter):int {
			return newContent.getFilterIndex(filter);
		}
		
		/**
		 * 	Moves a filter to an index
		 */
		override public function moveFilter(filter:Filter, index:int):void {
			newContent.moveFilter(filter, index);
		}
				
		/**
		 * 	Sets the time
		 */
		override public function set time(value:Number):void {
			newContent.time = value;
		}
		
		/**
		 * 	Gets the time
		 */
		override public function get time():Number {
			return newContent.time;
		}
		
		/**
		 * 	Gets the total time
		 */
		override public function get totalTime():int {
			return newContent.totalTime;
		}
		
		/**
		 * 	Pauses content
		 */
		override public function pause(value:Boolean):void {
			newContent.pause(value);
		}
				
		/**
		 * 	Gets the framerate
		 */
		override public function get framerate():Number {
			return newContent.framerate;
		}

		/**
		 * 	Sets framerate
		 */
		override public function set framerate(value:Number):void {
			newContent.framerate = value;
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		override public function get loopStart():Number {
			return newContent.loopStart;
		}
		
		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		override public function set loopStart(value:Number):void {
			newContent.loopStart = value;
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		override public function get loopEnd():Number {
			return newContent.loopEnd;
		}

		/**
		 * 	Sets the end loop point
		 */
		override public function set loopEnd(value:Number):void {
			newContent.loopEnd = value;
		}

		/**
		 * 	Returns the bitmap source
		 */
		override public function get source():BitmapData {
			return _source;
		}
		
		/**
		 * 	Sets blendmode
		 */
		override public function set blendMode(value:String):void {
			newContent.blendMode = value;
		}
		
		/**
		 * 	Returns content parameters
		 */
		override public function getParameters():Parameters {
			return newContent.getParameters();
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			super.dispose();
			
			// clean transition
			_transition.clean();
		
			// remove listeners
			newContent.removeEventListener(FilterEvent.FILTER_ADDED,		super.dispatchEvent);
			newContent.removeEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
			newContent.removeEventListener(FilterEvent.FILTER_REMOVED,		super.dispatchEvent);
			oldContent.removeEventListener(FilterEvent.FILTER_ADDED,		super.dispatchEvent);
			oldContent.removeEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
			oldContent.removeEventListener(FilterEvent.FILTER_REMOVED,		super.dispatchEvent);

			// destroy the old content
			oldContent.dispose();
			
			// clear out
			_transition	= null,
			oldContent	= null,
			newContent	= null;
		}
		
		/**
		 * 	Dispatches an event over to the new content
		 */
		override public function dispatchEvent(event:Event):Boolean {
			return newContent.dispatchEvent(event);
		}
		
		/**
		 * 
		 */
		override public function get path():String {
			return newContent.path;
		}
		
		/**
		 * 
		 */
		public function endTransition():void {
			super.dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_END, newContent));
		}

 	}
}