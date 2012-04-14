package com.allofus.videotest.controller
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.videotest.model.Settings;
	import com.allofus.videotest.service.PreferencesService;
	import com.allofus.videotest.view.SettingsView;
	import com.allofus.videotest.view.VideoView;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class StartupCommand extends Command
	{
		private static const logger:ILogger = GetLogger.qualifiedName( StartupCommand );
		
		[Inject] public var prefsService:PreferencesService;
		
		override public function execute() : void
		{
			logger.info("startup!");
			
			logger.debug("check preferences file:");
			var prefsXML:XML = prefsService.readPreferences(Settings.SETTINGS_URL);
			if(!prefsXML)
			{
				logger.debug("there was no prefs file already (first time running app?) so create it...");
				prefsXML = SettingsView.CONFIG;
				prefsService.writePreferences(Settings.SETTINGS_URL, prefsXML.toXMLString());
			}
			
			var mainView:VideoTest = contextView as VideoTest;
			var settingsView:SettingsView = new SettingsView();
			var videoView:VideoView = new VideoView();
			
			var vidURL:String = prefsXML..Text.(@id == "videoPathField").@text;
			logger.debug("set video URL: " + vidURL);
			settingsView.videoURL = vidURL;
			
			
			mainView.settingsLayer.addChild(settingsView);
			mainView.videoLayer.addChild(videoView);
			
		}
	}
}
