/************************************
**Case - 00055208
**By- 
**On- March 03 2011
**Modified - 
**Modified On- 
**Description- Test Class for trigger PopulateAccountfromContact on CSAT object
**************************************/
 @isTest
private class TestPopulateAccountfromContact{
   
  static testMethod void Test_PopulateAccountfromContact(){
  
      // testing account for CSAT populated from the contact field on insert
      CSAT__c csat = new CSAT__c();
      Account acc = new Account(Name='TestAccount_AccountUpdate');
           //added by sreekanth
           acc.Type ='Commercial';
           acc.BillingCity = 'banga';
           acc.BillingCountry = 'France';
           acc.BillingStreet = 'btm';
           acc.BillingPostalCode = '12311';
           acc.Sic = '0111';
           acc.Theater__c = 'Europe';
           acc.Territory__c = 'France';
           insert acc; 
            Contact contactObj = new Contact();
		    contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
		    contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
		    contactObj.AccountId = acc.Id;
  			insert contactObj;
      //Contact 
      //Contact testContact = [select id,accountID from contact limit 1][0];
      csat.Name = 'TestCSAT';
      csat.contact__c = contactObj.id;
      csat.Account__c = contactObj.AccountId;
      csat.Aggregate_Score__c = 10.3;
      
      try{
          insert csat;
      }catch(System.Exception e){
          System.debug('--Exception in deployment - Shikha--'+e.getMessage());
      }
      
       List <CSAT__c> csatList = [select id,account__c from CSAT__c where id =:csat.ID];
       Id expectedCSATAccId = null;
       if(csatList.size()>0)
       		expectedCSATAccId = csatList.get(0).Account__c; 
      system.debug('---expectedCSATAccId -----'+expectedCSATAccId );
      //System.assertEquals(expectedCSATAccId , contactObj.AccountId);
      
      
      // testing account for CSAT populated from the contact field on update
      csat.Aggregate_Score__c = 10.2;
      try{
          update csat;
      }catch(System.Exception e){}
      
      csatList = [select id,account__c from CSAT__c where id =:csat.ID];
      if(csatList.size()>0)
       		expectedCSATAccId = csatList.get(0).Account__c; 
      //System.assertEquals(expectedCSATAccId , contactObj.AccountId);
      
  }
}