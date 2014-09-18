package services.http
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import onyx.asset.AssetFile;
	import onyx.core.Console;
	import onyx.utils.HtmlEntities;
	
	[Event(name="foldersloaded", type="flash.events.TextEvent")]
	
	public class Http extends EventDispatcher
	{
		/**
		 * 	@private
		 */
		private static var _domain:String = '';
		private static var _pathdefaultonx:String = '';
		private var _folders:XML;
		private var _assets:XML;
		private var _folderResponse:uint;
		private var resultToDecode:String = '';
		//private var arrayOfTextToDecode:Array;
		
		/**
		 * 	Http class instance
		 */
		private static const httpInstance:Http = new Http();
		
		/**
		 * 	Returns the Http instance (singleton)
		 *  to avoid multiple instances
		 */
		
		public static function getInstance():Http {
			//Console.output( 'Http getInstance' );
			return httpInstance;
		}
		
		// Constructor
		public function Http()
		{
			//Console.output( 'Http Constructor' );
			_domain = '';
			_pathdefaultonx = '';
			// ask for folders tree
			//loadFoldersAndAssets();
			super();
		}
		
		public function loadFoldersAndAssets():void
		{
			var url:String = domain + '/onyx/files.xml';
			var request:URLRequest = new URLRequest( url );
			Console.output( 'loadFoldersAndAssets: ' + url );
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, foldersTreeHandler );
			loader.addEventListener( IOErrorEvent.IO_ERROR, foldersTreeHandler ); 
			loader.load( request );
		}
		public function foldersTreeHandler( event:Event ):void
		{
			/*Console.output( 'Http foldersTreeHandler response from loader, event:' + event.type );
			Console.output( 'foldersTreeHandler event:' + event.toString() );*/
			if (event is ErrorEvent) 
			{
				Console.output( 'foldersTreeHandler error: ' + (event as IOErrorEvent).text );
			}
			else
			{
				resultToDecode = event.currentTarget.data;
				Console.output( 'foldersTreeHandler result length:' + resultToDecode.length );
				//arrayOfTextToDecode = resultToDecode.split( 'folderid' );
				
				// problem too long? 
				//folders = XML(HtmlEntities.decode(resultToDecode));
				folders = XML(resultToDecode);
				folderResponse = folders..ResponseCode;//0 if ok
				Console.output( "Http folders loaded" ); 
				
				if ( folderResponse == 0 ) 
				{
					var tEvent:TextEvent = new TextEvent("foldersloaded");
					tEvent.text = "Folders and assets tree loaded";
					dispatchEvent( tEvent );
					// added for http, remove for videopong?
					//AssetFile.queryDirectory('onyx-query://httppr', updateList);
				}

			}
		}
		
		/**
		 * getAssets based on folderId
		 */
		public function httpGetAssets( folderId:String ):XMLList {
			var assetsList:XMLList;
			//Console.output( "Http folderId:" + folderId); 
			assetsList = assets.asset.(@folderid == folderId);
			return assetsList;
		}		
		public function faultHandler( event:Event ):void {
			
			var faultString:String = event.currentTarget.toString();
			
			Console.output( "Http faultHandler: " + faultString );  
			
		}	
		public function get folders():XML
		{
			//Console.output( "Http get folders" + _folders.toString().substr(0,10) ); 
			return _folders;
		}
		
		public function set folders(value:XML):void
		{
			//Console.output( "Http set folders" + value.toString().substr(0,10)); 
			_folders = value;
		}
		
		public function get domain():String
		{
			//Console.output( "Http get domain:" + _domain ); 
			return _domain;
		}
		
		public function set domain(value:String):void
		{
			_domain = value;
		}
		
		public function get pathdefaultonx():String
		{
			//Console.output( "Http get pathdefaultonx:" + _pathdefaultonx ); 
			return _pathdefaultonx;
		}
		
		public function set pathdefaultonx(value:String):void
		{
			_pathdefaultonx = value;
		}
		
		public function get folderResponse():uint
		{
			//Console.output( "Http get folderResponse" ); 
			return _folderResponse;
		}
		
		public function set folderResponse(value:uint):void
		{
			_folderResponse = value;
		}
		
		public function get assets():XML
		{
			//Console.output( "Http get assets" ); 
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
