package com.allofus.shared.video
{
	import org.osflash.signals.Signal;

	/**
	 * @author jc
	 */
	public class VideoRequestedSignal extends Signal
	{
		public function VideoRequestedSignal()
		{
			super(String);
		}
	}
}
