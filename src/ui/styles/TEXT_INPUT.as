/**
 * Copyright (c) 2003-2010 "Onyx-VJ Team" which is comprised of:
 *
 * Daniel Hai
 * Stefano Cottafavi
 * Bruce Lane
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
package ui.styles {
	
	import flash.text.TextFormat;
	
	import onyx.asset.*;
	import onyx.core.Console;
	
	public const TEXT_INPUT:TextFormat = new TextFormat(new AssetInputFont().fontName, 7, 0xe4eaef);
	
	TEXT_INPUT.leading		= 3;
	
}