package com.allofus.videotest.service
{
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author jcehle
	 */
	public class PreferencesService extends Actor
	{
		public static const UPDATED:String 	= "preferencesService/readComplete";
		
		//API
		public function readPreferences(filePath:String):XML
		{
			var file:File = File.applicationStorageDirectory.resolvePath(filePath);
			if(file.exists)
			{
				var readStream:FileStream = new FileStream();
				readStream.open(file, FileMode.READ);
				var xml:XML = XML(readStream.readUTFBytes(readStream.bytesAvailable));
				logger.debug("here is what we read from the prefs file: " + xml);
				readStream.close();
				return xml;
			}

			logger.debug("there is no preferences file.");
			return null;
		}
		
		public function writePreferences(filePath:String, contentsString:String):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(filePath);
			var writeStream:FileStream = new FileStream();
			writeStream.open(file, FileMode.WRITE);
			writeStream.writeUTFBytes(contentsString);
			writeStream.close();
			dispatch(new Event(UPDATED));
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName(PreferencesService);
	}
}
