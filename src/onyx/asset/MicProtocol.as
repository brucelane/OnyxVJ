package onyx.asset {
	
	import flash.media.*;
	
	import onyx.display.*;
	import onyx.plugin.*;
	
	public final class MicProtocol implements IAssetProtocol {
		
		/**
		 * 
		 */
		public function getContent(path:String, layer:Layer):Content {
			
			const index:int = path.indexOf('://');
			
			return new ContentMicrophone(layer, path, Microphone.getMicrophone(Microphone.names.indexOf(path.substr(index + 3))));
		}
		
		/**
		 * 
		 */
		public function getProtocolList(path:String):Array {
			const list:Array = [];
			for each (var name:String in Microphone.names) {
				list.push(new MicAsset(name));
			}
			return list;
		}
	}
}