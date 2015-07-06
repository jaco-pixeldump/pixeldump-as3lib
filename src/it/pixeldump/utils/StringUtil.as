/**
 * @author jaco
 *
 *
 *
 * some static method addition:
 *
 * 	String utils class by Ryan Matsikas, Feb 10 2006
 *
 *	Visit www.gskinner.com for documentation, updates and more free code.
 * 	You may distribute this code freely, as long as this comment block remains intact.
 */

package it.pixeldump.utils {

	/**
	 * Some static string utility methods
	 *
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class StringUtil {

		public static const PAD_LEFT:String = "padLeft";
		public static const PAD_RIGHT:String = "padRight";

		public static const RE_PUNCT:RegExp = new RegExp(/[\s\-=_!"#%&'*{},.\/:;?\(\)\[\]@\\$\^*+<>~`\u00a1\u00a7\u00b6\u00b7\u00bf\u037e\u0387\u055a-\u055f\u0589\u05c0\u05c3\u05c6\u05f3\u05f4\u0609\u060a\u060c\u060d\u061b\u061e\u061f\u066a-\u066d\u06d4\u0700-\u070d\u07f7-\u07f9\u0830-\u083e\u085e\u0964\u0965\u0970\u0af0\u0df4\u0e4f\u0e5a\u0e5b\u0f04-\u0f12\u0f14\u0f85\u0fd0-\u0fd4\u0fd9\u0fda\u104a-\u104f\u10fb\u1360-\u1368\u166d\u166e\u16eb-\u16ed\u1735\u1736\u17d4-\u17d6\u17d8-\u17da\u1800-\u1805\u1807-\u180a\u1944\u1945\u1a1e\u1a1f\u1aa0-\u1aa6\u1aa8-\u1aad\u1b5a-\u1b60\u1bfc-\u1bff\u1c3b-\u1c3f\u1c7e\u1c7f\u1cc0-\u1cc7\u1cd3\u2016\u2017\u2020-\u2027\u2030-\u2038\u203b-\u203e\u2041-\u2043\u2047-\u2051\u2053\u2055-\u205e\u2cf9-\u2cfc\u2cfe\u2cff\u2d70\u2e00\u2e01\u2e06-\u2e08\u2e0b\u2e0e-\u2e16\u2e18\u2e19\u2e1b\u2e1e\u2e1f\u2e2a-\u2e2e\u2e30-\u2e39\u3001-\u3003\u303d\u30fb\ua4fe\ua4ff\ua60d-\ua60f\ua673\ua67e\ua6f2-\ua6f7\ua874-\ua877\ua8ce\ua8cf\ua8f8-\ua8fa\ua92e\ua92f\ua95f\ua9c1-\ua9cd\ua9de\ua9df\uaa5c-\uaa5f\uaade\uaadf\uaaf0\uaaf1\uabeb\ufe10-\ufe16\ufe19\ufe30\ufe45\ufe46\ufe49-\ufe4c\ufe50-\ufe52\ufe54-\ufe57\ufe5f-\ufe61\ufe68\ufe6a\ufe6b\uff01-\uff03\uff05-\uff07\uff0a\uff0c\uff0e\uff0f\uff1a\uff1b\uff1f\uff20\uff3c\uff61\uff64\uff65]+/g); // finding appended punctuation

		/**
		 * provides to pad left/right string with given char
		 * @param the string to pad
		 * @param padding char
		 * @param total length of the resulting padded string
		 * @param pad left or right: StringUtil.PAD_LEFT StringUtil.PAD_RIGHT
		 * @return
		 */
		public static function strPad(str:String, padChar:String, padTotal:uint, padType:String = StringUtil.PAD_LEFT):String {

			var padStr:String = "";

			if (padTotal < str.length) return str;

			var numPad:int = padTotal - str.length;

			for (var i:int = 0; i < numPad; i++) padStr += padChar;

			if (padType == StringUtil.PAD_RIGHT) return str + padStr;

			return padStr + str;
		}

		/**
		 * check presence of a string in array
		 * @param item to check
		 * @param items to compare
		 * @return
		 */
		public static function inArray(str:String, cmpArray:Array):Boolean {

			for each (var cmp:String in cmpArray) {
				if (str == cmp)
					return true;
			}

			return false;
		}

		/**
		 *
		 */
		public static function repeat(str:String, numRepeat:int, separationChar:String = ""):String {

			var s:Array = new Array();

			for(var i:int; i < numRepeat; i++) s.push(str);

			return s.join(separationChar);
		}

		/**
		 * uint to html hex string
		 * @param
		 * @return
		 */
		public static function toColorString(colorValue:uint, pfx:String = "0x"):String {

			var colorStr:String = pfx;
			var red:uint = colorValue >> 0x10;
			var green:uint = (colorValue >> 0x08) & 0xFF;
			var blue:uint = colorValue & 0xFF;

			colorStr += StringUtil.strPad(red.toString(16), "0", 2);
			colorStr += StringUtil.strPad(green.toString(16), "0", 2);
			colorStr += StringUtil.strPad(blue.toString(16), "0", 2);
			//colorStr += StringUtil.strPad(alpha.toString(16), "0", 2);

			return colorStr;
		}

		/**
		 * hex html string to uint
		 * @param
		 * @return
		 */
		public static function fromColorString(colorString:String):uint {

			if(colorString.substring(0, 2) == "0x") return parseInt(colorString);
			if(colorString.charAt(0) == "#") return parseInt("0x"+ colorString.substring(1));

			return 0;
		}


		/**
		 * converts a string to boolean
		 * @param
		 * @return
		 */
		public static function toBoolean(booleanStr:String):Boolean {
			return booleanStr.toLowerCase() == "true" ? true : false;
		}

		/**
		 * Generate a random string over the alphabet or a specific set of chars
		 * @param newLength int
		 * @param userAlphabet String
		 * @return String
		 */
		public static function generateRandomString(newLength:uint = 1, userAlphabet:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String {

			var alphabet:Array = userAlphabet.split("");
			var alphabetLength:int = alphabet.length;
			var randomLetters:String = "";

			for (var i:uint = 0; i < newLength; i++)
				randomLetters += alphabet[int(Math.floor(Math.random() * alphabetLength))];

			return randomLetters;
		}

		/**
		 *	Returns everything after the first occurrence of the provided character in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function afterFirst(p_string:String, p_char:String):String {
			if (p_string == null) {
				return '';
			}
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) {
				return '';
			}
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		 *	Returns everything after the last occurence of the provided character in p_string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function afterLast(p_string:String, p_char:String):String {
			if (p_string == null) {
				return '';
			}
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) {
				return '';
			}
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		 *	Determines whether the specified string begins with the specified prefix.
		 *
		 *	@param p_string The string that the prefix will be checked against.
		 *
		 *	@param p_begin The prefix that will be tested against the string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beginsWith(p_string:String, p_begin:String):Boolean {
			if (p_string == null) {
				return false;
			}
			return p_string.indexOf(p_begin) == 0;
		}

		/**
		 *	Returns everything before the first occurrence of the provided character in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beforeFirst(p_string:String, p_char:String):String {
			if (p_string == null) {
				return '';
			}
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) {
				return '';
			}
			return p_string.substr(0, idx);
		}

		/**
		 *	Returns everything before the last occurrence of the provided character in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beforeLast(p_string:String, p_char:String):String {
			if (p_string == null) {
				return '';
			}
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) {
				return '';
			}
			return p_string.substr(0, idx);
		}

		/**
		 *	Returns everything after the first occurance of p_start and before
		 *	the first occurrence of p_end in p_string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_start The character or sub-string to use as the start index.
		 *
		 *	@param p_end The character or sub-string to use as the end index.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function between(p_string:String, p_start:String, p_end:String):String {
			var str:String = '';
			if (p_string == null) {
				return str;
			}
			var startIdx:int = p_string.indexOf(p_start);
			if (startIdx != -1) {
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf(p_end, startIdx);
				if (endIdx != -1) {
					str = p_string.substr(startIdx, endIdx - startIdx);
				}
			}
			return str;
		}

		/**
		 *	Description, Utility method that intelligently breaks up your string,
		 *	allowing you to create blocks of readable text.
		 *	This method returns you the closest possible match to the p_delim paramater,
		 *	while keeping the text length within the p_len paramter.
		 *	If a match can't be found in your specified length an  '...' is added to that block,
		 *	and the blocking continues untill all the text is broken apart.
		 *
		 *	@param p_string The string to break up.
		 *
		 *	@param p_len Maximum length of each block of text.
		 *
		 *	@param p_delim delimter to end text blocks on, default = '.'
		 *
		 *	@returns Array
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function block(p_string:String, p_len:uint, p_delim:String = "."):Array {
			var arr:Array = new Array();
			if (p_string == null || !contains(p_string, p_delim)) {
				return arr;
			}
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp("[^" + escapePattern(p_delim) + "]+$");
			while (chrIndex < strLen) {
				var subString:String = p_string.substr(chrIndex, p_len);
				if (!contains(subString, p_delim)) {
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}

		/**
		 *	Capitallizes the first word in a string or all words..
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_all (optional) Boolean value indicating if we should
		 *	capitalize all words or only the first.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function capitalize(p_string:String, ... args):String {
			var str:String = trimLeft(p_string);
			if (args[0] === true) {
				return str.replace(/^.|\b./g, _upperCase);
			}
			else {
				return str.replace(/(^\w)/, _upperCase);
			}
		}

		/**
		 * remove/replace whitespaces
		 *
		 *	@param p_string The string.
		 *
		 *	@returns String
		 *
		 */
		public static function stripWhiteSpaces(p_string:String, replaceChar:String = ""):String {

			var re:RegExp = /[\s\r\n]*/gim;

			return p_string.replace(re, replaceChar);
		}

		/**
		 *	Determines whether the specified string contains any instances of p_char.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string we are looking for.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function contains(p_string:String, p_char:String):Boolean {
			if (p_string == null) {
				return false;
			}
			return p_string.indexOf(p_char) != -1;
		}

		/**
		 *	Determines the number of times a charactor or sub-string appears within the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string to count.
		 *
		 *	@param p_caseSensitive (optional, default is true) A boolean flag to indicate if the
		 *	search is case sensitive.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function countOf(p_string:String, p_char:String, p_caseSensitive:Boolean = true):uint {
			if (p_string == null) {
				return 0;
			}
			var char:String = escapePattern(p_char);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.match(new RegExp(char, flags)).length;
		}

		/**
		 *	Levenshtein distance (editDistance) is a bar of the similarity between two strings,
		 *	The distance is the number of deletions, insertions, or substitutions required to
		 *	transform p_source into p_target.
		 *
		 *	@param p_source The source string.
		 *
		 *	@param p_target The target string.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function editDistance(p_source:String, p_target:String):uint {
			var i:uint;

			if (p_source == null) {
				p_source = '';
			}
			if (p_target == null) {
				p_target = '';
			}

			if (p_source == p_target) {
				return 0;
			}

			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			var j:uint;

			if (n == 0) {
				return m;
			}
			if (m == 0) {
				return n;
			}

			for (i = 0; i <= n; i++) {
				d[i] = new Array();
			}
			for (i = 0; i <= n; i++) {
				d[i][0] = i;
			}
			for (j = 0; j <= m; j++) {
				d[0][j] = j;
			}

			for (i = 1; i <= n; i++) {

				var s_i:String = p_source.charAt(i - 1);
				for (j = 1; j <= m; j++) {

					var t_j:String = p_target.charAt(j - 1);

					if (s_i == t_j) {
						cost = 0;
					}
					else {
						cost = 1;
					}

					d[i][j] = _minimum(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost);
				}
			}
			return d[n][m];
		}

		/**
		 *	Determines whether the specified string ends with the specified suffix.
		 *
		 *	@param p_string The string that the suffic will be checked against.
		 *
		 *	@param p_end The suffix that will be tested against the string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function endsWith(p_string:String, p_end:String):Boolean {
			return p_string.lastIndexOf(p_end) == p_string.length - p_end.length;
		}

		/**
		 *	Determines whether the specified string contains text.
		 *
		 *	@param p_string The string to check.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function hasText(p_string:String):Boolean {
			var str:String = removeExtraWhitespace(p_string);
			return !!str.length;
		}

		/**
		 *	Determines whether the specified string contains any characters.
		 *
		 *	@param p_string The string to check
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function isEmpty(p_string:String):Boolean {
			if (p_string == null) {
				return true;
			}
			return !p_string.length;
		}

		/**
		 *	Determines whether the specified string is numeric.
		 *
		 *	@param p_string The string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function isNumeric(p_string:String):Boolean {
			if (p_string == null) {
				return false;
			}
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(p_string);
		}

		/**
		 * Pads p_string with specified character to a specified length from the left.
		 *
		 *	@param p_string String to pad
		 *
		 *	@param p_padChar Character for pad.
		 *
		 *	@param p_length Length to pad to.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) {
				s = p_padChar + s;
			}
			return s;
		}

		/**
		 * Pads p_string with specified character to a specified length from the right.
		 *
		 *	@param p_string String to pad
		 *
		 *	@param p_padChar Character for pad.
		 *
		 *	@param p_length Length to pad to.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function padRight(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) {
				s += p_padChar;
			}
			return s;
		}

		/**
		 *	Properly cases' the string in "sentence format".
		 *
		 *	@param p_string The string to check
		 *
		 *	@returns String.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function properCase(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			var str:String = p_string.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}

		/**
		 *	Escapes all of the characters in a string to create a friendly "quotable" sting
		 *
		 *	@param p_string The string that will be checked for instances of remove
		 *	string
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function quote(p_string:String):String {
			var regx:RegExp = /[\\"\r\n]/g;
			return '"' + p_string.replace(regx, _quote) + '"'; //"
		}

		/**
		 *	Removes all instances of the remove string in the input string.
		 *
		 *	@param p_string The string that will be checked for instances of remove
		 *	string
		 *
		 *	@param p_remove The string that will be removed from the input string.
		 *
		 *	@param p_caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function remove(p_string:String, p_remove:String, p_caseSensitive:Boolean = true):String {
			if (p_string == null) {
				return '';
			}
			var rem:String = escapePattern(p_remove);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.replace(new RegExp(rem, flags), '');
		}

		/**
		 *	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		 *	specified string.
		 *
		 *	@param p_string The String whose extraneous whitespace will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function removeExtraWhitespace(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			var str:String = trim(p_string);
			return str.replace(/\s+/g, ' ');
		}

		/**
		 *	Returns the specified string in reverse character order.
		 *
		 *	@param p_string The String that will be reversed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function reverse(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.split('').reverse().join('');
		}

		/**
		 *	Returns the specified string in reverse word order.
		 *
		 *	@param p_string The String that will be reversed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function reverseWords(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.split(/\s+/).reverse().join('');
		}

		/**
		 *	Determines the percentage of similiarity, based on editDistance
		 *
		 *	@param p_source The source string.
		 *
		 *	@param p_target The target string.
		 *
		 *	@returns Number
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function similarity(p_source:String, p_target:String):Number {
			var ed:uint = editDistance(p_source, p_target);
			var maxLen:uint = Math.max(p_source.length, p_target.length);
			if (maxLen == 0) {
				return 100;
			}
			else {
				return (1 - ed / maxLen) * 100;
			}
		}

		/**
		 *	Remove's all < and > based tags from a string
		 *
		 *	@param p_string The source string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function stripTags(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/<\/?[^>]+>/igm, '');
		}

		/**
		 *	Swaps the casing of a string.
		 *
		 *	@param p_string The source string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function swapCase(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/(\w)/, _swapCase);
		}

		/**
		 *	Removes whitespace from the front and the end of the specified
		 *	string.
		 *
		 *	@param p_string The String whose beginning and ending whitespace will
		 *	will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trim(p_string:String):String {
			if (!p_string || !p_string.length)  return '';
			return p_string.replace(/^\s+|\s+$/g, '');
		}

		/**
		 *	Removes whitespace from the front (left-side) of the specified string.
		 *
		 *	@param p_string The String whose beginning whitespace will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trimLeft(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/^\s+/, '');
		}

		/**
		 *	Removes whitespace from the end (right-side) of the specified string.
		 *
		 *	@param p_string The String whose ending whitespace will be removed.
		 *
		 *	@returns String	.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trimRight(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/\s+$/, '');
		}

		/**
		 *	Determins the number of words in a string.
		 *
		 *	@param p_string The string.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function wordCount(p_string:String):uint {
			if (p_string == null) {
				return 0;
			}
			return p_string.match(/\b\w+\b/g).length;
		}

		/**
		 *	Returns a string truncated to a specified length with optional suffix
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_len The length the string should be shortend to
		 *
		 *	@param p_suffix (optional, default=...) The string to append to the end of the truncated string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function truncate(p_string:String, p_len:uint, p_suffix:String = "..."):String {
			if (p_string == null) {
				return '';
			}
			p_len -= p_suffix.length;
			var trunc:String = p_string;
			if (trunc.length > p_len) {
				trunc = trunc.substr(0, p_len);
				if (/[^\s]/.test(p_string.charAt(p_len))) {
					trunc = trimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += p_suffix;
			}

			return trunc;
		}

		public static function toHTMLColor(c:uint):String {

			var r:String = ((c & 0xFF0000) >> 16).toString(16);
			var g:String = ((c & 0x00FF00) >> 8).toString(16);
			var b:String = (c & 0x0000FF).toString(16);

			var colorStr:String = "#" + StringUtil.padLeft(r, "0", 2).toUpperCase();
			colorStr += StringUtil.padLeft(g, "0", 2).toUpperCase();

			return colorStr + StringUtil.padLeft(b, "0", 2).toUpperCase();
		}

		/**
		 *
		 */
		public static function ucfirst(input:String):String {
			var firstChar:String = input.charAt(0).toUpperCase();
			return firstChar +input.substring(1);
		}

		/**
		 *
		 */
		public static function lcfirst(input:String):String {
			var firstChar:String = input.charAt(0).toLowerCase();
			return firstChar +input.substring(1);
		}

		/**
		 *
		 */
		public static function replaceCarriageReturns(v:String, cr:String = "\r", replaceStr:String = ""):String {
			var re:RegExp = new RegExp(cr, "gi");
			var str:String = v.replace(re, replaceStr);
			return str;
		}

		public static function isEmail(v:String):Boolean {

			var re:RegExp = /^[\w-\._\+%]+@(?:[\w-]+\.)+[\w]{2,6}$/;

			return re.test(v);
		}

		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern:String):String {
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		private static function _minimum(a:uint, b:uint, c:uint):uint {
			return Math.min(a, Math.min(b, Math.min(c, a)));
		}

		private static function _quote(p_string:String, ... args):String {
			switch (p_string) {
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		private static function _upperCase(p_char:String, ... args):String {
			return p_char.toUpperCase();
		}

		private static function _swapCase(p_char:String, ... args):String {
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch (p_char) {
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}
	}
}

