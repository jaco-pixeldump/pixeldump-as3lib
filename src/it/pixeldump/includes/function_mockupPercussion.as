
public function mockupPercussion():void {

	Config.getInstance().updateSettingsFromPreference();

	_lm.score = new ScoreVO();
	_lm.score.settings = Config.getInstance().scoreSettings;
	_lm.score.settings.notationSystem = ScoreSettingsVO.NOTATION_PERCUSSION;
	//_lm.score.settings.numBarsPerStaff = 4;
	_lm.score.settings.barAutoStretch = true;
	_lm.score.settings.numberingBars = ScoreSettingsVO.NUMBERING_BAR_EACH_BAR;
	_lm.score.settings.beamSettings.numBeatsGrouping = 2;
	_lm.score.settings.tempoNotation = TempoVO.NOTATION_TEACHING;
	//_lm.score.settings.pageLayout.instrumentLabelDisplay = PageLayoutVO.INSTRUMENTLABEL_DISPLAY_NEVER;

	var p:PartVO = new PartVO();
	p.settings.instrument = Config.getInstance().configurationManager.getInstrumentByName("Slap");
	p.createInitialClefByIndex(14);
	p.createInitialTempoByName("4/4");
	p.createInitialTuneByKeyModal("cmaj");

	//
	var noteIndex:int = 0;
	p.createEmptyBars();

	var t:TriggerVO = new TriggerVO();
	t.duration = Lookups.DURATIONS.minima;
	NoteUtil.addTriggerAt(p.barGroups[1], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.semiminima;
	NoteUtil.addTriggerAt(p.barGroups[1], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	NoteUtil.addTriggerAt(p.barGroups[1], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.semicroma;
	NoteUtil.addTriggerAt(p.barGroups[1], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.semicroma;
	NoteUtil.addTriggerAt(p.barGroups[1], t, 0, 0, noteIndex++);

	NoteUtil.removeTriggerAt(p.barGroups[1], 0, 0, noteIndex);

	//
	noteIndex = 0;
	p.createEmptyBars();

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.semiminima;
	t.pitch = "C5";
	t.noteHeadType = TriggerVO.NOTEHEAD_DO;
	var l:LyricsVO = new LyricsVO();
	l.type = LyricsVO.POSITION_BOTTOM;
	l.text = "qui";
	t.addLyricsAt(l);

	NoteUtil.addTriggerAt(p.barGroups[2], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.semiminima;
	t.pitch = "C5";
	l = new LyricsVO();
	l.type = LyricsVO.POSITION_BOTTOM;
	l.text = "quo";
	t.addLyricsAt(l);
	NoteUtil.addTriggerAt(p.barGroups[2], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.minima;
	t.pitch = "C5";
	t.noteHeadType = TriggerVO.NOTEHEAD_DO;
	l = new LyricsVO();
	l.type = LyricsVO.POSITION_BOTTOM;
	l.text = "qua";
	t.addLyricsAt(l);
	NoteUtil.addTriggerAt(p.barGroups[2], t, 0, 0, noteIndex++);

	NoteUtil.removeTriggerAt(p.barGroups[2], 0, 0, noteIndex);

	//
	noteIndex = 0;
	p.createEmptyBars();

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.pitch = "C5";
	t.noteHeadType = TriggerVO.NOTEHEAD_CROSS;
	NoteUtil.addTriggerAt(p.barGroups[3], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.noteHeadType = TriggerVO.NOTEHEAD_CROSS;
	NoteUtil.addTriggerAt(p.barGroups[3], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.pitch = "C5";
	t.stem = TriggerVO.STEM_UP;
	t.noteHeadType = TriggerVO.NOTEHEAD_CROSS;
	NoteUtil.addTriggerAt(p.barGroups[3], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.noteHeadType = TriggerVO.NOTEHEAD_CROSS;
	NoteUtil.addTriggerAt(p.barGroups[3], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.pitch = "C5";
	t.noteHeadType = TriggerVO.NOTEHEAD_CROSS;
	NoteUtil.addTriggerAt(p.barGroups[3], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.noteHeadType = TriggerVO.NOTEHEAD_CROSS;
	NoteUtil.addTriggerAt(p.barGroups[3], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.pitch = "C5";
	t.stem = TriggerVO.STEM_UP;
	t.noteHeadType = TriggerVO.NOTEHEAD_CROSS;
	NoteUtil.addTriggerAt(p.barGroups[3], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.noteHeadType = TriggerVO.NOTEHEAD_CROSS;
	NoteUtil.addTriggerAt(p.barGroups[3], t, 0, 0, noteIndex++);

	NoteUtil.removeTriggerAt(p.barGroups[3], 0, 0, noteIndex);

	//
	noteIndex = 0;
	p.createEmptyBars();

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.minima;
	t.pitch = "C5";
	t.noteHeadType = TriggerVO.NOTEHEAD_TRIANGLE;
	NoteUtil.addTriggerAt(p.barGroups[4], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.pitch = "C5";
	t.noteHeadType = TriggerVO.NOTEHEAD_TRIANGLE;
	t.stem = TriggerVO.STEM_UP;
	NoteUtil.addTriggerAt(p.barGroups[4], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.croma;
	t.pitch = "C5";
	t.noteHeadType = TriggerVO.NOTEHEAD_TRIANGLE;
	NoteUtil.addTriggerAt(p.barGroups[4], t, 0, 0, noteIndex++);

	t = new TriggerVO();
	t.duration = Lookups.DURATIONS.semiminima;
	t.pitch = "C5";
	t.noteHeadType = TriggerVO.NOTEHEAD_TRIANGLE;
	NoteUtil.addTriggerAt(p.barGroups[4], t, 0, 0, noteIndex++);


	NoteUtil.removeTriggerAt(p.barGroups[4], 0, 0, noteIndex);

	_lm.score.parts = new Vector.<PartVO>();
	_lm.score.parts.push(p);

	_lm.score.parts[0].barGroups[0].bars[0].tempo.notation =  _lm.score.settings.tempoNotation;

	redraw();
}
