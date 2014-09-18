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
package onyx.asset.vp {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.text.*;
	
	import onyx.asset.*;
	
	/**
	 * 
	 */
	public final class VPAsset extends AssetFile {
		
		/**
		 * 	@private
		 */
		private var assetUrl:String;
		private var thumbUrl:String;
		private var assetName:String;
		private const label:TextField = new TextField();
		/**
		 * 
		 */
		public function VPAsset( name:String, url:String, thumb_url:String='' ):void {
			this.assetUrl 					= url;
			this.thumbUrl 					= thumb_url;
			this.assetName 					= name;
										
			const format:TextFormat			= new TextFormat(new AssetDefaultFont().fontName, 7, 0xFFFFFF);
			format.leading					= 3;
			label.autoSize					= TextFieldAutoSize.LEFT;
			label.wordWrap					= true;
			label.width						= 44;
			label.embedFonts				= true;
			label.defaultTextFormat			= format;
			
			label.text						= name.toUpperCase();
			if ( thumbUrl.length > 0)
			{
				// create a thumbnail loader
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onImageLoaded );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler ); 
				
				loader.load(new URLRequest(thumbUrl));
			}
			else
			{
				this.thumbnail.bitmapData		= new VideoPongThumbnail();
				
				const source:BitmapData			= this.thumbnail.bitmapData;
				source.draw(label);
			}
			
		}
		/**
		 * 
		 */
		private function onImageLoaded( evt:Event ):void
		{
			if (evt) 
			{
				var bmpThumb:Bitmap = Bitmap( evt.target.content );
				var tmpBD:BitmapData = new BitmapData( 64, 48 );
				tmpBD.draw( bmpThumb.bitmapData );
				this.thumbnail.bitmapData = tmpBD;
				this.thumbnail.bitmapData.draw(label);
			}
		}
		/**
		 * 
		 */
		private function ioErrorHandler( evt:IOErrorEvent ):void 
		{
			trace("thumbnail load error");
		}				
		/**
		 * 
		 */
		override public function get name():String {
			return assetName;
		}
		
		/**
		 * 
		 */
		override public function get path():String {
			return assetUrl;
		}
		
		/**
		 * 
		 */
		public function get url():String {
			return assetUrl;	
		}
		
		/**
		 * 
		 */
		override public function get isDirectory():Boolean {
			return false;
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return '[VPAsset: ' + path + ']';
		}
	}
}