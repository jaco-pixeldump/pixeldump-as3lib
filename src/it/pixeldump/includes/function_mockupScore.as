
public function mockupScore():void {

	var ba:ByteArray = new Abc01() as ByteArray;
	var str:String = ba.readUTFBytes(ba.length);
	var abci:ABCImporter = new ABCImporter();

	abci.baseOctave = 4;
	abci.instrumentName = "Violin";
	abci.parseABC(str);

	_lm.score = abci.score;
	_lm.score.settings.numBarsPerStaff = 4;
	_lm.score.settings.notationSystem = ScoreSettingsVO.NOTATION_TRADITIONAL;
	_lm.score.settings.numberingBars = ScoreSettingsVO.NUMBERING_BAR_EACH_BAR;
	_lm.score.settings.beamSettings.numBeatsGrouping = 2;
	_lm.score.settings.tempoNotation = TempoVO.NOTATION_TEACHING;
	_lm.score.parts[0].barGroups[0].bars[0].tempo.notation =  _lm.score.settings.tempoNotation;
	_lm.score.settings.pageLayout.instrumentLabelDisplay = PageLayoutVO.INSTRUMENTLABEL_DISPLAY_NEVER;

	redraw();
}