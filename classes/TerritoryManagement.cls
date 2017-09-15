public class TerritoryManagement{

    public static void afterAccountGeographyInsert (List<Account_Geography__c> accountGeographyList)
    {
    }
    
    public static void afterAccountGeographyUpdate (List<Account_Geography__c> accountGeographyList, 
        List<Account_Geography__c> oldAccountGeographyList)
    {
    }
    
    public static void afterAccountGeographyDelete (List<Account_Geography__c> oldAccountGeographyList)
    {
    }
    public static void beforeTerritoryDefinitionInsert (List<Territory_Definition__c> territoryDefinitionList)
    {
      // populateTerritoryDefinitionApprover(territoryDefinitionList);      
    }
    
    public static void beforeTerritoryDefinitionUpdate (List<Territory_Definition__c> territoryDefinitionList, 
        List<Territory_Definition__c> oldTerritoryDefinitonList)
    {
      // populateTerritoryDefinitionApprover(territoryDefinitionList);      
    } 
    
    //PR-01710 sets value of Approver field with User having Role 'Director of Sales'
    //only if the Approver field is null and Territory chosen is assigned to the user.
/*
    private static void populateTerritoryDefinitionApprover(List<Territory_Definition__c> territoryDefinitionList){
      //holds UserRole Id
      Set<Id> setUserRoleIds = new Set<Id>();      
      //holds territory names
      Set<String> setTerritory = new Set<String>();      
      //holds territory Ids
      Set<Id> setTerritoryIds = new Set<Id>();      
      //holds user Ids
      Set<Id> setUserIds = new Set<Id>();
      //holds IDs of user having Role 'Director of Sales'      
      Set<Id> setUserDOSIds = new Set<Id>();
      List<UserRole> lstUserRole = new List<UserRole>();            
      //holds userTerritory objects
      List<UserTerritory> lstUserTerritory = new List<UserTerritory>();            
      //holds territory objects
      List<Territory> lstTerritory = new List<Territory>();      
      //holds user Objects
      List<User> lstUsers = new List<User>();
      //holds Territory name and TerritoryId
      Map<string, Id> mapTerritoryName = new Map<string, Id>();
      //holds territory ID and User ID
      Map<string, Id> mapTerritoryUserId = new Map<string, Id>();
            
      //get User Role
      lstUserRole = [select Id, Name from UserRole where Name = 'Director of Sales'];      
      if(lstuserRole.size() <= 0){
        return;
      }
      for(UserRole userRoleObj : lstUserRole){
        setUserRoleIds.add(userRoleObj.Id);
      }      
      
      //get all territory names in a set
      for(Territory_Definition__c territoryDef : territoryDefinitionList){
        if(territoryDef.Territory__c != null && territoryDef.Approver__c == null){
          setTerritory.add(territoryDef.Territory__c);
        }
      }
      if(setTerritory.size() <= 0){
        return;
      }
      
      //Find territories that matches the Territory picklist values.
      lstTerritory = [select Id, Name from Territory where Name in :setTerritory];
      if(lstTerritory.size() <= 0){
        return;
      }      
      //get all territory Ids in set and map
      for(Territory terr : lstTerritory){
        setTerritoryIds.add(terr.Id);
        mapTerritoryName.put(terr.Name, terr.Id);
      }
      
      //get all user Ids from UserTerritory
      lstUserTerritory = [select Id, UserId, TerritoryId from UserTerritory where TerritoryId in :setTerritoryIds];
      
      //add all UserIds to the set
      for(UserTerritory userTerr : lstUserTerritory){
        setUserIds.add(userTerr.UserId);
        mapTerritoryUserId.put(userTerr.TerritoryId, userTerr.UserId);
      }
      
      //Of all the users assigned to the territory, find a user that has a role
      //of "Director of Sales".
      lstUsers = [select Id, name from User where Id in :setUserIds and UserRoleId in :setUserRoleIds];
      if(lstUsers.size() <= 0){
        return;
      }
      for(User userObj : lstUsers){
        setUserDOSIds.add(userObj.Id);
      }      
      
      //Put the user in the Approver field. 
      //Leave the field blank if no user satisfies the criteria. 
      for(Territory_Definition__c territoryDef : territoryDefinitionList){
        String territoryId = null;
        String UserId = null;
        if(territoryDef.Territory__c != null && territoryDef.Approver__c == null){
          //get Territory Id
          if(mapTerritoryName.containsKey(territoryDef.Territory__c)){
            territoryId = mapTerritoryName.get(territoryDef.Territory__c);
            //get User Id
            if(mapTerritoryUserId.containsKey(territoryId)){
              UserId = mapTerritoryUserId.get(territoryId);
              //assign this User Id to Approver
              territoryDef.Approver__c = UserId;
            }
          }
        }        
      }
    }       
*/    
}