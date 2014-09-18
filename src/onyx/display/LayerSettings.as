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
	
	import flash.events.EventDispatcher;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	This class stores settings that can be applied to layers
	 */
	public class LayerSettings {

		public var x:int				= 0;
		public var y:int				= 0;
		public var anchorX:Number		= 0.5;
		public var anchorY:Number		= 0.5;
		public var scaleX:Number		= 1;
		public var scaleY:Number		= 1;
		public var rotation:int			= 0;
		
		public var brightness:Number	= 0;
		public var contrast:Number		= 0;
		public var saturation:Number	= 1;
		public var hue:Number			= 0;

		public var alpha:Number			= 1;
		public var blendMode:String		= 'normal';
		public var visible:Boolean		= true;
		public var channel:Boolean		= false;
		
		public var time:Number			= 0;
		public var framerate:Number		= 1;

		public var filters:Array;
		public var parameters:Object;
		public var properties:XML;

		public var loopStart:Number		= 0;
		public var loopEnd:Number		= 1;
		public var path:String;
		
		/**
		 * 	Gets variables from a layer
		 */
		public function load(content:Content):void {
			
			x			= content.x,
			y			= content.y,
			scaleX		= content.scaleX,
			scaleY		= content.scaleY,
			rotation	= content.rotation,
			alpha		= content.alpha,
			brightness	= content.brightness,
			contrast	= content.contrast,
			saturation	= content.saturation,
			hue			= content.hue,
			blendMode	= content.blendMode,
			time		= content.time,
			framerate	= content.framerate,
			loopStart	= content.loopStart,
			loopEnd		= content.loopEnd,
			visible		= content.visible,
			//channel		= content.channel,
			path		= content.path;
			filters		= [];
			
			for each (var filter:Filter in content.filters) {
				filters.push(filter.clone());	
			}
			
			parameters = content.getParameters();
		}
		
		/**
		 * 	Loads settings info from xml
		 */
		public function loadFromXML(xml:XML):void {
			
			const propXML:XMLList = xml.properties;
			
			var value:String;
			
			for each (var list:XML in propXML.*) {
				if (!list.hasComplexContent()) {
					try { 
						var name:String = list.name();
						value			= list.toString();
						
						switch (name) {
							case 'visible':
								visible = (value === 'true')
								break;
							default:
								this[name]	= value;        
								break;
						}
					} catch (e:Error) {
						Console.error(e);
					}
				} else {
					for each (var child:XML in list.*) {
						try {
							 
							name		= child.name();
							this[name]	= String(child);
																								
						} catch (e:Error) {
							Console.error(e);
						}
					}
				}
			}
			
			path		= xml.@path;
			
			if (xml.parameters) { 
				parameters = xml.parameters;
			}
			            
			// TBD: needs to be cleaned up
			if (xml.filters) {
				
				filters = new FilterArray(null);
				filters.loadXML(xml.filters);
			}
		}
		
		/**
		 * 	Applies values to a layer
		 */
		public function apply(content:Content):void {
			
			var targetControl:Parameter;
			
			content.x			= x,
			content.y			= y,
			content.scaleX		= scaleX,
			content.scaleY		= scaleY,
			content.rotation	= rotation,
			content.anchorX		= anchorX,
			content.anchorY		= anchorY,
		    content.alpha		= alpha,
			content.brightness	= brightness,
			content.contrast	= contrast,
			content.saturation	= saturation,
			content.hue			= hue,
			content.blendMode	= blendMode,
			content.framerate	= framerate,
			content.loopStart	= loopStart,
			content.loopEnd		= loopEnd,
			content.time		= time,
			content.visible		= visible;
			//content.channel		= channel;
						
			// clone filters
			for each (var filter:Filter in this.filters) {
				content.addFilter(filter);
			}
			            
			// apply parameters
			if (parameters && content.getParameters()) {
								
				// check what type of object "parameters" is
				// type: parameters, set value to value
				// type: XML, parse the xml values
				
				// it's a control object
				if (parameters is Parameters) {
					for each (var control:Parameter in parameters) {
						if (control) {
							try {
								targetControl = content.getParameters().getParameter(control.name);
								if ( ! (targetControl is ParameterExecuteFunction) ) {
									targetControl.value = control.value;
								}
							} catch (e:Error) {
								Console.output('error setting property', control.name, e.message);
							}
						}
					}
					
				// it's xml
				} else {
					
					
					const xml:XMLList = parameters as XMLList;
					for each (var node:XML in xml.*) {
						try {
							var name:String = node.name();
							targetControl = content.getParameters().getParameter(name);
							targetControl.loadXML(node);
							
						} catch (e:Error) {
							Console.output('error setting property', name, e.message);
						}
					}
				}
				            
			}
		}
		        
	}
}