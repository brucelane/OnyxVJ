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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	
	import onyx.core.Console;
	import onyx.display.BlendModes;
	import onyx.display.OutputDisplay;
	import onyx.plugin.Display;
	import onyx.plugin.Layer;
	import onyx.tween.Tween;
	import onyx.tween.TweenProperty;
	
	import services.remote.DLCEvent;
	import services.remote.DirectLanConnection;
	import services.remote.PeerToPeerConnection;
	
	import ui.controls.ScrollPane;
	import ui.controls.TextButton;
	import ui.controls.UIOptions;
	import ui.core.DragManager;
	import ui.core.UIObject;
	import ui.layer.UILayer;
	
	/**
	 * 	Remote Mapping Window
	 */
	public final class RemoteWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var pane:ScrollPane;
		private var connectBtn:TextButton;
		private var sendBtn:TextButton;
		private var layersBtn:TextButton;

		private var cnx:DirectLanConnection;
		private var tween:Tween;
		private var index:int = 0;
		private var padTop:int = 18;
		private var selectedLayer:int = 0;
		//private var timer:Timer = new Timer(10000);
		private var layerButtonsCreated:Boolean = false;
		private var l:Layer;
		private var membersBtn:TextButton;
		private var peerNames:String = "Onyx-RemoteWindow";

		/**
		 * 	@Constructor
		 */
		public function RemoteWindow(reg:WindowRegistration):void {
			
			// position & create
			super(reg, true, 160, 117);
			
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
			pane.y		= padTop;
			addChild(pane);
			
			var options:UIOptions	= new UIOptions( true, true, null, 60, 12 );
			
			connectBtn				= new TextButton(options, 'connect');
			connectBtn.addEventListener(MouseEvent.MOUSE_DOWN, connection);
			pane.addChild(connectBtn).y = (index++ * padTop);
			
			sendBtn					= new TextButton(options, 'send');
			sendBtn.addEventListener(MouseEvent.MOUSE_DOWN, sendMsg);
			pane.addChild(sendBtn).y = (index++ * padTop);
			
			
			layersBtn				= new TextButton(options, 'layers');
			layersBtn.addEventListener(MouseEvent.MOUSE_DOWN, layersMsg);
			pane.addChild(layersBtn).y = (index++ * padTop);
			
			membersBtn				= new TextButton(options, 'members');
			membersBtn.addEventListener(MouseEvent.MOUSE_DOWN, membersMsg);
			pane.addChild(membersBtn).y = (index++ * padTop);
		}
		private function handleConnect(info:Object):void
		{
			Console.output("RWdw Connected");		
		}
		/*private function onTimer(event:TimerEvent):void 
		{
			Console.output("dlc members:" + cnx.memberCount());
			if ( !layerButtonsCreated ) dlc.sendData( {type:"layers", value:Display.layers.length} );
			var layer:Layer	= (UIObject.selection as UILayer).layer;
			dlc.sendData( {type:"layer", value:layer.index} );
		}*/
		//private function handleGotData(dataReceived:Object):void
		private function DataReceived(dataRcvd:Object):void
		{
			var valueRcvd:Number;
			var objValueRcvd:Object;
			var typeRcvd:String;
			//Console.output("dlc.received:");
			if ( dataRcvd.params && dataRcvd.params.type && dataRcvd.params.value )
			{
				if ( dataRcvd.params.value is Number) 
				{
					valueRcvd = dataRcvd.params.value;
				} 
				else
				{
					valueRcvd = 0;
					objValueRcvd = dataRcvd.params.value;
				}
				typeRcvd = dataRcvd.params.type.toString();
				Console.output(typeRcvd,":", valueRcvd);
				switch ( typeRcvd ) 
				{ 
					case "peername":
						Console.output("peername:" + objValueRcvd);
						peerNames += objValueRcvd;
						break;
					case "exitbtn":
						layerButtonsCreated = false;
						break;
					case "layerbtn":
						layerButtonsCreated = true;
						break;
					/*case "cnx":
						dlc.sendData( {type:"layers", value:Display.layers.length} );
						break;*/
					case "toggle-cross-fader":
						const property:TweenProperty = (Display.channelMix > .5) ? new TweenProperty('channelMix', Display.channelMix, 0) : new TweenProperty('channelMix', Display.channelMix, 1);
						
						new Tween( Display, 4000, property );
						break;
					case "frame-rate-increase":
						for each (l in Display.layers) {
							l.framerate += .5;
						}
						break;
					case "frame-rate-decrease":
						for each (l in Display.layers) {
							l.framerate -= .5;
						}
						break;
					case "cycle-blendmode-down":
						l	= (UIObject.selection as UILayer).layer;
						l.blendMode	= BlendModes[Math.min(BlendModes.indexOf(l.blendMode)+1, BlendModes.length - 1)];
						break;
					case "cycle-blendmode-up":
						l	= (UIObject.selection as UILayer).layer;
						l.blendMode	= BlendModes[Math.max(BlendModes.indexOf(l.blendMode)-1,0)];	
						break;
					case "select-layer":
						selectedLayer = valueRcvd;
						UILayer.selectLayer(selectedLayer);
						l = Display.getLayerAt(selectedLayer);
						/*dlc.sendData( {type:"path", value:l.path} );
						dlc.sendData( {type:"filters", value:l.filters.length} );*/
						//layer.filters.length>0
						//layer.filters[0].name = "BOUNCE"
						//layer.filters[0].
						break;
					case "fade-black":
						new Tween(
							Display,
							500,
							new TweenProperty('brightness', Display.brightness, (Display.brightness < 0) ? 0 : -1)
						)
						break;
					case "mute-layer":
						index = valueRcvd;
						selectedLayer = index;
						var layer:Layer = Display.getLayerAt(selectedLayer);
						if (layer.visible) {
							tween = new Tween(
								layer,
								250,
								new TweenProperty('alpha', layer.alpha, 0)
							);
							tween.addEventListener(Event.COMPLETE, tweenFinish);
						} else {
							layer.visible = true;
							tween = new Tween(
								layer,
								250,
								new TweenProperty('alpha', 0, 1)
							);
						}
						break;
					case "rotation":
						l	= (UIObject.selection as UILayer).layer;
						
						tween = new Tween(
							l,
							250,
							new TweenProperty('rotation', l.rotation, valueRcvd)
						);
						break;
					case "alpha":
						l	= (UIObject.selection as UILayer).layer;
						
						tween = new Tween(
							l,
							25,
							new TweenProperty('alpha', l.alpha, valueRcvd/100)
						);
						break;
					case "bounce":
						l	= (UIObject.selection as UILayer).layer;
						l.framerate	*= -1;

						break;
					case "x":
						l	= (UIObject.selection as UILayer).layer;
						
						tween = new Tween(
							l,
							25,
							new TweenProperty('x', l.x, valueRcvd)
						);
						break;
					case "y":
						l	= (UIObject.selection as UILayer).layer;
						
						tween = new Tween(
							l,
							25,
							new TweenProperty('y', l.y, valueRcvd)
						);
						break;
					case "brightness":
						l	= (UIObject.selection as UILayer).layer;
						
						tween = new Tween(
							l,
							25,
							new TweenProperty('brightness', l.brightness, valueRcvd/100)
						);
						break;
					case "contrast":
						l	= (UIObject.selection as UILayer).layer;
						
						tween = new Tween(
							l,
							25,
							new TweenProperty('contrast', l.contrast, valueRcvd/100)
						);
						break;
					case "saturation":
						l	= (UIObject.selection as UILayer).layer;
						
						tween = new Tween(
							l,
							25,
							new TweenProperty('saturation', l.saturation, valueRcvd/100)
						);
						break;
					case "backgroundcolor":
						Display.backgroundColor = valueRcvd;
						break;
					default: 
						trace("remoteWindow data received unknown");
						var p2p:PeerToPeerConnection = PeerToPeerConnection.getInstance();
						p2p.sendData(dataRcvd);
						break;
				}
				
			}
		}
		private function tweenFinish(event:Event):void {
			tween.removeEventListener(Event.COMPLETE, tweenFinish);
			l = Display.getLayerAt(selectedLayer);
			l.visible = false;
		}
		private function connection(event:MouseEvent):void {
			cnx = DirectLanConnection.getInstance();
			/*cnx.onConnect = handleConnect;
			cnx.onDataReceive = handleGotData;	*/
			cnx.addEventListener( DLCEvent.ON_RECEIVED, DataReceived );
			cnx.connect();//rtmfp://localhost/
			
			//timer.addEventListener(TimerEvent.TIMER, onTimer);
			//timer.start();

		}
		private function sendMsg(event:MouseEvent):void {
			switch (event.currentTarget) {
				case sendBtn:
					/*dlc.sendData( {type:"msg", value:"sent from onyx"} );*/
					break;
			}
			event.stopPropagation();
		}
		private function layersMsg(event:MouseEvent):void {
			switch (event.currentTarget) {
				case sendBtn:
					if (cnx && Display && Display.layers) cnx.sendData( {type:"layers", value:Display.layers.length} );
					break;
			}
			event.stopPropagation();
		}
		private function membersMsg(event:MouseEvent):void {
			if (cnx) 
			{
				membersBtn.label(cnx.memberCount() + " members" ); 
				
			}
			Console.output("peernames: " + peerNames);
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
