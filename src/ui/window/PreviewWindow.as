package ui.window {
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	
	import onyx.core.*;
	import onyx.events.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	import ui.controls.DropDown;
	import ui.controls.TextButton;
	import ui.controls.UIOptions;
	import ui.core.DragManager;
	
	public final class PreviewWindow extends Window implements IParameterObject {
		
		private var _pw:int;
		private var _ph:int;
		private var _px:int;
		private var _py:int;
		private var _ppw:int;
		private var _pph:int;
		
		private var _modes:Array = ['PIP','SINGLE','SPLIT'];
		private var _mode:String = 'PIP';
		
		/**
		 * 	@private
		 * 	returns controls
		 */
		private const parameters:Parameters	= new Parameters(this as IParameterObject,
			new ParameterArray('mode', 'mode', _modes , _mode )
		);
		
		/**
		 * 	@private
		 */
		private const preview:Bitmap	= new Bitmap(Display.source, PixelSnapping.ALWAYS, true);
	
		private const channelA:Bitmap	= new Bitmap(Display.channelA, PixelSnapping.ALWAYS, true);
		private const channelB:Bitmap	= new Bitmap(Display.channelB, PixelSnapping.ALWAYS, true);
		
		/**
		 * 	@private
		 */
		private var maximizeButton:TextButton;
		private var maximized:Boolean = false;
		
		//private var toggleA:TextButton;
		//private var toggleB:TextButton;
		private var modeDropDown:DropDown;
				
		/**
		 * 	Constructor
		 */
		public function PreviewWindow(reg:WindowRegistration):void {
			
			super(reg, true, 490, 400);
			
			var options:UIOptions		= new UIOptions();
			options.height				= 12,
			options.width				= 65;
			options.label				= false;
			
			maximizeButton	= new TextButton(options, 'Toggle size');
			//toggleA			= new TextButton(options, 'CH A');
			//toggleB			= new TextButton(options, 'CH B');
			modeDropDown	= new DropDown();
			modeDropDown.initialize(getParameters().getParameter('mode'),options);
			
			
			maximizeButton.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			/*toggleA.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			toggleA.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, handlerCh);
			toggleA.addEventListener(MouseEvent.MOUSE_UP, handlerCh);
			toggleB.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			toggleB.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, handlerCh);
			toggleB.addEventListener(MouseEvent.MOUSE_UP, handlerCh);*/
			//mode.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			
			maximizeButton.x	= 4,
			maximizeButton.y	= 18;
			/*toggleA.x 			= 72,
			toggleA.y 			= 18;
			toggleB.x 			= 140,
			toggleB.y 			= 18;*/
			modeDropDown.x 		= 72, // 208
			modeDropDown.y 		= 18;
			
			// add
			addChild(maximizeButton);
			//addChild(toggleA);
			//addChild(toggleB);
			addChild(modeDropDown);
			with(preview){x = 5, y = 35, width = 480, height = 360};
			addChild(preview);
			
			channelA.visible  = true;
			with(channelA){x = 5, y = 305, width = 120, height = 90, alpha = 1};
			addChild(channelA);
			
			channelB.visible  = true;
			with(channelB){x = 365, y = 305, width = 120, height = 90, alpha = 1};
			addChild(channelB);
			
			// add listeners			
			addEventListener(MouseEvent.MOUSE_DOWN,			mouseHandler);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,	mouseHandler);
			addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,	mouseHandler);
			
			//channelA.bitmapData.draw(new TextField({ text:'CH A', color: 0xFFFFFF }));
			
			// make draggable
			DragManager.setDraggable(this);
			
		}
		
		public function getParameters():Parameters {
			return parameters;
		}
		
		public function get mode():String {
			return _mode;	
		}
		public function set mode(value:String):void {
			//Console.output(value);
			switch(value) {
				case _modes[0]: // PIP
					channelA.visible = true;
					channelB.visible = true;
					with(preview){x = 5,	y = 35,	width = 480,	height = 360};
					with(channelA){x = 5,	y = 305,	width = 120,	height = 90};
					with(channelB){x = 365,	y = 305,	width = 120,	height = 90};
				case _modes[1]: // SINGLE
					channelA.visible = false;
					channelB.visible = false;
					preview.x		= 5;
					preview.y		= 35;
					preview.width	= 480; //Math.min(480, DISPLAY_WIDTH);
					preview.height	= 360; //Math.min(360, DISPLAY_HEIGHT);
					break;
				case _modes[2]: // SPLIT
					channelA.visible = true;
					channelB.visible = true;
					with(preview){x	= 5, 	y = 215,	width = 240, height	= 180};
					with(channelA){x = 5,	y = 35, 	width = 240, height = 180};
					with(channelB)(x = 245,	y = 35, 	width = 240, height	= 180);
					break;
			}
			_mode = value;
		} 
		
		private function handlerCh(event:MouseEvent):void {
			switch(event.type) {
				case MouseEvent.MOUSE_WHEEL:
					/*if((event.currentTarget.parent as TextButton).label.text=='CH A')
						channelA.alpha += event.delta/100; 
					else if((event.currentTarget.parent as TextButton).label.text=='CH B')
						channelB.alpha += event.delta/100;*/
					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:
					Console.output(event.target);
					event.target.addEventListener(MouseEvent.MOUSE_WHEEL, handlerCh);
					break;
				case MouseEvent.MOUSE_UP:	
					event.target.removeEventListener(MouseEvent.MOUSE_WHEEL, handlerCh);
			}
		}
		
		/**
		 * 	Handles mouse clicks on preview windows
		 */
		private function mouseHandler(event:MouseEvent):void {
			
			var e:InteractionEvent = new InteractionEvent(event.type);
			
			e.localX	= preview.mouseX;
			e.localY	= preview.mouseY;
			
			// forward the event
			Display.forwardEvent(e);
			
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					
					DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE,	mouseHandler);
					DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_UP,		mouseHandler);
			
					break;
				case MouseEvent.MIDDLE_MOUSE_DOWN:

					DISPLAY_STAGE.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,	mouseHandler);
					DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:

					DISPLAY_STAGE.addEventListener(MouseEvent.RIGHT_MOUSE_UP,	mouseHandler);
					DISPLAY_STAGE.addEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
				case MouseEvent.MOUSE_UP:

					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP,			mouseHandler);
					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
				case MouseEvent.MIDDLE_MOUSE_UP:
				
					DISPLAY_STAGE.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,	mouseHandler);
					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
				case MouseEvent.RIGHT_MOUSE_UP:
				
					DISPLAY_STAGE.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,	mouseHandler);
					DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,		mouseHandler);

					break;
			}
		}
		
		/**
		 * handles clicks on buttons
		 */
		private function handler(event:MouseEvent):void {
			switch (event.currentTarget) {
				case maximizeButton:
					if ( maximized ) {
						maximized 		= false;
						preview.width	= _pw; 
						preview.height	= _ph;
						preview.parent.width = _ppw;
						preview.parent.height = _pph;
						preview.parent.x = _px;
						preview.parent.y = _py;

					} else	{
						maximized 		= true;
						_pw = preview.width;
						_ph = preview.height;
						_px = preview.parent.x;
						_py = preview.parent.y;
						_ppw = preview.parent.width;
						_pph = preview.parent.height;
						preview.width	= 1200; 
						preview.height	= 760;
						preview.parent.width = 1300;
						preview.parent.height = 800;
						preview.parent.x = 10;
						preview.parent.y = 10;
					}
					break;
				/*case toggleA:
					channelA.visible = !channelA.visible;
					break;
				case toggleB:
					channelB.visible = !channelB.visible;
					break;*/
			}
		}		
		/**
		 * 
		 */
		override public function dispose():void {
			
			// remove listeners
			removeEventListener(MouseEvent.MOUSE_DOWN,				mouseHandler);
			removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,		mouseHandler);
			removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,		mouseHandler);

			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_UP,				mouseHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,		mouseHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,		mouseHandler);
			DISPLAY_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,			mouseHandler);
			
			//
			super.dispose();
		}
	}
}