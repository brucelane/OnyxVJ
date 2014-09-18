/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
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
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.string.*;
	
	use namespace onyx_ns;
	
	[Event(name="filter_added",	type="onyx.events.FilterEvent")]
	[Event(name="filter_removed",	type="onyx.events.FilterEvent")]
	[Event(name="filter_moved",		type="onyx.events.FilterEvent")]
	[Event(name="layer_loaded",		type="onyx.events.LayerEvent")]
	[Event(name="layer_moved",		type="onyx.events.LayerEvent")]
	[Event(name="progress",			type="flash.events.Event")]
	
	/**
	 * 	Layer is the base media for all video objects
	 */
	final public class LayerImplementor extends EventDispatcher implements Layer {
		
		/**
		 * 	@private
		 */
		private var _paused:Boolean = false;	
		/**
		 * 	@private
		 */
		private static const LAYER_RENDER:LayerEvent	= new LayerEvent(LayerEvent.LAYER_RENDER);
		
		/**
		 * 	@private
		 * 	Holder for null content
		 * 	(this is here so that there is not a layer of checking between changing properties)
		 */
		private static const NULL_LAYER:ContentNull		= new ContentNull();
		
		/**
		 * 	@private
		 * 	The display the layer belongs to
		 */
		onyx_ns var			_display:IDisplay;
		
		/**
		 * 	@private
		 * 	Stores the content
		 */
		onyx_ns var			content:Content				= NULL_LAYER;
		
		/**
		 * 	@private
		 */
		private var _channel:Boolean;
		
		/**
		 * 	@private
		 * 	Controls
		 */
		private const layerProperties:Parameters		= new Parameters(this as IParameterObject);
		
		/**
		 * 	@private
		 */
		internal const data:BitmapData					= new BitmapData(DISPLAY_WIDTH, DISPLAY_HEIGHT, true, 0x00);	
		
		/**
		 * 	@constructor
		 */
		public function LayerImplementor(display:IDisplay):void {
			
			// store layers to display
			// ugly, but better
			this._display	= display;
			
			// add parameters
			layerProperties.addParameters(
				new ParameterNumber('alpha', 'alpha', 0, 1, 1),
				new ParameterBlendMode('blendMode', 'blendmode'),
				new ParameterNumber('rotation', 'rotation', -3.6, 3.6, 0),
				new ParameterFrameRate('framerate','play rate'),
				new ParameterNumber('loopStart','loop',0,1,0),
				new ParameterNumber('loopEnd','end',0,1,1),
				new ParameterNumber('time',null,0,1,0),
				new ParameterProxy('position', 'x:y',
					new ParameterInteger('x','x',-5000,5000,0),
					new ParameterInteger('y','y',-5000,5000,0),
					{ invert: true }
				),
				new ParameterProxy('scale', 'scale', 
					new ParameterNumber('scaleX','scaleX',-5,5,1),
					new ParameterNumber('scaleY','scaleY',-5,5,1),
					{ multiplier: 100, invert: true }
				),
				new ParameterProxy('anchor', 'anchor', 
					new ParameterNumber('anchorX','anchorX', -1, 2, .5),
					new ParameterNumber('anchorY','anchorY', -1, 2, .5),
					{ invert: true }
				),
				
				new ParameterNumber('brightness', 'brightness', -1, 1, 0),
				new ParameterNumber('contrast', 'contrast', -1, 1, 0),
				new ParameterNumber('saturation', 'saturation', 0, 2, 1),
				new ParameterNumber('hue', 'hue', -180, 180, 0, 1, 1),
				
				new ParameterBoolean('visible', 'visible', 1)
			)
		}
		
		/**
		 * 	Loads a file type into a layer
		 * 	The path of the file to load into the layer
		 **/
		public function load(path:String, settings:LayerSettings = null, transition:Transition = null):void {
			
			//if (DEBUG::SPLASHTIME==0) trace('LayerImplementor, LOADING ' + path);
			// query
			AssetFile.queryContent(path, loadStatus, this, settings || new LayerSettings(), transition);
			
		}
		
		/**
		 * 	@private
		 * 	Called from the asset
		 */
		private function loadStatus(event:Event, content:Content, settings:LayerSettings, transition:Transition):void {
			
			// if it's a progress event, pass it on
			if (event is ProgressEvent) {
				//if (DEBUG::SPLASHTIME==0) Console.output('LOADING ' + Math.floor((event as ProgressEvent).bytesLoaded / (event as ProgressEvent).bytesTotal * 100) + '% (' + Math.floor((event as ProgressEvent).bytesTotal / 1024) + ' kb)');
				
				super.dispatchEvent(event);
				return;
			}
			
			// if it's an error
			if (event is ErrorEvent) {
				Console.output('Error loading layer: ErrorEvent'); // can't be more specific...
				
			} else {
				
				// if a transition was loaded, load the transition with the layer
				if (transition && !(this.content === NULL_LAYER)) {
					
					// if current content is already a transition, destroy it, then load
					if (content is ContentTransition) {
						(content as ContentTransition).endTransition();
					}
					
					// create a new transition
					content = new ContentTransition(this, transition, this.content, content);
					
					// here we need to dispatch that our old filters went away
					for each (var filter:Filter in content.filters) {
						super.dispatchEvent(new FilterEvent(FilterEvent.FILTER_REMOVED, filter));
					}
					
				}
				
				// pass the content on
				_createContent(content, settings);
				
			}
		}
		
		/**
		 * 	@private
		 * 	Initializes Content
		 */
		private function _createContent(content:Content, settings:LayerSettings):void {
			
			// get rid of earlier content
			if (!(content is ContentTransition)) {
				_destroyContent();
			}
			
			// store content
			this.content = content;
			
			// listen for events to forward			
			content.addEventListener(FilterEvent.FILTER_ADDED,			super.dispatchEvent);
			content.addEventListener(FilterEvent.FILTER_MUTED,			super.dispatchEvent);
			content.addEventListener(FilterEvent.FILTER_MOVED,			super.dispatchEvent);
			content.addEventListener(FilterEvent.FILTER_REMOVED,		super.dispatchEvent);
			content.addEventListener(TransitionEvent.TRANSITION_END,	_endTransition);
			
			// apply settings & midi
			if (settings) {
				settings.apply(content);
			}
			
			// render first frame
			content.render(null);
			
			// dispatch a "i'm loaded" event if it's not a transition
			if (!(content is ContentTransition)) {
				
				// dispatch a load event
				super.dispatchEvent(new LayerEvent(LayerEvent.LAYER_LOADED));
				
			}
		}
		
		
		/**
		 * 	@private
		 * 	Destroys the current content state
		 */
		private function _destroyContent():void {
			
			if (content !== NULL_LAYER) {
				
				// destroys the earlier content
				content.removeEventListener(TransitionEvent.TRANSITION_END, _endTransition);
				
				// dispatch an unload event
				super.dispatchEvent(
					new LayerEvent(LayerEvent.LAYER_UNLOADED)
				);
				
				// fill rect
				data.fillRect(DISPLAY_RECT, 0);
				data.lock();
				
				// blow it up
				content.dispose();
				
				// removes listener forwarding
				content.removeEventListener(FilterEvent.FILTER_ADDED,	super.dispatchEvent);
				content.removeEventListener(FilterEvent.FILTER_MOVED,		super.dispatchEvent);
				content.removeEventListener(FilterEvent.FILTER_REMOVED,	super.dispatchEvent);
				content.removeEventListener(FilterEvent.FILTER_MUTED,		super.dispatchEvent);
				
			}
		}
		
		/**
		 * 	@private
		 *	Handler for when a transition ends (swap the content
		 */
		private function _endTransition(event:TransitionEvent):void {
			
			// create the content
			_createContent(event.content, null);
			
		}
		
		/**
		 * 	Sets time
		 */
		public function set time(value:Number):void {
			content.time = value;
		}
		
		/**
		 * 	Gets time
		 */
		public function get time():Number {
			return content.time;
		}
		
		/**
		 * 	Gets totalTime
		 */
		public function get totalTime():int {
			return content.totalTime;
		}
		
		/**
		 * 	Returns the path of the file loaded
		 */
		public function get path():String {
			return content.path;
		}
		
		/**
		 * 	Returns the control array of the layer
		 */
		public function getParameters():Parameters {
			return content.getParameters();
		}
		
		/**
		 * 	Gets the framerate of the movie adjusted to it's own time rate
		 */
		public function get framerate():Number {
			return content.framerate;
		}
		
		/**
		 * 	Sets the framerate
		 */
		public function set framerate(value:Number):void {
			content.framerate = value;
		}
		
		/**
		 * 	Gets the start loop point
		 */
		public function get loopStart():Number {
			return content.loopStart;
		}
		
		/**
		 * 	Sets the start loop point
		 */
		public function set loopStart(value:Number):void {
			content.loopStart = value;
		}
		
		/**
		 * 	Gets the start marker
		 */
		public function get loopEnd():Number {
			return content.loopEnd;
		}
		
		/**
		 * 	Sets the right loop point for the video
		 * 	@param		Percentage for the end loop point
		 */
		public function set loopEnd(value:Number):void {
			content.loopEnd = value;
		}
		
		/**
		 * 	Pauses the layer
		 *	@param		True to pause, false to unpause
		 */
		public function pause(b:Boolean):void {
			_paused = b;
			content.pause(b);
		}
		/**
		 * 	Return paused
		 */
		public function get paused():Boolean {
			return _paused;
		}		
		/**
		 * 	Sets alpha of current content
		 */
		public function set alpha(value:Number):void {
			content.alpha = value;
		}
		
		/**
		 * 	Gets alpha of current content
		 */
		public function get alpha():Number {
			return content.alpha;
		}
		
		/**
		 * 	Sets alpha of current content
		 */
		public function set blendMode(value:String):void {
			content.blendMode = value;
		}
		
		/**
		 * 	Sets the x of current content
		 */
		public function set x(value:Number):void {
			content.x = value;
		}
		
		/**
		 * 	Sets the y of current content
		 */
		public function set y(value:Number):void {
			content.y = value;
		}
		
		/**
		 * 	Sets scaleX for current content
		 */
		public function set scaleX(value:Number):void {
			content.scaleX = value;
		}
		
		/**
		 * 	Sets scaleY for current content
		 */
		public function set scaleY(value:Number):void {
			content.scaleY = value;
		}
		
		/**
		 * 	Gets scaleX for current content
		 */
		public function get scaleX():Number {
			return content.scaleX;
		}
		
		/**
		 * 	Gets scaleY for current content
		 */
		public function get scaleY():Number {
			return content.scaleY;
		}
		
		/**
		 * 	Gets x for current content
		 */
		public function get x():Number {
			return content.x;
		}
		
		/**
		 * 
		 */
		public function get anchorX():Number {
			return content.anchorX;
		}
		
		/**
		 * 
		 */
		public function set anchorX(value:Number):void {
			content.anchorX = value;
		}
		
		/**
		 * 
		 */
		public function get anchorY():Number {
			return content.anchorY;
		}
		
		/**
		 * 
		 */
		public function set anchorY(value:Number):void {
			content.anchorY = value;
		}
		
		/**
		 * 	Gets y for current content
		 */
		public function get y():Number {
			return content.y;
		}
		
		/**
		 * 	Gets content rotation
		 */
		public function get rotation():Number {
			return content.rotation / (Math.PI / 180);
		}
		
		/**
		 * 	Sets content rotation
		 */
		public function set rotation(value:Number):void {
			content.rotation = value * (Math.PI / 180);
		}
		
		/**
		 * 	Adds an onyx-based filter
		 * 	The onyx filter to add to the Layer
		 */
		public function addFilter(filter:Filter):void {
			content.addFilter(filter);
		}
		
		/**
		 * 	Removes an onyx filter from the layer
		 * 	@param		The filter to remove
		 **/
		public function removeFilter(filter:Filter):void {
			content.removeFilter(filter);
		}
		
		/**
		 * 	Mutes a filter
		 */
		public function muteFilter(filter:Filter, toggle:Boolean = true):void {
			content.muteFilter(filter, toggle);
		}
		
		/**
		 * 	Returns the filters
		 */
		public function get filters():Array {
			return content.filters;
		}
		
		/**
		 * 	Returns the index of the layer within the display
		 **/
		public function get index():int {
			return _display.layers.indexOf(this);
		}
		
		/**
		 * 	Returns properties related to the layer
		 */
		public function getProperties():Parameters {
			return layerProperties;
		}
		
		/**
		 * 	Forwards event to the content
		 * 	(usually mouse events)
		 */
		public function forwardEvent(event:InteractionEvent):void {
			content.dispatchEvent(event);
		}
		
		/**
		 * 	Returns filter index
		 */
		public function getFilterIndex(filter:Filter):int {
			return content.getFilterIndex(filter);
		}
		
		/**
		 * 	Move Filter
		 */
		public function moveFilter(filter:Filter, index:int):void {
			content.moveFilter(filter, index);
		}
		
		/**
		 * 	Gets Blendmode
		 */
		public function get blendMode():String {
			return content.blendMode;
		}
		
		/**
		 * 	Renders
		 */
		public function render(info:RenderInfo):void {
			
			// render
			content.render(null);
			
			// copy
			this.source.copyPixels(content.source, DISPLAY_RECT, ONYX_POINT_IDENTITY);
			
			// dispatch
			dispatchEvent(LAYER_RENDER);
		}
		
		/**
		 *	Gets the source before filters are rendered
		 */
		public function get source():BitmapData {
			return data;
		}
		
		/**
		 * 	Returns the associated display
		 */
		public function get display():IDisplay {
			return _display;
		}
		
		/**
		 * 	Returns visibility
		 */
		public function get visible():Boolean {
			return content.visible;
		}
		
		/**
		 * 	Sets the visibility
		 */
		public function set visible(value:Boolean):void {
			content.visible = value;
		}
		
		/**
		 * 	Returns xml representation of the layer
		 */
		public function toXML():XML {
			
			const xml:XML = <layer path={path} index={index}/>;
			
			// create properties
			xml.appendChild(layerProperties.toXML('properties'));
			
			// add filters xml
			if(path) {
				xml.appendChild(content.filters.toXML());
			}
			
			// add parameters xml
			if ( content.getParameters() ) {
				xml.appendChild(content.getParameters().toXML());
			}
			
			return xml;
		}
		
		/**
		 * 	Sets whether the channel is A or B
		 */
		public function set channel(value:Boolean):void {
			_channel = value;
		}
		
		/**
		 * 	Returns whether the channel is on channel A or B 
		 */
		public function get channel():Boolean {
			return _channel;
		}
		
		/**
		 * 	Applies a filter to the rendered output
		 */
		public function applyFilter(filter:IBitmapFilter):void {
			content.applyFilter(filter);
		}
		
		/**
		 * 
		 */
		public function getColorTransform():ColorTransform {
			return content.getColorTransform();
		}
		
		final public function set brightness(value:Number):void {
			content.brightness = value;
		}
		final public function get brightness():Number {
			return content.brightness;
		}
		
		
		final public function set contrast(value:Number):void {
			content.contrast = value;
		}
		final public function get contrast():Number {
			return content.contrast;
		}
		
		
		final public function set saturation(value:Number):void {
			content.saturation = value;
		}
		final public function get saturation():Number {
			return content.saturation;
		}
		
		
		final public function set hue(value:Number):void {
			content.hue = value;
		}
		final public function get hue():Number {
			return content.hue;
		}
		
		
		final public function get contentWidth():Number {
			return DISPLAY_WIDTH;
		}
		
		final public function get contentHeight():Number {
			return DISPLAY_HEIGHT;
		}
		
		/**
		 * 	String representation of the layer
		 */
		override public function toString():String {
			return (content.path) ? this.index + ': ' + content.path : '';
		}
		
		/**
		 * 	Disposes the layer
		 */
		public function dispose():void {
			
			// disposes content
			if (content) {
				
				// change target (performance)
				layerProperties.setNewTarget(this);
				
				// destroy the content
				_destroyContent();
				
				// set content to nothing					
				content			= NULL_LAYER;
				
			}
		}
	}
}