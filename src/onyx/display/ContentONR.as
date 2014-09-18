package onyx.display {
	
	import flash.display.*;
//	import flash.filesystem.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	public final class ContentONR extends ContentBase {
		
		/**
		 * 	@private
		 */
		private const header:Array		= [];
		
		/**
		 * 	@private
		 */
		private var bytes:ByteArray;
		
		/**
		 * 	@private
		 */
		private var bmp:BitmapData;
		
		/**
		 * 	@private
		 */
		private var lastTime:int;
		
		/**
		 * 	@private
		 * 	The amount of frames to move per frame
		 */
		private var _framerate:Number	= 1;
		
		/**
		 * 	@private
		 */
		private var _frame:Number		= 0;
		
		/**
		 * 	@private
		 */
		private var startPos:int;
		
		/**
		 * 	@constructor
		 */
		public function ContentONR(layer:Layer, path:String, bytes:ByteArray):void {
			
			bytes.position = 0;
			
			// store bytes
			this.bytes = bytes;

			// parse bytes and init			
			parse();
			
			// super
			super(layer, path, bmp, bmp.width, bmp.height);
		}
		
		/**
		 * 	@private
		 */
		private function parse():void {

			var length:int	= bytes.readUnsignedInt();
			var width:int	= bytes.readUnsignedInt();
			var height:int	= bytes.readUnsignedInt();
			
			// write header positions
			while (bytes.position < length) {
				header.push(bytes.readUnsignedInt());
			}
			
			startPos		= bytes.position;
			
			// set loop
			_loopStart		= 0;
			_loopEnd		= 1;

			// store last time
			this.lastTime	= getTimer() - DISPLAY_STAGE.frameRate;	// sets the last time we executed
			
			this.bmp		= new BitmapData(width, height, true, 0);
			this.bmp.lock();

		}
		
		/**
		 * 
		 */
		override public function render(info:RenderInfo):void {
			
			var start:int = getTimer();

			// fill the rect
			bmp.fillRect(bmp.rect, 0);
			
			var time:int			= getTimer();
			var stageRate:int		= DISPLAY_STAGE.frameRate;
			var ratio:Number		= ((time - lastTime) / (1000 / stageRate));
			var startFrame:Number	= header.length * _loopStart;
			var endFrame:Number		= header.length * _loopEnd;
			
			// set frame
			var frame:Number		= _frame + (_framerate * ratio);
			
			// save the frame				
			_frame = (frame < startFrame) ? endFrame : Math.max(frame % endFrame, startFrame);
			
			// store last time
			lastTime = time;
			
			var index:int			= _frame >> 0;
			
			if (header[index] is int) {
				
				var data:ByteArray		= new ByteArray();
				var current:int			= header[index];
				var next:int			= header[index + 1] || (bytes.length - startPos);
				
				bytes.position		= current + startPos;	
				bytes.readBytes(data, 0, next - current);	
								
				// uncompress
				//data.uncompress();
				
				// set pixels
				bmp.setPixels(bmp.rect, data);
				
				// set
				header[index]			= bmp.clone();
				
				
			} else {
				
				var image:BitmapData		= header[index];
				if (image) {
					bmp.copyPixels(image, image.rect, ONYX_POINT_IDENTITY);
				}
				
			}
			
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
		 * 	Sets the time
		 */
		override public function set time(value:Number):void {
			_frame	= header.length * value;

		}
		
		/**
		 * 	Gets the time
		 */
		override public function get time():Number {
			return _frame / header.length;
		}
		
		/**
		 * 	Gets the total time
		 */
		override public function get totalTime():int {
			return (header.length / 24) * 1000;
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
		 * 
		 */
		override public function dispose():void {
			
			bytes.position	= 0;
			bytes.length	= 0;
			
			super.dispose();
			
		}
	}
}