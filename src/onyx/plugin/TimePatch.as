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
	
	import onyx.core.IRenderObject;
	import onyx.core.RenderInfo;
	import onyx.parameter.*;
	
	[SWF(width='320', height='240', frameRate='24')]
	public class TimePatch extends Sprite implements IParameterObject, IRenderObject {
		
		/**
		 * 	@private
		 */
		protected const parameters:Parameters	= new Parameters(this as IParameterObject);
		
		/**
		 * 
		 */
		final public function getParameters():Parameters {
			return parameters;
		}
		
		/**
		 * 
		 */
		public function render(info:RenderInfo):void {
			
		}
		
		/**
		 * 
		 */
		public function get totalFrames():int {
			return 1;
		}
		
		/**
		 * 
		 */
		public function dispose():void {
			
		}
	}
}