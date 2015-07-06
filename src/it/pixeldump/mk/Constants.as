
package it.pixeldump.mk {

	import flash.utils.*;

	public class Constants {

		public static const XML_HEADER:String = "<?xml version=\"1.0\"?>";

		public static const NIL:uint = 0;

		// swf measure unit
		public static const TWIP:uint = 20;

		// radiant conversion
		//public static const RADIANT", deg2rad(1);

		// maximum RECT byte length
		public static const MAX_RECT_LENGTH:uint = 17; // Math.ceil((15 * 4 + 5) / 8)
		public static const MAX_SHAPERECORD_LENGTH:uint = 10; // max byte length of a sr
		public static const MAX_EDGERECORD_LENGTH:uint = 9; // max byte length of a sr
		public static const MAX_CURVEDEDGE_BIT_LENGTH:uint = 74; // curdvedEdgeRecord bit length
		public static const MIN_MATRIX_LENGTH:uint = 1; // min byte length in a matrix record
		public static const MAX_MATRIX_LENGTH:uint = 27; // max byte length in a matrix record

		// item definitions
		public static const ACTION_ITEM:String = "DoActionTag";
		public static const INITCLIP_ITEM:String = "DoInitActionTag";

		public static const DEBUGGER:uint = 0;					// EnableDebugger version flag
		public static const DEBUGGER2:uint = 1;					// EnableDebugger2 version flag
		public static const SHAPE_ITEM:String = "DefineShape";
		public static const SHAPE:String = "DefineShape";
		public static const SHAPE2:String = "DefineShape2";
		public static const SHAPE3:String = "DefineShape3";
		public static const SHAPE4:String = "DefineShape4";

		public static const SHAPE_ID:uint = 2;					// 0x02
		public static const SHAPE_ID2:uint = 22;				// 0x16
		public static const SHAPE_ID3:uint = 32;				// 0x20
		public static const SHAPE_ID4:uint = 83;				// 0x53
		public static const FONT:uint = 10;				// 0x0A
		public static const ACTIONS:uint = 12;				// 0x0C
		public static const INITCLIP:uint = 59;				// 0x3B
		public static const LINKAGE:uint = 56;				// 0x38
		public static const PLACEOBJECT2:uint = 26;				// 0x1A
		public static const PLACEOBJECT3:uint = 70;				// 0x46
		public static const BUTTON:uint = 7;					// 0x07
		public static const BUTTON2:uint = 34;					// 0x22
		public static const BUTTON_SOUND:uint = 17;				// 0x11
		public static const TEXTFIELD:uint = 37;				// 0x25
		public static const MOVIECLIP:uint = 39;				// 0x27
		public static const TEXT:uint = 11;					// 0x0B
		public static const TEXT2:uint = 33;					// 0x21
		public static const FONT2:uint = 48;				// 0x30
		public static const FONT3:uint = 75;				// 0x4B
		public static const FLASHTYPE:uint = 73;				// 0x49
		public static const TEXTSETTINGS:uint = 74;				// 0x4A
		public static const FRAME_LABEL:uint = 43;				// 0x2B
		public static const SOUND:uint = 14;					// 0x0E

		// swf9 tag types
		public static const AS3CLASSNAMES:uint = 76;			// 0x4C
		public static const AS3SCENENAMES:uint = 86;			// 0x56

		// sound definitions
		public static const FRAME_SYNC_STRING:String = "11111111111";

		public static const SOUND_UNCOMPRESSED:uint = 0;
		public static const SOUND_ADPCM:uint = 1;
		public static const SOUND_MP3:uint = 2;
		public static const SOUND_UNCOMPRESSED_LE:uint = 3;		// uncompressed little-endian
		public static const SOUND_NELLYMOSER:uint = 6;

		public static const soundFormat:Array = ["uncompressed", "adpcm", "mp3", "uncompressed_le", "nellymoser"];

		public static const RATE_5K5:uint = 0;					// 5.5 KHz, not supported by mp3
		public static const RATE_11:uint = 1;					// 11 KHz
		public static const RATE_22:uint = 2;					// 22 KHz
		public static const RATE_44:uint = 3;					// 44 KHz

		public static const soundRate:Array = ["5k5", "11k", "22k", "44k"];
		public static const mp3Rates:Array = [5512, 11025, 22050, 44100];

		// mp3 lookup versions lookup table
		public static const brLU:Object = {V1L1:[0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 284, 416, 488],
										   V1L2:[0, 32, 48, 56, 64,  80,  96,  112, 128, 160, 192, 224, 256, 320, 384],
										   V1L3:[0, 32, 40, 48, 56,  64,  80,  96,  112, 128, 160, 192, 224, 256, 320],
										   V2L1:[0, 32, 48, 56, 64,  80,  96,  112, 128, 144, 160, 176, 192, 224, 256],
										   V2L2:[0, 8,  16, 24, 32,  40,  48,  56,  64,  80,  96,  112, 128, 144, 160],
										   V2L3:[0, 8,  16, 24, 32,  40,  48,  56,  64,  80,  96,  112, 128, 144, 160]};

		/* flash rates
		bits MPEG1 MPEG2 MPEG2.5
		00 	 44100 22050 11025
		01 	 48000 24000 12000
		10 	 32000 16000 8000
		11 	 reserv. reserv. reserv.
		*/
		public static const mp3R:Object = {V1:[44100, 48000, 32000],
						   				   V2:[22050, 24000, 16000],
						   				  V25:[11025, 12000, 8000]};

		// V2 here is equivalent to V25, let be the same to look correctly in brLU
		// the exactly indexes should be: "V25", "reserved", "V2", "V1"
		public static const mp3Versions:Array = ["V2", "reserved", "V2", "V1"];
		public static const mp3Layers:Array = ["reserved", "L3", "L2", "L1"];


		public static const SOUND_8BIT:uint = 0;				// 8bit sample deep
		public static const SOUND_16BIT:uint = 1;				// 16bit sample deep

		public static const soundSize:Array = ["8bit", "16bit"];

		public static const SOUND_MONO:uint = 0;				// mono, forced to zero for nellymoser
		public static const SOUND_STEREO:uint = 1;				// stereo

		public static const soundType:Array = ["mono", "stereo"];
		public static const SOUND_SH:uint = 18;
		public static const SOUND_SH2:uint = 45;

		// mp3 versions & definitions
		public static const MP3_FRAME_SYNC:uint = 0xFFE00000;
		public static const MP3_VERSION:uint = 0x00180000;
		public static const MP3_VERSION_25:uint = 0x00000000;
		public static const MP3_VERSION_RESERVED:uint = 0x00080000;
		public static const MP3_VERSION_2:uint = 0x00100000;
		public static const MP3_VERSION_1:uint = 0x00180000;

		public static const MP3_LAYER:uint = 0x00060000;
		public static const MP3_LAYER_RESERVED:uint = 0x00000000;
		public static const MP3_LAYER_3:uint = 0x00020000;
		public static const MP3_LAYER_2:uint = 0x00040000;
		public static const MP3_LAYER_1:uint = 0x00060000;

		public static const MP3_SAMPLERATE:uint = 0x00000C00;
		public static const MP3_SAMPLERATE_SHIFT:uint = 10;

		public static const MP3_CHANNEL:uint = 0x000000C0;
		public static const MP3_CHANNEL_STEREO:uint = 0x00000000;
		public static const MP3_CHANNEL_JOINT:uint = 0x00000040;
		public static const MP3_CHANNEL_DUAL:uint = 0x00000080;
		public static const MP3_CHANNEL_MONO:uint = 0x000000C0;

		// fillstyle fill types
		public static const SOLID_FILL:uint = 0;				// 0x00
		public static const LINEAR_GRADIENT_FILL:uint = 16;	// 0x10
		public static const RADIAL_GRADIENT_FILL:uint = 18;	// 0x12
		public static const FOCAL_RADIAL_GRADIENT_FILL:uint = 19;	// 0x13
		public static const REPEATING_BITMAP_FILL:uint = 64;	// 0x40
		public static const CLIPPED_BITMAP_FILL:uint = 65;	// 0x41
		public static const NS_BITMAP_FILL:uint = 66;	// 0x42
		public static const NS_CLIPPED_BITMAP_FILL:uint = 67;	// 0x43
		public static const GS_PAD:uint = 0;					// gradient PAD mode
		public static const GS_REFLECT:uint = 1;				// gradient REFLECT mode
		public static const GS_REPEAT:uint = 2;					// gradient REPEAT mode
		public static const GRADIENT:uint = 1;					// used by MK_gradient class
		public static const FOCAL_GRADIENT:uint = 2;			// ... for swf8 and higher versions


		// used in stylechange records and related
		public static const NO_STYLE:uint = 0;				// 0x00
		public static const RIGHT_FILL:uint = 1;				// 0x01
		public static const LEFT_FILL:uint = 2;				// 0x02
		public static const BOTH_FILL:uint = 3;				// 0x03
		public static const LINE_STYLE:uint = 4;				// 0x04
		public static const ALL_STYLE:uint = 7;				// 0x07
		public static const AUTO_FILL:uint = 8;				// 0x08
		public static const HAS_NEW_STYLE:uint = 16;			// 0x10


		public static const MOVIECLIP_ITEM:String = "DefineSprite";
		public static const BUTTON_ITEM:String = "DefineButton";
		public static const IMAGE_ITEM:String = "DefineBits";
		public static const VIDEO_ITEM:String = "DefineVideo";
		public static const SOUND_ITEM:String = "DefineSound";
		public static const FONT_ITEM:String = "DefineFont";
		public static const FONT_ITEM2:String = "DefineFont2";
		public static const TEXTFIELD_ITEM:String = "DefineEditText";

		// used in textField
		public static const INPUT_TEXT:uint = 0;
		public static const DYNAMIC_TEXT:uint = 1;
		public static const LEFT_ALIGN:uint = 0;
		public static const RIGHT_ALIGN:uint = 1;
		public static const CENTER_ALIGN:uint = 2;
		public static const JUSTIFY_ALIGN:uint = 3;

		// image lossy
		public static const JPEG_TABLE:String = "JPEGTables";
		public static const JPEG:String = "DefineBits";
		public static const JPEG2:String = "DefineBitsJPEG2";
		public static const JPEG_ALPHA:String = "DefineBitsJPEG3";

		// image lossless
		public static const IMAGE_LOSSLESS:String = "DefineBitsLossless";
		public static const IMG_LS_PALETTE_8:uint = 3;						// 8bpp
		public static const IMG_LS_PALETTE_15:uint = 4;						// 15 bpp
		public static const IMG_LS_RGB:uint = 5;							// rgb

		public static const IMAGE_LOSSLESS_ALPHA:String = "DefineBitsLossless2";
		public static const IMG_LS_PALETTE_8_ALPHA:uint = 3;
		public static const IMG_LS_RGB_ALPHA:uint = 5;

		// some jpeg type flag
		public static const JPEG_BASELINE:uint = 1;
		public static const JPEG_PROGRESSIVE:uint = 2;

		// some png type flag
		public static const PNG_GRAY:uint = 0;
		public static const PNG_RGB:uint = 2;
		public static const PNG_PALETTE:uint = 3;
		public static const PNG_GRAY_ALPHA:uint = 4;
		public static const PNG_RGB_ALPHA:uint = 6;

		//egde records
		public static const MAX_TWIPS:uint = 57600;

		public static const IS_END_SHAPERECORD:uint = 0;
		public static const IS_STYLECHANGERECORD:uint = 1;
		public static const IS_EDGERECORD:uint = 2;
		public static const NOT_EDGERECORD:uint = 4;
		public static const IS_NONEDGERECORD:uint = 8;
		public static const NOT_NONEDGERECORD:uint = 16;
		public static const IS_STRAIGHT_EDGERECORD:uint = 32;
		public static const NOT_STRAIGHT_EDGERECORD:uint = 64;
		public static const IS_CURVED_EDGERECORD:uint = 128;
		public static const NOT_CURVED_EDGERECORD:uint = 256;
		public static const VERTICAL_LINE:uint = 512;
		public static const HORIZONTAL_LINE:uint = 1024;

		// blend modes (swf >= 8)
		public static const BLEND_NORMAL:uint = 0;		// valid also if == 1
		public static const BLEND_LAYER:uint = 2;
		public static const BLEND_MULTIPLY:uint = 3;
		public static const BLEND_SCREEN:uint = 4;
		public static const BLEND_LIGTHEN:uint = 5;
		public static const BLEND_DARKEN:uint = 6;
		public static const BLEND_ADD:uint = 7;
		public static const BLEND_SUBTRACT:uint = 8;
		public static const BLEND_DIFFERENCE:uint = 9;
		public static const BLEND_INVER:uint = 10;
		public static const BLEND_ALPHA:uint = 11;
		public static const BLEND_ERASE:uint = 12;
		public static const BLEND_OVERLAY:uint = 13;
		public static const BLEND_HARDLIGHT:uint = 14;

		// button states for buttonRecord
		public static const STATE_HIT:uint = 0x08;		// hit test state
		public static const STATE_DOWN:uint = 0x04;		// down state
		public static const STATE_OVER:uint = 0x02;		// over state
		public static const STATE_UP:uint = 0x01;		// up state


		// saving options
		public static const OUTPUT_FROM_RAWBODY:uint = 1;
		public static const OUTPUT_FROM_FRAMELIST_SIMPLE:uint = 2;
		public static const OUTPUT_FROM_FRAMELIST_COMPLEX:uint = 3;
		public static const OUTPUT_FROM_RAWFRAMELIST:uint = 4;

		// add frame option
		public static const SIMPLE_FRAME:uint = 1;
		public static const OBJECT_FRAME:uint = 2;
		public static const RAW_FRAME:uint = 3;

		// action push option
		public static const AS_STRING:uint = 0;		// 0 = string literal
		public static const AS_FP:uint = 1;			// 1 = floating-point literal
		public static const AS_NULL:uint = 2;			// 2 = null
		public static const AS_UNDEFINED:uint = 3;	// 3 = undefined
		public static const AS_REGISTER:uint = 4;		// 4 = register
		public static const AS_BOOL:uint = 5;			// 5 = boolean
		public static const AS_DOUBLE:uint = 6;		// 6 = double
		public static const AS_INT:uint = 7;			// 7 = integer
		public static const AS_CONST8:uint = 8;		// 8 = constant 8
		public static const AS_CONST16:uint = 9;		// 9 = constant 16

		public static const AS_BYTE:uint = 10;		// byte
		public static const AS_WORD:uint = 11;		// word

		public static const NONE:uint = 0;			// no-method
		public static const GET:uint = 1;				// get method
		public static const POST:uint = 2;			// post method


		// clip events flags
		public static const KEY_UP:uint = 0x80;			// key release
		public static const KEY_DOWN:uint = 0x40;			// key press
		public static const MOUSE_UP:uint = 0x20;			// mouse release
		public static const MOUSE_DOWN:uint = 0x10;			// mouse down
		public static const MOUSE_MOVE:uint = 0x08;			// mouse move
		public static const UNLOAD:uint = 0x04;			// clip unload
		public static const ENTERFRAME:uint = 0x02;			// enterFrame
		public static const LOAD:uint = 0x01;			// load

		public static const DRAG_OVER:uint = 0x8000;			// dragOver
		public static const ROLL_OUT:uint = 0x4000;			// rollOut
		public static const ROLL_OVER:uint = 0x2000;			// rollover
		public static const RELEASE_OS:uint = 0x1000;			// mouse release outside
		public static const RELEASE:uint = 0x0800;			// mouse release
		public static const PRESS:uint = 0x0400;			// mouse press
		public static const INITIALIZE:uint = 0x0200;			// init
		public static const DATA:uint = 0x0100;			// onData

		// player 6 and above
		public static const EVENT:uint = 0x040000;			// event for swf7, otherwise 0
		public static const KEY_PRESS:uint = 0x020000;			// key pressed
		public static const DRAG_OUT:uint = 0x010000;			// drag outside

		// some wav (sound file) constans
		public static const RIFF_LENGTH:uint = 12;
		public static const FMT_LENGTH:uint = 24;

		public static const MAX_TAGID:uint = 91;


		public static const tagList:Object = {
									PlaceObject:0x04,
									PlaceObject2:0x1A,
									RemoveObject:0x05,
									RemoveObject2:0x1C,
									ShowFrame:0x01,
									SetBackgroundColor:0x09,
									FrameLabel:0x2B,
									NamedAnchor:0x2C,
									Protect:0x18,
									End:0x00,
									ExportAssets:0x38,
									ImportAssets:0x39,
									ImportAssets2:0x47,
									EnableDebugger:0x3A,
									EnableDebugger2:0x40,
									DoActionTag:0x0C,
									DoInitActionTag:0x3B,
									DefineShape:0x02,
									DefineShape2:0x16,
									DefineShape3:0x20,
									DefineShape4:0x53,
									DefineBits:0x06,
									JPEGTables:0x08,
									DefineBitsJPEG2:0x15,
									DefineBitsJPEG3:0x23,
									DefineBitsLossless:0x14,
									DefineBitsLossless2:0x24,
									DefineMorphShape:0x2E,
									DefineFont:0x0A,
									DefineFontInfo:0x0D,
									DefineFontInfo2:0x3E,
									DefineFont2:0x30,
									DefineText:0x0B,
									DefineText2:0x21,
									DefineEditText:0x25,
									DefineSound:0x0E,
									StartSound:0x0F,
									SoundStreamHead:0x12,
									SoundStreamHead2:0x2D,
									SoundStreamBlock:0x13,
									DefineButton:0x07,
									DefineButton2:0x22,
									DefineButtonCxform:0x17,
									DefineButtonSound:0x11,
									DefineSprite:0x27,
									DefineVideoStream:0x3C,
									VideoFrame:0x3D,
									ScriptLimits:0x41,

									// swf8
									FileAttributes:0x45,
									PlaceObject3:0x46,
									MetaData:0x4D,
									DefineFont3:0x4B,
									CSMTextSettings:0x4A,
									DefineFontAlignZones:0x49,

									// swf9
									// see mk_lib_swf9_bulk.php for further code
									ProductInfo:0x29, 	// flex2 product info
									AS3ClassNames:0x4C,	// class names
									DoABC2:0x52,	// AS3 bytecode
									AS3SceneNames:0x56, 	// scene names
									DebugMode:0x3F, 	// new debug mode
									DefineBinaryData:0x57 // hardcoded byteArray
									};

		public static const headerTags:Array = ["FileAttributes",
		                                        "MetaData",
		                                        "SetBackgroundColor",
		                                        "ScriptLimits",
		                                        "Protect",
		                                        "EnableDebugger",
		                                        "EnableDebugger2",
		                                        "ProductInfo",
		                                        "DebugMode"];

		public static const tagsWithItemID:Array = [
		                                        	2, 5, 6, 9, 7,
		                                   			11, 13, 14, 15, 17,
		                                   			20, 21, 22, 23,
		                                   			32, 33, 34, 35, 36, 37, 39,
		                                   			46, 48, 60, 61, 62, 73, 74, 75, 131];

		public static const blendModes:Object = {
											normal:0,
											normal1:1,
											layer:2,
											multiply:3,
											screen:4,
											ligthen:5,
											darken:6,
											add:7,
											subtract:8,
											difference:9,
											inver:10,
											alpha:11,
											erase:12,
											overlay:13,
											hardlight:14
											};

		// headerTags are not included in this list
		public static const supportedTags:Array = [0x14, // DefineBitsLossless
		                                           0x24, // DefineBitsLossless2
		                                           0x2B, // FrameLabel
		                                           0x27, // DefineSprite
		                                           0x15, // DefineBitsJPEG2
		                                           0x23, // DefineBitsJPEG3
		                                           0x02, // DefineShape (draft stage)
		                                           0x16, // DefineShape2 (draft stage)
		                                           0x20, // DefineShape3 (draft stage)
		                                           0x53, // DefineShape4 (draft stage)
		                                           0x04, // PlaceObject
		                                           0x1A, // PlaceObject2
		                                           0x0E, // DefineSound
		                                           0x30, // DefineFont2 (draft stage)
		                                           0x4B, // DefineFont3 (draft stage)
		                                           0x4A, // CSMTExtSettings
		                                           0x38]; // ExportAssets

		//
		public static function isSupportedTag(tagID:uint):Boolean {
			for each(var i:uint in Constants.supportedTags){
				if(tagID == i) return true;
			}
			return false;
		}

		//
		public static function getTagNameFromTagID(value:uint):String {

			var nodeName:String = "";

			for (var i:String in Constants.tagList){
				if(Constants.tagList[i] == value) {
					nodeName = i;
					break;
				}
			}


			return nodeName; // tagType not found
		}

		//
		public static function tagID_hasItemID(tagID:uint):Boolean {

			for each(var i:uint in Constants.tagsWithItemID)
				if(i == tagID) return true;

			return false;
		}
	}
}