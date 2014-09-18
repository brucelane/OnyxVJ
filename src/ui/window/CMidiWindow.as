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
	import onyx.display.BlendModes;
	import onyx.display.ContentCustom;
	import onyx.display.LayerImplementor;
	import onyx.display.OutputDisplay;
	import onyx.parameter.Parameter;
	import onyx.parameter.Parameters;
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
	 * 	Midi Window
	 */
	public final class CMidiWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var pane:ScrollPane;
		private var connectBtn:TextButton;
		private var outputBtn:TextButton;
		private var listBtn:TextButton;
		private var loopbeBtn:TextButton;
		private var touchOscBtn:TextButton;
		private var nanoBtn:TextButton;
		private var resetBtn:TextButton;
		private var lightAllBtn:TextButton;
		private var lightBtn:TextButton;
		
		private var tween:Tween;
		private var index:int = 0;
		private var selectedLayer:int = 0;
		private var previousLayer:int = 0;
		private var layer:Layer;
		private var timer:Timer = new Timer(1000);
		private var pathToExe:String = 'MidiPipe.exe';
		private var tempText:String	= 'outp launchpad';
		private var appLauncher:NativeAppLauncher;		
		private var numerator:uint = 1;
		private var denominator:uint = 3;

		private const OFF:uint = 12;
		private const REDLOW:uint = 13;
		private const REDFULL:uint = 15;
		private const AMBERLOW:uint = 29;
		private const AMBERFULL:uint = 63;
		private const YELLOW:uint = 62;
		private const GREENLOW:uint = 28;
		private const GREENFULL:uint = 60;
		private const amountW:int = DISPLAY_WIDTH / 2.5;
		private const amountH:int = DISPLAY_HEIGHT / 2.5;
		
		/*private var fadeFilter:Filter;
		private var fadeFilterActive:Boolean = false;*/
		private var randomBlendActive:Boolean = false;
		private var hashCurrentBlendModes:Dictionary;
		private var randomDistortActive:Boolean = false;
		public static var useTransition:Transition;
		private var l:Layer;
		private var filter:Filter;
		private var test:Filter;
		private var flters:Array;

		/**
		 * 	@Constructor
		 */
		public function CMidiWindow(reg:WindowRegistration):void {
			
			// position & create
			super(reg, true, 260, 217);
			
			// show controls
			init();
			
			// we are draggable
			DragManager.setDraggable(this, true);
			
		}
		
		/**
		 * 	@private
		 */
		private function init():void 
		{
			var index:int = 0;			
			pane		= new ScrollPane(242, 100);
			pane.x		= 3;
			pane.y		= 18;
			addChild(pane);
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			connectBtn				= new TextButton(options, 'connect'),
			connectBtn.addEventListener(MouseEvent.MOUSE_DOWN, start);
			pane.addChild(connectBtn).y = (index++ * 15);		
			
			listBtn				= new TextButton(options, 'list'),
			listBtn.addEventListener(MouseEvent.MOUSE_DOWN, listMsg);
			pane.addChild(listBtn).y = (index++ * 15);
			
			loopbeBtn				= new TextButton(options, 'inpt loopbe'),
			loopbeBtn.addEventListener(MouseEvent.MOUSE_DOWN, loopBeMsg);
			pane.addChild(loopbeBtn).y = (index++ * 15);
			
			touchOscBtn				= new TextButton(options, 'inpt touch'),
			touchOscBtn.addEventListener(MouseEvent.MOUSE_DOWN, touchOscMsg);
			pane.addChild(touchOscBtn).y = (index++ * 15);
			
			nanoBtn					= new TextButton(options, 'inpt nano'),
			nanoBtn.addEventListener(MouseEvent.MOUSE_DOWN, nanoMsg);
			pane.addChild(nanoBtn).y = (index++ * 15);
			
			outputBtn				= new TextButton(options, 'outp launchpad'),
			outputBtn.addEventListener(MouseEvent.MOUSE_DOWN, outpMsg);
			pane.addChild(outputBtn).y = (index++ * 15);
			
			resetBtn				= new TextButton(options, 'reset lp btns'),
			resetBtn.addEventListener(MouseEvent.MOUSE_DOWN, reset);
			pane.addChild(resetBtn).y = (index++ * 15);
			
			lightAllBtn				= new TextButton(options, 'lp light all'),
			lightAllBtn.addEventListener(MouseEvent.MOUSE_DOWN, lightAll);
			pane.addChild(lightAllBtn).y = (index++ * 15);
			
			/*lightBtn				= new TextButton(options, 'nano light'),
			lightBtn.addEventListener(MouseEvent.MOUSE_DOWN, lightNano);
			pane.addChild(lightBtn).y = (index++ * 15);*/
			
			appLauncher = new NativeAppLauncher(pathToExe);
			appLauncher.addEventListener( Event.ACTIVATE, activate );
			appLauncher.addEventListener( Event.CLOSE, closed );
			appLauncher.addEventListener( Event.CHANGE, change );
			
			UILayer.selectLayer(selectedLayer);
			layer = Display.getLayerAt(selectedLayer);	
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		public function start(event:MouseEvent):void 
		{
			appLauncher.launchExe();
			event.stopPropagation();
		}
		private function listMsg(event:MouseEvent):void 
		{
			appLauncher.writeData('list');
			event.stopPropagation();
		}
		private function loopBeMsg(event:MouseEvent):void 
		{
			appLauncher.writeData('list');
			appLauncher.writeData('inpt loopbe');	
			layer = Display.getLayerAt(selectedLayer);
			event.stopPropagation();
		}
		private function touchOscMsg(event:MouseEvent):void 
		{
			appLauncher.writeData('list');
			appLauncher.writeData('inpt touch');	
			layer = Display.getLayerAt(selectedLayer);
			event.stopPropagation();
		}
		private function nanoMsg(event:MouseEvent):void 
		{
			appLauncher.writeData('list');
			appLauncher.writeData('inpt nano');	
			layer = Display.getLayerAt(selectedLayer);
			event.stopPropagation();
		}
		private function outpMsg(event:MouseEvent):void 
		{
			//appLauncher.writeData('list');
			appLauncher.writeData('outp launchpad');
			//appLauncher.writeData('inpt loop');
			appLauncher.writeData('144,64,'+AMBERLOW);
			appLauncher.writeData('144,65,'+AMBERLOW);
			appLauncher.writeData('144,66,'+AMBERLOW);
			appLauncher.writeData('144,67,'+AMBERLOW);
			appLauncher.writeData('144,96,'+AMBERLOW);		
			layer = Display.getLayerAt(selectedLayer);
			event.stopPropagation();
		}
		public function reset(event:MouseEvent):void 
		{			
			appLauncher.writeData('176,0,0');
			event.stopPropagation();
		}
		public function lightAll(event:MouseEvent):void 
		{			
			appLauncher.writeData('176,0,127');
			event.stopPropagation();
		}
		/*public function lightNano(event:MouseEvent):void 
		{	
			appLauncher.writeData('176,32,127');
			event.stopPropagation();
		}*/
		public function dutyCycle():void 
		{	
			if (numerator++>7) numerator = 1;
			if (denominator++>17) denominator = 3;
			var duty:uint = (16 * (numerator - 1)) + (denominator - 3);
			//if (duty > 127) duty = 0;
			appLauncher.writeData('176,30,' + duty);
		}
		public function gradient():void
		{
			for (var red:uint=0;red<8;red++)
			{
				for (var green:uint=0;green<8;green++)
				{
					var colour:uint = 12 + red + (green*16);
					var pos:uint = red + ((green)*16);
					appLauncher.writeData('144,' + pos + ',' + colour);
				}	
			}
		}
		private function lightPad( padIndex:uint, color:uint):void
		{
			appLauncher.writeData('144,' + padIndex + ','+AMBERLOW );
		}
		private function onTimer(event:TimerEvent):void 
		{
			
			var layer:Layer	= (UIObject.selection as UILayer).layer;
			//dutyCycle();
		}

		private function tweenFinish(event:Event):void {
			tween.removeEventListener(Event.COMPLETE, tweenFinish);
			//var layer:Layer = Display.getLayerAt(selectedLayer);
			layer.visible = false;
		}
		private function sendMsg(event:MouseEvent):void {
			switch (event.currentTarget) {
				case connectBtn:
					
					break;
			}
			event.stopPropagation();
		}
		public function change(evt:Event):void 
		{
			var rcvd:String = appLauncher.readAppOutput();
			var rcvdInt:uint = uint(rcvd);
			var channel:uint = rcvdInt & 0xf; 
			var cmd:uint = rcvdInt & 0xf0; 
			var noteon:uint = (rcvdInt>> 8) & 0xff; 
			var velocity:uint = (rcvdInt>> 16) & 0xff; 

			trace("change:" + noteon + " mod:" + noteon%4 + " velocity:" + velocity + " channel:" + channel);	

			/*
			 * LAUNCHPAD
			 */
			if (channel == 1)
			{
				if ( noteon > 67 ) 
				{
					if ( noteon % 4 == 0 )
					{
						previousLayer = selectedLayer;
						selectedLayer = 4;
						UILayer.selectLayer(selectedLayer);
						layer = Display.getLayerAt(selectedLayer);
					}
					else
					{
						if ( layer==null )
						{
							UILayer.selectLayer(selectedLayer);
							layer = Display.getLayerAt(selectedLayer);
							
						}
					}
				}
				else
				{		
						previousLayer = selectedLayer;
						selectedLayer = noteon % 4;
						UILayer.selectLayer(selectedLayer);
						layer = Display.getLayerAt(selectedLayer);					
				}
				switch ( noteon ) 
				{ 
					// 1st line: layer select
					case 64:
					case 65:
					case 66:
					case 67:
					case 96:
						if ( selectedLayer != previousLayer )
						{						
							appLauncher.writeData('144,64,'+AMBERLOW);
							appLauncher.writeData('144,65,'+AMBERLOW);
							appLauncher.writeData('144,66,'+AMBERLOW);
							appLauncher.writeData('144,67,'+AMBERLOW);
							appLauncher.writeData('144,96,'+AMBERLOW);					
							appLauncher.writeData('144,' + noteon + ',' + GREENFULL);
							if (layer.visible) 
							{
								appLauncher.writeData('144,'+(noteon-4)+','+GREENFULL);
								
							} 
							else 
							{
								appLauncher.writeData('144,'+(noteon-4)+','+REDLOW);	
							}
						}
						break;	
					// go to A
					case 97:
						if ( Display.channelMix > 0 ) Display.channelMix -= 0.03;
						break;
					// go to B
					case 98:
						if ( Display.channelMix < 1 ) Display.channelMix += 0.03;
						break;
					// switch A/B
					case 99:
						const property:TweenProperty = (Display.channelMix > .5) ? new TweenProperty('channelMix', Display.channelMix, 0) : new TweenProperty('channelMix', Display.channelMix, 1);					
						new Tween( Display, 4000, property );
						break;
					//2nd line visibility
					case 60:
					case 61:
					case 62:
					case 63:
					case 92:
						if (layer.visible)
						{
							appLauncher.writeData('144,'+noteon+','+REDLOW);
							tween = new Tween(
								layer,
								250,
								new TweenProperty('alpha', layer.alpha, 0)
							);
							tween.addEventListener(Event.COMPLETE, tweenFinish);
						} 
						else 
						{
							appLauncher.writeData('144,'+noteon+','+GREENFULL);
							layer.visible = true;
							tween = new Tween(
								layer,
								250,
								new TweenProperty('alpha', 0, 1)
							);
						}
						break;
					// fade chopDown
					case 93:
						Command.echo('darken');
						break;
					// fade chopUp
					case 94:
						Command.echo('lighten');
						break;
					case 95:
						if (Display.brightness < 0)
						{
							appLauncher.writeData('144,95,'+GREENFULL);
						}
						else
						{
							appLauncher.writeData('144,95,'+REDLOW);
						}
						new Tween(
							Display,
							500,
							new TweenProperty('brightness', Display.brightness, (Display.brightness < 0) ? 0 : -1)
						)
						break;
					//3rd line: pause (lacks 58 and 59)
					case 56:
					case 57:
					case 88:
						if (layer.paused) 
						{
							layer.pause(false);
							appLauncher.writeData('144,'+noteon+','+GREENFULL);						
						}
						else
						{
							layer.pause(true);
							appLauncher.writeData('144,'+noteon+','+REDLOW);						
						}
						break;
					//select layer
					case 58:
						if (velocity == 127)
						{
							previousLayer = selectedLayer;
							selectedLayer--;
							if (selectedLayer < 0) selectedLayer = 4;
							UILayer.selectLayer(selectedLayer);
							layer = Display.getLayerAt(selectedLayer);
						}
						break;
					case 59:
						if (velocity == 127)
						{
							previousLayer = selectedLayer;
							selectedLayer++;
							if (selectedLayer > 4) selectedLayer = 0;
							UILayer.selectLayer(selectedLayer);
							layer = Display.getLayerAt(selectedLayer);
						}
						break;
					// fade screen
					case 89:
						Command.echo('screen');
						break;
					// fade multiply
					case 90:
						Command.echo('multiply');
						break;
					// random blend
					case 91:
						if ( randomBlendActive == false ) 
						{
							randomBlendActive = true;
							Display.addEventListener(Event.ENTER_FRAME, randomBlend);
							
							hashCurrentBlendModes = new Dictionary(true);
							
							for each (l in Display.layers) {
								hashCurrentBlendModes[l]		= l.blendMode;
							}					
						}
						else
						{			
							randomBlendActive = false;
							Display.removeEventListener(Event.ENTER_FRAME, randomBlend);
							
							for each (l in Display.layers) {
								l.blendMode = hashCurrentBlendModes[l] || 'normal';
								l.alpha		= 1;
								delete hashCurrentBlendModes[l];
							}
							hashCurrentBlendModes = null;
						}
						break;
					
					//4th line: bounce
					case 52:
					case 53:
					case 54:
					case 55:
					case 84:
						layer.framerate	*= -1;
						break;
					// random 3D distort
					case 85:				
						randomDistortActive = true;
						var filters:Array, filter:Filter, plugin:Plugin;
						
						plugin = PluginManager.getFilterDefinition('DISTORT');
						
						if (plugin) {
							
							for each (var lay:Layer in Display.loadedLayers) {
								
								if (lay.path) {
									filter	= null;
									filters = lay.filters;
									
									for each (var test:Filter in filters) {
										if (test.name === 'DISTORT') {
											filter = test;
											break;
										}
									}
									
									if (!filter) {
										filter = plugin.createNewInstance() as Filter;
										lay.addFilter(filter);
									}
									
									new Tween(
										filter,
										300,
										new TweenProperty('bottomLeftX',	filter.getParameterValue('bottomLeftX'), (Math.random() * -amountW)),
										new TweenProperty('topLeftX',		filter.getParameterValue('topLeftX'), (Math.random() * -amountW)),
										new TweenProperty('bottomRightX',	filter.getParameterValue('bottomRightX'), DISPLAY_WIDTH + (Math.random() * amountW)),
										new TweenProperty('topRightX',		filter.getParameterValue('topRightX'), DISPLAY_WIDTH + (Math.random() * amountW)),
										new TweenProperty('bottomLeftY',	filter.getParameterValue('bottomLeftY'), DISPLAY_HEIGHT + (Math.random() * amountH)),
										new TweenProperty('topLeftY',		filter.getParameterValue('topLeftY'), (Math.random() * -amountH)),
										new TweenProperty('bottomRightY',	filter.getParameterValue('bottomRightY'), DISPLAY_HEIGHT + (Math.random() * amountH)),
										new TweenProperty('topRightY',		filter.getParameterValue('topRightY'), (Math.random() * -amountH))
									)
									
								}
							}
						}	
						break;
					case 86:		
						if ( randomDistortActive == true )
						{
							
							randomDistortActive = false;
							
							for each (l in Display.layers) {
								new Tween(
									l,
									600,
									new TweenProperty('x', l.x, 0),
									new TweenProperty('y', l.y, 0),
									new TweenProperty('scaleX', l.scaleX, 1),
									new TweenProperty('scaleY', l.scaleY, 1)
								)
								
								filter	= null;
								filters = l.filters;
								
								for each (test in filters) {
									if (test.name === 'DISTORT') {
										filter = test;
										break;
									}
								}
								
								if (filter) {
									
									new Tween(
										filter,
										300,
										new TweenProperty('bottomLeftX',	filter.getParameterValue('bottomLeftX'), 0),
										new TweenProperty('topLeftX',		filter.getParameterValue('topLeftX'), 0),
										new TweenProperty('bottomRightX',	filter.getParameterValue('bottomRightX'), DISPLAY_WIDTH),
										new TweenProperty('topRightX',		filter.getParameterValue('topRightX'), DISPLAY_WIDTH),
										new TweenProperty('bottomLeftY',	filter.getParameterValue('bottomLeftY'), DISPLAY_HEIGHT),
										new TweenProperty('topLeftY',		filter.getParameterValue('topLeftY'), 0),
										new TweenProperty('bottomRightY',	filter.getParameterValue('bottomRightY'), DISPLAY_HEIGHT),
										new TweenProperty('topRightY',		filter.getParameterValue('topRightY'), 0)
									)
									
								}
							}
						}
						break;
					//saturation b&w
					case 87:	
						Console.output("saturation:",Display.saturation);
						if (Display.saturation < 1)
						{
							appLauncher.writeData('144,86,'+GREENFULL);
						}
						else
						{
							appLauncher.writeData('144,86,'+REDLOW);
						}
						new Tween(
							Display,
							500,
							new TweenProperty('saturation', Display.saturation, (Display.saturation < 1) ? 1 : 0)
						)
						break;
					//5th line: channel AB
					case 48:
					case 49:
					case 50:
					case 51:
					case 80:					
						layer.channel = !layer.channel;
						break;
					case 81:
						if (layer.scaleX == 1.1 )
						{
							new Tween(
								layer,
								60,
								new TweenProperty('scaleX', layer.scaleX, 1),
								new TweenProperty('scaleY', layer.scaleY, 1)
							)
							
						}
						else
						{
							new Tween(
								layer,
								60,
								new TweenProperty('scaleX', layer.scaleX, 1.1),
								new TweenProperty('scaleY', layer.scaleY, 1.1)
							)						
						}
						break;
					// framerate
					case 82:
						for each (l in Display.layers) l.framerate += .1;
						break;
					case 83:
						for each (l in Display.layers) l.framerate -= .1;
						break;
					// 6th line
					case 44:
					case 45:
					case 46:
					case 47:
					case 76:
						if (layer)
						{
							//layer.alpha = 0.99;
							if (layer.getParameters())
							{
								if (layer.getParameters().getParameter('midi'))
								{
									layer.getParameters().getParameter('midi').value = velocity;
									
								}
							}
							else
							{
								trace("layer.getParameters() null");
							}
						}
						else
						{
							trace("layer null");
						}
						break;
					default:
						//for the rest: load onx
						var f:File = new File( AssetFile.resolvePath( 'library/' + noteon + '.onx' ) );
						if ( f.exists )
						{
							const li:LayerImplementor = (Display as OutputDisplay).getLayerAt(0) as LayerImplementor;
							(Display as OutputDisplay).load(f.url, li, useTransition);
							
						}	
						else
						{
							Console.output( f.url + ' does not exist' );
						}
						break;
				}
			}// end launchpad
			else
			{
				/*
				* NANOKONTROL2
				*/
				switch ( noteon ) 
				{ 
					
					// go to A
					case 61:
						if ( Display.channelMix > 0 ) Display.channelMix -= 0.03;
						break;
					// go to B
					case 62:
						if ( Display.channelMix < 1 ) Display.channelMix += 0.03;
						break;
					// switch A/B
					case 60:
						const prop:TweenProperty = (Display.channelMix > .5) ? new TweenProperty('channelMix', Display.channelMix, 0) : new TweenProperty('channelMix', Display.channelMix, 1);					
						new Tween( Display, 4000, prop );
						break;
					// fade chopDown
					case 93:
						Command.echo('darken');
						break;
					// fade chopUp
					case 94:
						Command.echo('lighten');
						break;
					case 95:
						new Tween(
							Display,
							500,
							new TweenProperty('brightness', Display.brightness, (Display.brightness < 0) ? 0 : -1)
						)
						break;
					//layer 1 to 5 reverse R buttons
					case 64:
					case 65:
					case 66:
					case 67:
					case 68:
						previousLayer = selectedLayer;
						selectedLayer = noteon - 64;
						UILayer.selectLayer(selectedLayer);
						layer = Display.getLayerAt(selectedLayer);
						layer.framerate *= -1;
						selectedLayer = previousLayer;
						UILayer.selectLayer(selectedLayer);
						layer = Display.getLayerAt(selectedLayer);
						break;
					//layer 1 to 5 mute M buttons
					case 48:
					case 49:
					case 50:
					case 51:
					case 52:
						previousLayer = selectedLayer;
						selectedLayer = noteon - 48;
						UILayer.selectLayer(selectedLayer);
						layer = Display.getLayerAt(selectedLayer);
						if (velocity == 127)
						{
							tween = new Tween(
								layer,
								250,
								new TweenProperty('alpha', layer.alpha, 0)
							);
							tween.addEventListener(Event.COMPLETE, tweenFinish);
						}
						else
						{
							layer.visible = true;
							tween = new Tween(
								layer,
								250,
								new TweenProperty('alpha', 0, 1)
							);
						}
						selectedLayer = previousLayer;
						UILayer.selectLayer(selectedLayer);
						layer = Display.getLayerAt(selectedLayer);
						break;
					case 53:		
						if (layer.paused) 
						{
							layer.pause(false);
						}
						else
						{
							layer.pause(true);
						}
						break;
					//select layer
					case 58:
						if (velocity == 127)
						{
							previousLayer = selectedLayer;
							selectedLayer--;
							if (selectedLayer < 0) selectedLayer = 4;
							UILayer.selectLayer(selectedLayer);
							layer = Display.getLayerAt(selectedLayer);
						}
						break;
					case 59:
						if (velocity == 127)
						{
							previousLayer = selectedLayer;
							selectedLayer++;
							if (selectedLayer > 4) selectedLayer = 0;
							UILayer.selectLayer(selectedLayer);
							layer = Display.getLayerAt(selectedLayer);
						}
						break;
					// fade screen
					case 38:
						Command.echo('screen');
						break;
					// fade multiply
					case 54:
						Command.echo('multiply');
						break;
					// random blend
					case 55:
						if ( randomBlendActive == false ) 
						{
							randomBlendActive = true;
							Display.addEventListener(Event.ENTER_FRAME, randomBlend);
							
							hashCurrentBlendModes = new Dictionary(true);
							
							for each (l in Display.layers) {
								hashCurrentBlendModes[l]		= l.blendMode;
							}					
						}
						else
						{			
							randomBlendActive = false;
							Display.removeEventListener(Event.ENTER_FRAME, randomBlend);
							
							for each (l in Display.layers) {
								l.blendMode = hashCurrentBlendModes[l] || 'normal';
								l.alpha		= 1;
								delete hashCurrentBlendModes[l];
							}
							hashCurrentBlendModes = null;
						}
						break;
					// random 3D distort
					case 37:				
						randomDistortActive = true;				
						plugin = PluginManager.getFilterDefinition('DISTORT');
						
						if (plugin) {
							
							for each (l in Display.loadedLayers) {
								
								if (l.path) {
									filter	= null;
									flters = l.filters;
									
									for each (test in flters) {
										if (test.name === 'DISTORT') {
											filter = test;
											break;
										}
									}
									
									if (!filter) {
										filter = plugin.createNewInstance() as Filter;
										l.addFilter(filter);
									}
									
									new Tween(
										filter,
										300,
										new TweenProperty('bottomLeftX',	filter.getParameterValue('bottomLeftX'), (Math.random() * -amountW)),
										new TweenProperty('topLeftX',		filter.getParameterValue('topLeftX'), (Math.random() * -amountW)),
										new TweenProperty('bottomRightX',	filter.getParameterValue('bottomRightX'), DISPLAY_WIDTH + (Math.random() * amountW)),
										new TweenProperty('topRightX',		filter.getParameterValue('topRightX'), DISPLAY_WIDTH + (Math.random() * amountW)),
										new TweenProperty('bottomLeftY',	filter.getParameterValue('bottomLeftY'), DISPLAY_HEIGHT + (Math.random() * amountH)),
										new TweenProperty('topLeftY',		filter.getParameterValue('topLeftY'), (Math.random() * -amountH)),
										new TweenProperty('bottomRightY',	filter.getParameterValue('bottomRightY'), DISPLAY_HEIGHT + (Math.random() * amountH)),
										new TweenProperty('topRightY',		filter.getParameterValue('topRightY'), (Math.random() * -amountH))
									)
									
								}
							}
						}	
						break;
					case 53:		
						if ( randomDistortActive == true )
						{
							
							randomDistortActive = false;
							
							for each (l in Display.layers) {
								new Tween(
									l,
									600,
									new TweenProperty('x', l.x, 0),
									new TweenProperty('y', l.y, 0),
									new TweenProperty('scaleX', l.scaleX, 1),
									new TweenProperty('scaleY', l.scaleY, 1)
								)
								
								filter	= null;
								flters = l.filters;
								
								for each (test in flters) {
									if (test.name === 'DISTORT') {
										filter = test;
										break;
									}
								}
								
								if (filter) {
									
									new Tween(
										filter,
										300,
										new TweenProperty('bottomLeftX',	filter.getParameterValue('bottomLeftX'), 0),
										new TweenProperty('topLeftX',		filter.getParameterValue('topLeftX'), 0),
										new TweenProperty('bottomRightX',	filter.getParameterValue('bottomRightX'), DISPLAY_WIDTH),
										new TweenProperty('topRightX',		filter.getParameterValue('topRightX'), DISPLAY_WIDTH),
										new TweenProperty('bottomLeftY',	filter.getParameterValue('bottomLeftY'), DISPLAY_HEIGHT),
										new TweenProperty('topLeftY',		filter.getParameterValue('topLeftY'), 0),
										new TweenProperty('bottomRightY',	filter.getParameterValue('bottomRightY'), DISPLAY_HEIGHT),
										new TweenProperty('topRightY',		filter.getParameterValue('topRightY'), 0)
									)
									
								}
							}
						}
						break;
					//saturation b&w
					case 69:	
						Console.output("saturation:",Display.saturation);

						new Tween(
							Display,
							500,
							new TweenProperty('saturation', Display.saturation, (Display.saturation < 1) ? 1 : 0)
						)
						break;
					case 65:					
						layer.channel = !layer.channel;
						break;
					case 33:
						if (layer.scaleX == 1.1 )
						{
							new Tween(
								layer,
								60,
								new TweenProperty('scaleX', layer.scaleX, 1),
								new TweenProperty('scaleY', layer.scaleY, 1)
							)
							
						}
						else
						{
							new Tween(
								layer,
								60,
								new TweenProperty('scaleX', layer.scaleX, 1.1),
								new TweenProperty('scaleY', layer.scaleY, 1.1)
							)						
						}
						break;
					// framerate
					case 44:
						for each (l in Display.layers) l.framerate += .1;
						break;
					case 43:
						for each (l in Display.layers) l.framerate -= .1;
						break;
					case 0:
						if (velocity>0)	layer.alpha = velocity/127;
						break;
					case 1:
						if (velocity>0)	layer.brightness = velocity/127;
						break;
					case 2:
						if (velocity>0)	layer.contrast = velocity/127;
						break;
					case 3:
						if (velocity>0)	layer.saturation = velocity/64;
						break;
					case 4:
						if (velocity>0)	layer.hue = velocity/127;
						break;
					case 7:
						if (layer)
						{
							//layer.alpha = 0.99;
							if (layer.getParameters())
							{
								if (layer.getParameters().getParameter('midi'))
								{
									layer.getParameters().getParameter('midi').value = velocity;
									
								}
							}
							else
							{
								trace("layer.getParameters() null");
							}
						}
						else
						{
							trace("layer null");
						}
						break;
					case 16:
						trace("layer.totalTime:"+layer.totalTime);
						trace("layer.loopStart:"+layer.loopStart);
						trace("layer.loopEnd:"+layer.loopEnd);
						trace("layer.time:"+layer.time);
						layer.loopStart = velocity/100;//between 0 and 1
						break;
					case 17:
						layer.loopEnd = velocity/100;
						break;
					default:
						
						break;
				}
			}
			//appLauncher.writeData('144,' + noteon + ',' + velocity );
			//3 = red, 5=low red, 30=mid orange,
		

		}
		private function randomBlend(event:Event):void {
			for each (l in Display.layers) {
				l.blendMode = BlendModes[Math.floor(Math.random() * BlendModes.length)];
				l.alpha		= .8;
			}
		}
		private function activate(evt:Event):void
		{
			//trace("activate");
			//running = true;
		}
		private function closed(evt:Event):void
		{
			//trace("closed");
			//running = false;
		}
		/**
		 * 
		 */
		override public function dispose():void 
		{					
			// dispose
			super.dispose(); 
		}
	}
}
