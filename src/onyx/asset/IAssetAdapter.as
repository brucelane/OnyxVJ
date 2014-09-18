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
package onyx.asset {
	
	import flash.utils.ByteArray;
	
	import onyx.display.*;
	import onyx.plugin.*;
	
	[ExcludeSDK]
	
	public interface IAssetAdapter {
		
		function queryDirectory(path:String, callback:Function):void;
		function queryContent(path:String, callback:Function, layer:Layer, settings:LayerSettings, transition:Transition):void;
		function queryFile(path:String, callback:Function):void;
		function save(path:String, callback:Function, bytes:ByteArray, extension:String):void;
		function browseForSave(callback:Function, title:String, bytes:ByteArray, extension:String):void;
		function resolvePath(path:String):String;
		function quit():void;
		
	}
}