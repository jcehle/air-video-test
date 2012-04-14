package com.allofus.shared.osc
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.osc.data.OSCBundle;
	import com.allofus.shared.osc.data.OSCMessage;
	import com.allofus.shared.osc.signal.OSCBundleReceived;
	import com.allofus.shared.osc.signal.OSCMessageReceived;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.errors.IOError;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.net.DatagramSocket;
	import mx.logging.ILogger;
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Actor;

	/**
	 * @author jc
	 */
	public class OSCReciever extends Actor
	{
		public static const BOUND:String = "OSCReciever/Status/Bound";
		public static const UNBOUND:String = "OSCReciever/Status/UnBound";
		
		
		public var status:Signal;
		private var _currentStatus:String = UNBOUND;
		public var bundleReceived:OSCBundleReceived;
		public var messageReceived:OSCMessageReceived;
		
		
		private var socket:DatagramSocket;
		
		private var _localIp:String = "0.0.0.0";
		private var _localPort:int = 0;
		
		private static const logger:ILogger = GetLogger.qualifiedName( OSCReciever );
		
		public function OSCReciever()
		{
			status = new Signal(String);
			bundleReceived = new OSCBundleReceived();
			messageReceived = new OSCMessageReceived();
			makeSocket();
		}
		
		public function listen(port:int, ip:String):void
		{
			_localPort = port;
			_localIp = ip;
			bind();
		}
		
		
		private function bind( event:Event = null):void
		{
			if(socket && socket.bound)
			{
				logger.debug("refreshing socket binding");
				closeSocket();
				makeSocket();
			}
			
			if(!socket)
				makeSocket();
			
			try
			{
				socket.bind( _localPort, _localIp);
				socket.receive();
				setSetatus(BOUND);
			}
			catch(e:RangeError)
			{
				logger.error("must specify port between 0 and 65535");
				closeSocket();
			}
			catch(e:ArgumentError)
			{
				logger.error("local address is not valid: " + _localIp);
				closeSocket();
			}
			catch(e:IOError)
			{
				logger.error("port already in use; OR isufficient user privileges; OR socket already bound; OR socket closed... work it out!");
				closeSocket();
			}
			catch(e:Error)
			{
				logger.error("caught general error: " + e);
				closeSocket();
			}
		}
		
		private function makeSocket():void
		{
			socket = new DatagramSocket();
			socket.addEventListener(DatagramSocketDataEvent.DATA, onDataReceived);
		}
		
		private function closeSocket() : void 
		{
			logger.debug("closing socket" + status.valueClasses);
			MonsterDebugger.trace("wtf is status signal", status);
			if(socket)
			{
				socket.removeEventListener(DatagramSocketDataEvent.DATA, onDataReceived);
				try
				{
					socket.close();
				}
				catch (e:IOError)
				{
					logger.error("cannot close socket; socket wasn't open OR there is internal, networking or other OS error.");
				}
				catch (e:Error)
				{
					logger.error("cannot close socket. something is balls.");
				}
			}
			socket = null;
			setSetatus(UNBOUND);
		}

		private function onDataReceived(event : DatagramSocketDataEvent) : void
		{

			logger.debug("got packet.");
			if(OSCBundle.isBundle(event.data))
			{
				var b:OSCBundle = new OSCBundle(event.data);
				MonsterDebugger.trace("BUNDLE", b);
				bundleReceived.dispatch(b);
			}
			else
			{
				var m:OSCMessage = new OSCMessage(event.data);
				MonsterDebugger.trace("MESSAGE", m);
				messageReceived.dispatch(m);
			}
		}
		
		private function setSetatus(value:String):void
		{
			logger.debug("setting OSC Receiver status: " + value);
			_currentStatus = value;
			status.dispatch(_currentStatus);
		}

		public function get currentStatus() : String 
		{
			return _currentStatus;
		}
	}
}
