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
package onyx.core {

	import flash.system.Capabilities;
	
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	
	import services.remote.PeerToPeerConnection;
	
	use namespace onyx_ns;

	/**
	 * 	This class defines command-line commands usable by Onyx
	 */
	public final class Command {
		
		//private static var cnx:DirectLanConnection = DirectLanConnection.getInstance("cmd");
		private static var cnx:PeerToPeerConnection = PeerToPeerConnection.getInstance();
		private static var _name:String;
		private static var l:Layer;
		private static var fadeFilter:Filter;
		private static var fadeFilterActive:Boolean = false;

		/**
		 * 	@private
		 */
		private static const _modules:Object = {}
		
		/**
		 * 	Registers a module to be executable through the console object
		 */
		public static function registerModule(name:String, module:Module):void {
			if (module) {
				_modules[name] = module;
			} else {
				delete _modules.name;
			}
		}
		
		/**
		 * 	Executes a command
		 */
		internal static function execute(name:String, args:Array):Object {
			
			const method:Function = Command[name];
			const module:Module	= _modules[name.toUpperCase()];
			
			try {
				if (method !== null) {
					var message:String = method.apply(Command, args);
				} else if (module !== null) {
					message = ((args.length > 0) ? '' : _createHeader(name)) + module.command.apply(module, args);
				}
			} catch (e:Error) {
				return e;
			}
			
			return message;
		}
		
		/**
		 * 	@private
		 * 	Help information
		 */
		private static function help(... args:Array):String {
			
			var text:String;
			
			switch (args[0]) {
				case 'command':
				case 'commands':
				
					text =	_createHeader('commands') + 
							'CLEAR: CLEARS THE TEXT<br>' +
							'FULLSCREEN: RUNS ONYX IN FULLSCREEN MODE<br>' +
							'COPY: COPY THE CONSOLE TEXT IN CLIPBOARD<br>' +
							'HELP CONTRIBUTORS: LIST OF CONTRIBUTORS TO THE ONYX PROJECT<br>' +
							'RESOLUTION: OUTPUTS THE SIZE OF THE FLASH DISPLAY_STAGE'
							/*'STAT [TIME:INT]:	TESTS ALL LAYERS FOR AVERAGE RENDERING TIME<br>' +
							'PLUGINS: SHOWS # OF PLUGINS<br>' + */
					break;
				case 'contributors':
					text =	'CONTRIBUTORS<br>-------------<br>' +
							'DANIEL HAI: <A HREF="HTTP://WWW.DANIELHAI.COM">HTTP://WWW.DANIELHAI.COM</A><br>' +
							'BRUCE LANE: <A HREF="HTTP://WWW.BATCHASS.FR">HTTP://WWW.BATCHASS.FR</A><br>' +
							'STEFANO COTTAFAVI <A HREF="HTTP://WWW.STEFANOCOTTAFAVI.COM/">HTTP://WWW.STEFANOCOTTAFAVI.COM/</A><br>';
					break;
				case 'plugins':
					text =	PluginManager.filters.length + ' FILTERS, ' +
							PluginManager.transitions.length + ' TRANSITIONS, ' +
							PluginManager.visualizers.length + ' VISUALIZERS LOADED.';
					break;
				case 'version':
					text =	'FLASH PLUG-IN VERSION: ' + Capabilities.version;
					break;
				case 'modules':
					text =	'';
					for each (var module:Module in PluginManager.modules) {
						text +=	module.name + ' loaded.  type ' + module.name + ' for options.<br>'
					}
					break;
				// dispatch the start-up motd
				default:
					text =	_createHeader('<b>ONYX ' + VERSION + '</b>', 21) + 
							'COPYRIGHT 2003-2012: WWW.ONYX-VJ.COM' ;/*+
							'<br>TYPE "HELP" OR "HELP COMMANDS" FOR MORE COMMANDS.' ;*/
					break;
			}
			
			// output?
			return text;
		}
		
		/**
		 * 	@private
		 */
		private static function _createHeader(command:String, size:int = 14):String {
			return '<font size="' + size + '" color="#DCC697" face="DefaultFont">' + command + '</font><br>';
		}

		/**
		 * 	Gets resolution
		 */		
		private static const resolution:Function = res;

		/**
		 * 	Gets resolution
		 */		
		private static function res():String {
			return 'RESOLUTION: ' + DISPLAY_STAGE.stageWidth + 'x' + DISPLAY_STAGE.stageHeight;
		}

		/**
		 * 	Gets/Sets bpm
		 */		
		public static function bpm(tmp:int = 6000):String {
			if (tmp != 6000) Tempo.delay = 60000/(tmp*4);
			return 'BPM: ' + 60000/(Tempo.delay*4) + ' tempo: ' + Tempo.delay;
		}
		/**
		 * 	Gets tempo
		 */		
	
		public static function tempo():String {
			//if (tmp != 60001) Tempo.delay = tmp;
			return 'tempo: ' + Tempo.delay + ' bpm: ' + 60000/(Tempo.delay*4);
		}
		/**
		 * 	@private
		 * 	asset information
		 */
		private static function info(... args:Array):String {
			
			var text:String;
			
			switch (args[0]) {
				default:
					text =	'http://';
					break;
			}
			
			// output
			return text;
		}
		/**
		 * 	Chat
		 */		
		private static function chat(url:String = "rtmfp:", name:String = "guest"):String {
			_name = name;
			
			cnx = PeerToPeerConnection.getInstance();
			cnx.onConnect = handleOnConnect;
			cnx.onDataReceive = handleDataReceived;
			cnx.connect(url);
			return 'Chat: connecting';
		}
		/**
		 * 	Scale
		 */		
		public static function scale(factor:Number = 1.2, duration:int = 300):String {
			var scaled:Boolean = false;
			var rtn:String = 'Scaled to ';
			
			for each (l in Display.layers) {
				if (l.scaleX == 1 ) {
					new Tween(
						l,
						duration,
						new TweenProperty('scaleX', l.scaleX, factor),
						new TweenProperty('scaleY', l.scaleY, factor)
					)
					scaled = true;
				} else {
					new Tween(
						l,
						duration,
						new TweenProperty('scaleX', l.scaleX, 1),
						new TweenProperty('scaleY', l.scaleY, 1)
					)						
				}
				
				
			}
			return rtn + (scaled?factor:1) + ' duration:' + duration;
		}
		/**
		 * 	Alpha
		 */		
		public static function alpha(factor:Number = 0.3, duration:int = 300):String {
			var a:Boolean = false;
			var rtn:String = 'alpha to ';
			
			for each (l in Display.layers) {
				if (l.alpha == 1 ) {
					new Tween(
						l,
						duration,
						new TweenProperty('alpha', l.alpha, factor)
					)
					a = true;
				} else {
					new Tween(
						l,
						duration,
						new TweenProperty('alpha', l.alpha, 1)
					)						
				}
				
				
			}
			return rtn + (a?factor:1) + ' duration:' + duration;
		}
		/**
		 * 	Brightness
		 */		
		public static function bright(factor:Number = 0.2, duration:int = 300):String {
			var b:Boolean = false;
			var rtn:String = 'brightness to ';
			
			for each (l in Display.layers) {
				trace(l.brightness);
				if (l.brightness == 0 ) {
					new Tween(
						l,
						duration,
						new TweenProperty('brightness', l.brightness, factor)
					)
					b = true;
				} else {
					new Tween(
						l,
						duration,
						new TweenProperty('brightness', l.brightness, 0)
					)						
				}
				
				
			}
			return rtn + (b?factor:1) + ' duration:' + duration;
		}
		/**
		 * 	Bounce
		 */		
		public static function bounce():String {
			for each (l in Display.layers) {
				l.framerate	*= -1;
			}
			return '';
		}
		/**
		 * 	Echo
		 */		
		public static function echo(mode:String = 'darken'):String {
			var rtn:String = mode;
			if ( fadeFilterActive == false ) 
			{
				fadeFilterActive = true;
				fadeFilter = PluginManager.createFilter('ECHO') as Filter;
				fadeFilter.setParameterValue('feedBlend', mode);
				fadeFilter.setParameterValue('feedAlpha', .7);
				Display.addFilter(fadeFilter);						
			}
			else
			{			
				fadeFilterActive = false;
				Display.removeFilter(fadeFilter);
				fadeFilter = null;
				rtn = 'none';
			}
			return rtn;
		}
		private static function members():String {		
			return cnx.memberCount();
		}
		private static function name():String {	
			cnx.sendData({type:"name", value:_name });	
			return _name;
		}
		protected static function handleOnConnect(user:Object):void
		{
			Console.output("Connected");			
			cnx.sendData( {type:"peername", value:"OnyxCmd-" + PeerToPeerConnection.ipAddresses} );

		}
		protected static function handleDataReceived(dataReceived:Object):void
		{
			// received
			switch ( dataReceived.type.toString() ) 
			{ 
				case "name":
					Console.output("Name:" + dataReceived.value);
					break;
				
				default: 
					Console.output("Received:" + dataReceived.value);
					break;
			}
		}
	}
}
