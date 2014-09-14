package org.shankaa.coworkers.stubs
{
	import flash.system.MessageChannel;
	import flash.system.Worker;

	public interface I_Interface
	{
		function get remoteHandle():String;
		
		function set remoteHandle(aUuid:String):void;
		
		function set remoteWorker(value:Worker):void;
		
		function get remoteWorker():Worker;
		
		function get requestChannel():MessageChannel;
		
	}
}