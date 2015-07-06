
package it.pixeldump.sound.musicxml.vos {

	public class Pitch {

		public var step:String;	// e.g. C
		public var octave:int; 	// e.g. 5
		public var alter:int = 0;	// 0 = none, 1 = sharp, -1 moll

		function Pitch(step:String, octave:int, alter:int = 0){
			this.step = step;
			this.octave = octave;
			this.alter = alter;
		}
	}
}