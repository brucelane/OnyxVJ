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
	
	/**
	 * 
	 */
	public final class ContentMicrophone extends ContentBase {
		
		/**
		 * 	@public
		 * 	Render a visualizer?
		 */
		public var visualizer:Visualizer;
		
		/**
		 * 	@private
		 */
		private var _mic:Microphone;
		
		/**
		 * 	@private
		 */
		private var _level:int;
		
		/**
		 * 	@private
		 */
		private var _transform:SoundTransform	= new SoundTransform(.5);
		
		/**
		 * 	@constructor
		 */
		public function ContentMicrophone(layer:Layer, path:String, mic:Microphone):void {
			
			// create base parameters
			customParameters = new Parameters(this);
			customParameters.addParameters(
				new ParameterPlugin('visualizer', 'visualizer', PluginManager.visualizers),
				new ParameterInteger('level', 'level', 0, 100, 50)
			);
			
			_mic = mic;
			_mic.gain = 80;
			_mic.rate = 44;
			_mic.setUseEchoSuppression(true);
			_mic.setLoopBack(true);//false don't reroute to speakers
			_mic.setSilenceLevel(4, 1000);
			
			_mic.addEventListener(ActivityEvent.ACTIVITY, this.onMicActivity);
			_mic.addEventListener(StatusEvent.STATUS, this.onMicStatus);
			super(layer, path, null, DISPLAY_WIDTH, DISPLAY_HEIGHT);
		}
		
		//Mic
		private function onMicActivity(event:ActivityEvent):void
		{
			level = _mic.activityLevel;
			trace("activating=" + event.activating + ", activityLevel=" + _mic.activityLevel);
			
		}
		
		private function onMicStatus(event:StatusEvent):void
		{
			level = _mic.activityLevel;
			trace("status: level=" + event.level + ", code=" + event.code);
			getMicStatus();
		}
		private function getMicStatus():int
		{
			var micDetails:String = _mic.activityLevel.toString();
			/* micDetails += "Sound input device name: " + _mic.name + '\n';
			micDetails += "Gain: " + _mic.gain + '\n';
			micDetails += "Rate: " + _mic.rate + " kHz" + '\n';
			micDetails += "Muted: " + _mic.muted + '\n';
			micDetails += "Silence level: " + _mic.silenceLevel + '\n';
			micDetails += "Silence timeout: " + _mic.silenceTimeout + '\n';
			micDetails += "Echo suppression: " + _mic.useEchoSuppression + '\n'; */
			//trace(micDetails);
			
			return _mic.activityLevel;
		}
		
		/**
		 * 
		 */
		public function set level(value:int):void {
			_level = value;
		}
		
		/**
		 * 
		 */
		public function get level():int {
			return _level ;
		}
				
		/**
		 * 	Updates the bitmap source
		 */
		override public function render(info:RenderInfo):void {
			
			if (visualizer) {
				
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
				
				// render visualizer
				visualizer.render(renderInfo);
				
				// color adjustment
				if (!(_saturation === 1 && _brightness === 0 && _contrast === 0 && _hue === 0)) {
					
					// apply filter
					_source.applyFilter(_source, DISPLAY_RECT, ONYX_POINT_IDENTITY, colorMatrix.filter);
					
				}
				
				// render filters
				_filters.render(_source);
				
			}
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			super.dispose();
			
			_mic		= null;
		}
	}
}