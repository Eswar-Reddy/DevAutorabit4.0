/********************************************************************************************
Name   : IssueManagement
Author : Jitendra Kothari
Date   : Sep 26, 2011
Usage  : Test Class for triggers on Issue Object and IssueManagement Class.
Case   : 00079081
********************************************************************************************/
@IsTest
public class TestIssueManagement {
    static testMethod void Test_IssueManagement(){
        String  CSCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service Case').getRecordTypeId();
        User testUser = [Select Id From User where isActive = true and Profile.Name = 'System Administrator' and Id != :Userinfo.getUserId() limit 1];
        Account acc = new Account();
        acc.Name = 'Test Account-'+ String.valueOf(DateTime.Now());
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA'; 
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());
        con.AccountId = acc.Id;
        con.Email = 'testpqr@gmail.com';
        insert con;
        
        Case newCase = new Case();       
        newCase.Status = 'New';
        newCase.RecordTypeId = CSCaseRecTypeId;        
        newcase.AccountId = acc.Id;
        insert newCase;
        
        Test.startTest();
        Issues__c issue = new Issues__c(Case__c = newCase.Id, Name = 'Test Issue Jitendra', Location__c = 'Inverter', Serial__c ='6566555');
        issue.Product_Category__c ='Inverter';
        issue.b_Product_Sub_Category__c ='Other Inverter';
        issue.Other_Product_Sub_Category__c = 'Other valiue';
        insert issue;
        Issues__c newIssue = [Select Id, Case_Owner__c from Issues__c where Id = :issue.Id];
        System.assertEquals(Userinfo.getUserId(), newIssue.Case_Owner__c);
        
        newCase.OwnerId = testUser.Id;
        update newCase;        
        newIssue = [Select Id, Case_Owner__c from Issues__c where Id = :issue.Id];
        System.assertEquals(testUser.Id, newIssue.Case_Owner__c);
        
        newIssue.Case__c = null;
        update newIssue;        
        newIssue = [Select Id, Case_Owner__c from Issues__c where Id = :issue.Id];
        System.assertEquals(null, newIssue.Case_Owner__c);
        Test.stopTest();
    }
}