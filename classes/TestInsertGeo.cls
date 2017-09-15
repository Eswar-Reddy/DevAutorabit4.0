@isTest
private class TestInsertGeo  {
  static testMethod void Test_InsertGeo(){
       String recType1 = [SELECT id FROM recordtype WHERE name='Partner' and Sobjecttype = 'Account' limit 1].id;
      Account objP1 = new Account(Name = 'test22',recordtypeId=recType1, lat__c=37.349462,log__c=-121.9985126,Geo__Latitude__s=null,BillingStreet='Adriatic Way', BillingCity='Santa Clara', BillingState='CA', BillingPostalCode='95051', BillingCountry='United States',Theater__c ='North America',Phone='1234567895',Type='Elite-Partner-Combo');
      Insert objP1;
  }
}