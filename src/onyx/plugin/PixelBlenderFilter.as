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
	import flash.filters.*;
	import flash.utils.*;
	
	import onyx.core.*;
	import onyx.parameter.*;
	
	use namespace onyx_ns;
	
	[ExcludeClass]
	
	/**
	 * 
	 */
	public final class PixelBlenderFilter extends Filter implements IBitmapFilter {
		
		/**
		 * 	@private
		 */
		private var filter:ShaderFilter;
		
		/**
		 * 
		 */
		override public function initialize():void {
			
			const bytes:ByteArray		= super._plugin.getData('bytes');
			const shader:Shader			= new Shader(bytes);
			
			const data:ShaderData		= shader.data;
			
			for (var key:String in data) {
				var param:ShaderParameter = data[key] as ShaderParameter;
				if (param) {
					
					switch (param.type) {
						case ShaderParameterType.FLOAT:
						case ShaderParameterType.INT:
						
							parameters.addParameters(new ParameterNumberShader(param));
							break;
							
						case ShaderParameterType.FLOAT2:
						case ShaderParameterType.INT2:
						
							parameters.addParameters(
								new ParameterProxy(
									param.name,
									param.name,
									new ParameterNumberShaderIndex0(param),
									new ParameterNumberShaderIndex1(param),
									true
								)
							)
						
							break;
						case ShaderParameterType.FLOAT3:
						case ShaderParameterType.INT3:
						
							if (String(param.name).toUpperCase().indexOf('COLOR')) {
								
								parameters.addParameters(new ParameterShaderColor(param));
								
							}
						
							break;

						case ShaderParameterType.FLOAT4:
						case ShaderParameterType.INT4:
						default:
						
							break;
					}
					
				}

			}
			
			filter = new ShaderFilter(shader);

		}
		
		/**
		 * 
		 */
		public function applyFilter(source:BitmapData):void {
			
			source.applyFilter(source, DISPLAY_RECT, ONYX_POINT_IDENTITY, filter);
			
		}
		
		/**
		 * 
		 */
		override public function dispose():void {
			
			filter = null;
			
		}
	}
}