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
	
	import flash.events.NetStatusEvent;
	import flash.media.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;

	/**
	 * 
	 */
	public final class ContentFLV extends ContentBase {
		
		/**
		 * 	@private
		 */
		private var _stream:Stream;

		/**
		 * 	@private
		 */
		private var _totalTime:Number;

		/**
		 * 	@private
		 */
		private var _video:Video;
				
		/**
		 * 	@private
		 */
		private const _transform:SoundTransform	= new SoundTransform(.5);
	
		/**
		 * 	@constructor
		 */
		public function ContentFLV(layer:Layer, path:String, stream:Stream):void {

			_stream = stream;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, _onStatus);
			
			_totalTime			= stream.metadata.duration;
			
			const width:int		= stream.metadata.width;
			const height:int	= stream.metadata.height;
			
			_video			= new Video(width, height);
			_video.attachNetStream(stream);
			
			customParameters = new Parameters(this);
			customParameters.addParameters( 
				new ParameterInteger('volume', 'volume', 0, 100, 50),
				new ParameterInteger('pan', 'pan', -100, 100, 0)
			);
			
			super(layer, path, _video, width, height);
		}
		
		/**
		 * 
		 */
		public function set volume(value:int):void {
			_transform.volume = value / 100;
			
			_stream.soundTransform = _transform;
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
			
			_stream.soundTransform = _transform;
		}
		
		/**
		 * 
		 */
		public function get pan():int {
			return _transform.pan * 100;
		}
		
		/**
		 * 	@private
		 */
		private function _onStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case 'NetStream.Play.Complete':
					_stream.seek(_loopStart);
					break;
			}
		}
		
		/**
		 * 	@private
		 * 	Updates the bimap source
		 */
		override public function render(info:RenderInfo):void {
			
			var time:Number = _stream.time;
			
			// test loop points
			if (time >= _loopEnd || time < _loopStart) {
				_stream.seek(_loopStart);
			}

			// render
			super.render(info);
		}

		/**
		 * 
		 */
		override public function get time():Number {
			return _stream.time / _totalTime;
		}
		
		/**
		 * 	@private
		 * 	Goes to particular time
		 */		
		override public function set time(value:Number):void {
			_stream.seek(value * _totalTime);
		}
		
		/**
		 * 
		 */
		override public function get loopStart():Number {
			return _loopStart / _totalTime;
		}
		
		/**
		 * 	@private
		 * 	Sets Loop Start
		 */		
		override public function set loopStart(value:Number):void {
			_loopStart = __loopStart.dispatch(value) * _totalTime;
		}

		/**
		 * 
		 */
		override public function get loopEnd():Number {
			return _loopEnd / _totalTime;
		}
		
		/**
		 * 	@private
		 * 	Sets Loop Start
		 */		
		override public function set loopEnd(value:Number):void {
			_loopEnd = __loopEnd.dispatch(value) * _totalTime;
		}
		
		/**
		 * 
		 */
		override public function pause(value:Boolean):void {
			_paused = value;
			if (_paused) {
				_stream.pause();
			} else {
				_stream.resume();
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
		
			super.dispose();
			
			_video.attachNetStream(null);
			_stream.close();

			_video		= null,
			_stream		= null;
		}
	}
}