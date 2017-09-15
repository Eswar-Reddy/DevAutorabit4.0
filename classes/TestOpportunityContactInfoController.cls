/**************************************************
** Case - 00080946
**Created By- Jitendra Kothari
**Created On- Oct 10 2011
**Desciption- Test class for OpportunityContactInfoController
*****************************************************/
@isTest
private class TestOpportunityContactInfoController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<Account> accList = new List<Account>();
        
        Account acct = new Account();
            acct.Name = 'TestDuplicate';
            acct.Type ='Commercial'; 
            acct.billingCity = 'TestCity';
            acct.BillingCountry = 'TestCountry';
            acct.BillingPostalCode = '12345';
            acct.BillingState = 'TestState';
            acct.BillingStreet = 'TestStreet';   
            accList.add(acct);    
        
        Account acct1 = new Account();
            acct1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
            acct1.Name = 'TestDuplicate1';
            acct1.Type ='Commercial'; 
            acct1.billingCity = 'TestCity1';
            acct1.BillingCountry = 'TestCountry1';
            acct1.BillingPostalCode = '12345';
            acct1.BillingState = 'TestState';
            acct1.BillingStreet = 'TestStreet';
            accList.add(acct1);   
            insert accList;
        
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp = new Opportunity();
            opp.AccountId = acct.Id;
            opp.Name = 'testOpp';
            opp.CloseDate = System.today().addDays(14);
            opp.Sales_Steps__c = 'Shortlisted';
            opp.Contract_Type__c = 'Design';
            opp.Financing__c = 'PPA';
            opp.Business_Unit__c = 'Utility';
            opp.Region__c = 'New York';
            opp.StageName = 'Open';
            opp.Probability = 5;
            opp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
            oppList.add(opp);       
        
        Opportunity opp1 = new Opportunity();       
            opp1.AccountId = acct1.Id;
            opp1.Name = 'testOpp';
            opp1.CloseDate = System.today().addDays(14);
            opp1.Sales_Steps__c = 'Shortlisted';
            opp1.Contract_Type__c = 'Design';
            opp1.Financing__c = 'PPA';
            opp1.Business_Unit__c = 'Utility';
            opp1.Region__c = 'New York';
            opp1.StageName = 'Open';
            opp1.Probability = 5;
            opp1.Budgetary_Pricing_Agreed_On_Date__c = System.today();
            oppList.add(opp1);
            Test.startTest();
            insert oppList;
            
        
        OpportunityContactInfoController  oppCon = new OpportunityContactInfoController();
        Opportunity opps = oppCon.opportunity;
            //System.assertEquals(opps, null);
            oppCon.oppId = opp.Id;      
            opps = oppCon.opportunity;
            //System.assertEquals(opps.Id, opp.Id);       
            //System.assertEquals(oppCon.account.Id, acct.Id);
            opps = oppCon.opportunity;

            
/*        Contact contactObj = new Contact();
            contactObj.FirstName = 'test1' +String.valueOf(DateTime.Now());
            contactObj.LastName = 'test2' + String.valueOf(DateTime.Now());
            contactObj.AccountId = acct.Id;
            contactObj.LMS_Role__c = 'B-Owner/Training Liaison';
            insert contactObj;  */

        List<Contact> lstContact = new List<Contact>(); 
        Contact cont1 = new Contact();
            cont1.FirstName = 'test1';
            cont1.LastName = 'test2';
            cont1.AccountId = acct.Id;
            lstContact.add(cont1);

        Contact cont2 = new Contact();
            cont2.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            cont2.FirstName = 'test1';
            cont2.LastName = 'test2';
            cont2.AccountId = acct.Id;
            lstContact.add(cont2);
            insert lstContact;              
            
        
        oppCon = new OpportunityContactInfoController();
            oppCon.oppId = opp.Id;
            opps = oppCon.opportunity;
            //System.assertEquals(opps.Id, opp.Id);
            //System.assertEquals(oppCon.account.Id, acct.Id);
            //System.assertEquals(oppCon.contacts.size(), 1);
            
        oppCon = new OpportunityContactInfoController();
            oppCon.oppId = opp1.Id;
            opps = oppCon.opportunity;
            //System.assertEquals(opps.Id, opp1.Id);
            //System.assertEquals(oppCon.account, null);
            //System.assertEquals(oppCon.contacts, null);
            Test.stopTest();
            
/*          
        List<Contact> lstContact = new List<Contact>(); 
        Contact cont1 = new Contact();
            cont1.FirstName = 'test1' +String.valueOf(DateTime.Now());
            cont1.LastName = 'test2' + String.valueOf(DateTime.Now());
            cont1.AccountId = acct.Id;
        //  cont1.LMS_Role__c = 'B-Owner/Training Liaison';
            lstContact.add(cont1);

        Contact cont2 = new Contact();
            cont2.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            cont2.FirstName = 'test1' +String.valueOf(DateTime.Now());
            cont2.LastName = 'test2' + String.valueOf(DateTime.Now());
            cont2.AccountId = acct.Id;
        //  cont2.LMS_Role__c = 'B-Owner/Training Liaison';
            lstContact.add(cont2);
            insert lstContact;              
*/          
            
    }
}