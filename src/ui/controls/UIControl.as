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
package ui.controls {
	
	import flash.display.*;
	import flash.utils.Dictionary;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.ui.*;
	
	import ui.core.UIObject;

	/**
	 * 	Base UIControl class: This class is an UIObject that contains a parameterized control.
	 * 
	 * 	@see onyx.controls.Control
	 */
	public class UIControl extends UIObject implements UserInterfaceControl {

		/**
		 * 	@private
		 */
		protected static const CONTAINER:UnClippedContainer	= new UnClippedContainer();
		
		/**
		 * 	Stores all available UIControls
		 */
		public static const available:Dictionary			= new Dictionary(true);

		/**
		 * 	Stores the related core control
		 */
		protected var parameter:Parameter;
		
		/**
		 * 	Initialize
		 */
		public function initialize(control:Parameter, options:UIOptions = null):void {
			
			// store the UIControl so we can toggle affectable controls
			available[this] = null;

			// store the control
			parameter = control;
			
			// if there are options
			if (options) {
			
				if (options.background) {
					displayBackground(options.width, options.height);
				}
				
				if (options.label) {
					
					switch (options.labelAlign) {
						case 'left':
							addLabel(control.display, options.width + 3, options.height, 1, -15, 'left');
							break;
						default:
							addLabel(control.display, options.width, options.height, -8, 0, options.labelAlign);
							break;						
					}
				}
			}
		}
		
		/**
		 * 
		 */
		public function reflect():Class {
			return null;
		}
		
		/**
		 * 
		 */
		final public function getParameter():Parameter {
			return parameter;
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			// release
			Factory.release(reflect(), this);
			
			// dispose
			super.dispose();
			
			// delete
			delete available[this];
		}
	}
}
