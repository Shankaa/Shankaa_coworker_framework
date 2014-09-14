package org.shankaa.coworkers.example
{
	import flash.events.Event;
	import flash.system.Worker;
	
	import org.shankaa.coworkers.stubs.Stub;

	public class Stub_CoworkingObjectExample extends Stub implements ICoworkingObjectExample
	{
		/**
		 * creates a Stub on the main process side and connect it to a new CoworkingObjectExample object in the remoteWorker
		 * @param remoteWorker a worker set with a DataWorker class
		 * @param initialValue
		 * 
		 */
		public function Stub_CoworkingObjectExample(remoteWorker:Worker,initialValue:String)
		{
			super(remoteWorker,CoworkingObjectExample,initialValue);
		}
		
		public function set field0(value:String):void
		{
			setRemoteValue("field0",value);
		}
		
		public function get field0():String
		{
			return getRemoteValue("field0");
		}
		
		public function doSomethingBlockUntilReturn(arg0:String):String
		{
			//if you do not need to catch the event, onEventFunction can be null
			var onEventFunction:Function = function(eventObject:*):void{
				var eventType : String = eventObject.type;
				dispatchEvent(new Event(eventType));
			}
			var result : * = applyOnRemoteAndBlockUntilReturn("computeCustomerProfileDataInCube"+"InWorker",null,onEventFunction,arg0) ;
			return result;
		}
		
		public function doSomething(arg0:String):void
		{
			//if you do not need to catch the event, onEventFunction can be null
			var onEventFunction:Function = function(eventObject:*):void{
				var eventType : String = eventObject.type;
				dispatchEvent(new Event(eventType));
			}
			applyOnRemote("doSomething"+"InWorker",null,onEventFunction,arg0);
		}
		
		public function doSomeThingDoNotBlock(callbackFunction:Function,arg0:String):void
		{
			//if you do not need to catch the event, onEventFunction can be null
			var onEventFunction:Function = function(eventObject:*):void{
				var eventType : String = eventObject.type;
				dispatchEvent(new Event(eventType));
			}
			applyOnRemote("doSomeThingDoNotBlock"+"InWorker",callbackFunction,onEventFunction,arg0:String,);
		}
	}
}