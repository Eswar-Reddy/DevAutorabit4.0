@isTest
public class TestCreditCheckUtil {
    
        public static Account partnerAccount;
        public static Contact partnerContact;
        public static User partnerUser;
    
    public static testMethod void testcreditCheckUtil1(){
        
        UserManagement.IS_TEST = true;
        
        partnerAccount = TestUtils.createAccount( 'PartnerAcct', TestUtils.getPartnerRecordTypeId(), false );
        partnerAccount.BillingState = 'CA';
        partnerAccount.BillingCountry= 'United States';
        partnerAccount.Lease2_0_Program_Partner__c = true;
        partnerAccount.Loan_Partner__c = true;
        insert partnerAccount;
        
        partnerContact = TestUtils.createContact('CustomerContact', partnerAccount.Id, false);
        partnerContact.Primary__c = true;
        insert partnerContact;
        
        partnerUser = TestUtils.createPartnerPortalUser(partnerContact,false);
        partnerUser.Business_Function__c = 'Create Lease Quote;Create Loan Quote';
        insert partnerUser;
        Id customerAccountRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sobjectType).get('Home_Owner');
        Account customerAccount = TestUtils.createAccount('Test Lease',customerAccountRecordTypeId,false);
            customerAccount.ShippingCity = 'San Jose';
            customerAccount.ShippingStreet = 'Rio Robles';
            customerAccount.ShippingCountry = 'United States';
            customerAccount.ShippingState='CA';
            customerAccount.ShippingPostalCode ='95134';
            customerAccount.BillingCity = 'San Jose';
            customerAccount.BillingStreet = 'Rio Robles';
            customerAccount.BillingCountry = 'United States';
            customerAccount.BillingState='CA';
            customerAccount.BillingPostalCode ='95134';
       		insert customerAccount;

       	Contact customerContact = TestUtils.createContact('Test Lease', customerAccount.Id, true);
        
       	Credit_Check_Request__c ccr = new Credit_Check_Request__c(Application_Id__c = '36377',
                                                                  Account__c = customerAccount.Id,
                                                                  Application_Type__c = 'Lease',
                                                                  Contact__c = customerContact.Id,
                                                                  Credit_Beureu__c = 'LoanPath',
                                                                  Email__c = 'testCreditCheckUtil@test.com');
       	insert ccr;
        
        Set<String> permissionsSet = CreditCheckUtil.getPartnerPermissions();
        String partnerUrl = 'https://' + 
                                (ApexPages.currentPage().getHeaders().get('Host') != null ? ApexPages.currentPage().getHeaders().get('Host') : 'login.salesforce.com') +
                                '/services/Soap/u/22.0/' + 
                                UserInfo.getOrganizationId();
        test.startTest();
        System.runAs(partnerUser){
            permissionsSet = CreditCheckUtil.getPartnerPermissions();
            CreditCheckUtil.SendCreditRequest_LoanPath(ccr.Id,partnerUrl,UserInfo.getSessionId(),'ncr',true);
            CreditCheckUtil.SendCreditRequest_LoanPath(ccr.Id,partnerUrl,UserInfo.getSessionId(),'ncr',false);
        }
        test.stopTest();
    }
}