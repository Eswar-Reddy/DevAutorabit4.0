public class DocumentLibraryController{
//Content object
Public Content__c objContent{get; set;}
//Property to store the name of selected subTab
public String selectedSubTab {get;set;}
//Property to check whether archival data is to be shown
public boolean isIncludeArchive {get;set;}
//Property to hold the list of all Contents
public List<Content__C> lstAllContents {get;set;} 
//Property to hold the list of all Contents for knowledgeBase tab
public List<Content__C> lstknowledgeBase {get;set;}
//Property to hold the list of all Contents for ProcessDocuments tab
public List<Content__C> lstProcess {get;set;}
//Property to hold the list of all Contents for MarketingBulletins tab
public List<Content__C> lstMarketing {get;set;}
//Property to hold the list of all Contents for TechnicalNotifications tab
public List<Content__C> lstTechnical {get;set;}
//Property to hold the details of current login user
public User currentUser {get;set;}
//Property to store the type of Partner Account if user is PowerPartner
private String PartnerType {get;set;}
//Property to hold one year ond date in the formate year-month-day
private String oneYearOldDate{get;set;}
//Property to hold fixed date in the formate year-month-day
private String constantFixedOldDate{get;set;}
//To fill the combobox Category on KnowledgeBase tab
public List<SelectOption> lstCategory{get;set;}
//To get the selected value of combobox Category on KnowledgeBase tab
public String selCategory{get;set;} 
//To store string to be seached in KnowledgeBase tab
public String SearchStringKnowledge{get;set;}
//To store string to be seached in Marketing tab
public String SearchStringMarketing{get;set;}
//To store string to be seached in Technical tab
public String SearchStringTechnical{get;set;}
//To store string to be seached in Process tab
public String SearchStringProcess{get;set;}
//Property to store ID of Content to be deleted
public String idToDelete {get;set;}
//Property to check if current User is Administrator or SunPower Super User or SunPower Partner Ambassador
private Boolean isSunPowerSuperUser;
//properies for sorting
public String sortDirectionKnowledge{get;set;}
public String sortValueKnowledge {get;set;}
public String sortDirectionProcess{get;set;}
public String sortValueProcess {get;set;}
public String sortDirectionMarketing{get;set;}
public String sortValueMarketing {get;set;}
public String sortDirectionTechnical{get;set;}
public String sortValueTechnical {get;set;}
public boolean isSortCall {get; set;}

/* Added for Sunpower Case # 00028955 */
private final String QUERY_STRING;
/**************************************/

public Boolean getIsSunPowerSuperUser(){
    List<Profile> profileList =  new List<Profile>([Select Id, Name from Profile where Id =:Userinfo.getProfileId()]);
    //List<Profile> profileList =  new List<Profile>();
    //User u = [select id,profile.name,profile.id from user where id=:userinfo.getUserID()];
    //profileList.Add(new profile(id=u.profile.id,name=u.profile.name));
    //system.debug('---prnameFst---'+u.profile.name);
    if(profileList.Size()>0){
        String prName = profileList.get(0).Name;
        Id prId = profileList.get(0).Id;
        system.debug('---prname1---'+prName);
        if(prName == 'SunPower Super User'){
            return true; //to edit and delete link for sunpower super user 
        }
        if(prName == 'SunPower Partner Ambassador'){
            return true; //to edit and delete link for SunPower Partner Ambassador 
        }
        else if(prId == '00e80000000tepU'){
        system.debug('---prname2---'+prName);
            return true; //to edit and delete link for administrator
        }        
    }
    system.debug('---prname3---'+profileList);
    return false; 
    
}

//Properties for pagination knowledgeBase list
private integer stdPageSizeKnowledge=15;
public String paginglabelKnowledge{get;set;}
public String isFirstKnowledge{get;set;}
public String isPreKnowledge{get;set;}
public String isOneKnowledge{get;set;}
public String isSecondKnowledge{get;set;}
public String isThirdKnowledge{get;set;}
public String isNextKnowledge{get;set;}
public String islastKnowledge{get;set;}
public String strClickedKnowledge{get;set;}
private integer currentPageNumberKnowledge{get;set;}
public List<Content__c> pageLstKnowledge{get;set;}

//Properties for pagination Process list
private integer stdPageSizeProcess=15;
public String paginglabelProcess{get;set;}
public String isFirstProcess{get;set;}
public String isPreProcess{get;set;}
public String isOneProcess{get;set;}
public String isSecondProcess{get;set;}
public String isThirdProcess{get;set;}
public String isNextProcess{get;set;}
public String islastProcess{get;set;}
public String strClickedProcess{get;set;}
private integer currentPageNumberProcess{get;set;}
public List<Content__c> pageLstProcess{get;set;}

//Properties for pagination Marketing list
private integer stdPageSizeMarketing=15;
public String paginglabelMarketing{get;set;}
public String isFirstMarketing{get;set;}
public String isPreMarketing{get;set;}
public String isOneMarketing{get;set;}
public String isSecondMarketing{get;set;}
public String isThirdMarketing{get;set;}
public String isNextMarketing{get;set;}
public String islastMarketing{get;set;}
public String strClickedMarketing{get;set;}
private integer currentPageNumberMarketing{get;set;}
public List<Content__c> pageLstMarketing{get;set;}

//Properties for pagination Technical list
private integer stdPageSizeTechnical=15;
public String paginglabelTechnical{get;set;}
public String isFirstTechnical{get;set;}
public String isPreTechnical{get;set;}
public String isOneTechnical{get;set;}
public String isSecondTechnical{get;set;}
public String isThirdTechnical{get;set;}
public String isNextTechnical{get;set;}
public String islastTechnical{get;set;}
public String strClickedTechnical{get;set;}
private integer currentPageNumberTechnical{get;set;}
public List<Content__c> pageLstTechnical{get;set;}

//Property to check whether the current user is EU type or US type
public boolean isUSUser {get;set;}

//Prepare set of knowledge base categotries for US users
Set<String> setCategoryUS = new Set<String>{'Diagrams & CAD Blocks','FAQs','Product Datasheets','Product Manuals','Product Warranties','Training Manual','Webinars'};

//Prepare set of knowledge base categotries for EU users
Set<String> setCategoryEU = new Set<String>{'Certificates','Marketing','Technical Datasheet','Technical Manual'};

//Property to set the type of Process tab or Dealer Bulletins for US or EU users respectively
private String processDealerType{get;set;}

//Property to set the type of Technical Notification tab or Technical Bulletins for US or EU users respectively
private String technicalType{get;set;}

//Constructor
public DocumentLibraryController(){
    //Initialize variables
    objContent = new Content__c();
    isUSUser = true;
    processDealerType='Process';
    technicalType='Technical';
    isIncludeArchive = false;
    PartnerType = '';
    SearchStringKnowledge='';
    SearchStringProcess='';
    SearchStringMarketing='';
    SearchStringTechnical='';
    currentPageNumberKnowledge = 1;
    currentPageNumberProcess = 1;
    currentPageNumberMarketing = 1;
    currentPageNumberTechnical = 1;
    IsSunPowerSuperUser = getIsSunPowerSuperUser();
    sortDirectionKnowledge = sortDirectionProcess = sortDirectionMarketing = sortDirectionTechnical = 'ASC';
    sortValueknowledge = sortValueProcess = sortValueMarketing = sortValueTechnical = '';
    isSortCall = false;
    //Get one year old date
    FillOneYearOldDate();
    FillConstantFixedOldDate();
    //Get the detail of current login user
    currentUser=[Select id,country_domain__c,profile.name,UserType,ContactID,Contact.AccountID,Contact.Account.Type from User where id = :Userinfo.getUserID() ];
    
    /* Added for Sunpower Case # 00028955 */
    QUERY_STRING = 'Select Id, External_ID__c, Title__c, Content_Location__c, Type__c,'
            + ' Version_Number__c, Category__c, Publish_Date__c, CreatedDate From Content__c Where'
            + ' RecordType.Name = \'Documentation\' And Latest_Version__c = true And Country_Domain__c'
            + ' includes (\'' + getCountryDomain() + '\') ';
    
    System.debug('Debug: QUERY_STRING ' + QUERY_STRING);
    /**************************************/
    
    //Set the content location to include session and serverUrl
    
    //Set isUSUser true if US user and false if EU User
    if(currentUser.country_domain__c == 'cvar-us' || currentUser.country_domain__c == 'rvar-us' || currentUser.country_domain__c == 'combo-us'){       
        isUSUser = true;
    }
   // Added AU country domain condition for case 00047329 - closed by customer
   // Added BE country domain condition for case 00050644
    if(currentUser.country_domain__c == 'rvar-es' || currentUser.country_domain__c == 'rvar-it' 
    || currentUser.country_domain__c == 'rvar-de' || currentUser.country_domain__c == 'rvar-fr' 
    || currentUser.country_domain__c == 'cvar-it' || currentUser.country_domain__c == 'cvar-es' 
    || currentUser.country_domain__c == 'cvar-de' || currentUser.country_domain__c == 'cvar-fr' 
    || currentUser.country_domain__c == 'combo-es' || currentUser.country_domain__c == 'combo-de' 
    || currentUser.country_domain__c == 'combo-it' || currentUser.country_domain__c == 'combo-fr' 
    //|| currentUser.country_domain__c == 'cvar-au' || currentUser.country_domain__c == 'rvar-au' 
    //|| currentUser.country_domain__c == 'combo-au'  
    || currentUser.country_domain__c == 'cvar-be' 
    || currentUser.country_domain__c == 'rvar-be' || currentUser.country_domain__c == 'combo-be'
     //Case # 00072314
    || currentUser.country_domain__c == 'cvar-uk' 
    || currentUser.country_domain__c == 'rvar-uk' || currentUser.country_domain__c == 'combo-uk'){
        isUSUser = false;
        //processDealerType='Dealer Bulletins';
        //technicalType='Technical Bulletins';
    }

    //Get the type of Partner Account if user is PowerPartner
    if(currentUser.ContactID != null && currentUser.UserType == 'PowerPartner'){
        if(currentUser.Contact.AccountID != null){
            PartnerType = currentUser.Contact.Account.Type;
        }
    }
    //Make sub tab selected
    if(ApexPages.currentPage().getParameters().get('retSubTab')!=null){
        selectedSubTab = ApexPages.currentPage().getParameters().get('retSubTab');
    }
    //Fill Category combobox on Knowledge Base tab
    FillCategories();
    //objContent.category_US__c = 'All';
    //objContent.category_EU__c = 'All';
    //Get full list of Contents
    getAllContent();        
    //Fill Lists of All Tabs
    FillListForAllTabs(lstAllContents);
}

/* Added for Sunpower Case # 00028955 */
private String getCountryDomain() {
    String countryDomain = '';
    
    if (currentUser.Country_Domain__c != null && currentUser.Country_Domain__c.startsWith('combo-')) {
        String countryCode = currentUser.Country_Domain__c.substring(6);
        countryDomain = 'rvar-' + countryCode + '\', \'cvar-' + countryCode;
    } else {
        countryDomain = currentUser.Country_Domain__c;
    }
    
    return countryDomain;
}
/**************************************/

//Get full list of Contents
private void getAllContent(){
    //Get list of all Contents
    lstAllContents = new List<Content__C>();
    //Prepare query
    /* Change for Sunpower Case # 00028955 */
    // String strQuery = 'Select id,External_ID__c, Title__c,Version_Number__c,Category__c,Publish_Date__c,Content_Location__c,type__c,createdDate from Content__c where recordtype.name=\'Documentation\' and latest_version__c = true and country_domain__c includes (\''+currentUser.country_domain__c+'\') ';
    String strQuery = QUERY_STRING;
    /**************************************/

    // SunPower SuperUsers can view all docs
    if(!IsSunPowerSuperUser) {
        strQuery = strQuery + ' and view_profiles__c includes (\''+currentUser.profile.name+'\') ';      
    } 
    
    if(currentUser.UserType == 'PowerPartner'){
        strQuery = strQuery +' and Partner_Type__c includes (\''+PartnerType+'\') ';
    }
    if(isIncludeArchive==false){
    // Change reference case 00034989 / 00034989
    //   strQuery = strQuery+' and Publish_Date__c>'+oneYearOldDate+' ' ;
        strQuery = strQuery+' and( ((type__c =\'Marketing\' or type__c = \'Technical\')and Publish_Date__c >' +oneYearOldDate +') or ((type__c =\'General\' or type__c = \'Process\')and Publish_Date__c >' + constantFixedOldDate + '))' +''; //   Publish_Date__c>'+oneYearOldDate+' ' ;
   }   
    strQuery = strQuery +' order by Publish_Date__c desc, Title__c ';
    lstAllContents = database.query(strQuery);   
    system.debug('@@@1@@@'+lstAllContents.size());
}
    
// Added by Linda - 7/23/09 to fill Categories from the Category picklist instead of Type (??)
// Fill picklist values from document type Content
private void FillCategories(){
    lstCategory = new List<SelectOption>();
    lstCategory.add(new selectOption('All',System.Label.AllPicklistValue)); 
    Schema.DescribeFieldResult F ;
    if(isUSUser){
        F = Content__c.Category_US__c.getDescribe();
    }
    else{
        F = Content__c.Category_EU__c.getDescribe();
    }
    //Schema.DescribeFieldResult F = Content__c.Category__c.getDescribe();
    List<Schema.PicklistEntry> P = F.getPicklistValues();
    for(Schema.PicklistEntry entry : P){    
        lstCategory.add(new SelectOption(entry.getValue(),entry.getLabel()));          
        //if(setCategoryUS.contains(entry.getLabel()) && isUSUser){
        //    lstCategory.add(new SelectOption(entry.getValue(),entry.getLabel()));
        //} 
        //if(setCategoryEU.contains(entry.getLabel()) && !(isUSUser)){
        //    lstCategory.add(new SelectOption(entry.getValue(),entry.getLabel()));
        //}        
    }
    selCategory = 'All';       
}

//Fill Lists of All Tabs
private void FillListForAllTabs(List<Content__C> allContents){
    //Clear all lists
    lstknowledgeBase = new List<Content__C>();
    pageLstKnowledge = new List<Content__C>();
    lstProcess = new List<Content__C>();
    pageLstProcess = new List<Content__C>();
    lstMarketing = new List<Content__C>();
    pageLstMarketing = new List<Content__C>();
    lstTechnical = new List<Content__C>();
    pageLstTechnical = new List<Content__C>();
    
    //Fill All lists  Publish_Date__c>'+oneYearOldDate+' ' ;
    for(Content__C cont:allContents){
        if(cont.Type__c == processDealerType  ){
            lstProcess.Add(cont);
        }
        else if(cont.Type__c == 'Marketing'){
             
            lstMarketing.Add(cont);
        }
        else if(cont.Type__c == technicalType){
            lstTechnical.Add(cont);
        }
        else{
            lstknowledgeBase.Add(cont);
        }
    }
    //Set paging for all tabs
    SetPagingForKnowledgeBase();
    SetPagingForProcess();
    SetPagingForMarketing();
    SetPagingForTechnical();
}

//Get one year ond date in the formate year-month-day
private void FillOneYearOldDate(){
    Date dt = Date.today();        
    String strMonth=String.valueOf(dt.month());
    String strDay=String.valueOf(dt.day());
    if(dt.month()<10){
        strMonth = '0'+strMonth;
    }
    if(dt.day()<10){
        strDay = '0'+strDay;
    }
    oneYearOldDate=String.valueOf(dt.year()-1)+'-'+strMonth+'-'+strDay;
}

//Get Fixed date '2010-06-30' in the formate year-month-day as per case 00034989 / 00034989
private void FillConstantFixedOldDate(){
    
    constantFixedOldDate='2009-06-15';
}

//to remove selected item
public void remove() {
 try{  
      if(idToDelete != null){   
        Content__c con = new Content__c(Id=idToDelete);
        delete con;
        //Clear clicked string
        strClickedKnowledge = '';
        strClickedProcess = '';
        strClickedMarketing = '';
        strClickedTechnical ='';
        //Get full list of Contents
        getAllContent();        
        //Fill Lists of All Tabs
        FillListForAllTabs(lstAllContents);
      }    
   }
   catch(Exception ex) {
      ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
      ApexPages.addMessage(msg);
   }    
}

//Paging for knowledge base tab list
public void SetPagingForKnowledgeBase(){
    pageLstKnowledge = new List<Content__C>();
    //Create list for knowledgebase parameters
    List<String> lstParameter = new List<String>{String.valueOf(stdPageSizeKnowledge),paginglabelKnowledge,isFirstKnowledge, isPreKnowledge, isOneKnowledge, isSecondKnowledge, isThirdKnowledge, isNextKnowledge, islastKnowledge,strClickedKnowledge,String.valueOf(currentPageNumberKnowledge)}; 
    //Set paging parameters
    SetPaging(lstknowledgeBase, pageLstKnowledge, lstParameter );
    //Map parameters from list to original paging parameters
    stdPageSizeKnowledge = Integer.valueOf(lstParameter[0]);
    paginglabelKnowledge = lstParameter[1];
    isFirstKnowledge = lstParameter[2];
    isPreKnowledge = lstParameter[3];
    isOneKnowledge = lstParameter[4];
    isSecondKnowledge = lstParameter[5];
    isThirdKnowledge = lstParameter[6];
    isNextKnowledge = lstParameter[7];
    islastKnowledge = lstParameter[8];
    strClickedKnowledge = lstParameter[9];
    currentPageNumberKnowledge  = Integer.valueOf(lstParameter[10]);    
}

//Paging for Process tab list
public void SetPagingForProcess(){
    pageLstProcess = new List<Content__C>();
    //Create list for Process parameters
    List<String> lstParameter = new List<String>{String.valueOf(stdPageSizeProcess),paginglabelProcess,isFirstProcess, isPreProcess, isOneProcess, isSecondProcess, isThirdProcess, isNextProcess, islastProcess,strClickedProcess,String.valueOf(currentPageNumberProcess)};   
    //Set paging parameters
    SetPaging(lstProcess, pageLstProcess, lstParameter );
   
    //Map parameters from list to original paging parameters
    stdPageSizeProcess = Integer.valueOf(lstParameter[0]);
    paginglabelProcess = lstParameter[1];
    isFirstProcess = lstParameter[2];
    isPreProcess = lstParameter[3];
    isOneProcess = lstParameter[4];
    isSecondProcess = lstParameter[5];
    isThirdProcess = lstParameter[6];
    isNextProcess = lstParameter[7];
    islastProcess = lstParameter[8];
    strClickedProcess = lstParameter[9];
    currentPageNumberProcess  = Integer.valueOf(lstParameter[10]);
}

//Paging for Marketing Bullentins tab list
public void SetPagingForMarketing(){
    pageLstMarketing = new List<Content__C>();
    //Create list for Marketing parameters
    List<String> lstParameter = new List<String>{String.valueOf(stdPageSizeMarketing),paginglabelMarketing,isFirstMarketing, isPreMarketing, isOneMarketing, isSecondMarketing, isThirdMarketing, isNextMarketing, islastMarketing,strClickedMarketing,String.valueOf(currentPageNumberMarketing)}; 
    //Set paging parameters
    SetPaging(lstMarketing, pageLstMarketing, lstParameter );
     //Map parameters from list to original paging parameters
    stdPageSizeMarketing = Integer.valueOf(lstParameter[0]);
    paginglabelMarketing = lstParameter[1];
    isFirstMarketing = lstParameter[2];
    isPreMarketing = lstParameter[3];
    isOneMarketing = lstParameter[4];
    isSecondMarketing = lstParameter[5];
    isThirdMarketing = lstParameter[6];
    isNextMarketing = lstParameter[7];
    islastMarketing = lstParameter[8];
    strClickedMarketing = lstParameter[9];
    currentPageNumberMarketing  = Integer.valueOf(lstParameter[10]);
}

//Paging for Technical Notifications tab list
public void SetPagingForTechnical(){
    pageLstTechnical = new List<Content__C>();
    //Create list for Marketing parameters
    List<String> lstParameter = new List<String>{String.valueOf(stdPageSizeTechnical),paginglabelTechnical,isFirstTechnical, isPreTechnical, isOneTechnical, isSecondTechnical, isThirdTechnical, isNextTechnical, islastTechnical,strClickedTechnical,String.valueOf(currentPageNumberTechnical)}; 
    //Set paging parameters
    SetPaging(lstTechnical, pageLstTechnical, lstParameter );
    //Map parameters from list to original paging parameters
    stdPageSizeTechnical = Integer.valueOf(lstParameter[0]);
    paginglabelTechnical = lstParameter[1];
    isFirstTechnical = lstParameter[2];
    isPreTechnical = lstParameter[3];
    isOneTechnical = lstParameter[4];
    isSecondTechnical = lstParameter[5];
    isThirdTechnical = lstParameter[6];
    isNextTechnical = lstParameter[7];
    islastTechnical = lstParameter[8];
    strClickedTechnical = lstParameter[9];
    currentPageNumberTechnical  = Integer.valueOf(lstParameter[10]);
}

//Perform Advance Search on conetent object
public PageReference doAdvanceSearch(){
    //Prepare url for advance search
    String preFix=Content__c.SObjectType.getDescribe().getKeyPrefix();
    String url = '/search/SearchResults?searchType=2&str='+SearchStringKnowledge.trim()+'&search=Search&sen='+preFix;
    //Redirect to advance search page
    PageReference pg = new pageReference(url);
    pg.setRedirect(true);
    return pg;
}

//Call when search button on knowledge base is clicked
public void FillKnowledgeDoclistBySearch(){
    String selCategoryDomainBased = '';
    if(isUSUser){
        selCategoryDomainBased = objContent.category_US__c;
    }
    else{
        selCategoryDomainBased = objContent.category_EU__c;
    }
    if(isSortCall){
        if(sortDirectionKnowledge == 'ASC'){
            sortDirectionKnowledge = 'DESC';
        }
        else{
            sortDirectionKnowledge = 'ASC';
        }
        isSortCall = false;
    }
    else{
        sortValueknowledge = '';
    }
    currentPageNumberKnowledge =1;  
    strClickedKnowledge='';   
    lstknowledgeBase = new List<Content__C>();
    pageLstKnowledge = new List<Content__C>();
    //Prepare query
    /* Change for Sunpower Case # 00028955 */
    // String strQuery = 'Select id, External_ID__c, Title__c,Content_Location__c,Publish_Date__c,Version_Number__c,Category__c,type__c,createdDate from Content__c where recordtype.name=\'Documentation\' and latest_version__c = true and country_domain__c includes (\''+currentUser.country_domain__c+'\') and title__c like \'%'+SearchStringKnowledge.trim()+'%\' ';
    String strQuery = QUERY_STRING + 'And status__c=\'Approved\'' + ' And (Title__c Like \'%' + String.escapeSingleQuotes(SearchStringKnowledge.trim())+ '%\' or Description__c Like \'%' + String.escapeSingleQuotes(SearchStringKnowledge.trim())+ '%\'	)';  
   system.debug('============================'+strQuery);
    /**************************************/
    
    // SunPower SuperUsers can view all docs
    if(!IsSunPowerSuperUser) {
        strQuery = strQuery +' and view_profiles__c includes (\''+currentUser.profile.name+'\') ';
    }
    if(currentUser.UserType == 'PowerPartner'){
        strQuery = strQuery +' and Partner_Type__c includes (\''+PartnerType+'\') ';
    }
   // Case  : 00034989 not showing Archive document on Knowledge Base. 
    if(isIncludeArchive==false){
        strQuery = strQuery+' and Publish_Date__c>'+ constantFixedOldDate +' ';
    }   
    if(selCategory!='All' && selCategory!=null){
        strQuery = strQuery+' and category__c=\''+selCategory+'\' ';        
    } 
    
    strQuery = strQuery+' and type__c!=\'Marketing\' and type__c!=\''+technicalType+'\' and type__c!=\''+processDealerType+'\' ';
    
    
    if(sortValueknowledge!=null && sortValueknowledge!=''){
        strQuery = strQuery +' order by '+sortValueknowledge+ ' '+sortDirectionKnowledge+ ' ';      
    }
    else{
        strQuery = strQuery +' order by Publish_Date__c desc, Title__c '; 
    }   
    
    //Fill list
    lstknowledgeBase = database.query(strQuery);   
    //Set paging
    SetPagingForKnowledgeBase();          
}

//Call when search button on Process tab is clicked
public void FillProcessDocBySearch(){
    currentPageNumberProcess =1;  
    strClickedProcess='';       
    lstProcess = new List<Content__C>();
    pageLstProcess = new List<Content__C>();
    if(isSortCall){
        if(sortDirectionProcess == 'ASC'){
            sortDirectionProcess = 'DESC';
        }
        else{
            sortDirectionProcess = 'ASC';
        }
        isSortCall = false;
    }
    else{
        sortValueProcess = '';
    }
    //Prepare query
    String strQuery = prepareSearchQuery(processDealerType,searchStringProcess,false,sortDirectionProcess,sortValueProcess);  
    system.debug('-----------------Abhay-----------------------'+strQuery);
    //Fill list
    lstProcess = database.query(strQuery);   
    //Set paging
    SetPagingForProcess();          
}

//Call when search button on Marketing tab is clicked
public void FillMarketingDocBySearch(){
    currentPageNumberMarketing =1;  
    strClickedMarketing='';       
    lstMarketing = new List<Content__C>();
    pageLstMarketing = new List<Content__C>();
    if(isSortCall){
        if(sortDirectionMarketing == 'ASC'){
            sortDirectionMarketing = 'DESC';
        }
        else{
            sortDirectionMarketing = 'ASC';
        }
        isSortCall = false;
    }
    else{
        sortValueMarketing = '';
    }
    //Prepare query
    String strQuery = prepareSearchQuery('Marketing',searchStringMarketing,false,sortDirectionMarketing,sortValueMarketing);  
    //Fill list
    lstMarketing = database.query(strQuery);   
    //Set paging
    SetPagingForMarketing();          
}

//Call when search button on Technical tab is clicked
public void FillTechnicalDocBySearch(){
    currentPageNumberTechnical =1;  
    strClickedTechnical='';   
    lstTechnical = new List<Content__C>();
    pageLstTechnical = new List<Content__C>();
    if(isSortCall){
        if(sortDirectionTechnical == 'ASC'){
            sortDirectionTechnical = 'DESC';
        }
        else{
            sortDirectionTechnical = 'ASC';
        }
        isSortCall = false;
    }
    else{
        sortValueTechnical = '';
    }
    //Prepare query
    String strQuery = prepareSearchQuery(technicalType,searchStringTechnical,false,sortDirectionTechnical,sortValueTechnical);  
    //Fill list
    lstTechnical = database.query(strQuery);   
    //Set paging
    SetPagingForTechnical();          
}

//List all documnets on Index button click
public void FillKnowledgeBaseDoclist(){
    currentPageNumberKnowledge =1;
    strClickedKnowledge='';
    sortValueknowledge  = '';
    lstknowledgeBase = new List<Content__c>();
    pageLstKnowledge = new List<Content__C>();
    
    //Prepare query
    /* Change for Sunpower Case # 00028955 */
    // String strQuery = 'Select id, External_ID__c, Title__c,Content_Location__c,type__c,Version_Number__c,Category__c,Publish_Date__c,createdDate from Content__c where recordtype.name=\'Documentation\' and latest_version__c = true and country_domain__c includes (\''+currentUser.country_domain__c+'\')  ';
    String strQuery = QUERY_STRING;
    /**************************************/
    
    // SunPower SuperUsers can view all docs
    if(!IsSunPowerSuperUser) {
        strQuery = strQuery +' and view_profiles__c includes (\''+currentUser.profile.name+'\') ';
    }

    if(currentUser.UserType == 'PowerPartner'){
        strQuery = strQuery +' and Partner_Type__c includes (\''+PartnerType+'\') ';
    }
    if(isIncludeArchive==false){
        strQuery = strQuery+' and Publish_Date__c>'+constantFixedOldDate+'';
    }       
    strQuery = strQuery+' and type__c!=\'Marketing\' and type__c!=\''+technicalType+'\' and type__c!=\''+processDealerType+'\' order by Publish_Date__c desc, Title__c ';
    
    //Fill list
    lstknowledgeBase = database.query(strQuery);   
    //Set paging
    SetPagingForKnowledgeBase();         
}

//List 10 documnets on Recently Added button click
public void FillRecentDoclist(){
    currentPageNumberKnowledge =1;
    strClickedKnowledge ='';
    sortValueknowledge  = '';
    lstknowledgeBase = new List<Content__c>();
    pageLstKnowledge = new List<Content__C>();
    
    //Prepare query
    /* Change for Sunpower Case # 00028955 */
    // String strQuery = 'Select id, External_ID__c, Title__c,Content_Location__c,type__c,Version_Number__c,Category__c,Publish_Date__c,createdDate from Content__c where recordtype.name=\'Documentation\' and latest_version__c = true and country_domain__c includes (\''+currentUser.country_domain__c+'\')  ';
    String strQuery = QUERY_STRING;
    /**************************************/
     
    // SunPower SuperUsers can view all docs
    if(!IsSunPowerSuperUser) {
        strQuery = strQuery +' and view_profiles__c includes (\''+currentUser.profile.name+'\') ';
    }
    if(currentUser.UserType == 'PowerPartner'){
        strQuery = strQuery +' and Partner_Type__c includes (\''+PartnerType+'\') ';
    }
    if(isIncludeArchive==false){
        strQuery = strQuery+' and Publish_Date__c>'+constantFixedOldDate+' ';
    }       
    //strQuery = strQuery+' and type__c!=\'Marketing\' and type__c!=\'Technical\' and type__c!=\'process\' order by CreatedDate desc limit 10 ';           
    strQuery = strQuery +' order by Publish_Date__c ASC limit 10 ';  
    //Fill list
    lstknowledgeBase = database.query(strQuery);   
    //Set paging
    SetPagingForKnowledgeBase();  
}

//List 10 documnets on Popular Documents button click 
public void FillPopularDoclist(){
    currentPageNumberKnowledge =1;
    strClickedKnowledge='';
    sortValueknowledge  = '';
    lstknowledgeBase = new List<Content__c>();
    pageLstKnowledge = new List<Content__C>();
    List<Content__c> lst = new List<Content__c>();
    
    /* Change for Sunpower Case # 00028955 */
    // String qry = 'select id, Content__r.External_ID__c, Content__c,Content__r.content_location__c,Content__r.Title__c,Content__r.Version_Number__c,Content__r.Category__c,Content__r.country_domain__c,Content__r.View_Profiles__c,Content__r.Partner_Type__c,Content__r.Publish_Date__c from Content_tracker__c where Content__r.recordtype.name=\'Documentation\' and Content__r.latest_version__c = true and Content__r.country_domain__c includes (\''+currentUser.country_domain__c+'\')  ';
    String qry = 'Select Id, Content__r.External_ID__c, Content__c, Content__r.Content_Location__c,'
            + ' Content__r.Title__c, Content__r.Version_Number__c, Content__r.Category__c,'
            + ' Content__r.Country_Domain__c, Content__r.View_Profiles__c, Content__r.Partner_Type__c,'
            + ' Content__r.Publish_Date__c From Content_Tracker__c Where Content__r.RecordType.Name ='
            + ' \'Documentation\' And Content__r.Latest_Version__c = true And Content__r.Country_Domain__c'
            + ' includes (\'' + getCountryDomain() + '\') ';
    /**************************************/
    
    // SunPower SuperUsers can view all docs
    if(!IsSunPowerSuperUser) {
        qry = qry +' and Content__r.view_profiles__c includes (\''+currentUser.profile.name+'\') ';
    }
    if(currentUser.UserType == 'PowerPartner'){
        qry = qry +' and Content__r.Partner_Type__c includes (\''+PartnerType+'\') ';
    }
    if(isIncludeArchive==false){
        qry = qry+' and Content__r.Publish_Date__c>'+constantFixedOldDate+' ';
    } 
    qry = qry+' order by createdDate Desc limit 1000 ';
    List<Content_tracker__c> lstTrack =database.query(qry);
    
    Integer count=0;
    map<ID,Integer> mapcontentAccessCount = new map<ID,Integer>();
    map<ID,Integer> ImagecontentAccessCount = new map<ID,Integer>();
    map<ID,Content__c> mapcontentobj = new map<ID,Content__c>();
    for(Content_tracker__c conTrack:lstTrack){
        if(mapcontentAccessCount.containsKey(conTrack.Content__c)){
            mapcontentAccessCount.put(conTrack.Content__c, 0);
            ImagecontentAccessCount.put(conTrack.Content__c, mapcontentAccessCount.get(conTrack.Content__c)+1);
        }
        else{
            mapcontentAccessCount.put(conTrack.Content__c,0);
            ImagecontentAccessCount.put(conTrack.Content__c,1);
            mapcontentobj.put(conTrack.Content__c,conTrack.Content__r);
        }
    }
    integer index = 1;
          
    //Get 10 most accessed Content__c
    for(ID ident:mapcontentAccessCount.keyset()){
        Content__c maxCon;
        ID finalID;
        Integer countVal = mapcontentAccessCount.get(ident);
        for(ID ident1:ImagecontentAccessCount.keySet()){
            if(countVal <= ImagecontentAccessCount.get(ident1)){                   
                maxCon = mapcontentobj.get(ident1);
                finalID = ident1;
                countVal = ImagecontentAccessCount.get(ident1);
            }
        }
        if(maxCon!=null){                           
            //if(currentUser.UserType == 'PowerPartner'){
            //    if(maxCon.Partner_Type__c==PartnerType){
            //        lst.Add(maxCon);
            //        index++;
            //    }
            //}
            //else{   
                lst.Add(maxCon);
                index++;
            //}           
        }
        if(finalID!=null && ImagecontentAccessCount.containskey(finalID)){
            ImagecontentAccessCount.remove(finalID);                
        }
        if(index==10){
            break;
        }            
    }
    
    //Fill list
    lstknowledgeBase = lst;   
    //Set paging
    SetPagingForKnowledgeBase(); 
}

//Prepare Search Query
private String prepareSearchQuery(String typeContent,String searchString,Boolean isKnowledgeBase,String sortDirection,String sortValue){    
    /* Change for Sunpower Case # 00028955 */
    // String strQuery = 'Select id, External_ID__c, Title__c,Content_Location__c,type__c,Version_Number__c,Category__c,Publish_Date__c,createdDate from Content__c where recordtype.name=\'Documentation\' and latest_version__c = true and country_domain__c includes (\''+currentUser.country_domain__c+'\') and type__c=\''+typeContent+'\' and title__c like \'%'+SearchString.trim()+'%\' ';
    String strQuery = QUERY_STRING + 'And status__c=\'Approved\' And Type__c = \'' + typeContent + '\' And (Title__c Like \'%'+ SearchString.trim() + '%\' or Description__c Like \'%'+ SearchString.trim() + '%\') ';
    /**************************************/
     
    // SunPower SuperUsers can view all docs
    if(!IsSunPowerSuperUser) {
        strQuery = strQuery +' and view_profiles__c includes (\''+currentUser.profile.name+'\') ';
    }
    if(currentUser.UserType == 'PowerPartner'){
        strQuery = strQuery +' and Partner_Type__c includes (\''+PartnerType+'\') ';
    }
    // Change by refer case 00034989 
    if(isIncludeArchive==false){
        if (typeContent == processDealerType) {
          strQuery = strQuery+' and Publish_Date__c>'+ constantFixedOldDate +' ';
        }
        else {
          strQuery = strQuery+' and Publish_Date__c>'+oneYearOldDate+' ';
        }
    }   
    
    if(sortValue!=null && sortValue!=''){
        strQuery = strQuery +' order by '+sortValue+ ' '+sortDirection+ ' ';        
    }
    else{
        strQuery = strQuery +' order by Publish_Date__c desc, Title__c ';
    }     
    
    return strQuery;
}

//Set Paging for the lists 
public void SetPaging(List<Content__c> lstFull,List<Content__c> lstPage,List<String> lstParameter){     
    //Map list parameters
    Integer stdPageSize = Integer.valueOf(lstParameter[0]);
    String paginglabel = lstParameter[1];
    String isFirst = lstParameter[2];
    String isPre = lstParameter[3];
    String isOne = lstParameter[4];
    String isSecond = lstParameter[5];
    String isThird = lstParameter[6];
    String isNext = lstParameter[7];
    String islast = lstParameter[8];
    String strClicked = lstParameter[9];
    integer currentPageNumber = Integer.valueOf(lstParameter[10]);
    
    //Get last page number 
    integer lastPageNumber=lstFull.size()/stdPageSize; 
    Integer remainder = math.mod(lstFull.size(), stdPageSize); 
    if(remainder!=0){lastPageNumber= lastPageNumber+1;}
    
    //Set current page number according to clicked link on paging control
    if(strClicked!=null && strClicked!=''){
        if(strClicked=='First'){currentPageNumber = 1;}
        if(strClicked=='Pre'){currentPageNumber = currentPageNumber-1;}
        if(strClicked=='1'){currentPageNumber = 1;}
        if(strClicked=='2'){currentPageNumber = 2;}
        if(strClicked=='3'){currentPageNumber = 3;}
        if(strClicked=='Next'){currentPageNumber = currentPageNumber+1;}
        if(strClicked=='Last'){currentPageNumber = lastPageNumber;}
    }        
     system.debug('lastPageNumber'+lastPageNumber);   
      system.debug('lstFull.size()'+lstFull.size());          
    Integer StartNumber =((currentPageNumber-1)*stdPageSize)+1;
    Integer EndNumber = ((currentPageNumber-1)*stdPageSize)+stdPageSize;        
    if(currentPageNumber == lastPageNumber){
        EndNumber = StartNumber-1+lstFull.size()-(stdPageSize*(currentPageNumber-1));
    }
                           
    isFirst=isPre=isOne=isSecond=isThird=isNext=islast='none';         
    if(lstFull.size()<=stdPageSize){
    system.debug('Step1');
       isOne=isSecond=isThird='none';
    }
    else if(lstFull.size()<= 2*stdPageSize){
         system.debug('Step2');
       isOne=isSecond='block';
    }
    else{
         system.debug('Step3');
       isOne=isSecond=isThird='block';
    }
    
    if(currentPageNumber!=1){
         system.debug('Step4');
        isFirst=isPre='block';
    }
    if(currentPageNumber!=lastPageNumber){    
         system.debug('Step5');        
        isNext=islast='block';
    }                  
     
    //lstPage = new List<Content__c>();
    try{
        if(lstFull.size()>0){
            for(integer i=StartNumber-1;i<EndNumber;i++){            
                lstPage.Add(lstFull[i]);
            }
        }
    }
    catch(Exception ex){
    }
    
    system.debug('lstPage.size()'+lstPage.size());
    if(lstPage.size()==0){
        system.debug('Step6');
        paginglabel = System.Label.labelNoDocumentFound;     
        isFirst=isPre=isOne=isSecond=isThird=isNext=islast='none'; 
    }
    else{
    	paginglabel =String.valueOf(lstFull.size())+' '+System.Label.ContentPagingMssgPart1+' '+String.valueOf(EndNumber-StartNumber+1)+' '+System.Label.ContentPagingMssgPart2+'('+String.valueOf(StartNumber)+' '+System.Label.ContentPagingMssgPart3+' '+String.valueOf(EndNumber)+'). '+System.Label.ContentPagingMssgPart4+' '+String.valueOf(currentPageNumber)+'/'+String.valueOf(lastPageNumber);
        //paginglabel =String.valueOf(lstFull.size())+' documents found, displaying '+String.valueOf(EndNumber-StartNumber+1)+' document(s) from('+String.valueOf(StartNumber)+' to '+String.valueOf(EndNumber)+'). Page '+String.valueOf(currentPageNumber)+'/'+String.valueOf(lastPageNumber);    
    }
    
    //Add processes parameter to list
    lstParameter[0] = String.valueOf(stdPageSize);
    lstParameter[1] = paginglabel;
    lstParameter[2] = isFirst;
    lstParameter[3] = isPre;
    lstParameter[4] = isOne;
    lstParameter[5] = isSecond;
    lstParameter[6] = isThird;
    lstParameter[7] = isNext;
    lstParameter[8] = islast;
    lstParameter[9] = strClicked;
    lstParameter[10] = String.valueOf(currentPageNumber);
}
//Call when checked state of Include Archive is changed(To show and hide the archival data)
public void ShowHideArchiveData(){
    system.debug('@@enter');
    currentPageNumberKnowledge = 1;
    currentPageNumberProcess = 1;
    currentPageNumberMarketing = 1;
    currentPageNumberTechnical =1;
    strClickedKnowledge = '';
    strClickedProcess = '';
    strClickedMarketing = '';
    strClickedTechnical ='';
    
    //Get full list of Contents
    getAllContent();        
    //Fill Lists of All Tabs
    FillListForAllTabs(lstAllContents);        
}

}