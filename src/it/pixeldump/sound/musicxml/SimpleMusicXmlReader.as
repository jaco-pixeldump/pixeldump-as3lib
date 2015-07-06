/**
 * @package musicxml library
 * @author jaco_at_pixeldump
 * @description read and "play" musicxml score files
 *
 * NOTE: this is a draft stage, much work has to be done
 * If you plan to use this stuff, don't strip this header!
 * released under gpl v.2 - http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 */

package it.pixeldump.sound.musicxml {

	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	import it.pixeldump.sound.musicxml.vos.*;

	public class SimpleMusicXmlReader implements IEventDispatcher {

		public static const SCORE_READY:String = "scoreReady";

		private var dispatcher:EventDispatcher;
		private var noCache:Boolean = true;
		private var ul:URLLoader;
		private var musicFile:String;

		public var work:Work;
		public var identification:Identification;
		public var partList:PartList;
		public var parts:Vector.<Part>;

		/**
		 * the constructor
		 */
		function SimpleMusicXmlReader(musicFile:String, noCache:Boolean = true){

			this.noCache = noCache;
			dispatcher = new EventDispatcher(this);

			if(!musicFile){
				throw new Error("please provide a valid path to the musicXML file");
			}
			else {

				this.musicFile = musicFile;
				var qsRnd:String = "";

				if(noCache) {
					qsRnd = "?c=" +getTimer();
					qsRnd += String.fromCharCode(Math.round(32 + Math.random() * 64));
					qsRnd += Math.round(Math.random() * 1000);
				}

				var ur:URLRequest = new URLRequest(musicFile +qsRnd);
				ul = new URLLoader();
				ul.addEventListener(Event.COMPLETE, onULComplete);
				ul.load(ur);
			}
		}

		private function onULComplete(evt:Event):void {
			var xmlDoc:XML = XML(ul.data);
			var wn:XMLList = xmlDoc..work;

			if(wn.length()){
				work = new Work(wn[0]["work-title"]);
			}

			var creatorName:String = "";
			var creatorType:String = "";
			var cn:XMLList = xmlDoc..creator;

			if(cn.length()){
				creatorName = cn[0].toString();
				creatorType = cn[0].@type;
			}

			var software:String = "";
			var encodingData:String = "";
			var en:XMLList = xmlDoc..encoding;

			if(en.length()){
				software = en[0].software.toString();
				encodingData = en[0]["encoding-data"].toString();
			}

			var encoding:Encoding = new Encoding(software, encodingData);

			identification = new Identification(creatorName, creatorType, encoding);

			var pn:XMLList = xmlDoc.child("part-list");

			if(pn.length()){

				var sp:XMLList = pn[0].child("score-part");
				var scoreParts:Vector.<ScorePart> =  new Vector.<ScorePart>(sp.length());
				var k:int = 0;

				for each(var spn:XML in sp){
					var spID:String = spn.@id;
					var partName:String = spn["part-name"].toString();

					var sin:XML = spn["score-instrument"][0];
					var scoreInstrument:ScoreInstrument = new ScoreInstrument("", "");

					if(sin.length()){
						scoreInstrument.id = sin.@id;
						scoreInstrument.instrumentName = sin["instrument-name"].toString();
					}

					var min:XML = spn["midi-instrument"][0];
					var midiInstrument:MidiInstrument = new MidiInstrument("", 0, 0);

					if(min.length()){
						midiInstrument.id = min.@id;
						midiInstrument.midiChannel = parseInt(min["midi-channel"]);
						midiInstrument.midiProgram = parseInt(min["midi-program"]);
					}

					var scorePart:ScorePart = new ScorePart(spID, partName, scoreInstrument, midiInstrument);
					scoreParts[k++] = scorePart;
				}

				partList = new PartList(scoreParts);

				var pns:XMLList = xmlDoc..part;

				parts = new Vector.<Part>(pns.length());
				k = 0;

				for each(var partNode:XML in pns){

					var partID:String = partNode.@id;
					var mns:XMLList = partNode..measure;
					var measures:Vector.<Measure> = new Vector.<Measure>(mns.length());

					var j:int = 0;

					for each(var mn:XML in mns){

						var measureNumber:int = parseInt(mn.@id);

						var nns:XMLList = mn..note;
						var notes:Vector.<Note> = new Vector.<Note>(nns.length());
						var m:int = 0;

						for each(var nn:XML in nns){

							var step:String = "rest";
							var octave:int = 0;
							var alter:int = 0;

							if(nn..pitch[0]){
								var pitchNode:XML = nn..pitch[0];

								if(pitchNode.step) step = pitchNode.step.toString();
								if(pitchNode.octave) octave = parseInt(pitchNode.octave);


								if(pitchNode.alter) alter = parseInt(pitchNode.alter);
							}

							trace("step:", step);
							var pitch:Pitch = new Pitch(step, octave, alter);

							var noteDuration:int = parseInt(nn.duration);
							var noteVoice:int = parseInt(nn.voice);
							var noteType:String = nn.type.toString();

							var note:Note = new Note(pitch, noteDuration, noteVoice, noteType);

							if(nn.accidental)
								note.accidental = nn.accidental.toString();

							if(nn.stem)
								note.stem = nn.stem.toString();

							notes[m++] = note;
						}

						var measure:Measure = new Measure(measureNumber, notes);

						var an:XMLList = mn..attributes;

						if(an.length()){
							var divisions:int = parseInt(an[0].divisions);

							var kn:XML = an..key[0];
							var key:Key = new Key(kn.fifths.toString(), kn.mode.toString());

							var tn:XML = an..time[0];
							var time:Time = new Time(parseInt(tn.beats), parseInt(tn["beat-type"]));

							var cln:XML = an..clef[0];
							var clef:Clef = new Clef(cln.sign.toString(), parseInt(cln.line));

							measure.attributes = new Attributes(divisions, key, time, clef);
						}

						measures[j++] = measure;
					}

					parts[k++] = new Part(partID, measures);
				}

			}

			if(dispatcher.hasEventListener(SCORE_READY)){
				dispatchEvent(new Event(SCORE_READY));
			}
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			if(type == SCORE_READY) dispatcher.addEventListener(type, listener, useCapture, priority);
		}

		public function dispatchEvent(evt:Event):Boolean{
			return dispatcher.dispatchEvent(evt);
		}

		public function hasEventListener(type:String):Boolean{
			return dispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
	}
}