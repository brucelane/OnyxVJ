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
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class ContentCustomTime extends ContentBase {
		
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
		 * 	@private
		 */
		private var _framerate:Number				= 1;
		
		/**
		 * 	@private
		 */
		private var patch:TimePatch;
		
		/**
		 * 	@private
		 * 	Stores last time the draw was executed
		 */
		private var lastTime:uint;
		
		/**
		 * 	@private
		 * 	The frame number we are currently should navigate to
		 */
		private var frame:Number					= 0;

		/**
		 * 	@constructor
		 */		
		public function ContentCustomTime(layer:LayerImplementor, path:String, loader:Loader):void {
			
			this.loader		= loader,
			loaderInfo		= loader.contentLoaderInfo;
			
			// set stuff
			patch			= loader.content as TimePatch;
			lastTime		= getTimer() - DISPLAY_STAGE.frameRate;	// sets the last time we executed
			
			// pass parameters
			super(layer, path, loader.content, DISPLAY_WIDTH, DISPLAY_HEIGHT);
			
		}
		
		
		/**
		 * 	Sets the time
		 */
		override public function set time(value:Number):void {
			
			frame	= patch.totalFrames * value;
			
		}
		
		/**
		 * 	Gets the time
		 */
		override public function get time():Number {
			return frame / (patch.totalFrames);
		}
		
		/**
		 * 	Gets the total time
		 */
		override public function get totalTime():int {
			return (patch.totalFrames / loaderInfo.frameRate) * 1000;
		}
		
		/**
		 * 	Gets the framerate
		 * 	get the ratio of the original framerate and the actual framerate
		 */
		override public function get framerate():Number {
			return _framerate;
		}

		/**
		 * 	Sets framerate
		 */
		override public function set framerate(value:Number):void {
			_framerate = super.__framerate.dispatch(value);
		}
		
		/**
		 * 	Sets the beginning loop point (percentage)
		 */		
		override public function set loopStart(value:Number):void {
			_loopStart	= __loopStart.dispatch(Math.min(value, _loopEnd));
		}
		
		/**
		 * 
		 */
		override public function get loopStart():Number {
			return _loopStart;
		}
		
		/**
		 * 	Sets the end loop point
		 */
		override public function set loopEnd(value:Number):void {
			_loopEnd = __loopEnd.dispatch(Math.max(value, _loopStart, 0.01));
		}
		
		/**
		 * 	Sets the end loop point
		 */
		override public function get loopEnd():Number {
			return _loopEnd;
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
			
			var lastTime:int = getTimer();
			
			if (!_paused) {
				
				// get ellapsed frame
				const stageRate:int		= DISPLAY_STAGE.frameRate;
				const time:int			= lastTime - this.lastTime;
				const ratio:Number		= (time / (1000 / stageRate));
				const startFrame:Number	= patch.totalFrames * _loopStart;
				const endFrame:Number	= patch.totalFrames * _loopEnd;
				
				// set frame
				this.frame = this.frame + ((loaderInfo.frameRate / stageRate) * (_framerate * ratio));
				
				// constrain the frame
				this.frame = (frame < startFrame) ? endFrame : Math.max(frame % endFrame, startFrame);
				
			}
			
			// store last time
			this.lastTime = lastTime;

			// set 
			renderInfo.currentFrame	= this.frame >> 0;
			
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
			
			//dispose
			super.dispose();

			// destroy content
			loader.unload();
		}
	}
}