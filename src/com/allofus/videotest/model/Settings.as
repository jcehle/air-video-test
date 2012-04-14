package com.allofus.videotest.model
{
	import com.greensock.easing.Sine;
	/**
	 * @author jc
	 */
	public class Settings
	{
		public static const WIDTH:uint = 1920;
		public static const HEIGHT:uint = 1080;
		
		
		public static const SETTINGS_URL:String = "settings.xml"; //in File.applicationStorageDirectory; see PrefsService.as
		public static var VIDEO_URL:String = "";
		public static var ATTRACTOR_URL : String = "";
		
		public static const FADE_EASE : Function = Sine.easeOut;
		public static const FADE_TIME : Number = 0.5;
		
		//listening for OSC to get RFID swipe events
		public static const OSC_LISTEN_IP:String = "127.0.0.1";
		public static const OSC_LISTEN_PORT:uint = 8082;
		
		//the OSC address we expect the RFID reader to dispatch to us
		public static const OSC_USER_SWIPED_RFID:String = "/event/rfid-swipe";  		//when a user has swiped the card
		public static const OSC_USER_SESSION_STARTED:String = "/event/session-data";  	//after a card swipe, a session is created in the db (we dont care about this one..)
	}
}