package com.allofus.shared.video
{
	import com.demonsters.debugger.MonsterDebugger;
	import org.osflash.signals.Signal;
	import com.allofus.shared.logging.GetLogger;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	

	/**
	 * @author jc
	 */
	public class VideoPlayer extends Sprite
	{
		private static const logger:ILogger = GetLogger.qualifiedName( VideoPlayer );
		public static var VID_PLAYER_ID : int = 1;
		
		
		private var _loop:Boolean = true;
		
		protected var connection:NetConnection;
		protected var stream:NetStream;
		protected var video:Video;
		
		public var ready:Signal;
		public var finished:Signal;
		
		protected var _playerWidth:uint;
		protected var _playerHeight : uint;
		
		private var _streamURL:String;
		private var _autoplay:Boolean = true;
		private var _isPaused : Boolean = false;
		
		private var _id:int;
		
		
		public function VideoPlayer(width:uint, height:uint)
		{
			_id = VID_PLAYER_ID;
			VID_PLAYER_ID++;
			
			_playerWidth = width;
			_playerHeight = height;
			
			ready = new Signal(int);
			finished = new Signal(int);
			
			
			if(stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, initConnection);
			}
			else
			{
				initConnection();
			}
		}

		public function initConnection(event:Event = null) : void
		{
			logger.info("init player: " + _id);
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			connection.connect(null);
		}
		
		private function onConnectionStatus(event : NetStatusEvent) : void
		{
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					logger.debug("NetConnection success, init() the stream & attach the video");
					initStream();
					break;
					
				case "NetConnection.Call.BadVersion":
				case "NetConnection.Call.Failed":
				case "NetConnection.Call.Prohibited":
				case "NetConnection.Connect.AppShutdown":
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.InvalidApp":
				case "NetConnection.Connect.Rejected":
					logger.error("NetConnection error: " + event.info.code + ", read more here: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/NetStatusEvent.html");
					break;
					
				
				case "NetConnection.Connect.Closed":
					logger.debug("net connection closed successfully");
					break;
					
				default:
					logger.debug("NetConnection: " + event.info.code);
					break;
				
			}
		}
		
		private function killConnection():void
		{
			if(connection)
			{
				connection.close();
				connection.removeEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			}
			connection = null;
		}
		
		private function initStream():void
		{
			logger.debug("player: " + _id + "initStream()");
			killStream();
			stream = new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, streamStatus);
			stream.client = this;
			initVideo();
		}
		
		protected function killStream():void
		{
			if(stream)
			{
				stream.close();
				stream.dispose();
				stream.removeEventListener(NetStatusEvent.NET_STATUS, streamStatus);
			}	
			stream = null;	
		}
		
		
		protected function initVideo():void
		{
			logger.debug("player: " + _id + "initVideo(): " + _streamURL);
			killVideo();
			video = new Video(_playerWidth, _playerHeight);
			video.attachNetStream(stream);
			addChild(video);
			
			if(_streamURL)
			{
				logger.debug("queue up the video:" + _streamURL);
				queueVideo(_streamURL, _autoplay);
			}
			
			ready.dispatch(_id);
		}
		
		protected function killVideo():void
		{
			if(video)
			{
				video.attachNetStream(null);
				video.clear();
				if(video.parent)
					removeChild(video);
				video = null;
			}
		}
		
		private function streamStatus(event : NetStatusEvent) : void
		{
			switch (event.info.code)
			{
				case "NetStream.Play.Stop":
					logger.info("video: " + _id + " reached the end of video file");
					if(_loop)
						replay();
					else
					{
						logger.info("video: " + _id + " dispatch finished, numListeners: " + finished.numListeners );
						finished.dispatch(_id);
					}
					break;
				
				case "NetStream.Buffer.Empty":
				case "NetStream.Buffer.Flush":
				case "NetStream.Buffer.Full":
				case "NetStream.Buffer.Full":
				case "NetStream.Connect.Closed":
				case "NetStream.Connect.Success":
				case "NetStream.DRM.UpdateNeeded":
				case "NetStream.MulticastStream.Reset":
				case "NetStream.Pause.Notify":
				case "NetStream.Play.NoSupportedTrackFound":
				case "NetStream.Play.PublishNotify":
				case "NetStream.Play.Reset":
				case "NetStream.Play.Start":
				case "NetStream.Play.Transition":
				case "NetStream.Play.UnpublishNotify":
				case "NetStream.Publish.Idle":
				case "NetStream.Publish.Start":
				case "NetStream.Record.AlreadyExists":
				case "NetStream.Record.Start":
				case "NetStream.Record.Stop":
				case "NetStream.Seek.Notify":
				case "NetStream.Step.Notify":
				case "NetStream.Unpause.Notify":
				case "NetStream.Unpublish.Success":
				case "SharedObject.Flush.Success":
					logger.debug("video: " + _id + " NetStream event: " + event.info.code);
					break;
				
				case "NetStream.Play.InsufficientBW":
					logger.warn("video: " + _id + " NetStream event: " + event.info.code + ", read more here: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/NetStatusEvent.html");
					break;
				
				case "NetStream.Connect.Failed":
				case "NetStream.Connect.Rejected":
				case "NetStream.Failed":
				case "NetStream.Play.Failed":
				case "NetStream.Play.FileStructureInvalid":
				case "NetStream.Play.StreamNotFound":
				case "NetStream.Publish.BadName":
				case "NetStream.Record.Failed":
				case "NetStream.Record.NoAccess":
				case "NetStream.Seek.Failed":
				case "NetStream.Seek.InvalidTime":
				case "SharedObject.BadPersistence":
				case "SharedObject.Flush.Failed":
				case "SharedObject.UriMismatch":
					logger.error("video: " + _id + " NetStream (error) event: " + event.info.code + ", read more here: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/NetStatusEvent.html");
					break;
					
				default:
					logger.debug("video: " + _id + " NetStream event: " + event.info.code);
			}
		}

		
		
		public function queueVideo(url : String, autoplay:Boolean = true) : void
		{
			logger.debug("queueVideo: " + url);
			_streamURL = url;
			_autoplay = autoplay;
			if(stream)
			{
				stream.play(_streamURL);
				
				if(autoplay)
					resume();
				else
					pause();
			}
			else
			{
				logger.warn("no stream to queue video!");
			}
		}
		
		public function resume() : void
		{
			stream.resume();
			_isPaused = false;
		}
		
		public function pause():void
		{
			stream.pause();
			_isPaused = true;
		}
		
		public function replay() : void
		{
			logger.info("replay video: " + _id);
			stream.seek(0);
			stream.resume();
		}
		
		public function reset() : void
		{
			if(stream)
				stream.close();
				
			if(video)
				video.clear();
		}
		
		public function rewind():void
		{
			stream.seek(0);
		}
		
		/*
		 * NetStream handlers
		 */
		public function asyncError (info:Object):void { logger.error("asyncError: " + info); }
		public function ioError (info:Object):void { logger.error("ioError: " + info); }
		public function netStatus (e:NetStatusEvent):void {logger.debug("net status: " + e.info); }
		public function onMetaData(e:Object):void { logger.debug("loaded video metadata: " + e); }
		public function onXMPData(e:Object):void{ logger.debug("got XMPData : " + e); }
		
		public function onPlayStatus (e:Object):void 
		{	
			logger.debug("play status: " + e);
			MonsterDebugger.trace("Play status: " , e);
		}
		
		public function get FPS():Number
		{
			if(stream)
			
				return stream.currentFPS;
				
			else
				return 0;
		}
		
		public function get currentTime():Number
		{
			if(stream)
				return stream.time;
				
			else
				return 0;
		}

		public function get isPaused():Boolean
		{
			return _isPaused;
		}
		
		public function get loop() : Boolean
		{
			return _loop;
		}

		public function set loop(value : Boolean) : void
		{
			_loop = value;
		}

		public function get playerWidth() : uint
		{
			return _playerWidth;
		}

		public function set playerWidth(value : uint) : void
		{
			_playerWidth = value;
			if(video)
				video.width = _playerWidth;
		}

		public function get playerHeight() : uint
		{
			return _playerHeight;
		}

		public function set playerHeight(value : uint) : void
		{
			_playerHeight = value;
			if(video)
				video.height = _playerHeight;
		}
		
		public function dispose() : void
		{
			reset();
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
			removeEventListener(Event.ADDED_TO_STAGE, initConnection);
			
			killVideo();
			killStream();
			killConnection();
			
			ready.removeAll();
			finished.removeAll();

			ready = null;
			finished = null;
		}

		public function get streamURL() : String
		{
			return _streamURL;
		}

		public function set streamURL(streamURL : String) : void
		{
			_streamURL = streamURL;
		}

		public function get id() : int
		{
			return _id;
		}
	}
}
