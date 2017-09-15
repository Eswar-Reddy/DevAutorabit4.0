@isTest
public class TaskTrigger_Test {
    
    public static TestMethod void testTaskDelete() {
        Account a = TestClassFactory.testAccount('Test Account1', TestClassFactory.retrieveRecordTypeID('Account', 'Standard'));
        insert a;
        
        Task t = new Task();
        t.Subject = 'Test';
        t.WhatId = a.Id;
        insert t;
        
        Test.startTest();
        delete [Select Id FROM Task WHERE Id =: t.Id];
        Test.stopTest();        
    }

}