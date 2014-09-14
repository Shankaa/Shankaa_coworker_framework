package org.shankaa.coworkers.example
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.MessageChannel;

	public class CoworkingObjectExample extends EventDispatcher implements InWorker_CoworkingObjectExample
	{
		
		private var _field0 : String;
		
		public function CoworkingObjectExample(initialValue:String)
		{
			_field0 = initialValue;
		}
		
		public function set field0(value:String):void
		{
			_field0 = value;
		}
		
		public function get field0():String
		{
			return _field0;
		}
		
		/**
		 * a function that does something and returns a value 
		 * @param arg0
		 * @return 
		 * 
		 */
		public function doSomethingBlockUntilReturn(arg0:String):String
		{
			// do some computation here
			dispatchEvent(new Event("coworkingObjectExempleIsDoingSomething"));
			
			return "this is an example";
		}
		
		public function doSomethingBlockUntilReturnInWorker(replyChannel:MessageChannel,eventChannel:MessageChannel,arg0:String):void{
			addEventListener("coworkingObjectExempleIsDoingSomething", onEvent);
			var onEvent : Function = function(event:Event):void{
				var eventObject : * = {};
				eventObject.type = event.type;
				eventChannel.send(eventObject);
			}
			var result : String = doSomethingBlockUntilReturn(arg0);
			replyChannel.send(result);
			removeEventListener("coworkingObjectExempleIsDoingSomething",onEvent);
		}
		
		/**
		 * a function that does something in the process where the object is and do not need to return a value to another process
		 * 
		 * @param arg0
		 * 
		 */
		public function doSomething(arg0:String):void
		{
			// do some computation here
			dispatchEvent(new Event("coworkingObjectExempleIsDoingSomething"));
		}
		
		public function doSomethingInWorker(replyChannel:MessageChannel,eventChannel:MessageChannel,arg0:String):void
		{
			addEventListener("coworkingObjectExempleIsDoingSomething", onEvent);
			var onEvent : Function = function(event:Event):void{
				var eventObject : * = {};
				eventObject.type = event.type;
				eventChannel.send(eventObject);
			}
			doSomething(arg0);
			removeEventListener("coworkingObjectExempleIsDoingSomething",onEvent);
		}
		
		
		
		
		/**
		 * a function that does soemthing and returns through a callback function
		 * 
		 * @param callbackFunction
		 * @param arg0
		 * 
		 */
		public function doSomethingDoNotBlock(callbackFunction:Function,arg0:String):void
		{
			var valueToReturn : String;
			// do some computation here
			valueToReturn = "this is an example with "+ arg0;
			dispatchEvent(new Event("coworkingObjectExempleIsDoingSomething"));
			callbackFunction(valueToReturn);
		}
		
		/**
		 * inWorker function associated with the doSomethingDoNotBlock function
		 * 
		 * 
		 * @param replyChannel
		 * @param eventChannel
		 * @param callbackFunction should be null. Is here just to have the same arguments in both local and inWorker functions
		 * @param arg0
		 * 
		 */
		public function doSomethingDoNotBlockInWorker(replyChannel:MessageChannel,eventChannel:MessageChannel,callbackFunction:Function,arg0:String):void
		{
			addEventListener("coworkingObjectExempleIsDoingSomething", onEvent);
			var onEvent : Function = function(event:Event):void{
				var eventObject : * = {};
				eventObject.type = event.type;
				eventChannel.send(eventObject);
			}
			
			var onCallBack : Function = function(arg:String):void{
				replyChannel.send(arg);
				removeEventListener("coworkingObjectExempleIsDoingSomething",onEvent);
			}
			doSomethingDoNotBlock(onCallBack,arg0);
		}
	}
}