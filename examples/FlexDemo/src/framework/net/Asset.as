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
package framework.net
{
	import flash.errors.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.system.*;
	import framework.debug.Log;
	
	[Event(name='removed', type='flash.event.Event')]
	[Event(name='complete', type='flash.event.Event')]
	[Event(name='progress', type='flash.event.ProgressEvent')]
	[Event(name='ioError', type='flash.event.IOErrorEvent')]
	
	public class Asset extends EventDispatcher
	{
		public var name:String;
		public var job:Job;
		public var method:String;
		public var type:String;
		public var url:URI;
		public var format:String;
		public var usePolicy:Boolean;
		
		public var loader:Object;
		public var content:Object;
		public var bytesLoaded:Number;
		public var bytesTotal:Number;
		public var data:*;
		public var userData:*;
		
		public static var BLOCK_SIZE:uint = 0x10000; // 64 * 1024;
		
		private var _loader:URLLoader = new URLLoader();
		private var _boundary:String;
		private var _variableNames:Array = [];
		private var _fileNames:Array = [];
		private var _variables:Dictionary = new Dictionary();
		private var _files:Dictionary = new Dictionary();
		private var _data:ByteArray;
		
		private var totalFilesSize:uint = 0;
		
		public var requestHeaders:Array = [];
		
		private const isImage:RegExp = /^.+\.((jpg)|(gif)|(jpeg)|(png)|(swf))/i;
		
		/**
		 *	@constructor
		 *	@param	url	 	The Path of the Asset to load.
		 *	@param	name	The name of the Asset, this will be used to save it to the cache.
		 *	@param	job	 	The Job that this Asset will be loaded with
		 *	@param	type	The type of Asset this is to load; text, graphic, or swf. Figures it out based on extention if not defined.
		 *	@param	method	Default is "get", you can also pass in post.
		 *	@param	format	This is the format of the return type. The default is text.
		 */
		public function Asset( url:String, name:String, job:Job, type:String=null, method:String="get", format:String="text", usePolicy:Boolean=true )
		{
			super();
			this.url = new URI( url );
			this.name = name;
			this.type = type;
			this.job = job;
			this.method = method;
			this.format = format;
			this.usePolicy = usePolicy;
			
			if( type == null ){
				if(url.match(isImage)) this.type = Assets.GRAPHIC;
				else this.type = Assets.TEXT;
			}
		}
		
		/**
		 * Add file part to loader
		 * If you have already added file with the same fileName it will be overwritten
		 *
		 * @param	fileContent	File content encoded to ByteArray
		 * @param	fileName	Name of the file
		 * @param	dataField	Name of the field containg file data
		 * @param	contentType	MIME type of the uploading file
		 */
		public function addFile( fileContent:ByteArray, fileName:String=null, dataField:String = 'Filedata', contentType:String = 'application/octet-stream' ):void
		{
			if (_fileNames.indexOf(fileName) == -1) {
				_fileNames.push(fileName);
				_files[fileName] = new FilePart(fileContent, fileName, dataField, contentType);
				totalFilesSize += fileContent.length;
			} else {
				var f:FilePart = _files[fileName] as FilePart;
				totalFilesSize -= f.fileContent.length;
				f.fileContent = fileContent;
				f.fileName = fileName;
				f.dataField = dataField;
				f.contentType = contentType;
				totalFilesSize += fileContent.length;
			}
		}
		
		/**
		 * Add string variable to loader
		 * If you have already added variable with the same name it will be overwritten
		 *
		 * @param	name	Variable name
		 * @param	value	Variable value
		 */
		public function addVariable( name:String, value:Object="" ):void
		{
			if (_variableNames.indexOf(name) == -1) {
				_variableNames.push(name);
			}
			_variables[name] = value;
		}
		
		/**
		 * Remove all variable parts
		 */
		public function clearVariables():void
		{
			_variableNames = new Array();
			_variables = new Dictionary();
		}

		/**
		 * Remove all file parts
		 */
		public function clearFiles():void
		{
			for each(var name:String in _fileNames)
			{
				(_files[name] as FilePart).dispose();
			}
			_fileNames = [];
			_files = new Dictionary();
			totalFilesSize = 0;
		}

		/**
		 * Dispose all class instance objects
		 */
		public function dispose(): void
		{
			// removeListener();
			// close();

			_loader = null;
			_boundary = null;
			_variableNames = null;
			_variables = null;
			_fileNames = null;
			_files = null;
			requestHeaders = null;
			_data = null;
		}
		
		/**
		 *	Helper method to create URLRequest object with all of the saved settings.
		 *	@private
		 *	@param	req	 The URLRequest that you would like to setup.
		 */
		public function setRequestVaribles( req:URLRequest ):void
		{
			if(requestHeaders.length && requestHeaders != null){
				req.requestHeaders = requestHeaders.concat();
			}
			
			if( method == URLRequestMethod.POST || _fileNames.length != 0 ){
				req.contentType = 'multipart/form-data; boundary=' + getBoundary();
				req.method = URLRequestMethod.POST;
				req.data = constructPostData();
			}else{
				req.method = URLRequestMethod.GET;
				req.data = constructGetData();
			}
		}
		
		/**
		 *	Creates the URLVariable that goes along with your get request.
		 *	@private
		 *	@return		Returns a URLVariables object that contains all of the saved settings.
		 */
		private function constructGetData():URLVariables
		{
			var getData:URLVariables = new URLVariables();

			for each(var name:String in _variableNames)
			{
				getData[name] = _variables[name];
			}
			
			if( _fileNames.length != 0 ){
				//// Log.error( "Error: Files can not be sent to the server with a GET request method, they must use POST." )
			}
			
			return getData;
		}
		
		/**
		 *	Creates the ByteArray that has all of your settings and files inside of it.
		 *	@private
		 *	@return		Returns a ByteArray object that contains all of the saved settings.
		 */
		private function constructPostData():ByteArray
		{
			var postData:ByteArray = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;

			postData = constructVariablesPart(postData);
			postData = constructFilesPart(postData);
			
			postData = closeDataObject(postData);
			
			return postData;
		}
		
		/**
		 *	Wraps a ByteArray of information in seperators so that it is ready to send over HTTP
		 *	@private
		 *	@param	postData	 The data that that we are going to send to the sever
		 *	@return	Returns a ByteArray that has this information appended.
		 */
		private function constructVariablesPart(postData:ByteArray):ByteArray
		{
			var i:uint;
			var bytes:String;

			for each(var name:String in _variableNames)
			{
				postData = BOUNDARY(postData);
				postData = LINEBREAK(postData);
				bytes = 'Content-Disposition: form-data; name="' + name + '"';
				for ( i = 0; i < bytes.length; i++ ) {
					postData.writeByte( bytes.charCodeAt(i) );
				}
				postData = LINEBREAK(postData);
				postData = LINEBREAK(postData);
				postData.writeUTFBytes(_variables[name]);
				postData = LINEBREAK(postData);
			}

			return postData;
		}

		/**
		 *	Wraps a ByteArray of information in seperators so that it is ready to send over HTTP
		 *	@private
		 *	@param	postData	 The data that that we are going to send to the sever
		 *	@return	Returns a ByteArray that has this information appended.
		 */
		private function constructFilesPart(postData:ByteArray):ByteArray
		{
			var i:uint;
			var bytes:String;
			
			if(_fileNames.length){
				for each(var name:String in _fileNames)
				{
					postData = getFilePartHeader(postData, _files[name] as FilePart);
					postData = getFilePartData(postData, _files[name] as FilePart);
					postData = LINEBREAK(postData);
				}
				postData = closeFilePartsData(postData);
			}
			
			return postData;
		}
		
		/**
		 *	After every part we close put a kind of footer to define that this file part is finished
		 *	@private
		 *	@param	postData	 The data that that we are going to send to the sever
		 *	@return	Returns a ByteArray that has this information appended. 
		 */
		private function closeFilePartsData(postData:ByteArray):ByteArray
		{
			var i:uint;
			var bytes:String;
			
			postData = LINEBREAK(postData);
			postData = BOUNDARY(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Disposition: form-data; name="Upload"';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			postData = LINEBREAK(postData);
			bytes = 'Submit Query';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			
			return postData;
		}
		
		/**
		 *	Before every part we start a kind of header of information to define that this file part is starting
		 *	@private
		 *	@param	postData	 The data that that we are going to send to the sever
		 *	@return	Returns a ByteArray that has this information appended. 
		 */
		private function getFilePartHeader(postData:ByteArray, part:FilePart):ByteArray
		{
			var i:uint;
			var bytes:String;

			postData = BOUNDARY(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Disposition: form-data; name="Filename"';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			postData = LINEBREAK(postData);
			postData.writeUTFBytes(part.fileName);
			postData = LINEBREAK(postData);

			postData = BOUNDARY(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Disposition: form-data; name="' + part.dataField + '"; filename="';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData.writeUTFBytes(part.fileName);
			postData = QUOTATIONMARK(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Type: ' + part.contentType;
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			postData = LINEBREAK(postData);
			
			return postData;
		}
		
		/**
		 *	Adds the file data to the ByteArray that is send to the server
		 *	@private
		 *	@param	postData	The data that that we are going to send to the sever
		 *	@param	part	 	The FilePart
		 *	@return	Returns a ByteArray that has this information appended. 
		 */
		private function getFilePartData(postData:ByteArray, part:FilePart):ByteArray
		{
			postData.writeBytes(part.fileContent, 0, part.fileContent.length);
			
			return postData;
		}
		
		/**
		 *	Ends the ByteArray that is sent to the server.
		 *	@private
		 *	@param	postData	The data that that we are going to send to the sever
		 *	@return	Returns a ByteArray that has this information appended. 
		 */
		private function closeDataObject(postData:ByteArray):ByteArray
		{
			postData = BOUNDARY(postData);
			postData = DOUBLEDASH(postData);
			return postData;
		}
		
		/**
		 *	Return a ByteArray boundary
		 *	@private
		 */
		private function BOUNDARY(p:ByteArray):ByteArray
		{
			var l:int = getBoundary().length;
			p = DOUBLEDASH(p);
			for (var i:int = 0; i < l; i++ ) {
				p.writeByte( _boundary.charCodeAt( i ) );
			}
			return p;
		}

		/**
		 *	Return a ByteArray linebreak
		 *	@private
		 */
		private function LINEBREAK(p:ByteArray):ByteArray
		{
			p.writeShort(0x0d0a);
			return p;
		}

		/**
		 *	Return a ByteArray quotationmark
		 *	@private
		 */
		private function QUOTATIONMARK(p:ByteArray):ByteArray
		{
			p.writeByte(0x22);
			return p;
		}
		
		/**
		 *	Return a ByteArray doubledash
		 *	@private
		 */
		private function DOUBLEDASH(p:ByteArray):ByteArray
		{
			p.writeShort(0x2d2d);
			return p;
		}
		
		/**
		 * Generate random boundary
		 * @return	Random boundary
		 */
		public function getBoundary():String
		{
			if (_boundary == null) {
				_boundary = '';
				for (var i:int = 0; i < 0x20; i++ ) {
					_boundary += String.fromCharCode( int( 97 + Math.random() * 25 ) );
				}
			}
			return _boundary;
		}
	}
}

import flash.utils.ByteArray;
internal class FilePart
{

	public var fileContent:ByteArray;
	public var fileName:String;
	public var dataField:String;
	public var contentType:String;
	
	/**
	 *	
	 *	@constructor
	 *	@param	fileContent	 ByteArray of file contents
	 *	@param	fileName	 Name of the file as a String
	 *	@param	dataField	 The name of the variable that this file will be called in the URLVariables sent to the server
	 *	@param	contentType	 The MIME Type of this file
	 */
	public function FilePart(fileContent:ByteArray, fileName:String, dataField:String = 'Filedata', contentType:String = 'application/octet-stream')
	{
		super();
		this.fileContent = fileContent;
		this.fileName = fileName;
		this.dataField = dataField;
		this.contentType = contentType;
	}

	/**
	 *	Clear the objects information. Called internally.
	 *	@private
	 */
	public function dispose():void
	{
		fileContent = null;
		fileName = null;
		dataField = null;
		contentType = null;
	}
}