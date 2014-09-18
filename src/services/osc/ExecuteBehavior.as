package services.osc {
	
	import onyx.parameter.ParameterExecuteFunction;
	
	public final class ExecuteBehavior implements IOSCControlBehavior {
		
		/**
		 * 	@private
		 */
		private var control:ParameterExecuteFunction;
		
		/**
		 * 
		 */
		public function ExecuteBehavior(control:ParameterExecuteFunction):void {
			this.control = control;
		}
		
		public function setValue(value:int):void {
			control.execute();
		}
	}
}

