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
		
		import ui.controls.ButtonClear;
		import ui.core.UIObject;
		import ui.styles.*;
		import ui.text.TextFieldOnyx;
		
		public final class CrossFaderToggle extends UIObject {
			
			/**
			 * 	@private
			 */
			private const toggleA:ButtonClear	= new ButtonClear();
			
			/**
			 * 	@private
			 */
			private const toggleB:ButtonClear	= new ButtonClear();
			
			/**
			 * 	@private
			 */
			private var _layer:LayerImplementor;
			
			/**
			 * 	@private
			 */
			private var _current:TextFieldOnyx;
			
			/**
			 * 	@constructor
			 */
			public function CrossFaderToggle(layer:LayerImplementor):void {
				
				_current	= Factory.getNewInstance(ui.text.TextFieldOnyx),
				_layer		= layer,
					
				toggleA.initialize(11, 11);
				toggleB.initialize(11, 11);
				
				_current.width		= 11,
				_current.height		= 11,
				_current.y			= 1,
				_current.textColor	= 0xCCCCCC;
				
				toggleA.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				toggleB.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				
				toggleA.x	= 12;
				toggleB.x	= 24;
				
				addChild(toggleA);
				addChild(toggleB);
				
				select();
			}
			
			/**
			 * 	@private
			 */
			private function mouseDown(event:MouseEvent):void {
				_layer.channel = event.currentTarget === toggleB; 
				select();
			}
			
			/**
			 * 	@private
			 */
			private function select():void {
				if (_layer.channel) {
					_current.text	= 'B',
					_current.x		= 25;
					
					addChild(_current);
					addChild(toggleA);
					
					removeChild(toggleB);
				} else {
					_current.text	= 'A',
					_current.x		= 14;
					
					addChild(_current);
					addChild(toggleB);
					
					removeChild(toggleA);
				}
			}
			
			/**
			 * 
			 */
			override public function dispose():void {
				
				super.dispose();
				
				toggleA.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				toggleB.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				
			}	
		}
	}