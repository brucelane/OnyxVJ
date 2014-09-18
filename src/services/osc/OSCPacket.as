package services.osc 
{
	public class OSCPacket
	{
		private var _address:String;
		private var _port:String;
		private var _time:String;
		private var _xmlData:XML;
		
		// *** OSCPacket constructor / class definition
		public function OSCPacket(address:String, port:String, time:String, xmlData:XML) {
			this.address = address;
			this.port = port;
			this.time = time;
			this.xmlData = xmlData;
		}
		
		public function get address():String
		{
			return _address;
		}

		public function set address(value:String):void
		{
			_address = value;
		}

		public function get port():String
		{
			return _port;
		}

		public function set port(value:String):void
		{
			_port = value;
		}

		public function get time():String
		{
			return _time;
		}

		public function set time(value:String):void
		{
			_time = value;
		}

		public function get xmlData():XML
		{
			return _xmlData;
		}

		public function set xmlData(value:XML):void
		{
			_xmlData = value;
		}


	}
}


