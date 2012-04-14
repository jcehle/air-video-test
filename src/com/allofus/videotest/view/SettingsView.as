package com.allofus.videotest.view
{
	import net.hires.debug.Stats;

	import com.allofus.shared.logging.GetLogger;
	import com.allofus.videotest.model.Settings;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import com.bit101.utils.MinimalConfigurator;

	import org.osflash.signals.Signal;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	/**
	 * @author jc
	 */
	public class SettingsView extends Sprite
	{
		private var configurator:MinimalConfigurator;
		
		
		public var panel:Panel;
		public var topWindow:Window;		
		public var videoPathField:Text;
		public var openDir:PushButton;
		public var videoBtn : PushButton;
		
		public var videoSelected:Signal;
		
		private var videoFile:File;
		private var videoFilter:FileFilter = new FileFilter("movie files", "*.m4v;*.f4v;*.mp4;*.flv");
		
		
		private var stats:Stats;
		
		private static const logger : ILogger = GetLogger.qualifiedName(SettingsView);
		
		public function SettingsView()
		{
			videoFile = new File();
			stats = new Stats();
			
			videoSelected = new Signal();

			if(!stage)
			{
				addEventListener(Event.ADDED_TO_STAGE, initView);
			}
			else
			{
				initView();
			}
			
			visible = false;
		}

		private function initView(event : Event = null) : void
		{
			stage.addEventListener(Event.RESIZE, updateLayout);
			
			Style.setStyle(Style.DARK);
			configurator = new MinimalConfigurator(this);
			configurator.parseXML(CONFIG);
			
			addChild(stats);
			
			addListeners();
			updateLayout();
		}

		public function updateLayout(event:Event = null) : void
		{
			stats.x = stage.stageWidth - 80;
			stats.y = 10;
			panel.width = topWindow.width = stage.stageWidth;
		}
		
		private function addListeners():void
		{
			videoBtn.addEventListener(MouseEvent.CLICK, browseForVideo);
			videoFile.addEventListener(Event.SELECT, onVideoSelected);
			
			openDir.addEventListener(MouseEvent.CLICK, openAppDir);
		}
		
		private function onVideoSelected(event : Event) : void
		{
			videoURL = videoFile.url;
			videoSelected.dispatch();
		}
		
		private function openAppDir(event : MouseEvent) : void
		{
			 File.applicationStorageDirectory.openWithDefaultApplication();
		}

		private function browseForVideo(event : MouseEvent) : void
		{
			try
			{
				videoFile.browseForOpen("Select a video:",[videoFilter]);
			}
			catch(e:Error)
			{
				logger.error("no go : " + e.message);
			}
		}
		
		public function set videoURL(url:String):void
		{
			CONFIG..Text.(@id == "videoPathField").@text = Settings.VIDEO_URL = url;
			if(videoPathField)
				videoPathField.text = videoFile.resolvePath(url).nativePath;
		}
		
		
		public static var CONFIG:XML =
		<comps>
			<Panel id="panel" x="0" y="0" width="700" height="110">
				<VBox>
					<HBox x="0">
						<Window id="topWindow" width="700" height="110" title="Application Settings:" hasMinimizeButton="false" draggable="false">
							<HBox x="10">
			        			<VBox y="10">
									<HBox>
										<PushButton id="videoBtn" label="Video Path:" />
										<Text id="videoPathField" text={Settings.VIDEO_URL} editable="false" width="300" height="20" />
									</HBox>
									<PushButton id="openDir" label="View Settings Dir" />
			        			</VBox>
							</HBox>
		    			</Window>
					</HBox>
				</VBox>
			</Panel>
		</comps>;
	}
}
