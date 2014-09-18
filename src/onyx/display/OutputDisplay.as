/**
 * Copyright (c) 2003-2014 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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
	
	import benkuper.nativeExtensions.Spout;
	
	use namespace onyx_ns;
	
	/**
	 * 	Base Display class
	 */
	final public class OutputDisplay extends Sprite implements IDisplay 
	{
		//spout sender
		private var spout:Spout;
		private var sendName:String = "OnyxVJ Sender";

		/**
		 * 	@private
		 */
		private var _paused:Boolean = false;
		
		/**
		 * 	@private
		 */
		private static const RENDER_EVENT:Event	= new Event(DisplayEvent.DISPLAY_RENDER);
		
		/**
		 * 	@private
		 * 	Stores the filters for this content
		 */
		private const _filters:FilterArray		= new FilterArray(this as Content);
		
		/**
		 * 	@private
		 */
		private const parameters:Parameters		= new Parameters(this as IParameterObject);
		
		/**
		 * 	@private
		 */
		private const colorMatrix:ColorMatrix	= new ColorMatrix();

		/**
		 * 	@private
		 */
		private var colorDirty:Boolean			= true; 
				
		/**
		 * 	@private
		 */
		private var __visible:ParameterBoolean	= new ParameterBoolean("visible", "visible", 0);
		
		/**
		 * 	@private
		 */
		private const __brightness:Parameter	= new ParameterNumber('brightness', 'brightness', -1, 1, 0);
		
		/**
		 * 	@private
		 */
		private const __contrast:Parameter		= new ParameterNumber('contrast', 'contrast', -1, 2, 0);
		
		/**
		 * 	@private
		 */
		private const __saturation:Parameter	= new ParameterNumber('saturation', 'saturation', 0, 2, 1);
		
		/**
		 * 	@private
		 */
		private const __hue:Parameter			= new ParameterNumber('hue', 'hue', -180, 180, 0, 1, 1);
		
		/**
		 * 	@private
		 */
		private var _brightness:Number	= 0;
		
		/**
		 * 	@private
		 */
		private var _contrast:Number	= 0;
		
		/**
		 * 	@private
		 */
		private var _saturation:Number	= 1;
		
		/**
		 * 	@private
		 */
		private var _hue:Number			= 0;
		
		/**
		 * 	@private
		 */
		internal const _layers:Array					= [];
		
		/**
		 * 	@private
		 */
		internal const _valid:Array						= [];
		
		/**
		 * 	@private
		 */
		private var _validLen:int;
		
		/**
		 * 	@private
		 */
		private var _backgroundColor:uint;
		
		/**
		 * 	@private
		 * 	Channel Mix ratio
		 */
		private var _channelMix:Number				= 0;
		
		/**
		 * 	@private
		 * 	Channel A Bitmap
		 */
		private const _channelA:BitmapData			= new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, _backgroundColor);
		
		/**
		 * 	@private
		 * 	Channel B Bitmap
		 */
		private const _channelB:BitmapData			= new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, _backgroundColor);
		
		/**
		 * 	@private
		 */
		private const data:BitmapData				= new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, false, _backgroundColor);
		
		/**
		 * 	@private
		 */
		private var _channelBlend:Transition		= PluginManager.createTransition(0);
		
		/**
		 * 	@constructor
		 */
		public function OutputDisplay():void {
			
			init();
			
			this.mouseEnabled	= this.mouseChildren = this.tabEnabled = false;
			
		}
		
		/**
		 * 	@private
		 */
		private function init():void {
			
			addChild(new Bitmap(data, PixelSnapping.ALWAYS, true));
			
			// add parameters
			parameters.addParameters(
				new ParameterPlugin('channelBlend', 'transition', PluginManager.transitions, channelBlend),
				new ParameterColor('backgroundColor', 'BACKGROUND'),
				new ParameterNumber('channelMix', 'channelMix', 0, 1, 0),
				new ParameterInteger('framerate', 'framerate', 12, 60, 40),
				__brightness,
				__contrast,
				__saturation,
				__hue
			);
			
			// add filter methods
			_filters.addEventListener(FilterEvent.FILTER_ADDED,		super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_MUTED,		super.dispatchEvent);
			_filters.addEventListener(FilterEvent.FILTER_REMOVED,	super.dispatchEvent);
			
			// lock bitmaps
			_channelA.lock();
			_channelB.lock();
			
			// spout
			spout = new Spout();
			var createResult:Boolean = spout.extContext.call("createSender", sendName, data.width, data.height) as Boolean;
			trace("createSender result :", createResult);
		}
		
		/**
		 * 	Returns the number of layers
		 */
		public function get numLayers():int {
			return _layers.length;
		}
		
		/**
		 * 
		 */
		public function set channelBlend(i:Transition):void {
			this._channelBlend = i;
		}
		
		/**
		 * 
		 */
		public function get channelBlend():Transition {
			return this._channelBlend;
		}
		
		public function get channel():Boolean {
			return false;
		}
		public function set channel(i:Boolean):void {
		}
		
		
		/**
		 * 	Creates a specified number of layers
		 */
		public function createLayers(numLayers:int):void {
			
			while (numLayers-- ) {
				
				// create a new layer and set it's index
				var layer:LayerImplementor = new LayerImplementor(this);
				_layers.push(layer);
				
				// listen for load and unload (to push to the valid array);
				layer.addEventListener(LayerEvent.LAYER_LOADED,		layerLoadHandler);
				layer.addEventListener(LayerEvent.LAYER_UNLOADED,	layerUnloadHandler);
				
				// dispatch
				super.dispatchEvent(
					new DisplayEvent(DisplayEvent.LAYER_CREATED, layer)
				);
			}
		}
		
		/**
		 * 	Returns layer by index number
		 */
		public function getLayerAt(index:int):Layer {
			return _layers[index];
		}
		
		/**
		 * 	@private
		 * 	Called when a layer is loaded
		 */
		private function layerLoadHandler(event:LayerEvent):void {
			
			var layer:LayerImplementor, index:int;
			const currentLayer:Layer	= event.currentTarget as Layer;
			
			for (index = 0; index < _validLen; index++) {
				layer = _valid[index];
				if (currentLayer.index < layer.index) {
					break;
				}
			}
			
			_valid.splice(index, 0, currentLayer);
			_validLen++

		}
		
		/**
		 * 	@private
		 * 	Called when a layer is unloaded
		 */
		private function layerUnloadHandler(event:LayerEvent):void {
			const layer:LayerImplementor = event.currentTarget as LayerImplementor;
			const index:int = _valid.indexOf(layer);
			
			_valid.splice(index, 1);
			_validLen --;
		}

		/**
		 * 	Returns the layers
		 */
		public function get layers():Array {
			return _layers;
		}

		/**
		 * 	Moves a layer to a specified index
		 */
		public function moveLayer(layer:Layer, index:int):void {
			
			const fromIndex:int	= layer.index;
			const toLayer:LayerImplementor	= _layers[index];
			
			if (toLayer) {
				
				const numLayers:int = _layers.length;
				const fromChildIndex:int = _layers.indexOf(layer);
				
				// swap the layers
				swap(_layers, layer, index);
				
				const e:LayerEvent = new LayerEvent(LayerEvent.LAYER_MOVE);

				// dispatch events to the layers				
				layer.dispatchEvent(e);
				toLayer.dispatchEvent(e);
				
				// now we need to check if they're both valid layers, and move them
				const toLayerValid:int = _valid.indexOf(toLayer);
				
				// swap
				if (toLayerValid >= 0) {
					swap(_valid, layer, toLayerValid);
				}				
			}
				        				
		}
		
		/**
		 * 	Gets the parameters related to the display
		 */
		public function getParameters():Parameters {
			return parameters;
		}
		
		/**
		 * 	Copies a layer
		 */
		public function copyLayer(layer:Layer, index:int):void {
			
			const layerindex:int	= layer.index;
			const copylayer:LayerImplementor	= _layers[index];
			
			if (copylayer) {
				
				const settings:LayerSettings = new LayerSettings();
				settings.load(layer);

				copylayer.load(settings.path, settings);
			}
		}
		
		/**
		 * 	Loads a mix file into the layers
		 * 	@param	request:URLRequest
		 * 	@param	origin:Layer
		 * 	@param	transition:Transition
		 */
		public function load(path:String, origin:LayerImplementor, transition:Transition):void 
		{
			// tell listeners we're loading a mix
			super.dispatchEvent(new DisplayEvent(DisplayEvent.MIX_LOADING));
			
			// start loading
			const job:LoadONXJob = new LoadONXJob(this, origin, transition);
			job.addEventListener(Event.COMPLETE, jobComplete);
			
			// register
			JobManager.register(this, job, path);
			
		}
		
		/**
		 * 	@private
		 */
		private function jobComplete(event:Event):void {
			
			const job:LoadONXJob	= event.currentTarget as LoadONXJob;
			job.removeEventListener(Event.COMPLETE, jobComplete);
			
			// dispatch event
			super.dispatchEvent(new DisplayEvent(DisplayEvent.MIX_LOADED));
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
			_brightness = __brightness.dispatch(value);
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
			_contrast = __contrast.dispatch(value);
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
			_saturation = __saturation.dispatch(value);
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
			_hue = __hue.dispatch(value);
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
		public function get loopStart():Number {
			return 0;
		}
		
		/**
		 * 
		 */
		public function set loopStart(value:Number):void {
			for each (var layer:LayerImplementor in _valid) {
				layer.loopStart = value;
			}
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
		public function get paused():Boolean 
		{
			return _paused;
		}
		/**
		 * 	@private
		 */
		private function _render(event:Event):void {
			render(null);
		}
				
		/**
		 * 
		 */
		public function set time(value:Number):void {
			for each (var layer:LayerImplementor in _valid) {
				layer.time = value;
			}
		}
		
		/**
		 * 
		 */
		public function set loopEnd(value:Number):void {
			for each (var layer:LayerImplementor in _valid) {
				layer.loopEnd = value;
			}
		}
		
		/**
		 * 
		 */
		public function get loopEnd():Number {
			return 1;
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
			
			// check for absolute channels
			if (_channelMix === 0) {
				
				_channelA.fillRect(DISPLAY_RECT, _backgroundColor);
				renderLayers();
				data.copyPixels(_channelA, DISPLAY_RECT, ONYX_POINT_IDENTITY);
				
			} else if (_channelMix === 1) {
				
				_channelB.fillRect(DISPLAY_RECT, _backgroundColor);
				renderLayers();
				data.copyPixels(_channelB, DISPLAY_RECT, ONYX_POINT_IDENTITY);
				
			// otherwise we need to render the transition (slower)
			} else {
				
				// fill all channels with the background color
				data.fillRect(DISPLAY_RECT, _backgroundColor);
				_channelA.fillRect(DISPLAY_RECT, _backgroundColor);
				_channelB.fillRect(DISPLAY_RECT, _backgroundColor);
				
				// render all layers
				renderLayers();
				
				// mix the channels
				channelBlend.render(data, _channelA, _channelB, _channelMix);
			}
			
			// dispatch a render event
			super.dispatchEvent(RENDER_EVENT);
			
			// re-create colormatrix
			if (colorDirty) {
				
				colorMatrix.reset();
				colorMatrix.adjustContrast(_contrast);
				colorMatrix.adjustBrightness(_brightness);
				colorMatrix.adjustSaturation(_saturation);
				colorMatrix.adjustHue(_hue);
				
				colorDirty = false;
			}

			// apply color filter only if items have changed
			if (!(_saturation === 1 && _brightness === 0 && _contrast === 0 && _hue === 0)) {
				// apply filter
				data.applyFilter(data, DISPLAY_RECT, ONYX_POINT_IDENTITY, colorMatrix.filter);
			}
			
			// render filters onto the bitmap
			_filters.render(data);
			
			// unlock
			data.unlock();
			spout.extContext.call("sendTexture", sendName, data);
			data.lock();
			channelA.unlock();
			channelA.lock();
			channelB.unlock();
			channelB.lock();

		}
		
		/**
		 * 	@private
		 */
		private function renderLayers():void {
			
			_channelA.lock();
			_channelB.lock();
			var count:int, layer:LayerImplementor;
			
			// loop through layers and render			
			for (count = _validLen - 1; count >= 0; count--) {
				
				layer	= _valid[count];
				layer.render(null);
				
				if (layer.visible) {
					
					var data:BitmapData	= layer.data;
					// lock bitmapdata
					data.lock();
					
					if (layer.channel) {
						_channelB.draw(data, null, layer.getColorTransform(), layer.blendMode, null, false);
					} else {
						_channelA.draw(data, null, layer.getColorTransform(), layer.blendMode, null, false);
					}
					
					// unlock bitmapdata
					data.unlock();
				}
			}
			_channelA.unlock();
			_channelB.unlock();
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
		override public function set visible(value:Boolean):void {
			// BL: in case of main output filter(not a layer filter) __visible is null
			super.visible = __visible.dispatch(value);
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

			// add layers
			const layers:XML = <layers />;
			display.appendChild(layers);
			
			// create xml for all the layers
			for each (var layer:LayerImplementor in _valid) {
				
				if (layer.path) {
					layers.appendChild(layer.toXML());
				}
				
			}
			
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
		 * 	Dispatching an event here forward onto all layers
		 */
		public function forwardEvent(event:InteractionEvent):void {
			
			for each (var layer:LayerImplementor in _valid) {
				layer.forwardEvent(event);
			}
		}
		
		/**
		 * 
		 */
		public function set channelMix(value:Number):void {
			_channelMix = parameters.getParameter('channelMix').dispatch(value);
		}
		
		/**
		 * 
		 */
		public function get channelMix():Number {
			return _channelMix;
		}
		
		/**
		 * 	Returns the A channel
		 */
		public function get channelA():BitmapData {
			return _channelA;
		}

		/**
		 * 	Returns the B channel bitmapdata
		 */
		public function get channelB():BitmapData {
			return _channelB;
		}
		
		/**
		 * 
		 */
		public function getColorTransform():ColorTransform {
			return null;
		}
		
		/**
		 * 
		 */
		public function get loadedLayers():Array {
			return _valid;
		}

		/**
		 * 	Disposes the display
		 */
		public function dispose():void {
			
			for each (var layer:Layer in _layers) {
				
				// listen for load and unload (to push to the valid array);
				layer.removeEventListener(LayerEvent.LAYER_LOADED,		layerLoadHandler);
				layer.removeEventListener(LayerEvent.LAYER_UNLOADED,	layerUnloadHandler);
				layer.dispose();
				
			}
			
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
	}
}