/**
 * @package musicxml library
 * @author jaco_at_pixeldump
 * @description part of lib
 *
 * NOTE: this is a draft stage, much work has to be done
 * If you plan to use this stuff, don't strip this header!
 * released under gpl v.2 - http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 */
package it.pixeldump.sound.musicxml.vos {

	public class Identification {

		public var creator:String;
		public var creatorType:String;
		public var encoding:Encoding;


		function Identification(creator:String, creatorType:String, encoding:Encoding){
			this.creator = creator;
			this.creatorType = creatorType;
			this.encoding = encoding;
		}
	}
}