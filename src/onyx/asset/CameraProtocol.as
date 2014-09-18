package onyx.asset {
	
	import flash.media.*;
	
	import onyx.display.*;
	import onyx.plugin.*;
	
	public final class CameraProtocol implements IAssetProtocol {
		
		/**
		 * 
		 */
		public function getContent(path:String, layer:Layer):Content {
			
			const index:int = path.indexOf('://');
			
			return new ContentCamera(layer, path, Camera.getCamera(String(Camera.names.indexOf(path.substr(index + 3)))));
		}
		
		/**
		 * 
		 */
		public function getProtocolList(path:String):Array {
			const list:Array = [];
			for each (var name:String in Camera.names) {
				list.push(new CameraAsset(name));
			}
			return list;
		}
	}
}