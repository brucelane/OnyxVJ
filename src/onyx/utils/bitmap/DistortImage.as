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
package onyx.utils.bitmap {
    
    import flash.display.*;
    import flash.geom.*;
    
    
    /**
     * Tesselates an area into several triangles to allow free transform distortion on BitmapData objects.
     * 
     * @author        Thomas Pfeiffer (aka kiroukou)
     *                 kiroukou@gmail.com
     *                 www.flashsandy.org
     * @author        Ruben Swieringa
     *                 ruben.swieringa@gmail.com
     *                 www.rubenswieringa.com
     *                 www.rubenswieringa.com/blog
     * @version        1.1.0
     * 
     * 
     * edit 2
     * 
     * The original Actionscript2.0 version of the class was written by Thomas Pfeiffer (aka kiroukou),
     *   inspired by Andre Michelle (andre-michelle.com).
     *   Ruben Swieringa rewrote Thomas Pfeiffer's class in Actionscript3.0, making some minor changes/additions.
     * 
     * 
     * Copyright (c) 2005 Thomas PFEIFFER. All rights reserved.
     * 
     * Licensed under the CREATIVE COMMONS Attribution-NonCommercial-ShareAlike 2.0 you may not use this
     *   file except in compliance with the License. You may obtain a copy of the License at:
     *   http://creativecommons.org/licenses/by-nc-sa/2.0/fr/deed.en_GB
     * 
     */
    internal class DistortImage {
        
        
        // skew and translation matrix:
        /**
         * @private
         */
        protected const sMat:Matrix	= new Matrix();
        protected const tMat:Matrix	= new Matrix();
        /**
         * @private
         */
        protected var _xMin:Number, _xMax:Number, _yMin:Number, _yMax:Number;
        /**
         * @private
         */
        protected var _hseg:uint, _vseg:uint;
        /**
         * @private
         */
        protected var _hsLen:Number, _vsLen:Number;
        /**
         * @private
         */
        protected var _p:Array;
        /**
         * @private
         */
        protected var _tri:Array;
        
        // internals for accessors:
        /**
         * @private
         */
        protected var _w:Number, _h:Number;
        
        
        /**
         * Constructor.
         * 
         * @param    w        Width of the image to be processed
         * @param    h        Height of image to be processed
         * @param    hseg    Horizontal precision
         * @param    vseg    Vertical precision
         * 
         */
        public function DistortImage   (w:Number,
                                        h:Number,
                                        hseg:uint=0,
                                        vseg:uint=0):void {
            _w = w;
            _h = h;
            _vseg = vseg;
            _hseg = hseg;
            __init();
        }
        
        
        /**
         * Tesselates the area into triangles.
         * 
         * @private
         */
        protected function __init():void {
            _p = new Array();
            _tri = new Array();
            var ix: Number;
            var iy: Number;
            var w2: Number = _w / 2;
            var h2: Number = _h / 2;
            _xMin = _yMin = 0;
            _xMax = _w; _yMax = _h;
            _hsLen = _w / ( _hseg + 1 );
            _vsLen = _h / ( _vseg + 1 );
            var x: Number, y: Number;
            // create points:
            for ( ix = 0 ; ix <_vseg + 2 ; ix++ ){
                for ( iy = 0 ; iy <_hseg + 2 ; iy++ ){
                    x = ix * _hsLen;
                    y = iy * _vsLen;
                    _p.push( new DP( x, y, x, y) );
                }
            }
            // create triangles:
            for ( ix = 0 ; ix <_vseg + 1 ; ix++ ){
                for ( iy = 0 ; iy <_hseg + 1 ; iy++ ){
                    _tri.push([ _p[ iy + ix * ( _hseg + 2 ) ] , _p[ iy + ix * ( _hseg + 2 ) + 1 ] , _p[ iy + ( ix + 1 ) * ( _hseg + 2 ) ] ] );
                    _tri.push([ _p[ iy + ( ix + 1 ) * ( _hseg + 2 ) + 1 ] , _p[ iy + ( ix + 1 ) * ( _hseg + 2 ) ] , _p[ iy + ix * ( _hseg + 2 ) + 1 ] ] );
                }
            }
        }
        
        
        /**
         * Distorts the provided BitmapData according to the provided Point instances and draws it onto the provided Graphics.
         * 
         * @param    graphics    Graphics on which to draw the distorted BitmapData
         * @param    bmd            The undistorted BitmapData
         * @param    tl            Point specifying the coordinates of the top-left corner of the distortion
         * @param    tr            Point specifying the coordinates of the top-right corner of the distortion
         * @param    br            Point specifying the coordinates of the bottom-right corner of the distortion
         * @param    bl            Point specifying the coordinates of the bottom-left corner of the distortion
         * 
         */
        public function setTransform   (graphics:Graphics,
                                        bmd:BitmapData, 
                                        tl:Point, 
                                        tr:Point, 
                                        br:Point, 
                                        bl:Point):void {
                                        	
			graphics.clear();
                                        	
            var dx30:Number = bl.x - tl.x;
            var dy30:Number = bl.y - tl.y;
            var dx21:Number = br.x - tr.x;
            var dy21:Number = br.y - tr.y;
            var l:Number = _p.length;
            while( --l> -1 ){
                var point:DP = _p[ l ];
                var gx:Number = ( point.x - _xMin ) / _w;
                var gy:Number = ( point.y - _yMin ) / _h;
                var bx:Number = tl.x + gy * ( dx30 );
                var by:Number = tl.y + gy * ( dy30 );
                point.sx = bx + gx * ( ( tr.x + gy * ( dx21 ) ) - bx );
                point.sy = by + gx * ( ( tr.y + gy * ( dy21 ) ) - by );
            }
            __render(graphics, bmd);
        }
        
        
        /**
         * Distorts the provided BitmapData and draws it onto the provided Graphics.
         * 
         * @param    graphics    Graphics
         * @param    bmd            BitmapData
         * 
         * @private
         */
        protected function __render(graphics:Graphics, bmd:BitmapData):void {
            var t: Number;
            var vertices: Array;
            var p0:DP, p1:DP, p2:DP;
            var a:Array;
            sMat.identity();
            tMat.identity();
            var l:Number = _tri.length;
            while( --l> -1 ){
                a = _tri[ l ];
                p0 = a[0];
                p1 = a[1];
                p2 = a[2];
                var x0: Number = p0.sx;
                var y0: Number = p0.sy;
                var x1: Number = p1.sx;
                var y1: Number = p1.sy;
                var x2: Number = p2.sx;
                var y2: Number = p2.sy;
                var u0: Number = p0.x;
                var v0: Number = p0.y;
                var u1: Number = p1.x;
                var v1: Number = p1.y;
                var u2: Number = p2.x;
                var v2: Number = p2.y;
                tMat.tx = u0;
                tMat.ty = v0;
                tMat.a = ( u1 - u0 ) / _w;
                tMat.b = ( v1 - v0 ) / _w;
                tMat.c = ( u2 - u0 ) / _h;
                tMat.d = ( v2 - v0 ) / _h;
                sMat.a = ( x1 - x0 ) / _w;
                sMat.b = ( y1 - y0 ) / _w;
                sMat.c = ( x2 - x0 ) / _h;
                sMat.d = ( y2 - y0 ) / _h;
                sMat.tx = x0;
                sMat.ty = y0;
                tMat.invert();
                tMat.concat( sMat );
                // draw:
                graphics.beginBitmapFill( bmd, tMat, false, true);
                graphics.moveTo( x0, y0 );
                graphics.lineTo( x1, y1 );
                graphics.lineTo( x2, y2 );
                graphics.endFill();
            }
        }
        
        
        /**
         * Sets the size of this DistortImage instance and re-initializes the triangular grid.
         * 
         * @param    width    New width.
         * @param    height    New height.
         * 
         * @see    DistortImage#width
         * @see    DistortImage#height
         * 
         */
        public function setSize (width:Number, height:Number):void {
            this._w = width;
            this._h = height;
            this.__init();
        }
        
        
        /**
         * Sets the precision of this DistortImage instance and re-initializes the triangular grid.
         * 
         * @param    horizontal    New horizontal precision.
         * @param    vertical    New vertical precision.
         * 
         * @see    DistortImage#hPrecision
         * @see    DistortImage#vPrecision
         * 
         */
        public function setPrecision (horizontal:Number, vertical:Number):void {
            this._hseg = horizontal;
            this._vseg = vertical;
            this.__init();
        }
        
        
        /**
         * Width of this DistortImage instance. Property can only be set through the class constructor.
         * @see    DistortImage#setSize()
         */
        public function get width ():Number {
            return _w;
        }
        /**
         * Height of this DistortImage instance. Property can only be set through the class constructor.
         * @see    DistortImage#setSize()
         */
        public function get height ():Number {
            return _h;
        }
        
        
        /**
         * Horizontal precision of this DistortImage instance. Property can only be set through the class constructor.
         * @see    DistortImage#setPrecision()
         */
        public function get hPrecision ():uint {
            return _hseg;
        }
        /**
         * Vertical precision of this DistortImage instance. Property can only be set through the class constructor.
         * @see    DistortImage#setPrecision()
         */
        public function get vPrecision ():uint {
            return _vseg;
        }
    }
}

final class DP {
	public var x:Number;
	public var y:Number;
	public var sx:Number;
	public var sy:Number;
	
	public function DP(x:Number, y:Number, sx:Number, sy:Number):void {
		this.x = x;
		this.y = y;
		this.sx = sx;
		this.sy = sy;
	}
}