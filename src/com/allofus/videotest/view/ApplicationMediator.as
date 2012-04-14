package com.allofus.videotest.view
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.videotest.model.Settings;
	import com.allofus.videotest.signals.ShowVideoSignal;
	import com.allofus.videotest.signals.WritePreferencesSignal;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * @author jc
	 */
	public class ApplicationMediator extends Mediator
	{
		[Inject] public var view:VideoTest;
		
		[Inject] public var writePrefs:WritePreferencesSignal;
		
		[Inject] public var showVideoSig:ShowVideoSignal;
		
		private static const logger : ILogger = GetLogger.qualifiedName(ApplicationMediator);
		
		public static const ATTRACTOR_STARTED:String = "ApplicationMediator/AttractorStarted";
		
		override public function onRegister() : void
		{
			eventMap.mapListener(view.stage.nativeWindow, Event.CLOSING, onAppClosing);
			eventMap.mapListener(view.stage, KeyboardEvent.KEY_DOWN, onKeyDown);
			showVideoSig.add(showVideo);
		}

		private function onKeyDown(event:KeyboardEvent) : void
		{
			switch (event.keyCode)
			{
				case Keyboard.F:
					view.toggleFullscreen();
					break;
					
				case Keyboard.M:
					view.mouseVisible = !view.mouseVisible;
					break;
					
				case Keyboard.V:
					showVideo();
					break;
				
				case Keyboard.SPACE:
					showVideo();
					break;
			}
		}
		
		private function onAppClosing(event:Event = null) : void
		{
			logger.info("app is closing... write prefs file.");
			writePrefs.dispatch();
		}
		
		private function showVideo():void
		{
			logger.info("show content.");
			video.show(Settings.FADE_TIME);
		}
		
		private function get video():VideoView
		{
			return view.videoLayer.getChildAt(0) as VideoView;
		}
		

	}
}
