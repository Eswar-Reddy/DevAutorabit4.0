/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller InlineActivityOnObject
*****************************************************/

public class TestInlineActivityOnObject{
  @isTest
  public static void testInlineActivityOnObject(){
   
                 
    Account acct = new Account();
    acct.Name = 'TestDuplicate';
    acct.Type ='Commercial'; 
    acct.billingCity = 'TestCity';
    acct.BillingCountry = 'TestCountry';
    acct.BillingPostalCode = '12345';
    acct.BillingState = 'TestState';
    acct.BillingStreet = 'TestStreet';   
    insert acct;
    
   
    Task taskObj = new Task();
    taskObj.RecordTypeID = [Select id from RecordType where Name ='Task visible to everyone' limit 1].get(0).Id;
    taskObj.WhatID = acct.Id;
    insert taskObj;
    
    Event evt = new Event();
    evt.WhatId = acct.ID;
    evt.ActivityDatetime = system.now();
    evt.RecordTypeID = [SElect id from recordType where Name ='Event visible to everyone' limit 1 ].get(0).ID;
    evt.DurationInMinutes = 20;
    insert evt;
    
    ApexPages.currentPage().getParameters().put('id' , acct.Id);
    
    ApexPages.StandardController std = new ApexPages.StandardController(taskObj);    
    InlineActivityOnObject inline = new InlineActivityOnObject(std);
    inline.newTask();
    inline.newEvent();
    inline.EditLink();
    inline.CloseLink();
    inline.DeleteRecId = evt.Id;
    inline.DeleteEvent();
  }
}