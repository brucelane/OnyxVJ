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
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.media.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.plugin.*;
	import onyx.utils.file.*;
	
	/**
	 * 
	 */
	public final class AIRDirectoryQuery extends AssetQuery {
		
		/**
		 * 	@internal
		 */
		internal var list:Array;
		
		/**
		 * 	@private
		 */
		private var files:Array;
		
		/**
		 * 
		 */
		public function AIRDirectoryQuery(path:String, callback:Function):void {
			
			// super
			super(path, callback);
			
			// query
			query();
			
		} 
		
		/**
		 * 	@private
		 */
		public function query():void {
			
			list = [];

			var file:File	= AIR_ROOT.resolvePath(path);
			if (!file.exists) 
			{
				writeLogFile('Creating folder: ' + file);
				// create the directory
				file.createDirectory();
			}
			// grab files
			file.addEventListener(FileListEvent.DIRECTORY_LISTING, fileHandler);
			file.getDirectoryListingAsync();
		}
		
		/**
		 * 	@private
		 */
		private function fileHandler(event:FileListEvent):void {
			var file:File = event.currentTarget as File;
			file.removeEventListener(FileListEvent.DIRECTORY_LISTING, fileHandler);
			
			const files:Array = event.files;
			
			// up a folder?
			if (path.length > ONYX_LIBRARY_PATH.length) {

				list.push(new AIRAsset(AIR_ROOT.resolvePath(path).parent))
				
			}
			
            // add files                            
            for each (file in files) {

                if (file.isDirectory || valid(file)) {
                    var asset:AssetFile = new AIRAsset(file);
                    list.push(asset);
                }
            }

							
			// execute the callback immediately
			callback(this, list);
		}
		
		/**
		 *  @private
		 */
		private function valid(file:File):Boolean {
			switch (file.extension.toLowerCase()) {
				case 'onr':
				case 'swf':
				case 'onx':
				case 'mix':
				case 'flv':
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'mp3':
				case 'm4v':
				case 'mov':
				case 'mp4':
				case 'mpg':
				case 'mpeg':
				case '3gp':	
				case 'xml':
					return true;
					break;
			}
			return false;
		}
	}
}