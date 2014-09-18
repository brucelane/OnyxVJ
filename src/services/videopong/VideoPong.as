/** 
 * This is a generated sub-class of _VideoPong.as and is intended for behavior
 * customization.  This class is only generated when there is no file already present
 * at its target location.  Thus custom behavior that you add here will survive regeneration
 * of the super-class. 
 **/

package services.videopong
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import onyx.asset.AssetFile;
	import onyx.core.Console;
	import onyx.utils.HtmlEntities;
	
	[Event(name="loggedin", type="flash.events.TextEvent")]
	[Event(name="foldersloaded", type="flash.events.TextEvent")]
	
	public class VideoPong extends EventDispatcher
	{
		/**
		 * 	@private
		 */
		private static var _username:String = '';
		private static var _pwd:String = '';
		private static var _domain:String = '';
		private static var _pathdefaultonx:String = '';
		private var _folders:XML;
		private var _assets:XML;
		private var _folderResponse:uint;
		private var _loginResponse:uint;
		private var _sessiontoken:String = '';
		private var _fullUserName:String = '';
		private var _appkey:String = '';
		private var timer:Timer;
		private var resultToDecode:String = '';
		private var tempStr:String = '';
		//private var arrayOfTextToDecode:Array;
		
		/**
		 * 	VideoPong class instance
		 */
		private static const vpInstance:VideoPong = new VideoPong();
		
		/**
		 * 	Returns the VideoPong instance (singleton)
		 *  to avoid multiple instances
		 */
		
		public static function getInstance():VideoPong {
			//Console.output( 'Videopong getInstance' );
			return vpInstance;
		}
		
		// Constructor
		public function VideoPong()
		{
			//Console.output( 'Videopong Constructor' );
			_username = 'username';
			_pwd = 'password';
			_domain = '';
			_pathdefaultonx = '';
			
			super();
		}
		
		/**
		 * Login
		 */
		public function vpLogin():void 
		{
			Console.output( 'Videopong vpLogin:' + username  + 'domain:' + domain );
			
			//Call videopong webservice
			var url:String = domain + '/api/login/' + username + '/' + pwd;
			var request:URLRequest = new URLRequest( url );
			//request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, loginHandler );
			loader.addEventListener( IOErrorEvent.IO_ERROR, loginHandler ); 
			loader.load( request );
			
		}		
		/**
		 * 	Result from Login
		 */
		public function loginHandler( event:Event ):void {
			
			//Console.output( 'Videopong, loginHandler, response: ' + result );
			
			if (event is ErrorEvent) 
			{
				Console.output( 'Videopong login error: ' + (event as IOErrorEvent).text );
			}
			else
			{ 
				var result:String =	event.currentTarget.data;
				var res:XML = XML(result);
				loginResponse = res..ResponseCode;//0 if ok 1 if not then it is a guest
				sessiontoken = res..SessionToken;
				fullUserName = res..UserName;
				Console.output( 'Videopong login ok: ' + fullUserName);// + " loginResponse:" + loginResponse + " session:" + sessiontoken.substr(0,4) );
				var tEvent:TextEvent = new TextEvent("loggedin");
				tEvent.text = fullUserName;
				dispatchEvent( tEvent );
				
				// ask for folders tree
				loadFoldersAndAssets();
			}
		}	
		
		public function loadFoldersAndAssets():void
		{
			var url:String = domain + '/api/getfolderstreeassets/' + sessiontoken;
			var request:URLRequest = new URLRequest( url );
			Console.output( 'loadFoldersAndAssets: '  );
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, foldersTreeHandler );
			loader.addEventListener( IOErrorEvent.IO_ERROR, foldersTreeHandler ); 
			loader.load( request );
		}
		public function foldersTreeHandler( event:Event ):void
		{
			/*Console.output( 'Videopong foldersTreeHandler response from loader, event:' + event.type );
			Console.output( 'foldersTreeHandler event:' + event.toString() );*/
			if (event is ErrorEvent) 
			{
				Console.output( 'Videopong foldersTree error: ' + (event as IOErrorEvent).text );
			}
			else
			{
				Console.output( 'foldersTreeHandler result' );
				resultToDecode = event.currentTarget.data;
				Console.output( 'foldersTreeHandler result length:' + resultToDecode.length );
				//arrayOfTextToDecode = resultToDecode.split( 'folderid' );
				
				// problem too long? 
				//folders = XML(HtmlEntities.decode(resultToDecode));
				folders = XML(resultToDecode);
				folderResponse = folders..ResponseCode;//0 if ok
				Console.output( "Videopong folders loaded" ); 
				
				if ( folderResponse == 0 ) 
				{
					var tEvent:TextEvent = new TextEvent("foldersloaded");
					tEvent.text = "Folders and assets tree loaded";
					dispatchEvent( tEvent );
					//AssetFile.queryDirectory('onyx-query://vdpong', updateList);
				}
				// decode shorter strings
				/*timer = new Timer(12000);
				if (!timer.running)
				{
					timer.addEventListener(TimerEvent.TIMER, decode);
					timer.start();				
				}*/
			}
		}
		/*private function decode(event:Event):void 
		{		
			var tempToDecode:String = arrayOfTextToDecode.shift();
			Console.output( "tempToDecode:" + tempToDecode); 
			var tempRes:String = HtmlEntities.decode(tempToDecode );
			Console.output( "tempRes:" + tempRes); 
			
			tempStr += tempRes + 'folderid';
			Console.output( "tempStr:" + tempStr.length); 
			
			if (arrayOfTextToDecode.length == 0) 
			{
				Console.output( "timer.stop: " + tempStr.substr(0,15) ); 
				timer.stop();
				saveFolders();
			}
		}*/
		/*private function saveFolders(): void 
		{		
			Console.output( "saveFolders: " + tempStr.substr(0,15) ); 
			Console.output( "saveFolders l: " + tempStr.length ); 
			folders = XML(tempStr);			
			
			folderResponse = folders..ResponseCode;//0 if ok
			Console.output( "Videopong folders loaded" ); 
			
			if ( folderResponse == 0 ) 
			{
				var tEvent:TextEvent = new TextEvent("foldersloaded");
				tEvent.text = "Folders and assets tree loaded";
				dispatchEvent( tEvent );
				//AssetFile.queryDirectory('onyx-query://vdpong', updateList);
			}
		}*/
			
		/**
		 * getAssets based on folderId
		 */
		public function vpGetAssets( folderId:String ):XMLList {
			var assetsList:XMLList;
			//Console.output( "Videopong folderId:" + folderId); 
			assetsList = assets.asset.(@folderid == folderId);
			return assetsList;
		}		
		public function faultHandler( event:Event ):void {
			
			var faultString:String = event.currentTarget.toString();
			
			Console.output( "Videopong faultHandler: " + faultString );  
			
		}	
		public function get folders():XML
		{
			//Console.output( "Videopong get folders" + _folders.toString().substr(0,10) ); 
			return _folders;
		}
		
		public function set folders(value:XML):void
		{
			//Console.output( "Videopong set folders" + value.toString().substr(0,10)); 
			_folders = value;
		}
		
		public function get sessionToken():String
		{
			//Console.output( "Videopong get folders" ); 
			return sessiontoken;
		}
		
		public function set sessionToken(value:String):void
		{
			sessiontoken = value;
		}
		
		public function get domain():String
		{
			//Console.output( "Videopong get domain:" + _domain ); 
			return _domain;
		}
		
		public function set domain(value:String):void
		{
			_domain = value;
		}

		public function get pathdefaultonx():String
		{
			return _pathdefaultonx;
		}
		
		public function set pathdefaultonx(value:String):void
		{
			_pathdefaultonx = value;
		}

		public function get pwd():String
		{
			return _pwd;
		}
		
		public function set pwd(value:String):void
		{
			_pwd = value;
		}
		public function get fullUserName():String
		{
			return _fullUserName;
		}
		
		public function set fullUserName(value:String):void
		{
			_fullUserName = value;
		}
		public function get username():String
		{
			return _username;
		}
		
		public function set username(value:String):void
		{
			_username = value;
		}
		public function get appkey():String
		{
			//Console.output( "Videopong get appkey" + _appkey); 
			return _appkey;
		}
		
		public function set appkey(value:String):void
		{
			//Console.output( "Videopong set appkey" + value); 
			_appkey = value;
		}
		
		public function get folderResponse():uint
		{
			//Console.output( "Videopong get folderResponse" ); 
			return _folderResponse;
		}
		
		public function set folderResponse(value:uint):void
		{
			_folderResponse = value;
		}
		
		public function get loginResponse():uint
		{
			//Console.output( "Videopong get loginResponse" ); 
			return _loginResponse;
		}
		
		public function set loginResponse(value:uint):void
		{
			_loginResponse = value;
		}
		
		public function get sessiontoken():String
		{
			/*if (_sessiontoken)
			{
				Console.output( "Videopong get sessiontoken:" + _sessiontoken.substr(0,4) ); 
				
			}
			else
			{
				Console.output( "Videopong get sessiontoken is null"  ); 
				
			}*/
			return _sessiontoken;
		}
		
		public function set sessiontoken(value:String):void
		{
			_sessiontoken = value;
		}
		
		public function get assets():XML
		{
			//Console.output( "Videopong get assets" ); 
			return _assets;
		}
		
		public function set assets(value:XML):void
		{
			_assets = value;
		}
		/**
		 * 	@public
		 */
		public function dispose():void {
			
			
		}
	
	}
}
