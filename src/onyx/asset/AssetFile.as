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
package onyx.asset {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.utils.ByteArray;
	
	import onyx.asset.vp.VPContentQuery;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.utils.event.*;
	
	use namespace onyx_ns;
	
	/**
	 * 
	 */
	public class AssetFile {
		
		/**
		 * 	@private
		 */
		onyx_ns static var adapter:IAssetAdapter;
		
		/**
		 *  all names must have a length of 6
		 */
		onyx_ns static const protocols:Object	= {
			camera: new CameraProtocol(),
			linein: new MicProtocol(),
			vdpong: new VideoPongProtocol()
		};
		
		/**
		 * 
		 */
		public static function queryDirectory(path:String, callback:Function):void 
		{
			
			if (path.substr(0, 13).toLowerCase() === 'onyx-query://') {	
				
				const p:IAssetProtocol = protocols[path.substr(13,6)];
				
				// protocol registered
				if (p) {
					callback(
						new AssetQuery(path, callback),
						p.getProtocolList(path)
					);
					
					return;
				}
			}
			
			adapter.queryDirectory(path, callback);//AIR adapter, not called if other protocols
		}
		
		/**
		 * 	Adds a protocol
		 */
		public static function addProtocol(name:String, method:Function):void {
			protocols[name] = method;
		}
		
		/**
		 * 	@private
		 */
		public static function resolvePath(path:String):String {
			return adapter.resolvePath(path);
		}
		
		/**
		 * 	Callback is:
		 */
		public static function queryContent(path:String, callback:Function, layer:Layer, settings:LayerSettings, transition:Transition):void 
		{
			const index:int = path.indexOf('://');
			if ( index > 3 ) 
			{
				// 5 for https
				var protocol:String = ( index == 5 ? 'vdpong' : path.substr(0, index) );
				//if ( DEBUG::SPLASHTIME==0 ) Console.output('AssetFile, LOADING protocol: ' + protocol);
				const p:IAssetProtocol = protocols[protocol];
				if (p) 
				{
					callback(EVENT_COMPLETE, p.getContent(path, layer), settings, transition);	
					if ( p is VideoPongProtocol )
					{
						//Console.output('AssetFile, protocol known, LOADING ' + path);
						new VPContentQuery( path, callback, layer, settings, transition );
						return;
					}
					if ( p is CameraProtocol )
					{
						Console.output('AssetFile, camera, LOADING ' + path);
						return;
					}
					if ( p is MicProtocol )
					{
						Console.output('AssetFile, microphone, LOADING ' + path);
						return;
					}
				}
			}

			// fall through to the AIR adapter
			adapter.queryContent(path, callback, layer, settings, transition);
		}
		
		/**
		 * 
		 */
		public static function queryFile(path:String, callback:Function):void {
			adapter.queryFile(path, callback);
		}
		
		/**
		 * 
		 */
		public static function save(path:String, callback:Function, bytes:ByteArray, extension:String):void {
			adapter.save(path, callback, bytes, extension); 
		}
		
		/**
		 * 
		 */
		public static function browseForSave(callback:Function, title:String, bytes:ByteArray, extension:String):void {
			adapter.browseForSave(callback, title, bytes, extension)
		}
		
		/**
		 *	Store a thumbnail 
		 */
		public const thumbnail:Bitmap = new Bitmap();
		
		/**
		 * 
		 */
		public function get name():String {
			return null;
		}
		
		/**
		 * 
		 */
		public function get path():String {
			return null;
		}
		
		/**
		 * 
		 */
		public function get extension():String {
			return null;
		}
		
		/**
		 * 
		 */
		public function get isDirectory():Boolean {
			return false;
		}
	}
}