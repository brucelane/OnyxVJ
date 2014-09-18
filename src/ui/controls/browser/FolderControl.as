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
package ui.controls.browser {
	
	import flash.display.Bitmap;
	
	import onyx.asset.*;
	import onyx.core.*;
	
	import ui.assets.*;
	import ui.controls.ButtonClear;
	import ui.core.*;
	import ui.text.*;

	/**
	 * 	Folder Control
	 */
	public final class FolderControl extends UIObject {
		
		/**
		 * 	@private
		 */
		private static const FOLDERWIDTH:int	= 81;
		
		/**
		 * 	@private
		 */
		private const label:TextFieldOnyx			= Factory.getNewInstance(ui.text.TextFieldOnyx);			

		/**
		 * 	@private
		 */
		private const btn:ButtonClear			= new ButtonClear();

		/**
		 * 	@private
		 */
		private var img:Bitmap;
				
		/**
		 * 	@private
		 */
		public var asset:AssetFile;
		
		/**
		 * 	@constructor
		 */
		public function FolderControl(asset:AssetFile, useArrowFolder:Boolean = false):void {
			
			this.asset		= asset;
			
			if (useArrowFolder) {
				img = new AssetFolderUp();
				label.text = 'up one level';
			} else {
				img = new AssetFolder();
				label.text = asset.name;
			}
			
			img.x			= 2,
			img.y			= 3,
			label.x			= 13,
			label.y			= 2,
			label.width		= FOLDERWIDTH,
			label.height	= 14;
			
			btn.initialize(FOLDERWIDTH, 14);
			
			addChild(label);
			addChild(img);
			addChild(btn);
			
		}
	}
}