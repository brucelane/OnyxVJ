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
package onyx.display {
	
	import flash.geom.ColorTransform;
	
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;

	/**
	 * 	Color transformation and saturation matrix
	 */	
	public final class ColorFilter extends ColorTransform {
		
		/**
		 * 	@private
		 */
		onyx_ns var _color:uint						= 0;
		
		/**
		 * 	@private
		 */
		onyx_ns var _tint:Number					= 0;

		/**
		 * 	Tint
		 */
		public function set tint(value:Number):void {		
			
			_tint = value;
			
			const r:int = ((_color & 0xFF0000) >> 16) * value;
			const g:int = ((_color & 0x00FF00) >> 8) * value;
			const b:int = (_color & 0x0000FF) * value;

			const amount:Number = 1 - value;
			
			super.blueMultiplier = super.redMultiplier = super.greenMultiplier = amount,
			super.redOffset		= r,
			super.greenOffset	= g,
			super.blueOffset	= b;
			
		}

		/**
		 * 
		 */
		public function get tint():Number {
			return _tint;
		}
		
		/**
		 * 	Sets color
		 */
		override public function set color(value:uint):void {
			
			_color	= value;
			
			const r:int = ((value & 0xFF0000) >> 16) * _tint;
			const g:int  = ((value & 0x00FF00) >> 8) * _tint;
			const b:int  = (value & 0x0000FF) * _tint;

			const amount:Number = 1 - _tint;
			
			super.blueMultiplier = super.redMultiplier = super.greenMultiplier = amount,
			super.redOffset		= r,
			super.greenOffset	= g,
			super.blueOffset	= b;
		}
		
		/**
		 * 	Gets color
		 */
		override public function get color():uint {
			return _color;
		}

	}
}