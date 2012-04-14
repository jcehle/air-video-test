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
	public class VideoView extends Sprite
	{
		public var player:VideoPlayer;
		
		private static const logger:ILogger = GetLogger.qualifiedName( VideoView );
		
		public function VideoView()
		{
			player = new VideoPlayer(Settings.WIDTH, Settings.HEIGHT);
			player.ready.add(onPlayerReady);
//			player.finished.add(onFinished);
			addChild(player);
			
			var label:Label = new Label(this, 15, 200, "MAIN VIDEO VIEW");
		}

		private function onPlayerReady(playerId:int) : void
		{
			logger.info("player: " + playerId + " is ready, gonna queue up this one: " + Settings.VIDEO_URL);
			player.queueVideo(Settings.VIDEO_URL, true);
		}
		
		public function queue(url:String):void
		{
			player.queueVideo(url);
		}
		
		private function onFinished() : void
		{
			player.pause();
		}
		
		public function reset():void
		{
			player.rewind();
			player.pause();
		}
		
		private function resume():void
		{
			player.resume();
		}

		public function hide(delay:Number = 0) : void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this, Settings.FADE_TIME, {autoAlpha:0, ease:Settings.FADE_EASE, delay:delay, onComplete:reset});
		}

		public function show(delay:Number = 0) : void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this, Settings.FADE_TIME, {autoAlpha:1, ease:Settings.FADE_EASE, delay:delay, onComplete:resume});
		}
	}
}
