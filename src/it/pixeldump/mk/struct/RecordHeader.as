
package it.pixeldump.mk.struct {

	public class RecordHeader {

		public var tagID:uint;
		public var tagLength:uint;
		public var tagSL:Boolean;

		function RecordHeader(tagID:uint = 0, tagLength:uint = 0, tagSL:Boolean = false){
			this.tagID = tagID;
			this.tagLength = tagLength;
			this.tagSL = tagSL;
		}
	}

}