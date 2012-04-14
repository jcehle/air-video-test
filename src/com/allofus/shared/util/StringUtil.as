package com.allofus.shared.util
{
	import com.allofus.shared.logging.GetLogger;
	import com.demonsters.debugger.MonsterDebugger;

	import mx.logging.ILogger;
	/**
	 * @author jc
	 */
	public class StringUtil
	{
		private static const logger:ILogger = GetLogger.qualifiedName( StringUtil );
		
		public static function formatTime( value:Number ):String
		{
			var remainder:Number;
			var hours:Number;
			var minutes:Number;
			var seconds:Number;
			
			hours = value / ( 60 * 60 );
			remainder = hours - (Math.floor ( hours ));
			hours = Math.floor ( hours );
			minutes = remainder * 60;
			remainder = minutes - (Math.floor ( minutes ));
			minutes = Math.floor ( minutes );
			seconds = remainder * 60;
			remainder = seconds - (Math.floor ( seconds ));
			seconds = Math.floor ( seconds );
			
			var hString:String = hours   < 10 ? "0" + hours : "" + hours;	
			var mString:String = minutes < 10 ? "0" + minutes : "" + minutes;
			var sString:String = seconds < 10 ? "0" + seconds : "" + seconds;
						
			if ( value < 0 || isNaN(value)) 
				return "00:00";			
						
			if ( hours > 0 )
			{			
				return hString + ":" + mString + ":" + sString;
			}else
			{
				return mString + ":" + sString;
			}
		}
		
		//SAME AS formatTime(); need to test which version is faster.
		protected function convertToHHMMSS(seconds:Number):String
		{
		    var s:Number = seconds % 60;
		    var m:Number = Math.floor((seconds % 3600 ) / 60);
		    var h:Number = Math.floor(seconds / (60 * 60));
		 
		    var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
		    var minuteStr:String = doubleDigitFormat(m) + ":";
		    var secondsStr:String = doubleDigitFormat(s);
		 
		    return hourStr + minuteStr + secondsStr;
		}
 
		protected function doubleDigitFormat(num:uint):String
		{
		    if (num < 10)
		    {
		        return ("0" + num);
		    }
		    return String(num);
		}
		
		
		public static function formatDecimalPlaces(value:Number, precision:int = 0):String
		{
			if(isNaN(value))
			{
				trace("must provide a number to StringUtil.formatDecimalPlaces");	
				return "NaN";
			}
			
			var mult:Number = Math.pow(10, precision);
			var val:String = String(Math.round((value * mult)) / mult);
			var parts:Array = val.split(".");
			var i:uint = 0;
			
			if(parts[1] == null)
			{
				if(precision > 0)
				{
					val += ".";
				}
				for (i = 0; i < precision; i++) 
				{
					val += "0";	
				}
			}
			else if(parts[1].length < precision)
			{
				for(i = 0; i < precision - parts[1].length; i++)
				{
					val += "0";
				}
			}
			return val;
		}
		
		public static function friendlyNumber(value:String, precision:int = 2):FriendlyNumberVO
		{
			var val:String = "";
			var additional:String = "";
			var fnVO:FriendlyNumberVO = new FriendlyNumberVO();
			var len:int = value.length;
			if(len > 9 && len < 13)
			{
				//billions - give a precision decimal for figures that are in the billions
				val = Number(value).toPrecision(precision).slice(0,precision+1);
				additional = "Billion";
			}
			else if (len > 6 && len < 10)
			{
				//millions - just display the millions value
				val = value;
				while(val.length > 3)
				{
					//slice off the last 3 digits
					val = val.substr(0,val.length-3);
				}
				additional = " Million";
			}
			else if (len > 3 && len < 7)
			{
				//thousands - show thousands comma separated
				val = value;
				var firstChunk:String = value;
				var lastChunk:String = val.substr(-3);
				
				if(len == 6)
					firstChunk = firstChunk.slice(0,3);
				else if(len == 5)
					firstChunk = firstChunk.slice(0,2);
				else
					firstChunk = firstChunk.slice(0,1);
				
				val = firstChunk + "," + lastChunk;
			}
			else
			{
				val = value;
			}
			
			fnVO.value = val;
			fnVO.additionalText = additional;
			return fnVO;
		}
		
	}
}
