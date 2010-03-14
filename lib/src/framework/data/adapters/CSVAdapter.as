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
package framework.data.adapters 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import framework.utils.StringUtils;
	import framework.utils.ClassUtils;
	import framework.data.ModelBase;
	import framework.cache.Cache;
	import framework.data.Data;
	import framework.net.Assets;
	
	public class CSVAdapter extends AdapterBase
	{
		public function CSVAdapter( model:ModelBase, cache:Cache, data:Data )
		{
			super( model, cache, data );
		}
		
		/**
		 *	@param	id	 Optional id of the object that you want to export, if there is no id everything is exported
		 *	@return	Return String formated as a CSV of the data within model
		 */
		override public function export( id:int=0, params:Object=null ) : String
		{
			var csv : CSV = new CSV();
			csv.embededHeader = false;
			csv.recordsetDelimiter = "\n"
			var column:String;
			if( params && params.exclude is Array ){
				for each( column in data.columns( model.className ) ){
					if( params.exclude.indexOf( column ) == -1 ){
						csv.header.push( column );
					}
				}
			}else{
				csv.header = data.columns( model.className );
			}
			var clazz:* = data.getClass( model.className );
			var row:Array;
			var value:*
			if( id == 0 ) {
				for each( var item:* in clazz["all"]() ){
					row = [];
					for each( column in csv.header ){ 
						value = item[column];
						if( value is Array ) {
							value = String(value.length) + " " + StringUtils.pluralize(value[0].className); 
						}else if( value == null ){
							value = ""; 
						}
						row.push( value ); 
					}
					csv.addRecordSet( row );
				}
			}else{
				row = [];
				for each( column in csv.header ){
					value = clazz["findById"]( id )[ column ];
					if( !(value is Array) ) {
						row.push( value.toString() ); 
					}else if( value == null ){
						row.push( "" );
					}else{
						row.push( String(value.length) + " " + StringUtils.pluralize(value[0].className) ); 
					}
				}
				csv.addRecordSet( row );
			}
			csv.encode()
			return csv.data;
		}
		
		/**
		 *	@param	path	 The url that this data is going to be loaded from
		 */
		public function load( path:String ):void
		{
			assets.add( path ).addEventListener( Event.COMPLETE, onLoad );
			assets.load();
		}
		
		public function parse( source:String ):void
		{
			var csv:CSV = new CSV();
			csv.data = source;
			csv.decode();
			var className:String = ClassUtils.className( model );
			var clazz:Class = data.getClass( className );
			var columns:Array = [];
			for each( var header:String in csv.header){
				if( data.columns( className ).indexOf( header ) == -1 && data.columnsLocked( className ) != true ){
					data.columns( className ).push( header );
					columns.push( header );
				}
			}
			for each( var row:Array in csv.data){

				var instance:* = new clazz();
				var index:int = data.push( className, instance );
				
				var count:int = 0;
				for each( var cell:String in row ) {
					var column:String = columns[count];
					instance[column] = cell;
					if( data.isAssociatedProperty( className, column ) ){
						var associatedObject:* = data.getAssociationForProperty(className, column)["class"].findById( cell );
						if( associatedObject != null ){
							var name:String = StringUtils.pluralize( className ).toLowerCase();
							if( !associatedObject.hasOwnProperty( name ) ) {
								associatedObject[ name ] = [];
							}
							associatedObject[ name ].push( instance );
						}
					}
					count++
				}
				instance.index = index;
			}
			data.dispatchEvent(new Event( "dataLoaded" ) );
		}
		
		/**
		 *	@private
		 */
		private function onLoad( event:Event ):void
		{	
			parse( event.target.data );
		}
	}
}

import flash.net.*
import flash.events.*
import framework.utils.*;

/** 
 *   @author Marco Müller / http://shorty-bmc.com
 *   @see http://rfc.net/rfc4180.html RFC4180
 * 	 @see http://csvlib.googlecode.com csvlib
 *   @langversion ActionScript 3.0
 *   @tiptext
 */
class CSV extends URLLoader
{
	
	
	private var FieldSeperator		: String
	private var FieldEnclosureToken : String
	private var RecordsetDelimiter	: String
	
	private var Header 				: Array
	private var EmbededHeader 		: Boolean
	private var HeaderOverwrite 	: Boolean
	
	private var SortField			: *
	private var SortSequence		: String
	
	
	
	/**
	 *   TODO Constructor description ...
	 * 
	 *   @param request URLRequest
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function CSV( request : URLRequest = null )
	{
		super()
		fieldSeperator 		= ','
		fieldEnclosureToken = '"'
		recordsetDelimiter 	= '\r'
		
		header = new Array()
		embededHeader = true
		headerOverwrite = false
		
		if( request )
			load( request )
		this.dataFormat = URLLoaderDataFormat.TEXT
		addEventListener( Event.COMPLETE, decode )
		
	}
	
	
	
	// -> getter
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function get fieldSeperator() : String
	{
		return FieldSeperator
	}
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function get fieldEnclosureToken() : String
	{
		return FieldEnclosureToken
	}
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function get recordsetDelimiter() : String
	{
		return RecordsetDelimiter
	}
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function get embededHeader() : Boolean
	{
		return EmbededHeader
	}
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function get headerOverwrite()  : Boolean 
	{
		return HeaderOverwrite
	}
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function get header() : Array 
	{
		return Header
	}
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function get headerHasValues () : Boolean
	{
		var check : Boolean
		try {
			if ( Header.length > 0 ) check = true
		} catch ( e : Error ) {
			check = false
		} finally {
			return check
		}
	}
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function get dataHasValues () : Boolean
	{
		var check : Boolean
		try {
			if ( data.length > 0 ) check = true
		} catch ( e : Error ) {
			check = false
		} finally {
			return check
		}
	}
	
	
	
	// -> setter
	
	
	
	/**
	 *   TODO Setter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function set fieldSeperator( value : String ) : void
	{
		FieldSeperator = value
	}
	
	
	
	/**
	 *   TODO Getter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function set fieldEnclosureToken( value : String ) : void
	{
		FieldEnclosureToken = value
	}
	
	
	
	/**
	 *   TODO Setter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function set recordsetDelimiter( value : String ) : void
	{
		RecordsetDelimiter = value
	}
	
	
	
	/**
	 *   TODO Setter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function set embededHeader( value : Boolean ) : void
	{
		EmbededHeader = value
	}
	
	
	/**
	 *   TODO Setter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function set headerOverwrite( value : Boolean ) : void
	{
		HeaderOverwrite = value
	}
	
	/**
	 *   TODO Setter description ...
	 * 
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function set header( value : Array ) : void
	{
		if ( (!embededHeader && !headerHasValues) ||
			 (!embededHeader && headerHasValues && headerOverwrite) || headerOverwrite )
			   Header = value
	}
	
	// -> Public methods
	
	/**
	 *   TODO Public method description ...
	 * 
	 *   @param index int
	 *   @return Array
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function getRecordSet( index : int ) : Array
	{
		if ( dataHasValues )
			 return data[ index ]
		else
			return null
	}
	
	
	/**
	 *   TODO Public method description ...
	 * 
	 *   @param recordset Array
	 *   @param index *
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function addRecordSet( recordset : Array, index : * = null ) : void
	{
		if ( !dataHasValues )
			  data = new Array()
		
		if ( !index && index != 0 )
			  data.push( recordset )
		else
			  data.splice( index, 0, recordset )
	}
	
	
	
	/**
	 *   TODO Public method description ...
	 * 
	 *   @param startIndex int
	 *   @param endIndex int
	 *   @return Boolean
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function deleteRecordSet ( startIndex : int, endIndex : int = 1 ) : Boolean
	{
		if ( dataHasValues && startIndex < data.length && endIndex > 0 )
			 return data.splice( startIndex, endIndex )
		else
			 return false
	}
	
	
	/**
	 *   TODO Public method description ...
	 * 
	 *   @param raw The sting to decode
	 *   @param event Never set this, its only for internal use
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function decode( event : Event = null ) : void
	{
		var count  : int = 0
		var result : Array = new Array ()		 
		data = data.toString().split( recordsetDelimiter );
		for(  var i : int = 0; i < data.length; i++ )
		{
			if( !Boolean( count % 2 ) )
				 result.push( data[ i ] )
			else
				 result[ result.length - 1 ] += data[ i ]
			count += StringUtils.count( data[ i ] , fieldEnclosureToken )
		}
		result = result.filter( isNotEmptyRecord )
		result.forEach( fieldDetection )
		if ( ( embededHeader && headerOverwrite ) || ( embededHeader && headerHasValues ) )
			result.shift();
		else if ( embededHeader )
			Header = result.shift();
		data = result;
	}
	
	
	
	/**
	 *   TODO Public method description ...
	 *   
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	public function encode () : void
	{
		var result : String = ''
		if ( headerHasValues && header.length > 0 )
		{
			 embededHeader = true
			 data.unshift( header )
		}
		if ( dataHasValues )
			 for each ( var recordset : Array in data )
			 	 result += recordset.join( fieldSeperator ) + recordsetDelimiter
		data = result
	}
	
	
	
	// -> private methods
	
	
	
	/**
	 *   TODO Private method description ...
	 * 
	 *   @param element *
	 *   @param index int
	 *   @param arr Array
	 *   @return Boolean true if recordset has values, false if not
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	private function fieldDetection( element : *, index : int, arr : Array ) : void
	{	
		var count  : uint  = 0;
		var result : Array = new Array ();
		var tmp    : Array = element.split( fieldSeperator );
		for( var i : uint = 0; i < tmp.length; i++ )
		{
			if( !Boolean( count % 2 ) )
				 result.push( StringUtils.trim( tmp[ i ] ) );
			else
				 result[ result.length - 1 ] += fieldSeperator + tmp[ i ];
			count += StringUtils.count( tmp[ i ] , fieldEnclosureToken );
		}
		arr[ index ] = result
	}
	
	
	
	/**
	 *   TODO Private method description ...
	 * 
	 *   @param element *
	 *   @param index int
	 *   @param arr Array
	 *   @return Boolean true if recordset has values, false if not
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	private function isNotEmptyRecord( element : *, index : int, arr : Array ) : Boolean
	{
		return Boolean( StringUtils.trim( element ) );
	}
}