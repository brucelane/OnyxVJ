package onyx.asset {
	
	import onyx.plugin.*;
	
	public interface IAssetProtocol {
		
		function getContent(path:String, layer:Layer):Content;
		function getProtocolList(path:String):Array;
	
	}
}