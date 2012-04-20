package
{
	import com.allofus.videotest.view.LoopVideoPlayerMediator;
	import com.allofus.videotest.view.LoopVideoPlayer;
	import com.allofus.videotest.controller.StartupCommand;
	import com.allofus.videotest.controller.WritePreferencesCommand;
	import com.allofus.videotest.service.PreferencesService;
	import com.allofus.videotest.signals.ShowVideoSignal;
	import com.allofus.videotest.signals.VideoChangedSignal;
	import com.allofus.videotest.signals.WritePreferencesSignal;
	import com.allofus.videotest.view.ApplicationMediator;
	import com.allofus.videotest.view.SettingsView;
	import com.allofus.videotest.view.SettingsViewMediator;
	import com.allofus.videotest.view.VideoView;
	import com.allofus.videotest.view.VideoViewMediator;

	import org.robotlegs.mvcs.SignalContext;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author jc.ehle
	 */
	public class VideoTestContext extends SignalContext
	{
		public function VideoTestContext(contextView : DisplayObjectContainer = null, autoStartup : Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
				override public function startup() : void
		{
			//=== SINGLETON SIGNALS ===
			injector.mapSingleton(VideoChangedSignal);
			injector.mapSingleton(ShowVideoSignal);
			
			//=== SERVICES ===
			injector.mapSingleton(PreferencesService);
			
			//=== SIGNAL COMMANDS ===
			signalCommandMap.mapSignalClass(WritePreferencesSignal, WritePreferencesCommand);
			
			
			//=== MEDIATE MAIN VIEW ===
			mediatorMap.mapView(VideoTest, ApplicationMediator);
			mediatorMap.createMediator(contextView);
			
			//=== MEDIATE VIEW COMPONENTS ===
			mediatorMap.mapView(SettingsView, SettingsViewMediator);
			mediatorMap.mapView(VideoView, VideoViewMediator);
			mediatorMap.mapView(LoopVideoPlayer, LoopVideoPlayerMediator);
			
			commandMap.execute(StartupCommand);
			
		}
	}
}
