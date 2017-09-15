@isTest
public class TestSetGeoloc {
  static testMethod void Test_SetGeoloc(){
       LocationCallouts.isRunningTest = true;
      Id recordResidentId = [SELECT Id,Name FROM RecordType WHERE Name = 'Residential' and Sobjecttype = 'lead' limit 1].id;
      Lead obj_L = new Lead(City='Santa Clara',recordtypeid=recordResidentId,Status='new', LeadSource='Affilate', LastName = 'Test1',Email='a@gmail.com',Company='ABC',Lead_Manufacturer__c='SunPower',Country='United states',PostalCode='95051',State='CA',Street='Adriatic Way');
      Insert obj_L;
  }
}