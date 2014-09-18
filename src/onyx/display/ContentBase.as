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
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	
	[Event(name="filter_applied",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
	[Event(name="filter_muted",		type="onyx.events.FilterEvent")]
		
	use namespace onyx_ns;
	
	/**
	 * 
	 */
	internal class ContentBase extends EventDispatcher implements Content {
		
		/**
		 * 	@private
		 */
		private var _blendMode:String					= 'normal';
		
		/**
		 * 	@private
		 */
		private var _visible:Boolean;
		
		private var _channel:Boolean;
		
		/**
		 * 	@private
		 * 	Stores the filters for this content
		 */
		protected const _filters:FilterArray			= new FilterArray(this as Content);
		
		/**
		 * 	@private
		 * 	Stores the matrix for the content
		 */
		protected const renderMatrix:Matrix				= new Matrix();
		
		/**
		 * 	@private
		 */
		protected var renderDirty:Boolean				= true;
		
		/**
		 * 	@private
		 */
		protected var colorDirty:Boolean				= false;
		
		/**
		 * 	@private
		 */
		protected const colorMatrix:ColorMatrix			= new ColorMatrix(); 
		
		/**
		 * 	@private
		 * 	Stores local rotation
		 */
		private var _rotation:Number;
		
		/**
		 * 	@private
		 */
		protected const rotationMatrix:Matrix			= new Matrix(1, 0, 0, 1);
		
		/**
		 * 	@private
		 */
		protected const colorTransform:ColorTransform	= new ColorTransform();
		
		/**
		 * 	@protected
		 */
		protected var _paused:Boolean = false;

		/**
		 * 	@private
		 */
		private var _scaleX:Number;

		/**
		 * 	@private
		 */
		private var _scaleY:Number;

		/**
		 * 	@private
		 */
		protected var _x:int;

		/**
		 * 	@private
		 */
		protected var _y:int;

		/**
		 * 	@private
		 */
		private var _anchorX:int;

		/**
		 * 	@private
		 */
		private var _anchorY:int;
				
		/**
		 * 	@private
		 * 	The source
		 */
		protected const _source:BitmapData	= createDefaultBitmap();
		
		/**
		 * 	@private
		 * 	The left loop point
		 */
		protected var _loopStart:Number		= 0;
		
		/**
		 * 	@private
		 * 	The right loop point
		 */
		protected var _loopEnd:Number		= 1;
		
		/**
		 * 	@private
		 * 	Stores the layer's parameters so that the external content can use them
		 */
		protected var customParameters:Parameters; 
		
		/**
		 * 	@private
		 * 	Stores the content that we're gonna draw
		 */
		protected var _content:IBitmapDrawable;
		
		/**
		 * 	@private
		 */
		protected var _path:String;

		protected var __framerate:Parameter;
		protected var __loopStart:Parameter;
		protected var __loopEnd:Parameter;
		
		private var __alpha:Parameter;
		private var __scaleX:Parameter;
		private var __scaleY:Parameter;
		private var __rotation:Parameter;
		private var __x:Parameter;
		private var __y:Parameter;
		private var __blendMode:Parameter;
		
		private var __channel:Parameter; 
		private var __visible:Parameter;
		private var __anchorX:Parameter;
		private var __anchorY:Parameter;
		private var __brightness:Parameter;
		private var __contrast:Parameter;
		private var __saturation:Parameter;
		private var __hue:Parameter;
		
		protected var _brightness:Number	= 0;
		protected var _contrast:Number		= 0;
		protected var _saturation:Number	= 1;
		protected var _hue:Number			= 0;
		
		protected var properties:Parameters;
		
		protected var renderInfo:RenderInfo;
		
		private var ratioX:Number;
		private var ratioY:Number;
		
		private var _contentWidth:Number;
		private var _contentHeight:Number;
		
		/**
		 * 	@constructor
		 */		
		public function ContentBase(layer:Layer, path:String, content:IBitmapDrawable, contentWidth:Number, contentHeight:Number):void {
			
			// remove intensive logic to a method, so it can get JIT.
			// Constructors are not JIT'd
			_init(layer, path, content, contentWidth, contentHeight);
			
		}
		
		/**
		 * 	@private
		 */
		private function _init(layer:Layer, path:String, content:IBitmapDrawable, width:Number, height:Number):void {

			this._contentWidth	= width;
			this._contentHeight	= height;
			this.ratioX			= DISPLAY_WIDTH / width;
			this.ratioY			= DISPLAY_HEIGHT / height;

			const props:Parameters		= layer.getProperties();
			properties					= props;
			// _source						= layer.source;
			
			// store layer, parameters (for performance)
			_blendMode		= 'normal',
			_visible		= true,
			_path  			= path,
			__alpha 		= props.getParameter('alpha'),
			__scaleX		= props.getParameter('scaleX'),
			__scaleY		= props.getParameter('scaleY'),
			__rotation		= props.getParameter('rotation'),
			__x				= props.getParameter('x'),
			__y				= props.getParameter('y'),
			__framerate		= props.getParameter('framerate'),
			__loopStart		= props.getParameter('loopStart'),
			__loopEnd		= props.getParameter('loopEnd'),
			__blendMode		= props.getParameter('blendMode'),
			__visible		= props.getParameter('visible'),
			__channel		= props.getParameter('channel'),
			__anchorX		= props.getParameter('anchorX'),
			__anchorY		= props.getParameter('anchorY'),
			__brightness	= props.getParameter('brightness'),
			__contrast		= props.getParameter('contrast'),
			__saturation	= props.getParameter('saturation'),
			__hue			= props.getParameter('hue'),
			_scaleX			= 1,
			_scaleY			= 1,							// scale normally
			_content		= content;						// store content
			
			renderInfo		= new RenderInfo(_source, renderMatrix);
						
			_filters.addEventListener(FilterEvent.FILTER_ADDED, super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_MOVED, super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_MUTED, super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_REMOVED, super.dispatchEvent);
			
			// change target to this (performance)
			layer.getProperties().setNewTarget(this);
			
			// check for custom parameters
			if (_content is IParameterObject) {
				customParameters = (_content as IParameterObject).getParameters();
			}
			
			// if it takes events, pass em on
			if (_content is IEventDispatcher) {
				
				var method:Function = (_content as IEventDispatcher).dispatchEvent;
				
				addEventListener(MouseEvent.MOUSE_DOWN,	method);
				addEventListener(MouseEvent.MOUSE_UP,	method);
				addEventListener(MouseEvent.MOUSE_MOVE,	method);
			}
		}
		
		public function set brightness(value:Number):void {
			_brightness = __brightness.dispatch(value);
			colorDirty	= true;
		}
		public function get brightness():Number {
			return _brightness;
		}
		
		
		public function set contrast(value:Number):void {
			_contrast = __contrast.dispatch(value);
			colorDirty	= true;
		}
		public function get contrast():Number {
			return _contrast;
		}
		
		
		public function set saturation(value:Number):void {
			_saturation = __saturation.dispatch(value);
			colorDirty	= true;
		}
		public function get saturation():Number {
			return _saturation;
		}
		
		
		public function set hue(value:Number):void {
			_hue = __hue.dispatch(value);
			colorDirty	= true;
		}
		public function get hue():Number {
			return _hue;
		}
		
		/**
		 * 	Gets alpha
		 */
		public function get alpha():Number {
			return colorTransform.alphaMultiplier;
		}

		/**
		 * 	Sets alpha
		 */
		public function set alpha(value:Number):void {
			colorTransform.alphaMultiplier = __alpha.dispatch(value);
		}
		
		/**
		 * 	Sets x
		 */
		public function set x(value:Number):void {
			_x				= __x.dispatch(value),
			renderDirty = true;
		}	

		/**
		 * 	Sets y
		 */
		public function set y(value:Number):void {
			_y				= __y.dispatch(value),
			renderDirty = true;
		}

		/**
		 * 	Sets scaleX
		 */
		public function set scaleX(value:Number):void {
			_scaleX			= __scaleX.dispatch(value) * ratioX,
			renderDirty = true;
		}

		/**
		 * 	Sets scaleY
		 */
		public function set scaleY(value:Number):void {
			_scaleY			= __scaleY.dispatch(value) * ratioY,
			renderDirty = true;
		}
		
		/**
		 * 	Gets scaleX
		 */
		public function get scaleX():Number {
			return _scaleX / ratioX;
		}

		/**
		 * 	Gets scaleY
		 */
		public function get scaleY():Number {
			return _scaleY / ratioY;
		}
		
		/**
		 * 
		 */
		final public function get anchorX():Number {
			return _anchorX / this.contentWidth;
		}
		
		/**
		 * 
		 */
		final public function set anchorX(value:Number):void {
			_anchorX = __anchorX.dispatch(value) * this.contentWidth,
			renderDirty = true;
		}
		
		/**
		 * 
		 */
		final public function get anchorY():Number {
			return _anchorY / this.contentHeight;
		}
		
		/**
		 * 
		 */
		final public function set anchorY(value:Number):void {
			_anchorY = __anchorY.dispatch(value) * this.contentHeight,
			renderDirty = true;
		}

		/**
		 * 	Gets x
		 */
		public function get x():Number {
			return _x;
		}

		/**
		 * 	Gets y
		 */
		public function get y():Number {
			return _y;
		}
		
		/**
		 *	Returns rotation
		 */
		public function get rotation():Number {
			return _rotation;
		}

		/**
		 *	@private
		 * 	Sets rotation
		 */
		public function set rotation(value:Number):void {

			_rotation			= value,
			rotationMatrix.a	= Math.cos(value),
			rotationMatrix.b	= Math.sin(value),
			rotationMatrix.c	= -Math.sin(value),
			rotationMatrix.d	= Math.cos(value);
			
			renderDirty		= true;
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
		 * 	Sets filters
		 */
		public function set filters(value:Array):void {
			throw 'use addFilter, removeFilter, not filters = Array';
		}
		/**
		 * 	Returns filters
		 */
		public function get filters():Array {
			return _filters;
		}
		
		/**
		 * 	Gets a filter's index
		 */
		public function getFilterIndex(filter:Filter):int {
			return _filters.indexOf(filter);
		}
		
		/**
		 * 	Moves a filter to an index
		 */
		public function moveFilter(filter:Filter, index:int):void {
			_filters.moveFilter(filter, index);
		}
				
		/**
		 * 	Sets the time
		 */
		public function set time(value:Number):void {
			// do nothing
			// this needs to be overridden
		}
		
		/**
		 * 	Gets the time
		 */
		public function get time():Number {
			return 0;
		}
		
		/**
		 * 	Gets the total time
		 */
		public function get totalTime():int {
			return 1;
		}
		
		/**
		 * 	Pauses content
		 */
		public function pause(v:Boolean):void {
			_paused = v;
		}
		
		
		/**
		 * 	Return paused
		 */
		final public function get paused():Boolean {
			return _paused;
		}		
		/**
		 * 
		 */
		final protected function buildMatrix():void {
			
			// optimized matrix code
			renderMatrix.a = _scaleX;
			renderMatrix.b = 0;
			renderMatrix.c = 0;
			renderMatrix.d = _scaleY;
			renderMatrix.tx = -_anchorX * _scaleX;
			renderMatrix.ty = -_anchorY * _scaleY;
			
			renderMatrix.concat(rotationMatrix);
			
			renderMatrix.tx += _anchorX * ratioX + _x;
			renderMatrix.ty += _anchorY * ratioY + _y;

		}
		
		/**
		 * 	Called by the parent layer every frame to render
		 */
		public function render(info:RenderInfo):void 
		{
			try
			{
				if (_content) {
					
					if (renderDirty) {
						buildMatrix(); 
						renderDirty = false;
					}
					
					if (colorDirty) {
						colorMatrix.reset();
						colorMatrix.adjustBrightness(_brightness);
						colorMatrix.adjustContrast(_contrast);
						colorMatrix.adjustHue(_hue);
						colorMatrix.adjustSaturation(_saturation);
						
						colorDirty = false;
					}
					
					// clear 
					_source.fillRect(DISPLAY_RECT, 0);
					
					// draw our content
					_source.draw(_content, renderMatrix, null, null, null, true);
					
					// color adjustment
					if (!(_saturation === 1 && _brightness === 0 && _contrast === 0 && _hue === 0)) {
	
						// apply filter
						_source.applyFilter(_source, DISPLAY_RECT, ONYX_POINT_IDENTITY, colorMatrix.filter);
						
					}
					
					// render filters
					_filters.render(_source);
					
				}
				
			}
			catch (e:Error)
			{
				trace("error in ContentBase.as, render:" + e.message);
			}

		}
						
		/**
		 * 	Gets the framerate
		 */
		public function get framerate():Number {
			return 1;
		}

		/**
		 * 	Sets framerate
		 */
		public function set framerate(value:Number):void {
			__framerate.dispatch(value);
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		public function get loopStart():Number {
			return 0;
		}
		
		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		public function set loopStart(value:Number):void {
		}
		
		/**
		 * 	Gets the beginning loop point
		 */
		public function get loopEnd():Number {
			return 1;
		}

		/**
		 * 	Sets the end loop point
		 */
		public function set loopEnd(value:Number):void {
		}

		/**
		 * 	Returns the bitmap source
		 */
		public function get source():BitmapData {
			return _source;
		}
		
		/**
		 * 	Sets blendmode
		 */
		public function set blendMode(value:String):void {
			_blendMode = __blendMode.dispatch(value);
		}
		
		/**
		 * 	Returns content parameters
		 */
		public function getParameters():Parameters {
			return customParameters;
		}
		
		/**
		 * 
		 */
		final public function get blendMode():String {
			return _blendMode;
		}
		
		/**
		 * 
		 */
		public function get path():String {
			return _path;
		}
		
		/**
		 * 	Mutes a filter
		 */
		final public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			_filters.muteFilter(filter, toggle);
		}
		
		/**
		 * 	Get Properties
		 */
		final public function getProperties():Parameters {
			return properties;
		}
		
		/**
		 * 	Sets visible
		 */
		final public function set visible(value:Boolean):void {
			_visible = __visible.dispatch(value);
		}

		/**
		 * 	Return visible
		 */
		final public function get visible():Boolean {
			return _visible;
		}
		
		
		/**
		 * 	Sets visible
		 */
		final public function set channel(value:Boolean):void {
			_channel = __channel.dispatch(value);
		}
		
		/**
		 * 	Return visible
		 */
		final public function get channel():Boolean {
			return _channel;
		}
		
		
		/**
		 * 
		 */
		final public function applyFilter(filter:IBitmapFilter):void {
			filter.applyFilter(_source);
		}
		
		/**
		 * 
		 */
		final public function getColorTransform():ColorTransform {
			return colorTransform;
		}
		
		/**
		 * 
		 */
		final public function get contentWidth():Number {
			return _contentWidth;
		}
		
		/**
		 * 
		 */
		final public function get contentHeight():Number {
			return _contentHeight;
		}
			
		/**
		 * 	Destroys the content
		 */
		public function dispose():void {
			
			// stop all tweens related to this content
			Tween.stopTweens(this);
			
			// if it takes events, pass em on
			if (_content is IEventDispatcher) {
				const method:Function = (_content as IEventDispatcher).dispatchEvent;
				
				removeEventListener(MouseEvent.MOUSE_DOWN,	method);
				removeEventListener(MouseEvent.MOUSE_UP,	method);
				removeEventListener(MouseEvent.MOUSE_MOVE,	method);
			}
			
			// check to see if it's disposable, but only if it's not a movieclip
			// movieclips are handled through CombineContent
			if (_content is IDisposable && !(this is ContentMC)) {
				(_content as IDisposable).dispose();
			}
			
			// kill all filters
			_filters.clear();
			
			// remove listeners
			_filters.removeEventListener(FilterEvent.FILTER_ADDED, super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_MOVED, super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_MUTED, super.dispatchEvent);
			_filters.removeEventListener(FilterEvent.FILTER_REMOVED, super.dispatchEvent);

			// dispose			
			_source.dispose();

		}
	}
}