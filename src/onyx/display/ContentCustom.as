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
	import flash.geom.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class ContentCustom extends ContentBase {
		
		/**
		 * 	@private
		 * 	Stores the loader object where the content was loaded into
		 */
		private var loader:Loader;
		
		/**
		 * 	@private
		 */
		private var loaderInfo:LoaderInfo;

		/**
		 * 	@constructor
		 */		
		public function ContentCustom(layer:LayerImplementor, path:String, loader:Loader):void {
			
			this.loader	= loader,
			loaderInfo	= loader.contentLoaderInfo;
			
			// pass parameters
			super(layer, path, loader.content, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			
		}
		
		/**
		 * 	Render
		 */
		override public function render(info:RenderInfo):void {
			
			// if dirty, build the matrix
			if (renderDirty) {
				buildMatrix(); 
				renderDirty = false;
			}
			
			// test filter change
			if (colorDirty) {
				colorMatrix.reset();
				colorMatrix.adjustBrightness(_brightness);
				colorMatrix.adjustContrast(_contrast);
				colorMatrix.adjustHue(_hue);
				colorMatrix.adjustSaturation(_saturation);
				
				colorDirty = false;
			}
			
			// clear 
			_source.fillRect(DISPLAY_RECT, 0);

			const content:IRenderObject			= _content as IRenderObject;
			content.render(renderInfo);
			
			// color adjustment
			if (!(_saturation === 1 && _brightness === 0 && _contrast === 0 && _hue === 0)) {

				// apply filter
				_source.applyFilter(_source, DISPLAY_RECT, ONYX_POINT_IDENTITY, colorMatrix.filter);
				
			}
			
			// render filters
			_filters.render(_source);
		}
		
		/**
		 * 	Destroys the content
		 */
		override public function dispose():void {
			
			// dispose
			super.dispose();

			// destroy content
			loader.unload();
		}
	}
}