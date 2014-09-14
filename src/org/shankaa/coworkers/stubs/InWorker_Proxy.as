package org.shankaa.coworkers.stubs
{
	/**
	 * 
	 * @author Hugues Sansen, Shankaa
	 * 
	 * Inworker_Proxy gives a handle on an object running on a remote DataWorker that can be used in a stub as a reference to this remote object
	 * an Inworker_Proxy is usually used from the main worker but is can also be used between two remote workers...
	 * 
	 * var excelFileProxy 	: InWorker_Proxy;
	 * excelFileProxy = new InWorker_Proxy();
	 * excelFileProxy.setInWorker_Proxy(myExcelFile_Stub,["sheets",0]);
	 * anotherStub.doSomething(excelFileProxy)
	 *  
	 * Coworker is provided under the European Union Public Licence (EUPL)
	 */
	public class InWorker_Proxy
	{
		public var handle				: String;
		public var path					: Array;
		
		
		public function InWorker_Proxy()
		{
			
		}
		
		public function setInWorker_Proxy(stub:Stub,...args):void{
			this.handle = stub.remoteHandle;
			path = args;
		}
		
		public function _setInWorker_Proxy(stub:Stub,args:Array):void{
			this.handle = stub.remoteHandle;
			path = args;
		}
		
		
	}
}