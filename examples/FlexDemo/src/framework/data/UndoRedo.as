package framework.data
{
 	/**
 	 * This is an implimentation of the Memento pattern to take care of undo and redo functionality, 
 	 * it should be abstract enough to work with any type of situation. It's currently used for history
 	 * managment in the controller for the forward and back methods.
 	 */
	public class UndoRedo
    {
        private var undoArray:Array = [];
        private var redoArray:Array = [];
        private var _maxActionSaved:int;
        
        public function UndoRedo( maxActionSaved:int=10 )
        {
            super();
            _maxActionSaved = maxActionSaved;
        }
        
        public function redo():Object
		{
            if(redoArray.length > 0){
                return redoArray.pop();
            }
            return null
        
        }
        
        public function undo():Object
		{
			var result:Object;
            if( undoArray.length > 0 ){
                result = undoArray.pop();
				addRedo( result );
            }
            return result
        }
        
        public function add(obj:Object):void 
		{    
            if(undoArray.length >= _maxActionSaved){
                undoArray.shift();
            }
            undoArray.push(obj);
        }
        
        public function addRedo(obj:Object):void
		{   
            if(redoArray.length >= _maxActionSaved){
                redoArray.shift();
            }
            redoArray.push(obj);
        }
    }
}