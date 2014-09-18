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
	
	/**
	 * 
	 */
	public final class ContentMP3 extends ContentBase {
	
		/**
		 * 	@public
		 * 	Render a visualizer?
		 */
		public var visualizer:Visualizer;
		
		/**
		 * 	@private
		 */
		private var _length:int;

		/**
		 * 	@private
		 */
		private var _sound:Sound;

		/**
		 * 	@private
		 */
		private var _channel:SoundChannel;
		
		/**
		 * 	@private
		 */
		private var _transform:SoundTransform	= new SoundTransform(.5);

		private var _loop:Boolean	= false;

		/**
		 * 	@constructor
		 */
		public function ContentMP3(layer:Layer, path:String, sound:Sound):void {
			
			// create base parameters
			customParameters = new Parameters(this);
			customParameters.addParameters(
				new ParameterPlugin('visualizer', 'visualizer', PluginManager.visualizers),
				new ParameterInteger('volume', 'volume', 0, 100, 50),
				new ParameterInteger('pan', 'pan', -100, 100, 0),
				new ParameterBoolean('loop', 'loop')
			);
			
			_sound		= sound;
			_length		= Math.max(int(sound.length / 100) * 100, 0);
			
			super(layer, path, null, DISPLAY_WIDTH, DISPLAY_HEIGHT);
		}
		
		/**
		 * 	@private
		 */
		public function get loop():Boolean
		{
			return _loop;
		}

		/**
		 * @private
		 */
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}

		/**
		 * 
		 */
		public function set volume(value:int):void {
			_transform.volume = value / 100;
			
			if (_channel) {
				_channel.soundTransform = _transform;
			}
		}
		
		/**
		 * 
		 */
		public function get volume():int {
			return _transform.volume * 100;
		}


		/**
		 * 
		 */
		public function set pan(value:int):void {
			_transform.pan = value / 100;
			
			if (_channel) {
				_channel.soundTransform = _transform;
			}
		}
		
		/**
		 * 
		 */
		public function get pan():int {
			return _transform.pan * 100;
		}
		
		/**
		 * 	Updates the bitmap source
		 */
		override public function render(info:RenderInfo):void {
			
			if (_channel) {
				
				var position:Number = Math.ceil(_channel.position);
				
				if (position >= (_loopEnd * _length) || position < (_loopStart * _length) || position >= _length) {
					_channel.stop();
					if ( loop == true ) _channel = _sound.play(_loopStart, 0, _transform);
				}
			}
			
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
		 * 	
		 */
		override public function get time():Number {
			return (_channel) ? _channel.position / _sound.length : 0;
		}
		
		/**
		 * 	
		 */
		override public function set time(value:Number):void {
			
			if (_channel) {
				_channel.stop();
			}
			
			_channel = _sound.play(value * _length);
			
		}
		
		/**
		 * 	
		 */
		override public function set loopStart(value:Number):void {
			_loopStart = __loopStart.dispatch(value) * _length;
		}
		
		/**
		 * 	
		 */
		override public function get loopStart():Number {
			return _loopStart / _length;
		}
		
		/**
		 * 	
		 */
		override public function set loopEnd(value:Number):void {
			_loopEnd = __loopEnd.dispatch(value) * _length;
		}
		
		/**
		 * 	
		 */
		override public function get loopEnd():Number {
			return _loopEnd / _length;
		}
		
		/**
		 * 	Dispose
		 */
		override public function dispose():void {

			super.dispose();
	
			_channel.stop();
			_channel	= null,
			_sound		= null;
		}
	}
}