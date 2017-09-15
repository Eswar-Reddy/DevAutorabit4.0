@isTest
public class DealerUtilityPricingFileTestData {

    @TestVisible private Account partnerAccount_1, partnerAccount_2, account_1;
    
    @TestVisible
    private void createTestData() {
        // partner account
        partnerAccount_1 = new Account();
        partnerAccount_1.Name = 'partnerAccount_1'; 
        partnerAccount_1.BillingStreet = '100 XYZ Plaza';
        partnerAccount_1.BillingCity = 'Sunnyvale';
        partnerAccount_1.BillingState = 'CA';
        partnerAccount_1.BillingCountry = 'United States'; 
        partnerAccount_1.BillingPostalCode = '94086';  

        partnerAccount_2 = new Account();
        partnerAccount_2.Name = 'partnerAccount_2'; 
        partnerAccount_2.BillingStreet = '200 ABC Plaza';
        partnerAccount_2.BillingCity = 'Sunnyvale';
        partnerAccount_2.BillingState = 'CA';
        partnerAccount_2.BillingCountry = 'United States'; 
        partnerAccount_2.BillingPostalCode = '94086';  
        
        insert new List <Account>{partnerAccount_1, partnerAccount_2};  
        
        // Account
        account_1 = new Account();    
        account_1.Name = 'account_1'; 
        account_1.BillingStreet = '300 Test Plaza';
        account_1.BillingCity = 'San Jose';
        account_1.BillingState = 'CA';
        account_1.BillingCountry = 'United States'; 
        account_1.BillingPostalCode = '95086'; 
        account_1.Partner_Account__c = partnerAccount_1.Id; 

        insert new List <Account>{account_1};  
    }
    
    @TestVisible
    private static Utility_Code__c getNewUtilityCode(String name, String stateCode, String utilityName) {
        return new Utility_Code__c(Name = name, State_Code__c = stateCode, Utility_Name__c = utilityName);    
    }
    
    @TestVisible
    private static Dealer_Utility_Pricing_File__c getNewDUPF(String dealerId, String utilityCodeId, String state, 
        String utility, String fileName) {
    
        Dealer_Utility_Pricing_File__c dupf = new Dealer_Utility_Pricing_File__c();
        dupf.Dealer__c = dealerId;
        dupf.Utility_Code__c = utilityCodeId;
        dupf.State__c = state;
        dupf.Utility__c = utility;
        dupf.Pricing_File_Name__c = fileName;
        return dupf;
    }

}