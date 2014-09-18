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
package ui.controls {
	
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.styles.*;
	import ui.text.TextFieldCenter;

	
	/**
	 * 	Slider
	 */
	public class SliderV extends UIControl {
		
		/**
		 * 	@private
		 */
		protected var _multiplier:Number;
		
		/**
		 * 	@private
		 */
		protected var _factor:Number;
		
		/**
		 * 	@private
		 */
		protected var _toFixed:int;
		
		/**
		 * 	@private
		 */
		protected var _tempY:Number;

		/**
		 * 	@private
		 */
		protected const button:ButtonClear		= new ButtonClear();
		
		/**
		 * 	@private
		 */
		protected const label:TextFieldCenter	= Factory.getNewInstance(TextFieldCenter);
		
		/**
		 * 	@private
		 */
		protected var _mouseY:int;
		
		/**
		 * 
		 */
		override public function initialize(input:Parameter, options:UIOptions = null):void {
			
			super.initialize(input, options);
			
			var control:ParameterNumber	= input as ParameterNumber;
			var width:int				= options.width;
			var height:int				= options.height;
			var multiplier:Number		= control.multiplier;
			var factor:Number			= control.factor;
			var toFixed:Number			= 0;

			button.initialize(width, height);
			
			//label.defaultTextFormat	= TEXT_DEFAULT;
			label.width				= width + 3,
			label.height			= height,
			label.x					= 0,
			label.y					= 2;

			_multiplier			= multiplier;
			_factor				= factor;
			_toFixed			= toFixed;
			
			addChild(label);
			addChild(button);
			
			button.doubleClickEnabled	= true;
			button.addEventListener(MouseEvent.MOUSE_DOWN,		mouseDown);
			button.addEventListener(MouseEvent.DOUBLE_CLICK,	_reset);
			// TODO: reimplement without AIR
			//button.addEventListener(MouseEvent.RIGHT_CLICK,		_reset);
			button.addEventListener(MouseEvent.MOUSE_WHEEL,		_onMouseWheel);
			
			if (_toFixed > 0) {
				parameter.addEventListener(ParameterEvent.CHANGE, _onControlChangeFixed);
				_onControlChangeFixed();
			} else {
				parameter.addEventListener(ParameterEvent.CHANGE, _onControlChange);
				_onControlChange();
			}
			
			setMovesToTop(true);
		}
		
		/**
		 * 	@private
		 */
		protected function _onMouseWheel(event:MouseEvent):void {
			parameter.value = parameter.value + ((event.delta * 3) / _multiplier);
		}
		
		/**
		 * 	@private
		 */
		protected function _reset(event:MouseEvent):void {
			
			// reset
			parameter.reset();
			
			// stop propagation
			event.stopPropagation();
			
		}

		/**
		 * 	@private
		 */
		protected function mouseDown(event:MouseEvent):void {
			
			_mouseY = mouseY;
			_tempY = parameter.value * _multiplier;
			
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);

		}
		
		/**
		 * 	@private
		 */
		protected function _mouseMove(event:MouseEvent):void {
			
			var diff:Number = (_mouseY - mouseY) / _factor;
			
			parameter.value = (diff + _tempY) / _multiplier;
			
		}
		
		/**
		 * 	@private
		 */
		protected function _mouseUp(event:MouseEvent):void {

			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);

		}
		
		/**
		 * 	@private
		 */
		protected function _onControlChange(event:ParameterEvent = null):void {
			value	= String((((event) ? event.value : parameter.value) * _multiplier) >> 0);
		}
		
		/**
		 * 	@private
		 */
		protected function _onControlChangeFixed(event:ParameterEvent = null):void {
			value	= String(Number(((event) ? event.value : parameter.value) * _multiplier).toFixed(_toFixed));
		}
		
		/**
		 * 	Value
		 */
		protected function set value(value:String):void {
			label.text = value;
		}
		
		/**
		 * 
		 */
		override public function reflect():Class {
			return SliderV;
		}

		/**
		 * 	@method		cleans up references
		 */
		override public function dispose():void {

			// clean up event handlers
			button.removeEventListener(MouseEvent.MOUSE_DOWN,		mouseDown);
			button.removeEventListener(MouseEvent.DOUBLE_CLICK,	_reset);
			//button.removeEventListener(MouseEvent.RIGHT_CLICK,		_reset);
			button.removeEventListener(MouseEvent.MOUSE_WHEEL,		_onMouseWheel);
			
			// remove listeners
			parameter.removeEventListener(ParameterEvent.CHANGE, _onControlChange);
			parameter.removeEventListener(ParameterEvent.CHANGE, _onControlChangeFixed);

			// remove display objects

			removeChild(label);
			removeChild(button);
			
			// dispose, release
			super.dispose();
		}
	}
}