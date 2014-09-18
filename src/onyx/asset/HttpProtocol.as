package onyx.asset
{
	import onyx.asset.http.HttpprAsset;
	import onyx.core.Console;
	import onyx.display.ContentHttp;
	import onyx.plugin.Content;
	import onyx.plugin.Layer;
	
	import services.http.Http;
	
	public final class HttpProtocol implements IAssetProtocol
	{
		private const http:Http = Http.getInstance();
		
		public function getContent(path:String, layer:Layer):Content
		{
			return new ContentHttp(layer, path);
		}
		
		public function getProtocolList(path:String):Array
		{
			const list:Array = [];
			var folders:XML = http.folders;
			if ( folders )
			{
				trace(folders.toString().substr(0,550));
				var response:uint = folders..ResponseCode;//0 if ok
				//select only folders for the path eg:onyx-query://httppr/all
				var folderList:XMLList;
				var subFolder:String = '';
				var assetsList:XMLList;
				Console.output( 'HttpProtocol, path: ' + path );
				if ( path.length > 20 )
				{
					var suffix:String = path.substr(20);
					Console.output( 'HttpProtocol, we are in a sub-folder: ' + suffix );
					var currentFolder:String = suffix.substr( suffix.indexOf('/') + 1 );
					Console.output( 'HttpProtocol, current folder: ' + currentFolder );
					folderList = folders.listfolders.folder.(@foldername==suffix).subfolder.folder; 
					if ( folderList.length() == 0 )
					{
						//no subfolders
						//add up folder button
						var i:int = suffix.indexOf('/');
						if ( i < 0 )
						{
							subFolder = '';
						}
							else
						{
							subFolder = suffix.substr( 0, i );							
						}
						//Console.output( 'HttpProtocol, no subfolders, we add the up one folder button to return to: ' + subFolder );
						list.push( new HttpAsset( '', true, subFolder ) );
						assetsList = folders.listfolders.folder.(@foldername==subFolder).subfolder.folder.(@foldername==currentFolder).asset;
					}
					else
					{
						subFolder = folders.listfolders.folder.(@foldername==suffix).@foldername + '/';
						//Console.output( 'HttpProtocol, subfolders exist, we first add the up one folder button to return to: ' + subFolder );
						list.push( new HttpAsset( '', true ) );
						assetsList = folders.listfolders.folder.(@foldername==suffix).asset;
					}
				}
				else
				{
					//Console.output( 'HttpProtocol, root folder.' );
					folderList = folders.listfolders.folder;
					assetsList = folders.listfolders.asset;
					//OK all folders: var folderList:XMLList = folders..folder;
				}
				// get assets from the selected folder
				if ( assetsList.length() >0 )
				{
					//if ( DEBUG::SPLASHTIME==0 ) Console.output( 'HttpProtocol, number of assets: ' + assetsList.length() );
					
					for each ( var asset:XML in assetsList )
					{
						//Console.output( asset.@name + '_'+asset.@url + ''+asset.@thumb_url );
						
						/*var decodedAssetName:String = HtmlEntities.decode(asset.@name);
						var httpAsset:AssetFile = new HttpAsset( decodedAssetName, asset.@url, asset.@thumb_url );*/
						//TODO check if need to decode
						var httpAsset:AssetFile = new HttpprAsset(asset.@name,  http.domain + asset.@url,  http.domain + asset.@thumb_url );
						list.push( httpAsset );
					}
				}
				//loop on resulting xmllist
				for each ( var folder:XML in folderList )
				{

					list.push( new HttpAsset( folder.@foldername, true, subFolder ) );
				}
			}
			else
			{
				Console.output( 'HttpProtocol, no folders found.' );
			}
			
			return list;
		}

	}
}