
package it.pixeldump.mk {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	import it.pixeldump.mk.tags.*;
	import it.pixeldump.mk.struct.*;

	public class Frame {

		public var frameNumber:uint;
		public var tagList:Array;

		function Frame(frameNumber:uint = 1){
			this.frameNumber = frameNumber;
			tagList = new Array();
		}


		public function add_tag(tag:Tag):void{

			tagList.push(tag);
		}

		//
		public function replace_tag(tagIndex:uint, tag:Tag):void{

			if(tagIndex < tagList.length) tagList[tagIndex] = tag;
		}

		//
		public function get_tagAt(tagIndex:uint):Tag{

			var tCount:uint = tagList.length;

			if(tCount <= tagIndex) return null;

			return tagList[tagIndex];
		}

		//
		public function frame_is_empty():Boolean{
			return (tagList.length) ? true : false;
		}
	}
}
