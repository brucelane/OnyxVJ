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
package onyx.core {
	
	import flash.events.*;
	import flash.net.*;
	
	import onyx.utils.event.*;

	[Event(name='complete', type='flash.events.Event')]

	/**
	 * 	Base NetStream class
	 */
	public final class Stream extends NetStream {
		
		/**
		 * 	@private
		 */
		private static const NET_STATUS:NetStatusEvent = new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false);
		
		/**
		 * 	Stores metadata for the stream
		 */
		public var metadata:Object;

		/**
		 * 	@private
		 */
		private var _path:String;
		
		/**
		 * 	@public
		 */
		public var connection:Connection;

		/**
		 * 	@constructor
		 */
		public function Stream(path:String, connection:Connection = null):void {
			_path = path;
			
			super(this.connection = Connection.DEFAULT_CONNECTION);
		}
		
		/**
		 * 	Returns pathname 
		 */
		public function get path():String {
			return _path;
		}
		
		/**
		 * 	When metadata is returned, dispatch an event.complete event
		 */
		public function onMetaData(info:Object):void {
			
			metadata = info;
			dispatchEvent(EVENT_COMPLETE);

		}
		
		/**
		 * 	@private
		 * 	play Status
		 */
		public function onPlayStatus(info:Object):void {
			
			// net_status
			NET_STATUS.info = info;
			
			// dispatch a client-side net status event
			dispatchEvent(NET_STATUS);
		}
		
		public function onLastSecond(info:Object):void {
		}
		
		// 2010.10.13 SC: callback functions have to be added as 
		// needed for all custom metadata tags that a stream (flv)
		// could carry
	}
}