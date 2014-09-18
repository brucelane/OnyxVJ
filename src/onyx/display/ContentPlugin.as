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
package onyx.display {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	use namespace onyx_ns;
	
	internal final class ContentPlugin extends ContentBase {
		
		/**
		 * 	@private
		 */
		private var _render:IRenderObject;

		/**
		 * 	@constructor
		 */
		public function ContentPlugin(layer:LayerImplementor, path:String, renderable:IRenderObject):void {
			
			_render = renderable;
			
			// super
			super(layer, path, null, DISPLAY_WIDTH, DISPLAY_HEIGHT);
		}
		
		/**
		 * 	Updates the bimap source
		 */
		override public function render(info:RenderInfo):void {
			//var content:IRenderObject			= _render as IRenderObject;
			//var transform:RenderTransform		= content.render();
			//var drawContent:IBitmapDrawable		= transform.content || _content;
			
			// render content
			// renderContent(_source, drawContent, transform, _filter);
			
			// render filters
			//_filters.render(_source);
			
		}
		
		/**
		 * 	
		 */
		override public function get time():Number {
			return 0;
		}
		
		/**
		 * 	
		 */
		override public function set time(value:Number):void {
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {

			_render.dispose();
			_render = null;
			
			super.dispose();

		}
	}
}