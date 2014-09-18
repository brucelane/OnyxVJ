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
package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.jobs.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import services.videopong.VideoPong;
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.*;
	import ui.states.*;
	import ui.styles.*;
	import ui.text.*;

	/**
	 * 
	 */
	public final class VideopongWindow extends Window implements IParameterObject {
		
		private const vp:VideoPong = VideoPong.getInstance();
		
		/**
		 * 	@private
		 * 	returns controls
		 */
		private const parameters:Parameters	= new Parameters(this as IParameterObject,
			new ParameterString( 'vpusername', 'User name', 'login' ),
			new ParameterString( 'vppwd', 'Password', 'pwd' )
		);
		
		/**
		 * 	@private
		 */
		private var vpLoginBtn:TextButton;
		
		/**
		 * 	@private
		 */
		private var vpLoginTextControl:OneLineTextControl;
		
		/**
		 * 	@private
		 */
		private var vpPwdTextControl:OneLineTextControl;
		
		/**
		 * 	@private
		 */
		public var vpInfoLabel:StaticText;
		
		/**
		 * 
		 */
		public function set vpusername(t:String):void {
			vp.username	= t;
		}
		
		/**
		 * 
		 */
		public function get vpusername():String {
			return vp.username;
		}
		
		/**
		 * 
		 */
		public function set vppwd(t:String):void {
			vp.pwd	= t;
		}
		
		/**
		 * 
		 */
		public function get vppwd():String {
			return vp.pwd;
		}		
		
		/**
		 * 	@constructor
		 */
		public function VideopongWindow(reg:WindowRegistration):void {
			
			//super(reg, true, 150, 92);
			super(reg, true, 150, 80);
			
			init();
		}
		
		/**
		 * 	@private
		 */
		private function init():void {
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			
			// controls for display
			vpLoginBtn				= new TextButton(options, 'login to vp'),
				
			// videopong controls
			vpLoginTextControl = Factory.getNewInstance(OneLineTextControl);
			vpLoginTextControl.initialize( parameters.getParameter('vpusername'), options);
			
			vpPwdTextControl = Factory.getNewInstance(OneLineTextControl);
			vpPwdTextControl.initialize( parameters.getParameter('vppwd'), options);
			
			
			// add controls
			addChildren(
				vpLoginTextControl,				8,	40,
				vpPwdTextControl,				74,	40,
				vpLoginBtn,						74,	55
			);
			
			
			var bg:AssetWindow	= super.getBackground() as AssetWindow;
			
			// draw things onto the background
			if (bg) {
				var source:BitmapData	= bg.bitmapData;
				source.fillRect(new Rectangle(8, 25, 150, 1), 0xFF445463);
				
				var label:StaticText		= new StaticText();
				
				label.text	= 'VIDEOPONG';
				source.draw(label, new Matrix(1, 0, 0, 1, 8, 17));
				
			}
			
			// videopong login
			vpLoginBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
		}
		
		/**
		 * 
		 */
		public function getParameters():Parameters {
			return parameters;
		}
		
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			switch (event.currentTarget) {
				case vpLoginBtn:
					vp.addEventListener( 'loggedin', setUserName);
					vp.vpLogin();
					break;
			}
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 */
		private function setUserName(event:TextEvent):void
		{
			var bg:AssetWindow	= super.getBackground() as AssetWindow;
			
			if (bg) {
				var source:BitmapData	= bg.bitmapData;
				source.lock();
				vpInfoLabel = new StaticText();
				vpInfoLabel.text = 'You are logged in as ' + event.text;
				Console.output( vpInfoLabel.text );
				source.draw(vpInfoLabel, new Matrix(1, 0, 0, 1, 8, 70));
				source.unlock();
			}
			event.stopPropagation();
		}
		
		/**
		 * 	@public
		 */
		override public function dispose():void {
			
			// remove
			super.dispose();
			
		}
	}
}
