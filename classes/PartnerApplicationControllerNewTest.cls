/**
Created by:- Paritosh
Date:- 02/08/2013

 */
@isTest
private class PartnerApplicationControllerNewTest {

    static testMethod void PartnerApplicationNew1() {
    
    Map<String, Schema.RecordTypeInfo> nameToLeadRecordTypeInfoMap = Schema.SObjectType.Lead.getRecordTypeInfosByName();
    
    	
    Lead lead = new Lead();
  	lead.LastName = 'Test Lead';
  	lead.Company = 'Test Company Name';
  	lead.Status = 'Open';
  	lead.LeadSource = 'Web';
  	lead.Email = 'test@test.com';
  	lead.RecordTypeId = nameToLeadRecordTypeInfoMap.get('Partner').getRecordTypeId();
  	insert lead;
  	
  	Partner_Application__c partnerObj = new Partner_Application__c();
  	PageReference pageRef = Page.PartnerApplication_CommNew;
  	pageRef.getParameters().put('LId', lead.Id); 
    Test.setCurrentPageReference(pageRef);
    
    ApexPages.StandardController partner_cntrl = new ApexPages.StandardController(partnerObj);
    PartnerApplicationControllerNew PartAppNew = new PartnerApplicationControllerNew(partner_cntrl);
    
    
    
    PartAppNew.partnerApp.Company_Name__c =  'Test Company Name';  
    PartAppNew.step1();
    PartAppNew.step3();
            
    }
    
    static testMethod void PartnerApplicationNew2() {
    
    Map<String, Schema.RecordTypeInfo> nameToLeadRecordTypeInfoMap = Schema.SObjectType.Lead.getRecordTypeInfosByName();
    
    	
    Lead lead = new Lead();
  	lead.LastName = 'Test Lead';
  	lead.Company = 'Test Company Name';
  	lead.Status = 'Open';
  	lead.LeadSource = 'Web';
  	lead.Email = 'test@test.com';
  	lead.RecordTypeId = nameToLeadRecordTypeInfoMap.get('Partner').getRecordTypeId();
  	insert lead;
  	
  	Partner_Application__c partnerObj = new Partner_Application__c();
  	PageReference pageRef = Page.PartnerApplication_ResNew;
  	pageRef.getParameters().put('LId', lead.Id);
    Test.setCurrentPageReference(pageRef);
    
    ApexPages.StandardController partner_cntrl = new ApexPages.StandardController(partnerObj);
    PartnerApplicationControllerNew PartAppNew = new PartnerApplicationControllerNew(partner_cntrl);
    
     
    
    PartAppNew.partnerApp.Company_Name__c =  'Test Company Name';  
    PartAppNew.step1();
    PartAppNew.step3();
    
        
    }
}