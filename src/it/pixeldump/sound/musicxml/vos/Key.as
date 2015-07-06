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

	public class Key {

		public static const MODE_MAJOR:String = "major";
		public static const MODE_MINOR:String = "minor";

		public var fifths:int;
		public var mode:String;

		function Key(fiths:int, mode:String){

			this.fifths = fifths;
			this.mode = mode;
		}
	}
}

