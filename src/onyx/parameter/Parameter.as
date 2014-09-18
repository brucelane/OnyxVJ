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
package onyx.parameter {

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import onyx.core.*;
	import onyx.events.ParameterEvent;
		
	use namespace onyx_ns;
	
	[Event(name='change', type='onyx.events.ParameterEvent')]
	/**
	 *	Base control class.  This class is used in all objects that have user-defined parameters.
	 * 	For each control, a user editable control will display on-screen.  These controls will also
	 * 	save into "mix" files or presets for filters, transitions, etc. Do not instantiate this class directly.
	 * 
	 * 	@see onyx.controls.Controls
	 * 
	 * 	@example 
	 * 
	 * 	<code>
	 * 	public class SomeFilter extends IParameterObject {
	 * 
	 * 		public var value:int			= 10;
	 * 
	 * 		private var parameters:Parameter
	 * 
	 * 		// constructor
	 *  	public function SomeFilter():void {
	 * 			parameters = new Parameters(this,
	 * 				new ParameterInteger(
	 * 					'value',
	 * 					'display value',
	 * 					0,					-- minimum value
	 * 					100,				-- maximum value
	 * 					20					-- default value to assume when user double-clicks a control
	 * 				)
	 * 			)
	 *  	}
	 *	}
	 * 	</code>
	 */
	public class Parameter extends EventDispatcher {
		
		/**
		 * 
		 */
		protected static const REUSABLE_EVENT:ParameterEvent = new ParameterEvent();

		/**
		 * 	@private
		 * 	The target object for the control
		 */
		onyx_ns var _target:IParameterObject;
		
		/**
		 * 	@internal
		 * 	The parent control object
		 */
		public var parent:Parameters;

		/**
		 * 	stores the display name
		 */
		public var display:String;

		/**
		 * 	name of the property to affect
		 */
		public var name:String;
		
		/**
		 * 	Stores the default value for the control
		 */
		public var defaultValue:*;
		
		/**
		 * 	Stores objects added from external
		 */
		private const metadata:Dictionary = new Dictionary(true);
		
		/**
		 * @constructor
		 */
		public function Parameter(name:String, display:String, defaultValue:*):void {
			
			this.name			= name,
			this.display		= display || name,
			this.defaultValue	= defaultValue;      
			
		}
		
		/**
		 *  allow to add spare objects to control, from external
		 *  (ex. add MIDI hash map)
		 **/
		final public function setMetaData(name:String, ext:Object):void {
			metadata[name] = ext;
		}
		
		final public function getMetaData(name:String):Object {
			return metadata[name];
		}
		
		/**
		 *	Returns target value
		 */
		public function get value():* {
			return _target[name];
		}
		
		/**
		 * 	Returns the contrained value.  Use this function on a property when you
		 * 	want an object to dispatch a controlevent when changing of the property occurs:
		 * 
		 * 	For instance:
		 * 
		 * 	<code>
		 * 	public function set alpha(value:Number):void {
		 * 		super.alpha = _dispatch(value);
		 * 	}
		 * 	</code>
		 * 
		 * 	This will dispatch an event to the control and update the UI.
		 * 	
		 */
		public function dispatch(v:*):* {
			
			REUSABLE_EVENT.value = v;
			super.dispatchEvent(REUSABLE_EVENT);
			
			return v;
		}
		
		/**
		 * 	Sets the value to the target
		 */
		public function set value(v:*):void {
			_target[name] = dispatch(v);
		}
		
		/**
		 * 	Resets the control
		 */
		public function reset():void {
			_target[name] = REUSABLE_EVENT.value = defaultValue;
			dispatchEvent(REUSABLE_EVENT);
		}

		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		public function reflect():Class {
			return Parameter;
		}
		
		/**
		 * 	Loads the value from xml
		 */
		public function loadXML(xml:XML):void {
			target[name] = xml;
		}
		
		/**
		 * 
		 */
		public function updateListeners():void {
			REUSABLE_EVENT.value	= _target[name];
			dispatchEvent(REUSABLE_EVENT);
		}
		
		/**
		 * 	Returns xml representation of the control
		 */
		public function toXML():XML {
			
			const xml:XML = <{name}/>;
						
			const value:Object = _target[name];
			xml.appendChild((value) ? value.toString() : value);
						
			return xml;
		}
		
		
		/**
		 * 	Changes the target to another object
		 */
		public function set target(value:IParameterObject):void {
			_target = value;
		}
		
		public function get target():IParameterObject {
			return _target;
		}
		
		/**
		 * 
		 */
		override public function toString():String {
			return '[' + getQualifiedClassName(this).replace('onyx.parameter::', '') + ': ' + this.name + ']';
		}
		
		/**
		 * 
		 */
		public function clone():Parameter {
			return null;
		}
	}
}