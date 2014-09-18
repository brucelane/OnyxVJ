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
	import flash.net.*;
	import flash.system.Security;
	import flash.utils.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.utils.event.*;
	
	import services.videopong.VideoPong;
	
	/**
	 * 
	 */
	public final class VPContentQuery extends AssetQuery {
		
		/**
		 * 	@private
		 */
		private var layer:Layer;
		private var settings:LayerSettings;
		private var transition:Transition;
		private const bytes:ByteArray = new ByteArray();
		private var extension:String;
		private var tens:String = '0';
		private const vp:VideoPong = VideoPong.getInstance();
		
		/**
		 * 
		 */
		public function VPContentQuery(path:String, callback:Function, layer:Layer, settings:LayerSettings, transition:Transition):void {
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
		private function executeContent(query:VPContentQuery, event:Event, content:Content = null):void {
			query.callback(event, content, settings, transition);
		}
		
		/**
		 * 
		 */
		internal function loadContent():void {
			// find extension from the path
			var extension:String = path.substr( path.lastIndexOf('.') + 1, 3 ).toLowerCase();

			// depending on the extension, do different things
			switch ( extension ) { 
				
				// Netstream objects
				case 'mp4':
				case 'm4v':
				case 'm4a':
				case 'mov':
				case '3gp':
				case 'flv':
					
					var stream:Stream		= new Stream( path);
					stream.bufferTime		= 0;
					stream.soundTransform	= new SoundTransform(0);
					stream.addEventListener(Event.COMPLETE,				streamComplete);
					stream.addEventListener(NetStatusEvent.NET_STATUS,	streamComplete);
					stream.play( path );
					
					break;
				
				case 'mp3':
					
					var sound:Sound		= new Sound();
					sound.addEventListener(Event.COMPLETE,			soundHandler);
					sound.addEventListener(IOErrorEvent.IO_ERROR,	soundHandler);
					
					// load
					sound.load(
						new URLRequest( path )
					);
					
					break;

				// load a loader if we're any other type of file
				case 'swf':
					
					// need to check for already loaded swf's of the same name (performance gain);
					var reg:ContentRegistration = ContentMC.registration( path );
					
				case 'gif':
				case 'jpg':
				case 'jpeg':
				case 'png':
				default:	
					// if the swf is already loaded, test for re-use
					if (reg) 
					{												 
						ContentMC.register( path );
						_createLoaderContent(reg.loader.contentLoaderInfo);
					} 
					else 
					{
						var sessionReplace:RegExp = /replacethissessiontoken/gi; // g:global i:ignore case
						var pathWithSessiontoken:String = path.replace( sessionReplace, vp.sessiontoken );
						//if ( DEBUG::SPLASHTIME==0 ) Console.output('VPContentQuery, LOADING ' + pathWithSessiontoken);
						var request:URLRequest = new URLRequest( pathWithSessiontoken + '&appkey=' + vp.appkey );
						request.method = URLRequestMethod.POST;
						request.contentType = 'application/x-shockwave-flash';
						var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener( Event.COMPLETE, contentHandler );
						loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, contentHandler ); 
						loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progressHandler);
						loader.load( request );
						
					}
					
					break;
			}
		}
		private function progressHandler(event:ProgressEvent):void 
		{
			var ten:String = Math.floor(event.bytesLoaded / event.bytesTotal * 10).toString();
			if ( ten != tens )
			{
				tens = ten;
				Console.output('LOADING ' + Math.floor(event.bytesLoaded / event.bytesTotal * 100) + '% (' + Math.floor(event.bytesTotal / 1024) + ' kb)');
			}
			//this.layer..path =  'LOADING ' + Math.floor(event.bytesLoaded / event.bytesTotal * 100) + '% (' + Math.floor(event.bytesTotal / 1024) + ' kb)';
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
		private function contentHandler(event:Event):void 
		{
			var info:LoaderInfo			= event.currentTarget as LoaderInfo;
			var content:DisplayObject	= info.content;
			
			// remove listener
			info.removeEventListener(Event.COMPLETE, contentHandler);
			
			if (event is ErrorEvent) 
			{
				Console.output( 'VPContentQuery asset error: ' + (event as IOErrorEvent).text );
			}
			else
			{ 
				// get the classname
				//Videopong swfs:  flash.display::AVM1Movie, should be flash.display::MovieClip(AVM2Movie) now...
				//Console.output( 'QualifiedClassName: ' + getQualifiedClassName(info.content));
				if (getQualifiedClassName(info.content) === 'flash.display::MovieClip') {
					
					var reg:ContentRegistration = ContentMC.registration(path);
					// if something loaded before us, use it's loader instead of our own
					if (reg) {
						info = reg.loader.contentLoaderInfo;
					}
					
					// register
					ContentMC.register(path, info.loader);
				}
				else
				{
					//Put the file in cache
				}
				// load
				_createLoaderContent(info);
			}
		}
	}
}