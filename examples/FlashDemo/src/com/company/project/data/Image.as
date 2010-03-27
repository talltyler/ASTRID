package com.company.project.data
{
	import framework.data.ModelBase;
	import framework.data.ModelUtils;
	import framework.data.adapters.CSVAdapter;
	
	dynamic public class Image extends ModelBase
	{	
		public static var data:ModelUtils;
		
		public function Image( params:Object=null )
		{
			super( params );
			setAdapter( CSVAdapter );
		}
	}
}

























/*
Notes:
Data validation
Associations
*/
