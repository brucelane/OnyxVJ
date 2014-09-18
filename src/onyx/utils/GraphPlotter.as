/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
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
package onyx.utils {
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	/**
	 * 	Displays a graph over time
	 */
	public final class GraphPlotter extends Sprite implements IDisposable {
		
		/**
		 * 	@private
		 */
		public var maxY:Number;

		/**
		 * 	@private
		 */
		public var minY:Number;

		/**
		 * 	@private
		 */
		private var maxX:Number	= 0;

		/**
		 * 	@private
		 */
		private var minX:Number	= 0;
		
		/**
		 * 	@private
		 */
		private var _width:int;

		/**
		 * 	@private
		 */
		private var _height:int;
		
		/**
		 * 	@private
		 */
		private var _graph:Shape		= new Shape();
		
		/**
		 * 	@private
		 */
		private var _minText:TextField	= new TextField();

		/**
		 * 	@private
		 */
		private var _maxText:TextField	= new TextField();
		
		/**
		 * 	@private
		 */
		private var _currentText:TextField	= new TextField();
		
		/**
		 * 	@private
		 */
		private var _init:Boolean		= false;
		
		/**
		 * 	@private
		 */
		private var _firstVal:int		= getTimer();
		
		/**
		 * 	@constructor
		 */
		public function GraphPlotter(initValue:Number = 0, color:uint = 0xFFFF00, labelOffsetX:int = 104, width:int = 64, height:int = 45):void {

			_width	= width;
			_height = height;
			
			maxY = minY = initValue;

			_minText.width 		= width;
			_maxText.width 		= width;
			_currentText.width	= width;
			_currentText.height	= _minText.height = _maxText.height = 20;
			_minText.y			= height - 20;
			_currentText.y		= (height / 2) - 10;
			_currentText.selectable = _minText.selectable = _maxText.selectable = false;
			_currentText.textColor	= color && 0x00FF00;
			_minText.textColor = _maxText.textColor = color;
			_currentText.x = _minText.x = _maxText.x = labelOffsetX;
			
			var x:Number = 0;
			var y:Number = initValue;
			
			_calc(x, y);
			
			_graph.graphics.clear();
			_graph.graphics.lineStyle(0, color);
			_graph.graphics.moveTo(x, y);
			
			addChild(_graph);
			addChild(_minText);
			addChild(_maxText);
			addChild(_currentText);
		}
		
		/**
		 * 	@private
		 * 	Calculates minimum and maximum values
		 */
		private function _calc(x:Number, y:Number):void {
			maxY = Math.max(y, maxY);
			minY = Math.min(y, minY);
			maxX = Math.max(x, maxX);
			minX = Math.min(x, minX);
			
			_minText.text = minY.toFixed(0);
			_maxText.text = maxY.toFixed(0);
		}
		
		/**
		 * 	Registers a value to plot
		 */
		public function register(value:Number):void {
			
			var x:Number = (getTimer() - _firstVal) / DISPLAY_STAGE.frameRate;
			var y:Number = value;
			
			// calculate the x / y
			_calc(x, y);
			
			_currentText.text			= value.toFixed(0);

			// draw
			_graph.graphics.lineTo(x, y);
			
			// get ratio
			const ratioY:Number			= _height / (maxY - minY);
			_graph.y					= (maxY * ratioY);

			_graph.scaleY				= -ratioY;
			_graph.scaleX				= _width / maxX;
			
		}
		
		/**
		 * 	Dispose
		 */
		public function dispose():void {
			_graph.graphics.clear();
			_minText = null;
			_maxText = null;
		}
	}
}