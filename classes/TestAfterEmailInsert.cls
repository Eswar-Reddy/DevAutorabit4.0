/********************************************************************************************
Name   : TestAfterEmailInsert
Author : Jitendra Kothari
Date   : July 25, 2011
Usage  : Test class for AfterEmailInsert trigger
Case   : 00066693
********************************************************************************************/
@IsTest
public class TestAfterEmailInsert {
    static testMethod void Test_CaseManagement(){
        /*String  crmCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CRM Case').getRecordTypeId();
        
        Case newCase = new Case();       
        newCase.Status = 'New';
        newCase.RecordTypeId = crmCaseRecTypeId;
        insert newCase;
        
        EmailMessage email = new EmailMessage(ParentId = newCase.Id);
        email.Subject = 'Test mail [ ref:00D8ZF1L.5008FXVyg:ref ]';
        email.ToAddress = 'jkothari@appirio.com';
        email.TextBody = 'Test Body';
        insert email;*/
     }
}