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
package ui.core {
	
	import flash.display.DisplayObject;
	import flash.geom.*;

	/**
	 * 	Transforms multiple objects
	 */
	public final class MultiTransform extends Transform {
		
		/**
		 * 	@private
		 */
		private var _targets:Array;
		
		/**
		 * 	@constructor
		 */
		public function MultiTransform(obj:DisplayObject, ... targets:Array):void {
			super(obj);
			_targets = targets;
		}
		
		/**
		 * 	Override setting the colortransform to the objects
		 */
		override public function set colorTransform(value:ColorTransform):void {
			for each (var object:DisplayObject in _targets) {
				object.transform.colorTransform = value;
			}
		}
	
	}
}