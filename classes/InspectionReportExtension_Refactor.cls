// *********************************************************************
// Name : InspectionReportExtension 
// Created On : 08th April,2009
// Created By : Appirio (Kirtesh)
// Implementation: Controller class for InspectionReport and 
//                 InspectionReport_Commercial Page.
// Last Modified- Kapil Goutam
// Last Mod. On- July 17 2009
// ***** *****************************************************************
  
public class InspectionReportExtension_Refactor {
  //properties  
  public Inspection__c inspection{get;set;}  
  public string oldInspector{get ;set ;}
  private case cCase ; 
  public string selectedSiteType{get;set;}
  public boolean showSiteTypeblock{get;set;}
  public boolean showInspectionTypeblock{get;set;}
  public boolean showCommercialReportBlock{get;set;}
  public boolean showResidentialReportBlock{get;set;}
  private boolean isNewCase;
  public Boolean isEdit{get;set;}  
  public string selectedInspectionType{get ;set ;}  
  public String siteName {get; set;}
  public String inspectorName {get; set;}
  public String jobSupervisorName {get; set;}
  public string selectedSiteId{get ;set ;}
  public string site_CityStateZip{get;set;}  
  public string site_Email{get;set;}
  public string site_Phone{get;set;}
  public string site_ContactLastName{get;set;}
  public string site_ContactFirstName{get;set;}  
  public string site_ContactID{get ;set ;}
  public string site_ContactName{get;set;}
  public string selectedInspectorId{get ;set ;}
  public string inspector_Company{get ;set ;}
  public string inspector_Email{get ;set ;}
  public string inspector_Phone{get ;set ;}
  public string selectedJobSupervisorId{get ;set ;}
  public string JobSupervisor_Company{get ;set ;} 
  public string JobSupervisor_Email {get ;set ;}
  public string JobSupervisor_Phone {get ;set ;}
  public string JobSupervisor_CityStateZip {get ;set ;}
  public String caseId {get; set;}
  public String InspectionDealerTier{get; set;}
  public String inspectionId{get;set;}
   
  ApexPages.StandardController stdController;
  
  public List<SelectOption> getSiteType() {
    List<SelectOption> listOption =  new List<SelectOption>();
    SelectOption option0 = new SelectOption('--None--', '--None--');
    SelectOption option1 = new SelectOption('Residential', 'Residential');
    SelectOption option2 = new SelectOption('Commercial', 'Commercial') ;
    listOption.add(option0);
    listOption.add(option1);
    listOption.add(option2);
    return listOption;
  }
  
  public List<SelectOption> getResponseOptionType() {
    List<SelectOption> listOption =  new List<SelectOption>();
    SelectOption option0 = new SelectOption('Yes', 'Yes');
    SelectOption option1 = new SelectOption('No', 'No');
    SelectOption option2 = new SelectOption('NA', 'NA') ;
    listOption.add(option1);
    listOption.add(option0);
    listOption.add(option2);
    return listOption;
  }
 
  //constructor
  public InspectionReportExtension_Refactor(ApexPages.StandardController stdController) {
    this.stdController = stdController;    
    
    
    if(ApexPages.currentPage().getParameters().get('id')!=null){
            inspectionId = ApexPages.currentPage().getParameters().get('id') ;          
            List<Inspection__c> lstInspection = new List<Inspection__c>([Select SystemModstamp, Status__c, Site_Type__c, Score__c, Score_Details__c, Residential_SYSTEM_SAFETY_Hazards__c, Residential_SYSTEM_SAFETY_Comments__c, Residential_SYSTEM_SAFETY_ChkBox__c, Residential_Result__c, Residential_ReadingsMeasurements_Comment__c, Residential_Q54_Response__c, Residential_Q54_Comments__c, Residential_Q53_Response__c, Residential_Q53_Comments__c, Residential_Q52_Response__c, Residential_Q52_Comments__c, Residential_Q51_Rating__c, Residential_Q50_Rating__c, Residential_Q49_Rating__c, Residential_Q48_Response__c, Residential_Q48_Comments__c, Residential_Q48_3__c, Residential_Q48_2__c, Residential_Q48_1__c, Residential_Q47_Response__c, Residential_Q47_Comments__c, Residential_Q46_Response__c, Residential_Q46_Comments__c, Residential_Q45_Response__c, Residential_Q45_Comments__c, Residential_Q44_Size__c, Residential_Q44_Quantity__c, Residential_Q44_Distance__c, Residential_Q44_Comments__c, Residential_Q43_Response__c, Residential_Q43_Comments__c, Residential_Q43_3__c, Residential_Q43_2__c, Residential_Q43_1__c, Residential_Q42_Response__c, Residential_Q42_Comments__c, Residential_Q41_Response__c, Residential_Q41_Comments__c, Residential_Q40_Response__c, Residential_Q40_Comments__c, Residential_Q39_Response__c, Residential_Q39_Picklist__c, Residential_Q39_Comments__c, Residential_Q38_Response__c, Residential_Q38_Comments__c, Residential_Q37_Response__c, Residential_Q37_Comments__c, Residential_Q36_Response__c, Residential_Q36_Comments__c, Residential_Q35_Size__c, Residential_Q35_Quantity__c, Residential_Q35_Distance__c, Residential_Q35_Comments__c, Residential_Q34_Response__c, Residential_Q34_Comments__c, Residential_Q33_Response__c, Residential_Q33_Comments__c, Residential_Q32_Response__c, Residential_Q32_Comments__c, Residential_Q31_Response__c, Residential_Q31_EGC_Size__c, Residential_Q31_Comments__c, Residential_Q30_Array_Input_4__c, Residential_Q30_Array_Input_3__c, Residential_Q30_Array_Input_2__c, Residential_Q30_Array_Input_1__c, Residential_Q30_4_2__c, Residential_Q30_4_1__c, Residential_Q30_3_2__c, Residential_Q30_3_1__c, Residential_Q30_2_2__c, Residential_Q30_2_1__c, Residential_Q30_1_2__c, Residential_Q30_1_1__c, Residential_Q29_4__c, Residential_Q29_3__c, Residential_Q29_2__c, Residential_Q29_1__c, Residential_Q28_4__c, Residential_Q28_4_ChkBox__c, Residential_Q28_3__c, Residential_Q28_3_ChkBox__c, Residential_Q28_2__c, Residential_Q28_2_ChkBox__c, Residential_Q28_1__c, Residential_Q28_1_ChkBox__c, Residential_Q27_4__c, Residential_Q27_3__c, Residential_Q27_2__c, Residential_Q27_1__c, Residential_Q26_4__c, Residential_Q26_3__c, Residential_Q26_2__c, Residential_Q26_1__c, Residential_Q25_4__c, Residential_Q25_3__c, Residential_Q25_2__c, Residential_Q25_1__c, Residential_Q24_4__c, Residential_Q24_3__c, Residential_Q24_2__c, Residential_Q24_1__c, Residential_Q23_Comments__c, Residential_Q23_4__c, Residential_Q23_3__c, Residential_Q23_2__c, Residential_Q23_1__c, Residential_Q22_4__c, Residential_Q22_3__c, Residential_Q22_2__c, Residential_Q22_1__c, Residential_Q21_Sky_Conditions__c, Residential_Q20_Time__c, Residential_Q20_Time_Picklist__c, Residential_Q19_Response__c, Residential_Q19_Comments__c, Residential_Q18_Response__c, Residential_Q18_Comments__c, Residential_Q17_Response__c, Residential_Q17_Comments__c, Residential_Q16_Response__c, Residential_Q16_Comments__c, Residential_Q15_Picklist__c, Residential_Q15_Comments__c, Residential_Q14_Picklist__c, Residential_Q13_Picklist__c, Residential_Q12_Picklist__c, Residential_Q12_Comments__c, Residential_Q11_Picklist__c, Residential_Q11_Comments__c, Residential_Q10_Response__c, Residential_Q10_Comments__c, Residential_Q09_Response__c, Residential_Q09_Picklist__c, Residential_Q09_Comments__c, Residential_Q08_Response__c, Residential_Q08_Comments__c, Residential_Q07_Response__c, Residential_Q07_Comments__c, Residential_Q06_Response__c, Residential_Q06_Comments__c, Residential_Q05_Response__c, Residential_Q05_Comments__c, Residential_Q04_D__c, Residential_Q04_Comments__c, Residential_Q04_C__c, Residential_Q04_B__c, Residential_Q04_A__c, Residential_Q03_D__c, Residential_Q03_C__c, Residential_Q03_B__c, Residential_Q03_A__c, Residential_Q02_Text2__c, Residential_Q02_Text2_ChkBox__c, Residential_Q02_Text1__c, Residential_Q02_Text1_ChkBox__c, Residential_Q02_System_Size__c, Residential_Q02_Comments__c, Residential_Q02_Array_Power__c, Residential_Q01_SPR2__c, Residential_Q01_SPR2_ChkBox__c, Residential_Q01_SPR1__c, Residential_Q01_SPR1_ChkBox__c, Residential_MSP_NEC_Labels__c, Residential_MSP_Interior__c, Residential_MSP_Exterior__c, Residential_MOUNTING_Roof_Penetrations__c, Residential_MOUNTING_Problem_Areas__c, Residential_MOUNTING_L_Brackets__c, Residential_INVERTER_TO_MSP_Problem_Area__c, Residential_INVERTER_TO_MSP_Conduit__c, Residential_INVERTER_Overview__c, Residential_INVERTER_Interior_Grounding__c, Residential_INVERTER_Interior_AC_DC__c, Residential_INVERTER_DC_System__c, Residential_DC_DISCONNECT_Problem_Areas__c, Residential_DC_DISCONNECT_NEC_Labels__c, Residential_DC_DISCONNECT_Interior__c, Residential_DC_DISCONNECT_Exterior__c, Residential_Commission_Date__c, Residential_Auto_Calculations_4_4__c, Residential_Auto_Calculations_4_3__c, Residential_Auto_Calculations_4_2__c, Residential_Auto_Calculations_4_1__c, Residential_Auto_Calculations_3_4__c, Residential_Auto_Calculations_3_3__c, Residential_Auto_Calculations_3_2__c, Residential_Auto_Calculations_3_1__c, Residential_Auto_Calculations_2_4__c, Residential_Auto_Calculations_2_3__c, Residential_Auto_Calculations_2_2__c, Residential_Auto_Calculations_2_1__c, Residential_Auto_Calculations_1_4__c, Residential_Auto_Calculations_1_3__c, Residential_Auto_Calculations_1_2__c, Residential_Auto_Calculations_1_1__c, Residential_ARRAY_Rooftop__c, Residential_ARRAY_Profile__c, Residential_ARRAY_Problem_Areas__c, Residential_ARRAY_Pathfinder__c, Residential_ARRAY_Overall__c, Residential_ARRAY_J_Box__c, Residential_ARRAY_INVERTER_Problem_Areas__c, Residential_ARRAY_INVERTER_PV_Source__c, Residential_ARRAY_INVERTER_DC_Conduit__c, Residential_ARRAY_Grounding__c, Residential_ADDITIONAL_COMMENTS__c, Residential_AC_DISCONNECT_Problem_Areas__c, Residential_AC_DISCONNECT_NEC_Labels__c, Residential_AC_DISCONNECT_Interior__c, Residential_AC_DISCONNECT_Exterior__c, Partner_Contact__c, OwnerId, Name, Last_Modified_Date__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Integration_ID__c, Inspection_Type__c, Inspection_Time__c, Inspection_Status__c, Inspection_Date__c, Id, Customer_Communication__c, CurrencyIsoCode, CreatedDate, CreatedById, Contact__c, Compliance_Result__c, Comm_Q9_3_Field__c, Comm_Q9_2_Field__c, Comm_Q9_1_Field__c, Comm_Q8_8_Field__c, Comm_Q8_7_Field__c, Comm_Q8_5_Field__c, Comm_Q8_4_Field__c, Comm_Q8_3_Field__c, Comm_Q8_2_Field__c, Comm_Q8_1_Field__c, Comm_Q7_13_Field__c, Comm_Q7_12_Field__c, Comm_Q7_11_Field__c, Comm_Q7_10_Field__c, Comm_Q7_09_Field__c, Comm_Q7_08_Field__c, Comm_Q7_07_Field__c, Comm_Q7_06_Field__c, Comm_Q7_05_Field__c, Comm_Q7_04_Field__c, Comm_Q7_03_Field__c, Comm_Q7_02_Field__c, Comm_Q7_01b_Field__c, Comm_Q7_01a_Field__c, Comm_Q6_12_Field__c, Comm_Q6_11_Field__c, Comm_Q6_10_Field__c, Comm_Q6_09_Field__c, Comm_Q6_08_Field__c, Comm_Q6_07_Field__c, Comm_Q6_06_Field__c, Comm_Q6_05_Field__c, Comm_Q6_04_Field__c, Comm_Q6_03_Field__c, Comm_Q6_02_Field__c, Comm_Q6_01_Field__c, Comm_Q6_00_Field__c, Comm_Q5_19_Field__c, Comm_Q5_18_Field__c, Comm_Q5_17_Field__c, Comm_Q5_16_Field__c, Comm_Q5_15_Field__c, Comm_Q5_14_Field__c, Comm_Q5_13_Field__c, Comm_Q5_12_Field__c, Comm_Q5_11_Field__c, Comm_Q5_10_Field__c, Comm_Q5_09_Field__c, Comm_Q5_08_Field__c, Comm_Q5_07_Field__c, Comm_Q5_06_Field__c, Comm_Q5_05_Field__c, Comm_Q5_04_Field__c, Comm_Q5_03_Field__c, Comm_Q5_02_Field__c, Comm_Q5_01_Field__c, Comm_Q4_5_Field__c, Comm_Q4_4_Field__c, Comm_Q4_3_Field__c, Comm_Q4_2_Field__c, Comm_Q4_1_Field__c, Comm_Q4_0_Field__c, Comm_Q3_16_Field__c, Comm_Q3_13_Field__c, Comm_Q3_12_Field__c, Comm_Q3_11_Field__c, Comm_Q3_10_Field__c, Comm_Q3_09_Field__c, Comm_Q3_08_Field__c, Comm_Q3_07_Field__c, Comm_Q3_06_Field__c, Comm_Q3_05_Field__c, Comm_Q3_04_Field__c, Comm_Q3_03_Field__c, Comm_Q3_02_Field__c, Comm_Q3_01_Field__c, Comm_Q2_10_Field__c, Comm_Q2_09_Field__c, Comm_Q2_07_Field__c, Comm_Q2_06b_Field__c, Comm_Q2_06a_Field__c, Comm_Q2_06_Field__c, Comm_Q2_05_Field__c, Comm_Q2_04_4_2__c, Comm_Q2_04_4_1__c, Comm_Q2_04_3_2__c, Comm_Q2_04_3_1__c, Comm_Q2_04_2_2__c, Comm_Q2_04_2_1__c, Comm_Q2_04_1__c, Comm_Q2_03_Field__c, Comm_Q2_02_Field__c, Comm_Q2_01_Field__c, Comm_Q1_9_Field__c, Comm_Q1_8_Field__c, Comm_Q1_7_Field__c, Comm_Q1_6_Field__c, Comm_Q1_5e_Field__c, Comm_Q1_5d_Field__c, Comm_Q1_5c_Field__c, Comm_Q1_5b_Field__c, Comm_Q1_5a_Field__c, Comm_Q1_5_Field__c, Comm_Q1_4_Field__c, Comm_Q1_3_Field__c, Comm_Q1_2_Number2__c, Comm_Q1_2_Number1__c, Comm_Project__c, Comm_ProjectSize__c, Comm_OtherPresent__c, Comm_BuildingOccupancy__c, Comm_As_Builts__c, Case__c From Inspection__c where Id=:inspectionId]);
            if(lstInspection.size()>0){
                this.inspection = lstInspection.get(0);             
                oldInspector = inspection.Contact__c;
            }else{
                this.inspection = new Inspection__c();  
            }           
            
    }else{
        
            this.inspection = new Inspection__c();  
    }
    
    
    
    
    if(this.inspection.Id == null ){ // New Case
      if(ApexPages.currentPage().getParameters().get('caseid')!=null){
        caseId = ApexPages.currentPage().getParameters().get('caseid') ;
        cCase = [select id, RecordTypeId, job_supervisor_Email__c from Case where id =:caseId];
      } 
      showInspectionTypeblock = false;
      selectedinspectionType = 'onsite support inspection';
      showSiteTypeblock = true;      
      if(cCase==null){
          isNewCase = true;
      }else{ 
          isNewCase = false;
      }      
      onLoad();
                
    }else{ // Edit Case
      cCase = [select id, RecordTypeId, job_supervisor_Email__c from Case where id =:this.inspection.Case__c];
      caseId = cCase.Id ;
        
      if(this.inspection != null && this.inspection.Site_Type__c != null 
         && this.inspection.Site_Type__c == 'Residential'){
              InspectionDealerTier = inspection.Residential_Q04_C__c;
      }  
      showInspectionTypeblock = false ;
      showSiteTypeblock = false ;
      
      selectedInspectorId = this.inspection.Contact__c;      
      selectedSiteId = null;
      selectedJobSupervisorId = this.inspection.Partner_Contact__c;
      
        
      if( selectedInspectorId != null ){
         refreshInspector();
      }
      
      if( selectedJobSupervisorId != null ){
        refreshJobSupervisor();
      }
      
      if( selectedSiteId != null ){
        refreshSite() ;
      }
       
      if(this.inspection.site_type__c =='Residential'){
        showResidentialReportBlock = true ;
      }else{
        showCommercialReportBlock = true;
      }
      
    }
    
    if(ApexPages.currentPage().getParameters().get('inspectionType')!=null){
      selectedInspectionType = ApexPages.currentPage().getParameters().get('inspectionType');
    }
    if(ApexPages.currentPage().getParameters().get('siteType')!= null ){
      selectedSiteType = ApexPages.currentPage().getParameters().get('siteType') ;
    }
    if(ApexPages.currentPage().getParameters().get('isEdit') != null && ApexPages.currentPage().getParameters().get('isEdit') == 'true'){      
      isEdit = true;
    }
    else{
      isEdit = false;
    }
  }
  
  private string retrieveInspectionTypeRecordId() {     
    List<RecordType> lstRecordType = [SELECT Id FROM RecordType 
                                      WHERE SobjectType = 'Case' 
                                      And (Name = 'Case Inspection Audit' OR Name = 'Inspection Audit Case' OR DeveloperName ='Case_Inspection_Audit' OR DeveloperName = 'EU_Inspection_Site_Audit_Case')];//for Case#00078518
    if(lstRecordType.size() > 0) {
      return lstRecordType[0].Id;
    }
    return null;
  }
 
  //function used to upload a image. 
  public PageReference createCaseonImageUpload() {
    if (cCase == null) {
      cCase = new Case() ;
      cCase.RecordTypeId = retrieveInspectionTypeRecordId();
      insert cCase ;
      caseId = cCase.Id ;
    }
    return null;
  }
  
  public pageReference save(){    
    saveInspectionDetail();
    
    PageReference pr = new PageReference( '/'+cCase.Id) ;
    pr.setRedirect(true) ;
    return pr ;
  }
  public PageReference cancelInspection() {
    if( isNewCase == true ) {
      if(caseId != null && caseId != ''){
        List<Attachment> docList = [select id from Attachment where ParentId =:caseId];
        if (docList.size() > 0)
          delete docList;
        delete cCase;
      }
     
      if( ApexPages.currentPage().getParameters().get('cancelURL') != null ){
         string cancelUrl =  ApexPages.currentPage().getParameters().get('cancelURL');
         return new PageReference(cancelUrl) ;
      }
      
      return stdController.cancel();
    
    }
    return new PageReference( '/'+this.cCase.Id) ;
  }
  //function save a inspection
  private void saveInspectionDetail(){
      inspection.Residential_Q04_C__c = InspectionDealerTier;      
      if(inspection.Id == null ){ // Insert Condition      
        inspection.Inspection_Type__c = selectedinspectionType;
        inspection.Site_Type__c = selectedSiteType ;
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.UseDefaultRule= true;
        boolean isNew=false;
        if (cCase == null) {
          isNew=true;
          cCase =  new Case() ;
          cCase.RecordTypeId = retrieveInspectionTypeRecordId();
        }      
        //It is needed for Approval Process Email(It will be Removed if Case Contact == JobSupevisor)
        cCase.job_supervisor_Email__c = JobSupervisor_Email ;
        cCase.setOptions(dmo);
        Database.upsert(cCase);
        if(isNew){
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          req1.setObjectId(cCase.id);
          Approval.ProcessResult result = Approval.process(req1);
        }        
        inspection.Case__c = cCase.Id ;
        insert  inspection ;
      }else{  //Update Condition
        cCase.job_supervisor_Email__c = JobSupervisor_Email ;        
        update cCase;
        update inspection ;      
    } 
    
    if(isExistingSharing() == false){       
        ShareObject();      
    }
   
    updateContactDetail();
        
  }
  
  // Function to check is inspection object is already shared.
  public Boolean isExistingSharing(){
        List<Inspection__Share> lstInspectionShare = new List<Inspection__Share>([Select Id from Inspection__Share where UserOrGroupId =:inspection.Contact__c and ParentID =: inspection.Id and AccessLevel = 'Read']);
        if(lstInspectionShare.Size()>0){
            return true;
        }
     return false;
  }
  //share a inspection object with a inspector
  public void ShareObject(){
      if(inspection.Contact__c != null){ //chk inspector
        Inspection__Share sh = new Inspection__Share();
        sh.UserOrGroupId = inspection.Contact__c; 
        sh.ParentID =inspection.id ;
        sh.AccessLevel = 'Read';
        insert sh;
      } 
  }
  //called on save button click
  public PageReference QuickSave(){
      saveInspectionDetail();
      if(inspection.Id != null ){
        inspectionId = inspection.Id;
        PageReference pr = new PageReference('/apex/InspectionReport?isEdit=true&id='+inspection.Id);
        pr.setRedirect(false);
        return pr;
      }
      return null;
  }
  
  private void updateContactDetail(){   
  }
  
  public  pageReference onSeletionOfInspectionType(){
    showSiteTypeblock = true ;
    showInspectionTypeblock = false ;
    return null ;
  }
  
  public pageReference onSeletionOfSiteType(){
    if( selectedSiteType == '--None--'){
     return null ;
    }
    
    showInspectionTypeblock = false ;
    showSiteTypeblock = false ;
    
    if(selectedSiteType == 'Residential'){
      showResidentialReportBlock = true ;
    }else{
      showCommercialReportBlock = true;
      //showCommercialReportBlock = true ;
      PageReference pr = new PageReference('/apex/InspectionReport_Commercial?&inspectionType='+selectedinspectionType+'&siteType='+selectedSiteType+'&caseid='+caseId);
      pr.setRedirect(true);
      return pr ;
    }
    return null;
  }
  
  public PageReference refreshSiteByName(){     
    return refreshSite();
  }
  
  public  pagereference  refreshSite(){    
    return null ;
  }
  
  public String useContactId {get;set;}
  public PageReference refreshInspectorByName() {
    List<User> inspectorList = [select id, ContactId from User  where Name = :inspectorName];
    
    if (inspectorList.size() != 1) {
      inspector_Company = null;
      inspector_Email = null;
      inspector_Phone = null;
      return null;
    }
    
    selectedInspectorId = inspectorList[0].id; //user
    useContactId = inspectorList[0].ContactId;
    return refreshInspector();
  }
  
  public  pagereference  refreshInspector(){
    inspector_Company = null;
    inspector_Email = null;
    inspector_Phone = null;
    
    
    if (selectedInspectorId != null ){
         
         if(useContactId != null){// if user have contact then get information from contact
            List<Contact> inspectorList = [Select c.Phone, c.Name, c.Account.Name,
                                     c.LastName, c.FirstName, 
                                     c.Email, c.AccountId
                              From Contact c 
                              Where c.id = : useContactId]; 
             
             if (inspectorList.size() == 0)
                return null;
              
              Contact inspector = inspectorList[0];
              inspector_Company = inspector.Account.Name ;
              inspector_Email = inspector.Email ; 
              inspector_Phone =  inspector.Phone ;                   
            
         }
         else{
             List<User> inspectorList = [Select Phone, Email From User Where id = : selectedInspectorId] ;
                                     
              if (inspectorList.size() == 0)
                return null;
      
                User inspector = inspectorList[0];
                inspector_Email = inspector.Email ; 
                inspector_Phone =  inspector.Phone ;                         
                                       
         }
        
    }
    return null ;
  }
  
  public PageReference refreshJobSupervisorByName() {
    List<Contact> jobSupervisorList = [select id from Contact where Name = :jobSupervisorName];
    
    if (jobSupervisorList.size() != 1) {
      Jobsupervisor_company = null;
      JobSupervisor_cityStateZip = null;
      JobSupervisor_phone = null;
      JobSupervisor_Email = null;
      return null;
    }
    
    selectedJobSupervisorId = jobSupervisorList[0].id;
    return refreshJobSupervisor();
  }
  
  public pagereference refreshJobSupervisor() {
    Jobsupervisor_company = null;
    JobSupervisor_cityStateZip = null;
    JobSupervisor_phone = null;
    JobSupervisor_Email = null;
    
    if (selectedJobSupervisorId != null ){
      List<Contact> jobSupervisorList = [Select c.Phone, c.Name,
                                  c.MailingStreet, c.MailingState, 
                                  c.MailingPostalCode, c.MailingCountry, 
                                  c.MailingCity, c.LastName, c.FirstName,
                                  c.Email, c.AccountId ,c.Account.Name
                              From Contact c 
                              Where c.id = : selectedJobSupervisorId limit 1] ;
      
      if (jobSupervisorList.size() == 0)
        return null;
      
      Contact jobSupervisor = jobSupervisorList[0];
                           
      JobSupervisor_Company = jobSupervisor.Account.Name ;
      JobSupervisor_Email = jobSupervisor.Email ; 
      JobSupervisor_Phone =  jobSupervisor.Phone ;
      JobSupervisor_CityStateZip = jobSupervisor.MailingCity+' '+ jobSupervisor.MailingState +' '+ jobSupervisor.MailingPostalCode;
   
    }
    return null ;
  }
  
  public pageReference refreshScore(){
    return null ;
  }
  //function which load all default values at the time of new inspection creation
  private void onLoad(){
    if(ApexPages.currentPage().getParameters().get('caseid')!=null){
        cCase = [select id, RecordTypeId, job_supervisor_Email__c from Case where id =:ApexPages.currentPage().getParameters().get('caseid')];       
        caseId = ApexPages.currentPage().getParameters().get('caseid') ;
    }
    if(caseId != null && cCase != null){
        String casePartnerAccount = null; 
        String accountId = null;
        List<Case> lstCase = new List<Case>([select AccountId, Partner_Account__c from Case where Id=:caseId]);
        if(lstCase.Size()>0){
            casePartnerAccount = lstCase.get(0).Partner_Account__c;
            accountId = lstCase.get(0).AccountId;
        }
        //From the case field "Partner Account" get to the appropriate dealer account and pull Job Supervisor and 
        //all associated dealer information
        if(casePartnerAccount != null){
            List<Contact> lstContact = new List<Contact>([Select Id, Phone, Name, Account.Name, MailingState, MailingPostalCode, MailingCity, Email, AccountId From Contact where AccountId=:casePartnerAccount limit 1]);
            if(lstContact.size()>0){
                Contact jobSupervisor = lstContact.get(0);
                JobSupervisor_Company = jobSupervisor.Account.Name ;
                JobSupervisor_Email = jobSupervisor.Email ; 
                JobSupervisor_Phone =  jobSupervisor.Phone ;
                JobSupervisor_CityStateZip = jobSupervisor.MailingCity+' '+ jobSupervisor.MailingState +' '+ jobSupervisor.MailingPostalCode;
                inspection.Partner_Contact__c = jobSupervisor.Id;
             }
        } 
        //From the case field "Account Name" get to the appropriate end customer account and pull 
        //address and contact information.
        if(accountId != null){
              List<Contact> lstContact2 = new List<Contact>([Select Id, Phone, FirstName, LastName, Name, Account.Name, MailingState, MailingPostalCode, MailingCity, Email, AccountId From Contact where AccountId=:accountId limit 1]);
              if(lstContact2.size()>0){
                  Contact customerContact = lstContact2.get(0);
                  site_ContactName = customerContact.Name;
                  site_ContactFirstName = customerContact.FirstName;
                  site_ContactLastName = customerContact.LastName;
                  site_phone = customerContact.Phone;
                  site_Email = customerContact.Email;
                  
                  /**
                  List<Contact_Site__c> lstContactSite = new List<Contact_Site__c>([Select Contact__c From Contact_Site__c where Contact__c=:customerContact.Id]);
                  if(lstContactSite.Size()>0){
                    //site_CityStateZip = lstContactSite.get(0).Site__r.Address_Line_1__c;                    
                  }**/
              }
        }    
    }   
  }
  
  //function which used to print Resedential type inspection
  public PageReference printResidential(){
    PageReference pr ;
    if(inspectionId != null){
      pr = new PageReference('/apex/InspectionReportpdf?id='+ inspectionId);
      
    }
    else if(caseId != null){
        pr = new PageReference('/apex/InspectionReportpdf?caseId='+ caseId);
    }
    pr.setRedirect(true);
    return pr;
  }
  //function which used to print Commercial type inspection
   public PageReference printCommercial(){
    PageReference pr ;
    if(inspectionId != null){
      pr = new PageReference('/apex/InspectionReport_CommercialPdf?id='+ inspectionId);
      
    }
    else if(caseId != null){
        pr = new PageReference('/apex/InspectionReport_CommercialPdf?caseId='+ caseId);
    }
    pr.setRedirect(true);
    return pr;
   }
}