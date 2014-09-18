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
package ui.assets {
	
	import flash.display.*;

	[Embed(source='/../assets/img/crossfader_background.png')]
	public final class AssetCrossFaderBG extends Bitmap {

		public function AssetCrossFaderBG():void {
			super(null, PixelSnapping.ALWAYS, false);
		}

	}
}