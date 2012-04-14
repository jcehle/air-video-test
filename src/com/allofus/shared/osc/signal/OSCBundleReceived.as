package com.allofus.shared.osc.signal
{
	import com.allofus.shared.osc.data.OSCBundle;
	import org.osflash.signals.Signal;

	/**
	 * @author jc.ehle
	 */
	public class OSCBundleReceived extends Signal
	{
		public function OSCBundleReceived(...args : *)
		{
			super(OSCBundle);
		}
	}
}
