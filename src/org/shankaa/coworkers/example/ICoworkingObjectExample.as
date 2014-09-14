package org.shankaa.coworkers.example
{
	public interface ICoworkingObjectExample
	{
		function set field0(value:String):void;
		
		function get field0():String;
		
		function doSomethingBlockUntilReturn(arg0:String):String;
		
		function doSomething(arg0:String):void
		
		function doSomeThingDoNotBlock(callbackFunction:Function,arg0:String):void;
		
	}
}