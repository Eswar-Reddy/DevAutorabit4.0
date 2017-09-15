/**************************************************
      Desciption- Test class for CreateAccTaskFromEmail
*****************************************************/

public class TestCreateAccTaskFromEmail { 
    
    @isTest
    public static void Test_CreateAccTaskFromEmail(){
        
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        Account accountObj = new Account();
        accountObj.Name = 'Testing Account';
        accountObj.BillingCity = 'chicago';
        accountObj.BillingCountry = 'Spain';
        accountObj.BillingStreet = 'btm';
        accountObj.BillingPostalCode = '12311';
        accountObj.Theater__c = 'Europe';
        accountObj.Territory__c = 'Spain';
        insert accountObj;
        
        String accountObjId = accountObj.ID;

        // Create the email body
        email.plainTextBody = 'This should become a note. Id : *** '+ accountObjId + 'email body containing acc id.';
        email.fromAddress ='testFromAddress@test.com';
        email.ccAddresses = new String[] {'testccAddress@test.com'};
        email.subject = 'Testing Account Task';
 
        CreateAccTaskFromEmail accTask = new CreateAccTaskFromEmail();
        
        Test.startTest();
        Messaging.InboundEmailResult result = accTask.handleInboundEmail(email, env);
        Test.stopTest();

        System.assert(result.success);
        
        List<Task> taskList = [select id from task where WhatId = :accountObjId AND Subject = :email.subject];
        System.assertEquals(1, taskList.size());  

    }
    
}