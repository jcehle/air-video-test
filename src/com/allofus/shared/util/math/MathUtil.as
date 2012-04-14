package com.allofus.shared.util.math
{
	/**
	 * @author jc
	 */
	public class MathUtil
	{


		/**
		 * Re-maps a number from one range to another.
		 * 
		 * @param value			Number to be re-mapped
		 * @param fromMin		Number that is the smallest of the original range
		 * @param fromMax		Number that is the largest of the original range
		 * @param toMin			Number that is the smallest in the new range
		 * @param toMax			Number that is the largest in the new range
		 * 
		 * @return 				Number in the new range
		 */
		
		public static function map(value:Number, fromMin:Number, fromMax:Number, toMin:Number, toMax:Number):Number
		{
			return (value - fromMin) * (toMax - toMin) / (fromMax - fromMin) + toMin;
		}
		
	}
}
