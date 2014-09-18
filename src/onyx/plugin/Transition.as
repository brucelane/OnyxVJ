/**
 * Copyright (c) 2003-2008 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 *
 * All rights reserved.
 *
 * Licensed under the CREATIVE COMMONS Attribution-Noncommercial-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Please visit http://www.onyx-vj.com for more information
 * 
 */
package onyx.plugin {

	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.geom.*;
	import flash.utils.*;
	

	import onyx.parameter.*;
	import onyx.core.*;
	import onyx.events.TransitionEvent;
	import onyx.tween.easing.Linear;
	
	use namespace onyx_ns;
	
	/**
	 * 	Transition is a plug-in that is executed when a layer is loaded over another layer.
	 */
	public class Transition extends PluginBase implements IParameterObject {
		
		/**
		 * 	@private
		 * 	Stores duration of the transition
		 */
		onyx_ns var _duration:int	= 0;
		
		/**
		 * 	@constructor
		 */
		public function Transition():void {
			
			parameters.addParameters(
				new ParameterInteger('duration', 'duration', 0, 5000, 2000)
			);
			
		}
		
		/**
		 * 	Renders content onto the source bitmap
		 */
		public function render(source:BitmapData, channelA:BitmapData, channelB:BitmapData, ratio:Number):void {
			
			const transform:ColorTransform = new ColorTransform(1, 1, 1, 1 - ratio);
			source.draw(channelA, null, transform);
			transform.alphaMultiplier = ratio;
			source.draw(channelB, null, transform)

		}
		
		/**
		 * 	Sets duration
		 */		
		final public function set duration(value:int):void {
			_duration = value;
		}
		
		/**
		 * 	Gets duration
		 */
		final public function get duration():int {
			return _duration;
		}
		
		/**
		 * 
		 */
		final override public function toString():String {
			var rt:String;
			if (_plugin) rt=_plugin.name;
			return 'onyx-transition://' + rt;
		}
	}
}