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
	
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.*;
	
	import onyx.parameter.*;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Core Spectrum Analysis class.  Use this class instead of Sound.computeSpectrum().  This class will cache results
	 * 	of the Sound.computeSpectrum per frame, as well as normal results in an easy-to-use Array.
	 */
	public class SpectrumAnalyzer {

		/**
		 * 	@private
		 */
		private static function _init():void {
			for (var count:int = 0; count < SPECTRUM_LENGTH; count++) {
				BASE_ANALYSIS[count] = 0;
			}
		}
		
		_init();
		
		/**
		 * 	@private
		 */
		public static const SPECTRUM_LENGTH:int		= 255;

		/**
		 * 	@private
		 */
		private static const BASE_ANALYSIS:Array		= new Array(SPECTRUM_LENGTH);

		/**
		 * 	@private
		 */
		private static const MAX_PRIORITY:int			= int.MAX_VALUE;
		
		/**
		 * 	@private
		 */
		private static const bytes:ByteArray			= new ByteArray();
				
		/**
		 * 	@private
		 */
		private static var _spectrum:Array;
		
		private static var _leftPeak:Number = 0.1;
		private static var _rightPeak:Number = 0.1;
		
		/**
		 * 	Gets the spectrum analysis
		 */
		public static function getSpectrum(useFFT:Boolean = false):Array {
			
			var i:Number, array:Array;
			// clear next frame
			DISPLAY_STAGE.addEventListener(Event.ENTER_FRAME, _clearSpectrum, false, MAX_PRIORITY);

			// check for already computed spectrum for this frame
			if (!_spectrum) {
				
				leftPeak = 0;
				rightPeak = 0;
				i		= SPECTRUM_LENGTH + 1;
				array	= BASE_ANALYSIS.concat();
				
				// compute
				SoundMixer.computeSpectrum(bytes, useFFT);
				
				// right
				while ( --i > SPECTRUM_LENGTH/2 ) {
					
					// move the pointer
					bytes.position = i * 8;
					
					// get amplitude value
					array[i % SPECTRUM_LENGTH] += (bytes.readFloat() / 2);
					if ( array[i % SPECTRUM_LENGTH] > rightPeak ) rightPeak = array[i % SPECTRUM_LENGTH];
					//Console.output(array[i % SPECTRUM_LENGTH],rightPeak);
				}
				// left
				while ( --i > -1 ) {
					
					// move the pointer
					bytes.position = i * 8;
					
					// get amplitude value
					array[i % SPECTRUM_LENGTH] += (bytes.readFloat() / 2);
					if ( array[i % SPECTRUM_LENGTH] > leftPeak ) leftPeak = array[i % SPECTRUM_LENGTH];
				}
				
				_spectrum = array;
			}
			
			return _spectrum;
		}
		
		/**
		 * 	@private
		 * 	Clears the spectrum
		 */
		private static function _clearSpectrum(event:Event):void {

			// clear the listener
			DISPLAY_STAGE.removeEventListener(Event.ENTER_FRAME, _clearSpectrum, false);
			
			// clear the spectrum
			_spectrum	= null;
		}
		public static function get leftPeak():Number
		{
			return _leftPeak;
		}
		
		public static function set leftPeak(value:Number):void
		{
			_leftPeak = value;
		}
		
		public static function get rightPeak():Number
		{
			return _rightPeak;
		}
		
		public static function set rightPeak(value:Number):void
		{
			_rightPeak = value;
		}
	}
}