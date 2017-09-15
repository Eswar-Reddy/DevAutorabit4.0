/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 12 2009
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class 
*****************************************************/

public class TestBeforeTerritoryDefinitionUpdate
{
	@isTest
  public static void checkBeforeTerritoryDefinitionUpdate()
  {
    List<Territory_Definition__c> lstTest = new List<Territory_Definition__c>();
    Territory_Definition__c terrObj = new Territory_Definition__c();
    terrObj.Territory__c = 'North America';
    lstTest.add(terrObj);
    insert lstTest;    
    
    update lstTest;

  }
}