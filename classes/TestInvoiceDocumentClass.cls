@IsTest
Public class TestInvoiceDocumentClass 
{
  static testMethod void createInvoiceDocument() 
  {
      
       
     Account accountObj = new Account();
      accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
      accountObj.Type ='Residential Customer';
      accountObj.BillingCity = 'Temecula';
      accountObj.BillingCountry = 'United States';
      accountObj.BillingStreet = 'btm';
      accountObj.BillingPostalCode = '92592';
      accountObj.Theater__c = 'North America';
      accountObj.BillingState='CA';
      //accountObj.Territory__c = 'Spain';
      insert accountObj; 
      
      
      
      
      
      List<RecordType> RecType=[SELECT Id,Name FROM RecordType WHERE Name = 'New-RecordType'];     
      LeasePayment__c lcPay = new LeasePayment__c();
      lcPay.Name='Test Lease';
      lcPay.CurrencyIsoCode='USD';
      lcPay.Account__c=accountObj.Id;
      if(RecType.Size()>0)
      {
      lcPay.RecordType=RecType[0];
      }
      insert lcPay; 
   Invoice_Documents__c InVoiceObj = new Invoice_Documents__c ();  
   InVoiceObj.Name='TestBirlasoft';
   InVoiceObj.Lease_Payment__c=lcPay.Id;
   InVoiceObj.Invoice_Type__c ='Install';
   InVoiceObj.Status__c='Pending';
   InVoiceObj.Documents_in_File__c='Confirmed ICF'; 
   insert InVoiceObj; 
  }

}