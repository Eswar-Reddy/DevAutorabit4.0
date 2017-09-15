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
@isTest(SeeAllData = true)
private class DocGenAmendmentRequest_Test {
     
     public static testmethod void DocGenAmendmentRequestTest(){
       
      TestDocGenContractRequest.unitTest();
      System.debug(LoggingLevel.ERROR, '-------- ' + TestDocGenContractRequest.newQuote); 
      List<Account> lstAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,(SELECT FirstName, LastName FROM Contacts WHERE Primary__c = TRUE) FROM Account WHERE Id =:TestDocGenContractRequest.customerAccount.Id];
    if(lstAccount <> NUll && lstAccount.size() > 0){
      ChangeOrderAmendmentController.AccountInfo accountInfoObj = new ChangeOrderAmendmentController.AccountInfo(lstAccount[0]);
      ChangeOrderAmendmentController.Cosignee coSigneeObj = new ChangeOrderAmendmentController.Cosignee(TestDocGenContractRequest.customerContact,true,1,'',true);
      echosign_dev1__SIGN_Agreement__c agg = new echosign_dev1__SIGN_Agreement__c();
         agg.Name ='Test Agg';
         agg.Account__c = TestDocGenContractRequest.customerAccount.Id;
         agg.echosign_dev1__Status__c= 'Signed';
         agg.RecordTypeId = AgreementUtility.amendmentRecTypeId;
         agg.Quote__c = TestDocGenContractRequest.newQuote.Id;
         agg.echosign_dev1__DateSigned__c = System.now();
      insert agg;
      List<echosign_dev1__SIGN_Agreement__c> listAgg = [select Id,Name,account__c,echosign_dev1__Status__c,Quote__c,echosign_dev1__DateSigned__c,echosign_dev1__DateSignedDate__c from echosign_dev1__SIGN_Agreement__c where Id=:agg.Id Limit 1];
      System.debug(LoggingLevel.ERROR, '-------- ' + agg);
      DocGenAmendmentRequest.sendRequestToDocgen(listAgg[0],accountInfoObj,coSigneeObj,null,'HomeOwner Information Change',Null);
     } 
   }  
}