/**
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
@isTest(SeeAllData = false)
private class TestTPSDocumentUtility {
    
    /*    updateInvoiceDocumentWithUploaded is getting covered in TestDocumentWorkebenchController class. 
     *    In this TestTPSDocumentUtility, we are inserting the document and adding an attachment to it. 
     *    It'll fire updateInvoiceDocumentWithUploaded methods and cover it. To get the more information,  
     *    Please refer to TestDocumentWorkebenchController.  
     */


    /*   Below method is used to cover fUpdateHomeOwnerApproval. It's covers the functionality where the Hoem Owner Approval
     *   layout for TPS work bench updated as Submitted , whenever Agreement having Contract_TYPE = 'Design Layout'
     *   move to the status as 'Signed' from Other status.
     */
     
    Static testMethod void fUpdateHomeOwnerApproval () {

      TestClassFactory.createAndInsertLeaseAgreementSettings();
          
     // Create Account
       list<Account> lAcc = TestUtils.createAccounts(1,false);  
       insert lAcc;
        
       set<Id> sAccId = new set<Id> ();
       sAccId.add(lAcc[0].Id); 
        
       Contract con = new Contract(); 
       con.AccountId = lAcc[0].Id;
       con.Status = 'New';
       con.Contract_Type__c = 'Design Layout';
       insert con;
        
      List<LeasePayment__c> lleasePayment = TestUtils.createLeasePayments(2,lAcc[0].Id,false) ;
      lleasePayment[0].End_Customer_Account__c = lAcc[0].Id;
      insert lleasePayment;
        
      List<Invoice_Documents__c> lInvDoc = TestUtils.createInvoiceDocuments(1,lleasePayment[0].Id,'HO Layout Approval',false);
      lInvDoc[0].Documents_in_File__c = 'HO Layout Approval';
      lInvDoc[0].Lease_Payment__c = lleasePayment[0].Id;
      insert lInvDoc;  
        
      List<echosign_dev1__SIGN_Agreement__c> lAgreements =  TestUtils.createAgreements(sAccId,false);
      lAgreements[0].echosign_dev1__Contract__c = con.Id;
      lAgreements[0].Approved__c = true;
        
      insert lAgreements; 
        
       
       Test.startTest();
            lAgreements[0].echosign_dev1__Status__c = 'Signed';
            update lAgreements;
       Test.stopTest(); 
        
    }
}