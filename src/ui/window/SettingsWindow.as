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

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import onyx.asset.AssetQuery;
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.*;
	import onyx.jobs.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.updater.OnyxAIRUpdate;
	
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
	public final class SettingsWindow extends Window implements IParameterObject {
		
		/**
		 * 	@private
		 * 	returns controls
		 */
		private const parameters:Parameters	= new Parameters(this as IParameterObject,
			new ParameterPlugin('transition', 'Layer Transition', PluginManager.transitions),
			new ParameterInteger('duration', 'Duration', 1, 20, 3)
		);
        
		/**
		 * 	@private
		 */
		private var buttonXML:TextButton;
		

		/**
		 * 	@private
		 */
		private var buttonUpdate:TextButton;
		
		/**
		 * 	@private
		 */
		private var transitionDropDown:DropDown;
		
		/**
		 * 	@private
		 */
		private var durationSlider:SliderV;
		
		/**
		 * 	@private
		 */
		private var bpmSlider:SliderV;
		
		/**
		 * 	@private
		 */
		private var tempoSlider:SliderV;
				
		/**
		 * 	@private
		 */
		private var tempoDropDown:DropDown;
		
		/**
		 * 	@private
		 */
		private const tapTempo:TempoShape	= new TempoShape();
		
		/**
		 * 	@private
		 */
		private const releaseTimer:Timer	= new Timer(50);
		
		/**
		 * 	@private
		 */
		private const samples:Array			= [0];
				
		/**
		 * 
		 */
		public var duration:int = 2;
		
		/**
		 * 	@constructor
		 */
		public function SettingsWindow(reg:WindowRegistration):void {
			
			super(reg, true, 150, 150);

			init();
		}
		
		/**
		 * 	@private
		 */
		private function init():void {
			
			var options:UIOptions	= new UIOptions( true, true, null, 52, 12 );

			// controls for display
			buttonXML				= new TextButton(options, 'save mix file'),
			
			// transition controls
			durationSlider			= Factory.getNewInstance(SliderV);
			durationSlider.initialize(parameters.getParameter('duration'), options);
			transitionDropDown		= Factory.getNewInstance(DropDown) as DropDown;
			transitionDropDown.initialize(parameters.getParameter('transition'), options);

			// tempo controls
			tempoSlider			= Factory.getNewInstance(SliderV);
			tempoSlider.initialize(
				Tempo.getParameter('delay'), options
			);
			tempoDropDown			= Factory.getNewInstance(DropDown);
			tempoDropDown.initialize(Tempo.getParameter('snapTempo'), options);
			bpmSlider			= Factory.getNewInstance(SliderV);
			bpmSlider.initialize(Tempo.getParameter('delay'), options);
			
			// add controls
			addChildren(
				tempoDropDown,					8,		40,
				tapTempo,						75,		33,
				bpmSlider,						8,		60,
				transitionDropDown,				8,		95,
				durationSlider,					75,		95,
				buttonXML,						8,		129
			);
			
			
			var bg:AssetWindow	= super.getBackground() as AssetWindow;
			
			// draw things onto the background
			if (bg) {
				var source:BitmapData	= bg.bitmapData;
				source.fillRect(new Rectangle(4, 25, 145, 1), 0xFF445463);
				source.fillRect(new Rectangle(4, 81, 145, 1), 0xFF445463);
				source.fillRect(new Rectangle(4, 123, 145, 1), 0xFF445463);
				source.fillRect(new Rectangle(4, 155, 145, 1), 0xFF445463);
				
				var label:StaticText		= new StaticText();
				
				label.text	= 'GLOBAL TEMPO';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 17));
				
				label.text	= 'TRANSITION';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 73));
				
				label.text	= 'MIX FILE';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 115));
				
				/*label.text	= 'ONYX-VJ UPDATE';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 147));*/
				
			}
                        
			// xml
			buttonXML.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			                       
			// start the timer
			Tempo.addEventListener(TempoEvent.CLICK, _onTempo);
			
			// tap tempo click
			tapTempo.addEventListener(MouseEvent.MOUSE_DOWN, _onTempoDown);
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
				case buttonXML:
					saveMix();
					break;
			}
			event.stopPropagation();
		}
		
		/**
		 * 	@private
		 */
		private function saveMix():void {
			
			StateManager.loadState(new SaveMixState());

		}
		
		/**
		 * 	@private
		 */
		private function _onFileSaved(query:AssetQuery):void {
			Console.output(query.path + ' saved.');
		}
		
		/**
		 * 
		 */
		public function set transition(t:Transition):void {
			if (t) {
				t.duration				= duration * 1000;
			}
			Browser.useTransition	= t;
		}
		
		/**
		 * 
		 */
		public function get transition():Transition {
			return Browser.useTransition;
		}
		

		/**
		 * 	@private
		 */
		private function _onTempoDown(event:Event):void {
			
			var time:int = getTimer();
			
			if (time - samples[int(samples.length - 1)] > 1000) {
				samples.splice(0, samples.length);
			}
			samples.push(time);
			
			var len:int = samples.length;
			
			if (len > 2) {

				var total:int	= 0;
	
				for (var count:int = 1; count < len; count++) {
					total += samples[count] - samples[count - 1];
				}

				total /= (count - 1);
				Tempo.delay = (total / 4);
			} else {
				Tempo.start();
			}
			
			if (len > 8) {
				samples.shift();
			}

		}
		
		/**
		 * 	@private
		 */
		private function _onTempo(event:TempoEvent):void {
			if (event.beat % 4 === 0) {
				tapTempo.transform.colorTransform = (event.beat % 16 == 0) ? TEMPO_BEAT : TEMPO_CLICK;
				releaseTimer.addEventListener(TimerEvent.TIMER, _onTempoOff);
				releaseTimer.start();
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onTempoOff(event:TimerEvent):void {
			tapTempo.transform.colorTransform = DEFAULT;
			releaseTimer.removeEventListener(TimerEvent.TIMER, _onTempoOff);
			releaseTimer.stop();
		}
		
		/**
		 * 	@public
		 */
		override public function dispose():void {
			
			// xml
			buttonXML.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			// start the timer
			Tempo.removeEventListener(TempoEvent.CLICK, _onTempo);
			
			// tap tempo click
			tapTempo.removeEventListener(MouseEvent.MOUSE_DOWN, _onTempoDown);
			
			// remove
			super.dispose();
			
		}
	}
}



import flash.display.Sprite;
import ui.assets.AssetTapTempo;

/**
 * 	Tempo shape
 */
final class TempoShape extends Sprite {
	
	/**
	 * 	@constructor
	 */
	public function TempoShape():void {
		
		addChild(new AssetTapTempo());
		
		super.buttonMode	= true;
		super.tabEnabled	= false;
		
	}
}