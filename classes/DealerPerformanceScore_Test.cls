@isTest(SeeAllData=true)
public class DealerPerformanceScore_Test {
    
    public static Account accAccount;
    public static Contact conContact;
    public static User usr;
    
    static {      
                 
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'Partner Executive' LIMIT 1];
        System.assertNotEquals(null, p.Id);
        
        usr =  [SELECT Id, Name, Contact.AccountId, ProfileId FROM User WHERE ContactId != null AND IsActive = true AND ProfileId =: p.Id LIMIT 1];
        System.assertNotEquals(null, usr.Id);        
    }
        
    public static testMethod void testDealerPerformanceScoreCxPosi() {
        
        Test.startTest();
        System.runAs(usr) {
        
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
                Website = 'http://www.biggsun.com',            
                Opp_Convert_Rate__c = 90,
                Contact_SLA__c = 30, 
                SFDC_Timely_Updates__c = 40, 
                RSM_Discretionary_Adj__c = 5);
            insert accAccount;   
            System.assertNotEquals(null, accAccount.Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(accAccount);
            DealerPerformanceScoreCx stdcontroller = new DealerPerformanceScoreCx(sc);
            DealerPerformanceScoreCx dps = new DealerPerformanceScoreCx();
        }
        Test.stopTest();
    }
    
    public static testMethod void testDealerPerformanceScoreCxNega() {
        
        Test.startTest();
        System.runAs(usr) {
        
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
                Website = 'http://www.biggsun.com',            
                Opp_Convert_Rate__c = null,
                Contact_SLA__c = null, 
                SFDC_Timely_Updates__c = null, 
                RSM_Discretionary_Adj__c = null);
            insert accAccount;   
            System.assertNotEquals(null, accAccount.Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(accAccount);
            DealerPerformanceScoreCx stdcontroller = new DealerPerformanceScoreCx(sc);
            DealerPerformanceScoreCx dps = new DealerPerformanceScoreCx();
        }
        Test.stopTest();
    }
}