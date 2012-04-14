package com.allofus.shared.logging
{
	import com.bit101.components.TextArea;

	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.LineFormattedTarget;

	import flash.text.StyleSheet;
	/**
	 * a simple minimalcomps logging target
	 * 
	 * @author jc
	 */
	public class TextAreaTarget extends LineFormattedTarget
	{
		protected var field:TextArea;
		
		public function TextAreaTarget(textArea:TextArea)
		{
			this.field = textArea;
		}
		
		public override function logEvent(event:LogEvent):void
		{
			field.text += event.message + "\n";
		}
	}
}
