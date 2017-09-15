public class RecentContentController{
  //properties  
  public List<RecordType> listRecordType{get;set;} 
  public String strAnnouncemnt = 'Announcement';
  public String strClips = 'Clips';
  public String strTraining = 'Training Schedule';
  public String strEvent = 'Event - Webinar';
  public String idToDelete{get;set;}
  private String selectedTabForRedirection;
  public String UserCountryDomain{get;set;}
  public String UserPartnerType{get;set;}
  public String UserProfile{get;set;}
  public String strPrefixContent {get;set;}
  
  /* Added for Sunpower Case # 00028955 */
  private final String QUERY_STRING;
  /**************************************/
  
    //Properties to store the recordtype ID of each tab
    public String strAnnouncemntRecordTypeID {get;set;}
    public String strClipsRecordTypeID  {get;set;}
    public String strTrainingRecordTypeID  {get;set;}
    public String strEventRecordTypeID  {get;set;}  
    
   // by default only show 3 most recent content items
   // unless the url param 'showAllContent' is set 
   private String showAllContent = ApexPages.currentPage().getParameters().get('showAllContent');
   private Integer contentLimit = 3;
  
  public String getSelectedTabForRedirection(){ 
    String tab='';
    List<Content__c> contentList = new List<Content__c>([Select RecordType.Name from Content__c where Id =:content.Id]);
    if(contentList.Size()>0){
      String recordType = contentList.get(0).RecordType.Name;
      if(recordType == strAnnouncemnt){
        tab =  'Announcements';
      }
      else if(recordType == strClips){
        tab =  'Clips';
      }
      else if(recordType == strTraining){
        tab =  'TrainingSchedule';          
      }
      else if(recordType == strEvent){
        tab =  'UpcomingEvents';
      }
    }
    return tab;        
  }
  
  public Content__c content{get;set;}
  private String selectedTab;
  public String getSelectedTab(){
    selectedTab = ''; 
    if(Apexpages.currentPage().getParameters().get('retTab') != null){
      selectedTab = Apexpages.currentPage().getParameters().get('retTab');    
    }
    return selectedTab;
  }
  
  public void setSelectedTab(String selectedTab){
    this.selectedTab = selectedTab;
  }
    
  private List<Content> listEvent; //for record type event
  public List<Content> getListEvent(){
    if(listEvent == null){
      populateEvents();
    }
    return listEvent;
  }
  
  private List<Content> listAnnouncements; //for record type announcements
  public List<Content> getListAnnouncements(){
    if(listAnnouncements == null){
      populateAnnouncement();
    }
    return listAnnouncements;   
  }
  
  private List<Content> listClips; //for record type Clips
  public List<Content> getlistClips(){
    if(listClips == null){
      populateClips();
    }
    return listClips;   
  }
  
  private List<Content> listTaining; //for record type training
  public List<Content> getListTaining(){
    if(listTaining == null){
      populateTraining();
    }
    return listTaining;
  }
   
  private Boolean isSunPowerSuperUser;
  public Boolean getIsSunPowerSuperUser(){
    List<Profile> profileList =  new List<Profile>([Select Name from Profile where Id =:Userinfo.getProfileId()]);
    if(profileList.Size()>0){
      String prName = profileList.get(0).Name;
      
      /* Change for Sunpower Case # 00029036 */
      /*
      if(prName == 'SunPower Super User'){
        return true; //to show/hide edit/add and delete button sunpower super user
      }
      if(prName == 'SunPower Partner Ambassador'){
        return true; //to show/hide edit/add and delete button SunPower Partner Ambassador
      }
      else if(prName == 'System Administrator'){
        return true; //to show/hide edit/add and delete button for administrator
      }
      */
      
      // To show add, edit and delete links
      // Done for Case # 00074252 [adding profile 'Marketing Connect5' for announcement functionality]
      if (prName == 'SunPower Super User' || prName == 'SunPower Partner Ambassador'
          // || prName == 'SunPower LMS Administrator' || prName == 'System Administrator') {
          || prName == 'SunPower LMS Administrator' || prName == 'System Administrator' || prName == 'Marketing Connect5') {	
        return true;
      }
      /**************************************/
    }
    
    return false;
  }
  
  public String setUserProfile(){
      UserProfile = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name; 
    return UserProfile ;
  }  
  
  // Flag to enable/disable the sunpower clips 
  //  Currently sunpower Clips is only enabled for rvar-us,cvar-us,combo-us or to the profiles 'Partner Restricted','EU 'Partner Restricted'
    public Boolean isClipsVisible{ 
       get{ 
            if (isClipsVisible ==  null) {
                isClipsVisible = false;
               if (UserCountryDomain.endsWith('rvar-us') || 
                   UserCountryDomain.endsWith('cvar-us') || UserCountryDomain.endsWith('combo-us')) {
                   isClipsVisible = true;
                }
                //Following is done for the case 00013292
                if(UserProfile!=null){
                	if(UserProfile.indexOf('Partner Restricted')>=0){
                		isClipsVisible = true;
                	}
                }
             }                            
             return isClipsVisible; 
       }    
       set; 
    }

    //Get the recordTypeID for each recordType and Prefix of Content
    private void AssignRecordTypes(){
        //Get Prefix of Content
        strPrefixContent = Content__c.SObjectType.getDescribe().getKeyPrefix();
        //Get the list of Record types
        List<RecordType> records = new List<RecordType>();
        records = [Select id,name from RecordType where name= :strAnnouncemnt or name= :strClips or name= :strTraining or name= :strEvent];
        //Store recordTypeID for each recordType
        for(RecordType rec:records){
            if(rec.name == strAnnouncemnt){
                strAnnouncemntRecordTypeID = rec.id;
            }
            else if(rec.name == strClips){
                strClipsRecordTypeID = rec.id;
            }
            else if(rec.name == strTraining){
                strTrainingRecordTypeID = rec.id;
            }
            else if(rec.name == strEvent){
                strEventRecordTypeID = rec.id;
            }
        }
    }
      
  
  //constructor
  public RecentContentController(ApexPages.StandardController controller) {
    
    content = (Content__c) controller.getRecord();
    setCountryDomain();
    
    /* Added for Sunpower Case # 00028955 */
    String queryStr = 'Select Id, Content_Location__c, Title__c, Target_Audience__c, Location__c,'
            + ' Event_Date__c, Is_Content_New__c, Country_Domain__c, URL_Link_Text__c, Publish_Date__c,'
            + ' Event_Start_Date__c, Event_End_Date__c, Description__c, Partner_Type__c From Content__c'
            + ' Where Country_Domain__c includes (\'';
    
    if (UserCountryDomain.startsWith('combo-')) {
        String countryCode = UserCountryDomain.substring(6);
        queryStr += 'rvar-' + countryCode + '\', \'cvar-' + countryCode;
    } else {
        queryStr += UserCountryDomain;
    }
    
    QUERY_STRING = queryStr + '\') and RecordType.Name';
    System.debug('Debug: QUERY_STRING ' + QUERY_STRING);
    /**************************************/
    
    //userLocale = UserInfo.getLocale();
    setUserProfile();
    isSunPowerSuperUser = getIsSunPowerSuperUser();
    //Get Prefix of Content
    strPrefixContent = Content__c.SObjectType.getDescribe().getKeyPrefix();
    AssignRecordTypes();       
   
    if(showAllContent != null) {
        contentLimit = 50;
    }      
  }    
   
  //method to load all events
  public void populateEvents(){        
    listEvent = new List<Content>(); 
    Content cObj;
   List<Content__c>  listEventTemp = null;

   /* Change for Sunpower Case # 00028955 */
   /*
   if (isSunPowerSuperUser) {
      listEventTemp = new List<Content__c>([
        Select Id, Content_Location__c, Title__c, Target_Audience__c, Event_Date__c,
            Is_Content_New__c,Country_Domain__c,Partner_Type__c 
          From Content__c  where 
              RecordType.Name =:strEvent and
              Country_Domain__c includes (:UserCountryDomain)
            order By Event_Date__c Limit :contentLimit ]);     
   } else {
      listEventTemp = new List<Content__c>([
        Select Id, Content_Location__c, Title__c, Target_Audience__c, Event_Date__c,
            Is_Content_New__c,Country_Domain__c,Partner_Type__c 
          From Content__c  where 
              RecordType.Name =:strEvent and 
              View_Profiles__c includes (:UserProfile) and
              Country_Domain__c includes (:UserCountryDomain) and
              Partner_Type__c includes (:UserPartnerType)
            order By Event_Date__c Limit :contentLimit ]);   
   }
   */
   
   listEventTemp = database.query(addForSunPowerSuperUser(QUERY_STRING + ' =:strEvent')
           + ' order By Event_Date__c Limit :contentLimit');
   /**************************************/
   
   if(listEventTemp.Size()>0){
      for(Content__c c:listEventTemp){
      
        cObj = new Content();
        cObj.Id = c.Id;
        cObj.detailPageLink = '/apex/ContentDetailPage?cId=' + cObj.Id;
        cObj.title = c.Title__c; 
        cObj.targetAudience = c.Target_Audience__c;  
        cObj.targetAudience = '';
        cObj.eventSatrtDate = cObj.getShortDate(c.Event_Date__c);
        cObj.IsContentNew = c.Is_Content_New__c;
        cObj.location = c.Content_Location__c;
        listEvent.add(cObj);    
      }            
    }
  }
  
  //method to load all training
  public void populateTraining(){
    Content cObj;
    listTaining = new List<Content>(); 
    List<Content__c> listTainingTemp = null;

   /* Change for Sunpower Case # 00028955 */
   /*
   if (isSunPowerSuperUser) {    
    listTainingTemp = new List<Content__c>([
        Select Id, Location__c, Event_Start_Date__c, Event_End_Date__c, 
            Description__c,Is_Content_New__c,Country_Domain__c,
            Partner_Type__c From Content__c 
            where 
              RecordType.Name =:strTraining and
              Country_Domain__c includes (:UserCountryDomain)
            order By Event_Start_Date__c,Location__c Limit :contentLimit ]);     
   } else {
    listTainingTemp = new List<Content__c>([
        Select Id, Location__c, Event_Start_Date__c, Event_End_Date__c, 
            Description__c,Is_Content_New__c,Country_Domain__c,
            Partner_Type__c From Content__c 
            where 
              RecordType.Name =:strTraining and 
              View_Profiles__c includes (:UserProfile) and
              Country_Domain__c includes (:UserCountryDomain) and
              Partner_Type__c includes (:UserPartnerType)
            order By Event_Start_Date__c,Location__c Limit :contentLimit ]);    
        System.debug('>>>>>>>>>>>>>populateTraining SOQL' + ' Select Id, Location__c, Event_Start_Date__c, Event_End_Date__c,   Description__c,Is_Content_New__c,Country_Domain__c, Partner_Type__c From Content__c      where   RecordType.Name =: '+ strTraining+'  and View_Profiles__c includes (:'+ UserProfile+ ') and  Country_Domain__c includes (:'+UserCountryDomain+ ') and  Partner_Type__c includes (:'+UserPartnerType+ ')  order By Event_Start_Date__c ASC Limit 3');      
   }
   */
   
   listTainingTemp = database.query(addForSunPowerSuperUser(QUERY_STRING + ' =:strTraining')
           + ' order By Event_Start_Date__c, Location__c Limit :contentLimit');
   /**************************************/
   
    if(listTainingTemp.Size()>0){
      for(Content__c c:listTainingTemp){

        cObj = new Content();
        cObj.Id = c.Id;
        cObj.detailPageLink = '/apex/ContentDetailPage?cId=' + cObj.Id;
        cObj.location = c.Location__c;
        cObj.eventSatrtDate = cObj.getShortDate(c.Event_Start_Date__c);
        cObj.eventEndDate = cObj.getShortDate(c.Event_End_Date__c);
        cObj.description = c.Description__c;
        cObj.IsContentNew = c.Is_Content_New__c;
        listTaining.add(cObj);  
      }            
    } 
           
  }
  
  //method to load all announcements
  public void populateAnnouncement(){
    Content cObj;
    listAnnouncements = new List<Content>(); 
    List<Content__c> listAnnouncementsTemp = null;
    
    /* Change for Sunpower Case # 00028955 */
    /*
    if (isSunPowerSuperUser) {   
        listAnnouncementsTemp = new List<Content__c>([
            Select Id,Partner_Type__c, URL_Link_Text__c, Title__c, Event_Start_Date__c, 
            Description__c, Content_Location__c,Publish_Date__c, Is_Content_New__c,
            Country_Domain__c From Content__c 
                where 
                  RecordType.Name =:strAnnouncemnt and 
                  Country_Domain__c includes (:UserCountryDomain)
                order By Publish_Date__c DESC Limit :contentLimit ]);     
    } else {        
        listAnnouncementsTemp = new List<Content__c>([
        Select Id,Partner_Type__c, URL_Link_Text__c, Title__c, Event_Start_Date__c, 
        Description__c, Content_Location__c,Publish_Date__c, Is_Content_New__c,
        Country_Domain__c From Content__c 
            where 
              RecordType.Name =:strAnnouncemnt and 
              View_Profiles__c includes (:UserProfile) and
              Country_Domain__c includes (:UserCountryDomain) and
              Partner_Type__c includes (:UserPartnerType)
            order By Publish_Date__c DESC Limit :contentLimit ]);    
    }
    */
    
    listAnnouncementsTemp = database.query(addForSunPowerSuperUser(QUERY_STRING + ' =:strAnnouncemnt')
            + ' order By Publish_Date__c DESC Limit :contentLimit');
    /**************************************/
    
    if(listAnnouncementsTemp.Size()>0){
      for(Content__c c:listAnnouncementsTemp){
              
        cObj = new Content(); 
        cObj.Id = c.Id; 
        cObj.detailPageLink = '/apex/ContentDetailPage?cId=' + cObj.Id;
        cObj.title = c.Title__c;
        cObj.description = c.Description__c; 
        cObj.eventSatrtDate = cObj.getShortDate(c.Publish_Date__c);
        cObj.urlLink = c.URL_Link_Text__c;
        cObj.urlLinkActual = '/apex/ContentDetailPage?cId=' + cObj.Id + '&retUrl='+ c.URL_Link_Text__c;
        cObj.IsContentNew = c.Is_Content_New__c;
        if(cObj.eventSatrtDate != '' && c.Content_Location__c != null)
          cObj.location= ' in '+ c.Content_Location__c;
        else
          cObj.location= c.Content_Location__c;

        cObj.location= c.Content_Location__c;    
        if (c.Content_Location__c == null) {
            cObj.urlLink = null;
        }          
          
        listAnnouncements.add(cObj);    
      }
    }
    
  }
  
  //method to load all Clips
  public void populateClips(){
    Content cObj;
    listClips = new List<Content>(); 
    List<Content__c> listClipsTemp = null;   
    
    /* Change for Sunpower Case # 00028955 */
    /*
    if (isSunPowerSuperUser) {     
        listClipsTemp = new List<Content__c>([
            Select Id, URL_Link_Text__c, Title__c, Country_Domain__c, Event_Start_Date__c, 
            Description__c, Content_Location__c,Publish_Date__c, Is_Content_New__c, Partner_Type__c 
          From Content__c
            where 
              RecordType.Name =:strClips and 
              Country_Domain__c includes (:UserCountryDomain)
            order by Publish_Date__c DESC Limit :contentLimit ]);   
    } else {
        listClipsTemp = new List<Content__c>([
            Select Id, URL_Link_Text__c, Title__c, Country_Domain__c, Event_Start_Date__c, 
            Description__c, Content_Location__c,Publish_Date__c, Is_Content_New__c, Partner_Type__c 
          From Content__c
            where 
              RecordType.Name =:strClips and 
              View_Profiles__c includes (:UserProfile) and
              Country_Domain__c includes (:UserCountryDomain) and
              Partner_Type__c includes (:UserPartnerType)
            order by Publish_Date__c DESC Limit :contentLimit ]);     
    }
    */
    
    listClipsTemp = database.query(addForSunPowerSuperUser(QUERY_STRING + ' =:strClips')
            + ' order By Publish_Date__c DESC Limit :contentLimit');
    /**************************************/

    if(listClipsTemp.Size()>0){
      for(Content__c c:listClipsTemp){

        cObj = new Content(); 
        cObj.Id = c.Id; 
        cObj.detailPageLink = '/apex/ContentDetailPage?cId=' + cObj.Id;
        cObj.title = c.Title__c;
        cObj.description = c.Description__c; 
        cObj.eventSatrtDate = cObj.getShortDate(c.Publish_Date__c);
        cObj.urlLink = c.URL_Link_Text__c;
        cObj.urlLinkActual = '/apex/ContentDetailPage?cId=' + cObj.Id + '&retUrl='+ c.URL_Link_Text__c;
        cObj.IsContentNew = c.Is_Content_New__c;
        if(cObj.eventSatrtDate != '' && c.Content_Location__c != null)
          cObj.location= ' in '+ c.Content_Location__c;
        else
          cObj.location= c.Content_Location__c;

        cObj.location= c.Content_Location__c;    
        if (c.Content_Location__c == null) {
            cObj.urlLink = null;
        }
        
        listClips.add(cObj);    
      }
    }  
  }
  
  /* Added for Sunpower Case # 00028955 */
  private String addForSunPowerSuperUser(String queryStr) {
      if (isSunPowerSuperUser == false) {
         queryStr += ' and View_Profiles__c includes (:UserProfile)'
               + ' and Partner_Type__c includes (:UserPartnerType)';
      }
      
      return queryStr;
  }
  /**************************************/
  
  public boolean isEU_Version(){
     String url = Apexpages.currentPage().getUrl();
     
System.debug('>>>>>>>>>>>>>url' + url);     
     if(url.endsWith('_EU'))
        return true;
     else
        return false;
           
  }
  
  public void setCountryDomain(){
    // default value is rvar-us if country_domain is null.
    UserCountryDomain = 'rvar-us';
    List<User> lstUser = new List<User>([Select Id,Country_Domain__c,contactID, contact.Account.Type from User where Id =: userInfo.getUserId()]);
    if(lstUser.Size()>0 && lstUser.get(0).Country_Domain__c != null ){ 
        UserCountryDomain = lstUser.get(0).Country_Domain__c;
        if(lstUser.get(0).contactID != null)
            UserPartnerType = lstUser.get(0).contact.Account.Type;
    }   
  }
  
  // Done for Case # 00066101
  public boolean isFrench {
    get {
        String userLocale= UserInfo.getLocale();
        boolean isLocaleFrench = false;        
        if(userLocale =='fr' || userLocale=='FR'){
            isLocaleFrench =true;
        }
        return isLocaleFrench ;
     }
     set;
  }
     
  //class to show a Content object on all tabs in different types
  public class Content{
    public String Id{get;set;}
    public String detailPageLink{get;set;}
    public String IsContentNew{get;set;}
        
    //for event
    public String title{get;set;}
    public String targetAudience{get;set;}
    public String eventSatrtDate{get;set;}        
        
    //for training
    public String location{get;set;}
    public String eventEndDate{get;set;}
    public String description{get;set;}
        
    //for announcements
    public String urlLink{get;set;}
    public String urlLinkActual{get;set;}
    
    private String userLocale {get;set;}
 
    public Content(){
        userLocale = UserInfo.getLocale();
    }

            
    //date time related method 
    public String getShortDate(Date dt) {
      String stringDate = ''; 
      if(dt != null){
       if(userLocale == 'it' || userLocale == 'IT')
            stringDate = dt.Day() +' '+ getMonthName(dt.Month()) + ', ' + dt.Year(); 
       else if(userLocale == 'es' || userLocale == 'ES')
            stringDate = dt.Day() +' '+ getMonthName(dt.Month()) + ', ' + dt.Year(); 
       else if(userLocale == 'de' || userLocale == 'DE')
            stringDate = dt.Day() +'.'+ dt.Month() + '.' + dt.Year(); 
       else
           stringDate = getMonthName(dt.Month()) + ' '+ dt.Day() + ', ' + dt.Year(); 
      }
      return stringDate;
    }
    //date time related method
    public String getMonthName(integer month){
      String monthName = '';
      if(month == 1){
        monthName = (userLocale =='es' || userLocale == 'ES') ? 'Ene':(userLocale =='it' || userLocale=='IT')? 'gennaio' : 'Jan';
      }
      else if(month == 2){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'febbraio' :'Feb';
      }
      else if(month == 3){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'marzo' : (userLocale =='de' || userLocale=='DE')? 'Mär' : 'Mar';
      }
      else if(month == 4){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'aprile' :'Apr';
      }
      else if(month == 5){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'maggio' :(userLocale =='de' || userLocale=='DE')? 'Mai' : 'May';
      }
      else if(month == 6){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'giugno' :'Jun';
      }
      else if(month == 7){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'luglio' :'Jul';
      }
      else if(month == 8){
        monthName = (userLocale =='es' || userLocale=='ES') ? 'Ago' : (userLocale =='it' || userLocale=='IT') ? 'agosto' :'Aug';
      }
      else if(month == 9){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'settembre' :'Sep';
      }
      else if(month == 10){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'ottobre' :(userLocale =='de' || userLocale=='DE') ? 'Okt' : 'Oct';
      }
      else if(month == 11){
        monthName = (userLocale =='it' || userLocale=='IT') ? 'novembre' :'Nov';
      }
      else if(month == 12){
         monthName = (userLocale =='es' || userLocale=='ES')? 'Dic' :(userLocale =='it' || userLocale=='IT')? 'dicembre' :(userLocale =='de' || userLocale=='DE')? 'Dez' : 'Dec';
      }
      return monthName;
    }
  }
  
  //to remove selected item
  public PageReference remove(){
    try{
      if(idToDelete != null){   
        Content__c con = new Content__c(Id=idToDelete);
        delete con;
        listAnnouncements = null;
        listClips = null;
        listEvent = null;
        listTaining = null;
      }  
    }
    catch(Exception ex){
      ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
      ApexPages.addMessage(msg);
    }  
    return null;
  }
}