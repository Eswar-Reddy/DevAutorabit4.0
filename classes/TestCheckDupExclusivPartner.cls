@isTest(SeeAllData=true)
private class TestCheckDupExclusivPartner {

    static testMethod void Test_CheckDupExclusivPartner (){
  
    map<String,Exclusive_Zip_codes__c> mapZipcodeExclusive = new map<String,Exclusive_Zip_codes__c>();
    List <Exclusive_Zip_codes__c> ExZipRslt = new List <Exclusive_Zip_codes__c>();
    String recType1 = [SELECT id FROM recordtype WHERE name='Partner' and Sobjecttype = 'Account' limit 1].id;
    
    Account objP1 = new Account(Name = 'test22',recordtypeId=recType1, BillingStreet='Adriatic Way', BillingCity='Santa Clara', BillingState='CA', BillingPostalCode='95051', BillingCountry='United States',Theater__c ='North America',Phone='1234567895',Type='Elite-Partner-Combo');
    
    Insert objP1;
    
     date myDate = System.Today();  
     
     List<Exclusive_Zip_codes__c> InsertList = new List<Exclusive_Zip_codes__c>();
  try{  
    for(Integer i=0;i<5; i++){
         Exclusive_Zip_codes__c objZipCode = new Exclusive_Zip_codes__c();
         objZipCode.Partner__c =objP1.Id;
         objZipCode.Country__c = 'United States';
         objZipCode.Zip_code__c = '95051';
         if(i == 0 || i == 1){
             objZipCode.Start_Date__c = null;
             objZipCode.End_Date__c = null;
         }
         else if (i == 2){
            date newDate = mydate.addDays(2);
            objZipCode.Start_Date__c = null;
            objZipCode.End_Date__c = newDate;
         }
         else if (i == 3){
            date newDate = mydate.addDays(1);
            objZipCode.Start_Date__c = newDate;
            objZipCode.End_Date__c = mydate;
         }   
         else if (i == 4){
            date newDate = mydate.addDays(1);
            objZipCode.Start_Date__c = newDate;
            objZipCode.End_Date__c = null;
         }       
         InsertList.add(objZipCode);
     }
 
    if(InsertList.size() > 0){
        insert InsertList;
    }
  }catch(Exception ex){
  }
   
  }    
 
}