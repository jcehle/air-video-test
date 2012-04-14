package com.allofus.videotest.view
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.videotest.signals.VideoChangedSignal;
	import com.allofus.videotest.signals.WritePreferencesSignal;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;



	/**
	 * @author jc
	 */
	public class SettingsViewMediator extends Mediator
	{
		[Inject] public var view:SettingsView;
		
		[Inject] public var writePrefs:WritePreferencesSignal;
		
		[Inject] public var videoChangedSignal:VideoChangedSignal;
		
		
		private static const logger:ILogger = GetLogger.qualifiedName( SettingsViewMediator );
		
		public function SettingsViewMediator()
		{
		}

		override public function onRegister() : void
		{
			eventMap.mapListener(view.stage, KeyboardEvent.KEY_DOWN, onKeyDown);
			view.videoSelected.add(onVideoSelected);
		}

		private function onVideoSelected() : void
		{
			writePrefs.dispatch();
			videoChangedSignal.dispatch();
		}
		
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.D:
					//toggle visible
					view.visible = !view.visible;
					break;
			}
		}
	}
}
