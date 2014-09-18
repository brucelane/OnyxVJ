package services.osc {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import onyx.display.LayerImplementor;
	import onyx.events.LayerEvent;
	import onyx.events.ParameterEvent;
	import onyx.parameter.Parameter;
	import onyx.parameter.ParameterExecuteFunction;
	import onyx.parameter.Parameters;
	import onyx.plugin.Display;
	import onyx.plugin.Layer;
	import onyx.plugin.Module;
	import onyx.plugin.PluginManager;
	
	import services.osc.ExecuteBehavior;
	import services.osc.events.OSCEvent;
	import services.osc.ui.styles.OSC_HIGHLIGHT_SET;
	
	final public class OSC extends Module {
		
		public static const LAYER1:int                   = 0x90;
		/**
		 * 	Instance
		 */
		public static const instance:OSC 		= new OSC();
		private static const REUSABLE:OSCEvent	= new OSCEvent(OSCEvent.DATA);
		
		/**
		 * 	Move layer's OSC
		 */
		private static var _moveEvents:int = 0;
		private static var _layerFrom:Layer;
		private static var _layerTo:Layer;
		private static var _backupTo:Dictionary;
		
		/**
		 * 	Store styles for already set UIcontrol
		 */
		public static var controlsSet:Dictionary;
		
		/**
		 * 	Behavior/midihash crossmap
		 */
		private static var _map:Dictionary;
		
		/**
		 * 	Busy flag
		 */
		private static var busy:Boolean		= false;
		private static var started:Boolean 	= false;
		
		private static var _timer:Timer;
		
		/**
		 * 	@constructor
		 */
		public function OSC():void {
			
			// check unique
			if (instance)
				throw new Error('');
			
			_map = new Dictionary(false);
			
			_timer = new Timer(1000,10);
			_timer.addEventListener(TimerEvent.TIMER, _addListeners);
			_timer.start();
			
			busy 	= false;
			started = true;			
		}
		
		private static function _addListeners(e:Event):void {
			if(Display) {
				// add listeners
				for each(var layer:LayerImplementor in Display.layers) {
					layer.addEventListener(LayerEvent.LAYER_MOVE, _swapLayers);
					for each(var ctrl:Parameter in layer.getProperties())
					ctrl.addEventListener(ParameterEvent.CHANGE, _parChanged);
				}
				// remove timer
				_timer.removeEventListener(TimerEvent.TIMER, _addListeners);
				_timer.stop();
				_timer = null;
			} else {
				
			}
		}
		
		public static function registerControl(control:Parameter, OSChash:uint):ColorTransform {
			
			if(control && OSChash) {
				// check if alredy have this OSChash
				for (var val:Object in _map) {
					if(val==OSChash.toString() ) {
						if (_map[val]) {
							unregisterControl(OSChash);
						}
					}
				}
				
				// store the hash inside CONTROL
				control.setMetaData(ID, OSChash);
				
				// based on the control and the command type, create behaviors
				var behavior:IOSCControlBehavior;
				
				switch((OSChash>>8)&0xF0) {
					case LAYER1:	
						if (control is ParameterExecuteFunction) {
							behavior = new ExecuteBehavior(control as ParameterExecuteFunction);
						} 
						_map[OSChash] = behavior;
						break;
				}	
				//do style
				return OSC_HIGHLIGHT_SET;	
			}
			// error
			return null;
		}
		
		public static function unregisterControl(OSChash:uint):void {
			if (_map[OSChash]) {
				delete _map[OSChash].control.getMetaData(ID);			
				delete _map[OSChash];
			}           
		}
		
		
		/**
		 *  swap layers
		 **/
		public static function _swapLayers(event:LayerEvent):void {
			
			_moveEvents++;
			
			if(_moveEvents==1) {
				
				_layerTo 	= event.target as LayerImplementor;
				_backupTo 	= _backupControls(_layerTo.getProperties());
				
			} else if(_moveEvents==2) {
				
				_layerFrom 	= event.target as LayerImplementor;	
				
				for each(var controlTo:Parameter in _layerTo.getProperties()) {
					controlTo.setMetaData(ID, _layerFrom.getProperties().getParameter(controlTo.name).getMetaData(ID));
					registerControl( controlTo,
						controlTo.getMetaData(ID) as uint );	
				}
				for each(var controlFrom:Parameter in _layerFrom.getProperties()) {
					controlFrom.setMetaData(ID, _backupTo[controlFrom.name]);
					registerControl( controlFrom,
						controlFrom.getMetaData(ID) as uint );
				}
				
				_moveEvents = 0; 
			}
			
		}
		
		
		
		/**
		 *      RX/TX MIDI message to controller(via proxy)
		 */		
		public static function rxMessage(data:ByteArray):void {
			
			// this avoid loops on 2way communication: this tells that changes in parameter's value are coming from midi
			// so we avoid (see private _parChange()) to send back signal to midi controller in loop
			busy = true;
			
			var status:uint      = data.readUnsignedByte();
			var command:uint     = status&0xF0;
			var channel:uint     = status&0x0F; 
			var data1:uint       = data.readUnsignedByte(); // SC: if CC this contains MIDI Channel Number
			var data2:uint       = data.readUnsignedByte();
			
			var OSChash:uint    = ((status<<8)&0xFF00) | data1&0xFF; // SC: was ((status<<8)&0xFF00);
			
			var behavior:IOSCControlBehavior = _map[OSChash]; 
			
			if(behavior) {
				switch(command) {
					case LAYER1:
						behavior.setValue(data1);
						break;
					default:
						behavior.setValue(data1);
				}
			}
			
			if(instance.hasEventListener(OSCEvent.DATA)) {
				REUSABLE.command        = command;
				REUSABLE.channel        = channel;
				REUSABLE.data1          = data1;
				REUSABLE.data2          = data2;
				REUSABLE.OSChash       = OSChash;
				instance.dispatchEvent(REUSABLE);
			}
			
			// this tells that the incoming midi is up
			busy = false;
		}
		
		public static function txMessage(OSChash:uint, value:Number):void {
			var bytes:ByteArray = new ByteArray();
			bytes[0] = ((OSChash>>8)&0xFF);
			bytes[1] = OSChash&0xFF;
			bytes[2] = value;
			PluginManager.modules[ID].sendData(bytes);
		}  
		
		/**
		 *  parameter changed
		 **/
		public static function _parChanged(event:ParameterEvent):void {
			
			// ok, change is not coming from midi controller, so we send to it to allow 2way communication
			if(busy==false) {
				var par:Parameter = event.target as Parameter;
				OSC.txMessage(par.getMetaData(ID) as uint, event.value*127);
			}
			
		}
		
		private static function _backupControls(controls:Parameters):Dictionary {
			
			var _hashes:Dictionary = new Dictionary(false);
			for each(var control:Parameter in controls) {
				_hashes[control.name] = control.getMetaData(ID); 
			}
			return _hashes;
			
		}
		
	}
}
