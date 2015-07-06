package it.pixeldump.utils {

    public class DateUtil {

		public static const EMPTY_DATETIME:String = "0000-00-00 00:00:00";

		public static const MONTH_ITALIAN_SHORT:Array = [
			"gen", "feb", "mar", "apr", "mag", "giu", "lug", "ago", "set", "ott", "nov", "dic"
		];

		public static const MONTH_ITALIAN_FULL:Array = [
			"gennaio", "febbraio", "marzo", "aprile",
			"maggio", "giugno", "luglio", "agosto",
			"settembre", "ottobre", "novembre", "dicembre"
		];

		public static const DAY_WEEK_ITALIAN_SHORT:Array = [
			"dom", "lun", "mar", "mer", "gio", "ven", "sab", "dom"
		];

		public static const DAY_WEEK_ITALIAN_FULL:Array = [
			"domenica", "lunedì", "martedì", "mercoledì", "giovedì", "venerdì", "sabato", "domenica"
		];

		/**
		 * the constructor
		 */
		// public function DateUtil() {}

		public static function toDateTime(dt:Date = null):String {

			if(!dt) dt = new Date();

			var dtStr:String = "" +dt.getFullYear();
			var month:String = "" +(dt.getMonth() + 1);
			var date:String = "" +dt.getDate();
			var hours:String = "" +dt.getHours();
			var minutes:String = "" +dt.getMinutes();
			var seconds:String = "" +dt.getSeconds();

			/*
			var dtStr:String = "" +dt.getUTCFullYear();
			var month:String = "" +(dt.getUTCMonth() + 1);
			var date:String = "" +dt.getUTCDate();
			var hours:String = "" +dt.getUTCHours();
			var minutes:String = "" +dt.getUTCMinutes();
			var seconds:String = "" +dt.getUTCSeconds();
			*/

			dtStr += "-" +StringUtil.strPad(month, "0", 2);
			dtStr += "-" +StringUtil.strPad(date, "0", 2);
			dtStr += " " +StringUtil.strPad(hours, "0", 2);
			dtStr += ":" +StringUtil.strPad(minutes, "0", 2);
			dtStr += ":" +StringUtil.strPad(seconds, "0", 2);

			return dtStr;
		}

		public static function fromDateTime(dtStr:String):Date {

			//trace("got dtstr:", dtStr);

			dtStr = StringUtil.trim(dtStr);
			var fullYear:Number = parseInt(dtStr.substring(0, 4));
			var month:Number = parseInt(dtStr.substring(5, 7)) -1;
			var date:Number = parseInt(dtStr.substring(8, 10));
			var hours:Number = parseInt(dtStr.substring(11, 13));
			var minutes:Number = parseInt(dtStr.substring(14, 16));
			var seconds:Number = parseInt(dtStr.substring(17, 19));

			/*
			trace("y:", fullYear);
			trace("m:", month);
			trace("d:", date);
			trace("h:", hours);
			trace("m:", minutes);
			trace("s:", seconds);
			*/

			return new Date(fullYear, month, date, hours, minutes, seconds);
		}

		public static function timeStampToDateTime(v:Number):String {

			if(v <= 0) return EMPTY_DATETIME;

			return toDateTime(new Date(v));
		}

		public static function dateTimeToTimeStamp(dtStr:String):Number{
			return fromDateTime(dtStr).time;
		}

		public static function timeStampToItalianDate(v:Number):String {
			var dt:Date = new Date(v);
			var dtStr:String =  DAY_WEEK_ITALIAN_SHORT[dt.getDay()] +" ";
			//var dtStr:String =  DAY_WEEK_ITALIAN_SHORT[dt.getUTCDay()] +" ";

			dtStr +=  dt.getDate() +" ";
			dtStr += MONTH_ITALIAN_SHORT[dt.getMonth()] +" ";
			//dtStr += MONTH_ITALIAN_SHORT[dt.getUTCMonth()] +" ";
			//dtStr += dt.getUTCFullYear() +", ";
			dtStr += dt.getFullYear() +", ";
			dtStr += StringUtil.strPad("" +dt.getHours(), "0", 2) +":";
			dtStr += StringUtil.strPad("" +dt.getMinutes(), "0", 2) +" ";
			dtStr += StringUtil.strPad("" +dt.getSeconds(), "0", 2);

			/*
			dtStr += StringUtil.strPad("" +dt.getUTCHours(), "0", 2) +":";
			dtStr += StringUtil.strPad("" +dt.getUTCMinutes(), "0", 2) +" ";
			dtStr += StringUtil.strPad("" +dt.getUTCSeconds(), "0", 2);
			*/

			return dtStr;
		}
    } // end of class
} // end pkg
