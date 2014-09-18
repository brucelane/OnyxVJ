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
	import flash.events.*;
	import flash.utils.*;

	import onyx.core.*;
	import onyx.display.*;
	import onyx.parameter.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	The base Filter class
	 */
	public class Filter extends PluginBase {
		
		/**
		 * 	Returns a content's filters that match a type
		 * 	(i.e) passing in type of BlurFilter will return all blurfilters in another layer
		 */
		public static function getFilters(content:Content, plugin:Plugin):Array {
			var filters:Array = content.filters;
			var matches:Array = [];
			
			for each (var filter:Filter in filters) {
				if (filter is plugin.definition) {
					matches = matches;
					matches.push(filter);
				}
			}
			
			return matches;
		}

		/**
		 * 	Stores the layer
		 */
		protected var content:Content;
		
		/**
		 * 	@private
		 * 	Stores whether the filter is unique or not
		 */
		onyx_ns var _unique:Boolean		= false;
		
		/**
		 * 	@private
		 * 	Whether the filter is muted
		 */
		onyx_ns var _muted:Boolean;
		
		/**
		 * 
		 */
		final protected function get unique():Boolean {
			return _unique;
		}
		
		/**
		 * 
		 */
		final protected function set unique(value:Boolean):void {
			_unique = value;
		}
		
		/**
		 * 
		 */
		public function set muted(value:Boolean):void {
			content.muteFilter(this, value);
		}
		
		/**
		 * 	Returns whether it is muted
		 */
		final public function get muted():Boolean {
			return _muted;
		}
		
		/**
		 * 	Gets the index of the filter
		 */
		final public function get index():int {
			return content.getFilterIndex(this);
		}
		
		/**
		 * 
		 */
		final public function getParameterValue(name:String):* {
			const control:Parameter = parameters.getParameter(name);
			return control ? control.value : null;
		}
		
		/**
		 * 
		 */
		final public function setParameterValue(name:String, value:*):void {
			const control:Parameter = parameters.getParameter(name);
			if (control) {
				control.value = value;
			}
		}

		/**
		 * 	@private
		 *	Called by layer when a filter is added to it
		 */
		onyx_ns final function setContent(content:Content):void {
			this.content	= content;
		}
		
		/**
		 * 	@private
		 *	Called by layer when a filter is added to it
		 */
		onyx_ns final function getContent():Content {
			return content;
		}
				
		/**
		 * 	Moves the filter up
		 */
		final public function moveFilter(index:int):void {
			content.moveFilter(this, index);
		}
		
		/**
		 * 	Removes the filter
		 */
		final public function removeFilter():void {
			content.removeFilter(this);
		}
		
		/**
		 * 	Returns xml
		 */
		final public function toXML():XML {
			var xml:XML = <filter id={name} muted="{muted}" />;
			xml.appendChild(super.parameters.toXML());
			return xml;
		}
		
		/**
		 * 
		 */
		final override public function toString():String {
			return 'onyx-filter://' + (_plugin ? _plugin.name : getQualifiedClassName(this));
		}

	}
}