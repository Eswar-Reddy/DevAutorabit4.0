/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller TaskViewOverride
*****************************************************/

public class TestTaskViewOverride{
  @isTest
  public static void testTaskViewOverride(){
            
    Task taskObj = new Task();
    insert taskObj;
     
    PageReference pg = Page.TaskViewOverride;
    pg.getParameters().put('id' , taskObj.ID);
    pg.getParameters().put('retURL' , '\\' +taskObj.ID);
    Test.setCurrentPage(pg);   
    
    
    ApexPages.StandardController std = new ApexPages.StandardController(taskObj);
    
    TaskViewOverride tvo = new TaskViewOverride(std);
  }
}