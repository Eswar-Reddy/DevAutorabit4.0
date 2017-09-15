@isTest(SeeAllData=true)
public class DeclineOpportunityCX_Test {
    
    public static Account accAccount;
    public static Contact conContact;
    public static User usr;
    
    static {      
               
        accAccount = new Account(Name = 'BiggSun1 SolarCsTest1',
            Phone = '+919411111111',            
            BillingStreet = '77 Rio Roble', 
            BillingCity = 'San Jose',
            BillingState = 'CA', 
            BillingPostalCode = '95134', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',
            Chatter_Group_Name__c = 'BiggSun Solar',
            Status__c = 'Active',
            Website = 'http://www.biggsun.com');
        insert accAccount;   
        System.assertNotEquals(null, accAccount.Id);
        
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
        
    public static testMethod void testDeclineOpportunityCX() {
        
        Test.startTest();
        
        Opportunity opp = new Opportunity();
        opp = new Opportunity( Name = 'Test BiggSunOpp', 
            StageName = 'New Opportunity', 
            OwnerId = usr.Id, 
            //PartnerAccountId = accAccount.Id,
            Lead_Manufacturer__c = 'SunPower',
            Primary_Contact__c = conContact.Id,
            CloseDate = System.today(),
            AccountId = accAccount.Id);        
            insert opp;
        System.assertNotEquals(null, opp.Id);
        
        System.runAs(usr) {                                
            PageReference pageRef = Page.DeclineOpportunity;
            pageRef.getParameters().put('id',opp.Id);            
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(opp);
            DeclineOpportunityCX controller = new DeclineOpportunityCX(sc);
            controller.getDeclineReasons();
            controller.selectedDeclineReason = 'Not qualified  - Renter';
            controller.declineOpportunity();
            
            controller.selectedDeclineReason = 'Not qualified – Credit';
            controller.declineOpportunity();   
            
            controller.selectedDeclineReason = '';
            controller.declineOpportunity();
        }
  
        Test.stopTest();
    }
}