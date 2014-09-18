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
	
	import ui.styles.*;
	import ui.text.*;
	
	/**
	 * 	Relates to ControlExecute
	 */
	public final class ButtonControl extends UIControl {
		
		/**
		 * 	@private
		 */
		private var _label:TextFieldCenter;
		
		/**
		 * 	@private
		 */
		private const _button:ButtonClear		= new ButtonClear();
		
		/**
		 * 
		 */
		override public function initialize(control:Parameter, options:UIOptions = null):void {
			
			super.initialize(control, options);
			
			_button.initialize(options.width, options.height);
			
			_label				= Factory.getNewInstance(TextFieldCenter);
			_label.width		= options.width;
			_label.height		= options.height;
			_label.x			= 0;
			_label.y			= 2;
			
			addChild(_label);
			addChild(_button);
			
			_label.textColor	= 0x999999,
			_label.text			= (control is ParameterBoolean ? control.value : 'execute');

			if (control is ParameterBoolean) {
				control.addEventListener(ParameterEvent.CHANGE, change);
			}	

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		/**
		 * 	@private
		 */
		private function change(event:ParameterEvent):void {
			_label.text = event.value;
		}			

		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			
			if (parameter is ParameterBoolean) {
				
				const bool:ParameterBoolean	= parameter as ParameterBoolean;
				parameter.value				= !parameter.value;
				
			} else {
				
				const f:ParameterExecuteFunction = parameter as ParameterExecuteFunction;
				f.execute();

			}
			
			event.stopPropagation();
		}
		
		/**
		 * 	Reflection
		 */
		override public function reflect():Class {
			return ButtonControl;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			parameter.removeEventListener(ParameterEvent.CHANGE, change);
			
			super.dispose();
		}
	}
}