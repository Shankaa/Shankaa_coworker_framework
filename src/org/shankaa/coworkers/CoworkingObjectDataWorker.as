package org.shankaa.coworkers
{
	import flash.net.registerClassAlias;
	import org.shankaa.coworkers.example.CoworkingObjectExample;

	public class CoworkingObjectDataWorker extends DataWorker
	{
		public function CoworkingObjectDataWorker()
		{
			//TODO: implement function
			super();
		}
		
		protected override function initialize():void
		{	
			// register all the classes you need to pass from the main worker to this worker
			registerClassAlias("org.shankaa.coworkers.example", CoworkingObjectExample);
		}
	}
}