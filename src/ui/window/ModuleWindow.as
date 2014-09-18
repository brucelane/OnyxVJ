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
package ui.window {
	
	import flash.display.DisplayObject;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import ui.controls.page.*;
	import ui.core.DragManager;
	
	/**
	 * 
	 */
	public final class ModuleWindow extends Window {
		
		/**
		 * 	@constructor
		 */
		public function ModuleWindow(reg:WindowRegistration):void {
			
			var module:Module					= PluginManager.modules[reg.name];
			var options:ModuleInterfaceOptions	= module.interfaceOptions;
			
			// get options
			super(reg, true, options.width, options.height);
			
			// check if we need to make it draggable
			if (options.draggable) {
				DragManager.setDraggable(this, true);
			}
			
			// SC: we use both UI and core controls
			if (module.getParameters().length) {
				var page:ParameterPage = new ParameterPage();
				page.addControls(module.getParameters());
			}
			if (options.definition) {
				var ui:DisplayObject = new options.definition();
			}
			
			if (page) {
				page.x = 2;
				page.y = 17;
				addChild(page);
			} else if (ui) {
				ui.x = 2;
				ui.y = 17;
				addChild(ui);
			}
		}

		/**
		 * 
		 */
		override public function dispose():void {
			
			// remove drag listeners
			DragManager.setDraggable(this, false);

			// dispose
			super.dispose();
		}
	}
}