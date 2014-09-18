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
package ui.core {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.utils.*;
	
	import onyx.core.*;
	
	import ui.assets.AssetBitmap;
	import ui.assets.AssetWindow;
	import ui.styles.*;
	import ui.text.*;

	/**
	 * 	Base UIObject Class
	 */
	public class UIObject extends Sprite {
				
		/**
		 * 	The overall selection for the app
		 */
		public static var selection:UIObject;
		
		/**
		 * 	@private
		 */
		private var _label:flash.text.TextField;
		
		/**
		 * 	@constructor
		 */
		public function UIObject():void {
			tabEnabled = false;
		}
		
		/**
		 * 
		 */
		final public function setMovesToTop(value:Boolean):void {
			
			if (value) {
				this.addEventListener(MouseEvent.MOUSE_DOWN, moveToTop, false, 0, true);
			} else {
				this.removeEventListener(MouseEvent.MOUSE_DOWN, moveToTop);
			}
		}
		
		/**
		 * 
		 */
		public static function select(layer:UIObject):void {
			
			// select
			if (selection) {
				selection.setColor(DEFAULT);
			}
			
			// set
			if (layer) {
				layer.setColor(LAYER_HIGHLIGHT);
			}
			
			// select layer
			selection = layer;
		}
		
		/**
		 * 
		 */
		public function setColor(transform:ColorTransform):void {
			this.transform.colorTransform = transform;
		}
		
		/**
		 * 	Moves to the top
		 */
		final private function moveToTop(event:MouseEvent = null):void {
			
			parent.setChildIndex(this, parent.numChildren - 1);
			
		}	
		
		/**
		 * 	Creates a background
		 */
		final protected function displayBackground(width:int, height:int):void {
			addChildAt(new AssetBitmap(width, height), 0);
		}
		
		/**
		 * 
		 */
		final public function getBackground():DisplayObject {
			return getChildAt(0) as AssetBitmap || getChildAt(0) as AssetWindow;
		}
		
		/**
		 * 	Adds Children
		 */
		final public function addChildren(... args:Array):void {
			
			const len:int = args.length;
			for (var count:int = 0; count < len; count+=3) {
				
				args[count].x = args[count+1],
				args[count].y = args[count+2];

				addChild(args[count]);
			}
		}

		/**
		 * 	Disposes the UIObject
		 */
		public function dispose():void {
			
			if (parent) {
				parent.removeChild(this);
			}
			
			// clear children
			const numChildren:int = this.numChildren;
			for (var count:int = 0; count < numChildren; count++) {
				var child:DisplayObject = removeChildAt(0);
				
				if (child is IDisposable) {
					(child as IDisposable).dispose();
				}
			}
			
			// removes listener
			removeEventListener(MouseEvent.MOUSE_DOWN, moveToTop, true);
		}

		
		/**
		 * 	Adds a label to the control
		 */
		final public function addLabel(name:String, width:int, height:int, offsetY:int = -8, offsetX:int = 0, align:String = null, color:uint = TEXT_LABEL):void {
			
			if (_label && contains(_label)) {
				removeChild(_label);
			}
			
			switch (align) {
				case 'left':
					_label						= Factory.getNewInstance(ui.text.TextFieldOnyx);
					_label.x						= offsetX,
					_label.y						= offsetY,
					_label.width					= width,
					_label.height				= 12;
					_label.textColor				= color,
					_label.text					= name.toUpperCase(),
					_label.mouseEnabled			= false,
					
					super.addChild(_label);
					break;
				default:
				
					_label						= Factory.getNewInstance(ui.text.TextFieldCenter);
					_label.x						= offsetX,
					_label.y						= offsetY,
					_label.width					= width + 3,
					_label.height				= height,
					_label.textColor				= color,
					_label.text					= name.toUpperCase(),
					_label.mouseEnabled			= false;
		
					super.addChild(_label);

					break;
			}
		}
		
		/*public function get label():flash.text.TextField {
			return _label;
		}*/
	}
}