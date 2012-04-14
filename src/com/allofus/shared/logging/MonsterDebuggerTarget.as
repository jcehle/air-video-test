package com.allofus.shared.logging
{
	import com.demonsters.debugger.MonsterDebugger;

	import mx.logging.ILogger;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.LineFormattedTarget;

	/**
	 * @author jcehle
	 */
	 
	public class MonsterDebuggerTarget extends LineFormattedTarget
	{
		protected var debugger:MonsterDebugger;
		
		private static const COLOR_DEBUG:int 	= 0X000000;
		private static const COLOR_INFO:int 	= 0xafaf66;
		private static const COLOR_WARN:int 	= 0xFF9933;
		private static const COLOR_ERROR:int 	= 0xFF1313;
		private static const COLOR_FATAL:int 	= 0xb10202;
		
		public function MonsterDebuggerTarget(target:Object = null)
		{
			MonsterDebugger.initialize(target); 
		}
		
		public override function logEvent(event:LogEvent):void
		{
			var color:int;
			switch(event.level)
			{
				case LogEventLevel.DEBUG:
					color = COLOR_DEBUG;
					break;

				case LogEventLevel.INFO:
					color = COLOR_INFO;
					break;

				case LogEventLevel.WARN:
					color = COLOR_WARN;
					break;

				case LogEventLevel.ERROR:
					color = COLOR_ERROR;
					break;

				case LogEventLevel.FATAL:
					color = COLOR_FATAL;
					break;
			}
			MonsterDebugger.trace(ILogger(event.target).category, event.message, "person","label",color);
		}

	}
}
