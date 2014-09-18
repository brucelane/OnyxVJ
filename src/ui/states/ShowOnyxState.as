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
package ui.states {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Screen;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import onyx.core.ApplicationState;
	import onyx.core.Console;
	import onyx.core.Factory;
	import onyx.core.VERSION;
	import onyx.events.ConsoleEvent;
	import onyx.plugin.DISPLAY_STAGE;
	
	import ui.text.TextFieldOnyx;
	import ui.assets.OnyxStartUpImage;
	
	[ExcludeClass]

	/**
	 * 
	 */
	final public class ShowOnyxState extends ApplicationState {

		/**
		 * 	@private
		 */
		protected var image:Bitmap;
		
		/**
		 * 	@private
		 */
		protected var label:TextFieldOnyx;
		
		/**
		 * 	@constructor
		 */
		public function ShowOnyxState():void {
			super('startup');
		}

		/**
		 * 
		 */
		override public function initialize():void {
			
			DISPLAY_STAGE.align = StageAlign.TOP_LEFT;
			showStartupImage();
			
		}
		
		/**
		 * 
		 */
		private function showStartupImage():void {
			
			// create the image and a label
			image				= new OnyxStartUpImage();
			image.smoothing		= true;
			
			// label
			label				= Factory.getNewInstance(ui.text.TextFieldOnyx);
			label.width			= 400;
			label.height		= 425;
			label.x				= 465;
			label.y				= 190;
			
			label.text	=	'*  VERSION ' + VERSION + '  *\n\n' + 
							'*  THE ONYX TEAM  *\n' +
							'DANIEL HAI\nSTEFANO COTTAFAVI\nBRUCE LANE\n\n*  CONSIDER DONATING  *\nhttp://www.onyx-vj.com\n\n';
			
			// add the children
			DISPLAY_STAGE.addChild(image);
			DISPLAY_STAGE.addChild(label);
			
			const screenBounds:Rectangle	= Screen.mainScreen.bounds;
			const width:int					= screenBounds.width;
			const height:int				= screenBounds.height;
			
			// greater width-wise
			if (width / height >= 4 / 3) {
				
				var videoHeight:Number	= height;
				var videoWidth:Number	= (videoHeight / 3 * 4);
				
			// greater height-wise
			} else {

				videoWidth				= width;
				videoHeight				= width / 4 * 3;

			}
			
			// resize video and center				
			image.width		= videoWidth;
			image.height	= videoHeight;
			image.x			= width / 2 - videoWidth / 2;
			image.y			= height / 2 - videoHeight / 2;
			
			// listen for mouse clicks
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_DOWN,	captureEvents,	true, -1);
			DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP,		captureEvents,	true, -1);

			// every time something is added, put it below
			DISPLAY_STAGE.addEventListener(Event.ADDED,				onItemAdded);
			
			// listen for updates
			const console:Console	= Console.getInstance();
			console.addEventListener(ConsoleEvent.OUTPUT, onOutput);
			
			// set the label type

		}

		/**
		 * 	@private
		 * 	Traps all mouse events
		 */
		private function captureEvents(event:MouseEvent):void {
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 * 	When an item is added, make sure it is below the startup image
		 */
		private function onItemAdded(event:Event):void {
			
			const stage:DisplayObjectContainer = DISPLAY_STAGE;
			DISPLAY_STAGE.setChildIndex(image, DISPLAY_STAGE.numChildren - 2);
			DISPLAY_STAGE.setChildIndex(label, DISPLAY_STAGE.numChildren - 1);
			
		}

		/**
		 * 	@private
		 */
		private function onOutput(event:ConsoleEvent):void {
			label.appendText(event.message + '\n');
			label.scrollV = label.maxScrollV;
		}

		/**
		 * 
		 */
		override public function terminate():void {
			
			const console:Console = Console.getInstance();
			console.removeEventListener(ConsoleEvent.OUTPUT,	onOutput);
			
			// remove listener to the stage
			DISPLAY_STAGE.removeEventListener(Event.ADDED, onItemAdded);
			
			// remove listener for mouse clicks
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_DOWN,	captureEvents,	true);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP,		captureEvents,	true);

			// remove items
			DISPLAY_STAGE.removeChild(image);
			DISPLAY_STAGE.removeChild(label);
			
			// dispose
			label.dispose();
			
			// clear references
			image = null;
			label = null;
			
			// remove additional children
			/*BL var parent:DisplayObjectContainer = (Display as DisplayObject).parent;
			while (parent && parent.numChildren > 1) {
				parent.removeChildAt(1);
			}*/
			
			DISPLAY_STAGE.align = 'C';
			
		}
		
		/**
		 * 
		 */
		public function getLogText():String {
			return label.text;
		}
	}
}