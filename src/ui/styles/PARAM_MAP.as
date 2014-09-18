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
package ui.styles {
	
	import flash.utils.*;
	
	import onyx.parameter.*;
	import onyx.core.*;
	
	import ui.controls.*;
	import ui.controls.layer.*;
	import ui.text.*;

	public const PARAM_MAP:Object = {};
	
	PARAM_MAP[ParameterBoolean]				= ButtonControl;
	PARAM_MAP[ParameterColor]				= ColorPicker;
	PARAM_MAP[ParameterDirectory]			= DropDown;
	PARAM_MAP[ParameterExecuteFunction]		= ButtonControl;
	PARAM_MAP[ParameterFrameRate]			= SliderVFrameRate;
	PARAM_MAP[ParameterInteger]				= SliderV;
	PARAM_MAP[ParameterLayer]				= DropDown;
	PARAM_MAP[ParameterNumber]				= SliderV;
	PARAM_MAP[ParameterPlugin]				= DropDown;
	PARAM_MAP[ParameterProxy]				= SliderV2;
	PARAM_MAP[ParameterArray]				= DropDown;
	PARAM_MAP[ParameterString]				= TextControl;
	PARAM_MAP[ParameterTempo]				= DropDown;
	PARAM_MAP[ParameterUINT]				= SliderV;
	PARAM_MAP[ParameterStatus]				= Status;

}