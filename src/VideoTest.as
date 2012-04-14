package 
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.logging.SOSLoggingTarget;
	import com.demonsters.debugger.MonsterDebugger;

	import mx.logging.ILogger;
	import mx.logging.Log;

	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.ui.Mouse;

	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="1920", height="1080")]
	public class VideoTest extends Sprite
	{
		public var videoLayer : Sprite;
		public var settingsLayer : Sprite;
		
		private var context : VideoTestContext;
		
		private var _mouseVisible : Boolean = true;
		
		private static const logger:ILogger = GetLogger.qualifiedName( VideoTest );
		
		public function VideoTest()
		{
			addEventListener(Event.ADDED_TO_STAGE, initApp);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		}

		private function initApp(event : Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initApp);
			initSOSLogging();
			initMonsterDebugger();
			setupListeners();
			createViewLayers();
			createContext();
		}
		
		private function onInvoke(event:InvokeEvent):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			toggleFullscreen();
		}

		private function initSOSLogging() : void
		{
			var sosLoggingTarget : SOSLoggingTarget = new SOSLoggingTarget();
			sosLoggingTarget.includeCategory = true;
			sosLoggingTarget.includeDate = true;
			sosLoggingTarget.includeLevel = true;
			sosLoggingTarget.includeTime = true;
			//sosLoggingTarget.level = LogEventLevel.WARN;
			Log.addTarget(sosLoggingTarget);
		}

		private function initMonsterDebugger() : void
		{
			MonsterDebugger.initialize(this);
		}
		
		private function setupListeners() : void
		{
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError);
		}

		private function createViewLayers() : void
		{
			videoLayer = new Sprite();
			settingsLayer = new Sprite();
			
			addChild(videoLayer);
			addChild(settingsLayer);
		}

		private function createContext() : void
		{
			context = new VideoTestContext(this,true);
		}
		
		private function handleUncaughtError(event : UncaughtErrorEvent) : void
		{
			if(event.error is Error)
			{
				var e:Error = event.error as Error;
				MonsterDebugger.trace(this, e);
			}
			else if(event.error is ErrorEvent)
			{
				var ee:ErrorEvent = event.error as ErrorEvent;
				MonsterDebugger.trace(this, ee);
			}
			else
			{
				MonsterDebugger.trace(this, event);
			}
		}

		public function toggleFullscreen() : void
		{
			stage.displayState = (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		public function set mouseVisible(value:Boolean):void
		{
			if(value)
			{
				Mouse.show();	
			}
			else
			{
				Mouse.hide();
			}
			_mouseVisible = value;
		}
		
		public function get mouseVisible():Boolean
		{
			return _mouseVisible;
		}
	}
}
