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
package ui.core {
	

	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.controls.*;
	import ui.states.*;
	import ui.window.*;
	
	public final class Settings {
		
		/**
		 * 
		 */
		public static function toXML():XML {
			var xml:XML	= <settings />;
			xml.appendChild(<metadata><version>{VERSION}</version></metadata>);
			
			var core:XML = <core />;
			xml.appendChild(core);
			
			core.appendChild(
				<render>
					<!-- the width / height of bitmaps -->
					<bitmapData>
						<width>{DISPLAY_WIDTH}</width>
						<height>{DISPLAY_HEIGHT}</height>
						<x>{DISPLAY_X}</x>
						<y>{DISPLAY_Y}</y>
						<fullscreen>{DISPLAY_FULLSCREEN}</fullscreen>
					</bitmapData>
				</render>
			);
			
			var blend:XML = <blendModes />;
			core.appendChild(blend);
			for each (var mode:String in BlendModes) {
				blend.appendChild(<{mode}/>);
			}
			
			// add cameras registrations
			core.appendChild(ContentCamera.toXML());

			// add videopong webservice
			core.appendChild(ContentVideoPong.toXML());
			
			var ui:XML = <ui/>;
			xml.appendChild(ui);
			
			// add swatch
			ui.appendChild(ColorPicker.toXML());
			
			// add keys
			ui.appendChild(KeyListenerState.toXML());
			
			// add windows
			ui.appendChild(WindowState.toXML());
			
			// return
			return xml;
		}
	}
}