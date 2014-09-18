/**
 * Copyright (c) 2003-2011 "Onyx-VJ Team" which is comprised of:
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
package onyx.asset {
	
	import flash.text.Font;
	import flash.text.TextFormat;
	
	[Embed(
			source='../../../assets/Pixel.ttf',
			fontName='DefaultFont',
			advancedAntiAliasing='false',
			mimeType='application/x-font',
			embedAsCFF='false',
			unicodeRange='U+0020-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007F')
	]
	public final class AssetPixelFont extends Font 
	{
	}
}