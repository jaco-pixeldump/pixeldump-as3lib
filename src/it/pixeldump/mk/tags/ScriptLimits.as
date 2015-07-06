
package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class ScriptLimits extends Tag {

		public function get CLASS_NAME():String{ return "ScriptLimits"; }


		public var maxRecursionDepth:uint;		// UI16 Maximum recursion depth
		public var scriptTimeoutSeconds:uint;	// UI16 Maximum ActionScript
												// processing time before
												// script stuck dialog box displays


		// the constructor
		function ScriptLimits(maxRecursionDepth:uint = 0, scriptTimeoutSeconds:uint = 0){

			this.maxRecursionDepth = maxRecursionDepth;
			this.scriptTimeoutSeconds = scriptTimeoutSeconds;
		}



		public override function toByteArray():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void {

			/* TODO */
			super.fromByteArray(ba);
			ba.position = 2;
			maxRecursionDepth = ba.readUnsignedShort();
			scriptTimeoutSeconds = ba.readUnsignedShort();
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " maxRecursionDepth=\"" +maxRecursionDepth +"\" ";
			xmlStr += " scriptTimeoutSeconds=\"" +scriptTimeoutSeconds +"\" ";
			xmlStr += " tagLength=\"" +_tagLength +"\" >";

			return xmlStr;
		}
	}
}