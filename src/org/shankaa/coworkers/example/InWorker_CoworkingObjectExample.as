package org.shankaa.coworkers.example
{
	import flash.system.MessageChannel;

	public interface InWorker_CoworkingObjectExample extends ICoworkingObjectExample
	{
		function doSomethingBlockUntilReturnInWorker(replyChannel:MessageChannel,eventChannel:MessageChannel,arg0:String):String;
		
		function doSomethingInWorker(replyChannel:MessageChannel,eventChannel:MessageChannel,arg0:String):void
		
		function doSomeThingDoNotBlockInWorker(replyChannel:MessageChannel,eventChannel:MessageChannel,callbackFunction:Function,arg0:String):void;
	}
}