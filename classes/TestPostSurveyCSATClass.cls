/*********************************************************************
Name  : TestPostSurveyCSATClass
Author: Appirio Offshore (Anuradha)
Date  : June 08,2011
Related Case: 00049072 
Description:This is a Test Class For Class "PostSurveyCSATClass".
History: RedPoint Edited 11.12.2013 see below
*********************************************************************/
@isTest(seeAllData=false)
private class TestPostSurveyCSATClass {
   
    static testMethod void afterInsertUpdatePostInstallationCSATSurveyTest() {
        
        SFDCSpecialUtilities.isRunningTest = True;  
        UserManagement.IS_TEST = true;
        
        String  HomeOwnerOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
        
        Account a = new Account(name='testAcc');
        a.Type = 'Premier-Partner-Combo';
        a.BillingCity = 'hyd';
        a.BillingCountry = 'Italy';
        a.BillingStreet = 'abc';
        a.BillingPostalCode = '1223454';
        a.Theater__c = 'Europe';
        insert a;
        
        List<Contact> contacts = new List<Contact>();  
        Contact c = TestClassFactory.testContact('TestCon', 'testsurvey123@noemail.com', TestClassFactory.retrieveRecordTypeId('Contact', 'Customer'));
        c.AccountId = a.Id;
        c.Primary__c = TRUE;
        c.Include_In_Lease_Doc__c = TRUE;
        c.MailingCity = a.BillingCity;
        c.MailingStreet = a.BillingStreet;
        c.MailingPostalCode = a.BillingPostalCode;
        c.MailingCountry = a.BillingCountry;
        contacts.add(c);
        
        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = a.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        contacts.add(partnerContact);
        
        insert contacts;
        
        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];
        
        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('EU Partner Executive');
        
        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                                    emailencodingkey='UTF-8', lastname='Testing', 
                                    languagelocalekey='en_US', localesidkey='en_US', 
                                    profileid = execProfileId,  country='Germany', 
                                    communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                                    username=string.valueOf(math.random())+'u1@testorg.com',
                                    contactId=partnerContact.Id, UserRole = role);
        System.runAs(currentUser) {
            
            Test.startTest();
            
            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'testOpp';
            testOpp.Lead_Manufacturer__c = 'Partner';
            testOpp.Alliance_Program_Lead__c = TRUE;
            testOpp.Theater__c = 'Europe';
            testOpp.OwnerId = currentUser.Id; 
            testOpp.RecordTypeId = HomeOwnerOppRecordTypeID;
            testOpp.stageName = 'Visit Complete';
            testOpp.Primary_Contact__c = c.Id;
            testOpp.Customer_Satisfaction_Survey_opt_in__c = true;
            testOpp.CloseDate = Date.today();    
            testOpp.Lease__c = True;
            testOpp.Lease_Placed_in_Service__c = True;
            testOpp.RLC_Type__c = 'Residential';
            testOpp.Installation_Date__c = Date.today().addYears(1);
            testOpp.Installation_Completed_Date__c = Date.today().addYears(1);    
            testOpp.AccountId = a.Id;       
            insert testOpp;
            
            Map<Id, Opportunity> newOpportunityMap = new Map<Id, Opportunity>();
            newOpportunityMap.put(testOpp.Id, testOpp);
            Map<Id, Opportunity> oldOpportunityMap = new Map<Id, Opportunity>();
            oldOpportunityMap.put(testOpp.Id, testOpp);
            
            PostSurveyCSATClass.afterInsertUpdatePostInstallationCSATSurvey(newOpportunityMap, oldOpportunityMap, true);
            
            testOpp.StageName = 'Installation Complete';
            update testOpp;
            
            Map<Id, Opportunity> newOpportunityMap2 = new Map<Id, Opportunity>();
            newOpportunityMap2.put(testOpp.Id, testOpp);
            Map<Id, Opportunity> oldOpportunityMap2 = new Map<Id, Opportunity>();
            oldOpportunityMap2.put(testOpp.Id, testOpp);
            PostSurveyCSATClass.afterInsertUpdatePostInstallationCSATSurvey(newOpportunityMap2, oldOpportunityMap2, false);
            
            Test.stopTest();
        }
        
    }
    
    //Case # 00083101 testing postVisitSurvey
    static testMethod void postVisitSurveyTest() {
        
        String  HomeOwnerOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
        UserManagement.IS_TEST = true;
        Id resiSurveyRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Customer_Survey_Result__c.SobjectType).get('Residential');
        
        Account a = new Account(name='testAcc');
        a.Type = 'Premier-Partner-Combo';
        a.BillingCity = 'hyd';
        a.BillingCountry = 'Italy';
        a.BillingStreet = 'abc';
        a.BillingPostalCode = '1223454';
        a.Theater__c = 'Europe';
        insert a;
        
        List<Contact> contacts = new List<Contact>();  
        Contact c = TestClassFactory.testContact('TestCon', 'testsurvey123@noemail.com', TestClassFactory.retrieveRecordTypeId('Contact', 'Customer'));
        c.AccountId = a.Id;
        c.Primary__c = TRUE;
        c.Include_In_Lease_Doc__c = TRUE;
        c.MailingCity = a.BillingCity;
        c.MailingStreet = a.BillingStreet;
        c.MailingPostalCode = a.BillingPostalCode;
        c.MailingCountry = a.BillingCountry;
        contacts.add(c);
        
        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = a.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        contacts.add(partnerContact);
        
        insert contacts;
        
        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];
        
        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('EU Partner Executive');
        
        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                                    emailencodingkey='UTF-8', lastname='Testing', 
                                    languagelocalekey='en_US', localesidkey='en_US', 
                                    profileid = execProfileId,  country='Germany', 
                                    communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                                    username=string.valueOf(math.random())+'u1@testorg.com',
                                    contactId=partnerContact.Id, UserRole = role);
        System.runAs(currentUser) {
        
            Test.startTest();
            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'testOpp';
            testOpp.AccountId = a.Id; //REDPOINT
            testOpp.Theater__c = 'Europe';
            testOpp.OwnerId = currentUser.Id;
            testOpp.RecordTypeId = HomeOwnerOppRecordTypeID;
            testOpp.stageName = '12% - Qualified Opportunity';
            testOpp.Primary_Contact__c = c.Id;
            testOpp.Customer_Satisfaction_Survey_opt_in__c = true;
            testOpp.CloseDate = Date.today();
            testOpp.Lead_Manufacturer__c = 'SunPower';
            testOpp.RLC_Type__c = 'Residential';              
            insert testOpp;
            
            system.assertNotEquals(testOpp.Id , null);
        }
        
        List<Customer_Survey_Result__c> surveys = [SELECT Id, Survey_Status__c From Customer_Survey_Result__c WHERE RecordTypeId =: resiSurveyRecTypeId];
     /*   System.assertNotEquals(surveys.size(), 0, 'Count: ' + surveys.size()); */
        
        Map<Id, Customer_Survey_Result__c> updates = new Map<Id, Customer_Survey_Result__c>();
        for(Customer_Survey_Result__c result : surveys) {
            result.Survey_Status__c = 'No response received';
            updates.put(result.Id, result);
        }
        
        update updates.values();
    }

}