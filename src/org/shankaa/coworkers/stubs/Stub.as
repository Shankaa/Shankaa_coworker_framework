package org.shankaa.coworkers.stubs
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.UIDUtil;
	
	import org.shankaa.coworkers.WorkerManager;
	
	/**
	 * An abstract class parent of all Stub_xxxx classes
	 * Convention : All subclasses should be named as Stub_TheNameOfTheRemoteClass
	 *  
	 * @author Shankaa
	 * 
	 */
	public class Stub extends EventDispatcher implements I_Interface
	{
		//protected static var CURRENT_CHANNELS	: ArrayCollection	= new ArrayCollection();
		
		protected static var INWORKERSUFFIX		: String			= "InWorker";
		
		protected var _worker					: Worker;
		protected var _workerRequestChannelID	: String;
		protected var _remoteHandle				: String;
		private var delayedExecutionQueue		: Array				= new Array();
		
		protected var _remoteClass				: Class				= null;
		
		protected var recycledChannels			: Array				= new Array();
		
		protected var channelDictionary			: Dictionary		= new Dictionary();
		
		/**
		 * 
		 * @param remoteWorker a worker set with a DataWorker class
		 * @param remoteClass the class of the object to create in the worker
		 * @param args
		 * 
		 */
		public function Stub(remoteWorker:Worker,remoteClass:Class,...args)
		{
			
			//registerClassAlias("flash.system.MessageChannel",MessageChannel);
			_worker 				= remoteWorker;
			_remoteClass			= remoteClass;
			if(_worker && _remoteClass){
				_remoteHandle 		= build_Remote(args);
			}
		}
		
		public function set remoteWorker(value:Worker):void{
			if(value && _worker != value && _remoteClass){
				_worker = value;
				build_Remote();
			} else {
				_worker = value;
			}
			
		}
		
		public function get remoteWorker():Worker{
			return _worker;
		}
		
		protected function set remoteClass(value:Class):void{
			if(_worker && _remoteClass != value && value){
				_remoteClass = value;
				build_Remote();
			} else {
				_remoteClass = value;
			}
		}
		
		public function getInWorkerProxy(...args):InWorker_Proxy{
			var proxy : InWorker_Proxy = new InWorker_Proxy();
			proxy._setInWorker_Proxy(this,args);
			return proxy;
		}
		
		/**
		 * builds a remote instance of the object 
		 * blocks until we get the remote object uid
		 * @param args
		 * @return 
		 * 
		 */
		protected function build_Remote(...args):String{
			try{
				var className		: String 			= getQualifiedClassName(_remoteClass);
				className = className.replace("::",".");
			
				var id1				: String			= callbackOnChannelAsUUid();
				var replyChannel 	: MessageChannel	= _worker.getSharedProperty(id1) as MessageChannel;
				var id2				: String			= callbackOnChannelAsUUid();
				var remoteArgs 		: Array 			= ["workerCallback","build_Object",className,id1,id2];
				
				remoteArgs	= remoteArgs.concat(args);
				
				requestChannel.send(remoteArgs);
				_remoteHandle 							= replyChannel.receive(true);
			} catch (error:Error){
				trace(error.getStackTrace());
			}
			_worker.setSharedProperty(id1,null);
			replyChannel.close();
			return _remoteHandle;
		}
		
		public function get remoteHandle():String
		{
			return _remoteHandle;
		}
		
		public function set remoteHandle(aUuid:String):void
		{
			_remoteHandle = aUuid;
		}
		
		public function get requestChannel():MessageChannel
		{
			return WorkerManager.getRequestChannel(_worker);
			//return _worker.getSharedProperty(_workerRequestChannelID);
			//return _worker.getSharedProperty("requestChannel");
		}
		
		protected function blockingChannel(callBackChannelUid:String):MessageChannel
		{
			var _callbackChannel			: MessageChannel 	= _worker.createMessageChannel(Worker.current);
			channelDictionary[_callbackChannel] = callBackChannelUid;
			_worker.setSharedProperty(callBackChannelUid,_callbackChannel);
			return _callbackChannel;
		}
		
		/**
		 * creates a callback channel used either for result of events
		 * @param callback a function(event:Event):void
		 * @return 
		 * 
		 */
		protected function callbackOnChannelAsUUid(callback:Function = null, uid:String = null):String
		{
			var _callbackChannel			: MessageChannel 	= _worker.createMessageChannel(Worker.current);
			
			if(callback !=null){
				_callbackChannel.addEventListener(Event.CHANNEL_MESSAGE,callback);
			}
			var callBackChannelUid			: String			= uid;
			if(callBackChannelUid == null){
				callBackChannelUid= UIDUtil.createUID();
			}
			channelDictionary[_callbackChannel] = callBackChannelUid;
			_worker.setSharedProperty(callBackChannelUid,_callbackChannel);
			return callBackChannelUid;
		}
		
		protected function onChannelClosed(event:Event):void{
			trace((event.currentTarget as MessageChannel).state)
		}
		
		protected function applyOnWorker(functionName:String,onCallback:Function,onEvent:Function,...args):void{
			var remoteArgs : Array;
			try{
				remoteArgs = ["applyOnRemoteObject",functionName,"this",callbackOnChannelAsUUid(onCallback),callbackOnChannelAsUUid(onEvent)];
				remoteArgs = remoteArgs.concat(args);
				requestChannel.send(remoteArgs);
			} catch(error:Error){
				if(remoteArgs){
					remoteArgs[2] = onCallback;
					remoteArgs[3] = onEvent;
					delayedExecutionQueue.push(remoteArgs);
				}
			}
		}
		
		/**
		 * applies functionName with args on remoteObject known by its uuid
		 * gets the callback and the event (used to track a process status) responses on callback functions
		 * non blocking
		 * 
		 * @param functionName
		 * @param onCallback
		 * @param onEvent
		 * @param remoteObjectUid
		 * @param args
		 * 
		 */
		protected function applyOnRemote(functionName:String,onCallback:Function,onEvent:Function,...args):void{
			var remoteArgs : Array;
			var callbackChannelUid 	: String = callbackOnChannelAsUUid(onCallback);
			var eventChannelUid		: String = callbackOnChannelAsUUid(onEvent);
			
			try{
				remoteArgs = ["applyOnRemoteObject",functionName,_remoteHandle,callbackChannelUid,eventChannelUid];
				remoteArgs = remoteArgs.concat(args);
				requestChannel.send(remoteArgs);
			} catch(error:Error){
				
			}
			
		}
		
		protected function applyOnRemoteAndBlockUntilReturn(functionName:String,onCallback:Function,onEvent:Function,...args):*{
			var remoteArgs 			: Array;
			var result				: * ;
			try{
				var callBackChannelUid	: String 			= UIDUtil.createUID();
				var callbackChannel 	: MessageChannel 	= blockingChannel(callBackChannelUid);
				remoteArgs = ["applyOnRemoteObject",functionName,_remoteHandle,callBackChannelUid,null];
				remoteArgs = remoteArgs.concat(args);
				requestChannel.send(remoteArgs);
				result 									= callbackChannel.receive(true);
				_worker.setSharedProperty(callBackChannelUid,null);
				delete channelDictionary[callbackChannel];
				callbackChannel.close();
			} catch(error:Error){
				
			} finally {
				
			}
			return result;
		}
		
		/**
		 * gets the result from a remote object, blocks until it receives.
		 *  
		 * @param functionName
		 * @param remoteObjectUid
		 * @param args
		 * @return 
		 * 
		 */
		protected function getRemoteValue(functionName:String):*{
			var result : * = null;
			try{
				
				var callbackChannel			:  MessageChannel 	= _worker.createMessageChannel(Worker.current);
				var callBackChannelUid			: String			= UIDUtil.createUID();
				_worker.setSharedProperty(callBackChannelUid,callbackChannel);
				var remoteArgs 					: Array 			= ["getRemoteObjectValue",functionName,_remoteHandle,callBackChannelUid,null];
				requestChannel.send(remoteArgs);
				result = callbackChannel.receive(true);
			} catch(error:Error){
				
			}
			_worker.setSharedProperty(callBackChannelUid,null);
			delete channelDictionary[callbackChannel];
			callbackChannel.close();
			return result;
		}
		
		protected function setRemoteValue(functionName:String,value:*):void{
			var remoteArgs 					: Array 			= ["setRemoteObjectValue",functionName,_remoteHandle,null,null,value];
			requestChannel.send(remoteArgs);
		}
		
		private function executeDelayedQueue():void{
			while(delayedExecutionQueue.length){
				var args	:	Array = delayedExecutionQueue.unshift() as Array;
				args[2] = callbackOnChannelAsUUid(args[2]);
				args[3] = callbackOnChannelAsUUid(args[3]);
				requestChannel.send(args);
			}
		}
		
		protected function removeChannel(channel:MessageChannel,callbackFunction:Function):void{
			var channelUid : String = channelDictionary[channel]
			_worker.setSharedProperty(channelUid,null);
			channel.removeEventListener(Event.CHANNEL_MESSAGE,callbackFunction);
			delete channelDictionary[channel];
			channel.close();
		}
		
		public function getResult(event:Event):*{
			var callbackChannel : MessageChannel = event.currentTarget as MessageChannel;
			var result : * = callbackChannel.receive();
			var channelUid : String = channelDictionary[callbackChannel];
			delete channelDictionary[callbackChannel];
			_worker.setSharedProperty(channelUid, null);
			callbackChannel.close();
			return result;
		}
		
	}
}