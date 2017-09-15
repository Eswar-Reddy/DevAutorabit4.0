@IsTest (SeeAllData=true)
public class ChatterNotificationUtility_Test {
   
    public static testMethod void testChatterNotificationUtility() {
        
        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = 'Sample CG3';
        cg.CollaborationType = 'Public';
        insert cg; 
                        
        Account accAccount = new Account(Name = 'BiggSun1 SolarCsTest1',
            Phone = '+919411111111',            
            BillingStreet = '77 Rio Roble', 
            BillingCity = 'San Jose',
            BillingState = 'CA', 
            BillingPostalCode = '95134', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',            
            Status__c = 'Active',
            Website = 'http://www.biggsun.com',
            Chatter_Group_Name__c = 'Sample CG3');
        insert accAccount;
        System.assertNotEquals(null, accAccount.Id);
        
        Account accAccount1 = new Account(Name = 'BiggSun1 PartnerAccount',
            Phone = '+919411111111',            
            BillingStreet = '8516 Hedges Pl', 
            BillingCity = 'Los Angeles',
            BillingState = 'CA', 
            BillingPostalCode = '90068', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',
            Chatter_Group_Name__c = 'Sample CG1',
            Status__c = 'Active',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(),
            Website = 'http://www.biggsun.com');
        insert accAccount1;   
        System.assertNotEquals(null, accAccount1.Id);
        
        Contact conContact = new Contact(AccountId = accAccount.Id,
            LastName = 'Sherpas1',
            FirstName = 'Cloud',
            Email = 'cs1@test.com');
        insert conContact;
        System.assertNotEquals(null, conContact.Id);        
        
        Partner p1 = new Partner(IsPrimary = true, AccountFromId = accAccount.Id, 
            AccountToId = accAccount1.Id);
        insert p1;
        System.assertNotEquals(null, p1.Id); 
        
        Test.startTest();
        
        RecordType rType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Home Owner'];
        Opportunity opp = new Opportunity();
        opp.Name = 'Test BiggSunOpp';
        opp.AccountId = accAccount.Id;
        opp.Primary_Contact__c = conContact.Id;
        opp.StageName = 'New Opportunity';
        opp.Dealer_Selection__c = accAccount1.Id;
        opp.CloseDate = Date.today();
        opp.RecordTypeId =  rType.Id;
        opp.Partner_Account_Id__c = accAccount1.Id;
        insert opp;
        System.assertNotEquals(null, opp.Id);      
           
        Partner p2 = new Partner(IsPrimary = true, OpportunityId = opp.Id, 
            AccountToId = accAccount1.Id);
        insert p2;
        System.assertNotEquals(null, p2.Id); 
        //System.assert([SELECT Id, AccountToId FROM OpportunityPartner WHERE AccountToId =: accAccount1.Id].size() > 0);
        //System.assert([SELECT Id, OpportunityId FROM OpportunityPartner WHERE OpportunityId =: opp.Id].size() > 0);
        
        opp = [SELECT Id, Name, AccountId, OwnerId, Partner_Account_Id__c, PartnerAccountId, Primary_Contact__c,
            StageName, Dealer_Selection__c, CloseDate FROM Opportunity 
            WHERE id =: opp.Id];
        //System.assertNotEquals(null, opp.PartnerAccountId); 
        
        ChatterNotificationUtility.createOppAssignmentPost(opp, 'OpportunityAssignment', Userinfo.getUserId());
        
        ChatterNotificationUtility.createOppAssignmentPost(opp, 'ChangeOwner', Userinfo.getUserId());
        
        ChatterNotificationUtility.createOppAssignmentPost(opp, 'DeclineOpportunity', Userinfo.getUserId());
        
        
        /*Lead l = new Lead( FirstName = 'Test', LastName = 'LastName', Company = 'Test LastName', 
            street = '8516 Hedges Pl', city = 'Los Angeles', state = 'CA', country = 'United States', 
            PostalCode = '90068', status = 'Open', email = 'testlastname@fakemail.com',  isConverted = false,
            Description = 'This is a test Lead', Dealer_Locator_Selection__c = accAccount1.Id, LeadSource='Web',
            Theater__c = 'North America', Lead_Manufacturer__c = 'SunPower', IsAutoConvert__c = true,
            RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Residential').getRecordTypeId());
        insert l;   
        System.assertNotEquals(null, l.Id);  
        */
        
        Test.stopTest();
        //System.assertEquals(true, [SELECT isConverted FROM Lead WHERE Id =: l.Id].isConverted);
    }
}