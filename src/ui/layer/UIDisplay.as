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
package ui.layer {
	
	import flash.display.*;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.assets.AssetDisplay;
	import ui.controls.*;
	import ui.controls.page.*;
	import ui.controls.xfader.*;
	import ui.core.*;
	import ui.settings.*;
	import ui.styles.*;
	import ui.window.*;

	/**
	 * 	Display Control
	 */
	public final class UIDisplay extends UIFilterControl implements IFilterDrop {
		
		/**
		 * 	@private
		 */
		private var _xFader:XFaderControl;
		
		/**
		 * 	@private
		 */
		private var _transitionDrop:DropDown;
		
		/**
		 * 	@private
		 */
		private var _background:AssetDisplay			= new AssetDisplay();
		
		/**
		 * 	@constructor
		 */
		public function UIDisplay(display:OutputDisplay):void {
			const params:Parameters = display.getParameters();

			// super!			
			super(
				display,
				new LayerPage('Display',
					params.getParameter('framerate'),
					params.getParameter('backgroundColor'),
					params.getParameter('brightness'),
					params.getParameter('contrast'),
					params.getParameter('saturation'),
					params.getParameter('hue')
				),
				new LayerPage('FILTER')
			);
			
			init();
		}
		
		/**
		 *	@private 
		 */
		private function init():void {
			
			// order
			controlPage.x	= 3,
			controlPage.y	= 19,
			filterPane.x	= 142,
			filterPane.y	= 15,
			tabContainer.x	= 3;

			// change tab color
			controlTabs.transform.colorTransform = LAYER_HIGHLIGHT;
			
			// add background
			addChildAt(_background, 0);
			
			// tbd: clean up tabs
			addChild(tabContainer);
			
			var options:UIOptions	= new UIOptions();
			options.width			= 100;
			options.label			= false;

			_xFader					= new XFaderControl();
			_xFader.initialize(Display.getParameters().getParameter('channelMix'));

			// add the control
			_transitionDrop			= Factory.getNewInstance(DropDown) as DropDown;
			_transitionDrop.initialize(Display.getParameters().getParameter('channelBlend'), options);

			// draw
			_transitionDrop.x	= 74,
			_transitionDrop.y	= 136;//168;
			_xFader.x			= 17;
			_xFader.y			= 152;//142;

			// add the fader
			addChild(_transitionDrop);
			addChild(_xFader);

		}
		
	}
}