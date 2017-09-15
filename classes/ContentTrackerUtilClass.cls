public class ContentTrackerUtilClass {
  
  public static void createContentTracker(String contentId, String userId){
    Content_Tracker__c trackerObj = new Content_Tracker__c();
    trackerObj.Content__c = contentId;
    trackerObj.User__c = userId;
    upsert trackerObj;
  }
}