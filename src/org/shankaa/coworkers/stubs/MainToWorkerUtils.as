package org.shankaa.coworkers.stubs
{
	import mx.collections.ArrayCollection;
	import mx.collections.ISort;
	import mx.collections.XMLListCollection;

	/**
	 * 
	 * @author Hugues Sansen, Shankaa
	 * The MainToWorkerUtils class is part of the coworkers framework.
	 * 
	 * we centralize the marshalling and unmarshalling of classes that fail to marshall automatically with standard Flash mechanism
	
	 * 
	 * Coworker is provided under the European Union Public Licence (EUPL)
	 */
	public class MainToWorkerUtils
	{
		
		public static function xmlListToArray(xList:XMLList):Array{
			if(xList == null){
				return null;
			}
			var arxl	: Array = new Array();
			var data	: Array = new Array();
			var header	: Array = [];
			arxl[0] = header;
			arxl[1] = data;
			for each(var x:XML in xList){
				data.push(x);
			}
			return arxl;
		}
		
		public static function xMLListCollectionToArray(coll:XMLListCollection):Array{
			if(coll == null){
				return null;
			}
			var array		: Array = [];
			var data		: Array = [];
			var sort		: ISort = coll.sort ;
			array[0] = sort;
			array[1] = data;
			for each(var x:XML in coll){
				data.push(x);
			}
			return array;
		}
		
		public static function arrayCollectionToArray(coll:ArrayCollection):Array{
			if(coll == null){
				return null;
			}
			var array		: Array = [];
			var data		: Array = [];
			var sort		: ISort = coll.sort ;
			array[0] = sort;
			for each (var o:* in coll){
				data.push(o);
			}
			array[1] = data;
			
			return array;
		}
		
		
		
		public static function arrayToXMLList(arxl:Array):XMLList{
			if(arxl == null){
				return null;
			}
			var xList	: XMLList = new XMLList();
			for each(var x:XML in arxl[1]){
				xList += x;
			}
			return xList;
		}
		
		public static function arrayToXMLListCollection(arxl:Array):XMLListCollection{
			if(arxl == null){
				return null;
			}
			var xList		: XMLList = new XMLList();
			var sort		: ISort = null;//arxl[0];
			for each(var x:XML in arxl[1]){
				xList += x;
			}
			var collection	: XMLListCollection 	= new XMLListCollection(xList);
			if(sort){
				collection.sort = sort;
				collection.refresh();
			}
			return collection;
		}
		
		public static function arrayToArrayCollection(array:Array):ArrayCollection{
			if(array == null){
				return null;
			}
			var xList		: XMLList = new XMLList();
			var sort		: ISort = null;//array[0];
			var collection	: ArrayCollection 	= new ArrayCollection(array[1]);
			if(sort){
				collection.sort = sort;
				collection.refresh();
			}
			return collection;
		}
		
		public static function marshallComplexObject(value:*):*{
			var passedValue : *	= value;
			if(value is XMLList){
				passedValue = MainToWorkerUtils.xmlListToArray(value as XMLList);
			} else if (value is XMLListCollection){
				passedValue = MainToWorkerUtils.xMLListCollectionToArray(value as XMLListCollection);
			} else if(value is ArrayCollection){
				passedValue = MainToWorkerUtils.arrayCollectionToArray(value as ArrayCollection);
			}
			return passedValue;
		}
		
		public static function unmarshallComplexObject(value:*,targetClass:Class):*{
			var passedValue : *	= value;
			if(value is Array){
				if(targetClass == XMLList){
					passedValue = arrayToXMLList(value);
				} else if(targetClass == XMLListCollection){
					passedValue = arrayToXMLListCollection(value);
				} else if(targetClass == ArrayCollection){
					passedValue = arrayToArrayCollection(value);
				}
			}
			return passedValue;
		}
	}
}