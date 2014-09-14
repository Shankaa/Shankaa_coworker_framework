package org.shankaa.coworkers.example
{
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	import org.shankaa.coworkers.WorkerManager;

	public class Example
	{
		
		private var remoteWorker			: Worker;
		private var requestChannel 			: MessageChannel;
		private var coworkingObjectExample 	: Stub_CoworkingObjectExample
		
		public function Example()
		{
			preinitialize();
			initialize();
		}
		
		protected function preinitialize():void
		{
			var xlsWorkerId : int = 1;
			remoteWorker = WorkerManager.initializeExcelDataWorker(xlsWorkerId,Worker.current);
			requestChannel = Worker.current.createMessageChannel(remoteWorker);
			requestChannel.addEventListener(Event.CHANNEL_STATE,onRequestChannelState);
			remoteWorker.setSharedProperty("requestChannel",requestChannel);
			remoteWorker.start();
		}
		
		protected function initialize():void{
			coworkingObjectExample = new Stub_CoworkingObjectExample(remoteWorker,"initialValue");
		}
		
		protected function onRequestChannelState(event:Event):void{
			trace("requestChannel state",(event.currentTarget as MessageChannel).state)
		}
		
		protected function doSomethingOnRemote(arg0:String):void{
			coworkingObjectExample.doSomething(arg0);
		}
		
		protected function doSomethingBlockUntilReturnOnRemote(arg0:String):void{
			var returnedValue : String = coworkingObjectExample.doSomethingBlockUntilReturn(arg0);
			trace("Example","doSomethingBlockUntilReturnOnRemote","value:", returnedValue);
		}
		
		protected function doSomeThingDoNotBlockOnRemote(arg0:String):void{
			var onCallback			: Function			= function(event:Event):void{
				var returnedValue	: String			= (event.currentTarget as MessageChannel).receive();
				trace("Example","doSomeThingDoNotBlockOnRemote","value:", returnedValue);
			}
			coworkingObjectExample.doSomeThingDoNotBlock(onCallback,arg0);
		}
	}
}