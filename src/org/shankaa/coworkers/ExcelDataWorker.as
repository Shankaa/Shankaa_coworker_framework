package org.shankaa.coworkers
{
	import flash.net.registerClassAlias;
	
	import org.as3.ms.xls.Cell;
	import org.as3.ms.xls.ExcelFile;
	import org.as3.ms.xls.Sheet;

	public class ExcelDataWorker extends DataWorker
	{
		public function ExcelDataWorker()
		{
			super();
		}
		
		protected override function initialize():void
		{	
			// register all the classes you need to pass from the main worker to this worker
			registerClassAlias("org.as3.ms.xls.ExcelFile", ExcelFile);
			registerClassAlias("org.as3.ms.xls.Sheet", Sheet);
			registerClassAlias("org.as3.ms.xls.Cell", Cell);
		}
	}
}