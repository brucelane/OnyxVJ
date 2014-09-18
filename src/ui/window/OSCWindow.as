package ui.window {
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import onyx.core.StateManager;
	import onyx.display.LayerImplementor;
	import onyx.parameter.IParameterObject;
	import onyx.parameter.Parameter;
	import onyx.parameter.ParameterExecuteFunction;
	import onyx.parameter.ParameterProxy;
	import onyx.parameter.ParameterString;
	import onyx.parameter.Parameters;
	import onyx.plugin.Display;
	import onyx.plugin.Filter;
	import onyx.ui.UserInterface;
	
	import services.osc.OP;
	import services.osc.OSC;
	import services.osc.OSCProvider;
	
	import ui.assets.AssetWindow;
	import ui.controls.ButtonControl;
	import ui.controls.TextButton;
	import ui.controls.TextControl;
	import ui.controls.UIOptions;
	import ui.core.DragManager;
	import ui.text.StaticText;
	
	public class OSCWindow extends Window implements IParameterObject {
		
		public var host:String;
		public var port:String;
		
		/**
		 * 	@private
		 */
		private var t1:TextControl;
		private var t2:TextControl;
		private var bc:ButtonControl;
		
		private var b1:TextButton;
		private var b2:TextButton;
		private var b3:TextButton;
		
		private const parameters:Parameters	= new Parameters(this as IParameterObject,
			new ParameterString('host', 'host'),
			new ParameterString('port', 'port'),
			new ParameterExecuteFunction('connect', 'connect')
			
		);
		
		public function connect():void {
			OP.connect();
		}
		
		public function OSCWindow(reg:WindowRegistration)  {
			//super(reg, true, 150, 184);
			super(reg, true, 150, 80);
			
			init();
			
			// make draggable
			DragManager.setDraggable(this);
			
			// load OSC provider
			OP = new OSCProvider();
			host = '127.0.0.1';
			//host = '192.168.0.18';
			port = '10000';
			OP.host = host;
			OP.port = port;
			OP.connect();
			
		}
		
		private function init():void {
			
			var options:UIOptions	= new UIOptions( true, true, null, 40, 12 );
			var options2:UIOptions	= new UIOptions( true, true, null, 48, 12 );
			
			// controls for display
			t1 = new TextControl();
			t1.initialize(parameters.getParameter('host'),options2);
			t2 = new TextControl();
			t2.initialize(parameters.getParameter('port'),options2);
			bc = new ButtonControl();
			bc.initialize(parameters.getParameter('connect'),options2);
			b1 = new TextButton(options, 'learn'),
				b2 = new TextButton(options, 'save'),
				b3 = new TextButton(options, 'load')
			
			// add controls
			addChildren(
				t1,		4,		35,
				t2,		52,		35,
				bc,     100,	35,
				b1,		8,		49,
				b2,		52,		49,
				b3,		96,		49
			);
			
			b1.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			b2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			b3.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			var bg:AssetWindow	= super.getBackground() as AssetWindow;
			if (bg) {
				var source:BitmapData	= bg.bitmapData;
				source.fillRect(new Rectangle(4, 25, 145, 1), 0xFF445463);
				
				var label:StaticText		= new StaticText();
				
				label.text	= 'PROXY';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 17));
				
				label.text	= 'ACTION';
				source.draw(label, new Matrix(1, 0, 0, 1, 4, 73));
				
			}
		}
		
		public function getParameters():Parameters {
			return parameters;
		}
		
		/**
		 * 	@private
		 */
		private function mouseDown(event:MouseEvent):void {
			/*TODO? switch (event.currentTarget) {
				case b1:
					StateManager.loadState(new OSCLearnState());
					break;
				case b2:
					StateManager.loadState(new OSCSaveState());
					break;
				case b3:
					StateManager.loadState(new OSCLoadState()); 
					break;
			}*/
			event.stopPropagation();
		}
		
		
		override public function dispose():void {
			
			b1.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			b2.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			b3.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			// remove
			super.dispose();
			
		}
		
		
		/**
		 *	SC: to OSC
		 **/		
		public static function toXML():XML {
			
			var windows:XML = <windows />;
			var local:XML;
			var remote:XML;
			
			var control:Parameter;
			
			for each(var registration:WindowRegistration in WindowRegistration.registrations) {
				var win:Window = WindowRegistration.getWindow(registration.name);
				
				if(win != null) {
					var xml:XML = <window/>;
					xml.@name 	= registration.name;
					
					// DISPLAY
					if(win is DisplayWindow) { 
						
						var display:DisplayWindow = win as DisplayWindow;
						// remote controls
						remote = <remote/>;
						for each(control in Display.getParameters() ) {
							if(control.name!='channelMix') {
								remote.appendChild(toControlXML(control));
							}
						}
						xml.appendChild(remote);
						
						// local controls
						local = <local/>;
						for each(control in Display.getParameters()) {
							local.appendChild(toControlXML(control));
						}
						xml.appendChild(local);			
						
						// LAYERS
					} else if(win is LayerWindow) {
						for each (var layer:LayerImplementor in Display.layers) {
							xml.appendChild(toLayerXML(layer));
						}
						
						// BROWSER	
						//} else if(win is Browser) {
						
						//	var browser:Browser = win as Browser;
						//	xml = <{substituteBlanks('FILE BROWSER','_')}/>;
						
						// FILTERS
					} else if(win is Filters) {
						
						var filters:Filters = win as Filters;
						
					} else if(win is SettingsWindow) {
						
						var settings:SettingsWindow = win as SettingsWindow;
						
						// remote controls
						remote = <remote/>;
						for each(control in settings.getParameters()) {
							remote.appendChild(toControlXML(control));
						}
						xml.appendChild(remote);
						
					}
					
					windows.appendChild(xml);
				}
				
			}
			
			return windows;
			
		}
		
		public static function toLayerXML(layer:LayerImplementor):XML {
			
			var xml:XML = <layer/>;
			xml.@name = layer.index;
			
			// properties
			for each (var property:Parameter in layer.getProperties()) {
				xml.appendChild(toControlXML(property));
			}
			
			// customs
			/*var custom:XML = <CUSTOM/>;
			for each (var control:Parameter in layer.getParameters()) {
			custom.appendChild(toControlXML(control));
			}
			xml.appendChild(custom);*/
			
			// filters
			/*var filters:XML = <FILTERS/>;
			for each (var filter:Filter in layer.filters) {
			var f:XML = <{filter.name}/>;
			for each (var controlF:Parameter in filter.getParameters()) {
			f.appendChild(toControlXML(controlF));
			}
			filters.appendChild(f);
			}
			xml.appendChild(filters);*/
			
			return xml;
			
		}
		
		public static function toControlXML(control:Parameter):XML {
			
			var xml:XML = <control/>;
			xml.@name 	= control.name;
			
			if(control is ParameterProxy) {
				
				var proxy:ParameterProxy = control as ParameterProxy;
				xml.appendChild( toControlXML(proxy.controlX) );
				xml.appendChild( toControlXML(proxy.controlY) ); 
				
			} else {
				
				if(	control.getMetaData(services.osc.ID)!=null && control.getMetaData(services.osc.ID)!=0 ) {
					xml.@OSC = control.getMetaData(services.osc.ID);
				}
				
			}
			
			return xml;
			
		}
		
		/**
		 *	SC: from OSC
		 **/
		public static function fromXML(x:XML):void {
			
			var OSCXML:XMLList = x.windows;
			
			var layer:LayerImplementor;
			var control:Parameter;
			
			for each(var xml:XML in OSCXML.children()) {
				
				var window:Window = WindowRegistration.getWindow(xml.@name);
				//var name:String = registration.name.replace('_',' ');
				//win.loadXML(OSC,windows[name]);
				
				// do parse xml		
				if(window is DisplayWindow) {
					
					var display:DisplayWindow = window as DisplayWindow;
					if(xml.hasOwnProperty('remote')) {
						for each (control in Display.getParameters()) {
							fromControlXML( control, xml.child('remote').child(control.name) );
						}
					}
					if(xml.hasOwnProperty('local')) {
						for each (control in Display.getParameters()) {
							//Console.output(control);
							fromControlXML( control, xml.child('local').child(control.name) );
						}
					}
					
				} else if(window is LayerWindow)  {
					
					for each (layer in Display.layers)
					fromLayerXML(layer,xml.layer.(@name == layer.index));
					
				} else if(window is SettingsWindow) {
					
					var settings:SettingsWindow = window as SettingsWindow;
					if(xml.hasOwnProperty('remote')) {
						for each (control in settings.getParameters()) {
							fromControlXML( control, xml.child('remote').child(control.name) );
						}
					}								
				}
				
			}					
		}
		
		public static function fromLayerXML(layer:LayerImplementor, xml:XMLList):void {
			
			var control:Parameter;
			var filter:Filter;
			
			// properties
			for each (control in layer.getProperties()) {
				fromControlXML( control, xml );
			}
			
			// customs
			/*if(layer.controls) {
			for each (control in layer.controls) {
			loadControlXML( control, xml.child(control.name) );
			}	
			}
			
			// filters
			if(layer.filters) {
			for each (filter in layer.filters) {
			for each (control in filter.controls) {
			loadControlXML( control, xml.child(control.name) );
			}	
			} 
			}*/				
		}
		
		public static function fromControlXML(control:Parameter, xml:XMLList):void {
			
			var controls:Dictionary = UserInterface.getAllControls();
			if(xml) {
				var hashXML:String = xml.control.(@name == control.name).@OSC;
				
				if(hashXML) {
					// proxy				
					if(control is ParameterProxy) {
						var proxy:ParameterProxy = control as ParameterProxy;
						for each (control in proxy) {
							fromControlXML( control, xml.child(control.name) );
						}	
						// single
					} else {
						// register control
						//OSC.controlsSet[uic] = 
						//	OSC.registerControl(control, uint(parseInt(hashXML)));
						//control
						//uic.transform.colorTransform = OSC.controlsSet[uic];
						OSC.registerControl(control, uint(parseInt(hashXML)) );
					}
				}
				
			}
			
		}
		
	}
	
}