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
package ui.controls.layer {
	
	import flash.events.MouseEvent;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.parameter.*;
	
	import ui.controls.*;
	import ui.core.UIObject;
	import ui.styles.*;
	import ui.text.TextFieldOnyx;

	public final class CrossFaderToggle2 extends UIControl {

		/**
		 * 	@private
		 */
		private var toggle:ButtonClear	= new ButtonClear();
				
		/**
		 * 	@private
		 */
		private var _layer:LayerImplementor;
		
		/**
		 * 	@private
		 */
		private var _current:TextFieldOnyx;
		
		//public CrossFaderToggle2(layer:LayerImplementor) {
		//	_layer = layer;
		//}
		
		/**
		 * 
		 */
		override public function initialize(parameter:Parameter, options:UIOptions = null):void {

			super.initialize(parameter);
			
			_current			= Factory.getNewInstance(ui.text.TextFieldOnyx),
			_current.width		= 11,
			_current.height		= 11,
			_current.y			= 1,
			_current.textColor	= 0x00AA00;//0xCCCCCC;
			
			toggle.initialize(22, 11);
			toggle.x	= 12;
			
			if ( parameter )
			{
				parameter.addEventListener(ParameterEvent.CHANGE, _controlHandler);
				select(parameter.value);
			}
			toggle.addEventListener(MouseEvent.MOUSE_DOWN, _mouseHandler);
						
			addChild(toggle);
			addChild(_current);
			
		}
		
		/**
		 * 	@private
		 */
		private function _mouseHandler(event:MouseEvent):void {
			if ( parameter )
			{
				parameter.value = !parameter.value;
				select(parameter.value);
			}
		}
		
		/**
		 * 	@private
		 */
		private function _controlHandler(event:ParameterEvent):void {
			if ( parameter )
			{
				event.value = !parameter.value;
				select(event.value);
			}
		}
		
		/**
		 * 	@private
		 */
		private function select(val:Boolean):void {
			if (val) {
				_current.text	= 'B',
				_current.x		= 25;
				_current.textColor	= 0xAA0000;			
			} else {
				_current.text	= 'A',
				_current.x		= 14;
				_current.textColor	= 0x00AA00;							
			}
		}
		
		/**
		 * 
		 */
		override public function reflect():Class {
			return CrossFaderToggle2;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {

			toggle.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseHandler);
			super.dispose();
			
		}	
	}
}