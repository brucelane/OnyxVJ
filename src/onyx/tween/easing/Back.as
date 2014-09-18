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
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package onyx.tween.easing
{

/**
 *  The Back class defines three easing functions to implement 
 *  motion with Flex effect classes. 
 *
 *  For more information, see http://www.robertpenner.com/profmx.
 */  
final public class Back {
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
    /**
     *  The <code>easeIn()</code> method starts 
     *  the motion by backtracking, 
     *  then reversing direction and moving toward the target.
	 *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
	 *
	 *  @param s Specifies the amount of overshoot, where the higher the value, 
	 *  the greater the overshoot.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeIn(t:Number, b:Number, c:Number,
								  d:Number, s:Number = 0):Number
	{
		if (!s)
			s = 1.70158;
		
		return c * (t /= d) * t * ((s + 1) * t - s) + b;
	}

    /**
     *  The <code>easeOut()</code> method starts the motion by
     *  moving towards the target, overshooting it slightly, 
     *  and then reversing direction back toward the target.
	 *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
	 *
	 *  @param s Specifies the amount of overshoot, where the higher the value, 
	 *  the greater the overshoot.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeOut(t:Number, b:Number, c:Number,
								   d:Number, s:Number = 0):Number
	{
		if (!s)
			s = 1.70158;
		
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
	}

    /**
     *  The <code>easeInOut()</code> method combines the motion
	 *  of the <code>easeIn()</code> and <code>easeOut()</code> methods
	 *  to start the motion by backtracking, then reversing direction and 
	 *  moving toward target, overshooting target slightly, reversing direction again, and 
	 *  then moving back toward the target.
	 *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
	 *
	 *  @param s Specifies the amount of overshoot, where the higher the value, 
	 *  the greater the overshoot.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeInOut(t:Number, b:Number, c:Number,
									 d:Number, s:Number = 0):Number
	{
		if (!s)
			s = 1.70158; 
		
		if ((t /= d >> 1) < 1)
			return c >> 1 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
		
		return c >> 1 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
	}
}

}
