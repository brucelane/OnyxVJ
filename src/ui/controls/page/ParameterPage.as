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
package ui.controls.page {
	
	import flash.events.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	
	import ui.controls.*;
	import ui.styles.*;

	/**
	 * 	The pages
	 */
	public final class ParameterPage extends ScrollPane {
		
		/**
		 * 	@private
		 */
		private static const DEFAULT:UIOptions = new UIOptions();
		DEFAULT.width = 64;

		/**	
		 * 	@private
		 */
		private var parameters:Array		= [];
		
		/**
		 * 	@private
		 * 	If the controls passed in is a control array, listen for updates
		 */
		private var target:Parameters;
		
		/**
		 * 	@constructor
		 */		
		public function ParameterPage():void {
			
			super(140, 122);		// controls size of ScrollPane
			
			// set mouseenabled
			mouseEnabled = false;
			
		}
		
		/**
		 * 	Removes all the controls from the page
		 */
		public function removeControls():void {
			
			// if it's a control array, remove listeners
			if (target) {
				target.removeEventListener(Event.CHANGE, update);
				target = null;
			}
			
			// remove all controls
			for each (var uicontrol:UIControl in parameters) {
				removeChild(uicontrol);
				uicontrol.dispose();
			}
			
			// set new array
			parameters = [];
		}
		
		/**
		 * 	@private
		 * 	When the control is updated
		 */
		private function update(event:Event):void {
			addControls(target);
		}
		
		/**
		 * 	Add controls
		 */
		public function addControls(controls:Array):void {
			
			if (target === controls) {
				return;
			}
			
			var uicontrol:UIControl, x:int, y:int, width:int, target:Parameters, height:int, creationArray:Array;

			x						= 0,
			y						= 8,
			width					= DEFAULT.width + 3,
			height					= DEFAULT.height,
			target					= controls as Parameters,
			creationArray			= [];
			
			// remove existing controls
			removeControls();
			
			// create first layer of controls to display
			creationArray = (controls) ? controls.concat() : null;
			
			// if it's a Controls array, listen for changes
			if (target) {
				
				this.target = target;
				target.addEventListener(Event.CHANGE, update);
				
				for each (var child:Parameters in target.children) {
					creationArray =  creationArray.concat(child);
				}

			}
			
			// now create a uicontrol based on each control
			for each (var param:Parameter in creationArray) {
				
				if (!param) {
					continue;
				}
				
				var uiClass:Class		= PARAM_MAP[param.reflect()];
				
				if (uiClass) {

					uicontrol			= Factory.getNewInstance(uiClass) as UIControl;
					uicontrol.initialize(param, DEFAULT);
					
					// position the control
					uicontrol.x = x,
					uicontrol.y = y;
					
					// save the control
					parameters.push(uicontrol);
					
					// add
					x += width;
					
					// check width, reposition based on it
					if (x > width) {
						x = 0,
						y += height + 10;
					}
					
					// add it
					addChild(uicontrol);
				}
			}
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			if (target) {
				target.removeEventListener(Event.CHANGE, update);
			}
			
			super.dispose();
		}
	}
}