package ui.core {
	
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.ui.IUserInterfaceAdapter;
	import onyx.ui.UserInterfaceControl;
	
	import ui.controls.*;
	import ui.styles.*;
	
	public final class UserInterfaceAPI implements IUserInterfaceAdapter {
		
		public function createControl(param:Parameter, options:Object = null):UserInterfaceControl {
			var controlClass:Class	= PARAM_MAP[param.reflect()];
			
			if (options) {
				var newoptions:UIOptions	= new UIOptions();
				for (var i:String in options) {
					if (newoptions.hasOwnProperty(i)) {
						newoptions[i] = options[i]
					}
				}
			}

			var control:UIControl		= new controlClass();
			control.initialize(param, newoptions || UI_OPTIONS);
			
			return control;
		}
		
		public function getAllControls():Dictionary {
			return UIControl.available;
		}
	}
}