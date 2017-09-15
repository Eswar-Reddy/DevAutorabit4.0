/* **************************************************************************************
* Class Name     : DocGenEconomicAmendmentRequest_test
* Version        : 1.0
* Created Date   : 30 April 2017
* Function       : It's a class to make call to DocGen for Economic document creation.

* Modification Log    :
* Developer                Date                 Description
* ----------------------------------------------------------------------------
* Ankit                    10 May 2017          Original Version
*************************************************************************************/
@isTest(seeAllData = false)
public class DocGenEconomicAmendmentRequest_test {

public static testmethod void testDocGenEconomicAmendment(){

  // inserting partner and customer account
      Account customerAccount = TestFactory_StandardObjects.getResidentialCustomerAccount();
      Account installerPartner = TestFactory_StandardObjects.getInstallerAccount();
 // inserting Contact
      List<contact> customerContacts = new List<Contact>{
                                                         TestFactory_StandardObjects.createCustomerContact(customerAccount.Id),
                                                         TestFactory_StandardObjects.createCustomerContact(customerAccount.Id)
                                                        };
       customerContacts[0].primary__c = true;
       customerContacts[1].Include_in_Lease_Doc__c = true;
       insert customerContacts;
// Creating Opp
      Opportunity opp = TestFactory_StandardObjects.createHomeOwnerOpportunity(customerAccount.Id,installerPartner.Id);
      insert opp;
// Inserting Quote
      Quote qt = TestFactory_StandardObjects.createProposalQuote(opp.Id);
      qt.Name = 'TestOracleHoldCancelltion';
      qt.Account__c = opp.AccountId;
      insert qt;

      DocGen_Callout_Settings__c docGenCallSetting = TestFactory_Custom_Settings.CreateDocGenCallOutSetting();
      insert docGenCallSetting;

      Lease_2_1_PO_Creation__c LeasePOCreation = TestFactory_Custom_Settings.createLease21POCreation();
      insert LeasePOCreation;

      Test.StartTest();
       Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock(200,'success','Agreement pdf created',null));
       DocGenEconomicAmendmentRequest.createAgreementRecord(qt.Id,Schema.SObjectType.echosign_dev1__SIGN_Agreement__c.getRecordTypeInfosByName().get('Amendment Agreement').getRecordTypeId(),'test@test.com','Test Notes','Economic Amendmnet','Economic');
      Test.StopTest();
   }

}