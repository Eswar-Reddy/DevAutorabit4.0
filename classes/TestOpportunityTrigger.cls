@IsTest (SeeAllData=true)
public class TestOpportunityTrigger {
 static testMethod void testOpportunityTrigger()
    {
        Util.isTestnonGethealthyCode = true;
        Set<String> mySet = new Set<String>();
        mySet.add('Account');

        mySet.add('afterOpportunityUpdate');
         mySet.add('beforeOpportunityUpdate');
        mySet.add('UpdateOpportunityRoleAmountValue');
        mySet.add('DummyOpportunity');
        mySet.add('OppTrigger');
         mySet.add('beforeOpportunityInsert');
        mySet.add('Opportunity');
        mySet.add('OpportunityTriggerSharingAndSurvey');
        mySet.add('OpportunityNotificationTrigger');
        mySet.add('afterOpportunityInsert');
        mySet.add('onbeforeUpdate');
        mySet.add('OpportunityAfterUpdateTrigger');
        TestAccountTriggerGethealthy.byPassHelper(mySet);
        
        Account acct = new Account();
        acct.Name = 'Test123456888999';
        acct.Type = 'Elite-Partner-Residential';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'DeSoto';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '751234';
        acct.Opp_Convert_Rate__c = 70;
        acct.Theater__c='North America';
        
        acct.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SobjectType).get('Partner');
        
        
        
        Account acct1 = new Account();
        acct1.Name = 'Test123456888999';
        acct1.Type = 'Elite-Partner-Residential';
        acct1.RSM_Discretionary_Adj__c = 5;
        acct1.BillingCity = 'DeSoto';
        acct1.BillingStreet = 'Main Street';
        acct1.BillingState = 'AZ';
        acct1.BillingCountry = 'United States';
        acct1.BillingPostalCode = '751234';
        acct1.Opp_Convert_Rate__c = 70;
        acct1.Theater__c='North America';
        
        acct.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SobjectType).get('Home_Owner');
        
        list<Account> listAccount = new list<Account>();
        
		listAccount.add(acct1);
        listAccount.add(acct);
        insert listAccount;
        
        Contact objContact= new Contact();
		objContact.Phone='123-456-12345';
		objContact.lastName ='test';
		objContact.Email='ss@gmail.com';
		objContact.MailingCity = 'Irving';
		objContact.MailingStreet = 'Main Street';
		objContact.MailingState = 'TX';
		objContact.MailingCountry = 'United States';
		objContact.MailingPostalCode = '75038';
		objContact.AccountId = acct.Id;
		objContact.primary__c = true;
            
        insert objContact;
        
        
       Opportunity oppObj = new Opportunity();
       oppObj.Name = 'testOpp';
       oppObj.StageName = '25% - Site Audit Completed';
       oppObj.CloseDate = Date.today();
       oppObj.Lead_Manufacturer__c ='SunPower';
       oppObj.Is_Excluded_From_SLA_Score__c = true;
       oppObj.Partner_Account_Id__c =acct.id;
       //oppObj.PartnerAccountID = acct.id;
       oppObj.AccountId =acct1.id;
       oppObj.Amount=300;
       oppObj.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Home Owner').RecordTypeId; 
       User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.id ='00e80000001SqIlAAK' AND isActive=true limit 1];
       oppObj.OwnerId = objUser.id;
       oppObj.Primary_Contact__c = objContact.id;
       oppObj.Customer_Satisfaction_Survey_opt_in__c = true;
       
      
       Test.startTest();
       
        insert oppObj;
       Opportunity_Role__c OpportunityRole= new Opportunity_Role__c();
       OpportunityRole.Amount__c = 300;
       OpportunityRole.Opp_Name__c = oppObj.id;
       
       insert OpportunityRole;
        
       oppObj.Amount=301;
       oppObj.stageName = 'Installation Completed';
       oppObj.OwnerId = userinfo.getUserId();
       //oppObj.PartnerAccountID = acct1.id;
       oppObj.Partner_Account_Id__c = acct1.id; 
       update oppObj;
        Test.stopTest();
    }
    static testMethod void testOpportunityTriggerSettings()
    {
        Util.isTestnonGethealthyCode = true;
     Opportunity oppObj = new Opportunity();
       oppObj.Name = 'testOpp';
       oppObj.StageName = '25% - Site Audit Completed';
       oppObj.CloseDate = Date.today();
       oppObj.Lead_Manufacturer__c ='SunPower';
       oppObj.Is_Excluded_From_SLA_Score__c = true;
       oppObj.Amount=300;
       oppObj.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Home Owner').RecordTypeId; 
       User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.id ='00e80000001SqIlAAK' AND isActive=true limit 1];
       oppObj.OwnerId = objUser.id;
       insert oppObj;
        
    }
}