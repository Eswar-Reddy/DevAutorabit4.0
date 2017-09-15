@isTest

public class sendEmailSPVTClassAndHandlerTest{
    
    static Account newAccount;
    static Contact newContact;
    static Contact newContact1;
    static Opportunity newOpportunity;
    static Quote newQuote;
    static Account newPartnerAccount;
    static  Account newPartnerAccountReturn;
    
    static testMethod void leasepaymentCreationAndUpdate() {
        newPartnerAccount=TestUtils.createAccount('Partner TEST ACCOUNT 1', TestUtils.getPartnerRecordTypeId(), true);
        newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , true );
        newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );
        newContact1 = TestUtils.createContact('CPR TEST CONTACT 11', newPartnerAccount.Id, true );
        newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];
        LeasePayment__c leasePayment = TestUtils.createLeasePayment( 'Lease Payment', newAccount.Id, newQuote.Id, false );
        
        //Creating User
        User user= TestUtils.createUser ('Sunpower Admin(No Deployment)',false);
        User user1= TestUtils.createUser ('Sunpower Admin(No Deployment)',false); 
        newPartnerAccountReturn=[SELECT Area_Sales_Manager__c,Residential_Field_Supervisor__c FROM Account WHERE Id =:newPartnerAccount.id LIMIT 1];
        newPartnerAccountReturn.Area_Sales_Manager__c=user1.id;
        newPartnerAccountReturn.Residential_Field_Supervisor__c=user.id;
        update newPartnerAccountReturn;
        //Creating Account Role
        AccountContactRole acr1 = new AccountContactRole();
        acr1.AccountId = newPartnerAccount.Id;
        acr1.ContactId = newContact1.Id;
        acr1.Role = 'SPVT Notification';
        acr1.IsPrimary=True;
        insert acr1;
        
        leasePayment.Funding_Tranche__c  ='SPWR';
        leasePayment.Site_State_Prov_old__c ='CA';
        leasePayment.Date_Countersigned_old__c =system.today()-30;
        leasePayment.Partner_Account__c=newPartnerAccountReturn.Id;
        leasePayment.Dealer_Lease_Contact_Email__c=System.now().getTime()+'@123test.com.test';
        insert leasePayment;
        
        SPVTBCCEMailsSend__c sendBccEmail=new SPVTBCCEMailsSend__c();
        sendBccEmail.Name=System.now().getTime()+'@12test.com.test';
        sendBccEmail.bccEMailsSend__c=System.now().getTime()+'@12test.com.test';
        insert sendBccEmail; 
        
        LeasePayment__c leasePaymentReturn=[SELECT Partner_Account__c,Dealer_Lease_Contact_Email__c, Partner_Account__r.Area_Sales_Manager_Email__c, Partner_Account__r.RSM_Mail__c, Partner_Account__r.FSR_email__c, Lease__c, End_Customer_Account__r.Name, Partner_Account__r.FSR_NAME__c, Partner_Account__r.FSR_phone_no__c FROM LeasePayment__c  where Id =:leasePayment.id LIMIT 1];
        Test.startTest();
        leasePaymentReturn.SPVT_Result__c='Fail';
        leasePaymentReturn.SPVT_case_to_SunPower__c=true;
        update leasePaymentReturn; 
        Test.stopTest();
       System.assertEquals(leasePaymentReturn.Partner_Account__c,newPartnerAccountReturn.id,'Working');
    
    }
  
    
}