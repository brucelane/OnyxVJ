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
	import flash.net.*;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.utils.event.*;
	import onyx.utils.file.*;
	
	/**
	 * 
	 */
	public final class AIRContentQuery extends AssetQuery {
		
		/**
		 * 	@private
		 */
		private var layer:Layer;
		private var settings:LayerSettings;
		private var transition:Transition;
		private const bytes:ByteArray			= new ByteArray();
		
		/**
		 * 
		 */
		public function AIRContentQuery(path:String, callback:Function, layer:Layer, settings:LayerSettings, transition:Transition):void {
			
			//
			super(path, callback);
			
			// store & execute
			this.layer		= layer,
			this.settings	= settings,
			this.transition	= transition;
			
			// load
			loadContent();
		}
		

		/**
		 * 	@private
		 * 	Executes callback
		 */
		private function executeContent(query:AIRContentQuery, event:Event, content:Content = null):void {
			query.callback(event, content, settings, transition);
		}
				
		/**
		 * 
		 */
		internal function loadContent():void {
			
			// resolve the file path
			var file:File = AIR_ROOT.resolvePath(path);
			// AIR_ROOT.nativePath: e:\SelectedFolderForLibrary\Onyx-VJ
			
			// depending on the extension, do different things
			switch (file.extension.toLowerCase()) {
				
				// Netstream objects
				case 'mp4':
				case 'm4v':
				case 'm4a':
				case 'mov':
				case '3gp':
				case 'flv':
				
					var stream:Stream		= new Stream(AIR_ROOT.resolvePath(path).nativePath);
					stream.bufferTime		= 0;
					stream.soundTransform	= new SoundTransform(0);
					stream.addEventListener(Event.COMPLETE,				streamComplete);
					stream.addEventListener(NetStatusEvent.NET_STATUS,	streamComplete);
					stream.play(AIR_ROOT.resolvePath(path).nativePath);
					
					break;
					
				case 'mp3':

					var sound:Sound		= new Sound();
					sound.addEventListener(Event.COMPLETE,			soundHandler);
					sound.addEventListener(IOErrorEvent.IO_ERROR,	soundHandler);
					
					// load
					sound.load(
						new URLRequest(AIR_ROOT.resolvePath(path).nativePath)
					);
					
					break;

				// load a loader if we're any other type of file
				case 'swf':

					// need to check for already loaded swf's of the same name (performance gain);
					var reg:ContentRegistration = ContentMC.registration(path);
				
				case 'gif':
				case 'jpg':
				case 'jpeg':
				case 'png':
				case 'onr':
				
					// if the swf is already loaded, test for re-use
					if (reg) {												 
						ContentMC.register(path);
						_createLoaderContent(reg.loader.contentLoaderInfo);
	 				} else {
						var fs:FileStream = new FileStream();
						// fs.addEventListener(ProgressEvent.PROGRESS, fillBuffer);
						
						if (file.extension === 'onr') {
							fs.addEventListener(IOErrorEvent.IO_ERROR, onrComplete);
							fs.addEventListener(Event.COMPLETE, onrComplete);
						} else {
							
							fs.addEventListener(IOErrorEvent.IO_ERROR, bytesComplete);
							fs.addEventListener(Event.COMPLETE, bytesComplete);
						}
						fs.openAsync(file, FileMode.READ);
	 				}
	 				
					break;
			}
		}
		
		/**
		 * 	@private
		 */
		private function onrComplete(event:Event):void {
			var fs:FileStream	= event.currentTarget as FileStream;
			fs.removeEventListener(Event.COMPLETE,			onrComplete);
			fs.removeEventListener(IOErrorEvent.IO_ERROR,	onrComplete);
			// fs.removeEventListener(ProgressEvent.PROGRESS,	fillBuffer);
			
			var bytesRead:int	= fs.bytesAvailable;
			if (bytesRead > 0) {			
				fs.readBytes(bytes);
				// bytes.position +=	bytesRead;
			}
			
			// close the stream
			fs.close();
			
			// resolve the file path
			var file:File = AIR_ROOT.resolvePath(path);
			
			var c:Content	= new ContentONR(layer, path, bytes);
			
			// give it up!
			executeContent(this, new Event(Event.COMPLETE), c);
			
		}
		
		/**
		 * 	@private
		 */
		private function bytesComplete(event:Event):void {
			var stream:FileStream = event.currentTarget as FileStream;
			stream.removeEventListener(Event.COMPLETE, streamComplete);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, streamComplete);
			
			if (event is ErrorEvent) {
			
				// complete					
				executeContent(
					this,
					event
				)
			
			} else {
				
				stream.readBytes(bytes);
				stream.close();
				
				var loader:Loader	= new Loader();
				var info:LoaderInfo	= loader.contentLoaderInfo;
				info.addEventListener(Event.COMPLETE, contentHandler);
				loader.loadBytes(bytes, AIR_CONTEXT);
			}
		}
		
		/**
		 * 	@private
		 * 	Handles events when a sound object retrieves it's ID3 information
		 */
		private function soundHandler(event:Event):void {
			var sound:Sound = event.currentTarget as Sound;
			sound.removeEventListener(Event.COMPLETE, soundHandler);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, soundHandler);

			executeContent(
				this, 
				event,
				new ContentMP3(layer, path, sound)
			);
		}
		
		/**
		 * 	@private
		 * 	Dispatched when a stream receives meta data
		 */
		private function streamComplete(event:Event):void {
			
			var stream:Stream = event.currentTarget as Stream;
			
			if (event is NetStatusEvent) {
			
				switch ((event as NetStatusEvent).info.code) {
					case 'NetStream.Buffer.Full':
						stream.removeEventListener(NetStatusEvent.NET_STATUS, streamComplete);
						break;
					case 'NetStream.Play.StreamNotFound':
						stream.removeEventListener(NetStatusEvent.NET_STATUS, streamComplete);
						
						// throw error
						executeContent(this, new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, 'File Not Found'))
						break;
				}				
			} else {
			
				stream.removeEventListener(Event.COMPLETE, streamComplete);

				// complete					
				executeContent(
					this,
					event,
					new ContentFLV(layer, path, stream)
				)
			}
			
		}
		

		/**
		 *	  @private
		 */
		private function _createLoaderContent(info:LoaderInfo):void {
			   
			var type:Class, loader:Loader, content:DisplayObject;  
			loader	= info.loader;
			content = loader.content;
			
			if (content is IRenderObject) {
				type = (content is TimePatch) ? ContentCustomTime : ContentCustom;
			} else if (content is MovieClip) {
				type = ContentMC;
			} else {
				type = ContentSprite;
			}
			
			// execute
			executeContent(this, EVENT_COMPLETE, new type(layer, path, info.loader))
			
		}
		
		/**
		 *	@private 
		 */
		private function contentHandler(event:Event):void {
			var info:LoaderInfo			= event.currentTarget as LoaderInfo;
			var content:DisplayObject	= info.content;
			
			// remove listener
			info.removeEventListener(Event.COMPLETE, contentHandler);

			// get the classname
			if (getQualifiedClassName(info.content) === 'flash.display::MovieClip') {
				
				var reg:ContentRegistration = ContentMC.registration(path);
				// if something loaded before us, use it's loader instead of our own
				if (reg) {
					info = reg.loader.contentLoaderInfo;
				}

				// register
				ContentMC.register(path, info.loader);
			}
			
			// load
			_createLoaderContent(info);
		}
	}
}