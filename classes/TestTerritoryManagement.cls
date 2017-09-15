/**************************************************
** PR- 01923
**Created By- Harsh Mathur 
**Created On- May 13 2009 
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller TerritoryManagement
*****************************************************/

public class TestTerritoryManagement {

@isTest
	public static void testGetTheater(){
  
		List<Country_Reference__c> lstCountryReference = 
			[select Country__c, Theater__c 
				from Country_Reference__c
					Limit 1];  
        		
      	if(lstCountryReference.size() > 0){
      		String country = lstCountryReference[0].Country__c;			
			//TerritoryManagement.getTheater(country);
      	}    	
	}
  
  @isTest
  public static  void checkTerritoryManagement(){
    /*
    //setup test data
    
    //insert role 'Director of Sales'
    UserRole userRoleObj = new UserRole();
    userRoleObj.Name = 'Director of Sales';
    insert userRoleObj;
    
    Profile prof = [select Id, Name 
    	from profile 
    	where Name = 'System Administrator' Limit 1];
    
    //insert user with Role as 'Director of Sales'
    User userObj = new User();
    userObj.FirstName = 'test';
    userObj.LastName = 'testing';
    userObj.UserRoleId = userRoleObj.Id;
    userObj.Alias = 'fortest';
    userObj.Email = 'test@testing.com';
    userObj.Username = 'test@testing.com';
    userObj.communitynickname = 'test';
    userObj.ProfileId = prof.Id;
    userObj.TimeZoneSidKey = 'America/Los_Angeles';
    userObj.LocaleSidKey = 'en_US';
    userObj.EmailEncodingKey = 'ISO-8859-1';
    userObj.LanguageLocaleKey = 'en_US';    
    insert userObj;
    
    //insert territory object
    Territory territoryObj = new Territory();
    territoryObj.Name = 'North America';
    insert territoryObj;
    
    //insert UserTerritory object
    UserTerritory userTerritoryObj = new UserTerritory();
    userTerritoryObj.userId = userObj.Id;
    userTerritoryObj.TerritoryId = territoryObj.Id;
    //insert userTerritoryObj;
    */
    
    //start test    
    //insert Territory Definition object with territory as 'North America'
    Territory_Definition__c territoryDefinitionObj = new Territory_Definition__c();
    //territoryDefinitionObj.Name = '10';
    territoryDefinitionObj.Territory__c = 'North America';
    insert territoryDefinitionObj;    
   
  }
}