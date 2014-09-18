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
package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.plugin.*;
	import onyx.utils.*;
	
	import ui.controls.*;
	import ui.controls.filter.LibraryFilter;
	import ui.core.*;
	import ui.events.DragEvent;
	import ui.layer.*;
	import ui.policy.*;
	import ui.styles.*;
	
	/**
	 * 	Filters Window
	 */
	public final class Filters extends Window {
		
		/**
		 * 	@private
		 * 	An array of targets you can drag filters to
		 */
		private static const targets:Dictionary	= new Dictionary(true);

		/**
		 * 	Registers
		 */
		public static function registerTarget(obj:UIObject, enable:Boolean):void {
			(enable) ? targets[obj] = obj : delete targets[obj];
		}
		
		/**
		 * 	@private
		 */
		private const pane:ScrollPane		= new ScrollPane(232, 185);
		
		/**
		 * 	@private
		 */
		private const bitmapFilters:Array	= [];
		
		/**
		 * 	@private
		 */
		private const tempoFilters:Array	= [];
		
		/**
		 * 	@private
		 */
		private const soundFilters:Array	= [];
		
		/**
		 * 	@private
		 */
		private const allFilters:Array		= [];
		
		/**
		 * 	@private
		 */
		private var current:Array;
		
		/**
		 * 	@private
		 */
		private var allButton:TextButton;
		
		/**
		 * 	@private
		 */
		private var bitmapButton:TextButton;
		
		/**
		 * 	@private
		 */
		private var tempoButton:TextButton;
		
		/**
		 * 	@private
		 */
		private var soundButton:TextButton;
		
		/**
		 * 	@constructor
		 */
		public function Filters(reg:WindowRegistration):void {
			
			// set title, etc
			super(reg, true, 244, 217);
			
			draw();
		}
		
		/**
		 * 	@private
		 */
		private function draw():void {
			
			var sprite:DisplayObject;
			
			// draw stuff
			var options:UIOptions		= new UIOptions();
			options.height				= 12,
			options.width				= 55;
			
			allButton		= new TextButton(options, 'ALL');
			bitmapButton	= new TextButton(options, 'BITMAP');
			tempoButton		= new TextButton(options, 'TEMPO');
			soundButton		= new TextButton(options, 'SOUND');
			
			allButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			bitmapButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			tempoButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			soundButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			
			allButton.x		= 4,
			allButton.y		= 17,
			bitmapButton.x	= 74,
			bitmapButton.y	= 17,
			tempoButton.x	= 130,
			tempoButton.y	= 17,
			soundButton.x	= 186,
			soundButton.y	= 17,
			pane.x			= 4,
			pane.y			= 30;

			// add
			addChild(allButton);
			addChild(bitmapButton);
			addChild(tempoButton);
			addChild(soundButton);
			addChild(pane);

			// register filters
			for each (var plugin:Plugin in PluginManager.filters) {
				if (plugin.getData('bitmap')) {
					bitmapFilters.push(plugin);
				}
				if (plugin.getData('tempo')) {
					tempoFilters.push(plugin);
				}
				if (plugin.getData('sound')) {
					soundFilters.push(plugin);
				}
				allFilters.push(plugin);
			}
			
			bitmapFilters.sortOn('name');
			tempoFilters.sortOn('name');
			soundFilters.sortOn('name');
			allFilters.sortOn('name');

			current = allFilters;

			// create filter controls
			_createControls();
			
		}
		
		/**
		 * 
		 */
		private function handler(event:MouseEvent):void {
			switch (event.currentTarget) {
				case allButton:
					current = allFilters;
					break;
				case bitmapButton:
					current = bitmapFilters;
					break;
				case tempoButton:
					current = tempoFilters;
					break;
				case soundButton:
					current = soundFilters;
					break;
			}
			
			_createControls();
		}
		
		/**
		 * 	@private
		 */
		private function _createControls():void {
			
			var index:int = 0;
			
			_clearControls();
			
			for each (var plugin:Plugin in current) {
				
				var lib:LibraryFilter = new LibraryFilter(plugin);
				
				lib.x	= (index % 5) * 43,
				lib.y	= Math.floor(index / 5) * 33;
				
				// set it to listen for double clicks
				lib.doubleClickEnabled = true;
				
				// add listeners
				lib.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
				lib.addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClick);
				
				// add
				pane.addChild(lib);
				
				index++;
			}
		}

		/**
		 * 	@private
		 * 	Clear all controls
		 */
		private function _clearControls():void {
			
			while (pane.numChildren) {
				
				var lib:LibraryFilter = pane.removeChildAt(0) as LibraryFilter;
				lib.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
				lib.removeEventListener(MouseEvent.DOUBLE_CLICK, _doubleClick);
				
			}
		}
		
		/**
		 * 	@private
		 * 	Double Click
		 */
		private function _doubleClick(event:MouseEvent):void {
			
			var control:LibraryFilter	= event.target as LibraryFilter;
			var plugin:Plugin			= control.filter;
			var target:IFilterDrop		= UIObject.selection as IFilterDrop;
			
			if (target) {
				if (event.ctrlKey) {
					_applyToAll(plugin);
				} else {
					target.addFilter(plugin.createNewInstance() as Filter);
				}
			}
				
		}
		
		/**
		 * 	@private
		 * 	Mouse Down
		 */
		private function _mouseDown(event:MouseEvent):void {
			
			var control:LibraryFilter = event.currentTarget as LibraryFilter;
			DragManager.startDrag(control, targets, _onDragOver, _onDragOut, _onDragDrop);
			
		}
		
		/**
		 * 	@private
		 * 	Drag Over
		 */
		private function _onDragOver(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.transform.colorTransform = DRAG_HIGHLIGHT;
		}
		
		/**
		 * 	@private
		 */
		private function _onDragOut(event:DragEvent):void {
			var obj:UIObject = event.currentTarget as UIObject;
			obj.transform.colorTransform = DEFAULT;
		}
		
		/**
		 * 	@private
		 * 	Drag Handler
		 */
		private function _onDragDrop(event:DragEvent):void {
			var object:IFilterDrop		= event.currentTarget as IFilterDrop;
			var origin:LibraryFilter	= event.origin as LibraryFilter;
			var plugin:Plugin			= origin.filter;
			
			(object as DisplayObject).transform.colorTransform = DEFAULT;

			// if ctrl key is down, apply to all layers
			if (event.ctrlKey && !(object is UIDisplay)) {

				_applyToAll(plugin);

			} else {
				
				// just add the filter to the related object
				object.addFilter(plugin.createNewInstance() as Filter);
				
			}
		}
		
		/**
		 * 	@private
		 * 	Apply to all layers
		 */
		private function _applyToAll(plugin:Plugin):void {
			
			const layers:Dictionary = UILayer.layers;
			for each (var layer:UILayer in layers) {
				layer.addFilter(plugin.createNewInstance() as Filter);
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {

			// remove controls
			_clearControls();
			
			// remove listeners
			allButton.removeEventListener(MouseEvent.MOUSE_DOWN, handler);
			bitmapButton.removeEventListener(MouseEvent.MOUSE_DOWN, handler);
			tempoButton.removeEventListener(MouseEvent.MOUSE_DOWN, handler);
			soundButton.removeEventListener(MouseEvent.MOUSE_DOWN, handler);
			
			allButton		= null,
			bitmapButton	= null,
			tempoButton		= null;
			soundButton		= null;
			
			super.dispose();
		}
	}
}