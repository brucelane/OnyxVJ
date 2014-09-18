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
package onyx.display {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import services.videopong.VideoPong;
	
	use namespace onyx_ns;
	
	public final class ContentVideoPong extends ContentBase {
		
		private static const vp:VideoPong = VideoPong.getInstance();
		/**
		 *  Save
		 */
		public static function toXML():XML {
			const xml:XML	= 
				<videopong>
					<login>{vp.username}</login>
					<pwd>{vp.pwd}</pwd>
					<domain>{vp.domain}</domain>
					<pathdefaultonx>{vp.pathdefaultonx}</pathdefaultonx>
					<appkey>{vp.appkey}</appkey>
					<title>{ONYX_TITLE}</title>
				</videopong>;
			
			
			return xml;
		}
		
		/**
		 *  Load
		 */
		public static function loadXML( xml:XML ):void {
			vp.username = xml.login;
			vp.pwd = xml.pwd;
			vp.domain = xml.domain;
			vp.pathdefaultonx = xml.pathdefaultonx;
			vp.appkey = xml.appkey;
			ONYX_TITLE = xml.title;
		}
		
		
		/**
		 * 	@constructor
		 */		
		public function ContentVideoPong( layer:Layer, path:String ):void {
			
			super(layer, path,null,320,240);
			
		}
		
		/**
		 * 	Destroys the content
		 */
		override public function dispose():void {
			
			// dispose
			super.dispose();
			
		}
		
	}
}