/**
 * Copyright (c) 2003-2012 "Onyx-VJ Team" which is comprised of:
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
	
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.ui.*;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import onyx.asset.AssetFile;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.ParameterEvent;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.system.NativeAppLauncher;
	import onyx.tween.Tween;
	import onyx.tween.TweenProperty;
	import onyx.utils.string.*;
	
	import ui.controls.*;
	import ui.core.*;
	import ui.layer.LayerPage;
	import ui.layer.UILayer;
	import ui.policy.*;
	import ui.states.*;
	
	/**
	 * 	Dmx Window
	 */
	public final class DmxWindow extends Window implements IParameterObject {

		private var pane:ScrollPane;
		private var connectBtn:TextButton;
		private var outputBtn:TextButton;
		private var ichnSlider:SliderV;
		private var rchnSlider:SliderV;
		private var gchnSlider:SliderV;
		private var bchnSlider:SliderV;
		private var startaddrSlider:SliderV;

		private var appLauncher:NativeAppLauncher;		
		private var timer:Timer = new Timer(1000);
		private var pathToExe:String 	= 'onyxdmx.exe';
		private var tempText:String		= 'l';
		private var _ichn:int			= 0;
		private var _rchn:int			= 0;
		private var _gchn:int			= 0;
		private var _bchn:int			= 0;
		private var _startaddr:int		= 0;

		private const parameters:Parameters	= new Parameters(this as IParameterObject,
			new ParameterInteger('ichn', 'ichn', 0, 255, 0),
			new ParameterInteger('rchn', 'rchn', 0, 255, 0),
			new ParameterInteger('gchn', 'gchn', 0, 255, 0),
			new ParameterInteger('bchn', 'bchn', 0, 255, 0),
			new ParameterInteger('startaddr', 'startaddr', 0, 512, 0)
		);
			
		/**
		 * 	@Constructor
		 */
		public function DmxWindow(reg:WindowRegistration):void {
			
			// position & create
			super(reg, true, 260, 217);
			
			// show controls
			init();
			
			// we are draggable
			DragManager.setDraggable(this, true);		
		}

		private function init():void 
		{
			var index:int = 0;			
			pane		= new ScrollPane(121, 190);
			pane.x		= 3;
			pane.y		= 18;
			addChild(pane);
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			connectBtn				= new TextButton(options, 'connect'),
			connectBtn.addEventListener(MouseEvent.MOUSE_DOWN, start);
			pane.addChild(connectBtn).y = (index++ * 15);		
			
			outputBtn				= new TextButton(options, 'send'),
			outputBtn.addEventListener(MouseEvent.MOUSE_DOWN, outpMsg);
			pane.addChild(outputBtn).y = (index++ * 15);
					
			startaddrSlider				= Factory.getNewInstance(SliderV);
			startaddrSlider.initialize(parameters.getParameter('startaddr'), options);
			pane.addChild(startaddrSlider).y = (index++ * 20);
				
			ichnSlider				= Factory.getNewInstance(SliderV);
			ichnSlider.initialize(parameters.getParameter('ichn'), options);
			pane.addChild(ichnSlider).y = (index++ * 20);
				
			rchnSlider				= Factory.getNewInstance(SliderV);
			rchnSlider.initialize(parameters.getParameter('rchn'), options);
			pane.addChild(rchnSlider).y = (index++ * 20);
				
			gchnSlider				= Factory.getNewInstance(SliderV);
			gchnSlider.initialize(parameters.getParameter('gchn'), options);
			pane.addChild(gchnSlider).y = (index++ * 20);
				
			bchnSlider				= Factory.getNewInstance(SliderV);
			bchnSlider.initialize(parameters.getParameter('bchn'), options);
			pane.addChild(bchnSlider).y = (index++ * 20);
				
			appLauncher = new NativeAppLauncher(pathToExe);
			appLauncher.addEventListener( Event.ACTIVATE, activate );
			appLauncher.addEventListener( Event.CLOSE, closed );
			//appLauncher.addEventListener( Event.CHANGE, change );

			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		public function start(event:MouseEvent):void 
		{
			appLauncher.launchExe();
			event.stopPropagation();
		}
		private function outpMsg(event:MouseEvent):void 
		{
			//appLauncher.writeData('chan 3');
			event.stopPropagation();
		}

		public function getParameters():Parameters {
			return parameters;
		}
		private function onTimer(event:TimerEvent):void 
		{					
		}

		private function activate(evt:Event):void
		{
			trace("activate");
		}
		private function closed(evt:Event):void
		{
			trace("closed");
		}
		/**
		 * 
		 */
		override public function dispose():void 
		{					
			// dispose
			super.dispose(); 
		}

		public function get startaddr():int
		{
			return _startaddr;
		}

		public function set startaddr(value:int):void
		{
			_startaddr = value;
			Console.output('sendind startaddr',_startaddr);
			appLauncher.writeData('addr ' + _startaddr);
		}

		public function get ichn():int
		{
			return _ichn;
		}

		public function set ichn(value:int):void
		{
			_ichn = value;
			Console.output('sendind ichn',_ichn);
			appLauncher.writeData('ichn ' + _ichn);
		}

		public function get rchn():int
		{
			return _rchn;
		}

		public function set rchn(value:int):void
		{
			_rchn = value;
			Console.output('sendind rchn',_rchn);
			appLauncher.writeData('rchn ' + _rchn);
		}

		public function get gchn():int
		{
			return _gchn;
		}

		public function set gchn(value:int):void
		{
			_gchn = value;
			Console.output('sendind gchn',_gchn);
			appLauncher.writeData('gchn ' + _gchn);
		}

		public function get bchn():int
		{
			return _bchn;
		}

		public function set bchn(value:int):void
		{
			_bchn = value;
			Console.output('sendind bchn',_bchn);
			appLauncher.writeData('bchn ' + _bchn);
		}


	}
}
