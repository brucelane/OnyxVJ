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
package ui.macros {
	
	import flash.events.Event;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.plugin.*;
	import onyx.tween.*;
	
	[ExcludeClass]
	
	/**
	 * 
	 */
	public final class MuteLayer0 extends Macro {
		
		/**
		 * 	@private
		 */
		private static var index:int		= 0;

		/**
		 * 
		 */
		private var layer:Layer;
		private var tween:Tween;
		
		/**
		 * 
		 */
		override public function keyDown():void {
			layer = Display.getLayerAt(index);
			
			if (layer.visible) {
				tween = new Tween(
					layer,
					250,
					new TweenProperty('alpha', layer.alpha, 0)
				);
				tween.addEventListener(Event.COMPLETE, tweenFinish);
			} else {
				layer.visible = true;
				tween = new Tween(
					layer,
					250,
					new TweenProperty('alpha', 0, 1)
				);
			}
		}
		
		private function tweenFinish(event:Event):void {
			tween.removeEventListener(Event.COMPLETE, tweenFinish);
			layer = Display.getLayerAt(index);
			layer.visible = false;
		}
		
		/**
		 * 
		 */
		override public function keyUp():void {
			layer = null			
		}

	}
}