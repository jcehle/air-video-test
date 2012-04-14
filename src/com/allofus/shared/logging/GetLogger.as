package com.allofus.shared.logging
{
	import mx.logging.ILogger;
	import mx.logging.Log;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author ehlejc
	 */
	public class GetLogger
	{
		public static function qualifiedName (value:*):ILogger
		{
			return Log.getLogger(getQualifiedClassName(value).replace("::", "."));
		}
	}
}
