/**************************************************
**Created By- Harsh Mathur
**Created On- July 21 2009 
**Last Modified By-Anuradha Suthar 
**Last Modified On- July 23 2009
**Desciption- Test class for executeScript trigger
*****************************************************/
public class TestExecuteScript{
  @isTest  
  public static void CheckExecuteScript(){   
    Batch_Script__c testObj = new Batch_Script__c();
    //testObj.Batch_Script_Run__c = true;
    //testObj.Name = 'Partners Scorecard Calculation';
    insert testObj; 
    Test.startTest();
    try{           
        update testObj;
    }
    catch(Exception ex){
    }
    Test.stopTest();   
  }
}