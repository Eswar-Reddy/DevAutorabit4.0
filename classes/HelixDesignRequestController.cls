/*
* HelixDesignRequestController - controller for Helix Design Request process, Commercial Opportunities
* SFDC Release - https://sunpower.my.salesforce.com/5003400000sGxDa
*
* Pivotal Tracker Updates:
* ID #137737559 - HDR Revision Process
* 
* 
* 
*/
global with sharing class HelixDesignRequestController {
    

    /*Constants*/
    public final String helixRoof = 'Helix Roof';
    public final String moreInfo = 'More Information Needed';
    @TestVisible private final String errorString = ' is required. Please enter a value.';
    @TestVisible private final String notStartedStatus = 'Not Started';    
    @TestVisible private final String underReviewDealerStatus = 'Request Under Review';
    @TestVisible private final String inProgressStatus = 'In Progress';
    @TestVisible private final String designInProgressDealerStatus = 'Design In Progress';
    @TestVisible private final String requestInProgressDealerStatus = 'Request In Progress';
    @TestVisible private final String designDeliveredStatus = 'Design Delivered';
    @TestVisible private final String desingExportedStatus = 'Design Exported';
    @TestVisible private Id partnerUserId;
    @TestVisible private Boolean updateSiteFlag = false;
    @TestVisible private final String none = '--None--';

    /*Properties*/
    public List<String> errorMessages {
        get {
            if(errorMessages == null) 
                errorMessages = new List<String>();
            return errorMessages;
        }
        set;
    }
    public Boolean saveQuitErrors {get;set;}
    public Boolean page1Errors {get;set;}
    public Boolean lockInputs {get;set;}
    public Boolean isRevision {get;set;} //#137737559
    public Design__c revisedDesign {get;set;}
    public String siteId {get;set;}
    public String designId {get;set;}
    public String opptyId {get;set;}
    public String oppAccId {get; set;}
    public Site_Information_Form__c objSite {get; set;}
    public Design__c objDesign {get; set;}
    public User objUser {get; set;}
    public PageReference pageRef;
    public String dealerName {get;set;}
    public String contactPerson {get;set;}
    public String contactEmail {get;set;}
    public String contactPhone {get;set;}

    /*Variables*/
    public String testString {get;set;}
    public Integer submittedDesignCount {get;set;}
    public List<Design__c> revisableDesigns {get;set;}
    public List<Roof_Details__c> cloneRoofs {get;set;}
    public Id originalDesignId {get;set;}
    

    //Select Options//
    public List<SelectOption> gcrOptions {
        get {
            if(gcrOptions == null) {
                gcrOptions = new List<SelectOption>();
                gcrOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Design__c.GCR_Requirement__c.getDescribe().getPicklistValues()) {
                    gcrOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return gcrOptions;
        }
        set;
    }
    public List<SelectOption> roofTypeOptions {
        get {
            if(roofTypeOptions == null) {
                roofTypeOptions = new List<SelectOption>();
                roofTypeOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Roof_Details__c.Roof_Type__c.getDescribe().getPicklistValues()) {
                    roofTypeOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return roofTypeOptions;
        }
        set;
    }
    public List<SelectOption> roofMembraneOptions {
        get {
            if(roofMembraneOptions == null) {
                roofMembraneOptions = new List<SelectOption>();
                roofMembraneOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Roof_Details__c.Roof_Membrane__c.getDescribe().getPicklistValues()) {
                    roofMembraneOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return roofMembraneOptions;
        }
        set;
    }
    public List<SelectOption> airBarrierOptions {
        get {
            if(airBarrierOptions == null) {
                airBarrierOptions = new List<SelectOption>();
                airBarrierOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Roof_Details__c.Functional_Air_Barrier__c.getDescribe().getPicklistValues()) {
                    airBarrierOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return airBarrierOptions;
        }
        set;
    }
    public List<SelectOption> voltageOptions {
        get {
            if(voltageOptions == null) {
                voltageOptions = new List<SelectOption>();
                voltageOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Site_Information_Form__c.Nominal_AC_Voltage__c.getDescribe().getPicklistValues()) {
                    voltageOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return voltageOptions;
        }
        set;
    }
    public List<SelectOption> stateOptions {
        get {
            if(stateOptions == null) {
                stateOptions = new List<SelectOption>();
                stateOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : SalesConfiguration__c.State__c.getDescribe().getPicklistValues()) {
                    stateOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return stateOptions;
        }
        set;
    }
    

    /*
    * Constructor - standard controller (Opportunity based)
    *
    */
    public HelixDesignRequestController(ApexPages.StandardController controller) {
        siteId = ApexPages.currentPage().getParameters().get('siteId');

        if(String.isNotBlank(siteId) && siteId.contains('&')) {
            System.debug('bad url from communities');
            PageReference temp = new PageReference('/apex/HelixDesignRequest?' + siteId);
            siteId = siteId.subStringBefore('&');
            designId = temp.getParameters().get('designId');
            
        } else {
            designId = ApexPages.currentPage().getParameters().get('designId');
        }
        opptyId = ApexPages.currentPage().getParameters().get('opptyId');
        isRevision = false; 
        saveQuitErrors = false;
        submittedDesignCount = 0;

        if(ApexPages.currentPage().getParameters().get('revision') == 'Y') {
            isRevision = true;
        } else isRevision = false; 
        //Get Partner and Site details
        fetchInfo();
    }
    

    /* Initialization Methods:
    * fetchInfo() - get initial information about site/design
    * initializeDesign() - 
    * 
    * 
    */
    public void fetchInfo() {
 
        objSite = new Site_Information_Form__c();
        objDesign = new Design__c();
        lockInputs = false;
        revisableDesigns = new List<Design__c>(); 
        objUser = [SELECT Id, Contact.Email, Contact.MobilePhone, Contact.Name, ContactId, 
                          Contact.AccountId, Contact.Account.Name, Contact.Account.CRSM__c, Contact.Account.Commercial_PSR__c,IsPortalEnabled 
                    FROM User
                    WHERE Id=: UserInfo.getUserId()]; 
        dealerName =  objUser.Contact.Account.Name;
        contactPhone =  objUser.Contact.MobilePhone;
        contactEmail =  objUser.Contact.Email;
        contactPerson =  objUser.Contact.Name; 
        if(objUser.IsPortalEnabled){
            partnerUserId = objUser.Id; 
        }

        //FROM NEW SITE BUTTON
        if(String.isNotBlank(opptyId) && String.isBlank(siteId)) {
            //do show modal
        }
        else {

            if(siteId != '' && siteId != null && siteId != 'null'){         
                objSite = [ SELECT Id, Name, Site_Name__c, Site_Address__c, Account__c, Opportunity_del__r.Id, 
                                   Design_Consideration_Comments__c, Design_Wind_Speed_Mph__c,
                                   Nominal_AC_Voltage__c, Site_City__c, Site_State__c, Site_Zip_Postal_Code__c //KM_07142017: removed OwnerId with the field type change to master-detail                               
                            FROM Site_Information_Form__c
                            WHERE Id=: siteId OR Name=: siteId];      
                System.debug('**objSite==>'+objSite);   
                opptyId = objSite.Opportunity_del__r.Id;
                oppAccId = objSite.Account__c; //kcm

                submittedDesignCount = 0;
                try {
                    submittedDesignCount = [SELECT Count() FROM Design__c WHERE Site__c =: siteId AND Submitted__c = TRUE];
                }  catch(Exception e) { }
            }

            if(designId !='' && designId != null){
             
                objDesign = [SELECT Id, Name, Submitted__c, Expected_Installation_Date__c, Partner_Comments__c,Comments__c, Requested_System_Size__c, 
                                    Project_Contact_Person__c,TargetAnnualProduction__c, DealerRequestedSystemSizeAC__c, HelixDesignType__c, Email__c, 
                                    Technology_System__c, ModuleTypeandWattage__c, Design_Package_Type__c, MaxOuttheRoofSpace__c, PhoneMobile__c,
                                    DealerName__c, DealerName__r.Name, Project_Contact_Person__r.Name, SetbackDistanceServiceableVent__c, AccessPathwayHVAC__c,
                                    SetbackDistanceHVAC__c, SetbackDistanceSkylight__c, AccessPathwaySkylight__c, AccessPathwayServiceableVent__c,
                                    RerouteConduit__c, RemoveTrees__c, GCR_Requirement__c, Dealer_Status__c,Opportunity__r.RecordTypeId, OwnerId,
                                    Additional_37_Watt_Edge_lighting__c, Allowable_Passive_Pressure__c, Branding__c, Decking__c, Excessive_Undocumented_Fill__c,
                                    Flush_mounted_piers__c, Min_Clearance_Lower_Edge__c, No_Of_DAS_Monitor_Box__c, Separate_DC_switch_required__c, Shallow_Bedrock__c,
                                    Site_Located_in_a_Flood_Plain__c, Snow_Guard_required__c, Soil_Subject_to_Liquefaction__c, Topo_grade_change__c, Underground_Utility_Lines__c,
                                    Vertical_Downward_Load_Skin_Friction__c, Vertical_Uplift_Resistance_Skin_Friction__c, Topo_grade_change_specify__c, X7_5_Degree_Tilt__c,
                                    Ballast_Block_Weight__c, Design_Originated_By__c, Revision_Of__c, Submitted_Date__c, Design_Submitted_Date__c, Design_Tracking__c
                             FROM Design__c
                             WHERE Id=: designId];
                objDesign.Design_Originated_By__c='Request'; //KCM_02012017: Pivotal#138450201
                System.debug('**objDesign==>'+objDesign);   
                
                if(!isRevision) {
                    dealerName =  objDesign.DealerName__r.Name;
                    contactPhone =  objDesign.PhoneMobile__c;
                    contactEmail =  objDesign.Email__c;
                    contactPerson =  objDesign.Project_Contact_Person__r.Name;
                }

                if(objDesign.Submitted__c == true) 
                    lockInputs = true;
               
                if(objDesign.HelixDesignType__c == null){
                    objDesign.HelixDesignType__c = helixRoof;            
                }
            } else {
                if(opptyId != null) {
                    if (isRevision == false) {
                        Opportunity oppty = getOpportunity(opptyId);
                        objDesign.Expected_Installation_Date__c = oppty.Installation_Date__c;
                    }
                } 
                initializeDesign();
            }

            System.debug('IS REVISION: ' + isRevision);
            if(isRevision) {
                originalDesignId = objDesign.Id;
                revisedDesign = objDesign.clone(false, true, false, false);
                revisedDesign = setInitialDesignFields(revisedDesign);
                revisedDesign.Revision_Of__c = objDesign.Id;
                revisedDesign.Submitted__c = false;
                revisedDesign.Submitted_Date__c = null;
                revisedDesign.Design_Submitted_Date__c = null;
                revisedDesign.OwnerId = objUser.Id;

                objDesign = revisedDesign;
                designId = null;
                lockInputs = false;
                System.debug('FINAL REVISED DESIGN: ' + objDesign);
                revisableDesigns = new List<Design__c>([SELECT Id, Name, HelixDesignType__c, Design_Package_Type__c,
                                                                Actual_System_Size__c, Submitted__c, Design_Originated_By__c,
                                                                Site__r.Opportunity_del__r.Partner_Account_id__r.Name
                                                        FROM Design__c 
                                                        WHERE Site__c =: siteId 
                                                        AND Site__c != null
                                                        AND ((Dealer_Status__c =: desingExportedStatus AND Submitted__c = false)
                                                           OR (Dealer_Status__c =: designDeliveredStatus))
                                                        Order By Name DESC]);
            }
        }                                                   
    }

    public void initializeDesign(){     
        objDesign = setInitialDesignFields(objDesign);
    }

    public Design__c setInitialDesignFields(Design__c designParam) {
        //Site lookup
        if(objSite != null)
            designParam.Site__c = objSite.Id;
        //Opportunity Lookup
        if(opptyId != null) {
            designParam.Opportunity__c = opptyId; 
        } 
        designParam.RecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
        designParam.Design_request_reviewed_by__c = objUser.Id;   
        designParam.Status__c = requestInProgressDealerStatus;
        designParam.Dealer_Status__c = requestInProgressDealerStatus;
        designParam.Project_Contact_Person__c = objUser.ContactId;
        designParam.Email__c = objUser.Contact.Email;
        designParam.DealerName__c = objUser.Contact.AccountId;
        designParam.CRSM__c = objUser.Contact.Account.CRSM__c;
        designParam.CommercialPSR__c = objUser.Contact.Account.Commercial_PSR__c;
        designParam.Step_Number__c = 1; // set Page 1 :: HelixDesignPage  
        if(designParam.HelixDesignType__c == null ) { 
            designParam.HelixDesignType__c = helixRoof;
        }
        designParam.Design_Originated_By__c='Request'; //KCM_0201_2017: Pivotal#138450201
        designParam.Submitted__c = false;
        designParam.Submitted_Date__c = null;
        designParam.Design_Submitted_Date__c = null;
        return designParam;
    }

    /* Saves and Redirect Methods:
    * savePage1() - navigate from first to second page; upsert both site and design
    * submitDesign() - submit the design
    * toAttachemnts()
    * toDisclaimer()
    * toProductInfo()
    * 
    */

    public PageReference savePage1() {

        

        errorMessages = new List<String>();
        page1Errors = false;
        if(String.isBlank(designId))
            initializeDesign();

        //Page 1 validations
        if(String.isBlank(objSite.Nominal_AC_Voltage__c)) {
            errorMessages.add('Nominal AC Voltage' + errorString);
            page1Errors = true;
        }
        if(objDesign.Expected_Installation_Date__c == null) {
            errorMessages.add('Expected Installation Date' + errorString);
            page1Errors = true;
        }
        if(objDesign.Expected_Installation_Date__c != null && objDesign.Expected_Installation_Date__c < Date.today()) {
            errorMessages.add('Expected Installation Date must not be in the past');
            page1Errors = true;
        }
        if(String.isBlank(objSite.Site_Address__c)) {
            errorMessages.add('Street Address ' + errorString);
            page1Errors = true;
        }

        if(page1Errors) {
            return null;
        }
        else {
            objDesign.Step_Number__c = 2; // set Page 2 :: Product_Info
            page1Errors = upsertSiteANDDesign();
            if(page1Errors) {
                return null;
            }
            else {
                designId = objDesign.Id;
                if(isRevision && objDesign.HelixDesignType__c == helixRoof && objDesign.Design_Package_Type__c == 'Tier 2') {
                    Boolean doContinue = cloneRoofDetails(designId);
                }
                pageRef  = new PageReference('/apex/HelixDesignRequest_ProductInfo?siteId='+siteId+'&designId='+designId); 
                pageRef.setRedirect(true);
                return pageRef; 
            }
        }
        return null;
    }

    public Boolean cloneRoofDetails(Id revisedDesignId) {

        if(String.isBlank(revisedDesignId)) return null;

        cloneRoofs = new List<Roof_Details__c>();
        for(Roof_Details__c r : [SELECT Id, Design__c, RecordTypeId, Parapet_Wall_Height__c, Roof_Slope__c, Roof_Type__c, 
                                        Anchoring_Allowed__c, With_Roof_Load_Limit__c, Height__c, Roof_Construction__c,
                                        Roof_Load_Limit_Amount_psf__c, Roof_Membrane__c, Functional_Air_Barrier__c, Snow_Load__c, Roof_Id__c
                                        FROM Roof_Details__c WHERE Design__c =: originalDesignId AND isDeleted = false]) {
            Roof_Details__c temp = r.clone(false, true, false, false);
            temp.Design__c = revisedDesignId;
            temp.Name = String.valueOf(System.now());
            cloneRoofs.add(temp);
        }

        insert cloneRoofs;
        return true;
    }
 
    public PageReference submitDesign() {
        System.debug('SUBMITTING: ' + objDesign);

        objDesign.Submitted__c = true;
        if(objDesign.Submitted_Date__c == null) objDesign.Submitted_Date__c = System.Today();
        if(objDesign.Design_Submitted_Date__c == null) objDesign.Design_Submitted_Date__c = System.Now();
        if (objDesign.HelixDesignType__c == 'Helix Roof' || objDesign.HelixDesignType__c == 'Helix Carport') {
            if (objDesign.Design_Package_Type__c == 'Tier 1') {
                objDesign.Design_Tracking__c = System.Today().addDays(2);
            } else if (objDesign.Design_Package_Type__c == 'Tier 2') {
                objDesign.Design_Tracking__c = System.Today().addDays(4);
            }
        } else if (objDesign.HelixDesignType__c == 'Helix Tracker') {
            objDesign.Design_Tracking__c = System.Today().addDays(2);
        }
            
        objDesign.Step_Number__c = 1; // set Page 1 :: HelixDesignPage
        if(objDesign.Dealer_Status__c == requestInProgressDealerStatus || objDesign.Dealer_Status__c == moreInfo) {
            objDesign.Status__c = notStartedStatus;
            objDesign.Dealer_Status__c = underReviewDealerStatus;
            if(UserInfo.getUserId() == partnerUserId && UserInfo.getUserId() == objDesign.OwnerId){
                Group grp= [select Id,Name from Group where Type = 'Queue' and Name='CDE DR QUEUE'];
                if(grp != null && grp.Id != null){
                    objDesign.OwnerId = grp.Id; //queue id?
                    /* KCM_07142017: commented out with the change in Opportunity_del__c field type to Master-Detail
                    if(String.valueOf(objSite.OwnerId).startsWith('005') ){
                        objSite.OwnerId = grp.Id; //queue id?
                        updateSiteFlag = true;
                    }*/ 
                }
            }
        } else {
            objDesign.Status__c = inProgressStatus;
            objDesign.Dealer_Status__c = designInProgressDealerStatus;
        }       
        
        saveQuitErrors = upsertDesign(); 
        if(!errorMessages.isEmpty()) {
            saveQuitErrors = true;
            return null;
        }
        
        //kcm        
        return returnToOpp();
    }

    public PageReference returnToOpp() {
        //kcm
        if (SPCommunityUtility.isNewUIUser(UserInfo.getUserId())) { 
            pageRef = Page.SPCommunityCustomer;
            pageRef.setAnchor('/account/commercial/'+oppAccId+'/opportunity/'+opptyId+'/designs');
        }
        else{
            //usual page for all other partner users
            pageRef  = new PageReference('/'+opptyId);
        }
        
        return pageRef;
    }

    //kcm
    public String getredirectURL(){
        return returnToOpp().getURL();
    }

    public PageReference toHelixDesignRequest() {

        System.debug('toHelixDesignRequest: ' + objDesign); 
        saveQuitErrors = false;
        if(!lockInputs) {
            if(objDesign.Dealer_Status__c != moreInfo){
                objDesign.Step_Number__c = 1; // set Page 1 :: HelixDesignPage
            }
            saveQuitErrors = upsertDesign();

            //if(!errorMessages.isEmpty()) 
            if(saveQuitErrors == true) {
                return null;
            } 
        }   
            
        pageRef = new PageReference('/apex/HelixDesignRequest?siteId='+siteId+'&designId='+designId);
        pageRef.setRedirect(true);
        return pageRef;        
    }
    
    public PageReference toProductInfo() {

        System.debug('toProductInfo: ' + objDesign); 

        if(!lockInputs || objDesign.Dealer_Status__c == moreInfo) {
            if(objDesign.Dealer_Status__c != moreInfo){
                objDesign.Step_Number__c = 2; // set Page 2 :: Product_Info
            }
            saveQuitErrors = upsertDesign();            
            if(!errorMessages.isEmpty()) {
                saveQuitErrors = true;
                return null;
            }
        }

        pageRef = new PageReference('/apex/HelixDesignRequest_ProductInfo?siteId='+siteId+'&designId='+designId);
        pageRef.setRedirect(true);
        return pageRef;  
    }
    
    public PageReference toAttachments() {

        System.debug('toAttachments: ' + objDesign); 

        if(!lockInputs) {
            objDesign.Step_Number__c = 3; // set Page 3 :: Attachments
            saveQuitErrors = upsertDesign(); 
            if(!errorMessages.isEmpty()) {
                saveQuitErrors = true;
                return null;
            }
        }    
            
        pageRef = new PageReference('/apex/HelixDesignRequest_Attachments?siteId='+siteId+'&designId='+designId);
        pageRef.setRedirect(true);
        return pageRef;        
    }

    public PageReference toDisclaimer() {

        System.debug('toDisclaimer: ' + objDesign); 

        if(!lockInputs || objDesign.Dealer_Status__c == moreInfo) {
            if(objDesign.Dealer_Status__c != moreInfo){
                objDesign.Step_Number__c = 4; // set Page 4 :: Disclaimer
            }
            saveQuitErrors = upsertDesign(); 
            if(!errorMessages.isEmpty()) {
                saveQuitErrors = true;
                return null;
            }
        }
            
        pageRef = new PageReference('/apex/HelixDesignRequest_Disclaimer?siteId='+siteId+'&designId='+designId);
        pageRef.setRedirect(true);
        return pageRef; 
    }

    public String pageNo {get;set;}
    public PageReference navigate() {

        System.debug('pageNo: ' + pageNo);
        if(pageNo == '1') {
            return toHelixDesignRequest();
        } else if(pageNo == '2') {
            return toProductInfo();
        } else if(pageNo == '3') {
            return toAttachments();
        } else if(pageNo == '4') {
            return toDisclaimer();
        } else {
            return toHelixDesignRequest();
        }
    }
    
   /* DML Methods:
    * saveANDQuit() - save progress and navigate back to the opportunity page
    * upsertSiteANDDesign() - 
    * upsertDesign()
    * insertNewRoof(String roofJSON)
    * 
    * 
    */
    public PageReference saveANDQuit() {

        System.debug('Save AND QUIT: ' + objDesign);
        errorMessages = new List<String>();

        //TODO   
        //New Design creation
        if(designId == '' || designId == null){
            initializeDesign();                   
        } 

        saveQuitErrors = upsertSiteANDDesign();
        if(!errorMessages.isEmpty()) {
            saveQuitErrors = true;
            return null;
        }           
        
        //KCM: apply new redirection for new UI users; redirect other users to this page otherwise                
        return returnToOpp();
    }

    public Boolean upsertSiteANDDesign() {
        try{
            System.debug('*upsert*objSite==>'+objSite);         
            System.debug('*upsert*objDesign==>'+objDesign);
            upsert objSite;
            Database.UpsertResult sr = Database.upsert(objDesign);
            System.debug('SUCCESS: ' + sr.isSuccess());

            if(sr.isSuccess()) {
                designId = sr.getId();
                System.debug('designId: ' + designId);
            }
            else {
                for(Database.Error e : sr.getErrors()) {
                    errorMessages.add(e.getMessage());
                }
                return true;
            }
            return false;
        }catch(Exception e){
            System.debug('*upsert**Failed**==>'+e);
            errorMessages.add(e.getMessage()); //TODO: Replace with generic exception, log error 
        }
        return true;
    }

    public Boolean upsertDesign() {

        try {
            System.debug('*upsertDesign==>'+objDesign);
            
            upsert objDesign;
             System.debug('**after*upsertDesign==>'+objDesign);
            if(updateSiteFlag){ update objSite; }
            return false;
        } catch(Exception e) {
            System.debug('*upsert**Failed**==>'+e);
            errorMessages.add(e.getMessage()); //TODO: Replace with generic exception, log error
        }
        return true;
    }

    

    /*
    * PageRef methods to pass data
    *  setDesignType() - used on tab click to reset Module type dependent dropdown
    *  setSelectedModule - used to lock in selected Module type not easily accessible via JS/JQ
    * 
    * 
    */
    public PageReference setDesignType() {        
        objDesign.ModuleTypeandWattage__c = null;
        update objDesign;
        return null;
    }
    
    public PageReference setSelectedModule() {
        upsertDesign();
        return null;
    }

    /* Remote Action Methods
    * saveDesignRequest(String designJSON)
    *
    *
    */

    @RemoteAction
    public static ResultMessage saveDesignRequest(String designJSON, String isSubmit) {

        String helixRoof = 'Helix Roof';
        String helixTier2 = 'Tier 2';
        Boolean submitContext = true;

        ResultMessage result = new ResultMessage();
        result.success = false;
        result.payloadMap.put('record', '');
        result.payloadMap.put('errors', new List<String>());

        List<String> errors = new List<String>();

        try {

            submitContext = Boolean.valueOf(isSubmit);
            System.debug('designJSON: ' + designJSON);
            Design__c design = (Design__c)JSON.deserializeStrict(designJSON, Design__c.class);
 
            Design__c originalDesign = [SELECT Id, ModuleTypeandWattage__c,Site__c
                                        FROM Design__c
                                        WHERE Id=: design.Id];

            design.ModuleTypeandWattage__c = originalDesign.ModuleTypeandWattage__c;
            if(submitContext) {
                if(String.isNotBlank(design.GCR_Requirement__c) ){       
                    try {
                        design.GCR__c = Decimal.ValueOf(design.GCR_Requirement__c); //GCR Requirnment mapped with GCR
                    } catch(Exception e) { }
                } 

                //additional validations here...
                if(String.isBlank(design.ModuleTypeandWattage__c)) {
                    errors.add('Module Type is required. Please enter a value.');
                }

                //roof specific
                if(design.HelixDesignType__c == helixRoof && design.Design_Package_Type__c == helixTier2) {
                    Integer countOfRoofs = [SELECT Count() From Roof_Details__c WHERE Design__c =: design.Id AND isDeleted = false];
                    if(countOfRoofs == 0) {
                        errors.add('At least one roof must be added for a Tier 2 design.');
                    }
                }
                design.Step_Number__c = 3; // set Page 3 :: Attachments

            }

            result.success = true;
            if(errors.size() > 0) {
                result.payloadMap.put('StatusCode', 403);
                result.payloadMap.put('errors', errors); 
                return result;
            }
            else {
                upsert design;
                result.payloadMap.put('StatusCode', 200);
            }
        } catch(Exception e) {
            result.payloadMap.put('StatusCode', 400);
            errors.add(e.getMessage());
            result.payloadMap.put('errors', errors);
        }        
        
        return result;
    }

    /* Multiple Roof methods
    * deleteSelectedRoof(String roofId)
    * insertNewRoof(String roofJSON)
    * fetchRoofDetails(String designId)
    */
    @RemoteAction
    public static ResultMessage deleteSelectedRoof(String roofId) {

        System.debug('roofId: ' + roofId);
        ResultMessage result = new ResultMessage();
        result.success = false;
        
        try {
            delete [SELECT Id FROM Roof_Details__c WHERE Id =: roofId];
            result.success = true;
        } catch(Exception e) {
            result.payload.add(e.getMessage());
        }

        return result;
    }

    @RemoteAction
    public static ResultMessage insertNewRoof(String roofJSON) {

        System.debug('roofJSON: ' + roofJSON);

        ResultMessage result = new ResultMessage();
        result.success = false;
        List<String> errors = new List<String>(); 

        try {
            Roof_Details__c r = (Roof_Details__c)JSON.deserializeStrict(roofJSON, Roof_Details__c.class);
            System.debug('ROOF: ' + r);

            r.Name = String.valueOf(System.now());
            r.RecordTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Roof_Details__c.sObjectType).get('Commercial_Roof_Details');

            upsert r;

            Roof_Details__c finalRoof = [SELECT Id, Design__c, RecordTypeId, Parapet_Wall_Height__c, Roof_Slope__c, Roof_Type__c, 
                                        Anchoring_Allowed__c, With_Roof_Load_Limit__c, Height__c, Roof_Construction__c,
                                        Roof_Load_Limit_Amount_psf__c, Roof_Membrane__c, Functional_Air_Barrier__c, Snow_Load__c, Roof_Id__c
                                        FROM Roof_Details__c WHERE Id =: r.Id];
            result.success = true;
            result.payloadMap.put('newRoof', finalRoof); 
        } catch(Exception e) {
            result.payloadMap.put('errors', e.getMessage());
        }

        return result;
    }

    @RemoteAction
    public static ResultMessage fetchRoofDetails(String designId) {

        ResultMessage result = new ResultMessage();
        result.success = false;
        result.payloadMap.put('details', new List<Roof_Details__c>());

        try {
            result.payloadMap.put('details', [SELECT Id, Design__c, RecordTypeId, Parapet_Wall_Height__c, Roof_Slope__c, Roof_Type__c, 
                                        Anchoring_Allowed__c, With_Roof_Load_Limit__c, Height__c, Roof_Construction__c,
                                        Roof_Load_Limit_Amount_psf__c, Roof_Membrane__c, Functional_Air_Barrier__c, Snow_Load__c, Roof_Id__c
                                        FROM Roof_Details__c WHERE Design__c =: designId AND isDeleted = false]);
            result.success = true;
        } catch(Exception e) {
            result.payloadMap.put('errors', e.getMessage());
        }
        return result;
    }

    private static Opportunity getOpportunity(String opptyId) {
        Opportunity oppty = new Opportunity();
        if (String.IsNotBlank(opptyId)) {
            List <Opportunity> opptyList = [SELECT Id, Name, Installation_Date__c FROM Opportunity WHERE Id = :opptyId];
            if (opptyList.size() > 0) {
                oppty = opptyList[0];
            } 
        }
        return oppty;    
    }

}