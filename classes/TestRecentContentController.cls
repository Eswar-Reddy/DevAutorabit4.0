/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 12 2009
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller RecentContentController
****************************************************
*****************************************************/


public class TestRecentContentController{
    @isTest
  public static void checkRecentContentController(){    
    Content__c contentObj = new Content__c();
    contentObj.Title__c = 'test content';
    contentObj.External_Id__c = 'test1';
    insert contentObj;
    
    String strAnnouncemnt = 'Announcement';
    String strClips = 'Clips';
    String strTraining = 'Training Schedule';
    String strEvent = 'Event - Webinar';
    
    Set<string> setRecordTypes = new Set<string>();
    setRecordTypes.add(strAnnouncemnt);
    setRecordTypes.add(strClips);
    setRecordTypes.add(strTraining);
    setRecordTypes.add(strEvent);
    
    List<RecordType> lstRecordType = new List<RecordType>();
    lstRecordType = [select Id, Name from RecordType where Name in :setRecordTypes];
    Map<string, RecordType> mapRecordType = new Map<string, RecordType>();
    for(RecordType recObj : lstRecordType){
      if(!mapRecordType.containsKey(recObj.Name)){
        mapRecordType.put(recObj.Name, recObj);
      }        
    }
    
    Content__c cont1 = new Content__c();
    cont1.Title__c = 'cont1';
    if(mapRecordType.containsKey(strAnnouncemnt)){
      cont1.RecordTypeId = mapRecordType.get(strAnnouncemnt).Id;
    }
    insert cont1;
    
    Content__c cont2 = new Content__c();
    cont2.Title__c = 'cont2';
    if(mapRecordType.containsKey(strClips)){
      cont2.RecordTypeId = mapRecordType.get(strClips).Id;
    }
    insert cont2;
    
    Content__c cont3 = new Content__c();
    cont3.Title__c = 'cont3';
    if(mapRecordType.containsKey(strTraining)){
      cont3.RecordTypeId = mapRecordType.get(strTraining).Id;
    }
    insert cont3;
    
    Content__c cont4 = new Content__c();
    cont4.Title__c = 'cont4';
    if(mapRecordType.containsKey(strEvent)){
      cont4.RecordTypeId = mapRecordType.get(strEvent).Id;
    }
    insert cont4;
    
    ApexPages.StandardController controller = new ApexPages.StandardController(contentObj);
    RecentContentController obj = new RecentContentController(controller);
    RecentContentController.Content c = new RecentContentController.Content();
    String  monthname = c.getMonthName(1);
    String selectedTab = obj.getSelectedTabForRedirection();
    String tab = obj.getSelectedTab();
    obj.setSelectedTab(tab);
    obj.getListEvent();
    obj.getListAnnouncements();
    obj.getListTaining();
    obj.getIsSunPowerSuperUser();
    obj.populateEvents();
    obj.populateTraining();
    obj.populateAnnouncement();
    obj.getlistClips();
    obj.idToDelete = contentObj.Id;
    obj.remove();    
    
    RecentContentController.Content conObj = new RecentContentController.Content();
    for(Integer iter = 1; iter < 13; iter++){
      conObj.getMonthName(iter);
    }
    conObj.getShortDate(Date.today());
  }
  
  @isTest
  public static void checkRecentContentController2(){    
    Content__c contentObj = new Content__c();
    contentObj.Title__c = 'test content';
    contentObj.External_Id__c = 'test1';
    insert contentObj;
    
    String strAnnouncemnt = 'Announcement';
    String strClips = 'Clips';
    String strTraining = 'Training Schedule';
    String strEvent = 'Event - Webinar';
    
    Set<string> setRecordTypes = new Set<string>();
    setRecordTypes.add(strAnnouncemnt);
    setRecordTypes.add(strClips);
    setRecordTypes.add(strTraining);
    setRecordTypes.add(strEvent);
    
    Test.starttest();
    
    User u1 = new User(LastName = 'AUserTEST', Country_Domain__c = 'combo-us', languagelocalekey='fr');
    
    List<RecordType> lstRecordType = new List<RecordType>();
    lstRecordType = [select Id, Name from RecordType where Name in :setRecordTypes];
    Map<string, RecordType> mapRecordType = new Map<string, RecordType>();
    
    for(RecordType recObj : lstRecordType){
      if(!mapRecordType.containsKey(recObj.Name)){
        mapRecordType.put(recObj.Name, recObj);
      }        
    }
    
    Content__c cont1 = new Content__c();
    cont1.Title__c = 'cont1';
    cont1.Country_Domain__c = 'rvar-us';
    if(mapRecordType.containsKey(strAnnouncemnt)){
      cont1.RecordTypeId = mapRecordType.get(strAnnouncemnt).Id;
    }
    insert cont1;
    
    Content__c cont2 = new Content__c();
    cont2.Title__c = 'cont2';
    cont2.Country_Domain__c = 'rvar-us';
    if(mapRecordType.containsKey(strClips)){
      cont2.RecordTypeId = mapRecordType.get(strClips).Id;
    }
    insert cont2;
    
    Content__c cont3 = new Content__c();
    cont3.Title__c = 'cont3';
    cont3.Country_Domain__c = 'rvar-us';
    if(mapRecordType.containsKey(strTraining)){
      cont3.RecordTypeId = mapRecordType.get(strTraining).Id;
    }
    insert cont3;
    
    Content__c cont4 = new Content__c();
    cont4.Title__c = 'cont4';   
    cont4.Country_Domain__c = 'rvar-us'; 
    if(mapRecordType.containsKey(strEvent)){
      cont4.RecordTypeId = mapRecordType.get(strEvent).Id;
    }
    insert cont4;   
    
    for (integer cInt = 0; cInt < 4; cInt++) {
        ApexPages.StandardController controller;
    
        if (cInt == 0) {        
            controller = new ApexPages.StandardController(cont1);
            u1.languagelocalekey = 'it';
        } else if (cInt == 1) {
            controller = new ApexPages.StandardController(cont2);
            u1.languagelocalekey = 'es';
        } else if (cInt == 2) {
            controller = new ApexPages.StandardController(cont3);
            u1.languagelocalekey = 'de';
        } else if (cInt == 3){
            controller = new ApexPages.StandardController(cont4);
        } else {
            System.runAs(u1) {
                controller = new ApexPages.StandardController(cont4);
            }
            break;
        }        
        
        RecentContentController obj = new RecentContentController(controller);
        RecentContentController.Content c = new RecentContentController.Content();
        
        String  monthname = c.getMonthName(1);
        String selectedTab = obj.getSelectedTabForRedirection();        
        
        String tab = obj.getSelectedTab();
        
        obj.setSelectedTab(tab);
        obj.getListEvent();
        obj.getListAnnouncements();
        obj.getListTaining();
        
        obj.getIsSunPowerSuperUser();
               
        obj.populateEvents();
        obj.populateTraining();
        obj.populateAnnouncement();
        obj.getlistClips();
        obj.idToDelete = contentObj.Id;
        obj.remove();    
        
        RecentContentController.Content conObj = new RecentContentController.Content();
        
        for(Integer iter = 1; iter < 13; iter++){
          conObj.getMonthName(iter);
        }
        
        conObj.getShortDate(Date.today());
      }
      
      Test.stopTest();
    }  
}