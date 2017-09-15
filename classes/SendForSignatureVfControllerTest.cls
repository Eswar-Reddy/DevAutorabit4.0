/* This is Test Class For Adobe Send For Signature Method */
@isTest

public class SendForSignatureVfControllerTest{


private static Map<String, Schema.sObjectType> sObjectSchema;

static testMethod void sendForSignatureTest() {
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
        
        Contact cont3=new Contact();
        cont3= new Contact( AccountID = account.Id, FirstName='Test Contact3', LastName='Test3');
        cont3.Email = System.now().getTime()+'te@test.com';
        cont3.Phone = '999-888-6677';
        cont3.MailingCity = 'San Francisco';
        cont3.MailingStreet = '100 Spear St';
        cont3.MailingCountry = 'USA';
        cont3.MailingState='CA';
        cont3.MailingPostalCode ='94105';
        insert cont3;
        

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
        agg.echosign_dev1__Recipient3__c=cont3.Id;
        agg.echosign_dev1__More_Recipients__c=System.now().getTime()+'te@test.com'; 
        insert agg;
        
        echosign_dev1__SIGN_Agreement__c agg1 = new echosign_dev1__SIGN_Agreement__c();
        agg1.echosign_dev1__Account__c = account.Id;
        agg1.Account__c = account.Id;
        agg1.echosign_dev1__Recipient__c = cont.Id;
        agg1.echosign_dev1__Recipient2__c = cont2.Id;
        agg1.echosign_dev1__Recipient3__c=cont3.Id;
        agg1.echosign_dev1__More_Recipients__c=System.now().getTime()+'1te@test.com'; 
        //agg1.change_order_type__c='Cancellation'; 
        insert agg1;
            
        Test.stopTest();
        
        
        
        
        

//ApexPages.currentPage().getParameters().put('Id',account.id);
ApexPages.currentPage().getParameters().put('id',agg.id);
ApexPages.StandardController standardController = new ApexPages.StandardController(agg);
SendForSignatureVfController sendForSignatire=new SendForSignatureVfController(standardController); 
sendForSignatire.aggId=String.valueOf(agg.Id);
sendForSignatire.level='ERROR'; 

ApexPages.currentPage().getParameters().put('id',agg1.id);
ApexPages.StandardController standardController1 = new ApexPages.StandardController(agg1);
SendForSignatureVfController sendForSignatire1=new SendForSignatureVfController(standardController1); 
sendForSignatire.message ='Test Errror';
PageReference checkreference= sendForSignatire.showPageMessage();
echosign_dev1__SIGN_Agreement__c aggReturn=[SELECT echosign_dev1__Recipient__r.Email,echosign_dev1__Recipient2__r.Email,echosign_dev1__Recipient3__r.Email,echosign_dev1__More_Recipients__c FROM echosign_dev1__SIGN_Agreement__c WHERE Id =: agg.Id LIMIT 1];
System.assertEquals(String.valueOf(aggReturn.echosign_dev1__More_Recipients__c),String.valueOf(agg.echosign_dev1__More_Recipients__c),'Working');
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