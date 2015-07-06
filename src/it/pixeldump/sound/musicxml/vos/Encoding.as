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

	public class Encoding {

		public var software:String;
		public var encodingDate:String;

		function Encoding(software:String, encodingDate:String){
			this.software = software;
			this.encodingDate = encodingDate;
		}
	}
}


