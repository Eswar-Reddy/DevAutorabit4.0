@isTest
private class GenerateAndAttachACHpdfControllerTest {
  private static Map<String, Schema.sObjectType> sObjectSchema;
  static Account account;
  static  Contact cont;
  static Contact cont2;
  static Contract contract;
  static echosign_dev1__SIGN_Agreement__c agg;
  static {
        //Test.startTest();
        account = new Account();
        account.Name = 'Test Account1';
        account.RecordTypeID=retrieveRecordTypeID('Account', 'Standard');
        account.BillingCity = 'Denver';
        account.BillingCountry = 'USA';
        account.BillingStreet = '12345 Main St';
        account.BillingPostalCode= '80000';
        account.BillingState= 'CO';
        insert account;
        system.debug('account : '+account);


       cont=new Contact();
    //dummy comment
        cont = new Contact( AccountID = account.Id, FirstName='Test Contact', LastName='Test');
        cont.Email = System.now().getTime()+'te@test.com';
        cont.Phone = '999-888-6677';
        cont.MailingCity = 'San Francisco';
        cont.MailingStreet = '100 Spear St';
        cont.MailingCountry = 'USA';
        cont.MailingState='CA';
        cont.MailingPostalCode ='94105';
        insert cont;
        
        cont2=new Contact();
 
        cont2 = new Contact( AccountID = account.Id, FirstName='Test Contact2', LastName='Test2');
        cont2.Email = System.now().getTime()+'te@test.com';
        cont2.Phone = '999-888-6677';
        cont2.MailingCity = 'San Francisco';
        cont2.MailingStreet = '100 Spear St';
        cont2.MailingCountry = 'USA';
        cont2.MailingState='CA';
        cont2.MailingPostalCode ='94105';
        cont2.Include_in_Lease_Doc__c = true;
        insert cont2;  

         contract=new Contract();
         contract.BillingCity = 'Denver';
        contract.BillingCountry = 'USA';
        contract.BillingStreet = '12345 Main St';
        contract.BillingPostalCode= '80000';
        contract.BillingState= 'CO';
        contract.AccountId=account.Id;
        insert contract;
        
        
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        
        agg = new echosign_dev1__SIGN_Agreement__c();
        agg.echosign_dev1__Account__c = account.Id;
        agg.Account__c = account.Id;
        agg.echosign_dev1__Recipient__c = cont.Id;
        agg.echosign_dev1__Recipient2__c = cont2.Id;
        insert agg;
        //Test.stopTest();
     

  }

  static testMethod void testPdfGenerator() {

    PageReference pdf = Page.ACH_Form_Template;
    pdf.getParameters().put('Id',account.Id); // Pass this Parameter to Render Page
    pdf.getParameters().put('aggId',agg.Id); // Pass this Parameter to Render Page
    Test.setCurrentPage(pdf);

    GenerateAndAttachACHpdfController controller = new GenerateAndAttachACHpdfController();    

    Test.startTest();

    // populate the field with values
    GenerateAndAttachACHpdfController.agreementId=ApexPages.currentPage().getParameters().get('aggId'); //gettting Agreement Id from URL 
    GenerateAndAttachACHpdfController.accountId=ApexPages.currentPage().getParameters().get('Id'); //Getting Account Id from URL
    controller.parentId = account.id;
    controller.pdfName = 'My Test PDF';

    // submit the record
    pdf = controller.attachPDFtoRecord();

    // assert that they were sent to the correct page
    System.assertEquals(pdf.getUrl(),'/'+agg.Id);

    // assert that an attachment exists for the record
    System.assertEquals(1,[select count() from attachment where parentId = :agg.id]);

    Test.stopTest(); 

  }
  
  public static ID retrieveRecordTypeID(String objectName, String recordTypeName) {
                                              
        ID result = null;
        Map<String, Schema.RecordTypeInfo> recordTypeInfo;
        
        if((objectName != null && objectName != '') || 
           (recordTypeName != null && recordTypeName != ''))
        {
            if(sObjectSchema == null)
            {
                sObjectSchema = Schema.getGlobalDescribe();
            }
            
            if(sObjectSchema!= null && sObjectSchema.containsKey(objectName))
            {
                Schema.SObjectType sObjType = sObjectSchema.get(objectName);
                Schema.DescribeSObjectResult description = 
                    sObjType.getDescribe();
                recordTypeInfo = description.getRecordTypeInfosByName();
                
                if(recordTypeInfo != null && 
                   recordTypeInfo.containsKey(recordTypeName))
                {  
                    result = recordTypeInfo.get(
                        recordTypeName).getRecordTypeId();
                }          
            }
        }
        
        return result;
    }

}