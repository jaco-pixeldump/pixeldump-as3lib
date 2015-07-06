
package it.pixeldump.mk {

	import flash.utils.*;

	public interface ITaggable {

		function set tagID(value:uint):void;
		function get tagID():uint;

		function fromByteArray(ba:ByteArray):void;
		function toByteArray():ByteArray;

		function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String;
	}
}