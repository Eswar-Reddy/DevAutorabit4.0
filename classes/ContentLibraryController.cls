/************************************
**PR-01772
**By- Kapil Goutam
**On- May 21 2009
**Modified - Kapil Goutam
**Modified On- June 05 2009
**Description- Controller Class for ContentLibrary page

**************************************/
public class ContentLibraryController {
    public boolean isEUPartner{get;set;}
    /**********Prpoerties  **************/
    public List<RecordType> listRecordType{get;set;} 
    public String strAnnouncemnt = 'Announcement';
    public String strClips = 'Clips';
    public String strTraining = 'Training Schedule';
    public String strEvent = 'Event - Webinar';   
    public String strDocumentation = 'Documentation';
    //Properties to store the recordtype ID of each tab
    public String strAnnouncemntRecordTypeID {get;set;}
    public String strClipsRecordTypeID  {get;set;}
    public String strTrainingRecordTypeID  {get;set;}
    public String strEventRecordTypeID  {get;set;}
    //Properties to store prefix of Content
    public String strPrefixContent {get;set;}
    
    public String idToDelete{get;set;}
    public List<Document> lstDocuments {get;set;}
    public List<Content> lstDocByCategory {get;set;}
    public List<Content> lstMarketingDoc {get;set;}
    public List<Content> lstTechnicalDoc {get;set;}
    public List<SelectOption> lstCategory{get;set;} 
    public String selCategory{get;set;}  
    public String SearchString{get;set;}
    public String MarketingSearchString{get;set;}
    public String TechnicalSearchString{get;set;}
    public List<ProcessDocument> processDocs{get;set;}
    private boolean isIncludeArchive;
    private String selectedSubTab;
    public String MarketingfolderID{get;set;}
    public String TechnicalfolderID{get;set;}
    private Set<String> knowledgeBaseSubCategory{get; set;}
    private Set<String> ProcessDocSubCategory{get; set;}
    //----Paging Properties for knowledge base-----------
    private integer stdPageSize=15;
    public String paginglabel{get;set;}
    public String isFirst{get;set;}
    public String isPre{get;set;}
    public String isOne{get;set;}
    public String isSecond{get;set;}
    public String isThird{get;set;}
    public String isNext{get;set;}
    public String islast{get;set;}
    public String strClicked{get;set;}
    private integer currentPageNumber{get;set;}
    public List<Content> pageLstDocByCategory{get;set;}
    
    //----Paging Properties for Marketing bulletins-----------
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
    public List<Content> pageMarketingLst{get;set;}
    
    //----Paging Properties for Technical Notifications-----------
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
    public List<Content> pageTechnicalLst{get;set;}
    
    public String UserCountryDomain{get;set;}
  	public String UserPartnerType{get;set;}
    
    public Boolean getIsIncludeArchive(){
        setTestIsIncludeArchive();
        return isIncludeArchive;
    }     
    public void setIsIncludeArchive(Boolean isIncludeArchive){
       this.isIncludeArchive = isIncludeArchive;
    }     
    private String oneYearOldDate{get;set;}
    private String selectedTabForRedirection;    
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
            else if(recordType == strDocumentation){
                tab =  'Documentation';
            }
        }
        return tab;
        
    }
    public void setTestIsIncludeArchive(){
        isIncludeArchive = false;
    }
    public Content__c content{get;set;}
    private String selectedTab;    
    public String getSelectedTab(){
        selectedTab = ''; 
        if(Apexpages.currentPage().getParameters().get('retTab') != null){
            selectedTab = Apexpages.currentPage().getParameters().get('retTab');    
        }
      /**  if(Apexpages.currentPage().getParameters().get('retSubTab') != null){
            selectedSubTab = Apexpages.currentPage().getParameters().get('retSubTab');
        }**/
        return selectedTab;
    }
    public void setSelectedTab(String selectedTab){
        this.selectedTab = selectedTab;       
    }
    public String getSelectedSubTab(){
        //selectedSubTab = ''; 
        if(Apexpages.currentPage().getParameters().get('retSubTab') != null){
            selectedSubTab = Apexpages.currentPage().getParameters().get('retSubTab');
        }
        return selectedSubTab;
    }
    public void setSelectedSubTab(String selectedSubTab){
        this.selectedSubTab = selectedSubTab;       
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
        if(listAnnouncements == null)
            populateAnnouncement();
        return listAnnouncements;   
    }
    private List<Content> listClips; //for record type Clips
    public List<Content> getlistClips(){
        if(listClips == null)
            populateClips();
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
            if(prName == 'SunPower Super User'){
                return true; //to show/hide edit/add and delete button sunpower super user
            }
            if(prName == 'SunPower Partner Ambassador'){
                return true; //to show/hide edit/add and delete button SunPower Partner Ambassador
            }
            else if(prName == 'System Administrator'){
                return true; //to show/hide edit/add and delete button for administrator
            }
        }
        return false; 
        
    }
    /**********Prpoerties  End**************/
    
    //constructor
    public ContentLibraryController(ApexPages.StandardController controller) {
        content = (Content__c) controller.getRecord();
        setCountryDomain();
        checkEUPartner();  
        FillSubCategories();
        SearchString='';
        MarketingSearchString='';
        TechnicalSearchString='';
        currentPageNumber = 1;
        currentPageNumberMarketing = 1;
        currentPageNumberTechnical =1;
        
        FillOneYearOldDate(); 
        lstDocByCategory = new List<content>();
        lstDocuments = new List<Document>();                   
        String qry = 'Select id,name,folder.name,createdDate from Document where folder.type=\'Document\' and createdDate>'+oneYearOldDate+'T00:00:01Z '+' order by name ';            
        lstDocuments = database.query(qry);
        
        mapDocToContent(lstDocByCategory,lstDocuments);           
        FillCategories();  
        FillMarketingTechnicalDoc(); 
        FillProcessDocs();  
        
        //Get folderIDs
        MarketingfolderID='';
        TechnicalfolderID='';
        List<Folder> fldrs = [Select id,name from Folder where name='Marketing Bulletins' or name='Technical Notifications'];
        for(Folder f:fldrs){
            if(f.name=='Marketing Bulletins')
                MarketingfolderID=f.id;
            if(f.name=='Technical Notifications')
                TechnicalfolderID=f.id;
        }
        
        //Get the recordTypeID for each recordType and Prefix of Content
        AssignRecordTypes();
    }   
    //Check if current user is EU Partner
    public void checkEUPartner(){
        String userId= UserInfo.getUserID(); 
        isEUPartner = false;
        List<User> listUser = [Select u.Id, u.Profile.Name, u.Contact.AccountId from User u where u.Id= :userId ];
        if (listUser.size() > 0 ) {
            String profileName = listUser[0].Profile.Name;
            if (profileName != null && (profileName.StartsWith('EU Partner') || profileName.StartsWith('EU Residential'))  ) {
                isEUPartner = true;
            }
        }
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
    
    
    private void FillSubCategories(){        
        //Add Sub Categories of knowledge base
        knowledgeBaseSubCategory = new Set<String>();
        knowledgeBaseSubCategory.Add('Diagrams and CAD blocks');
        knowledgeBaseSubCategory.Add('FAQs');
        knowledgeBaseSubCategory.Add('Product Datasheets');
        knowledgeBaseSubCategory.Add('Product Manuals');
        knowledgeBaseSubCategory.Add('Product Warranties');
        knowledgeBaseSubCategory.Add('Training Manual');
        knowledgeBaseSubCategory.Add('Webinars');
        //Add Sub Categories of Process Document
        ProcessDocSubCategory = new Set<String>();
        ProcessDocSubCategory.Add('General');
        ProcessDocSubCategory.Add('Application Engineering');
        ProcessDocSubCategory.Add('Customer Care');
        ProcessDocSubCategory.Add('Finance');
        ProcessDocSubCategory.Add('Information System');
        ProcessDocSubCategory.Add('Marketing');
        ProcessDocSubCategory.Add('Operations');
        ProcessDocSubCategory.Add('Sales');
        ProcessDocSubCategory.Add('Training');
        ProcessDocSubCategory.Add('Business Development');
    }
    //Set Paging for the list under knowledge base tab
    public void SetPagingForKnowledgeBase(){     
        //Get last page number 
        integer lastPageNumber=lstDocByCategory.size()/stdPageSize; 
        Integer remainder = math.mod(lstDocByCategory.size(), stdPageSize); 
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
               
        Integer StartNumber =((currentPageNumber-1)*stdPageSize)+1;
        Integer EndNumber = ((currentPageNumber-1)*stdPageSize)+stdPageSize;        
        if(currentPageNumber == lastPageNumber){
            EndNumber = StartNumber-1+lstDocByCategory.size()-(stdPageSize*(currentPageNumber-1));
        }
                               
        isFirst=isPre=isOne=isSecond=isThird=isNext=islast='none';         
        if(lstDocByCategory.size()<=stdPageSize){
           isOne=isSecond=isThird='none';
        }
        else if(lstDocByCategory.size()<= 2*stdPageSize){
           isOne=isSecond='block';
        }
        else if(lstDocByCategory.size()<= 3*stdPageSize){
           isOne=isSecond=isThird='block';
        }
        
        if(currentPageNumber!=1){
            isFirst=isPre='block';
        }
        if(currentPageNumber!=lastPageNumber){            
            isNext=islast='block';
        }                  
         
        pageLstDocByCategory = new List<Content>();
        
        if(lstDocByCategory.size()>0){
            for(integer i=StartNumber-1;i<EndNumber;i++){
                pageLstDocByCategory.Add(lstDocByCategory[i]);
            }
        }
        
        if(pageLstDocByCategory.size()==0){
            paginglabel ='No document found.';
            isFirst=isPre=isOne=isSecond=isThird=isNext=islast='none'; 
        }
        else{
            paginglabel =String.valueOf(lstDocByCategory.size())+' documents found, displaying '+String.valueOf(EndNumber-StartNumber+1)+' document(s) from('+String.valueOf(StartNumber)+' to '+String.valueOf(EndNumber)+'). Page '+String.valueOf(currentPageNumber)+'/'+String.valueOf(lastPageNumber);    
        }
    }
    
    //Set Paging for the list under Marketing Bulletin tab
    public void SetPagingForMarketing(){     
        //Get last page number 
        integer lastPageNumber=lstMarketingDoc.size()/stdPageSizeMarketing; 
        Integer remainder = math.mod(lstMarketingDoc.size(), stdPageSizeMarketing); 
        if(remainder!=0){lastPageNumber= lastPageNumber+1;}
        
        //Set current page number according to clicked link on paging control
        if(strClickedMarketing!=null && strClickedMarketing!=''){
            if(strClickedMarketing=='First'){currentPageNumberMarketing = 1;}
            if(strClickedMarketing=='Pre'){currentPageNumberMarketing = currentPageNumberMarketing-1;}
            if(strClickedMarketing=='1'){currentPageNumberMarketing = 1;}
            if(strClickedMarketing=='2'){currentPageNumberMarketing = 2;}
            if(strClickedMarketing=='3'){currentPageNumberMarketing = 3;}
            if(strClickedMarketing=='Next'){currentPageNumberMarketing = currentPageNumberMarketing+1;}
            if(strClickedMarketing=='Last'){currentPageNumberMarketing = lastPageNumber;}
        }        
               
        Integer StartNumber =((currentPageNumberMarketing -1)*stdPageSizeMarketing)+1;
        Integer EndNumber = ((currentPageNumberMarketing -1)*stdPageSizeMarketing)+stdPageSizeMarketing;        
        if(currentPageNumberMarketing == lastPageNumber){
            EndNumber = StartNumber-1+lstMarketingDoc.size()-(stdPageSizeMarketing*(currentPageNumberMarketing-1));
        }
                               
        isFirstMarketing=isPreMarketing=isOneMarketing=isSecondMarketing=isThirdMarketing=isNextMarketing=islastMarketing='none';         
        if(lstMarketingDoc.size()<=stdPageSizeMarketing){
           isOneMarketing=isSecondMarketing=isThirdMarketing='none';
        }
        else if(lstMarketingDoc.size()<= 2*stdPageSizeMarketing){
           isOneMarketing=isSecondMarketing='block';
        }
        else if(lstMarketingDoc.size()<= 3*stdPageSizeMarketing){
           isOneMarketing=isSecondMarketing=isThirdMarketing='block';
        }
        
        if(currentPageNumberMarketing!=1){
            isFirstMarketing=isPreMarketing='block';
        }
        if(currentPageNumberMarketing!=lastPageNumber){            
            isNextMarketing=islastMarketing='block';
        }                  
         
        pageMarketingLst = new List<Content>();
        
        if(lstMarketingDoc.size()>0){
            for(integer i=StartNumber-1;i<EndNumber;i++){
                pageMarketingLst.Add(lstMarketingDoc[i]);
            }
        }
        
        if(pageMarketingLst.size()==0){
            paginglabelMarketing ='No document found.';
            isFirstMarketing=isPreMarketing=isOneMarketing=isSecondMarketing=isThirdMarketing=isNextMarketing=islastMarketing='none'; 
        }
        else{
            paginglabelMarketing =String.valueOf(lstMarketingDoc.size())+' documents found, displaying '+String.valueOf(EndNumber-StartNumber+1)+' document(s) from('+String.valueOf(StartNumber)+' to '+String.valueOf(EndNumber)+'). Page '+String.valueOf(currentPageNumberMarketing)+'/'+String.valueOf(lastPageNumber);    
        }
    }
    
    //Set Paging for the list under Technical Notifications tab
    public void SetPagingForTechnical(){ 
        system.debug('+++tech+++');    
        //Get last page number 
        integer lastPageNumber=lstTechnicalDoc.size()/stdPageSizeTechnical; 
        Integer remainder = math.mod(lstTechnicalDoc.size(), stdPageSizeTechnical); 
        if(remainder!=0){lastPageNumber= lastPageNumber+1;}
        
        //Set current page number according to clicked link on paging control
        if(strClickedTechnical!=null && strClickedTechnical!=''){
            if(strClickedTechnical=='First'){currentPageNumberTechnical = 1;}
            if(strClickedTechnical=='Pre'){currentPageNumberTechnical = currentPageNumberTechnical -1;}
            if(strClickedTechnical=='1'){currentPageNumberTechnical = 1;}
            if(strClickedTechnical=='2'){currentPageNumberTechnical = 2;}
            if(strClickedTechnical=='3'){currentPageNumberTechnical = 3;}
            if(strClickedTechnical=='Next'){currentPageNumberTechnical = currentPageNumberTechnical +1;}
            if(strClickedTechnical=='Last'){currentPageNumberTechnical = lastPageNumber;}
        }        
               
        Integer StartNumber =((currentPageNumberTechnical -1)*stdPageSizeTechnical)+1;
        Integer EndNumber = ((currentPageNumberTechnical -1)*stdPageSizeTechnical)+stdPageSizeTechnical;        
        if(currentPageNumberTechnical == lastPageNumber){
            EndNumber = StartNumber-1+lstTechnicalDoc.size()-(stdPageSizeTechnical*(currentPageNumberTechnical-1));
        }
                               
        isFirstTechnical=isPreTechnical=isOneTechnical=isSecondTechnical=isThirdTechnical=isNextTechnical=islastTechnical='none';         
        if(lstTechnicalDoc.size()<=stdPageSizeTechnical){
           isOneTechnical=isSecondTechnical=isThirdTechnical='none';
        }
        else if(lstTechnicalDoc.size()<= 2*stdPageSizeTechnical){
           isOneTechnical=isSecondTechnical='block';
        }
        else if(lstTechnicalDoc.size()<= 3*stdPageSizeTechnical){
           isOneTechnical=isSecondTechnical=isThirdTechnical='block';
        }
        
        if(currentPageNumberTechnical!=1){
            isFirstTechnical=isPreTechnical='block';
        }
        if(currentPageNumberTechnical!=lastPageNumber){            
            isNextTechnical=islastTechnical='block';
        }                  
         
        pageTechnicalLst = new List<Content>();
        
        if(lstTechnicalDoc.size()>0){
            for(integer i=StartNumber-1;i<EndNumber;i++){
                pageTechnicalLst.Add(lstTechnicalDoc[i]);
            }
        }
        
        if(pageTechnicalLst.size()==0){
            paginglabelTechnical ='No document found.';
            isFirstTechnical=isPreTechnical=isOneTechnical=isSecondTechnical=isThirdTechnical=isNextTechnical=islastTechnical='none'; 
        }
        else{
            paginglabelTechnical =String.valueOf(lstTechnicalDoc.size())+' documents found, displaying '+String.valueOf(EndNumber-StartNumber+1)+' document(s) from('+String.valueOf(StartNumber)+' to '+String.valueOf(EndNumber)+'). Page '+String.valueOf(currentPageNumberTechnical)+'/'+String.valueOf(lastPageNumber);    
        }
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
    
    //Call when checked state of Include Archive is changed
    public void ShowHideArchiveData(){
        currentPageNumber =1;
        strClicked='';
        lstMarketingDoc = new List<Content>();
        lstTechnicalDoc = new List<Content>();
        lstDocByCategory = new List<Content>();  
        system.debug('+++++++'+isIncludeArchive);      
        if(isIncludeArchive==false){
            String qry = 'Select id,name,folder.name,createdDate from Document where folder.type=\'Document\' and createdDate>'+oneYearOldDate+'T00:00:01Z '+' order by name ';            
            system.debug('+++++++'+qry);
            lstDocuments = database.query(qry);
        }
        else{
            lstDocuments = [Select id,name,folder.name,createdDate from Document where folder.type='Document' order by name];            
        }
        mapDocToContent(lstDocByCategory,lstDocuments);
        FillProcessDocs();
        FillMarketingTechnicalDoc();
    }
    
    private void populateCategoryDoc(List<Content> target,List<Content__c> source){        
        /*for(Content__c cont:source){
            Content c = new Content();
            c.id = cont.id;
            c.title = cont.Title__c;
            c.Category = cont.Category__c;
            c.PublishDate = c.getShortDate(cont.Publish_Date__c);
            target.Add(c);
        }
        //Set Paging for the list under knowledge base tab
        if(target==lstDocByCategory){
            SetPagingForKnowledgeBase();
        } */       
    }
    
    //Fill the data for Process Documents tab order by Categories
    private void FillProcessDocs(){
        system.debug('@@@lstDocuments'+lstDocuments);
        processDocs = new List<ProcessDocument>();
        Set<String> strCategory = new Set<String>();
        for(Document cont:lstDocuments){
            if(!ProcessDocSubCategory.contains(cont.folder.name)){
                continue;
            }
            if(strCategory.contains(cont.folder.name)){
                for(ProcessDocument pDoc:processDocs){ 
                    if(pDoc.Category == cont.folder.name){                   
                        pDoc.contentDoc.Add(cont);
                    }
                }
            }
            else{
                ProcessDocument doc = new ProcessDocument();
                doc.Category = cont.folder.name;
                doc.contentDoc.Add(cont);
                Content objCon = new Content();
                Date dt = date.newInstance(cont.createdDate.year(), cont.createdDate.month(), cont.createdDate.day());
                doc.strPublishDate = objCon.getShortDate(dt);
                processDocs.Add(doc);
                strCategory.Add(cont.folder.name);
            }
        }
    }
    
    //Fill the list for marketing bulletins and Technical Notifications tabs
    private void FillMarketingTechnicalDoc(){
        lstMarketingDoc = new List<Content>();
        lstTechnicalDoc = new List<Content>();
        String qry = 'Select id,name,folder.name,folder.id,createdDate from Document where (folder.name=\'Marketing Bulletins\' or folder.name=\'Technical Notifications\') and folder.type=\'Document\' ';        
        if(isIncludeArchive==false){
            qry = qry+' and createdDate>'+oneYearOldDate+'T00:00:01Z ';
        }
        qry = qry+' order by name ';
        List<Document> docs = database.query(qry);        
        for(Document doc:docs){
            Content c = new Content();
            c.id = doc.id;
            c.title = doc.name;
            c.Category = doc.folder.name;
            Date dt = date.newInstance(doc.createdDate.year(), doc.createdDate.month(), doc.createdDate.day());
            c.PublishDate = c.getShortDate(dt);  
            if(doc.folder.name=='Marketing Bulletins'){                             
                lstMarketingDoc.Add(c);
            }
            if(doc.folder.name=='Technical Notifications'){
                lstTechnicalDoc.Add(c);
            }
        }
        SetPagingForMarketing();
        SetPagingForTechnical();
    }
    
    //Fill picklist values from document type Content
    private void FillCategories(){
        /*lstCategory = new List<SelectOption>();
        lstCategory.add(new selectOption('All','All')); 
        Schema.DescribeFieldResult F = Content__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        for(Schema.PicklistEntry entry : P){
            if(knowledgeBaseSubCategory.contains(entry.getLabel())){
                lstCategory.add(new SelectOption(entry.getValue(),entry.getLabel()));
            }
        }
        selCategory = 'All';*/
        
        lstCategory = new List<SelectOption>();
        lstCategory.add(new selectOption('All','All')); 
        for(Folder fldr:[Select name,id from Folder where type='Document']){
            if(knowledgeBaseSubCategory.contains(fldr.name)){
                lstCategory.add(new SelectOption(fldr.name,fldr.name));
            }
        }
        selCategory = 'All';
    }
    
    //Call when search button on knowledge base is clicked
    public void FillDoclistBySearch(){
        currentPageNumber =1;  
        strClicked='';   
        lstDocByCategory = new List<Content>();
        String qry = 'Select id,name,folder.name,createdDate from Document where folder.type=\'Document\' and name like \'%'+SearchString.trim()+'%\' ';
        if(selCategory=='All' && SearchString.trim()==''){
            mapDocToContent(lstDocByCategory,lstDocuments);
            return;
        }
        if(selCategory!='All'){
            qry = qry+' and folder.name=\''+selCategory+'\' ';        
        }  
        if(isIncludeArchive==false){
            qry = qry+' and createdDate>'+oneYearOldDate+'T00:00:01Z ';
        }
       
        List<Document> lst = database.query(qry);
        mapDocToContent(lstDocByCategory,lst);            
    }
    
    //Call when search button on Marketing Bulletins is clicked
    public void FillMarketingDocBySearch(){ 
        currentPageNumberMarketing =1;
        strClickedMarketing='';
        lstMarketingDoc = new List<Content>();
        String searchFor = '%'+MarketingSearchString.trim()+'%';
        String qry = 'Select id,name,folder.name,createdDate from Document where folder.name=\'Marketing Bulletins\' and folder.type=\'Document\' and name like \''+searchFor+'\' ';
        if(isIncludeArchive==false){
            qry = qry+' and createdDate>'+oneYearOldDate+'T00:00:01Z ';
        }
        qry = qry+' order by name ';
        List<Document> lst = database.query(qry);
        mapDocToContent(lstMarketingDoc,lst); 
        SetPagingForMarketing();        
    }
    
    //Call when search button on Technical Notification is clicked
    public void FillTechnicalDocBySearch(){ 
        currentPageNumberTechnical =1;
        strClickedTechnical='';
        lstTechnicalDoc = new List<Content>();
        String searchFor = '%'+TechnicalSearchString.trim()+'%';        
        String qry = 'Select id,name,folder.name,createdDate from Document where folder.name=\'Technical Notifications\' and folder.type=\'Document\' and name like \''+searchFor+'\' ';
        if(isIncludeArchive==false){
            qry = qry+' and createdDate>'+oneYearOldDate+'T00:00:01Z ';
        }
        qry = qry+' order by name ';
        List<Document> lst = database.query(qry);        
        mapDocToContent(lstTechnicalDoc,lst); 
        SetPagingForTechnical();  
    }
    
    //Map Documens to Content
    private void mapDocToContent(List<Content> target,List<Document> docs){
        for(Document doc:docs){
            if(target==lstDocByCategory && !knowledgeBaseSubCategory.contains(doc.folder.name)){
                continue;
            }
            Content c = new Content();
            c.id = doc.id;
            c.title = doc.name;
            c.Category = doc.folder.name;
            Date dt = date.newInstance(doc.createdDate.year(), doc.createdDate.month(), doc.createdDate.day());
            c.PublishDate = c.getShortDate(dt);  
            target.Add(c);
        }
        //Set Paging for the list under knowledge base tab
        if(target==lstDocByCategory){
            SetPagingForKnowledgeBase();
        }
    }
    
    //List all documnets on Knowledge Base button click
    public void FillKnowledgeBaseDoclist(){
        currentPageNumber =1;
        strClicked='';
        lstDocByCategory = new List<Content>();
        mapDocToContent(lstDocByCategory,lstDocuments);        
    }
    //List 10 documnets on Recently Added button click
    public void FillRecentDoclist(){
        currentPageNumber =1;
        strClicked='';
        lstDocByCategory = new List<Content>();
        String qry = 'Select id,name,folder.name,createdDate from Document where folder.type=\'Document\' ';                
        if(isIncludeArchive==false){
            qry = qry+' and createdDate>'+oneYearOldDate+'T00:00:01Z ';
        }        
        qry = qry+' order by CreatedDate desc limit 10 ';
        List<Document> lst=database.query(qry);
        mapDocToContent(lstDocByCategory,lst); 
    }
    
    //List 10 documnets on Popular Documents button click 
    public void FillPopularDoclist(){
        /*currentPageNumber =1;
        strClicked='';
        lstDocByCategory = new List<Content>();
        List<Content__c> lst = new List<Content__c>();
        String qry = 'select id,Content__c,Content__r.Title__c,Content__r.Category__c,Content__r.Publish_Date__c from Content_tracker__c where Content__r.recordtype.name=\'Documentation\' ';
        if(isIncludeArchive==false){
            qry = qry+' and Content__r.Publish_Date__c>'+oneYearOldDate+' ';
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
                lst.Add(maxCon);
                index++;
            }
            if(finalID!=null && ImagecontentAccessCount.containskey(finalID)){
                ImagecontentAccessCount.remove(finalID);                
            }
            if(index==10){
                break;
            }            
        }
        
        populateCategoryDoc(lstDocByCategory,lst); */
    }
    
     public void setCountryDomain(){
    	List<User> lstUser = new List<User>([Select Id,Country_Domain__c,contactID, contact.Account.Type from User where Id =: userInfo.getUserId()]);
	    if(lstUser.Size()>0 && lstUser.get(0).Country_Domain__c != null ){ 
	        UserCountryDomain = lstUser.get(0).Country_Domain__c;
	        if(lstUser.get(0).contactID != null)
	            UserPartnerType = lstUser.get(0).contact.Account.Type;
	    }   
	 }
    //method to load all events
    public void populateEvents(){
        
        listEvent = new List<Content>(); 
        Content cObj;
        List<Content__c>  listEventTemp = 
            new List<Content__c>([Select Id, Content_Location__c, Title__c, Target_Audience__c, Event_Date__c,Is_Content_New__c ,Country_Domain__c,Partner_Type__c
                From Content__c 
                where RecordType.Name =:strEvent order By Event_Date__c ASC]);        
        if(listEventTemp.Size()>0){
            for(Content__c c:listEventTemp){
            	 /*Country_Domain__c check here starts */
			         if(c.Country_Domain__c != null && UserCountryDomain != null){
			              if(!(c.Country_Domain__c.indexOf(UserCountryDomain) >=0))
			               continue;    
			          }
			       /*Country_Domain__c check here ends */
			       /*Partner Type check here starts */
			         if(c.Partner_Type__c != null && UserPartnerType != null){
			              if(!(c.Partner_Type__c.indexOf(UserPartnerType) >=0))
			               continue;    
			          }
			       /*Partner Type check here ends */
            	
                cObj = new Content();
                cObj.Id = c.Id;
                cObj.detailPageLink = '/apex/ContentDetailPage?cId='+ cObj.Id;
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
        List<Content__c> listTainingTemp = new List<Content__c>([Select Id, Location__c, Event_Start_Date__c, Event_End_Date__c, Description__c,Is_Content_New__c ,Country_Domain__c,Partner_Type__c
            From Content__c 
            where RecordType.Name =:strTraining order By Event_Start_Date__c ASC]);
        if(listTainingTemp.Size()>0){
            for(Content__c c:listTainingTemp){
            	/*Country_Domain__c check here starts */
		         if(c.Country_Domain__c != null && UserCountryDomain != null){
		              if(!(c.Country_Domain__c.indexOf(UserCountryDomain) >=0))
		               continue;    
		          }
		       /*Country_Domain__c check here ends */
		       /*Partner Type check here starts */
		         if(c.Partner_Type__c != null && UserPartnerType != null){
		              if(!(c.Partner_Type__c.indexOf(UserPartnerType) >=0))
		               continue;    
		          }
		       /*Partner Type check here ends */
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
        List<Content__c> listAnnouncementsTemp = 
            new List<Content__c>([Select Id, URL_Link_Text__c, Title__c, Event_Start_Date__c, Description__c, Content_Location__c,Publish_Date__c, Is_Content_New__c,Country_Domain__c,Partner_Type__c From Content__c where RecordType.Name =:strAnnouncemnt order by Publish_Date__c ASC]);
        if(listAnnouncementsTemp.Size()>0){
            for(Content__c c:listAnnouncementsTemp){
            	 /*Country_Domain__c check here starts */
		         if(c.Country_Domain__c != null && UserCountryDomain != null){
		              if(!(c.Country_Domain__c.indexOf(UserCountryDomain) >=0))
		               continue;    
		          }
		       /*Country_Domain__c check here ends */
		        /*Partner Type check here starts */
		         if(c.Partner_Type__c != null && UserPartnerType != null){
		              if(!(c.Partner_Type__c.indexOf(UserPartnerType) >=0))
		               continue;    
		          }
		       /*Partner Type check here ends */
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
        List<Content__c> listClipsTemp = new List<Content__c>([Select Id, URL_Link_Text__c, Title__c, Event_Start_Date__c, Description__c, Content_Location__c,Publish_Date__c, Is_Content_New__c,Country_Domain__c,Partner_Type__c From Content__c where RecordType.Name =:strClips order by Publish_Date__c ASC]);
        if(listClipsTemp.Size()>0){
            for(Content__c c:listClipsTemp){
            	  /*Country_Domain__c check here starts */
		         if(c.Country_Domain__c != null && UserCountryDomain != null){
		              if(!(c.Country_Domain__c.indexOf(UserCountryDomain) >=0))
		               continue;    
		          }
		       /*Country_Domain__c check here ends */
		       /*Partner Type check here starts */
		         if(c.Partner_Type__c != null && UserPartnerType != null){
		              if(!(c.Partner_Type__c.indexOf(UserPartnerType) >=0))
		               continue;    
		          }
		       /*Partner Type check here ends */
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
    //class to show a Content object on all tabs in differenet types
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
        
        //for Documents
        public String Category{get;set;}
        public String PublishDate{get;set;}
        
       //date time related method 
        public String getShortDate(Date dt) {
          String stringDate = ''; 
          if(dt != null) {
              stringDate = getMonthName(dt.Month()) + ' '+ dt.Day() + ', ' + dt.Year(); 
          }
          return stringDate;
       }
       //date time related method
       public String getMonthName(integer month){
            String monthName = '';
            if(month == 1){
                monthName = 'Jan';
            }
            else if(month == 2){
                monthName = 'Feb';
            }
            else if(month == 3){
                monthName = 'Mar';
            }
            else if(month == 4){
                monthName = 'Apr';
            }
            else if(month == 5){
                monthName = 'May';
            }
            else if(month == 6){
                monthName = 'Jun';
            }
            else if(month == 7){
                monthName = 'Jul';
            }
            else if(month == 8){
                monthName = 'Aug';
            }
            else if(month == 9){
                monthName = 'Sep';
            }
            else if(month == 10){
                monthName = 'Oct';
            }
            else if(month == 11){
                monthName = 'Nov';
            }
            else if(month == 12){
                monthName = 'Dec';
            }
            return monthName;
       }
    }
    //to remove selected item
    public PageReference remove() {
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
       catch(Exception ex) {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
          ApexPages.addMessage(msg);
       }  
       return null;
    }
    
    //Sub Class for Process Documentation tab
    public class ProcessDocument{
        public String Category{get;set;}
        public String strPublishDate{get;set;}
        public List<Document> contentDoc{get;set;}
        //Constructor
        public ProcessDocument(){
            Category='';
            strPublishDate='';
            contentDoc = new List<Document>();
        }
    }
}