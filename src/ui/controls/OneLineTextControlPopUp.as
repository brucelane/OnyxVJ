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
package ui.controls {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.core.UIObject;
	import ui.states.*;
	import ui.styles.TEXT_INPUT;
	import ui.text.*;
	
	public final class OneLineTextControlPopUp extends UIObject {
		
		/**
		 * 	@private
		 */
		private var _input:ui.text.TextFieldOnyx;
		
		/**
		 * 	@private
		 */
		private var _control:Parameter;
		
		/**
		 * 	@private
		 */
		private var _states:Array;
		
		/**
		 * 	@constructor
		 */
		public function OneLineTextControlPopUp(parent:DisplayObjectContainer, background:BitmapData, width:int, height:int, text:String, control:Parameter = null):void {
			
			if (parent) {
				
				_control		= control;
				
				var bounds:Rectangle	= parent.getBounds(parent.stage);
				x						= bounds.x,
					y						= bounds.y;
				
				DISPLAY_STAGE.addChildAt(this, DISPLAY_STAGE.numChildren);
				DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_DOWN, _captureMouse);
				
				displayBackground(width, height);
				
				_input				= Factory.getNewInstance(ui.text.TextFieldOnyx);
				_input.width		= width - 4,
					_input.height		= height - 4,
					_input.multiline	= true,
					_input.x			= 2,
					_input.y			= 2,
					_input.text			= text;
				_input.selectable	= true;
				_input.mouseEnabled	= true;
				_input.type			= TextFieldType.INPUT;
				_input.defaultTextFormat = TEXT_INPUT;
				
				addChild(_input);
				
				_input.addEventListener(FocusEvent.FOCUS_IN, _onFocus);
				
				_input.setSelection(0, text.length - 1);
				_input.addEventListener(Event.CHANGE, _onChange);
			}
			
			mouseEnabled	= true,
				mouseChildren	= true;
			
		}
		
		/**
		 * 	@private
		 */
		private function _onFocus(event:FocusEvent):void {
			
			StateManager.pauseStates(ApplicationState.KEYBOARD);
			
		}
		
		/**
		 * 	@private
		 */
		private function _onChange(event:Event):void 
		{
			var l:int = _input.text.length;
			if ( l > 1 && _input.text.charCodeAt(l - 1) == 13 )
			{
				_cleanUp();
			}			
			else
				_control.value = _input.text;
		}
		
		/**
		 * 	@private
		 */
		private function _captureMouse(event:MouseEvent):void {
			
			if (!hitTestPoint(DISPLAY_STAGE.mouseX, DISPLAY_STAGE.mouseY)) {
				
				_cleanUp();
			}
			
			event.stopPropagation();
		}
		/**
		 * 	@private
		 */
		private function _cleanUp():void 
		{
			
			if (_control) {
				// _control.value = _input.text;
				_control = null;
			}
			
			// check for keylistener states, and turn them back on
			if (_states) {
				for each (var state:ApplicationState in _states) {
					state.initialize();
				}
			}
			
			dispose();
		}		
		/**
		 * 
		 */
		override public  function dispose():void {
			_input.removeEventListener(FocusEvent.FOCUS_IN, _onFocus);
			_input.removeEventListener(Event.CHANGE, _onChange);
			_input = null;
			
			
			// remove mouse capturing
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, _captureMouse, false);
			//ADDED: caused error for instance on typewriter patch quit
			if (parent) {
				DISPLAY_STAGE.removeChild(this);
			}
		}
	}
}