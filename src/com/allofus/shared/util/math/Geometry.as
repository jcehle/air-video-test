package com.allofus.shared.util.math
{
	import flash.geom.Point;
	/**
	 * Full details: http://gamedev.michaeljameswilliams.com/2009/04/24/angles-in-flash/
	 * Hungarian notation idea: http://www.joelonsoftware.com/articles/Wrong.html
	 * Optimisation credit: http://www.nbilyk.com/optimizing-actionscript-3
	 * 
	 * Usage:	import com.michaeljameswilliams.gamedev.angles.Angle
	 * 			var degAngle:Number = Angle.degFromRad( radAngle );
	 * 
	 * @author MichaelJWilliams
	 * @author jc
	 */
	public class Geometry
	{
		private static const localPi:Number = Math.PI;
		private static const localTwoPi:Number = Math.PI * 2;
		private static const oneOver180:Number = 1 / 180;
		private static const oneOverPi:Number = 1 / localPi;
		
		/**
		 * @param	p_degInput	Angle, in degrees
		 * @return	Angle, in degrees, in range 0 to 360
		 */
		public static function degFromDeg( p_degInput:Number ):Number
		{
			var degOutput:Number = p_degInput;
			while ( degOutput >= 360 )
			{
				degOutput -= 360;
			}
			while ( degOutput < 0 )
			{
				degOutput += 360;
			}
			return degOutput;
		}
		
		/**
		 * @param	p_rotInput	Angle, in degrees
		 * @return	Angle, in degrees, in range -180 to + 180
		 */
		public static function rotFromRot( p_rotInput:Number ):Number
		{
			var rotOutput:Number = p_rotInput;
			while ( rotOutput > 180 )
			{
				rotOutput -= 360;
			}
			while ( rotOutput < -180 )
			{
				rotOutput += 360;
			}
			return rotOutput;
		}
		
		/**
		 * @param	p_radInput	Angle, in radians
		 * @return	Angle, in radians, in range 0 to ( 2 * pi )
		 */
		public static function radFromRad( p_radInput:Number ):Number
		{
			var radOutput:Number = p_radInput;
			while ( radOutput >= localTwoPi )
			{
				radOutput -= localTwoPi;
			}
			while ( radOutput < -localTwoPi ) 
			{
				radOutput += localTwoPi;
			}
			return radOutput;
		}
		
		/**
		 * @param	p_degInput	Angle, in degrees
		 * @return	Angle, in degrees, in range -180 to +180
		 */
		public static function rotFromDeg( p_degInput:Number ):Number
		{
			var rotOutput:Number = p_degInput;
			while ( rotOutput > 180 )
			{
				rotOutput -= 360;
			}
			while ( rotOutput < -180 )
			{
				rotOutput += 360;
			}
			return rotOutput;
		}
		
		/**
		 * @param	p_rotInput	Angle, in degrees
		 * @return	Angle, in degrees, in range 0 to 360
		 */
		public static function degFromRot( p_rotInput:Number ):Number
		{
			var degOutput:Number = p_rotInput;
			while ( degOutput >= 360 )
			{
				degOutput -= 360;
			}
			while ( degOutput < 0 )
			{
				degOutput += 360;
			}
			return degOutput;
		}
		
		/**
		 * @param	p_radInput	Angle, in radians
		 * @return	Angle, in degrees, in range 0 to 360
		 */
		public static function degFromRad( p_radInput:Number ):Number
		{
			var degOutput:Number = 180 * oneOverPi * radFromRad( p_radInput );
			return degOutput;
		}
		
		/**
		 * @param	p_degInput	Angle, in degrees
		 * @return	Angle, in radians, in range 0 to ( 2 * pi )
		 */
		public static function radFromDeg( p_degInput:Number ):Number
		{
			var radOutput:Number = localPi * oneOver180 * degFromDeg( p_degInput );
			return radOutput;
		}
		
		/**
		 * @param	p_radInput	Angle, in radians
		 * @return	Angle, in degrees, in range -180 to +180
		 */
		public static function rotFromRad( p_radInput:Number ):Number
		{
			return rotFromDeg( degFromRad( p_radInput ) );
		}
		
		/**
		 * @param	p_rotInput	Angle, in degrees
		 * @return	Angle, in radians, in range 0 to ( 2 * pi )
		 */
		public static function radFromRot( p_rotInput:Number ):Number
		{
			return radFromDeg( degFromRot( p_rotInput ) );
		}
		
		/**
		 * @param p1 				start point of line
		 * @param p2 				end point of line
		 * @param percentDistance 	range (from 0 to 1) how far down the line to we want to retrieve the point? ie 0.5 will return
		 * 							a point that is 1/2 way between p1 and p2; 0.75 will return a point 3/4 of the length, etc...
		 * 							
		 * @default 				returns a point that is 1/2 way between p1, p2
		 * @return					Point
		 * 
		 * no bounds checking on input values; this could be bad...
		 * 
		 */
		public static function pointOnLineFromPoints(p1:Point, p2:Point, percentDistance:Number = 0.5):Point
		{
			var distance:Number		= Math.sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));	//distance between p1 and p2
			var angleRads:Number	= Math.atan2(p2.y - p1.y, p2.x - p1.x);							//angle of line, in radians formed by line (p1,p2)
			
			var point:Point = new Point();
			point.x = ((distance * Math.cos(angleRads)) * percentDistance) + p1.x;
			point.y = ((distance * Math.sin(angleRads)) * percentDistance) + p1.y;
			return point;
		}
		
		public static function pointOnLine(pointRef:Point, segmentTotalLength:Number, angleRads:Number, percentOfSegment:Number = 0.5):Point
		{
			pointRef.x = segmentTotalLength * Math.cos(angleRads) * percentOfSegment;
			pointRef.y = segmentTotalLength * Math.sin(angleRads) * percentOfSegment;
			return pointRef;
		}
		
		public static function randomInRange(min:Number, max:Number):Number
		{
    		 return Math.random() * (max - min) + min;
		}
		
		
	}
}
