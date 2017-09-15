/**************************************************
**Created By- Jitendra
**Created On- 25 Mar 2011
**Desciption- Test class for SiteManagement class 
*****************************************************/
public class TestSiteManagement {
	@isTest
  public static void test_SiteManagement (){
  	Map<String, Schema.RecordTypeInfo> nameToOppRecordTypeInfoMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
  	Id devRecordTypeId = nameToOppRecordTypeInfoMap.get('Development').getRecordTypeId();
  	Site_Information_Form__c site = new Site_Information_Form__c();
  	
  	Opportunity oppObj = new Opportunity();
    oppObj.RecordTypeId = devRecordTypeId;
    oppObj.Name = 'testOpp';
    oppObj.StageName = '01 – Assess Opportunity';
    oppObj.CloseDate = Date.today();    
    insert oppObj;
    site.Opportunity_del__c = oppObj.Id;
    site.Land_size_ha__c = 100;
    site.Of_Useable_Land__c = 10;
    insert site;
  }
}