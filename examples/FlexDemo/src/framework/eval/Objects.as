/*                                   ,----,                                 
 *                                 ,/   .`|                                 
 *      ,---,       .--.--.      ,`   .'  :,-.----.      ,---,    ,---,     
 *     '  .' \     /  /    '.  ;    ;     /\    /  \  ,`--.' |  .'  .' `\   
 *    /  ;    '.  |  :  /`. /.'___,/    ,' ;   :    \ |   :  :,---.'     \  
 *   :  :       \ ;  |  |--` |    :     |  |   | .\ : :   |  '|   |  .`\  | 
 *   :  |   /\   \|  :  ;_   ;    |.';  ;  .   : |: | |   :  |:   : |  '  | 
 *   |  :  ' ;.   :\  \    `.`----'  |  |  |   |  \ : '   '  ;|   ' '  ;  : 
 *   |  |  ;/  \   \`----.   \   '   :  ;  |   : .  / |   |  |'   | ;  .  | 
 *   '  :  | \  \ ,'__ \  \  |   |   |  '  ;   | |  \ '   :  ;|   | :  |  ' 
 *   |  |  '  '--' /  /`--'  /   '   :  |  |   | ;\  \|   |  ''   : | /  ;  
 *   |  :  :      '--'.     /    ;   |.'   :   ' | \.''   :  ||   | '` ,/   
 *   |  | ,'        `--'---'     '---'     :   : :-'  ;   |.' ;   :  .'     
 *   `--''                                 |   |.'    '---'   |   ,.' Tyler      
 * ActionScript tested rapid iterative dev `---' Copyright2010'---'  Larson
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * http://www.gnu.org/licenses
 */
package framework.eval
{

	import framework.utils.*;

 /**
 * <p>
 * Objects can take text that has data and logic defined within it and 
 * evaluate it down to the converted objects value. 
 * </p>
 * 
 * <p>This started with a class that could load a String of data and runtime and be able to 
 * simple pick out Objects defined within the String of data and replace these String with 
 * the ActionScript Object value. This idea grew after I needed a way to loop over data
 * that was loaded from a server. I realized it would be nice to have conditionals and all
 * of the other parts of a basic logic.</p>
 * 
 * <p>This type of thing is often called a templating language and can be found in many 
 * server side languages. This language is modeled in a very similar way to things like 
 * Liquid in Ruby or Smarty in PHP but skips out on a few of the more complicated features 
 * to make sure that this class doesn't become a beast of a script.</p>
 * 
 * <b>Currently it supports </b>
 * <p>
 * <b>Loops:</b>
 * For in loops, for each in loops are both implemented with limit and offset properties for 
 * Arrays. You can also use numeric ranges like in Ruby with ... and .. 
 * example; 3...5 would return and Array with [3,4,5]. The difference between two dots and three
 * is if you would like to include the last value. 
 * </p>
 * <p>
 * <b>Conditionals:</b>
 * If statements with if, if else and else all work with the following operators, 
 * ==, !=, &lt;=, and &gt;=. You can also string conditions together with the &amp;&amp; and || 
 * operators. Conditionals don't currently support parenthesis which would allow for even more 
 * complicated conditionals but this is rairly used. Tell me if you need them. 
 * </p>
 * <p>
 * <b>Math:</b>
 * Math operations like +, -, /, * and % are all supported. I've left out the binary operators 
 * but it is easy to add them if you need them.
 * </p>
 * <p>
 * <p>
 * <b>Variables:</b>
 * Some times you need a variable to store things while looping over objects, simple variable 
 * assignment can be used just like ActionScript.
 * </p>
 * <p>
 * <p>
 * <b>Dot syntax:</b>
 * Everything is created with nested objects, just like ActionScript you can drill into any 
 * deeply nested object. This is notable if you remember tellTarget in AS1
 * </p>
 * <p>
 * <b>Methods:</b>
 * You can't define new methods but you can call any public function or property contained 
 * within your data object. Feel free to pass in scope to other methods if you would like
 * the language to be more powerful.
 * </p>
 * 
 * <p>
 * Think of all of this as a way to mold your loaded text into anything you would 
 * like in a secure way. It's great for APIs, injecting variables or simplifying CSS and
 * HTML content. If you come up with other uses I would love to hear about them.
 * </p>
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 * 
 * @author Tyler Larson, @talltyler
 * @since  10.02.2010
 * 
 * @example
 * <p>
 * <pre class="brush: as3;">
 * var source:String = "Hello &lt;% name %&gt;!";
 * var data:Object = {name:"Tyler"};
 * var objects:Objects = new Objects();
 * var result:String = objects.parse( source, data, &quot;&lt;%&quot;, &quot;%&gt;&quot; );
 * trace( result );
 * </pre>
 * </p>
 * 
 * <p>One of the key features of it is that because I don&#x27;t know what type of text this logic 
 * might be contained within, so the logic delimiters are variable. For instance a for loop can 
 * be written like this;
 * <pre class="brush: as3;">
 * &lt;% for(prop in item) %&gt;
 * 	&lt;% prop %&gt;&lt;% item[prop] %&gt;
 * &lt;% end %&gt;
 * </pre>
 * </p>
 * <p>
 * or like this, if you change the delimiters;
 * <pre class="brush: as3;">
 * {{ for(prop in item) }}
 * 	{{ prop }}{{ item[prop] }}
 * {{ end }}
 * </pre>
 * </p>
 * <p>
 * Here is a larger example:
 * <pre class="brush: as3;">
 * &lt;h2&gt;Images&lt;/h2&gt;
 * &lt;div&gt;
 * 	&lt;% for each(image in images.data) %&gt;
 * 		&lt;div class=&quot;image&quot;&gt;
 * 			&lt;% image %&gt;
 * 		&lt;/div&gt;
 * 	&lt;% end %&gt;
 * &lt;/div&gt;
 * 
 * &lt;div id=&quot;pages&quot;&gt;
 * 	&lt;% if images.prevPage != 1 %&gt;
 * 		&lt;a href=&quot;#/game/index/?page=&lt;% images.prevPage %&gt;&quot;&gt;Previous&lt;/a&gt;
 * 	&lt;% end %&gt;
 * 	&lt;% if images.nextPage != images.currentPage %&gt;
 * 		&lt;a href=&quot;#/game/index/?page=&lt;% images.nextPage %&gt;&quot;&gt;Next&lt;/a&gt;
 * 	&lt;% end %&gt;
 * &lt;/div&gt;
 * </pre>
 * </p>
 * <p>
 * This gets converted to something like this;
 * <pre class="brush: xml;">
 * &lt;h2&gt;Images&lt;/h2&gt;
 * &lt;div id=&quot;images&quot;&gt;
 * 	&lt;div class=&quot;image&quot;&gt;
 * 		&lt;img src=&quot;image1.jpg&quot; /&gt;
 * 		&lt;img src=&quot;image2.jpg&quot; /&gt;
 * 		&lt;img src=&quot;image3.jpg&quot; /&gt;
 * 		&lt;img src=&quot;image4.jpg&quot; /&gt;
 * 		&lt;img src=&quot;image5.jpg&quot; /&gt;
 * 		&lt;img src=&quot;image6.jpg&quot; /&gt;
 * 	&lt;/div&gt;
 * &lt;/div&gt;
 * 
 * &lt;div id=&quot;pages&quot;&gt;
 * 	&lt;a href=&quot;#/game/index/?page=2&quot;&gt;Next&lt;/a&gt;
 * &lt;/div&gt;
 * </pre>
 * </p>
 *//*
	Notes:
	doesn't currently support;
		math with hexadecimal or numbers writen with e's, whatever that is called 
		it doesn't do any very much type checking or validation of values before they are passed
		nested mathimatical operations, 
			this works - user.name.substr(0,user.name.length).length * 5
			this doesn't - user.name.substr(0,user.name.length - 5).length * 5
  */
public class Objects
{
	private var _rootToken:Token;
	private var _currentToken:Token;
	private var _objCount:int = 0;
	
	private const MATH_SYMBOLS:RegExp = /[*\/\-+%]/gim;
	private const SPLIT_ARGUMENTS:RegExp = /(?:^|,)(\"(?:[^\"]+|\"\")*\"|[^,]*)/gim;
	private const METHOD_START:RegExp = /[\sA-Za-z0-9\.\$_]*\(/gim;
	private const EQUALS:String = "=";
	private const FOR:String = "for";
	private const FOR_EACH:String = "for each";
	private const EACH:String = "each";
	private const IF:String = "if";
	private const ELSE:String = "else";
	private const ELSE_IF:String = "else if";
	private const VAR:String = "var";
	private const INCLUDE:String = "include";
	private const END:String = "end";
	private const STANDARD:String = "standard";
	private const LOGIC:String = "logic";
	private const EMPTY:String = "";
	
	/**
	 * @constructor
	 */
	public function Objects()
	{
		super();
	}
	
	/**
	 * This is the main method within the Objects class. It accepts any string and evaluates anything 
	 * within the logic delimiters. Simply pass in your string, the data that contains the 
	 * needed values and the delimiters that you would like and this method will pass back a
	 * evaluated string with the replaced values.
	 * 
	 * @param source String 
	 * @param data Object 
	 * @param startChars String 
	 * @param endChars String
	 * @return Returns a String of evaluated texted based on the data that you have passed in.
	 */
	public function parse( source:String, data:Object=null, startChars:String="<%", endChars:String="%>" ):String
	{
		var myRegExp:RegExp = new RegExp( startChars+"(.*?)"+endChars, "igm" );
		var output:Array = myRegExp.exec(source);
		var lastIndex:int = 0;
		var before:String;
		var tokens:Array = [];
		
		while(output != null) {
			before = source.substring(lastIndex, output.index);
			if( before != EMPTY ){
				tokens.push( new Token( STANDARD, before ) );
			}
			tokens.push( new Token( LOGIC, output[1] ) );
			lastIndex = myRegExp.lastIndex;
		    output = myRegExp.exec(source);
		}
		
		if( lastIndex != source.length ){
			tokens.push( new Token( STANDARD, source.substring(lastIndex, source.length) ) );
		}
		
		_rootToken = new Token( STANDARD, EMPTY );
		_currentToken = _rootToken;
		tokens.forEach( structureTokens );
		var result:String = parseTokens( _rootToken.children, data );
		
		// Cleanup objects
		_rootToken = null;
		_currentToken = null;
		
		return result;
	}
	
	/**
	 * Structure the tokens into their object hierarchy
	 * @private
	 * @param token Token 
	 * @param index int 
	 * @param arr Array 
	 */
	private function structureTokens( token:Token, index:int, arr:Array ):void 
	{
		var text:String = StringUtils.trimLeft( token.text );
		if( text.indexOf( IF ) == 0 || text.indexOf( FOR ) == 0 ) {
			token.parent = _currentToken;
			_currentToken.children.push( token );
			_currentToken = token;
		}else if( text.indexOf( ELSE_IF ) == 0 || text.indexOf( ELSE ) == 0 ) {
			if( _currentToken.parent != null ) {
				_currentToken = _currentToken.parent;
			}
			token.parent = _currentToken;
			_currentToken.children.push( token );
			_currentToken = token;
		}else if( text.indexOf( END ) == 0 ) {
			_currentToken = _currentToken.parent;
		}else{
			_currentToken.children.push( token );
		}	
	}
	
	/**
	 * Parse the tokens into different types.
	 * @private
	 * @param tokens Array 
	 * @param data Object 
	 * @return String 
	 */
	private function parseTokens( tokens:Array, data:Object=null ):String
	{
		var result:String = EMPTY;
		var ifResult:Boolean;
		var forObject:Object;
		var forResult:Array
		var item:*;
		var i:int;
		for each( var token:Token in tokens ) {
			if( token.type == LOGIC ) {
				forResult = [];
				if( token.text.indexOf( IF ) == 0 ) {
					ifResult = resolveCondition( token, data );
					if( ifResult ) {
						result += parseTokens( token.children, data );
					}
				}else if( token.text.indexOf( ELSE_IF ) == 0 ) {
					if( !ifResult ) {
						ifResult = resolveCondition( token, data );
						if( ifResult ) {
							result += parseTokens( token.children, data );
						}
					}
				}else if( token.text.indexOf( ELSE ) == 0 ) {
					if( !ifResult ) {
						result += parseTokens( token.children, data );
					}
				}else if( token.text.indexOf( FOR_EACH ) == 0 ) {
					forObject = resolveForObject( token, data );
					if( forObject.object is Array ) {
						for( i=(forObject.offset||0); i < (forObject.limit||forObject.object.length); i++ ){
							forResult.push.apply(null, resolveLoopChildren( token, data, forObject.object[i], forObject ) );
							_objCount++
						}
					}else{
						for each( item in forObject.object ) {
							forResult.push.apply(null, resolveLoopChildren( token, data, item, forObject ) );
							_objCount++
						}
					}
					token.children = forResult;
					result += parseTokens( token.children, data );
				}else if( token.text.indexOf( FOR ) == 0 ) {
					forObject = resolveForObject( token, data );
					if( forObject.object is Array ) {
						for( i=(forObject.offset||0); i < (forObject.limit||forObject.object.length); i++ ){
							forResult.push.apply(null, resolveLoopChildren( token, data, i, forObject ) );
							_objCount++
						}
					}else{
						for( item in forObject.object ) {
							forResult.push.apply(null, resolveLoopChildren( token, data, item, forObject ) );
							_objCount++
						}
					}
					token.children = forResult;
					result += parseTokens( token.children, data );
				}else if( token.text.indexOf( VAR ) == 0 ) {
					resolveVar( token, data );
				}else{
					result += String( resolveObject( token.text, data ) );
				}
			}else{
				result += token.text;
			}
		}
		
		return result;
	}
	
	/**
	 * Loop over all children and change variable to unique name and save value into data
	 * @private
	 * @param token Token 
	 * @param data Object 
	 * @param item * 
	 * @param forObject Object 
	 * @return Array 
	 */
	private function resolveLoopChildren( token:Token, data:Object, item:*, forObject:Object ):Array
	{
		var result:Array = [];
		var objName:String;
		var newToken:Token;
		for each( var subToken:Token in token.children ){
			newToken = subToken.clone();
			result.push( newToken );
			if( newToken.type == LOGIC ) {
				objName = "$_"+_objCount;
				newToken.text = newToken.text.split( StringUtils.trim( forObject.variable ) ).join( objName );
				data[objName] = item;
				if( newToken.children.length != 0 ) {
					newToken.children = resolveLoopChildren( newToken, data, item, forObject );
				}
			}
		}
		return result;
	}
	
	/**
	 * Parse for loop tokens like this: for( user in users, limit:4, offset:2 )
	 * @private
	 * @param token Token 
	 * @param data Object 
	 * @return Object 
	 */
	private function resolveForObject( token:Token, data:Object ):Object
	{
		var result:Object = {};
		var subparts:Array
		var parts:Array = token.text.split( FOR ).join(EMPTY).split( EACH ).join(EMPTY).split("(").join(EMPTY).split(")").join(EMPTY).split(",");
		var forParts:Array = parts[0].split( " in " );
		result.variable = forParts[0];
		result.object = StringUtils.trim(forParts[1]);
		if( result.object.indexOf("..") != -1 ) {
			result.object = resolveRange( result.object, data );
		}else{
			result.object = resolveObject( ( result.object||"" ), data );
		}
		
		if( parts.length > 1 ) { // limit
			subparts = parts[1].split(":");
			result[StringUtils.trim(subparts[0].toLowerCase())] = parseInt(StringUtils.trim(subparts[1]));
		}
		
		if( parts.length > 2 ) { // offset
			subparts = parts[2].split(":");
			result[StringUtils.trim(subparts[0].toLowerCase())] = parseInt(StringUtils.trim(subparts[1]));
		}
		
		return result;
	}
	
	/**
	 * Parse conditional tokens like this: user.name == 'tobi' || user.name == 'bob'
	 * @private
	 * @param token Token 
	 * @param data Object 
	 * @return Boolean 
	 */
	private function resolveCondition( token:Token, data:Object ):Boolean
	{
		var result:Boolean;
		var conditionChars:Array = StringUtils.trim(token.text.substr(3, token.text.length-1).split("e if").join(EMPTY) ).split("(").join(EMPTY).split(")").join(EMPTY).split(EMPTY);
		var parts:Array = [];
		var currentCondition:Object;
		var currentPart:String = EMPTY;
		var index:int = 0;
		for each( var char:String in conditionChars ) {
			if( char == EQUALS && conditionChars[index+1] == char  ) {
				currentCondition = { left:StringUtils.trim(currentPart), comparison:"==" };
				parts.push( currentCondition );
				currentPart = EMPTY;
			}else if( char == "<" && conditionChars[index+1] == EQUALS ){
				currentCondition = { left:StringUtils.trim(currentPart), comparison:"<=" };
				parts.push( currentCondition );
				currentPart = EMPTY;
			}else if( char == ">" && conditionChars[index+1] == EQUALS ){
				currentCondition = { left:StringUtils.trim(currentPart), comparison:">=" };
				parts.push( currentCondition );
				currentPart = EMPTY;
			}else if( char == "!" && conditionChars[index+1] == EQUALS ){
				currentCondition = { left:StringUtils.trim(currentPart), comparison:"!=" };
				parts.push( currentCondition );
				currentPart = EMPTY;
			}else if( char == "|" && conditionChars[index+1] == "|" ){
				currentCondition.right = StringUtils.trim(currentPart);
				result = evalCondition( currentCondition, data );
				if( result ) {
					return true;
				}
				currentPart = EMPTY;
			}else if( char == "&" && conditionChars[index+1] == "&" ){
				currentCondition.right = StringUtils.trim(currentPart);
				result = evalCondition( currentCondition, data );
				if( !result ) {
					return false;
				}
				currentPart = EMPTY;
			}else if( char != "&" && char != EQUALS && char != "|" && char != "<" && char != ">" ){
				currentPart += char;
			}
			index++
		}
		currentCondition.right = StringUtils.trim(currentPart);
		return evalCondition( currentCondition, data );
	}
	
	/**
	 * Evaluate conditional to true or false based on its conditional type: (==,!=,>=,)
	 * @private
	 * @param condition Object 
	 * @param data Object 
	 * @return Boolean 
	 */
	private function evalCondition( condition:Object, data:Object ):Boolean
	{
		var left:* = resolveObject( condition.left, data );
		var right:* = resolveObject( condition.right, data );
		var result:Boolean;
		switch( condition.comparison ) {
			case "==":
				left == right ? result = true : result =  false; 
				break;
			case "!=":
				left != right ? result = true : result = false; 
				break;
			case "<=":
				left <= right ? result = true : result = false; 
				break;
			case ">=":
				left <= right ? result = true : result = false; 
				break;
		}
		return result;
	}
	
	/**
	 * Assign variable to data object: var item = 4
	 * @private
	 * @param token Token 
	 * @param data Object 
	 */
	private function resolveVar( token:Token, data:Object ):void
	{
		var parts:Array = token.text.substr(4).split(EQUALS);
		data[StringUtils.trim(parts[0])] = resolveObject( parts[1], data );
	}
	
	/**
	 * Resolve ranges like 1..item.length
	 * @private
	 * @param object String 
	 * @param data Object 
	 * @return Array 
	 */
	private function resolveRange( object:String, data:Object ):Array
	{
		var parts:Array;
		var result:Array = [];
		var i:int
		if( object.indexOf("...") != -1 ) {
			parts = object.split("...");
			for( i = int(resolveObject( StringUtils.trim(parts[0] ), data )); i <= int(resolveObject( StringUtils.trim(parts[1]), data )); i++ ) {
				result.push(i);
			}
		}else if( object.indexOf("..") != -1 ) {
			parts = object.split("..");
			for( i = int(resolveObject( StringUtils.trim(parts[0]), data )); i < int(resolveObject( StringUtils.trim(parts[1]), data )); i++ ) {
				result.push(i);
			}
		}
		return result;
	}
	
	/**
	 * Resolve an object defined as a String into its Object value
	 * @private
	 * @param object String 
	 * @param data Object
	 * @return  
	 */
	private function resolveObject( object:String, data:Object ):*
	{
		object = StringUtils.trim( object );
		if( object == "null" ) {
			return null;
		}else if( object.indexOf("+") != -1 || object.indexOf("-") != -1 || object.indexOf("*") != -1 
				|| object.indexOf("/") != -1 || object.indexOf("%") != -1 ) { // break out to math parse because we have math symbols
			return resolveMath( object, data );
		}else if( object.indexOf("'") == 0 || object.indexOf('"') == 0 ) { // must be a String if starts with " or '
			object = StringUtils.trim( object );
			return object.substr( 1, object.length-2 );
		}else if( object.search( /\d+/ ) == 0 ){ // if starts with number, must be number
			return parseFloat( object );
		}else if( object == "true" ){
			return true;
		}else if( object == "false" ){
			return false;
		}else if( object == "null" ){
			return null;
		}else{ // otherwise it must be an object
			//var parts:Array = object.split("[").join(".").split("]").join(EMPTY).split(".");
			var obj:* = data;
			var parts:Array;
			var part:String;
			var wholeObj:String = object.split("[").join(".").split("]").join(EMPTY);
			if( METHOD_START.test( wholeObj ) ) { // has characters and then ( character which means if must be a method
				var count:int = 0;
				var methodStr:String = wholeObj.substr( 0, wholeObj.indexOf("(") );
				var method:Function = resolveDotObject( methodStr, data ) as Function;
				return resolveMethod( method, wholeObj, data );
			}else{
				return resolveDotObject( wholeObj, data );
			}
			return obj;
		}
		return obj;
	}
	
	/**
	 * Resolve a String with dot syntax, 
	 * @param object 	A String like this this.main.alpha
	 * @param data 		The data object that stores all of our name/value pairs
	 * @private
	 * @return returns an untyped object 
	 */
	private function resolveDotObject( object:String, data:Object ):*
	{
		var parts:Array = object.split(".");
		var result:* = data;
		for each( var part:String in parts ){
			if( result.hasOwnProperty(part) ) {
				result = result[part];
			}else{
				trace( "Error", part, "is not contained on", result );
				return null;
			}
		}
		return result;
	}
	
	/**
	 * @private
	 * @param obj *				The scope that this method is on
	 * @param method String 	The name of the method
	 * @param part String 		The whole string that we are working with
	 * @param data Object		The data object that stores all of our name/value pairs
	 * @return  
	 */
	private function resolveMethod( func:Function, whole:String, data:Object ):*
	{
		var args:Array = whole.split("(")[1].split(")").join(EMPTY).match(SPLIT_ARGUMENTS);
		var length:uint = args.length;
		for( var i:int = 0; i < length; i++ ) {
			args[i] = resolveObject( trim( args[i], [','] ), data );
		}
		if( args[args.length-1] == EMPTY ) {
			args.pop();
		}
		return func.apply( null, args );
	}
	
	/**
	 * This method resolves equations like this: users.length + 340.5 * users.length / 2.35 % 3 
	 * @param object String 
	 * @param data Object
	 * @private
	 * @return  
	 */
	private function resolveMath( source:String, data:Object ):*
	{
		var result:*;
		var output:Array = MATH_SYMBOLS.exec(source);
		var lastIndex:int = 0;
		var tokens:Array = [];
		var lastToken:Token;
		
		while(output != null) {
			tokens.push( new Token( output[0], source.substring( lastIndex, MATH_SYMBOLS.lastIndex-1 ) ) );
			lastIndex = MATH_SYMBOLS.lastIndex;
		    output = MATH_SYMBOLS.exec(source);
		}
		
		if( lastIndex != source.length ){
			tokens.push( new Token( EMPTY, source.substring(lastIndex, source.length) ) );
		}
		
		lastToken = tokens.shift();
		result = resolveObject( lastToken.text, data );
		
		for each( var token:Token in tokens ) {
			var obj:* = resolveObject( token.text, data );
			result = evalMath( result, lastToken.type, obj );
			lastToken = token;
		}
		
		return result;
	}
	
	/**
	 * Evaluate the resulting value within the equation between the two parts
	 * @private
	 * @param	left 	Left side of the equation
	 * @param	symbol 	The mathematical symble used to put the two parts together
	 * @param	right 	Right side of the equation
	 * @return  
	 */
	private function evalMath( left:*, symbol:String, right:* ) : *
	{
		switch( symbol ) {
			case "+" : return left + right; break;
			case "-" : return left - right; break;
			case "*" : return left * right; break;
			case "/" : return left / right; break;
			case "%" : return left % right; break;
		}
		return null; 
	}
	
	/**
	 * Trim whitespace and characters from begining and end of String
	 * @param input String
	 * @param stripChars Array 
	 * @private
	 * @return String 
	 */
	private function trim(input:String, stripChars:Array ):String
	{
		return ltrim( rtrim(input, stripChars), stripChars);
	}

	/**
	 * Trim whitespace and characters from begining of String
	 * @param input String
	 * @param stripChars Array
	 * @private
	 * @return String 
	 */
	private function ltrim(input:String, stripChars:Array ):String
    {
		var size:Number = input.length;
		for(var i:Number = 0; i < size; i++) {
			if( input.charCodeAt(i) > 32 && stripChars.indexOf( input.charAt(i) ) == -1 ){
				return input.substring(i);
			}
		}
		return "";
    }

	/**
	 * Trim whitespace and characters from end of String
	 * @param input String
	 * @param stripChars Array
	 * @private
	 * @return String 
	 */
	private function rtrim(input:String, stripChars:Array ):String
	{
		var size:Number = input.length;
		for( var i:Number = size; i > 0; i-- ){
			if( input.charCodeAt(i - 1) > 32 && stripChars.indexOf( input.charAt(i - 1) ) == -1 ){
				return input.substring(0, i);
			}
		}
		return "";
	}
}

}

import framework.utils.*;

class Token 
{
	public var type:String;
	public var parent:Token;
	public var text:String;
	public var children:Array = [];
	
	public function Token( type:String="", text:String=null, parent:Token=null, children:Array=null ):void
	{
		super();
		this.type = type;
		this.parent = parent;
		this.text = StringUtils.trim(text);
		if( children != null ) {
			this.children = children;
		}
	}
	
	public function clone():Token
	{
		return new Token( type, text, parent, children );
	}
}