package com.allofus.shared.osc.signal
{
	import com.allofus.shared.osc.data.OSCMessage;
	import org.osflash.signals.Signal;

	/**
	 * @author jc.ehle
	 */
	public class OSCMessageReceived extends Signal
	{
		public function OSCMessageReceived(...args : *)
		{
			super(OSCMessage);
		}
	}
}
