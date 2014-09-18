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
package onyx.asset.air {
	
	import flash.events.*;
	import flash.filesystem.*;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.plugin.*;
	
	/**
	 * 
	 */
	public final class AIRSaveBrowseQuery extends AssetQuery {
		
		/**
		 * 	@private
		 */
		private var bytes:ByteArray;
		
		/**
		 * 	@private
		 */
		private var extension:String;

		/**
		 * 
		 */
		public function AIRSaveBrowseQuery(callback:Function, title:String, bytes:ByteArray, extension:String) {
			
			this.bytes		= bytes;
			this.extension	= extension;
			
			// super
			super(null, callback);
			
			// browse
			var file:File = new File();
			file.addEventListener(Event.CANCEL, fileHandler);
			file.addEventListener(Event.SELECT, fileHandler);
			file.browseForSave(title);
		}
		
		/**
		 * 	@private
		 */
		private function fileHandler(event:Event):void {
			
			if (event.type === Event.SELECT) {
				var file:File = event.currentTarget as File;
				
				if (file.extension !== extension) {
					file = new File(file.nativePath + '.' + extension);
				}
				
				var stream:FileStream	= new FileStream();
				stream.open(file, FileMode.UPDATE);
				stream.writeBytes(bytes);
				stream.close();
			}
			
			// execute callback
			super.callback(this);
		}
	}
}