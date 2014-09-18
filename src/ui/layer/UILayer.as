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
package ui.layer {
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.*;
	import flash.utils.Dictionary;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.string.*;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.controls.filter.*;
	import ui.controls.layer.*;
	import ui.controls.page.*;
	import ui.core.*;
	import ui.states.*;
	import ui.styles.*;
	import ui.text.*;
	import ui.window.*;

	/**
	 * 	Controls layers
	 */	
	public final class UILayer extends UIFilterControl implements IFilterDrop, ILayerDrop {
		
		/**
		 * 	
		 */
		public static function selectFilterPlugin(plugin:Plugin):void {
			
			// pass in a plugin to select the filter
			for each (var layer:UILayer in layers) {
				layer.selectFilter(plugin);
			}
			
		}
		
		/**
		 * 
		 */
		public static function deleteFilterPlugin(plugin:Plugin):void {
			
			// pass in a plugin to select the filter
			for each (var layer:UILayer in layers) {
				layer.deleteFilter(plugin);
			}

		}

		/**
		 * 	@private
		 */
		private static const SCRUB_LEFT:int				= 8;

		/**
		 * 	@private
		 */
		private static const SCRUB_RIGHT:int			= 236;

		/**
		 * 	@private
		 */
		private static const LAYER_WIDTH:int			= SCRUB_RIGHT - SCRUB_LEFT;

		/**
		 * 	@private
		 */
		public static const layers:Dictionary			= new Dictionary(true);
		
		/**
		 * 	Selects a layer
		 */
		public static function selectLayer(index:int):void {
			UIObject.select(layers[Display.getLayerAt(index)]);
		}

		/********************************************************
		 * 
		 * 					CLASS MEMBERS
		 * 
		 **********************************************************/

		/** @private **/
		private var _layer:LayerImplementor;

		/** @private **/
		private const btnCopy:ButtonClear					= new ButtonClear();

		/** @private **/
		private const btnDelete:ButtonClear					= new ButtonClear();
		
		/** @private **/
		private var btnVisible:LayerVisible;
		
		/** @private **/
		private const loopStart:LoopStart					= new LoopStart();

		/** @private **/
		private const loopEnd:LoopEnd						= new LoopEnd();
		
		/** @private **/
		private const assetLayer:AssetLayer					= new AssetLayer();

		/** @private **/
		private const assetScrub:ScrubArrow 				= new ScrubArrow();

		/** @private **/
		private const btnScrub:ButtonClear					= new ButtonClear();

		/** @private **/
		public const preview:Bitmap							= new Bitmap();

		/** @private **/
		private const filename:Bitmap						= new Bitmap(new BitmapData(162, 7, true, 0), PixelSnapping.ALWAYS, false);
		
		/** @private **/
		// BL 20100811: private var crossFaderToggle:CrossFaderToggle2; 
		private var crossFaderToggle:CrossFaderToggle; 
		
		/**
		 * 	@private
		 */
		private var blendDrop:DropDown;
				
		/**
		 * 	@constructor
		 **/
		public function UILayer(layer:LayerImplementor):void {
			
			// register for file drops
			Browser.registerTarget(this, true);
			
			// get properties
			const props:Parameters	= layer.getProperties();
			
			// register for filter drops
			super(
				layer,
				new LayerPage('BASIC',	null,
					props.getParameter('position'),
					props.getParameter('alpha'),
					props.getParameter('scale'),
					props.getParameter('anchor'),
					props.getParameter('brightness'),
					props.getParameter('contrast'),
					props.getParameter('saturation'),
					props.getParameter('hue'),
					props.getParameter('rotation'),
					props.getParameter('framerate')
				),
				new LayerPage('FILTER', null),
				new LayerPage('CUSTOM')
			);
			
			// store layer
			_layer = layer;
			
			// push
			layers[layer] = this;

			// draw
			_draw();
			
			// add handlers			
			_assignHandlers(true);

			// if there is no selected layer, select current layer
			if (!UIObject.selection) {
				UIObject.select(this);
			}
			
			// if there's already a file in there, set it to update
			if (_layer.path) {
				layerLoad();
			}
			
		}

		/**
		 * 	Overrides the layer colortransform
		 */
		override public function get transform():Transform {
			var mtransform:MultiTransform = new MultiTransform(this, assetLayer, controlTabs);
			return mtransform;
		}
		
		/**
		 * 	@private
		 * 	assign handlers
		 */
		private function _assignHandlers(value:Boolean):void {
			
			if (value) {
				
				// add layer event handlers
				_layer.addEventListener(LayerEvent.LAYER_LOADED,	layerLoad);
				_layer.addEventListener(LayerEvent.LAYER_UNLOADED,	layerUnLoad);
				
				// when the scrub button is pressed
				btnScrub.addEventListener(MouseEvent.MOUSE_DOWN, scrubPress);
				
				// this listens for selecting the layer
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightDown);
	
				// buttons
				btnCopy.addEventListener(MouseEvent.MOUSE_DOWN, buttonPress);
				btnDelete.addEventListener(MouseEvent.MOUSE_DOWN, buttonPress);
	
				// when the layer is moved
				_layer.addEventListener(LayerEvent.LAYER_MOVE, position);
				
			} else {
				
				// add layer event handlers
				_layer.removeEventListener(LayerEvent.LAYER_LOADED,		layerLoad);
				_layer.removeEventListener(LayerEvent.LAYER_UNLOADED,	layerUnLoad);
				
				// when the scrub button is pressed
				btnScrub.removeEventListener(MouseEvent.MOUSE_DOWN,	scrubPress);
				
				// this listens for selecting the layer
				removeEventListener(MouseEvent.MOUSE_DOWN,				mouseDown);
				removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,		rightDown);
	
				// buttons
				btnCopy.removeEventListener(MouseEvent.MOUSE_DOWN,		buttonPress);
				btnDelete.removeEventListener(MouseEvent.MOUSE_DOWN,	buttonPress);
	
				// when the layer is moved
				_layer.removeEventListener(LayerEvent.LAYER_MOVE, position);
				
				// remove update
				removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
				
			}
		}
		
		/**
		 * 	@private
		 */
		private function rightDown(event:MouseEvent):void {
			// trace(event);
		}
	
		
		/**
		 * 	@private
		 */
		private function buttonPress(event:MouseEvent):void {
			
			switch (event.currentTarget) {
				case btnCopy:
					Display.copyLayer(_layer, _layer.index + 1);
					break;
				case btnDelete:
				
					// unload all layers
					if (event.ctrlKey) {
						for each (var layer:UILayer in UILayer.layers) {
							layer._layer.dispose();
						}
						
					// unload single layer
					} else {
						_layer.dispose();
					}

					// make sure the event doesn't propagate to any other methods
					event.stopPropagation();
					
					break;
			}
		}
		
		/**
		 * 	Moves a layer to a specified index
		 */
		public function moveLayer(index:int):void {
			Display.moveLayer(_layer, index);
		}
		
		/**
		 * 	@private
		 * 	Positions all the objects
		 */
		private function _draw():void {
			
			// resize preview
			preview.bitmapData		= _layer.source;
			preview.pixelSnapping	= PixelSnapping.ALWAYS;
			preview.smoothing		= false;
			preview.scaleX			= (241 / DISPLAY_WIDTH);
			preview.scaleY			= (181 / DISPLAY_HEIGHT);
			
			const props:Parameters = _layer.getProperties();
			
			loopStart.initialize(props.getParameter('loopStart'));
			loopEnd.initialize(props.getParameter('loopEnd'));
			
			btnVisible					= Factory.getNewInstance(LayerVisible);
			btnVisible.initialize(props.getParameter('visible'));
			
			// BL 20100811: crossFaderToggle			= new CrossFaderToggle2();
			crossFaderToggle			= new CrossFaderToggle(_layer);
			
			btnDelete.initialize(10, 10);
			btnCopy.initialize(10, 10);
			btnScrub.initialize(241, 9, false);
			
			blendDrop					= Factory.getNewInstance(DropDown) as DropDown;
			blendDrop.initialize(props.getParameter('blendMode'), new UIOptions(false, false, null, 80, 11));
			
			const options:UIOptions		= new UIOptions();
						
			addChildren(
			
				assetLayer,															0,			0,
				preview,															1,			1,
				filename,															3,			3,
				controlPage,														3,			221,

				blendDrop,															46,			187,
				filterPane,															142,		219,

				btnVisible,															201,		189,
				btnCopy,															214,		189,
				btnDelete,															227,		189,
				
				crossFaderToggle,													153,		188,
				tabContainer,														3,			204				
			);

			// set default locations for the ui objects that get moved / removed
			assetScrub.x	= SCRUB_LEFT,
			assetScrub.y	= 174,
			btnScrub.x		= 1,
			btnScrub.y		= 173,
			loopStart.x		= 10,
			loopStart.y		= 175,
			loopEnd.x		= SCRUB_LEFT - loopEnd.width,
			loopEnd.y		= 175;
			
			addChild(assetScrub);
			addChild(btnScrub);
			
		}
		
		/**
		 * 	@private
		 * 	Handler that is evoked when a layer has finished loading a file
		 */
		private function layerLoad(event:Event = null):void {
			
			// parse out the extension
			var path:String = _layer.path;
			
			// check for custom controls
			var params:Parameters = _layer.getParameters();
			if (params && params.length) {
				var page:LayerPage = pages[2];
				page.controls = _layer.getParameters();
				selectPage(2);
			}
			
			const source:BitmapData	= filename.bitmapData;
			const label:TextFieldOnyx = Factory.getNewInstance(ui.text.TextFieldOnyx);
			label.wordWrap = false;
			label.width = 200;
			label.text			= removePath(path).toUpperCase();
			label.filters		= [new DropShadowFilter(1,45,0,1,0,0)]
			source.fillRect(source.rect, 0);
			source.draw(label);
			label.filters		= [];
			
			// frame listener
			addEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			// if it has time, add the ui controls for time
			if (_layer.totalTime > 1) {
				
				// add time controls
				super.addChild(loopStart);
				super.addChild(loopEnd);
				
			} else {
				
				// check to see if added already
				if (loopStart.parent) {
					super.removeChild(loopStart);
					super.removeChild(loopEnd);
				}
			}
		}
		
		/**
		 * 	@private
		 *	Handler that is evoked when a layer is unloaded
		 */
		private function layerUnLoad(event:LayerEvent):void {
			
			const page:LayerPage = pages[2];
			if (page.controls) {
				page.controls = null;
			}
			// default controls
			selectPage(0);
			
			const source:BitmapData	= filename.bitmapData;
			source.fillRect(source.rect, 0);
			assetScrub.x	= SCRUB_LEFT;
			
			// remove scrub listener
			removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			// remove time controls if they're added
			if (loopStart.parent) {
				super.removeChild(loopStart);
				super.removeChild(loopEnd);
			}
		}
		
		/**
		 * 	@private
		 * 	Handler that is evoked to update the playhead location
		 */
		private function _updatePlayheadHandler(event:Event):void {

			// updates the playhead marker
			assetScrub.x = _layer.time * LAYER_WIDTH + SCRUB_LEFT;
			
		}

		/**
		 * 	@private
		 * 	Mouse handler that is evoked when the playhead button is pressed
		 */		
		private function scrubPress(event:MouseEvent):void {
			
			// remove listeners
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, scrubMove);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, scrubUp);
			
			removeEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			_layer.pause(true);

			scrubMove(event);
		}

		/**
		 * 	@private
		 * 	When the scrubber is moved, change the frame
		 */
		private function scrubMove(event:MouseEvent):void {
			
			var value:int = Math.min(Math.max(btnScrub.mouseX, SCRUB_LEFT), SCRUB_RIGHT);
			assetScrub.x = value;
			_layer.time = (value - SCRUB_LEFT) / LAYER_WIDTH;
			
		}

		/**
		 * 	@private
		 * 	When the scrub bar is moused up
		 */
		private function scrubUp(event:MouseEvent):void {

			// add our events back			
			addEventListener(Event.ENTER_FRAME, _updatePlayheadHandler);
			
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,	scrubMove);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP,		scrubUp);
			
			_layer.pause(false);

		}

		/**
		 * 	@private
		 * 	Handler for the mousedown select
		 */
		private function mouseDown(event:MouseEvent):void {
			
			UIObject.select(this);
			
			// check to see if we clicked on the top portion, if so, we're going to allow
			// dragging to move a layer
			if (mouseY < 136) {
				
				if (event.ctrlKey) {
					
					_forwardMouse(event);
					addEventListener(MouseEvent.MOUSE_MOVE, _forwardMouse);
					addEventListener(MouseEvent.MOUSE_UP, _stopForwardMouse);
				
				} else {
					
					StateManager.loadState(new LayerMoveState(this));
					
				}
				
			}
		}
		
		/**
		 * 	@private
		 * 	Forwards mouse events to the layer based on clicking the preview
		 */
		private function _forwardMouse(event:MouseEvent):void {
			const e:InteractionEvent	= new InteractionEvent(event.type);
			e.localX					= preview.mouseX;
			e.localY					= preview.mouseY;
			_layer.forwardEvent(e);
		}
		
		/**
		 * 	@private
		 * 	Forwards mouse events to the layer based on clicking the preview
		 */
		private function _stopForwardMouse(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _forwardMouse);
			removeEventListener(MouseEvent.MOUSE_UP, _stopForwardMouse);
			
			_forwardMouse(event);
		}

		/**
		 * 	Moves layer
		 */
		public function position(event:LayerEvent = null):void {
			x = _layer.index * 256;
		}
		
		/**
		 * 	Returns the index of the current layer
		 */
		public function get index():int {
			return _layer.index;
		}

		/**
		 * 	Returns layer associated to this control
		 */
		public function get layer():LayerImplementor {
			return _layer;
		}
		
		/**
		 * 	Selects a filter above or below currently selected filter
		 */
		public function selectFilterUp(up:Boolean):void {
			
			if (filterPane.selectedFilter) {
				const index:int = filterPane.selectedFilter.filter.index + (up ? -1 : 1);
				filterPane.selectFilter(filterPane.getFilter(_layer.filters[index]));
			} else {
				filterPane.selectFilter(filterPane.getFilter(_layer.filters[int((up) ? _layer.filters.length - 1 : 0)]));
			}

		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {

			// register for file drops
			Browser.registerTarget(this, false);
			
			// remove listeners
			_assignHandlers(false);

			// remove children
			super.dispose();
			
			// remove layer
			layers.splice(layers.indexOf(this), 1);
			
			// remove references
			_layer = null;
			
			if (UIObject.selection === this) {
				UIObject.select(null);
			}
		}
	}
}
