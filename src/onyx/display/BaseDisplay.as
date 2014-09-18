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
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.jobs.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.array.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Base Display class
	 */
	public class BaseDisplay extends Sprite implements IDisplay {
		
		/**
		 * 	@private
		 */
		protected static const RENDER_EVENT:Event	= new Event(DisplayEvent.DISPLAY_RENDER);
		
		/**
		 * 	@private
		 * 	Stores the filters for this content
		 */
		protected const _filters:FilterArray		= new FilterArray(this as Content);
		
		/**
		 * 	@private
		 */
		protected const parameters:Parameters		= new Parameters(this as IParameterObject);
		
		/**
		 * 	@private
		 */
		protected const colorMatrix:ColorMatrix		= new ColorMatrix();

		/**
		 * 	@private
		 */
		protected var colorDirty:Boolean			= true;
		
		/**
		 * 	@private
		 */
		protected var _brightness:Number	= 0;
		
		/**
		 * 	@private
		 */
		protected var _contrast:Number	= 0;
		
		/**
		 * 	@private
		 */
		protected var _saturation:Number	= 1;
		
		/**
		 * 	@private
		 */
		protected var _hue:Number			= 0;
		
		/**
		 * 	@private
		 */
		protected var _backgroundColor:uint;
		
		/**
		 * 	@private
		 */
		private var _paused:Boolean = false;	
		
		/**
		 * 	@private
		 */
		protected const data:BitmapData		= new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, _backgroundColor);
		
		/**
		 * 	@constructor
		 */
		public function BaseDisplay():void {
			
			init();
			
			this.mouseEnabled	= false;
			this.mouseChildren	= false;
			this.tabEnabled		= false;
			
		}
		
		/**
		 * 	@private
		 */
		private function init():void {
			
			addChild(new Bitmap(data, PixelSnapping.ALWAYS, false));
			
			// add parameters
			parameters.addParameters(
				new ParameterColor('backgroundColor', 'BACKGROUND'),
				new ParameterInteger('framerate', 'framerate', 12, 60, 40),
				new ParameterNumber('brightness', 'brightness', -1, 1, 0),
				new ParameterNumber('contrast', 'contrast', -1, 1, 0),
				new ParameterNumber('saturation', 'saturation', 0, 2, 1),
				new ParameterNumber('hue', 'hue', -180, 180, 0, 1, 0)
			);
			
			// add filter methods
			_filters.addEventListener(FilterEvent.FILTER_ADDED,		super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_MUTED,		super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_REMOVED,	super.dispatchEvent);

		}
		
		/**
		 * 	Gets the parameters related to the display
		 */
		public function getParameters():Parameters {
			return parameters;
		}
				
		/**
		 * 	Sets background color
		 */
		public function set backgroundColor(value:uint):void {
			_backgroundColor = parameters.getParameter('backgroundColor').dispatch(value);
		}
		
		/**
		 * 	Sets the background color
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}

		/**
		 * 
		 */
		public function set brightness(value:Number):void {
			_brightness = parameters.getParameter('brightness').dispatch(value);
			colorDirty	= true;
		}
		
		/**
		 * 
		 */
		public function get brightness():Number {
			return _brightness;
		}
		
		/**
		 * 
		 */
		public function set contrast(value:Number):void {
			_contrast = parameters.getParameter('contrast').dispatch(value);
			colorDirty	= true;
		}
		
		/**
		 * 
		 */
		public function get contrast():Number {
			return _contrast;
		}
		
		/**
		 * 
		 */
		public function set saturation(value:Number):void {
			_saturation = parameters.getParameter('saturation').dispatch(value);
			colorDirty	= true;
		}
		
		/**
		 * 
		 */
		public function get saturation():Number {
			return _saturation;
		}
		
		/**
		 * 
		 */
		public function set hue(value:Number):void {
			_hue = parameters.getParameter('hue').dispatch(value);
			colorDirty	= true;
		}
		public function get hue():Number {
			return _hue;
		}

		/**
		 * 	Adds a filter
		 */
		public function addFilter(filter:Filter):void {
			_filters.addFilter(filter);
		}

		/**
		 * 	Removes a filter
		 */		
		public function removeFilter(filter:Filter):void {
			_filters.removeFilter(filter);
		}

		/**
		 * 	Gets a filter's index
		 */
		public function getFilterIndex(filter:Filter):int {
			return _filters.indexOf(filter);
		}

		/**
		 * 
		 */
		public function pause(value:Boolean):void 
		{
			_paused = value;
			if (_paused) {
				DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, _render);
			} else {
				DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, _render);
			}

		}
		/**
		 * 	Return paused
		 */
		public function get paused():Boolean {
			return _paused;
		}	
		/**
		 * 	@private
		 */
		private function _render(event:Event):void {
			render(null);
		}
		
		/**
		 * 	Returns the display bitmap before rendering filters
		 */
		public function get source():BitmapData {
			return data;
		}

		/**
		 * 
		 */
		public function get totalTime():int {
			return 1;
		}
		
		/**
		 * 	Moves a filter to an index
		 */
		public function moveFilter(filter:Filter, index:int):void {
			_filters.moveFilter(filter, index);
		}
		
		/**
		 * 
		 */
		public function get time():Number {
			return 0;
		}
		
		/**
		 * 	Renders the display
		 */
		public function render(info:RenderInfo):void {
		}
		
		/**
		 * 	@private
		 */
		override public function set x(value:Number):void {
			// do nothing, use displayX
		}
		
		/**
		 * 	@private
		 */
		override public function set y(value:Number):void {
			// do nothing, use displayY
		}
		
		/**
		 * 	@private
		 */
		override public function get x():Number {
			return 0;
		}
		
		/**
		 * 	@private
		 */
		override public function get y():Number {
			return 0;
		}
		/**
		 * 	Returns the anchor
		 */
		public function get anchorX():Number {
			return 0;
		}
		
		/**
		 * 	Sets the anchor
		 */
		public function set anchorX(value:Number):void {
			// do nothing, use no anchor
		}
		
		/**
		 * 	Returns the anchor
		 */
		public function get anchorY():Number {
			return 0;
		}
		
		/**
		 * 
		 */
		public function set anchorY(value:Number):void {
			// do nothing, use no anchor
		}
		
		/**
		 * 	Mutes a filter
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			_filters.muteFilter(filter, toggle);
		}
		
		/**
		 * 	Sets visibility
		 */
		// BL 20100811: uncommented
		override public function set visible(value:Boolean):void {
			// super.visible = __visible.dispatch(value);
		}
		 		
		public function get channel():Boolean {
			return false;
			// super.visible = __visible.dispatch(value);
		}
		public function set channel(value:Boolean):void {
			// super.visible = __visible.dispatch(value);
		}
		
		/**
		 * 	Returns the display as xml
		 */
		public function toXML():XML {
			
			const xml:XML = <mix/>;

			// add version metadata
			var meta:XML = <metadata />
			meta.appendChild(<version>{VERSION}</version>);
			
			xml.appendChild(meta);
		
			// add display xml
			const display:XML = <display />;
			
			// add display parameters
			display.appendChild(parameters.toXML('position', 'visible', 'transition'));
			
			// add filters
			display.appendChild(_filters.toXML());
			
			// add display settings			
			xml.appendChild(display);
			
			return xml;
		}
		
		/**
		 * 	Loads settings from xml
		 */
		public function loadXML(xml:XMLList):void {
			
			// load display settings
			getParameters().loadXML(xml.parameters);

			// remove all filters
			_filters.clear();
			
			// load xml
			_filters.loadXML(xml.filters);
			
		}

		/**
		 * 
		 */
		public function get path():String {
			return null;
		}
		
		/**
		 * 	Applies a filter to the rendered output
		 */
		public function applyFilter(filter:IBitmapFilter):void {
			filter.applyFilter(data);
		}
		
		/**
		 * 
		 */
		public function getColorTransform():ColorTransform {
			return null;
		}

		/**
		 * 	Disposes the display
		 */
		public function dispose():void {
			
			pause(true);
			data.dispose();
			
			_filters.removeEventListener(FilterEvent.FILTER_ADDED,		super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_MUTED,		super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_REMOVED,	super.dispatchEvent);
		}
		
		final public function get contentWidth():Number {
			return DISPLAY_WIDTH;
		}
		
		final public function get contentHeight():Number {
			return DISPLAY_HEIGHT;
		}
		
		/**
		 * 
		 */
		override public function get filters():Array {
			return _filters;
		}
		
		/**
		 * 
		 */
		public function get index():int {
			return -1;
		}
		
		/**
		 * 
		 */
		public function set framerate(value:Number):void {
			DISPLAY_STAGE.frameRate = value;
		}
		
		/**
		 * 
		 */
		public function get framerate():Number {
			return DISPLAY_STAGE.frameRate;
		}
		
		/******************
		 * 
		 ******************/
		 
		public function get loadedLayers():Array {
			return null;
		}
		public function get layers():Array {
			return null;
		}
		
		public function moveLayer(layer:Layer, index:int):void {
			
		}
		public function copyLayer(layer:Layer, index:int):void {
			
		}
		
		public function set channelMix(value:Number):void {

		}
		public function get channelMix():Number {
			return 0;
		}
				
		public function get channelA():BitmapData {
			return data;
		}
		public function get channelB():BitmapData {
			return data;
		}
		
		public function set channelBlend(value:Transition):void {
			
		}
		public function get channelBlend():Transition {
			return null;
		}
		
		public function createLayers(numLayers:int):void {
			
		}
		
		public function getLayerAt(index:int):Layer {
			return null;
		}
		
		public function forwardEvent(event:InteractionEvent):void {
			
		}
		public function get loopStart():Number {
			return 0;
		}
		public function set loopStart(value:Number):void {
			
		}
		public function get loopEnd():Number {
			return 1;
		}
		public function set loopEnd(value:Number):void {
			
		}
		public function set time(value:Number):void {
			
		}
	}
}