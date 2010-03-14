/**
*	Copyright (c) 2009 Tyler Larson 
*	This class a a combonation of a few things that I have found and modified,
*	I've also commented out the methods that I never use but left them in incase
* 	you might want to use these methods at some time.
*
*	Thier copyright information is below
*	
*	Copyright (c) 2007 Derek Wischusen
*
*	Also
*	Copyright (c) 2006 Ryan Matsikas
*
*	And 
*	Visit www.gskinner.com for documentation, updates and more free code.
* 	You may distribute this code freely, as long as this comment block remains intact.
*
* 	Permission is hereby granted, free of charge, to any person obtaining a copy of 
* 	this software and associated documentation files (the "Software"), to deal in 
* 	the Software without restriction, including without limitation the rights to 
* 	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
* 	of the Software, and to permit persons to whom the Software is furnished to do
* 	so, subject to the following conditions:
* 	
* 	The above copyright notice and this permission notice shall be included in all
* 	copies or substantial portions of the Software.
* 	
* 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
* 	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
* 	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
* 	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
* 	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
* 	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
* 	SOFTWARE.
*
*/

package framework.utils 
{
	import flash.xml.XMLDocument;
	
	public class StringUtils 
	{
		
		public function StringUtils()
		{
			super();
		}
		/*
		public static function htmlUnescape(str:String):String
		{
		    return new XMLDocument(str).firstChild.nodeValue;
		}*/
		
		/**
		 * Returns the plural version of a word
		 */
		public static function pluralize(word:String):String
		{
			for each (var rule:Array in pluralRules)
			{
				var regex:RegExp = rule[0];
				var replacement:String = rule[1];
				if (regex.test(word))
					return word.replace(regex, replacement);
			} 
			return word;
		}

		/**
		 * Gives back the singular version of a plural word
		 */
		public static function singularize(word:String):String
		{
			for each (var rule:Array in singularRules)
			{
				var regex:RegExp = rule[0];
				var replacement:String = rule[1];
				if (regex.test(word))
					return word.replace(regex, replacement);
			} 
			return word;
		}

		/**
		 * Camelizes an underscored phrase
		 */
		/*
		public static function camelize(word:String):String
		{
			return word.replace(camelizeExp, function(match:String, underScore:String, char:String, index:int, word:String):String
			{
				return char.toUpperCase();
			});
		}
		private static var camelizeExp:RegExp = /(^|_|-)(.)/g;
		*/
		
		/**
		 * Returns the underscore version of a phrase
		 */
		/*
		public static function underscore(word:String):String
		{
			return word.replace(underscoreExp1, "$1_$2").replace(underscoreExp2, "$1_$2").toLowerCase();
		}
		private static var underscoreExp1:RegExp = /([A-Z]+)([A-Z])/g;
		private static var underscoreExp2:RegExp = /([a-z])([A-Z])/g;
		*/
		
		/**
		 * Returns a the phrase as it would be read with spaces, optionally capitalizing the first
		 * character in each word
		 */
		/*
		public static function humanize(word:String, capitalize:Boolean = false):String
		{
			return underscore(word).replace(camelizeExp, function(match:String, underScore:String, char:String, index:int, word:String):String
			{
				return (index ? " " : "") + (capitalize ? char.toUpperCase() : char); // if this is the start of the string don't add the space
			});
		}*/

		/**
		 * Returns a phrase with all the words in it capitalized
		 */
		/*
		public static function upperWords(phrase:String):String
		{
			return phrase.replace(upperWordsExp, function(match:String, space:String, char:String, index:int, word:String):String
			{
				return space + char.toUpperCase();
			});
		}
		private static var upperWordsExp:RegExp = /(^| )(\w)/g;
		*/
		
		/**
		 * Returns a phrase with all the words in it not capitalized
		 *//*
		public static function lowerWords(phrase:String):String
		{
			return phrase.replace(upperWordsExp, function(match:String, space:String, char:String, index:int, word:String):String
			{
				return space + char.toLowerCase();
			});
		}*/

		/**
		 * Returns a phrase with only the first character capitalized
		 *//*
		public static function upperFirst(phrase:String):String
		{
			return phrase.charAt(0).toUpperCase() + phrase.substr(1);
		}*/

		/**
		 * Returns a phrase with only the first character lowercased
		 *//*
		public static function lowerFirst(phrase:String):String
		{
			return phrase.charAt(0).toLowerCase() + phrase.substr(1);
		}*/

		protected static var pluralRules:Array = [
			[/fish$/i, "fish"],						// fish
			[/(x|ch|ss|sh)$/i, "$1es"],				// search, switch, fix, box, process, address
			[/(series)$/i, "$1"],
			[/([^aeiouy]|qu)ies$/i, "$1y"],
			[/([^aeiouy]|qu)y$/i, "$1ies"],			// query, ability, agency
			[/(?:([^f])fe|([lr])f)$/i, "$1$2ves"],	// half, safe, wife
			[/sis$/i, "ses"],						// basis, diagnosis
			[/([ti])um$/i, "$1a"],					// datum, medium
			[/person$/i, "people"],					// person, salesperson
			[/man$/i, "men"],						// man, woman, spokesman
			[/child$/i, "children"],				// child
			[/s$/i, "s"],							// no change (compatibility)
			[/$/, "s"]
		];

		protected static var singularRules:Array = [
			[/fish$/i, "fish"],
			[/(x|ch|ss|sh)es$/i, "$1"],
			[/movies$/i, "movie"],
			[/series$/i, "series"],
			[/([^aeiouy]|qu)ies$/i, "$1y"],
			[/([lr])ves$/i, "$1f"],
			[/(tive)s$/i, "$1"],
			[/([^f])ves$/i, "$1fe"],
			[/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i, "$1$2sis"],
			[/([ti])a$/i, "$1um"],
			[/people$/i, "person"],
			[/men$/i, "man"],
			[/status$/i, "status"],
			[/children$/i, "child"],
			[/news$/i, "news"],
			[/s$/i, ""]
		];
		
		/**
		 *	Capitalizes the first character of your input string
		 *	
		 *	@param p_string The string.
		 *	@tiptext
		 *//*
		public static function toTitleCase( p_string:String ) : String
		{
			return p_string.substr(0,1).toUpperCase() + p_string.substr(1, p_string.length).toLowerCase();
		}*/
		
		/**
		*	Returns everything after the first occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*	
		*	@tiptext
		*//*
		public static function afterFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}*/

		/**
		*	Returns everything after the last occurence of the provided character in p_string.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function afterLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}*/

		/**
		*	Determines whether the specified string begins with the specified prefix.
		*
		*	@param p_string The string that the prefix will be checked against.
		*
		*	@param p_begin The prefix that will be tested against the string.
		*
		*	@returns Boolean
		*	@tiptext
		*//*
		public static function beginsWith(p_string:String, p_begin:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_begin) == 0;
		}*/

		/**
		*	Returns everything before the first occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function beforeFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
        	if (idx == -1) { return ''; }
        	return p_string.substr(0, idx);
		}*/

		/**
		*	Returns everything before the last occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function beforeLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
        	if (idx == -1) { return ''; }
        	return p_string.substr(0, idx);
		}*/

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
		*	@tiptext
		*//*
		public static function between(p_string:String, p_start:String, p_end:String):String {
			var str:String = '';
			if (p_string == null) { return str; }
			var startIdx:int = p_string.indexOf(p_start);
			if (startIdx != -1) {
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf(p_end, startIdx);
				if (endIdx != -1) { str = p_string.substr(startIdx, endIdx-startIdx); }
			}
			return str;
		}*/

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
		*	@tiptext
		*//*
		public static function block(p_string:String, p_len:uint, p_delim:String = "."):Array {
			var arr:Array = new Array();
			if (p_string == null || !contains(p_string, p_delim)) { return arr; }
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp("[^"+escapePattern(p_delim)+"]+$");
			while (chrIndex <  strLen) {
				var subString:String = p_string.substr(chrIndex, p_len);
				if (!contains(subString, p_delim)){
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}*/

		/**
		*	Capitallizes the first word in a string or all words..
		*
		*	@param p_string The string.
		*
		*	@param p_all (optional) Boolean value indicating if we should
		*	capitalize all words or only the first.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function capitalize(p_string:String, ...args):String {
			var str:String = trimLeft(p_string);
			if (args[0] === true) { return str.replace(/^.|\b./g, _upperCase);}
			else { return str.replace(/(^\w)/, _upperCase); }
		}*/

		/**
		*	Determines whether the specified string contains any instances of p_char.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string we are looking for.
		*
		*	@returns Boolean
		*	@tiptext
		*//*
		public static function contains(p_string:String, p_char:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_char) != -1;
		}*/

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
		*	@tiptext
		*//*
		public static function countOf(p_string:String, p_char:String, p_caseSensitive:Boolean = true):uint {
			if (p_string == null) { return 0; }
			var char:String = escapePattern(p_char);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.match(new RegExp(char, flags)).length;
		}*/

		/**
		*	Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		*	The distance is the number of deletions, insertions, or substitutions required to
		*	transform p_source into p_target.
		*
		*	@param p_source The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns uint
		*	@tiptext
		*//*
		public static function editDistance(p_source:String, p_target:String):uint {
			var i:uint;

			if (p_source == null) { p_source = ''; }
			if (p_target == null) { p_target = ''; }

			if (p_source == p_target) { return 0; }

			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			var j:uint;

			if (n == 0) { return m; }
			if (m == 0) { return n; }

			for (i=0; i<=n; i++) { d[i] = new Array(); }
			for (i=0; i<=n; i++) { d[i][0] = i; }
			for (j=0; j<=m; j++) { d[0][j] = j; }

			for (i=1; i<=n; i++) {

				var s_i:String = p_source.charAt(i-1);
				for (j=1; j<=m; j++) {

					var t_j:String = p_target.charAt(j-1);

					if (s_i == t_j) { cost = 0; }
					else { cost = 1; }

					d[i][j] = _minimum(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+cost);
				}
			}
			return d[n][m];
		}*/

		/**
		*	Determines whether the specified string ends with the specified suffix.
		*
		*	@param p_string The string that the suffic will be checked against.
		*
		*	@param p_end The suffix that will be tested against the string.
		*
		*	@returns Boolean
		*	@tiptext
		*//*
		public static function endsWith(p_string:String, p_end:String):Boolean {
			return p_string.lastIndexOf(p_end) == p_string.length - p_end.length;
		}*/

		/**
		*	Determines whether the specified string contains text.
		*
		*	@param p_string The string to check.
		*
		*	@returns Boolean
		*	@tiptext
		*//*
		public static function hasText(p_string:String):Boolean {
			var str:String = removeExtraWhitespace(p_string);
			return !!str.length;
		}*/

		/**
		*	Determines whether the specified string contains any characters.
		*
		*	@param p_string The string to check
		*
		*	@returns Boolean
		*	@tiptext
		*//*
		public static function isEmpty(p_string:String):Boolean {
			if (p_string == null) { return true; }
			return !p_string.length;
		}*/

		/**
		*	Determines whether the specified string is numeric.
		*
		*	@param p_string The string.
		*
		*	@returns Boolean
		*	@tiptext
		*//*
		public static function isNumeric(p_string:String):Boolean {
			if (p_string == null) { return false; }
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(p_string);
		}*/

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
		*	@tiptext
		*//*
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s = p_padChar + s; }
			return s;
		}*/

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
		*	@tiptext
		*//*
		public static function padRight(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s += p_padChar; }
			return s;
		}*/

		/**
		*	Properly cases' the string in "sentence format".
		*
		*	@param p_string The string to check
		*
		*	@returns String.
		*	@tiptext
		*//*
		public static function properCase(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = p_string.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}*/

		/**
		*	Escapes all of the characters in a string to create a friendly "quotable" sting
		*
		*	@param p_string The string that will be checked for instances of remove
		*	string
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function quote(p_string:String):String {
			var regx:RegExp = /[\\"\r\n]/g;
			return '"'+ p_string.replace(regx, _quote) +'"'; //"
		}*/

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
		*	@tiptext
		*//*
		public static function remove(p_string:String, p_remove:String, p_caseSensitive:Boolean = true):String {
			if (p_string == null) { return ''; }
			var rem:String = escapePattern(p_remove);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.replace(new RegExp(rem, flags), '');
		}*/

		/**
		*	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		*	specified string.
		*
		*	@param p_string The String whose extraneous whitespace will be removed.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function removeExtraWhitespace(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = trim(p_string);
			return str.replace(/\s+/g, ' ');
		}*/

		/**
		*	Returns the specified string in reverse character order.
		*
		*	@param p_string The String that will be reversed.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function reverse(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split('').reverse().join('');
		}*/

		/**
		*	Returns the specified string in reverse word order.
		*
		*	@param p_string The String that will be reversed.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function reverseWords(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split(/\s+/).reverse().join('');
		}*/

		/**
		*	Determines the percentage of similiarity, based on editDistance
		*
		*	@param p_source The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns Number
		*	@tiptext
		*//*
		public static function similarity(p_source:String, p_target:String):Number {
			var ed:uint = editDistance(p_source, p_target);
			var maxLen:uint = Math.max(p_source.length, p_target.length);
			if (maxLen == 0) { return 100; }
			else { return (1 - ed/maxLen) * 100; }
		}*/

		/**
		*	Remove's all &lt; and &gt; based tags from a string
		*
		*	@param p_string The source string.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function stripTags(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/<\/?[^>]+>/igm, '');
		}*/

		/**
		*	Swaps the casing of a string.
		*
		*	@param p_string The source string.
		*
		*	@returns String
		*	@tiptext
		*//*
		public static function swapCase(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/(\w)/, _swapCase);
		}*/

		/**
		*	Removes whitespace from the front and the end of the specified
		*	string.
		*
		*	@param p_string The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns String
		*	@tiptext
		*/
		public static function trim(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+|\s+$/g, '');
		}

		/**
		*	Removes whitespace from the front (left-side) of the specified string.
		*
		*	@param p_string The String whose beginning whitespace will be removed.
		*
		*	@returns String
		*	@tiptext
		*/
		public static function trimLeft(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+/, '');
		}

		/**
		*	Removes whitespace from the end (right-side) of the specified string.
		*
		*	@param p_string The String whose ending whitespace will be removed.
		*
		*	@returns String	.
		*	@tiptext
		*/
		public static function trimRight(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/\s+$/, '');
		}

		/**
		*	Determins the number of words in a string.
		*
		*	@param p_string The string.
		*
		*	@returns uint
		*	@tiptext
		*//*
		public static function wordCount(p_string:String):uint {
			if (p_string == null) { return 0; }
			return p_string.match(/\b\w+\b/g).length;
		}*/
		
		/**
		 *	@private
		 */
		public static function count ( haystack : String, needle : String, offset : Number = 0, length : Number = 0 ) : Number
		{
			if ( length === 0 )
				 length = haystack.length
			var result : Number = 0;
			haystack = haystack.slice( offset, length );
			while ( haystack.length > 0 && haystack.indexOf( needle ) != -1 )
			{
				haystack = haystack.slice( ( haystack.indexOf( needle ) + needle.length ) );
				result++;
			}
			return result;
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
		*	@tiptext
		*//*
		public static function truncate(p_string:String, p_len:uint, p_suffix:String = "..."):String {
			if (p_string == null) { return ''; }
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
		}*/

		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern:String):String {
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		private static function _minimum(a:uint, b:uint, c:uint):uint {
			return Math.min(a, Math.min(b, Math.min(c,a)));
		}

		private static function _quote(p_string:String, ...args):String {
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

		private static function _upperCase(p_char:String, ...args):String {
			return p_char.toUpperCase();
		}

		private static function _swapCase(p_char:String, ...args):String {
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