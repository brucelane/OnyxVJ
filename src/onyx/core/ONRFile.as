package onyx.core {
	
	import flash.display.*;
	import flash.utils.*;
	
	public final class ONRFile {
		
		private var	frames:ByteArray;
		private const	header:Array		= [];
		private var 	width:int;
		private var		height:int;
		
		/**
		 * 
		 */
		
		/**
		 * 	Sets frames (uncompressed bitmaps)
		 */
		public function setFrames(data:Array):void {
			
			// clear header
			header.splice(0, header.length);
			
			// clear out the bytearray
			frames			= new ByteArray();
			
			if (data.length) {
				
				// loop and compress
				for each (var imageData:BitmapData in data) {
					var imageBytes:ByteArray	= imageData.getPixels(imageData.rect);
					//AIR only : 
					imageBytes.compress(CompressionAlgorithm.ZLIB);
					header.push(frames.position)
					frames.writeBytes(imageBytes);
				}
				
				// save width and height
				width	= imageData.width;
				height	= imageData.height;
			}
		}
		
		/**
		 * 
		 */
		public function toByteArray():ByteArray {
			
			const bytes:ByteArray	= new ByteArray();
			bytes.writeUnsignedInt(0);
			bytes.writeUnsignedInt(width);
			bytes.writeUnsignedInt(height);
			
			// write file location
			for each (var loc:int in header) {
				bytes.writeUnsignedInt(loc);
			}
			
			// write major
			bytes.writeBytes(frames);
			
			// update header length
			bytes.position	= 0;
			bytes.writeUnsignedInt(header.length * 4 + 12);
			
			return bytes;
		}
		
	}
}