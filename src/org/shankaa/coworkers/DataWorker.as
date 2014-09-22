package org.shankaa.coworkers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.getClassByAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.Dictionary;
	
	import mx.utils.UIDUtil;
	
	import org.shankaa.coworkers.stubs.InWorker_Proxy;
	import org.shankaa.coworkers.stubs.MainToWorkerUtils;
	
	/**
	 * 
	 * @author Hugues Sansen, Shankaa
	 * 
	 * Coworker is provided under the European Union Public Licence (EUPL)
	 * 
	 */
	public class DataWorker extends Sprite
	{
		public static const DEFAULT_REQUEST_CHANNEL_ID	: String	= "requestChannel";
		
		private var localObjects						: Dictionary = new Dictionary();
		private var requestChannel						: MessageChannel;
		
		private var _name								: String = UIDUtil.createUID();
		
		private var _requestChannelID					: String = DEFAULT_REQUEST_CHANNEL_ID;
		
		private function set requestChannelID(value:String):void{
			_requestChannelID = value;
			initialize();
		}
		
		private function get requestChannelID():String{
			return _requestChannelID;
		}
		
		
		public function DataWorker()
		{
			initialize();
			
		}
		
		/**
		 * should be overridden to register class aliases
		 * 
		 * creates all the channels
		 * 
		 */
		private function initialize():void
		{	
			
			try{
				initializeAliases();
				
				requestChannel	= Worker.current.getSharedProperty(requestChannelID) as MessageChannel;
				requestChannel.addEventListener(Event.CHANNEL_MESSAGE,onInputHandler);
				
				postInitialize();
			} catch (error:Error){
				trace(error.getStackTrace());
			}
			
		}
		
		/**
		 * 
		 * called at the begining of the initialize function
		 * all subclasses should implement this function
		 * 
		 * override this function with class aliases registration
		 * registerClassAlias("org.example.MyObject",MyObject);
		 * 
		 */
		protected function initializeAliases():void{
			
		}
		
		/**
		 *  called at the end of the initialize function
		 * 
		 */
		protected function postInitialize():void{
			
		}
		
		/**
		 * received serialized objects must have a constructor without arguments.
		 * only attributes or setters that are public can be passed by the  AMF3 unmarshalling mechanism
		 * 
		 *  
		 * @param event
		 * 
		 */
		
		private function onInputHandler(event:Event):void{
			var request			: Array = requestChannel.receive();
			var requestType		: String	= (request as Array).shift();
			request[2]						= Worker.current.getSharedProperty(request[2] as String) as MessageChannel;
			request[3]						= Worker.current.getSharedProperty(request[3] as String) as MessageChannel;
			var i 				: int 		= 4;
			var local			: *	;
			while(i<request.length){
				var o : * = request[i];
				try{
					if( o is InWorker_Proxy){
						var uid : String = o.handle;
						request[i] = indexOnLocal(uid,o.path);
					}
				} catch (error:Error){
					
				}
				++i;
			}
			
			switch(requestType){
				case "workerCallback":
					onCallback(request);
					break;
				case "getObjectByUuid":
					onGetObjectByUuid(request);
					break;
				case "applyOnRemoteObject":
					onApplyOnLocalObject(request);
					break;
				case "getRemoteObjectValue":
					onGetRemoteObjectValue(request);
					break;
				case "setRemoteObjectValue":
					onSetRemoteObjectValue(request);
					break;
				
				//following cases are for tests....
				case "test0":
					trace("request channel test0 on DataWorker ok");
					break;
				case "test1":
					trace("request channel test1 on DataWorker ok");
					break;
				case "test2":
					trace("request channel test2 on DataWorker ok");
					break;
				case "test3":
					trace("request channel test3 on DataWorker ok");
					break;
			}
		}
		
		
		protected function setName(replyChannel:MessageChannel,eventChannel:MessageChannel,name:String):void{
			_name = name;
		}
		
		
		protected function getName(replyChannel:MessageChannel,eventChannel:MessageChannel):void{
			replyChannel.send(_name);
		}
		
		
		protected function build_Object(className:String,replyChannel:MessageChannel,eventChannel:MessageChannel,args:Array=null):void{
			var uuid 			: String 			= UIDUtil.createUID();
			var objectClass		: Class				= getClassByAlias(className);
			
			var funArgs			: Array				= args == null?[]:args;
			switch(funArgs.length){
				case 0:
					localObjects[uuid]	= new objectClass();
					break;
				case 1:
					localObjects[uuid]	= new objectClass(funArgs[0]);
					break;
				case 2:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1]);
					break;
				case 3:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1],funArgs[2]);
					break;
				case 4:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1],funArgs[2],funArgs[3]);
					break;
				case 5:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1],funArgs[2],funArgs[3],funArgs[4]);
					break;
				case 6:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1],funArgs[2],funArgs[3],funArgs[4],funArgs[5]);
					break;
				case 7:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1],funArgs[2],funArgs[3],funArgs[4],funArgs[5],funArgs[6]);
					break;
				case 8:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1],funArgs[2],funArgs[3],funArgs[4],funArgs[5],funArgs[6],funArgs[7]);
					break;
				case 9:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1],funArgs[2],funArgs[3],funArgs[4],funArgs[5],funArgs[6],funArgs[7],funArgs[8]);
					break;
				case 10:
					localObjects[uuid]	= new objectClass(funArgs[0],funArgs[1],funArgs[2],funArgs[3],funArgs[4],funArgs[5],funArgs[6],funArgs[7],funArgs[8],funArgs[9]);
					break;
			}
			
			replyChannel.send(uuid);
		}
		
		/**
		 * args : functionName, replyChannel, eventChannel, the rest of args to apply to the function
		 * 
		 * a generic way to call a method
		 * @param args
		 * 
		 */
		private function onCallback(args:Array):void{
			var data				: Array 			= args.concat();
			var replyFunctionName 	: String 			= data.shift();
			(this[replyFunctionName] as Function).apply(this,data);
		}
		
		private function onApplyOnLocalObject(args:Array):void{
			var data				: Array 			= args.concat();
			var replyFunctionName 	: String 			= data.shift();
			var uuid 				: String 			= data.shift() as String;
			var object				: *	;
			if(uuid == "this"){
				object = this;
			} else {
				object = localObjects[uuid];
			}
			(object[replyFunctionName] as Function).apply(object,data);
		}
		
		private function onGetObjectByUuid(args:Array):void{
			var data				: Array 			= args.concat();
			var uuid 				: String 			= data.shift() as String;
			var object				: *					= localObjects[uuid];
			var replyChannelUid		: String			= data.shift() as String;
			var replyChannel		:  MessageChannel	= Worker.current.getSharedProperty(replyChannelUid);
			replyChannel.send(object);
		}
		
		private function indexOnLocal(knownIndex:String,accessToLocal:Array):*{
			var object				: *					= localObjects[knownIndex];
			var result				: *					;
			switch(accessToLocal.length){
				case 0:
					result = object;
					break;
				case 1:
					result = object[accessToLocal[0][0]][accessToLocal[0][1]];
					break;
				case 2:
					result = object[accessToLocal[0][0]][accessToLocal[0][1]][accessToLocal[0][2]];
					break;
			}
			
			return result;
		}
		
		private function onSetWorkerFieldValue(args:Array):void{
			var data				: Array 			= args.concat();
			var functionName		: String			= data.shift() as String;
			// we shift the channels that are supposed to be null
			data.shift();
			data.shift();
			var value				: *					= data.shift() ;
			this[functionName] 							= value;
		}
		
		private function onGetWorkerFieldValueValue(args:Array):void{
			var data				: Array 			= args.concat();
			var functionName		: String			= data.shift() as String;
			var replyChannel		: MessageChannel	= data.shift() as MessageChannel;
			var result				: *					= MainToWorkerUtils.marshallComplexObject(this[functionName]);
			replyChannel.send(result);
		}
		
		private function onGetRemoteObjectValue(args:Array):void{
			var data				: Array 			= args.concat();
			var functionName		: String			= data.shift() as String;
			var uuid 				: String 			= data.shift() as String;
			var object				: * ;
			if(uuid == "this"){
				object = this;
			} else {
				object = localObjects[uuid];
			}
			var replyChannel		: MessageChannel	= data.shift() as MessageChannel;
			var result				: *					= MainToWorkerUtils.marshallComplexObject(object[functionName]);
			replyChannel.send(result);
		}
		
		private function onSetRemoteObjectValue(args:Array):void{
			var data				: Array 			= args.concat();
			var functionName		: String			= data.shift() as String;
			var uuid 				: String 			= data.shift() as String;
			var object				: * ;
			if(uuid == "this"){
				object = this;
			} else {
				object = localObjects[uuid];
			}
			// we shift the channels that are supposed to be null
			data.shift();
			data.shift();
			var value				: *					= data.shift() ;
			object[functionName] 						= value;
		}
	}
}

