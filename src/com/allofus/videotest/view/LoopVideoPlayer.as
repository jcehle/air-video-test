package com.allofus.videotest.view
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.video.VideoPlayer;
	import com.allofus.videotest.model.Settings;
	import com.bit101.components.Label;
	import com.greensock.TweenMax;

	import mx.logging.ILogger;

	import flash.display.Sprite;

	/**
	 * @author jc
	 */
	public class LoopVideoPlayer extends Sprite
	{
		
		public var vidPlayer1:VideoPlayer;
		public var vidPlayer2:VideoPlayer;
		
		public var currentPlayer:VideoPlayer;
		public var queuedPlayer:VideoPlayer;
		
		
		
		private static const logger:ILogger = GetLogger.qualifiedName( VideoView );

		public function LoopVideoPlayer()
		{
			vidPlayer1 = new VideoPlayer(Settings.WIDTH, Settings.HEIGHT);
			vidPlayer2 = new VideoPlayer(Settings.WIDTH, Settings.HEIGHT);
			
			vidPlayer1.queueVideo(Settings.VIDEO_URL, true);
			vidPlayer2.queueVideo(Settings.VIDEO_URL, false);
			
			addChild(vidPlayer1);
			addChildAt(vidPlayer2, 0);
			
			currentPlayer = vidPlayer1;
			queuedPlayer = vidPlayer2;
			
			currentPlayer.finished.add(doSwapLoop);
						
			queuedPlayer.visible = false;
			
			var label:Label = new Label(this, 15, 200, "MAIN VIDEO VIEW");
		}

		private function doSwapLoop(vidPlayerCompleteId:int):void
		{
			logger.info("i see vid player finished: " + vidPlayerCompleteId);
			
//			var cvp:VideoPlayer = currentPlayer;
//			currentPlayer = queuedPlayer;
//			logger.info("swapping players, currentPlayer is: " + currentPlayer.id);
//			queuedPlayer = cvp;
//			bringToTop(currentPlayer);
//			currentPlayer.visible = true;
//			queuedPlayer.visible = false;
//			queuedPlayer.queueVideo(Settings.VIDEO_URL, false);
//			currentPlayer.finished.add(doSwapLoop);
//			currentPlayer.resume();
		}
		
		protected function bringToTop(vp:VideoPlayer):void
		{
			setChildIndex(vp, numChildren -1);
		}
		

		public function queue(videoUrl : String) : void
		{
			logger.debug("both players queue up vid: " + videoUrl);
			currentPlayer.queueVideo(videoUrl);
			queuedPlayer.queueVideo(videoUrl);
		}
	}
}
