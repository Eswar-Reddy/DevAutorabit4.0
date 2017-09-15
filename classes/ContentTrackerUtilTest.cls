@IsTest
public class ContentTrackerUtilTest {

  public static testMethod void checkContentTracker(){
    //setup test data
    //create content
    Content__c contentObj = new Content__c();
    contentObj.Title__c = 'test content';
    contentObj.External_Id__c = 'test123';
    insert contentObj;
    
    ContentTrackerUtilClass.createContentTracker(contentObj.Id, UserInfo.getUserId());    
  }
}