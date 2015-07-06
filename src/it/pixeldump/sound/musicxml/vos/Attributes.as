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

	public class Attributes {

		public var divisions:int;
		public var key:Key;
		public var time:Time;
		public var clef:Clef;

		function Attributes(divisions:int, key:Key, time:Time, clef:Clef){

			this.divisions = divisions;
			this.key = key;
			this.time = time;
			this.clef = clef;
		}
	}
}

