@isTest
public class SurveyUtilityTestData {

    public Opportunity oppty_1;
    public Account spdPartnerAccount_1;

    public void createTestData() {
        // custom setting
        Survey_Countries__c setting_1 = new Survey_Countries__c();
        setting_1.Name = 'United States';    // USA does not work. looks like name standardization
        setting_1.Sales_Survey__c = true;
        setting_1.Install_Survey__c = true;
        setting_1.One_Year_Survey__c = true;
        insert new List <Survey_Countries__c> {setting_1};
        
        // account
        Account account_1 = new Account();
        account_1.Name = 'account_1';
        account_1.BillingCountry = 'United States';        // condition for Is valid opportunity for survey
        
        // partner account
        Account partnerAccount_1 = new Account();
        partnerAccount_1.Name = 'partnerAccount_1';
        spdPartnerAccount_1 = new Account();
        spdPartnerAccount_1.Name = 'spdPartnerAccount_1 (SPD)';    // name should have (SPD) in it

        insert new List <Account> {account_1, partnerAccount_1, spdPartnerAccount_1};
        
        // contact
        Contact contact_1 = new Contact();
        contact_1.FirstName = 'test' +String.valueOf(DateTime.Now());
        contact_1.LastName = 'test' + String.valueOf(DateTime.Now());
        contact_1.AccountId = account_1.Id;
        // condition for Is valid opportunity for survey
        contact_1.Email = 'test.' + String.valueOf(DateTime.now().month() * DateTime.now().millisecond()) + '@test' + String.valueOf(DateTime.now().month() * DateTime.now().millisecond()) + '.com';
        insert contact_1;
        
        // opportunity
        oppty_1 = new Opportunity();
        oppty_1.Name = 'testOpp1';
        oppty_1.AccountId = account_1.Id; 
        oppty_1.Partner_Account_Id__c = partnerAccount_1.Id;
        oppty_1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
        oppty_1.stageName = 'Installation Completed';
        oppty_1.Primary_Contact__c = contact_1.Id;        // condition for Is valid opportunity for survey
        oppty_1.Customer_Satisfaction_Survey_opt_in__c = true;
        oppty_1.CloseDate = Date.today();
        
        // we will insert in test class
        //insert oppty_1; 
        
        
    }
    
}