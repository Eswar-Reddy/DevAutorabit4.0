/********************************************************
**By- Harsh Mathur
**On- July 21 2009
**Modified - 
**Modified On- 
**Description- Test class for afterUpdateTask trigger
**********************************************************/
public class TestAfterUpdateTask{
  @isTest
  public static void checkAfterUpdateTask(){
  	try{
	    Task taskObj = new Task();
	    insert taskObj;
	    
	    update taskObj;
  	}
  	catch(Exception ex){
  		
  	}
  }  
}