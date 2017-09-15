@isTest(SeeAllData=true)
public class OpportunityTriggers_Test {
    
    public static Account accAccount;
    public static Account accAccount1;
    public static Contact conContact;
    public static User usr;
    public static CollaborationGroup cg;
    
    static {      
        
        cg = new CollaborationGroup();
        cg.Name = 'Sample CG1';
        cg.CollaborationType = 'Public';
        insert cg; 
        System.assertNotEquals(null, cg.Id);
        
        accAccount = new Account(Name = 'BiggSun1 SolarCsTest1',
            Phone = '+919411111111',            
            BillingStreet = '77 Rio Roble', 
            BillingCity = 'San Jose',
            BillingState = 'CA', 
            BillingPostalCode = '95134', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',
            Chatter_Group_Name__c = 'Sample CG1',
            Status__c = 'Active',            
            Website = 'http://www.biggsun.com');
        insert accAccount;
        System.assertNotEquals(null, accAccount.Id);
               
        accAccount1 = new Account(Name = 'BiggSun1 PartnerAccount',
            Phone = '+919411111111',            
            BillingStreet = '77 Rio Roble', 
            BillingCity = 'San Jose',
            BillingState = 'CA', 
            BillingPostalCode = '95134', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',
            Chatter_Group_Name__c = 'Sample CG1',
            Status__c = 'Active',
            Oracle_Operating_Unit__c = 'SPNA OU',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(),
            Website = 'http://www.biggsun.com');
        insert accAccount1;   
        System.assertNotEquals(null, accAccount1.Id);
        
        conContact = new Contact(AccountId = accAccount.Id,
            LastName = 'Sherpas1',
            FirstName = 'Cloud',
            Email = 'cs1@test.com');
        insert conContact;
        System.assertNotEquals(null, conContact.Id);       
                
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'Partner Executive' LIMIT 1];
        System.assertNotEquals(null, p.Id);
        
        usr =  [SELECT Id, Name, Contact.AccountId, ProfileId FROM User WHERE ContactId != null AND IsActive = true AND ProfileId =: p.Id LIMIT 1];
        System.assertNotEquals(null, usr.Id);        
    }
        
    public static testMethod void testOpportunityTriggers() {
        
        
        
        Opportunity opp = new Opportunity();
        opp = new Opportunity( Name = 'Test BiggSunOpp', 
            StageName = 'New Opportunity', 
            //OwnerId = usr.Id, 
            //PartnerAccountId = accAccount.Id,
            Lead_Manufacturer__c = 'SunPower',
            Primary_Contact__c = conContact.Id,
            Dealer_Assignment_Date__c = System.today()+1,
            CloseDate = System.today(),
            AccountId = accAccount.Id);        
            insert opp;
        System.assertNotEquals(null, opp.Id);
                
        Partner p = new Partner(IsPrimary = true, OpportunityId = opp.Id, 
            AccountToId = accAccount1.Id);
        insert p;
        System.assertNotEquals(null, p.Id);
        Test.startTest();
        opp.OwnerId = usr.Id;
        update opp;
        
        Test.stopTest();
    }

    private static testMethod void test_OpportunityStatus_InReview() {
        Opportunity opp_1 = new Opportunity(Name = 'opp_1', AccountId = accAccount.Id, StageName = 'New Opportunity', 
            CloseDate = System.today());
        insert new List <Opportunity>{opp_1};        
        opp_1.Opportunity_Status__c = 'In Review';
        update opp_1;

    }

    private static testMethod void test_Opportunity_Amount() {
        Opportunity opp_1 = new Opportunity(Name = 'opp_1', AccountId = accAccount.Id, StageName = 'New Opportunity', 
            CloseDate = System.today());
        insert new List <Opportunity>{opp_1}; 
        Opportunity_Role__c oppRole_1 = new Opportunity_Role__c(Opp_Name__c = opp_1.Id, Opportunity__c = opp_1.Id);
        insert new List <Opportunity_Role__c>{oppRole_1};       
        opp_1.Amount = 1000;
        update opp_1;

    }

    private static testMethod void test_LeadManufacturer_SunPower() {
        Opportunity opp_1 = new Opportunity(Name = 'opp_1', AccountId = accAccount.Id, StageName = 'New Opportunity', 
            CloseDate = System.today(), Lead_Manufacturer__c = 'SunPower', OwnerId = usr.Id, Partner_Account_Id__c = accAccount.Id);
        insert new List <Opportunity>{opp_1};        

    }

    private static testMethod void test_nacRequirements() {
        Opportunity opp_1 = new Opportunity(Name = 'opp_1', AccountId = accAccount.Id, StageName = 'New Opportunity', 
            CloseDate = System.today(), RecordTypeId = OpportunityUtilities.systemOppRecTypeId, Business_Unit__c = 'NA Commercial');
        insert new List <Opportunity>{opp_1};        
        opp_1.StageName = '02 - Finalize SSO';
        Database.update(opp_1, false);

    }
    
}