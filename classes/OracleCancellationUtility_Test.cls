/*
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

/* **************************************************************************************
* Class Name     : OracleCancellationUtility_Test
* Version           : 1.0
* Created Date   :    JAN 18 2017
* Function       :

* Modification Log :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                    JAN 18 2017          Original Version
*************************************************************************************/
@isTest(seeAllData = false)
public class OracleCancellationUtility_Test {

      @testSetup static void CreateTestData() {
        
         Lease_2_1_PO_Creation__c lspo = TestFactory_Custom_Settings.createLease21POCreation();
         insert lspo;
         
         Lease_2_1_PO_Creation__c settings = new Lease_2_1_PO_Creation__c(name='Lease_2_1_Bypass',Lease_2_1_Test_Method_Bypass__c=true);
         insert settings;
         
      // inserting partner and customer account
         Account customerAccount = TestFactory_StandardObjects.getResidentialCustomerAccount();
         Account installerPartner = TestFactory_StandardObjects.getInstallerAccount();
      // inserting Contact
         Contact customerContact = TestFactory_StandardObjects.createCustomerContact(customerAccount.Id);
         Insert customerContact;
      // Creating Opp
         Opportunity opp = TestFactory_StandardObjects.createHomeOwnerOpportunity(customerAccount.Id,installerPartner.Id);
         insert opp;
      // Inserting Quote
         Quote qt = TestFactory_StandardObjects.createProposalQuote(opp.Id);
         qt.Name = 'TestOracleHoldCancelltion';
         qt.Account__c = opp.AccountId;
         insert qt;

         echosign_dev1__SIGN_Agreement__c cancelledAgreement = new echosign_dev1__SIGN_Agreement__c();
         cancelledAgreement.Name='Cancelled Contract';
         cancelledAgreement.Agreement_Name__c='Cancelled Contract';
         cancelledAgreement.echosign_dev1__Status__c = 'Draft';
         cancelledAgreement.Quote__c = qt.Id;
         cancelledAgreement.echosign_dev1__Recipient__c = customerContact.Id;
         cancelledAgreement.Account__c = qt.Account__c;
         cancelledAgreement.recordTypeId = TestClassFactory.retrieveRecordTypeID('echosign_dev1__SIGN_Agreement__c','Lease Contract');
         insert cancelledAgreement;

         Purchase_Order__c po = new purchase_Order__c();
         po.Opportunity__c = opp.Id;
         po.Quote__c = qt.Id;
         po.End_Customer_Account__c = customerAccount.Id;
         po.Dealer_Account__c = installerPartner.Id;
         po.Order_Status__c  = 'Submitted';
         insert po;

        system.debug(LoggingLevel.ERROR, '----po-----' + po);

        LeasePayment__c LP = TestUtils.createLeasePayment('OracleCancellationFunctionality',customerAccount.Id,false);
         LP.Quote__c= qt.Id;
         LP.Opportunity__c = opp.Id;
         LP.Contact__c = customerContact.Id;
         LP.Date_Lease_Document_signed__c = Date.Today();
         LP.Partner_Account__c = installerPartner.Id;
         LP.Oracle_Cancellation_Status__c = 'HOLD';
        insert LP;

        system.debug(LoggingLevel.ERROR, '----LP-----' + LP);


     }


     public static testmethod void OracleCancellationUtility_hold_Test(){
         List<Quote> qt = [select Id,(select Id from Agreements__r) from Quote where Name = 'TestOracleHoldCancelltion'];
         if(qt <> null && qt[0].agreements__r.size()>0){
            qt[0].agreements__r[0].echosign_dev1__Status__c = 'Out for Signature';
             system.debug(LoggingLevel.ERROR, '--before Update agreement---' + qt[0].agreements__r[0]);
              Update qt[0].agreements__r[0];
             system.debug(LoggingLevel.ERROR, '--after update agreement---' + qt[0].agreements__r[0]);

            Test.setMock(HttpCalloutMock.class, new OracleCancellationMockResponse());
            Test.startTest();
              OracleCancellationUtility.fCallToOralce(qt[0].Agreements__r[0].Id,qt[0].Id,'Hold');
            Test.stopTest();
         }
       }
     public static testmethod void OracleCancellationUtility_Cancel_Test(){

        List<Quote> qt = [select Id,(select Id from Agreements__r), (select Id,Oracle_Cancellation_Status__c from Lease_Payments__r) from Quote where Name = 'TestOracleHoldCancelltion'];
        if(qt <> null && qt[0].agreements__r.size()>0){
            qt[0].agreements__r[0].echosign_dev1__Status__c = 'Signed';
            system.debug(LoggingLevel.ERROR, '-Cancel--before Update agreement---' + qt[0].agreements__r[0]);
              Update qt[0].agreements__r[0];
           system.debug(LoggingLevel.ERROR, '-Cancel---after Update agreement---' + qt[0].agreements__r[0]);
            Test.setMock(HttpCalloutMock.class, new OracleCancellationMockResponse());
            Test.startTest();
                OracleCancellationUtility.fCallToOralce(qt[0].Agreements__r[0].Id,qt[0].Id,'Cancel');
            Test.stopTest();
         }
       }
}