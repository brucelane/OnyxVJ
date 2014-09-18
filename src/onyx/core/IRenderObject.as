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
package onyx.core {
	
	/**
	 * 	Interface that defines a plugin or external swf that enables it to render itself,
	 * 	rather than be rendered by Onyx directly
	 */
	public interface IRenderObject extends IDisposable {
		
		function render(info:RenderInfo):void;
		
	}
}