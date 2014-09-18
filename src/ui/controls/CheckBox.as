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

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.core.*;
	
	import ui.styles.*;
	import ui.text.TextFieldCenter;
	
	/**
	 * 	Checkbox
	 */
	public class CheckBox extends UIControl {

		/**
		 * 	@private
		 */
		private var _value:*;

		/**
		 * 	@private
		 */
		private var _label:TextFieldCenter;
		
		/**
		 * 	@private
		 */
		private var _button:ButtonClear;

		/**
		 * 	@constructor
		 */
		public function CheckBox(options:UIOptions, control:ParameterArray):void {
			
			//super(options, control, true, control.display);

			_label			= Factory.getNewInstance(TextFieldCenter);
			_label.width	= options.width + 3;
			_label.height	= options.height;
			_label.x		= 0;
			_label.y		= 0;
			
			_button			= new ButtonClear();//options.width, options.height);
			_value			= control.value;
			
			_label.text		= _value;
			
			addChild(_label);
			addChild(_button);

			_onChanged();
			
			control.addEventListener(ParameterEvent.CHANGE, _onChanged);
			_button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
		}
		
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			const range:ParameterArray	= super.getParameter as ParameterArray;
			const data:Array				= range.data;
			const index:int				= data.indexOf(_value) + 1;
			getParameter().value			= (index >= data.length) ? data[0] : data[index];
		}
		
		/**
		 * 	@private
		 */
		private function _onChanged(event:ParameterEvent=null):void {
			
			const background:DisplayObject = super.getBackground();

			_value		= event ? event.value : _value;
			_label.text	= _value;
			
			if (background) {
				background.transform.colorTransform = _value ? LAYER_HIGHLIGHT : DEFAULT;
			}
			
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			getParameter().removeEventListener(ParameterEvent.CHANGE, _onChanged);
			_button.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			_button = null;
			
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

			super.dispose();
		}
	}
}