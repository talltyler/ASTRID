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
package framework.helpers
{
import flash.events.Event;
import flash.events.EventDispatcher;

/**
* Dispatched whenever the current page value is changed or when the source array is set.
*/
[Event(name = "change", type = "flash.events.Event")]
/**
 * Paginate takes an array of data and paginates it into paged data collections, allowing
 * you to look at smaller portions of that data at one time.
 * @author Tyler Egeto
 */
public class Paginator extends EventDispatcher
{
	/**
	 * The number of pages to be returned by getPagesInRange.
	 * @default 5
	 * @see getPagesInRange
	 */
	public var pagesInRange:int = 5;

	/**
	 * Current page the paginator is currently on
	 */
	private var _currentPage:int;

	/**
	 * The last page the paginator was on.
	 */
	private var _lastPage:int;

	/**
	 * The source array being paginated over
	 */
	private var _source:Array;

	/**
	 * The number of items to be returned by data. Fewer items may
	 * be returned if on the last page and there are not enough items to fill it.
	 * @default 10
	 * @see data
	 */
	private var _perPage:int = 10;

	/**
	 * Main Construcutor
	 * @param	source
	 */
	public function Paginator(source:Array = null, currentPage:int=1, perPage:int=10)
	{
		super();
		_source = source || [];
		_currentPage = currentPage;
		_perPage = perPage;
	}

	/**
	 * Returns the current page that the pagination object is on.
	 */
	public function get currentPage():int
	{
		return _currentPage;
	}

	/**
	 * Returns the last page that the paginator object was on, or 0 if
	 * there is not one.
	 */
	public function get lastPage():int
	{
		return _lastPage;
	}

	/**
	 * Returns the next page number if one is available, otherwise the
	 * last page (numPages) is returned.
	 */
	public function get nextPage():int
	{
		return numPages > _currentPage ? _currentPage + 1:_currentPage;
	}

	/**
	 * Returns the previous page number is one is available, otherwise the
	 * first page (1) is returned.
	 */
	public function get prevPage():int
	{
		return _currentPage > 1 ? _currentPage - 1:1;
	}

	/**
	 * Returns a Boolean value indicating if there is another page
	 * after the current one.
	 * @return
	 */
	public function hasNextPage():Boolean
	{
		return _currentPage < numPages;
	}

	/**
	 * Returns a Boolean value indicating if there is a page
	 * before the the current one.
	 * @return
	 */
	public function hasPrevPage():Boolean
	{
		return _currentPage > 1;
	}

	/**
	 * Returns the number of pages in the current data source.
	 */
	public function get numPages():int
	{
		return Math.ceil(_source.length / _perPage);
	}

	/**
	 * Returns the number of items that will be paginated over. (Length of source array)
	 */
	public function get numItems():int { return _source.length; }

	/**
	 * Returns the number of items on the current page.
	 */
	public function get numCurrentItems():int
	{
		if (_currentPage == numPages)
		{
			return numItems - ((_currentPage - 1) * _perPage)
		}
		else{
			return _perPage;
		}
	}

	/**
	 * Returns a Array on intergers indicating the page numbers in the current range.
	 * @return
	 */
	public function getPagesInRange():Array
	{
		var visiblePages:Array = [];
		var numPages:int = this.numPages;
		var i:int;
		var start:int;
		var end:int;

		var currentRange:int = (currentPage - 1) / pagesInRange;
		start = currentRange * pagesInRange + 1;
		end = start + pagesInRange;

		for (i = start; i < end; i++)
		{
			if (i <= numPages) visiblePages.push(i);
		}

		return visiblePages;
	}

	/**
	 * Returns an array of items that are on the current page.
	 * @return
	 */
	public function get data():Array
	{
		var start:int = (_currentPage - 1) * _perPage;
		return _source.slice(start, start + _perPage);
	}

	/**
	 * Returns the items that are on the indicated page. If the page does nto exist
	 * and empty array is returned.
	 * @param	page
	 * @return
	 */
	public function getItemsOnPage(page:int):Array
	{
		var start:int = (page - 1) * _perPage;
		return _source.slice(start, start + _perPage);
	}

	/**
	 * Changes the current page. New page values are restricted to the
	 * number of a pages available in the data source. If there are only
	 * 5 pages and a value of 6 is passed in, the current page is set to 5.
	 * @param	page
	 */
	public function changePage(page:int):void
	{
		var currentPage:int = _currentPage;
		var numPages:int = this.numPages;

		if (page < 1)
		{
			_currentPage = 1;
		}
		else if (page > numPages){
			_currentPage = numPages;
		}
		else{
			_currentPage = page;
		}

		// we only update lastPage if the current page actually changes.
		if (currentPage != _currentPage)
		{
			_lastPage = currentPage;
		}

		dispatchEvent(new Event("change"));
	}

	/**
	 * Sets the source Array that will be paginated through.
	 * @param	source
	 */
	public function setSource(source:Array):void
	{
		_source = source;
		dispatchEvent(new Event("change"));
	}
}

}