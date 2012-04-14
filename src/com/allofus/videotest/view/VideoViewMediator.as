package com.allofus.videotest.view
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.videotest.model.Settings;
	import com.allofus.videotest.signals.VideoChangedSignal;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class VideoViewMediator extends Mediator
	{
		[Inject] public var view:VideoView;
		
		[Inject] public var videoChangedSignal:VideoChangedSignal;
		
		
		private static const logger:ILogger = GetLogger.qualifiedName( VideoViewMediator );

		override public function onRegister() : void
		{
			videoChangedSignal.add(onVideoChanged);
		}

		private function onVideoChanged() : void
		{
			view.queue(Settings.VIDEO_URL);
		}
	}
}
