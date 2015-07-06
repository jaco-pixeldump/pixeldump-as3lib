
/**
 * @author jaco
 *
 * created on 2/26/2010 11:10:01 PM
 */
package it.pixeldump.svg.font.vos {

	/**
	 * kenrning pair data
	 * field names are accurate to reflect their names in the original svg data
	 */
	public class KerningPair {

		private var _g1:String;
		private var _g2:String;
		private var _k:Number;

		/**
		 *
		 */
		public function get g1():String {
			return _g1;
		}

		/**
		 *
		 */
		public function get g2():String {
			return _g2;
		}

		/**
		 *
		 */
		public function get k():Number {
			return _k;
		}

		/**
		 * the constructor
		 */
		function KerningPair(g1:String, g2:String, k:Number){

			_g1 = g1;
			_g2 = g2;
			_k = k;
		}

		public function match(ch1:String, ch2:String):Number {
			return (ch1 == _g1 && ch2 == _g2) ? _k : 0;
		}
	}

}
