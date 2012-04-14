package com.allofus.shared.util
{
	import flash.display.DisplayObject;
	/**
	 * @author jc
	 */
	public class PositionUtil
	{
		public static function centerHorizontally(thisObject:DisplayObject, relativeTo:DisplayObject, offset:int = 0):void
		{
			thisObject.x = Math.round((relativeTo.x + (relativeTo.width * 0.5)) - (thisObject.width * 0.5)) + offset;
		}
		
		public static function centerHorizontallyByVal(thisObject:DisplayObject, val:Number, offset:int = 0):void
		{
			thisObject.x = Math.round((val * 0.5) - (thisObject.width * 0.5)) + offset;
		}
		
		public static function centerVertically(thisObject:DisplayObject, relativeTo:DisplayObject, offset:int = 0):void
		{
			thisObject.y = Math.round((relativeTo.y + (relativeTo.height * 0.5)) - (thisObject.height * 0.5)) + offset;
		}
		
		public static function centerVerticallyByVal(thisObject:DisplayObject, val:Number, offset:int = 0):void
		{
			thisObject.y = Math.round((val * 0.5) - (thisObject.height * 0.5)) + offset;
		}
		
		public static function positionUnder(thisObject:DisplayObject, underThisOne:DisplayObject, distance:Number = 0):void
		{
			thisObject.y = Math.round(underThisOne.y + underThisOne.height + distance);
		}
		
		public static function positionToTheRight(thisObject:DisplayObject, toTheRightOfThisOne:DisplayObject, distance:Number = 0):void
		{
			thisObject.x = Math.round(toTheRightOfThisOne.x + toTheRightOfThisOne.width + distance);
		}

		public static function positionToTheLeft(thisObject : DisplayObject, toTheLeftOfThisOne : DisplayObject, distance : Number = 0) : void
		{
			thisObject.x = Math.round(toTheLeftOfThisOne.x - thisObject.width - distance);
		}

		public static function positionAbove(thisObject : DisplayObject, aboveThisOne : DisplayObject, distance:Number = 0) : void
		{
			thisObject.y = Math.round(aboveThisOne.y - thisObject.height - distance);
		}

		public static function alignRight(thisObject : DisplayObject, alignedToTheRightOf : DisplayObject, offset:int = 0) : void
		{
			thisObject.x = Math.round(alignedToTheRightOf.x + alignedToTheRightOf.width - thisObject.width + offset);
		}

		public static function alignBottom(thisObject : DisplayObject, alignedToTheBottomOf : DisplayObject, offset:int = 0) : void
		{
			thisObject.y = Math.round(alignedToTheBottomOf.y + alignedToTheBottomOf.height - thisObject.height + offset);
		}

	}
}
