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
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	public final class ColorPicker extends UIControl {
		
		/**
		 * 
		 */
		private static var colors:Array;
		
		/**
		 * 	Registers a color to be displayed on the swatch
		 */
		public static function registerSwatch(colors:Array):void {
			
			ColorPicker.colors = colors;
			
			var len:int			= colors.length;
			var bmp:BitmapData	= new BitmapData(len * 10, 10, false);

			var rect:Rectangle = new Rectangle(0,0,10,10);

			for (var count:int = 0; count < len; count++) {
				bmp.fillRect(rect, colors[count]);
				rect.offset(10, 0);
			}
			
			SWATCH.bitmapData = bmp;
		}
		
		/**
		 * 
		 */
		public static function toXML():XML {
			var xml:XML = <swatch />;
			for each (var color:uint in colors) {
				xml.appendChild(<color>0x{color.toString(16)}</color>);
			}
			return xml;
		}
		
		/**
		 * 	@private
		 */
		private static const DISPLAY_STAGE_COLOR:BitmapData = new BitmapData(1, 1, false);
		
		/**
		 * 	@private
		 */
		private static const RECT:Rectangle			= new Rectangle(0, 0, 1, 1);
		
		/**
		 * 	@private
		 */
		private static const SWATCH:Bitmap			= new Bitmap(null, PixelSnapping.ALWAYS, false);
		
		/**
		 * 	@private
		 */
		private static const MATRIX:Matrix			= new Matrix();
		
		/**
		 * 	@private
		 */
		private static var _picker:Picker;

		/**
		 * 	@private
		 */
		private var _preview:Shape					= new Shape();

		/**
		 * 	@private
		 */
		private var _lastX:int			= 0;

		/**
		 * 	@private
		 */
		private var _lastY:int			= 0;
		
		/**
		 * 
		 */
		public function ColorPicker():void {
			super.setMovesToTop(true);
		}

		/**
		 * 
		 */
		override public function initialize(control:Parameter, options:UIOptions = null):void {
			
			super.initialize(control, options);
			
			_draw(options.width, options.height);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			useHandCursor	= true;
			buttonMode		= true;
			mouseChildren	= false;
			
			if (!_picker) {
				_picker		= new Picker();
				SWATCH.y	= 100;
				_picker.addChild(SWATCH);
			}
		}
		
		/**
		 * 	Begin initial fill
		 */
		private function _draw(width:int, height:int):void {
			
			var graphics:Graphics = _preview.graphics;
			graphics.beginFill(0x000000);
			graphics.drawRect(1, 1, width - 2, height - 2);
			graphics.endFill();

			addChild(_preview);
		}
		
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			
			_picker.x	= -_lastX + mouseX;
			_picker.y	= -_lastY + mouseY;
			
			// add to the root outside container so it doesn't clip
			CONTAINER.display(this, _picker);
			
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
			_mouseMove(event);

			// prevent event propagation
			event.stopPropagation();
		}

		/**
		 * 	@private
		 */
		private function _mouseMove(event:MouseEvent):void {
			
			var transform:ColorTransform	= new ColorTransform();
			
			// first, check to see if we're hitting the picker, if so, grab the pixel directly
			if (_picker.mouseX > 0 && _picker.mouseX < 100 && _picker.mouseY > 0 && _picker.mouseY < 100) {

				var color:uint			= _picker.asset.bitmapData.getPixel(_lastX, _lastY);

				_picker.cursor.visible	= true;
				
				_lastX = Math.min(Math.max(_picker.mouseX,0),99);
				_lastY = Math.min(Math.max(_picker.mouseY,0),99);

				_picker.cursor.x = _lastX;
				_picker.cursor.y = _lastY;
				
			} else {
				
				_picker.cursor.visible	= false;

				MATRIX.tx = -DISPLAY_STAGE.mouseX;
				MATRIX.ty = -DISPLAY_STAGE.mouseY;

				DISPLAY_STAGE_COLOR.draw(DISPLAY_STAGE, MATRIX, null, null, RECT);
				color = DISPLAY_STAGE_COLOR.getPixel(0,0);

			}
						
			transform.color = color;
			parameter.value = transform.color;
			_preview.transform.colorTransform = transform;
			
		}

		/**
		 * 	@private
		 */
		public function _mouseUp(event:MouseEvent):void {

			CONTAINER.remove();
			
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
		}
		
		/**
		 * 	Changes color
		 */
		public function set color(c:int):void {
			var transform:ColorTransform = new ColorTransform();
			transform.color = c;
			_preview.transform.colorTransform = transform;
		}
		
		/**
		 * 
		 */
		override public function reflect():Class {
			return ColorPicker;
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			super.dispose();			
		}
	}
}

import flash.display.Sprite;
import ui.assets.AssetColorPicker;
import flash.display.Shape;
import flash.geom.ColorTransform;
import flash.display.Bitmap;	

/**
 *
 */
final class Picker extends Sprite {
	
	public var cursor:Shape				= new Shape();
	public var asset:AssetColorPicker	= new AssetColorPicker();
	
	/**
	 * 	@constructor
	 */
	public function Picker():void {

		addChild(asset);
		addChild(cursor);

		cursor.graphics.lineStyle(0, 0x000000);
		cursor.graphics.drawRect(0,0,2,2);
		
		mouseEnabled	= false;
		tabEnabled		= false;
	}
}