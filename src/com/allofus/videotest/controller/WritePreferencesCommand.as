package com.allofus.videotest.controller
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.videotest.model.Settings;
	import com.allofus.videotest.service.PreferencesService;
	import com.allofus.videotest.view.SettingsView;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	import flash.filesystem.File;

	/**
	 * @author jc
	 */
	public class WritePreferencesCommand extends Command
	{
		[Inject] public var prefsService:PreferencesService;
		
		private static const logger:ILogger = GetLogger.qualifiedName( WritePreferencesCommand );
		
		override public function execute() : void
		{
			logger.info("writing prefs...");
			var prefsString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			var xml:XML = SettingsView.CONFIG;
			prefsString += xml.toXMLString();
			prefsString = prefsString.replace(/\n/g, File.lineEnding); 
			prefsService.writePreferences(Settings.SETTINGS_URL, prefsString);
		}

	}
}
