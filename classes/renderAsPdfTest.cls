@isTest

public class renderAsPdfTest{
private static Map<String, Schema.sObjectType> sObjectSchema;

static testMethod void renderAsPdfInspection() {
        Test.startTest();
Account account = new Account();
        account.Name = 'Test Account1';
        account.RecordTypeID=retrieveRecordTypeID('Account', 'Standard');
        account.BillingCity = 'Denver';
        account.BillingCountry = 'USA';
        account.BillingStreet = '12345 Main St';
        account.BillingPostalCode= '80000';
        account.BillingState= 'CO';
        insert account;
        system.debug('account : '+account);


       Contact cont=new Contact();
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
        
       Contact cont2=new Contact();
 
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

        Contract contract=new Contract();
         contract.BillingCity = 'Denver';
        contract.BillingCountry = 'USA';
        contract.BillingStreet = '12345 Main St';
        contract.BillingPostalCode= '80000';
        contract.BillingState= 'CO';
        contract.AccountId=account.Id;
        insert contract;
        
        
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        
        echosign_dev1__SIGN_Agreement__c agg = new echosign_dev1__SIGN_Agreement__c();
        agg.echosign_dev1__Account__c = account.Id;
        agg.Account__c = account.Id;
        agg.echosign_dev1__Recipient__c = cont.Id;
        agg.echosign_dev1__Recipient2__c = cont2.Id;
        insert agg;
        Test.stopTest();
        
        
        
        
        

ApexPages.currentPage().getParameters().put('Id',account.id);
ApexPages.currentPage().getParameters().put('aggId',agg.id);

RenderAsPDf renderPdf=new RenderAsPDf(); 

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