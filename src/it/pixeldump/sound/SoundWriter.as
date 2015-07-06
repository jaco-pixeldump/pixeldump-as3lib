﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿package it.pixeldump.sound {

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import it.pixeldump.mk.Constants;
	import it.pixeldump.mk.tags.DefineSound;
	import it.pixeldump.sound.events.SoundEvent;
	import it.pixeldump.sound.utils.SoundUtil;
	import it.pixeldump.sound.vos.MP3DataVO;

	public class SoundWriter implements IEventDispatcher{

		private static const ALPHABET:String = "abcdefghijklmnopqrstuvwxyz0123456789";

		[Embed(source="../assets/sndlib/snditem01_header.bin", mimeType="application/octet-stream")]
	    private const SwfSoundHeader:Class;

		[Embed(source="../assets/sndlib/p01_t086.tag", mimeType="application/octet-stream")]
		private const Pre_sceneNames:Class;

		[Embed(source="../assets/sndlib/slot01_p02_t082.tag", mimeType="application/octet-stream")]
		private const Pre_doABC2:Class;

		[Embed(source="../assets/sndlib/slot01_p04_t076.tag", mimeType="application/octet-stream")]
		private const Post_classNames:Class;

		[Embed(source="../assets/sndlib/p05_t045.tag", mimeType="application/octet-stream")]
		private const Post_streamHead2:Class;

		private var randomClassName:String = "SndItem01";
		private var dispatcher:EventDispatcher;

		private var ds:DefineSound;
		private var swfH:ByteArray;
		private var swfDef:ByteArray;

		private var ld:Loader = new Loader();
		private var ldContext:LoaderContext = new LoaderContext();

		public var mp3Data:MP3DataVO;
		public var snd:Sound;

		/**
		 * the constructor
		 */
		function SoundWriter(){

			ldContext.allowCodeImport = true;
			dispatcher = new EventDispatcher(this);
		}

		// ----------------------- private events methods

		private function initData():void {

			generateRandomClassName();

			swfH = new ByteArray();
			swfH.endian = Endian.LITTLE_ENDIAN;

			var cnt:ByteArray = new SwfSoundHeader() as ByteArray;
			swfH.writeBytes(cnt, 0, cnt.length);

			cnt = new Pre_sceneNames() as ByteArray;
			swfH.writeBytes(cnt, 0, cnt.length);

			cnt = new Pre_doABC2() as ByteArray;
			swfH.writeBytes(cnt, 0, 21);
			swfH.writeUTFBytes(randomClassName);
			swfH.writeBytes(cnt, 30, cnt.length - 30);

			swfH.position = 0;
		}

		private function finalizeAndLoad():void {

			var cnt:ByteArray = new Post_classNames() as ByteArray;
			swfDef.writeBytes(cnt, 0, 10);
			swfDef.writeUTFBytes(randomClassName);
			swfDef.writeBytes(cnt, 19, cnt.length - 19);

			cnt = new Post_streamHead2() as ByteArray;
			swfDef.writeBytes(cnt, 0, cnt.length);

			swfDef.writeShort(0x01 << 6); // showframe
			swfDef.writeShort(0x0);		// end tag

			swfDef.position = 4;
			swfDef.writeUnsignedInt(swfDef.length);
			swfDef.position = 0;

			loadData();
		}

		private function loadData():void {

			//trace("swfDef.length:", swfDef.length);
			//trace("loading runtime content");

			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSWFLoaded);
			ld = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoaded);
			ld.loadBytes(swfDef, ldContext);
		}

		private function generateRandomClassName():void {

			randomClassName = "Snd";

			for(var i:int = 0; i < 6; i++){
				randomClassName += ALPHABET.charAt(Math.floor(Math.random() * ALPHABET.length));
			}
		}

		// -------------- listeners

		private function onSWFLoaded(evt:Event ):void {

			trace("onSWFLoaded:", ld.contentLoaderInfo.bytesTotal, randomClassName);

			var clazz:Class = ld.contentLoaderInfo.applicationDomain.getDefinition(randomClassName) as Class;
			snd = new clazz() as Sound;
			//snd = Sound(new (ld.contentLoaderInfo.applicationDomain.getDefinition("SndItem01") as Class)());
			var evtData:Object = {};
			evtData.sound = snd;

			trace("sound length:", evtData.sound.bytesTotal);

			dispatcher.dispatchEvent(new SoundEvent(SoundEvent.SOUND_READY, evtData));
			ld.unload();
		}

		// ----------------------- public methods

		public function loadTagSound(tagData:ByteArray):void {

			initData();

			tagData.position = 6;
			tagData.writeShort(0x01);
			tagData.position = 0;

			swfDef = new ByteArray();
			swfDef.endian = Endian.LITTLE_ENDIAN;
			swfDef.writeBytes(swfH);

			swfDef.writeBytes(tagData);

			finalizeAndLoad();
		}

		public function writeUncompressedSoundData(samples:ByteArray, isStereo:Boolean = true, sampleLimit:int = 0, soundRate:uint = 44100):void {

			initData();
			samples.position = 0;

			swfDef = new ByteArray();
			swfDef.endian = Endian.LITTLE_ENDIAN;
			swfDef.writeBytes(swfH, 0, swfH.length);

			swfDef.writeByte(0xBF);
			swfDef.writeByte(0x03); // tag type

			swfDef.writeUnsignedInt(samples.length + 7); // tag data length;
			swfDef.writeShort(0x01); // sound ID

			var soundType:int = isStereo ? 0x03F : 0x3E;

			swfDef.writeByte(soundType); // uncompressed little-endian, 44.1KHz 16bit mono or stereo

			swfDef.writeInt(Math.round((samples.length - sampleLimit)/ 2));
			swfDef.writeBytes(samples, 0, samples.length - sampleLimit);

			finalizeAndLoad();
		}

		public function loadMp3Sound(soundData:ByteArray):void {

			var mp3BA:ByteArray = new ByteArray();
			mp3BA.writeBytes(soundData, 0, 4096);

			mp3Data = SoundUtil.read_mp3_data(mp3BA, soundData.length);

			ds = new DefineSound();
			ds.itemID = 1;
			ds.soundFormat = Constants.SOUND_MP3;
			ds.soundRate = mp3Data.frameHeader.rate; // Constants.RATE_44;
			ds.soundSize = Constants.SOUND_16BIT;
			ds.soundType = Constants.SOUND_STEREO;
			ds.soundSampleCount = mp3Data.sampleCount;
			ds.soundData = new ByteArray();
			ds.soundData.writeBytes(soundData);

			var dsBA:ByteArray = ds.toByteArray();
			loadTagSound(dsBA);
		}

		// ---- IEventDispatcher implementors

	    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
	        dispatcher.addEventListener(type, listener, useCapture, priority);
	    }

	    public function dispatchEvent(evt:Event):Boolean { return dispatcher.dispatchEvent(evt); }
	    public function hasEventListener(type:String):Boolean { return dispatcher.hasEventListener(type); }

	    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
	        dispatcher.removeEventListener(type, listener, useCapture);
	    }

	    public function willTrigger(type:String):Boolean { return dispatcher.willTrigger(type); }
	}
}
