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
package ui.file {
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.TextFieldAutoSize;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.utils.string.*;
	
	import ui.styles.*;
	import ui.text.*;
	
	/**
	 * 	Stores bytearray of files, and their associated thumbnails
	 */
	public final class AIRThumbnailDB {
		
		/**
		 * 	@private
		 */
		private var width:int;
		
		/**
		 * 	@private
		 */
		private var height:int;
		
		/**
		 * 	@private
		 */
		private var lookup:Dictionary	= new Dictionary(true);
		
		/**
		 * 
		 */
		public function AIRThumbnailDB(width:int = 64, height:int = 48):void {
			this.width	= width;
			this.height	= height;
		}
		
		/**
		 * 	Adds a file to the db
		 */
		public function addFile(path:String, data:BitmapData):void {
			
			if (!lookup[path]) {

				if (data.width !== width || data.height !== height) {
					var newbmp:BitmapData = new BitmapData(width, height, false, 0);
					newbmp.draw(data, new Matrix(width / data.width, 0, 0, height / data.height));
					data = newbmp;
				}

				// draw the label onto the thumbnail
				const label:TextFieldOnyx	= Factory.getNewInstance(TextFieldOnyx);
				label.height			= 10;
				label.autoSize			= TextFieldAutoSize.LEFT;
				label.filters			= [new DropShadowFilter(1,45,0,1,0,0)]
				label.text				= removePath(path).toUpperCase();
				label.wordWrap			= true;
				label.width				= data.width;
				/*switch(getExtension(path)) {
					case 'flv': label.textColor = 0xFF9933;
						break;
					case 'mp4': label.textColor = 0x6699FF;
						break;
					default:
				}*/
				// draw the label
				data.draw(label, new Matrix(1,0,0,1,0, data.height - label.textHeight - 4));
				// release the label for re-use
				label.filters		= [];
				Factory.release(TextFieldOnyx, label);
								
				// now draw a border
				data.fillRect(new Rectangle(0, 0, THUMB_WIDTH, 1), 0x5f6f7d);
				data.fillRect(new Rectangle(0, 1, 1, THUMB_HEIGHT), 0x5f6f7d);
				data.fillRect(new Rectangle(THUMB_WIDTH - 1, 0, 1, THUMB_HEIGHT), 0x5f6f7d);
				data.fillRect(new Rectangle(0, THUMB_HEIGHT - 1, THUMB_WIDTH, 1), 0x5f6f7d);

				var def:FileDef = new FileDef(path, data);
				lookup[path]	= def;
				
			}
		}
		
		/**
		 * 
		 */
		public function isEmpty():Boolean {
			for (var a:Object in lookup) {
				return false;
			}
			return true;
		}
		
		/**
		 * 	Loads database from bytearray
		 */
		public function load(bytes:IDataInput):void {
			
			try {
				
				width	= bytes.readShort();
				height	= bytes.readShort();
				
				while (bytes.bytesAvailable) {
				
					var thumbnail:ByteArray	= new ByteArray();
					var total:int			= bytes.readUnsignedInt();
					var path_length:int		= bytes.readUnsignedInt();
					var path:String			= bytes.readUTFBytes(path_length);
					var bmp:BitmapData		= new BitmapData(width,height,false,0);
					bytes.readBytes(thumbnail, 0, total - path_length - 8);
					bmp.setPixels(bmp.rect, thumbnail);
					addFile(path, bmp);
					
				}
				
			} catch (e:Error) {
				Console.error(e);
			}
		}
		
		/**
		 * 
		 */
		internal function removeNonExistingThumbnails(directoryHash:Object):Boolean {
			
			var deleted:Boolean = false;

			// let's look for items that don't exist			
			for each (var def:FileDef in lookup) {
				if (!directoryHash[def.path]) {
					
					delete lookup[def.path];
					deleted = true;
				}
			}
			
			return deleted;
		}
		
		/**
		 * 
		 */
		public function getThumbnail(path:String):BitmapData {
			const def:FileDef = lookup[path];
			return (def) ? def.thumbnail : null;
		}
		
		/**
		 * 
		 */
		public function get bytes():ByteArray {
			const bytes:ByteArray = new ByteArray();
			
			// write width / height
			bytes.writeShort(width);
			bytes.writeShort(height);
			
			for each (var def:FileDef in lookup) {
				var thumbnail:ByteArray = def.thumbnail.getPixels(def.thumbnail.rect);
				bytes.writeUnsignedInt(thumbnail.length + def.path.length + 8);
				bytes.writeUnsignedInt(def.path.length);
				bytes.writeUTFBytes(def.path);
				bytes.writeBytes(thumbnail);
			}
			
			return bytes;
		}
	}
}

import flash.utils.ByteArray;
import flash.display.BitmapData;

final class FileDef {
	
	/**
	 * 
	 */
	public var path:String;
	
	/**
	 * 
	 */
	public var thumbnail:BitmapData;
	
	/**
	 * 
	 */
	public function FileDef(path:String, thumbnail:BitmapData):void {
		this.path		= path;
		this.thumbnail	= thumbnail;
	}
	
}