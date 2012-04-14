package com.allofus.shared.util
{
	import flash.filters.GlowFilter;	
	import flash.filters.BlurFilter;	
	import flash.filters.BitmapFilterQuality;	
	import flash.filters.DropShadowFilter;	
	import flash.filters.BitmapFilter;	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;	

	/**
	 * @author shaneseward
	 * @author protasewiczm
	 * @author jc
	 * 
	 * Static drawing methods
	 */
	public class DrawUtils 
	{
		/******************************************************************
		 * STATIC UTIL METHODS
		 *******************************************************************/
		
		/** 
		 * Draw basic rectangle
		 * 
		 * @param rect - Rectangle of box
		 * @param fillC - colour of fill [optional]
		 * @param lineC - colour of outline [optional]
		 * @param lineW - outline thickness [optional]
		 * @return shape
		 */
		public static function drawBox(rect : Rectangle, fillC : uint = undefined, lineC : uint = undefined, lineW : uint = undefined, alpha : Number = 1.0) : Sprite
		{
			var shp : Sprite = new Sprite();			
				shp.graphics.clear();
				if(lineW && lineC) shp.graphics.lineStyle(lineW, lineC, 1.0, true);
				if(fillC >= 0) shp.graphics.beginFill(fillC, alpha);
				shp.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				if(fillC >= 0) shp.graphics.endFill();
			return shp;
		}

		public static function drawGradientBox(type : String, width : Number, height : Number, colours : Array, alphas : Array, ratios : Array, rotation : Number) : Sprite
		{
			var shp : Sprite = new Sprite();
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(width, height, rotation * (Math.PI / 180));
				shp.graphics.clear();
				shp.graphics.beginGradientFill(type, colours, alphas, ratios, matrix);
				shp.graphics.drawRect(0, 0, width, height);
				shp.graphics.endFill();
			return shp;
		}

		public static function drawGradientCurveBox(rect : Rectangle, corner : uint, pos : String, type : String, colours : Array, alphas : Array, ratios : Array, rotation : Number) : Sprite
		{
			var shp : Sprite = new Sprite();
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(rect.width, rect.height, rotation * (Math.PI / 180));
			
			var points : Array = [];
			switch(pos) 
			{
				case 'all': 
					points = [1,-1,1,1,1,1,-1,1]; 
					break;
				case 'top':
					points = [1,-1,1,0,0,0,0,1];
					break;
				case 'bottom': 
					points = [0,0,0,1,1,1,-1,0];
					break;
			}		
				shp.graphics.clear();
				shp.graphics.beginGradientFill(type, colours, alphas, ratios, matrix);
				shp.graphics.moveTo(corner * points[0], 0);
				shp.graphics.lineTo(rect.width + (corner * points[1]), 0);
				shp.graphics.curveTo(rect.width, 0, rect.width, (corner * points[2]));
				shp.graphics.lineTo(rect.width, (rect.height - (corner * points[3])));
				shp.graphics.curveTo(rect.width, rect.height, rect.width - (corner * points[4]), rect.height);
				shp.graphics.lineTo(corner * points[5], rect.height);
				shp.graphics.curveTo(0, rect.height, 0, rect.height + corner * points[6]);
				shp.graphics.lineTo(0, corner * points[7]);
				shp.graphics.curveTo(0, 0, corner * points[0], 0);
				shp.graphics.endFill();
			return shp;
		}

		/**
		 * Draw flared curved box
		 * 
		 * @param rect - Rectangle of box (not including the flared corners)
		 * @param corner - corner radius
		 * @param pos - alignment position ('tl','tr','br','bl')
		 * @param fillC - colour of fill [optional]
		 * @param lineC - colour of outline [optional]
		 * @param lineW - outline thickness [optional]
		 * @return shape
		 */  
		public static function drawCurveBox(rect : Rectangle, corner : uint, pos : String, fillC : uint = undefined, lineC : uint = undefined, lineW : uint = undefined, fillAlpha : Number = 0, lineAlpha : Number = 1) : Sprite
		{
			var points : Array = [];
			switch(pos) 
			{
				case 'all': 
					points = [1,-1,1,1,1,1,-1,1]; 
					break;
				case 'top':
					points = [1,-1,1,0,0,0,0,1];
					break;
				case 'bottom': 
					points = [0, 0, 0, 1, 1, 1,-1, 0];
					break;
			}
			var shp : Sprite = new Sprite();		
				shp.graphics.clear();
				if(lineW && lineC) shp.graphics.lineStyle(lineW, lineC, lineAlpha, true);
				if(fillC)shp.graphics.beginFill(fillC, fillAlpha);
				shp.graphics.moveTo(corner * points[0], 0);
				shp.graphics.lineTo(rect.width + (corner * points[1]), 0);
				shp.graphics.curveTo(rect.width, 0, rect.width, (corner * points[2]));
				shp.graphics.lineTo(rect.width, (rect.height - (corner * points[3])));
				shp.graphics.curveTo(rect.width, rect.height, rect.width - (corner * points[4]), rect.height);
				shp.graphics.lineTo(corner * points[5], rect.height);
				shp.graphics.curveTo(0, rect.height, 0, rect.height + corner * points[6]);
				shp.graphics.lineTo(0, corner * points[7]);
				shp.graphics.curveTo(0, 0, corner * points[0], 0);
				if(fillC)shp.graphics.endFill();
			return shp;
		}

		/** 
		 * Draw angled wedge circle
		 * 
		 * @param startAngle - start position of wedge
		 * @param arc - end position of wedge
		 * @param radius - circle radius
		 * @param fillC - colour of fill [optional]
		 * @param lineC - colour of outline [optional]
		 * @param lineW - outline thickness [optional]
		 * @return shape 
		 */
		public static function drawWedge(startAngle : int, arc : uint, radius : uint, fillC : uint = undefined, lineC : uint = undefined, lineW : uint = undefined) : Shape
		{
			if (Math.abs(arc) > 360) arc = 360;
			var y : uint = radius;
			var x : uint = radius;
			var segs : Number = Math.ceil(Math.abs(arc) / 45);
			var segAngle : Number = arc / segs;
			var theta : Number = -(segAngle / 180) * Math.PI;
			var angle : Number = -(startAngle / 180) * Math.PI;
			var ax : Number = x + Math.cos(startAngle / 180 * Math.PI) * radius;
			var ay : Number = y + Math.sin(-startAngle / 180 * Math.PI) * radius;

			var shp : Shape = new Shape();			
				if(lineW && lineC) shp.graphics.lineStyle(lineW, lineC, 1.0, true);
				if(fillC) shp.graphics.beginFill(fillC);
				shp.graphics.moveTo(x, y);
				if (segs > 0) {				
					shp.graphics.lineTo(ax, ay);
					for (var i : uint = 0;i < segs; i++) 
					{
						angle += theta;
						var angleMid : Number = angle - (theta / 2);
						var bx : Number = x + Math.cos(angle) * radius;
						var by : Number = y + Math.sin(angle) * radius;
						var cx : Number = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
						var cy : Number = y + Math.sin(angleMid) * (radius / Math.cos(theta / 2));
						shp.graphics.curveTo(cx, cy, bx, by);
					}
					shp.graphics.lineTo(x, y);
				}
				if(fillC) shp.graphics.endFill();	
			return shp;
		}

		/**
		 * draw circle:
		 * TODO: add code to make an elipse out of circle e.g. xscale & yscale properties to stretch the circle
		 */
		public static function drawElipse(propObj : Object = null) : Shape 
		{
			// set default values:
			var properties : Object = {fillColor: 0x000000, radius: 100, x: 0, y: 0, alpha: 1.0};
			
			// set properties from propObj:
			if(propObj)
				for(var p : String in propObj)
					if(properties[p] != null && properties[p] != undefined)
						properties[p] = propObj[p];
			
			// create shape:
			var shp : Shape = new Shape();
			
			// draw elipse:
				shp.graphics.beginFill(properties['fillColor'], properties['alpha']);
				shp.graphics.drawCircle(properties['x'], properties['y'], properties['radius']);
				shp.graphics.endFill();
			// return drawn elipse:
			return shp;
		}

		public static function drawPolygon(radius : int, segments : int, fill : uint, lineW : int = 1, lineC : uint = 0xFFFFFF, rotating : Number = 0) : Sprite
		{
			var shp : Sprite = new Sprite();
			shp.graphics.beginFill(fill, 1.0);
			shp.graphics.lineStyle(lineW, lineC, 1.0, true);
			shp.graphics.moveTo(0, radius * 2 - (radius /2));
			
			var id : int = 0;
			var points : Array = [];
			var ratio : Number = 360 / segments;
			var top : Number = 0- (radius /2);
			for(var i : int = rotating;i <= 360 + rotating;i += ratio) {
				var xx : Number = Math.sin(radians(i)) * radius;
				var yy : Number = top + (radius - Math.cos(radians(i)) * radius);
				points[id] = new Array(xx, yy);
				if(id>=1)shp.graphics.lineTo(points[id][0], points[id][1]);
				id++;
			}
			id = 0;
			shp.graphics.endFill();
			return shp;
		}

		private static function radians(n : Number) : Number 
		{
			return(Math.PI / 180 * n);
		}

		public static function getDropShadow(color : uint, angle : Number, alpha : Number, 
											 blurX : Number, blurY : Number, distance : Number, 
											 strength : Number, inner : Boolean = false, 
											 knockout : Boolean = false, quality : String = "HIGH" ) : Array
		{
			var filter : BitmapFilter = new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, BitmapFilterQuality[quality], inner, knockout);
			var pFilter : Array = [];
			pFilter.push(filter);
           	
			return pFilter;
		}

		public static function getBlur(blurX : Number, blurY : Number, quality : String = "HIGH" ) : Array
		{
			var filter : BitmapFilter = new BlurFilter(blurX, blurY, BitmapFilterQuality[quality]);
			var pFilter : Array = [];
			pFilter.push(filter);
           	
			return pFilter;
		}

		public static function getGlow(color : uint, alpha : Number, blurX : Number, 
									   blurY : Number, strength : Number, 
									   quality : String = "HIGH" ,inner : Boolean = false, knockout : Boolean = false) : Array
		{
			var filter : BitmapFilter = new GlowFilter(color, alpha, blurX, blurY, strength, BitmapFilterQuality[quality], inner, knockout);
			var pFilter : Array = [];
			pFilter.push(filter);
           	
			return pFilter;
		}		

		public static function dashLine(g : Graphics,x1 : Number,y1 : Number,x2 : Number,y2 : Number,onLength : Number = 0,offLength : Number = 0) : void 
		{
			g.moveTo(x1, y1);
			if (offLength == 0) {
				g.lineTo(x2, y2);
				return;
			}

			var dx : Number = x2 - x1,
		   		dy : Number = y2 - y1,
		   		lineLen : Number = Math.sqrt(dx * dx + dy * dy),
		   		angle : Number = Math.atan2(dy, dx),
		    	cosAngle : Number = Math.cos(angle),
		    	sinAngle : Number = Math.sin(angle),
		    	ondx : Number = cosAngle * onLength,
		    	ondy : Number = sinAngle * onLength,
		    	offdx : Number = cosAngle * offLength,
		    	offdy : Number = sinAngle * offLength,

   			 	x : Number = x1,
    			y : Number = y1;


			var fullDashCountNumber : int = Math.floor(lineLen / (onLength + offLength));

			for (var i : int = 0;i < fullDashCountNumber; i++) 
			{
				g.lineTo(x += ondx, y += ondy);
				g.moveTo(x += offdx, y += offdy);
			}

			var remainder : Number = lineLen - ((onLength + offLength) * fullDashCountNumber);

			if (remainder >= onLength) {
				g.lineTo(x += ondx, y += ondy);
			} else {
				g.lineTo(x2, y2);
			}
		}
		
		public static function drawPointyBox(w:int, h:int, pointHeight:int, color:uint, alpha:Number = 1):Shape
		{
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			g.beginFill(color, alpha);
			g.lineTo(w, 0);
			g.lineTo(w, h);
			g.lineTo((w*0.5) + pointHeight, h);
			g.lineTo((w*0.5), h + pointHeight);
			g.lineTo((w*0.5) - pointHeight, h);
			g.lineTo(0, h);
			g.endFill();
			return s;
		}
	}
}