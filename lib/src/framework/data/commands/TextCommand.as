package framework.data.commands
{
import framework.data.commands.ICommand;

public class TextCommand implements ICommand
{
	
	public function TextCommand( text:String )
	{
		super();
	}
	
	public function execute():void
	{
		
	}
	
	
	
}

}

<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" 
               xmlns:s="library://ns.adobe.com/flex/spark" 
               xmlns:mx="library://ns.adobe.com/flex/mx" minWidth="955" minHeight="600" applicationComplete="init()" xmlns:components="components.*" viewSourceURL="srcview/index.html">

    <fx:Script>
        <![CDATA[
            import components.CustomWin;
            
            import org.mart3.utils.Memento;
            import org.mart3.utils.MementoVO;
            
            private var memento:Memento;
            private var actualWin:CustomWin;
            
            protected function init():void{
                
                memento = Memento.getInstance();
                
                for(var i:int = 0; i < 15; i++){
                    
                    var cWin:CustomWin = new CustomWin();
                    cWin.x = Math.random() * 800;
                    cWin.y = Math.random() * 600;
                    cWin.title = String(i);
                    cWin.addEventListener("SetActualWinEvent", setWin);
            
                    this.addElement(cWin);
                    
                    cWin.mementoObject = memento;
                }
                
                
            }
            
            private function setWin(e:Event):void{
                
                actualWin = e.target as CustomWin;
                
                if(!undoBtn.enabled){
                    
                    undoBtn.enabled = true;
                    
                }
                
            }
            
            protected function undoAction(event:MouseEvent):void
            {                
                var tmpMem:MementoVO = memento.undo();
                
                if(tmpMem != null){
                    
                    if(!redoBtn.enabled){
                        
                        redoBtn.enabled = true;
                        
                    }
                    
                    actualWin = tmpMem.who as CustomWin;
                    
                    var obj:Object = new Object();
                    obj.who = actualWin;
                    obj.x = actualWin.x;
                    obj.y = actualWin.y;
                    
                    memento.saveRedoAction(obj);
                    
                    changeProperties(tmpMem)
                    
                    if(memento.undoArrayLen == 0){
                        
                        undoBtn.enabled = false;
                        
                    }
                    
                } else {
                    
                    undoBtn.enabled = false;
                    
                }
                
            }


            protected function redoAction(event:MouseEvent):void
            {
                var tmpMem:MementoVO = memento.redo();
                
                if(tmpMem != null){
                    
                    if(!undoBtn.enabled){
                        
                        undoBtn.enabled = true;
                        
                    }
                    
                    redoBtn.enabled = false;
                    
                    var obj:Object = new Object();
                    obj.who = actualWin;
                    obj.x = actualWin.x;
                    obj.y = actualWin.y;
                    
                    memento.saveAction(obj)
                    
                    changeProperties(tmpMem)
                    
                } else {
                    
                    redoBtn.enabled = false;
                    
                }
            }


            private function changeProperties(_memObj:MementoVO):void{
        
                actualWin = _memObj.who as CustomWin;
                actualWin.x = _memObj.x;
                actualWin.y = _memObj.y;
                
            }
            

        ]]>
    </fx:Script>

    <fx:Declarations>
        <!-- Place non-visual elements (e.g., services, value objects) here -->
    </fx:Declarations>

    <mx:HBox>
        <s:Button id="undoBtn" label="UNDO" click="undoAction(event)" />
        <s:Button id="redoBtn" label="REDO" click="redoAction(event)" enabled="false"/>
    </mx:HBox>

</s:Application>