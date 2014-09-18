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
	import flash.system.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
			
	use namespace onyx_ns;
	
	public final class ContentMC extends ContentBase {
		
		/**
		 * 	@private
		 * 	Stores paths of loaded stuff
		 */
		private static const _dict:Object = {};
		
		/**
		 * 	@private
		 * 	Registers a loader
		 */
		public static function registration(path:String):ContentRegistration {
			return _dict[path];
		}
		
		/**
		 * 
		 */
		public static function register(path:String, loader:Loader = null):void {
			
			var reg:ContentRegistration = _dict[path];
			
			if (!reg) {
				reg			= new ContentRegistration(),
				reg.loader	= loader,
				_dict[path] = reg;
			}
			
			reg.refCount++;
		}
		
		/**
		 * 	Unregisters from shared
		 */
		public static function unregister(path:String):Boolean {
			
			var reg:ContentRegistration = _dict[path];
			
			if (reg) {
				reg.refCount--;
				
				if (reg.refCount === 0) {
					reg.dispose();
					delete _dict[path];
				}
			} else {
				return false;
			}
			
			return true;
		}
		
		/**
		 * 	@private
		 * 	The frame number we are currently should navigate to
		 */
		private var _frame:Number;
		
		/**
		 * 	@private
		 * 	The amount of frames to move per frame
		 */
		private var _framerate:Number;
		
		/**
		 * 	@private
		 * 	Stores last time the draw was executed
		 */
		private var _lastTime:uint;
		
		/**
		 * 	@private
		 */
		private var loaderInfo:LoaderInfo;
		
		/**
		 * 	@private
		 */
		private var mc:MovieClip;

		/**
		 * 	@constructor
		 */		
		public function ContentMC(layer:LayerImplementor, path:String, loader:Loader):void {

			loaderInfo		= loader.contentLoaderInfo,
			mc				= loader.content as MovieClip;

			super(layer, path, loader.content, loaderInfo.width, loaderInfo.height);

			_framerate		= 1, // sets the framerate based on the swf framerate
			_frame			= 0,
			_lastTime		= getTimer() - DISPLAY_STAGE.frameRate;	// sets the last time we executed
			
			_loopStart		= 0;
			_loopEnd		= 1;
		}

		/**
		 * 	Sets the time
		 */
		override public function set time(value:Number):void {
			_frame	= mc.totalFrames * value;
			
		}
		
		/**
		 * 	Gets the time
		 */
		override public function get time():Number {
			return _frame / (mc.totalFrames);
		}
		
		/**
		 * 	Gets the total time
		 */
		override public function get totalTime():int {
			return (mc.totalFrames / loaderInfo.frameRate) * 1000;
		}
		
		/**
		 * 	Updates the bimap source
		 */
		override public function render(info:RenderInfo):void {

			var lastTime:int = getTimer();
			
			if (!_paused) {
				
				// get ellapsed frame
				var stageRate:int		= DISPLAY_STAGE.frameRate;
				var time:int			= lastTime - _lastTime;
				var ratio:Number		= (time / (1000 / stageRate));
				var startFrame:Number	= mc.totalFrames * _loopStart;
				var endFrame:Number		= mc.totalFrames * _loopEnd;
				
				// set frame
				var frame:Number	= _frame + ((loaderInfo.frameRate / stageRate) * (_framerate * ratio));
				
				// constrain the frame
				frame = (frame < startFrame) ? endFrame : Math.max(frame % endFrame, startFrame);

				// save the frame
				_frame = frame;
								
			}

			// store last time
			_lastTime = lastTime;

			// go to the right frame
			mc.gotoAndStop(_frame << 0);

			// render
			super.render(info);
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
		 * 	Destroys the content
		 */
		override public function dispose():void {

			// dispose
			super.dispose();

			// unregister from the shared movieclips if it's the last one
			var value:Boolean = unregister(_path);
			
			if (!value && mc is IDisposable) {
				(mc as IDisposable).dispose();
			}
			
			// remove reference
			mc		= null;
		}

	}
}