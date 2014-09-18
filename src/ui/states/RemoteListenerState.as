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
package ui.states {
	
	/*import com.reyco1.multiuser.MultiUserSession;
	import com.reyco1.multiuser.data.UserObject;*/
	//import com.reyco1.multiuser.debug.Logger;
	
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.ui.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.plugin.*;
	
	import ui.core.*;
	
	/**
	 * 	Listens for keyboard events
	 */
	public final class RemoteListenerState extends ApplicationState {
		private const SERVER:String   = "rtmfp://p2p.rtmfp.net/";
		private const DEVKEY:String   = "batchass"; // you can get a key from here : http://labs.adobe.com/technologies/cirrus/
		private const SERV_KEY:String = SERVER + DEVKEY;
		
		//private var connection:MultiUserSession;
		private var myName:String;
		private var myColor:uint;
		private var cursors:Object = {};		
		/**
		 * 	@private
		 */
		private static const forward:Object		= {};
		
		/**
		 * 
		 */
		private static const reverse:Object		= {};
		
		/**
		 * 	@private
		 */
		private static const keyUpHash:Object	= {};
		
		//private var :NetConnection;
		private var group:NetGroup;
		
		/**
		 * Boolean value indicating if the connection is establised 
		 */		
		public var isConnected:Boolean;	
		/**
		 * The port this connection is on 
		 */		
		public var port:String;
		/**
		 * Method that should be executed when data is received (should have one argument to hold the object returned from the NetStatusEvent : event.info.message)
		 */		
		public var onDataReceive:Function;
		/**
		 * Method that should be executed once the connection is established (should have one argument to hold the object returned from the NetStatusEvent : event.info.message)
		 */		
		public var onConnect:Function;
		
		/**
		 * 
		 */
		public static function registerKey(id:int, plugin:Plugin):void {
			
			if (plugin) 
			{
				
				var last:Plugin = forward[id];
				if (last) 
				{
					delete reverse[last];
				}
				
				// store forward and reverse hash
				forward[id] = plugin;
				reverse[plugin] = id;
				
			} 
			else 
			{
				
				var plugin:Plugin = forward[id];
				delete forward[id];
				if (plugin) 
				{
					delete reverse[plugin];
				}
				
			}
		}
		
		/**
		 * 
		 */
		public static function getKeyDefinition(id:int):Plugin 
		{
			return forward[id];
		}
		
		/**
		 * 
		 */
		public static function getMacroKeys(plugin:Plugin):int 
		{
			return reverse[plugin];
		}
		
		/**
		 * 	Returns an array of xml for the key settings
		 */
		public static function toXML():XML 
		{
			const xml:XML = <keys/>;
			
			for each (var plugin:Plugin in forward) 
			{
				var id:int = reverse[plugin];
				xml.appendChild(<key code={id}>{plugin.name}</key>);
			}
			
			return xml;
		}
		
		/**
		 * 
		 */
		public function RemoteListenerState():void 
		{
			super(ApplicationState.REMOTE);
			isConnected = false;
		}
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void 
		{
			Console.output("initialize");
			/*connection = new MultiUserSession(SERV_KEY, "multiuser/test"); 		// create a new instance of MultiUserSession
			connection.onConnect 		= handleConnect;						// set the method to be executed when connected
			connection.onUserAdded 		= handleUserAdded;						// set the method to be executed once a user has connected
			connection.onUserRemoved 	= handleUserRemoved;					// set the method to be executed once a user has disconnected
			connection.onObjectRecieve 	= handleGetObject;						// set the method to be executed when we recieve data from a user
			
			myName  = "Onyx_" + Math.round(Math.random()*100);					// my name
			myColor = Math.random()*0xFFFFFF;									// my color
			
			connection.connect(myName, {color:myColor});*/						// connect using my name and color variables
		}
		/*protected function handleConnect(user:UserObject):void					// method should expect a UserObject
		{
			Console.output("I'm connected: " + user.name + ", total: " + connection.userCount); 
			addEventListener(MouseEvent.MOUSE_MOVE, sendMyData);
		}
		
		protected function handleUserAdded(user:UserObject):void				// method should expect a UserObject
		{
			Console.output("User added: " + user.name + ", total users: " + connection.userCount);
			//cursors[user.id] = new CursorSprite(user.name, user.details.color);	// create a cursor for the new user that has just joined with his name and color
			//addChil( cursors[user.id] );
			
			sendMyData();
		}
		
		protected function handleUserRemoved(user:UserObject):void				// method should expect a UserObject
		{
			Console.output("User disconnected: " + user.name + ", total users: " + connection.userCount); 
			//removeChild( cursors[user.id] );									// remove cursor for disconnected user
			delete cursors[user.id];
		}
		
		protected function sendMyData(event:MouseEvent = null):void			
		{
			connection.sendObject({x:event.movementX, y:event.movementY});			// send my cursor position
		}
		
		protected function handleGetObject(peerID:String, data:Object):void
		{
			cursors[peerID].update(data.x, data.y);								// update user cursor
		}*/			
		/**
		 * 
		 */
		override public function pause():void {
			
			// remove listener
			/*DISPLAY_STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,	keyDown);
			DISPLAY_STAGE.removeEventListener(KeyboardEvent.KEY_UP,		keyUp);*/
			
		}
		
		/**
		 * 	Terminates the keylistener
		 */
		override public function terminate():void 
		{
			//clear();
		}
		
		/**
		 * 	@private
		 */
		/*private function keyDown(event:KeyboardEvent):void {
			
			const code:int		= event.keyCode;
			const plugin:Plugin	= forward[code];
			
			if (plugin && !keyUpHash[code]) {
				
				var macro:Macro	= plugin.createNewInstance() as Macro;
				keyUpHash[code] = macro;
				
				// execute the macro
				macro.keyDown();
				
				// add a listener for the key up
				DISPLAY_STAGE.addEventListener(KeyboardEvent.KEY_UP, keyUp);
				
			}
		}*/
		
		/**
		 * 	@private
		 */
		/*private function keyUp(event:KeyboardEvent):void 
		{
			const code:int			= event.keyCode;
			
			const macro:Macro = keyUpHash[code];
			if (macro) {
				macro.keyUp();
			}
			
			delete keyUpHash[code];
		
		}*/
		
	}
}