/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights rescerved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package services.midi {
	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import services.midi.*;
	
	import onyx.asset.*;
	import onyx.core.*;
	import onyx.ui.*;
	
	/**
	 *  
	 */
	public final class MidiProvider extends EventDispatcher {

		/**
		 * 	@private
		 */
		private const controls:Dictionary	= UserInterface.getAllControls();
		
		public var    conn:Socket;
		public var    host:String;
		public var    port:String;
		
		private var   _timer:Timer;
		private var   _attempts:int;
		private var   _maxAttempts:int = 3;
		
		/**
		 * 	@constructor
		 */		
		public function MidiProvider():void {		
			init();	
		}
		
		
		/**
		 * 
		 */
		private function init():void {
			
			_attempts = 0;
			conn = new Socket();		
			conn.addEventListener(Event.CONNECT, handleSocketConnected);
			conn.addEventListener(Event.CLOSE, handleSocketClose);
			conn.addEventListener(ProgressEvent.SOCKET_DATA, handleProgress);
			conn.addEventListener(IOErrorEvent.IO_ERROR, handleSocketIOError);
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSocketSecurityError);
			
		}
		
		public function connect():void {
			// 10sec timeout
			if(_attempts<_maxAttempts) {
				_attempts += 1;
				try{
					Console.output('MIDI Module: attempt '+_attempts+' on '+host+'@'+port);
					conn.connect(host, int(port));
				} catch (e : SecurityError) {
					_scheduleReconnect()
				}
			} else {
				Console.output('MIDI Module: network down');
				_attempts = 0;
			}
		}
		
		public function get connected():Boolean {
			return conn.connected;
		}
		private function _reconnect(event:Event): void {
			_timer.removeEventListener(TimerEvent.TIMER, _reconnect);
			_timer.stop();
			_timer = null;
			connect();
		}
		private function _scheduleReconnect():void {
			_timer = new Timer(1000,1);
			_timer.addEventListener(TimerEvent.TIMER, _reconnect);
			_timer.start();
		}
		
				
		/**
		 * 	@private
		 */
		private function _onFileSaved(query:AssetQuery):void {
			Console.output(query.path + ' saved.');
		}
		
		private function handleSocketConnected(e : Event) : void {
			Console.output('MIDI Module: connected');
			_attempts = 0;
		}
		private function handleSocketIOError(e : IOErrorEvent) : void {
			Console.output("MIDI Module: unable to connect, socket error");
			_scheduleReconnect();
		}
		private function handleSocketSecurityError(e : SecurityErrorEvent) : void {
			Console.output('MIDI Module: security error');
		}
		private function handleSocketClose(e:Event):void {
			Console.output('MIDI Module: connection lost');
			_scheduleReconnect();
		}
		
		
		private function handleProgress(event:ProgressEvent):void {
			
			var n:int 				= event.bytesLoaded;
			var buffer:ByteArray 	= new ByteArray();
			
			
			// SC: TODO...n==3 very restrictive due to startup errors!!
			// if(n==3)
			while(conn.bytesAvailable>=3) {
				buffer.clear();
				conn.readBytes(buffer,0,3);
				Midi.rxMessage(buffer);
			}
			
			buffer = null;
			
		}
		
		public function sendData(bytes:ByteArray):void {
			if(conn.connected) {
				conn.writeBytes(bytes);
				conn.flush();
				//Console.output('MIDI Module: sendData bytes:' + bytes.toString());
			}
		}
	}
}

