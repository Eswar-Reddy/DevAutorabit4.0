// *********************************************************************
// Name : InspectionReportNewExtension 
// Created On : 13 Sep 2010
// Created By : Appirio (Lokesh)
// Implementation: Controller class for InspectionReport, InspectionReport_Commercial,InspectionReportPdf & InspectionReport_CommercialPdf Page.
//  This Page has been implemented under case : 00039348
// ***** *****************************************************************
   
public class InspectionReportNewExtension {
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
  public String ReviewerName {get; set;}
  public String jobSupervisorName {get; set;}
  public string selectedSiteId{get ;set ;}
  public string site_CityStateZip{get;set;}  
  public string site_StreetAdd{get;set;} 
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
  public string selectedReviewerId{get ;set ;}  
  public string Reviewer_Email{get ;set ;}
  public string Reviewer_Phone{get ;set ;}
  public string selectedJobSupervisorId{get ;set ;}
  public string JobSupervisor_Company{get ;set ;} 
  public string JobSupervisor_Email {get ;set ;}
  public string JobSupervisor_Phone {get ;set ;}
  public string JobSupervisor_CityStateZip {get ;set ;}
  public String caseId {get; set;}
  public String InspectionDealerTier{get; set;}
  public String inspectionId{get;set;}
  public Decimal SolarBreakerRating {get;set;}
  private PageReference pr;
  public Boolean isStrigConfig;
  public String pageMessage ; 
  ApexPages.StandardController stdController;
  public Boolean isInspcEdit{get;set;}  
  public Boolean  isNotAllowViewReport{get;set;}  
  public Inspection__c inspectionRec{get;set;}  
  public Inspection__c inspectionTSE{get;set;} 
  public String strReviewedTSE{get;set;}
  public String userRole {get;set;}
  public String currentUserName{get;set;}
  public string maxOutputValue {get ;set ;}
  
  public static Boolean isTest{get;set;}
// Variables for email to deale function  

  public String MAIL_SUBJECT {get;set;}
  public String strEmailDealerCC{get;set;}
  public String strEmailDealerBcc{get;set;}
  public String strEmailBody{get;set;}
  public string nameFile { get; set;}
  Attachment doc = null;
  public blob contentFile { get; set;}
  public  Map<String,blob> mapAttachments = new Map<String,blob>();
  public  static List<ClsAttachfile> lstAttachs = new List<ClsAttachfile>();  //Transient
  public  Set<String> setattachfiles  { get; set;}
  public Boolean isClosed { get; set;}
  public Boolean isAttached{ get; set;}
  public String currentUserEmail{ get; set;}
  public String sendEmailToUser {get; set;}
  public String urlLink {get;set;}
  public String inspectionReportName {get;set;} // set inspection name by Inspection Specialist
// Variables for email

 static {
 	isTest = false;
 }

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
  public string partnerContactName{get;set;}
  
  public void AssignParentUrl() {
    
    userRole = CheckUserRole();
    if ( userRole != 'no Role' && (userRole == 'Inspection Specialist' || userRole == 'Inspector' || userRole == 'Technical Services Engineer' || (userRole.trim() == 'Logistics Support' && currentUserName.contains('Neil Pamulaklakin'))) ) {
        strEmailBody = '\n Please Find below link to inspection report saved by ' + Userinfo.getName() + ' (' + userRole + ') \n\n' + urlLink;
        strEmailBody += '\n\n Thanks.';
    }   
    List<Attachment> lstattach =  CheckInspectionAttachment();
    if (lstattach.size() > 0)
    	lstattach.clear();
     
  }
  
  //constructor
  public InspectionReportNewExtension(ApexPages.StandardController stdController) {
    pr = null;
    urlLink = '';
    setattachfiles = new Set<String>();
    isClosed = false;
    isAttached = false;
    currentUserEmail = '';
    sendEmailToUser = '';
    SolarBreakerRating = 0;
    isInspcEdit = true;
    isNotAllowViewReport = false;
    maxOutputValue = '0';
    // Section for email Reprot to dealer
    
    MAIL_SUBJECT = 'Residential Inspection Report';
    strEmailDealerCC = '';
    strEmailBody = 'Please find the residential inspection report attached as a PDF format herewith this email.';
    
    // end Section Email report to dealer
    
    this.stdController = stdController;    
    inspectionRec = (Inspection__c) stdController.getRecord();
    strReviewedTSE = '';
    if(ApexPages.currentPage().getParameters().get('id')!=null){
            inspectionId = ApexPages.currentPage().getParameters().get('id') ;
            System.Debug(' inspection id show in construtor ---' + inspectionId);            
            List<Inspection__c> lstInspection = new List<Inspection__c>([Select SystemModstamp, Status__c, Site_Type__c, Score__c, Score_Details__c, Residential_SYSTEM_SAFETY_Hazards__c, Residential_SYSTEM_SAFETY_Comments__c, Residential_SYSTEM_SAFETY_ChkBox__c, Residential_Result__c, Residential_ReadingsMeasurements_Comment__c, Residential_Q54_Response__c, Residential_Q54_Comments__c, Residential_Q53_Response__c, Residential_Q53_Comments__c, Residential_Q52_Response__c, Residential_Q52_Comments__c, Residential_Q51_Rating__c, Residential_Q50_Rating__c, Residential_Q49_Rating__c, Residential_Q48_Response__c, Residential_Q48_Comments__c, Residential_Q48_3__c, Residential_Q48_2__c, Residential_Q48_1__c, Residential_Q47_Response__c, Residential_Q47_Comments__c, Residential_Q46_Response__c, Residential_Q46_Comments__c, Residential_Q45_Response__c, Residential_Q45_Comments__c, Residential_Q44_Size__c, Residential_Q44_Quantity__c, Residential_Q44_Distance__c, Residential_Q44_Comments__c, Residential_Q43_Response__c, Residential_Q43_Comments__c, Residential_Q43_3__c, Residential_Q43_2__c, Residential_Q43_1__c, Residential_Q42_Response__c, Residential_Q42_Comments__c, Residential_Q41_Response__c, Residential_Q41_Comments__c, Residential_Q40_Response__c, Residential_Q40_Comments__c, Residential_Q39_Response__c, Residential_Q39_Picklist__c, Residential_Q39_Comments__c, Residential_Q38_Response__c, Residential_Q38_Comments__c, Residential_Q37_Response__c, Residential_Q37_Comments__c, Residential_Q36_Response__c, Residential_Q36_Comments__c, Residential_Q35_Size__c, Residential_Q35_Quantity__c, Residential_Q35_Distance__c, Residential_Q35_Comments__c, Residential_Q34_Response__c, Residential_Q34_Comments__c, Residential_Q33_Response__c, Residential_Q33_Comments__c, Residential_Q32_Response__c, Residential_Q32_Comments__c, Residential_Q31_Response__c, Residential_Q31_EGC_Size__c, Residential_Q31_Comments__c, Residential_Q30_Array_Input_4__c, Residential_Q30_Array_Input_3__c, Residential_Q30_Array_Input_2__c, Residential_Q30_Array_Input_1__c, Residential_Q30_4_2__c, Residential_Q30_4_1__c, Residential_Q30_3_2__c, Residential_Q30_3_1__c, Residential_Q30_2_2__c, Residential_Q30_2_1__c, Residential_Q30_1_2__c, Residential_Q30_1_1__c, Residential_Q29_4__c, Residential_Q29_3__c, Residential_Q29_2__c, Residential_Q29_1__c, Residential_Q28_4__c, Residential_Q28_4_ChkBox__c, Residential_Q28_3__c, Residential_Q28_3_ChkBox__c, Residential_Q28_2__c, Residential_Q28_2_ChkBox__c, Residential_Q28_1__c, Residential_Q28_1_ChkBox__c, Residential_Q27_4__c, Residential_Q27_3__c, Residential_Q27_2__c, Residential_Q27_1__c, Residential_Q26_4__c, Residential_Q26_3__c, Residential_Q26_2__c, Residential_Q26_1__c, Residential_Q25_4__c, Residential_Q25_3__c, Residential_Q25_2__c, Residential_Q25_1__c, Residential_Q24_4__c, Residential_Q24_3__c, Residential_Q24_2__c, Residential_Q24_1__c, Residential_Q23_Comments__c, Residential_Q23_4__c, Residential_Q23_3__c, Residential_Q23_2__c, Residential_Q23_1__c, Residential_Q22_4__c, Residential_Q22_3__c, Residential_Q22_2__c, Residential_Q22_1__c, Residential_Q21_Sky_Conditions__c, Residential_Q20_Time__c, Residential_Q20_Time_Picklist__c, Residential_Q19_Response__c, Residential_Q19_Comments__c, Residential_Q18_Response__c, Residential_Q18_Comments__c, Residential_Q17_Response__c, Residential_Q17_Comments__c, Residential_Q16_Response__c, Residential_Q16_Comments__c, Residential_Q15_Picklist__c, Residential_Q15_Comments__c, Residential_Q14_Picklist__c, Residential_Q13_Picklist__c, Residential_Q12_Picklist__c, Residential_Q12_Comments__c, Residential_Q11_Picklist__c, Residential_Q11_Comments__c, Residential_Q10_Response__c, Residential_Q10_Comments__c, Residential_Q09_Response__c, Residential_Q09_Picklist__c, Residential_Q09_Comments__c, Residential_Q08_Response__c, Residential_Q08_Comments__c, Residential_Q07_Response__c, Residential_Q07_Comments__c, Residential_Q06_Response__c, Residential_Q06_Comments__c, Residential_Q05_Response__c, Residential_Q05_Comments__c, Residential_Q04_D__c, Residential_Q04_Comments__c, Residential_Q04_C__c, Residential_Q04_B__c, Residential_Q04_A__c, Residential_Q03_D__c, Residential_Q03_C__c, Residential_Q03_B__c, Residential_Q03_A__c, Residential_Q02_Text2__c, Residential_Q02_Text2_ChkBox__c, Residential_Q02_Text1__c, Residential_Q02_Text1_ChkBox__c, Residential_Q02_System_Size__c, Residential_Q02_Comments__c, Residential_Q02_Array_Power__c, Residential_Q01_SPR2__c, Residential_Q01_SPR2_ChkBox__c, Residential_Q01_SPR1__c, Residential_Q01_SPR1_ChkBox__c, Residential_MSP_NEC_Labels__c, Residential_MSP_Interior__c, Residential_MSP_Exterior__c, Residential_MOUNTING_Roof_Penetrations__c, Residential_MOUNTING_Problem_Areas__c, Residential_MOUNTING_L_Brackets__c, Residential_INVERTER_TO_MSP_Problem_Area__c, Residential_INVERTER_TO_MSP_Conduit__c, Residential_INVERTER_Overview__c, Residential_INVERTER_Interior_Grounding__c, Residential_INVERTER_Interior_AC_DC__c, Residential_INVERTER_DC_System__c, Residential_DC_DISCONNECT_Problem_Areas__c, Residential_DC_DISCONNECT_NEC_Labels__c, Residential_DC_DISCONNECT_Interior__c, Residential_DC_DISCONNECT_Exterior__c, Residential_Commission_Date__c, Residential_Auto_Calculations_4_4__c, Residential_Auto_Calculations_4_3__c, Residential_Auto_Calculations_4_2__c, Residential_Auto_Calculations_4_1__c, Residential_Auto_Calculations_3_4__c, Residential_Auto_Calculations_3_3__c, Residential_Auto_Calculations_3_2__c, Residential_Auto_Calculations_3_1__c, Residential_Auto_Calculations_2_4__c, Residential_Auto_Calculations_2_3__c, Residential_Auto_Calculations_2_2__c, Residential_Auto_Calculations_2_1__c, Residential_Auto_Calculations_1_4__c, Residential_Auto_Calculations_1_3__c, Residential_Auto_Calculations_1_2__c, Residential_Auto_Calculations_1_1__c, Residential_ARRAY_Rooftop__c, Residential_ARRAY_Profile__c, Residential_ARRAY_Problem_Areas__c, Residential_ARRAY_Pathfinder__c, Residential_ARRAY_Overall__c, Residential_ARRAY_J_Box__c, Residential_ARRAY_INVERTER_Problem_Areas__c, Residential_ARRAY_INVERTER_PV_Source__c, Residential_ARRAY_INVERTER_DC_Conduit__c, Residential_ARRAY_Grounding__c, Residential_ADDITIONAL_COMMENTS__c, Residential_AC_DISCONNECT_Problem_Areas__c, Residential_AC_DISCONNECT_NEC_Labels__c, Residential_AC_DISCONNECT_Interior__c, Residential_AC_DISCONNECT_Exterior__c, Partner_Contact__c, OwnerId, Name, Last_Modified_Date__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Integration_ID__c, Inspection_Type__c, Inspection_Time__c, Inspection_Status__c, Inspection_Date__c, Id, Customer_Communication__c, CurrencyIsoCode, CreatedDate, CreatedById, Contact__c, Contact__r.Name,Contact__r.Email, Compliance_Result__c, Comm_Q9_3_Field__c, Comm_Q9_2_Field__c, Comm_Q9_1_Field__c, Comm_Q8_8_Field__c, Comm_Q8_7_Field__c, Comm_Q8_5_Field__c, Comm_Q8_4_Field__c, Comm_Q8_3_Field__c, Comm_Q8_2_Field__c, Comm_Q8_1_Field__c, Comm_Q7_13_Field__c, Comm_Q7_12_Field__c, Comm_Q7_11_Field__c, Comm_Q7_10_Field__c, Comm_Q7_09_Field__c, Comm_Q7_08_Field__c, Comm_Q7_07_Field__c, Comm_Q7_06_Field__c, Comm_Q7_05_Field__c, Comm_Q7_04_Field__c, Comm_Q7_03_Field__c, Comm_Q7_02_Field__c, Comm_Q7_01b_Field__c, Comm_Q7_01a_Field__c, Comm_Q6_12_Field__c, Comm_Q6_11_Field__c, Comm_Q6_10_Field__c, Comm_Q6_09_Field__c, Comm_Q6_08_Field__c, Comm_Q6_07_Field__c, Comm_Q6_06_Field__c, Comm_Q6_05_Field__c, Comm_Q6_04_Field__c, Comm_Q6_03_Field__c, Comm_Q6_02_Field__c, Comm_Q6_01_Field__c, Comm_Q6_00_Field__c, Comm_Q5_19_Field__c, Comm_Q5_18_Field__c, Comm_Q5_17_Field__c, Comm_Q5_16_Field__c, Comm_Q5_15_Field__c, Comm_Q5_14_Field__c, Comm_Q5_13_Field__c, Comm_Q5_12_Field__c, Comm_Q5_11_Field__c, Comm_Q5_10_Field__c, Comm_Q5_09_Field__c, Comm_Q5_08_Field__c, Comm_Q5_07_Field__c, Comm_Q5_06_Field__c, Comm_Q5_05_Field__c, Comm_Q5_04_Field__c, Comm_Q5_03_Field__c, Comm_Q5_02_Field__c, Comm_Q5_01_Field__c, Comm_Q4_5_Field__c, Comm_Q4_4_Field__c, Comm_Q4_3_Field__c, Comm_Q4_2_Field__c, Comm_Q4_1_Field__c, Comm_Q4_0_Field__c, Comm_Q3_16_Field__c, Comm_Q3_13_Field__c, Comm_Q3_12_Field__c, Comm_Q3_11_Field__c, Comm_Q3_10_Field__c, Comm_Q3_09_Field__c, Comm_Q3_08_Field__c, Comm_Q3_07_Field__c, Comm_Q3_06_Field__c, Comm_Q3_05_Field__c, Comm_Q3_04_Field__c, Comm_Q3_03_Field__c, Comm_Q3_02_Field__c, Comm_Q3_01_Field__c, Comm_Q2_10_Field__c, Comm_Q2_09_Field__c, Comm_Q2_07_Field__c, Comm_Q2_06b_Field__c, Comm_Q2_06a_Field__c, Comm_Q2_06_Field__c, Comm_Q2_05_Field__c, Comm_Q2_04_4_2__c, Comm_Q2_04_4_1__c, Comm_Q2_04_3_2__c, Comm_Q2_04_3_1__c, Comm_Q2_04_2_2__c, Comm_Q2_04_2_1__c, Comm_Q2_04_1__c, Comm_Q2_03_Field__c, Comm_Q2_02_Field__c, Comm_Q2_01_Field__c, Comm_Q1_9_Field__c, Comm_Q1_8_Field__c, Comm_Q1_7_Field__c, Comm_Q1_6_Field__c, Comm_Q1_5e_Field__c, Comm_Q1_5d_Field__c, Comm_Q1_5c_Field__c, Comm_Q1_5b_Field__c, Comm_Q1_5a_Field__c, Comm_Q1_5_Field__c, Comm_Q1_4_Field__c, Comm_Q1_3_Field__c, Comm_Q1_2_Number2__c, Comm_Q1_2_Number1__c, Comm_Project__c, Comm_ProjectSize__c, Comm_OtherPresent__c, Comm_BuildingOccupancy__c, Comm_As_Builts__c, Case__c,Reviewer__c,Reviewer__r.Name , Res_Per_Monitoring_Sys__c, Res_Per_Monitoring_Comments__c, Res_Ambrient__c, Res_GroundPath_Inverter_MSP__c, Res_GroundPath_Inverter_MSP_Comment__c, Res_Consumtion_Monitoring_Sys__c, Res_Consumtion_Monitoring_Comments__c,Res_flashing_lights__c, Res_flashing_lights_Comments__c, Res_External_Bonding__c, Res_External_Bonding_Comments__c, Res_Mounting_Location_Other__c, Res_Roofing_Material_Other__c, Res_Rack_Type_Other__c, Res_Mount_Type_Other__c,IsSaveByTSE__c, InspectionNameType__c, Inspection_Name__c, InspectionByTSE__c, InspectionByTSE__r.Id, InspectionSavedBy__c,Res_MaxOutputValue__c,Res_SolarBreakerRating__c From Inspection__c where Id=:inspectionId]);
                   
            if(lstInspection.size()>0){
                this.inspection = lstInspection.get(0);  
                userRole  = CheckUserRole();
                System.Debug('current use role is --' + userRole );
                
                isEdit = CheckUserEditReport();
                maxOutputValue = String.valueOf(inspection.Res_MaxOutputValue__c);
                oldInspector = inspection.Contact__c;
                
                MAIL_SUBJECT = MAIL_SUBJECT + ' - ' + inspection.InspectionNameType__c;
            }else{
                this.inspection = new Inspection__c();  
            }    
            // body to send email to Next level user ( Requirement update on 04 Nov)
            userRole = CheckUserRole();
            if ( userRole != 'no Role' && (userRole == 'Inspection Specialist' || userRole == 'Inspector' || userRole == 'Technical Services Engineer' || (userRole.trim() == 'Logistics Support' && currentUserName.contains('Neil Pamulaklakin'))) ) {
                //if( urlLink == null || urlLink == '')
                    //urlLink = 'https://c.cs1.visual.force.com' + ApexPages.currentPage().getUrl();
                strEmailBody = '\n Please Find below link to inspection report saved by ' + Userinfo.getName() + ' (' + userRole + ') \n' + urlLink;
                strEmailBody += '\n\n Thanks.';
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
      }
      else{ 
          isNewCase = false;
      }   
      isEdit = true;   
      onLoad();
                
    }else{ // Edit Case
      cCase = [select id, RecordTypeId, job_supervisor_Email__c,Account.BillingPostalCode
        , Account.BillingStreet
        , Account.BillingState
        , Account.BillingCity,AccountId
        , Partner_Account__c
        , Contact.Email, Contact.Phone, Contact.Name
        , Contact.FirstName, Contact.LastName from Case where id =:this.inspection.Case__c];
        
      caseId = cCase.Id ;
      
       site_CityStateZip =  (cCase.Account.BillingStreet == null ? '' : '' + cCase.Account.BillingStreet) 
                  + (cCase.Account.BillingCity == null ? '' : ',' + cCase.Account.BillingCity)  
                  + (cCase.Account.BillingState == null ? '' : ',' + cCase.Account.BillingState) 
                  + (cCase.Account.BillingPostalCode == null ? '' : ',' + cCase.Account.BillingPostalCode);
        
       site_StreetAdd =  (cCase.Account.BillingStreet == null ? '' : '' + cCase.Account.BillingStreet) ;
         
         //comment on 6 dec
     /* if(this.inspection != null && this.inspection.Site_Type__c != null 
         && this.inspection.Site_Type__c == 'Residential'){
              InspectionDealerTier = inspection.Residential_Q04_C__c;
      }  */
      showInspectionTypeblock = false ;
      showSiteTypeblock = false ;
      
      selectedInspectorId = this.inspection.Contact__c;
      selectedReviewerId = this.inspection.Reviewer__c;      
      selectedSiteId = null;
      selectedJobSupervisorId = this.inspection.Partner_Contact__c;
      
      try{
      	if ( inspection.Residential_Q49_Rating__c != null && inspection.Residential_Q50_Rating__c != null && Decimal.valueOf(inspection.Residential_Q49_Rating__c) > 0 && Decimal.valueOf(inspection.Residential_Q50_Rating__c) > 0 )
        // SolarBreakerRating = (Decimal.valueOf(inspection.Residential_Q49_Rating__c) * 1.2) - Decimal.valueOf(inspection.Residential_Q50_Rating__c);
        	inspection.Res_SolarBreakerRating__c = (Decimal.valueOf(inspection.Residential_Q49_Rating__c) * 1.2) - Decimal.valueOf(inspection.Residential_Q50_Rating__c);
      }catch(TypeException e){
      	inspection.Res_SolarBreakerRating__c = 0.0;
      }if( selectedInspectorId != null ){
         refreshInspector();
      }
      
      if( selectedReviewerId != null ){
         refreshReviewer();
      }
      
      if( selectedJobSupervisorId != null ){
        refreshJobSupervisor();
      }
      
      //if( selectedSiteId != null ){
      //  refreshSite() ;
      //}
      
      if(cCase.accountId != null){
              List<Contact> lstContact2 = new List<Contact>([Select Id, Phone, FirstName, LastName, Name, Account.Name, MailingState, MailingPostalCode, MailingCity, Email, AccountId From Contact where AccountId=:cCase.accountId limit 1]);
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
                  }
                  **/
              } 
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
      
     if (selectedJobSupervisorId != null && selectedJobSupervisorId.trim() == Userinfo.getUserId() ) {
        isEdit = false;
     }
     
    }
    else{
      isEdit = false;
    }
    if (inspection.id != null) {
         isEdit = CheckUserEditReport();
         // function to check the user email where the report is need to send on next level.
         System.Debug(' final is edit value : ' + isEdit);
          System.Debug(' final is isInspcEdit value : ' + isInspcEdit);
         sendEmailToUser = SetSendEmailTo();
    }
  }
  
  // Function to check access level for different Inspection users.
  public Boolean CheckUserEditReport() {
    
    if(isTest == false){
    	userRole  = CheckUserRole();
    }
    System.Debug('current user role is --' + userRole );
    Boolean CheckisEdit = false;
    isNotAllowViewReport = false;
    if(userRole != 'no role') {
                    
        if(userRole == 'Inspection Specialist') {
            
          if((inspection.InspectionSavedBy__c == null || inspection.InspectionSavedBy__c == userRole)) { // && inspection.InspectionByTSE__c == null )
            CheckisEdit = true;
            isInspcEdit = true;
          }
          else if (inspection.InspectionSavedBy__c == 'Technical Services Engineer'){
          	CheckisEdit = true;
          	isInspcEdit = false;
          }
          else
          	isInspcEdit = false;
          
        }
       
        if(userRole == 'Inspector') {
                        
           if(inspection.InspectionSavedBy__c == 'Inspector' || (inspection.InspectionSavedBy__c == 'Inspection Specialist' && inspection.InspectionByTSE__c == null) ) {
                CheckisEdit = true;
            	isInspcEdit = true;
           }
           else {
                CheckisEdit = false;
                isInspcEdit = false;
           }
           // if Inspector access Inspection form saved by him. Only permitted to send report to next level user.
          // if (inspection.InspectionSavedBy__c == 'Inspector'){
          //      isInspcEdit = true;
          //      CheckisEdit = true;
          // }
           
        }//Case#00067466 : Included 'Technical Services Team Leader'
        if(userRole == 'Technical Services Engineer' || userRole == 'Applications Engineering' || userRole == 'Technical Services Team Leader') {
            if(currentUserName.contains('Mandeep Guragain') || currentUserName.contains('Joseph Maico')|| currentUserName.contains('Allan Arboleda') || currentUserName == 'Walton Jan Atizado' || currentUserName.contains('Saturnino Fegi Jr') || currentUserName == inspection.Reviewer__r.Name
            //Case#00067466 : Included more users 
            || currentUserName.contains('Joey Villagomez') || currentUserName.contains('Mike Leonard') || currentUserName.contains('Timothy Murphy') || currentUserName.contains('Mike Feather') || currentUserName.contains('Jesse Stallcup') || currentUserName.contains('Aage Nagel') || currentUserName.contains('Dan Bolden') || currentUserName.contains('Josh Kozub'))
            {
            	CheckisEdit = true;
            	isInspcEdit = true;
            }
            else{
            	CheckisEdit = false;
            } 
             
        }
        else if( userRole != 'Inspection Specialist' && inspection.InspectionSavedBy__c != 'Inspection Specialist' && inspection.InspectionSavedBy__c != 'Inspector' && inspection.InspectionSavedBy__c != 'Technical Services Engineer' ) {
             CheckisEdit = false;
        }
    }
    else
        CheckisEdit = false;
   return CheckisEdit;
  }
  
  public PageReference redirect() {
    return pr;
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
    if (isStrigConfig == false) {
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Enter value for String Configutration value with respect of Choosen Inverter Type ..'));
        return null;
    }       
    // check if any error on page.  
    if(pageMessage.length() > 0) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,pageMessage ));
        return null;
    }
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
  
  public Boolean CheckInverterStringConfigutration(){
    if ( userRole == 'Inspection Specialist') {
        if ((inspection.Residential_Q28_1__c != '' && inspection.Residential_Q28_2__c != null) && (inspection.Residential_Q30_1_1__c == null || inspection.Residential_Q30_1_1__c == '' ) &&  (inspection.Residential_Q30_1_2__c == null || inspection.Residential_Q30_1_2__c == '' )) {
            return false;
        }
        if ((inspection.Residential_Q28_2__c != '' && inspection.Residential_Q28_2__c != null) && (inspection.Residential_Q30_2_1__c == null || inspection.Residential_Q30_2_1__c == '' ) &&  (inspection.Residential_Q30_2_2__c == null || inspection.Residential_Q30_2_2__c == '' )) {
            return false;
        }
        if ((inspection.Residential_Q28_3__c != '' && inspection.Residential_Q28_3__c != null) && (inspection.Residential_Q30_3_1__c == null || inspection.Residential_Q30_3_1__c == '' ) &&  (inspection.Residential_Q30_3_2__c == null || inspection.Residential_Q30_3_2__c == '' )) {
            return false;
        }
        if ((inspection.Residential_Q28_4__c != '' && inspection.Residential_Q28_4__c != null) && (inspection.Residential_Q30_4_1__c == null || inspection.Residential_Q30_4_1__c == '' ) &&  (inspection.Residential_Q30_4_2__c == null || inspection.Residential_Q30_4_2__c == '' )) {
            return false;
        }
        return true;
    }
    else 
       return true;
  }
  
  //function save a inspection
  private void saveInspectionDetail(){
      pageMessage = '';
      //comment on 6 dec
      // inspection.Residential_Q04_C__c = InspectionDealerTier; 
      // if ( maxOutputValue != '0')
     // inspection.Res_MaxOutputValue__c = Decimal.valueOf(maxOutputValue);
      isStrigConfig = true;
      isStrigConfig = CheckInverterStringConfigutration();  
      if ( isStrigConfig == false) 
        return;
      
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
        if ( inspectionReportName != null && inspectionReportName.length() > 0 )
        	inspection.InspectionNameType__c = inspectionReportName;
        else
           inspection.InspectionNameType__c = JobSupervisor_Company + '_' + site_ContactLastName;
        inspection.InspectionSavedBy__c = 'Inspection Specialist';
        if(isTest == false)
        	userRole = CheckUserRole();
        if(userRole.trim() == 'Inspection Specialist' || (userRole.trim() == 'Logistics Support' && currentUserName.contains('Neil Pamulaklakin') )) {
            insert  inspection ;
        }
        else {
            pageMessage = 'You are not authorized to Insert/Update Inspection form. Please contact your Administrator.';
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'You are not authorized to Insert/Update Inspection form. Please contact your Administrator.'));
           return;
        }   
      }else{  //Update Condition
        
        //CheckIfTSEUser();
        cCase.job_supervisor_Email__c = JobSupervisor_Email ;        
       		
        if (isTest == false) {
        	update cCase;
        // Code to check if Logged in user is Inspection Specialist / Inspector / TSE reviewer and then create a Clone of Inspection report accordingly.
        	userRole = CheckUserRole();
        }
        if ( userRole.trim() != 'no role') {
            
            if (userRole.trim() == 'Inspection Specialist' ||  (userRole.trim() == 'Logistics Support' && currentUserName.contains('Neil Pamulaklakin') )) {
                if ((inspection.InspectionSavedBy__c == 'Inspection Specialist' && inspection.InspectionByTSE__c == null)  ) { // || inspection.InspectionByTSE__c == ''
                    update inspection; 
                }
                else{
                  pageMessage = 'this repot has been already procced by Inspector. So no updations are permitted.';
                  return;
                }
            }
            else if(userRole.trim() == 'Inspector') {
                if (inspection.InspectionSavedBy__c == 'Inspection Specialist' && (inspection.InspectionByTSE__c == null) ) { // || inspection.InspectionByTSE__c == ''
                
                    Inspection__c objInspection = New Inspection__c ();
                    objInspection = inspection.clone(false,true);
                    objInspection.InspectionSavedBy__c = userRole;
                    objInspection.InspectionByTSE__c = null;
                    objInspection.IsSaveByTSE__c = false;
                    String inspectionName = inspection.InspectionNameType__c + '_' + String.valueOf(inspection.Inspection_Date__c);
                    objInspection.InspectionNameType__c = inspectionName;
                    insert objInspection;
                    system.Debug('saved inspection id = ....' + objInspection.id);
                    if(objInspection != null && objInspection.Id != null ) {
                        Inspection__c objInspectionTemp = [Select id,Name,IsSaveByTSE__c,InspectionByTSE__c from Inspection__c where id = :inspectionId] ; 
                        if (objInspectionTemp != null ){
                            
                            objInspectionTemp.InspectionByTSE__c = objInspection.Id;
                            update objInspectionTemp;
                        }
                    }
                    else {
                      pageMessage = 'Report Cannot be saved properly. Contact your Administrator';      
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Report Cannot be saved properly. Contact your Administrator'));
                      return;
                    }
                }
                else if (inspection.InspectionSavedBy__c == userRole ) {
                    update inspection;
                }
                else {
                    pageMessage = 'Report Cannot be saved properly.  Inspector is not authorized.';     
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Report Cannot be saved. Inspector is not authorized.'));
                    return;
                }
            }
            else if (userRole == 'Technical Services Engineer' || userRole == 'Applications Engineering') {
                System.Debug('Technical Sevices Engineer section inner part');
                System.Debug('inspection.InspectionSavedBy__c   ' + inspection.InspectionSavedBy__c);
                System.Debug('inspection.InspectionByTSE__c  '  +inspection.InspectionByTSE__c);
                if (inspection.InspectionSavedBy__c == 'Inspector' && (inspection.InspectionByTSE__c == null ) ) { //|| inspection.InspectionByTSE__c == ''
                
                    Inspection__c objInspection = New Inspection__c ();
                    objInspection = inspection.clone(false,true);
                    objInspection.InspectionSavedBy__c = 'Technical Services Engineer'; //userRole;
                    objInspection.InspectionByTSE__c = null;
                    objInspection.IsSaveByTSE__c = false;
                    String userName = Userinfo.getFirstName().substring(0,1) + Userinfo.getLastName().substring(0,1);
                    String inspectionName = inspection.InspectionNameType__c + '_' + userName.toUpperCase();
                    objInspection.InspectionNameType__c = inspectionName;
                    insert objInspection;
                    if(objInspection != null && objInspection.Id != null ) {
                        Inspection__c objInspectionTemp = [Select id,Name,IsSaveByTSE__c,InspectionByTSE__c from Inspection__c where id = :inspectionId] ; 
                        if (objInspectionTemp != null ){
                            
                            objInspectionTemp.InspectionByTSE__c = objInspection.Id;
                            update objInspectionTemp;
                        }
                    }
                    else {
                      pageMessage = 'Report Cannot be saved properly. Contact your Administrator.';
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Report Cannot be saved properly. Contact your Administrator'));
                      return;
                    }
                }
                else if (inspection.InspectionSavedBy__c == userRole ) {
                    
                    Inspection__c objInspTse = [Select id,Name,IsSaveByTSE__c,InspectionByTSE__c,Residential_Result__c from Inspection__c where id = :inspectionId];
                    String scoreDetails = objInspTse.Residential_Result__c;
                    scoreDetails = scoreDetails.toUpperCase();
                    if (scoreDetails.contains('FAIL') && objInspTse.InspectionByTSE__c == null && objInspTse.IsSaveByTSE__c == false) {
                        
                        Inspection__c objInspection = New Inspection__c ();
                        objInspection = inspection.clone(false,true);
                        objInspection.InspectionSavedBy__c = userRole;
                        objInspection.InspectionByTSE__c = null;
                        objInspection.IsSaveByTSE__c = true;
                        String userName = inspection.InspectionNameType__c.substring(0,inspection.InspectionNameType__c.length() - 2); 
                        String inspectionName = userName + 'Reinspection_' + inspection.InspectionNameType__c.substring(inspection.InspectionNameType__c.length() - 2,inspection.InspectionNameType__c.length()); 
                        objInspection.InspectionNameType__c = inspectionName;
                        insert objInspection;
                        if(objInspection != null && objInspection.Id != null ) {
                            Inspection__c objInspectionTemp = [Select id,Name,IsSaveByTSE__c,InspectionByTSE__c from Inspection__c where id = :inspectionId] ; 
                            if (objInspectionTemp != null ){
                            
                                objInspectionTemp.InspectionByTSE__c = objInspection.Id;
                                update objInspectionTemp;
                            }
                        }
                        else {
                             pageMessage = 'Report Cannot be saved properly. Contact your Administrator.';
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Report Cannot be saved properly. Contact your Administrator'));
                            return;
                        }
                    }
                    else
                        update inspection;
                }
                else 
                    update inspection;
                      //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Report Cannot be saved properly. Contact your Administrator'));
                
            }
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'User is not authorized to save/ update report'));
                
            
        }
       
        System.Debug('-- Inspection id value in save function -----' + inspection.Id);    
    } 
    
    if (isTest == false) {
    	if(isExistingSharing() == false){       
        	ShareObject();      
    	}
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
        
        List<CaseShare> lstCaseShare = new List<CaseShare>([Select Id from CaseShare where UserOrGroupId =:inspection.Contact__c and CaseId =: cCase.Id and CaseAccessLevel = 'Read']);
        //Designated inspector cannot see the case, therefore cannot get to the inspection report
        
        
        if(lstCaseShare.Size() == 0){
           CaseShare caseSh = new CaseShare();
           //inspection.Contact__c is User 
           caseSh.UserOrGroupId = inspection.Contact__c; 
           caseSh.CaseId = cCase.id;
           caseSh.CaseAccessLevel = 'Read'; 
           insert caseSh;   
        }
        
        
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
      System.Debug('------ inspection.Id-----'+ inspection.Id);
      System.Debug('isStrigConfig value : ' + isStrigConfig);
      if (isStrigConfig == false) {
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Enter value for String Configutration value with respect of Choosen Inverter Type ..'));
        return null;
      }     
      
      if(pageMessage.length() > 0) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,pageMessage ));
        return null;
      }
      if(inspection.Id != null ){
        inspectionId = inspection.Id;
        if( inspectionTSE != null && inspectionTSE.Id != null)
           inspectionId = inspectionTSE.Id;
        PageReference pr = new PageReference('/apex/InspectionReportNew?isEdit=true&id='+inspectionId + '&ReportName=' + inspection.InspectionNameType__c );
        
        pr.setRedirect(true);
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
             List<User> inspectorList = [Select CompanyName,Phone, Email From User Where id = : selectedInspectorId] ;
                                     
              if (inspectorList.size() == 0)
                return null;
      
                User inspector = inspectorList[0];
                inspector_Email = inspector.Email ; 
                inspector_Phone =  inspector.Phone ;
                inspector_Company = inspector.CompanyName;                         
                                       
         }
        
    }
    return null ;
  }
  
  //Refresh reviewer detail by passing user(Reviewer) name
  public PageReference refreshReviewerByName() {
    List<User> ReviewerList = [select id from User  where Name = :ReviewerName];
    
    if (ReviewerList.size() != 1) {      
      Reviewer_Email = null;
      Reviewer_Phone = null;
      return null;
    }
    
    selectedReviewerId = ReviewerList[0].id; //user    
    return refreshReviewer();
  }
  
  //Refresh reviewer detail by passing user(Reviewer) id
  public  pagereference  refreshReviewer(){    
    Reviewer_Email = null;
    Reviewer_Phone = null;
        
    if (selectedReviewerId != null ){    
             List<User> ReviewerList = [Select Phone, Email, Name From User Where id = : selectedReviewerId] ;
                                     
              if (ReviewerList.size() == 0)
                return null;
      
            User Reviewer = ReviewerList[0];
            Reviewer_Email = Reviewer.Email ; 
            Reviewer_Phone =  Reviewer.Phone ;                                    
    
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
                                  c.Email, c.AccountId ,c.Account.Name,c.Account.Type
                              From Contact c 
                              Where c.id = : selectedJobSupervisorId limit 1] ;
      
      if (jobSupervisorList.size() == 0)
        return null;
      
      Contact jobSupervisor = jobSupervisorList[0];
      
      System.Debug('---Account type ---- ' +jobSupervisor.Account.Type );    
      
      JobSupervisor_Company = jobSupervisor.Account.Name ;
      JobSupervisor_Email = jobSupervisor.Email ; 
      JobSupervisor_Phone =  jobSupervisor.Phone ;
      JobSupervisor_CityStateZip = jobSupervisor.MailingCity +' '+ jobSupervisor.MailingState +' '+ jobSupervisor.MailingPostalCode;
      partnerContactName = jobSupervisor.Name;
      InspectionDealerTier = jobSupervisor.Account.Type;
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
        List<Case> lstCase = new List<Case>([select Account.BillingPostalCode
        , Account.BillingStreet
        , Account.BillingState
        , Account.BillingCity,AccountId
        , Partner_Account__c
        , Contact.Email, Contact.Phone, Contact.Name
        , Contact.FirstName, Contact.LastName
        , ContactId from Case where Id=:caseId]);
        
        if(lstCase.Size()>0){
            casePartnerAccount = lstCase.get(0).Partner_Account__c;
            accountId = lstCase.get(0).AccountId;
            site_CityStateZip =  (lstCase.get(0).Account.BillingCity == null ? '' : lstCase.get(0).Account.BillingCity)  
                  + (lstCase.get(0).Account.BillingState == null ? '' : ',' + lstCase.get(0).Account.BillingState) 
                  + (lstCase.get(0).Account.BillingPostalCode == null ? '' : ',' + lstCase.get(0).Account.BillingPostalCode);
            site_StreetAdd =  (lstCase.get(0).Account.BillingStreet == null ? '' : lstCase.get(0).Account.BillingStreet);
            System.Debug('List first value  is ' +lstCase.get(0).Contact.FirstName );
              
            //site_ContactName = lstCase.get(0).Contact.Name;
            //site_ContactFirstName = lstCase.get(0).Contact.FirstName;
            //site_ContactLastName = lstCase.get(0).Contact.LastName;
            //site_phone = lstCase.get(0).Contact.Phone;
            //site_Email = lstCase.get(0).Contact.Email;
        }
        //From the case field "Partner Account" get to the appropriate dealer account and pull Job Supervisor and 
        //all associated dealer information
        if(casePartnerAccount != null){
            List<Contact> lstContact = new List<Contact>([Select Id, Phone, Name, Account.Name, Account.Type, MailingState, MailingPostalCode, MailingCity, Email, AccountId From Contact where AccountId=:casePartnerAccount limit 1]);
            if(lstContact.size()>0){
                Contact jobSupervisor = lstContact.get(0);
                JobSupervisor_Company = jobSupervisor.Account.Name ;
                JobSupervisor_Email = jobSupervisor.Email ; 
                JobSupervisor_Phone =  jobSupervisor.Phone ;
                JobSupervisor_CityStateZip = jobSupervisor.MailingCity+' '+ jobSupervisor.MailingState +' '+ jobSupervisor.MailingPostalCode;
                inspection.Partner_Contact__c = jobSupervisor.Id;
                partnerContactName = jobSupervisor.Name;
                InspectionDealerTier = jobSupervisor.Account.Type;
             }
        } 
        //From the case field "Account Name" get to the appropriate end customer account and pull 
        //address and contact information.
        
        if(accountId != null){
              List<Contact> lstContact2 = new List<Contact>([Select Id, Phone, FirstName, LastName, Name, Account.Name, MailingState, MailingPostalCode, MailingCity, Email, AccountId From Contact where AccountId=:accountId limit 1]);
              System.Debug('List 2 size is ' +lstContact2 );
              if(lstContact2.size()>0){
              		
                  Contact customerContact = lstContact2.get(0);
                  System.Debug('List 2 size is value customer  ' +customerContact.Name + '   ' + customerContact.FirstName + '    ' + customerContact.LastName + '   ' + customerContact.Phone + '   ' + customerContact.Email );
                  site_ContactName = customerContact.Name;
                  site_ContactFirstName = customerContact.FirstName;
                  site_ContactLastName = customerContact.LastName;
                  site_phone = customerContact.Phone;
                  site_Email = customerContact.Email;
                  
                  /**
                  List<Contact_Site__c> lstContactSite = new List<Contact_Site__c>([Select Contact__c From Contact_Site__c where Contact__c=:customerContact.Id]);
                  if(lstContactSite.Size()>0){
                  }**/
              } 
        }    
    }    
  }
  
  //function which used to print Resedential type inspection
  public PageReference printResidential(){
    PageReference pr ;
    if(inspectionId != null){
      pr = new PageReference('/apex/InspectionReportNewPdf?id='+ inspectionId);
      
    }
    else if(caseId != null){
        pr = new PageReference('/apex/InspectionReportNewPdf?caseId='+ caseId);
    }
    pr.setRedirect(true);
    return pr;
  }
  //function which used to print Commercial type inspection
   public PageReference printCommercial(){
    PageReference pr ;
    if(inspectionId != null){
      pr = new PageReference('/apex/InspectionReport_Commercial_PDF_1?id='+ inspectionId);
      
    }
    else if(caseId != null){
        pr = new PageReference('/apex/InspectionReport_Commercial_PDF_1?caseId='+ caseId);
    }
    pr.setRedirect(true);
    return pr;
   }
   //////////////////////////////////////////////////////////////////////////
   // Add Function to send email to Dealer through "Send to Dealer" button //
   //////////////////////////////////////////////////////////////////////////
    public PageReference SendMailtoDealer(){
        
        try{
            blob content;
            String fileName = '';
            if(inspectionRec.Id != null){
               content = getContentForInspectionPDF();
               fileName = inspection.Inspection_Name__c + '.pdf';
            }
            
            sendEmail(content,fileName);
            //addAttachment(content,fileName);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
            return null;
        }
        return null;
        //return new ApexPages.Standardcontroller(inspectionRec).cancel();
        
    }
    
    ///////////////////////////////////////////////////////////////////
    //Method responsible for generating Inspection Content as PDF and return
    //////////////////////////////////////////////////////////////////
    private blob getContentForInspectionPDF(){
        PageReference pageRef = new PageReference('/apex/InspectionreportNewPdf');
        pageRef.getParameters().put('id', inspectionRec.Id);
        transient blob content = pageRef.getContent();
        return content;
    }
    
    public List<Attachment> CheckInspectionAttachment(){
    	
    	List<Attachment> lstInspectionAttach = [Select id,Name,Body,ParentId from Attachment where ParentId =: inspectionid];
    	return lstInspectionAttach;
    	
    }
    
    public void fillAttachfilelist() {
    	
    	List<Attachment> lstattached = CheckInspectionAttachment();
    	setattachfiles.clear();
    	setattachfiles = new Set<String>();
    	isAttached = false;
    	if (lstattached.size() > 0) {
    		isAttached = true;
    		for (Attachment objAttach :  lstattached) {
                setattachfiles.add(objAttach.Name);
           }
    	}
    }
    
    ///////////////////////////////////////////////////////////////////
    //Method responsible for attaching a PDF doc with Inspection Record
    //////////////////////////////////////////////////////////////////
    private void sendEmail(blob content,String fileName){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> lstAttachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment attach ;
        if ( sendEmailToUser != null && sendEmailToUser != '') {
            List<String> strEmailTo = new List<String>();
            strEmailTo.add(sendEmailToUser);
        	//strEmailTo.add('lagarwal@appirio.com');
            mail.setToAddresses(strEmailTo); //JobSupervisor_Email
        }
        
        System.Debug('----inspection.Name in sendemail----' + fileName);
        System.Debug(' PDF blob size in sendemail----' + content.size() );
        
        if(content.size() > 0 && fileName != '' ) {
           attach = new Messaging.EmailFileAttachment();
           attach.setBody(content);
           attach.setFileName(fileName);
           lstAttachments.add(attach);
           
        }
        //  mapAttachments.put(filename, content);
        
        if ( strEmailDealerCC != null && strEmailDealerCC != '') {
            
            List<String> lstCC = strEmailDealerCC.split(';');
            mail.setCcAddresses(lstCC);
        }
        if ( strEmailDealerBcc != null && strEmailDealerBcc != '') {
            
            List<String> lstBcc = strEmailDealerBcc.split(';');
            mail.setBccAddresses(lstBcc);
        }
        
        mail.setSubject(MAIL_SUBJECT);
        mail.setPlainTextBody(strEmailBody );
        // Specify the address used when the recipients reply to the email.
        if(site_Email != null)
            mail.setReplyTo(currentUserEmail); //site_Email
        
        System.Debug('--- total attachnment in send email function ---' +lstAttachs.size());
         
        List<Attachment> lstInsAttach = CheckInspectionAttachment();
        if ( lstInsAttach.size() > 0) {
        	
        	for (Attachment objAttach :  lstInsAttach) {
                
                attach = new Messaging.EmailFileAttachment();
                attach.setBody(objAttach.body);
                attach.setFileName(objAttach.Name);
                lstAttachments.add(attach);
            }
        }
        if (lstAttachments.size() > 0 ) {
            System.Debug('--- total lstAttachments ---' +lstAttachments.size());
            mail.setFileAttachments(lstAttachments);
        }
       
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        isClosed = true;
        if ( lstInsAttach.size() > 0) {
        	
        	delete lstInsAttach;
        }
            
    }
   
  /*  private Boolean CheckUserTSEReviewer() {
        
        String SteUserID = UserInfo.getUserId();
        User loggedUser = [Select id, Name,Email, UserRole.Name, Profile.Name from User where id = :SteUserID];
        
        
        System.Debug ('---loggedUser.UserRole.Name---' + loggedUser.UserRole.Name);
        System.Debug ('---this.inspection.isSaveByTSE__c---' + this.inspection.isSaveByTSE__c);
        System.Debug ('---loggedUser.id---' + loggedUser.id);
        System.Debug ('---inspection.Reviewer__c---' + inspection.Reviewer__c);
        if ( loggedUser != null && (loggedUser.UserRole.Name == 'Technical Services Engineer' || loggedUser.UserRole.Name == 'Applications Engineering')
             && loggedUser.id == inspection.Reviewer__c) {
            
             return true;
        }
        else 
            return false;
        
    }*/
    
    private String CheckUserRole() {
        
        String SteUserID = UserInfo.getUserId();
        User loggedUser = [Select id, Name,Email, UserRole.Name, Profile.Name from User where id = :SteUserID];
        if(loggedUser.UserRole.Name == 'Inspection Specialist' || loggedUser.UserRole.Name == 'Technical Services Engineer' || loggedUser.UserRole.Name == 'Applications Engineering' || (loggedUser.UserRole.Name == 'Logistics Support' && currentUserName.contains('Neil Pamulaklakin'))) {
            currentUserEmail = 'inspections@sunpowercorp.com';
        }
        else
            currentUserEmail = loggedUser.Email;
            
        if ( loggedUser != null ) {
            
            String usrRole = loggedUser.UserRole.Name;
            currentUserName = loggedUser.Name;
             return usrRole;
        }
        else 
            return 'no role';
        
    }
    
    private String SetSendEmailTo(){
        
        userRole = CheckUserRole();
        String emailTo;
        if(userRole != 'no role' && inspection.id != null) {
            
            if(userRole == 'Inspection Specialist' || (userRole.trim() == 'Logistics Support' && currentUserName.contains('Neil Pamulaklakin')))
                emailTo = inspection.Contact__r.Email;
            else if(userRole == 'Inspector')
                emailTo = Reviewer_Email;
            else if (userRole == 'Technical Services Engineer' || userRole =='Applications Engineering') {
                emailTo = JobSupervisor_Email;
            }
                
        }
        return emailTo;
    }
    
    public void SetInspectionReportName(){
    	
    }
    
    private class ClsAttachfile {
        
        public  blob blbContent {get;set;}
        public String fileName {get;set;}
    }
   
}