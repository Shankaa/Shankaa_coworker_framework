package org.shankaa.coworkers
{
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.Dictionary;
	

	/**
	 * 
	 * @author Hugues Sansen, Shankaa
	 * 
	 * The WorkerManager is part of the coworkers frameworker.
	 * We centralize the creation of workers here.
	 * Why? Because most of the time the worker swf tend to grow at each clean and compilation.
	 * If you experience the issue,
	 * - remove all the workers in the application properties window.
	 * - comment the line
	 * 			dataWorker 			= WorkerDomain.current.createWorker(Workers.org_shankaa_coworkers_DataWorker,true);
	 * - clean your code and compile,
	 * - declare you worker classes as workers,
	 * - clean and compile,
	 * - uncomment the worker declaration lines,
	 * - clean and compile again...
	 * 
	 * 
	 *  Coworker is provided under the European Union Public Licence (EUPL)
	 * 
	 */
	public final class WorkerManager
	{
		
		public static const WORKER_IDS		: Dictionary = new Dictionary();
		
		
		/**
		 * creates a worker running a DataWorker instance
		 * 
		 * @param workerNumber
		 * @param requestWorker
		 * @return 
		 * 
		 */
		public static function initializeExcelDataWorker(workerNumber : int, requestWorker:Worker):Worker{
			var dataWorker 		: Worker;
			var requestChannel	: MessageChannel;
			
			dataWorker 			= WorkerDomain.current.createWorker(Workers.org_shankaa_coworkers_ExcelDataWorker,true);
			requestChannel = requestWorker.createMessageChannel(dataWorker);
			dataWorker.setSharedProperty("requestChannel",requestChannel);
			WORKER_IDS[dataWorker] = requestChannel;
			
			return dataWorker;
		}
		
		public static function getRequestChannel(remoteWorker:Worker):MessageChannel{
			var requestChannel 		: MessageChannel 	= WORKER_IDS[remoteWorker];
			return requestChannel;
		}
	}
}