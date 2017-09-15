// *********************************************************************
// Name : InspectionReportEUController 
// Created On : 26 Oct 2010
// Created By : Appirio
// Implementation: Controller class for InspectionReportEU, InspectionReportEUPdf Page.
//  This Page has been implemented under case : 00045421
// ***** *****************************************************************
public class InspectionReportEUController {

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
  public Boolean isItaly{get;set;}    
  public Boolean isGermany{get;set;}
  public string selectedInspectionType{get ;set ;}  
  public String siteName {get; set;}
  public String lang {get; set;}
  public String country {get; set;}
  public String selLang {get; set;}
  public String message{get; set;}
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
  public string site_Country{get;set;}
  public string selectedInspectorId{get ;set ;}
  public string inspector_Company{get ;set ;}
  public string inspector_Email{get ;set ;}
  public string inspector_Phone{get ;set ;}
  public string selectedReviewerId{get ;set ;}  
  public string Reviewer_Email{get ;set ;}
  public string Reviewer_Phone{get ;set ;}
  public string selectedJobSupervisorId{get ;set ;}
  public string JobSupervisor_Name{get ;set ;}
  public string Reviewer_Name{get ;set ;}
  public string JobSupervisor_Company{get ;set ;} 
  public string JobSupervisor_Email {get ;set ;}
  public string JobSupervisor_Phone {get ;set ;}
  public string JobSupervisor_CityStateZip {get ;set ;}
  public String caseId {get; set;}
  public String InspectionDealerTier{get; set;}
  public String inspectionId{get;set;}
  public Decimal SolarBreakerRating {get;set;}
  private PageReference pr;
  
  ApexPages.StandardController stdController;
  
  public Inspection__c inspectionRec{get;set;}  
  public Inspection__c inspectionTSE{get;set;} 
  private String userProfile;

  public String currentUserEmail{ get; set;}
  
  public List<SelectOption> listOptionRoofMaterial{ get; set;}
  public List<SelectOption> listOptionRackType{ get; set;}
  public List<SelectOption> listOptionMountingType{ get; set;}
  public String rack{ get; set;}
  public String roof{ get; set;}
  public String mount{ get; set;}
  
// Variables for email

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
  
  public List<SelectOption> getLanguage() {
    List<SelectOption> listOption =  new List<SelectOption>();
    listOption.add(new SelectOption('en-US', 'English'));
    listOption.add(new SelectOption('it', 'Italy'));
    listOption.add(new SelectOption('de', 'Germany'));
    //listOption.add(new SelectOption('fr', 'French'));
    return listOption;
  }
  
  public String getRack() {
        return rack;
    }
    
    public void setRack(String rack) {
        this.rack = rack;
    }
    
    public String getSelLang() {
        return selLang;
    }
    
    public void setSelLang(String selLang) {
        this.selLang = selLang;
    }
    
    public String getRoof() {
        return roof;
    }
    
    public void setRoof(String roof) {
        this.roof = roof;
    }
    
    public String getMount() {
        return mount;
    }
    
    public void setMount(String mount) {
        this.mount = mount;
    }
    
  public List<SelectOption> getRoofMaterial() {    
    return listOptionRoofMaterial;
  }
  
  public List<SelectOption> getRackType() {    
    return listOptionRackType;
  }
  
  public List<SelectOption> getMountingType() {    
    return listOptionMountingType;
  }
  
  public string partnerContactName{get;set;}
  
  //constructor
  public InspectionReportEUController(ApexPages.StandardController stdController) {
    pr = null;
    currentUserEmail = '';
    SolarBreakerRating = 0;      
    
    this.stdController = stdController;    
    inspectionRec = (Inspection__c) stdController.getRecord();
    if(ApexPages.currentPage().getParameters().get('id')!=null){
            inspectionId = ApexPages.currentPage().getParameters().get('id') ;
            System.Debug(' inspection id show in construtor ---' + inspectionId);            
            List<Inspection__c> lstInspection = new List<Inspection__c>([Select SystemModstamp, Status__c, 
            Site_Type__c, Score__c, Score_Details__c, Residential_SYSTEM_SAFETY_Hazards__c, 
            Residential_SYSTEM_SAFETY_Comments__c, Residential_SYSTEM_SAFETY_ChkBox__c, 
            Residential_Result__c, Residential_ReadingsMeasurements_Comment__c, Residential_Q54_Response__c, 
            Residential_Q54_Comments__c, Residential_Q53_Response__c, Residential_Q53_Comments__c, 
            Residential_Q52_Response__c, Residential_Q52_Comments__c, Residential_Q51_Rating__c, 
            Residential_Q50_Rating__c, Residential_Q49_Rating__c, Residential_Q48_Response__c, 
            Residential_Q48_Comments__c, Residential_Q48_3__c, Residential_Q48_2__c, Residential_Q48_1__c, 
            Residential_Q47_Response__c, Residential_Q47_Comments__c, Residential_Q46_Response__c, 
            Residential_Q46_Comments__c, Residential_Q45_Response__c, Residential_Q45_Comments__c, 
            Residential_Q44_Size__c, Residential_Q44_Quantity__c, Residential_Q44_Distance__c, 
            Residential_Q44_Comments__c, Residential_Q43_Response__c, Residential_Q43_Comments__c, 
            Residential_Q43_3__c, Residential_Q43_2__c, Residential_Q43_1__c, Residential_Q42_Response__c, 
            Residential_Q42_Comments__c, Residential_Q41_Response__c, Residential_Q41_Comments__c, 
            Residential_Q40_Response__c, Residential_Q40_Comments__c, Residential_Q39_Response__c, 
            Residential_Q39_Picklist__c, Residential_Q39_Comments__c, Residential_Q38_Response__c, 
            Residential_Q38_Comments__c, Residential_Q37_Response__c, Residential_Q37_Comments__c, 
            Residential_Q36_Response__c, Residential_Q36_Comments__c, Residential_Q35_Size__c, 
            Residential_Q35_Quantity__c, Residential_Q35_Distance__c, Residential_Q35_Comments__c, 
            Residential_Q34_Response__c, Residential_Q34_Comments__c, Residential_Q33_Response__c, 
            Residential_Q33_Comments__c, Residential_Q32_Response__c, Residential_Q32_Comments__c, 
            Residential_Q31_Response__c, Residential_Q31_EGC_Size__c, Residential_Q31_Comments__c, 
            Residential_Q30_Array_Input_4__c, Residential_Q30_Array_Input_3__c, Residential_Q30_Array_Input_2__c, 
            Residential_Q30_Array_Input_1__c, Residential_Q30_4_2__c, Residential_Q30_4_1__c, Residential_Q30_3_2__c, 
            Residential_Q30_3_1__c, Residential_Q30_2_2__c, Residential_Q30_2_1__c, Residential_Q30_1_2__c, 
            Residential_Q30_1_1__c, Residential_Q29_4__c, Residential_Q29_3__c, Residential_Q29_2__c, 
            Residential_Q29_1__c, Residential_Q28_4__c, Residential_Q28_4_ChkBox__c, Residential_Q28_3__c, 
            Residential_Q28_3_ChkBox__c, Residential_Q28_2__c, Residential_Q28_2_ChkBox__c, Residential_Q28_1__c, 
            Residential_Q28_1_ChkBox__c, Residential_Q27_4__c, Residential_Q27_3__c, Residential_Q27_2__c, 
            Residential_Q27_1__c, Residential_Q26_4__c, Residential_Q26_3__c, Residential_Q26_2__c, 
            Residential_Q26_1__c, Residential_Q25_4__c, Residential_Q25_3__c, Residential_Q25_2__c, 
            Residential_Q25_1__c, Residential_Q24_4__c, Residential_Q24_3__c, Residential_Q24_2__c, 
            Residential_Q24_1__c, Residential_Q23_Comments__c, Residential_Q23_4__c, Residential_Q23_3__c, 
            Residential_Q23_2__c, Residential_Q23_1__c, Residential_Q22_4__c, Residential_Q22_3__c, 
            Residential_Q22_2__c, Residential_Q22_1__c, Residential_Q21_Sky_Conditions__c, Residential_Q20_Time__c, 
            Residential_Q20_Time_Picklist__c, Residential_Q19_Response__c, Residential_Q19_Comments__c, 
            Residential_Q18_Response__c, Residential_Q18_Comments__c, Residential_Q17_Response__c, 
            Residential_Q17_Comments__c, Residential_Q16_Response__c, Residential_Q16_Comments__c, 
            Residential_Q15_Picklist__c, Residential_Q15_Comments__c, Residential_Q14_Picklist__c, 
            Residential_Q13_Picklist__c, Residential_Q12_Picklist__c, Residential_Q12_Comments__c, 
            Residential_Q11_Picklist__c, Residential_Q11_Comments__c, Residential_Q10_Response__c, 
            Residential_Q10_Comments__c, Residential_Q09_Response__c, Residential_Q09_Picklist__c, 
            Residential_Q09_Comments__c, Residential_Q08_Response__c, Residential_Q08_Comments__c, 
            Residential_Q07_Response__c, Residential_Q07_Comments__c, Residential_Q06_Response__c, 
            Residential_Q06_Comments__c, Residential_Q05_Response__c, Residential_Q05_Comments__c, 
            Residential_Q04_D__c, Residential_Q04_Comments__c, Residential_Q04_C__c, Residential_Q04_B__c, 
            Residential_Q04_A__c, Residential_Q03_D__c, Residential_Q03_C__c, Residential_Q03_B__c, 
            Residential_Q03_A__c, Residential_Q02_Text2__c, Residential_Q02_Text2_ChkBox__c, 
            Residential_Q02_Text1__c, Residential_Q02_Text1_ChkBox__c, Residential_Q02_System_Size__c, 
            Residential_Q02_Comments__c, Residential_Q02_Array_Power__c, Residential_Q01_SPR2__c, 
            Residential_Q01_SPR2_ChkBox__c, Residential_Q01_SPR1__c, Residential_Q01_SPR1_ChkBox__c, 
            Residential_MSP_NEC_Labels__c, Residential_MSP_Interior__c, Residential_MSP_Exterior__c, 
            Residential_MOUNTING_Roof_Penetrations__c, Residential_MOUNTING_Problem_Areas__c, 
            Residential_MOUNTING_L_Brackets__c, Residential_INVERTER_TO_MSP_Problem_Area__c, 
            Residential_INVERTER_TO_MSP_Conduit__c, Residential_INVERTER_Overview__c, 
            Residential_INVERTER_Interior_Grounding__c, Residential_INVERTER_Interior_AC_DC__c, 
            Residential_INVERTER_DC_System__c, Residential_DC_DISCONNECT_Problem_Areas__c, 
            Residential_DC_DISCONNECT_NEC_Labels__c, Residential_DC_DISCONNECT_Interior__c, 
            Residential_DC_DISCONNECT_Exterior__c, Residential_Commission_Date__c, 
            Residential_Auto_Calculations_4_4__c, Residential_Auto_Calculations_4_3__c, 
            Residential_Auto_Calculations_4_2__c, Residential_Auto_Calculations_4_1__c, 
            Residential_Auto_Calculations_3_4__c, Residential_Auto_Calculations_3_3__c, 
            Residential_Auto_Calculations_3_2__c, Residential_Auto_Calculations_3_1__c, 
            Residential_Auto_Calculations_2_4__c, Residential_Auto_Calculations_2_3__c, 
            Residential_Auto_Calculations_2_2__c, Residential_Auto_Calculations_2_1__c, 
            Residential_Auto_Calculations_1_4__c, Residential_Auto_Calculations_1_3__c, 
            Residential_Auto_Calculations_1_2__c, Residential_Auto_Calculations_1_1__c, 
            Residential_ARRAY_Rooftop__c, Residential_ARRAY_Profile__c, Residential_ARRAY_Problem_Areas__c, 
            Residential_ARRAY_Pathfinder__c, Residential_ARRAY_Overall__c, Residential_ARRAY_J_Box__c, 
            Residential_ARRAY_INVERTER_Problem_Areas__c, Residential_ARRAY_INVERTER_PV_Source__c, 
            Residential_ARRAY_INVERTER_DC_Conduit__c, Residential_ARRAY_Grounding__c, Residential_ADDITIONAL_COMMENTS__c, 
            Residential_AC_DISCONNECT_Problem_Areas__c, Residential_AC_DISCONNECT_NEC_Labels__c, Residential_AC_DISCONNECT_Interior__c, 
            Residential_AC_DISCONNECT_Exterior__c, Partner_Contact__c, OwnerId, Name, Last_Modified_Date__c, LastModifiedDate, 
            LastModifiedById, LastActivityDate, IsDeleted, Integration_ID__c, Inspection_Type__c, Inspection_Time__c, 
            Inspection_Status__c, Inspection_Date__c, Id, Customer_Communication__c, CurrencyIsoCode, CreatedDate, 
            CreatedById, Contact__c, Contact__r.Name, Compliance_Result__c, Comm_Q9_3_Field__c, Comm_Q9_2_Field__c, 
            Comm_Q9_1_Field__c, Comm_Q8_8_Field__c, Comm_Q8_7_Field__c, Comm_Q8_5_Field__c, Comm_Q8_4_Field__c, 
            Comm_Q8_3_Field__c, Comm_Q8_2_Field__c, Comm_Q8_1_Field__c, Comm_Q7_13_Field__c, Comm_Q7_12_Field__c, 
            Comm_Q7_11_Field__c, Comm_Q7_10_Field__c, Comm_Q7_09_Field__c, Comm_Q7_08_Field__c, Comm_Q7_07_Field__c, 
            Comm_Q7_06_Field__c, Comm_Q7_05_Field__c, Comm_Q7_04_Field__c, Comm_Q7_03_Field__c, Comm_Q7_02_Field__c, 
            Comm_Q7_01b_Field__c, Comm_Q7_01a_Field__c, Comm_Q6_12_Field__c, Comm_Q6_11_Field__c, Comm_Q6_10_Field__c, 
            Comm_Q6_09_Field__c, Comm_Q6_08_Field__c, Comm_Q6_07_Field__c, Comm_Q6_06_Field__c, Comm_Q6_05_Field__c, 
            Comm_Q6_04_Field__c, Comm_Q6_03_Field__c, Comm_Q6_02_Field__c, Comm_Q6_01_Field__c, Comm_Q6_00_Field__c, 
            Comm_Q5_19_Field__c, Comm_Q5_18_Field__c, Comm_Q5_17_Field__c, Comm_Q5_16_Field__c, Comm_Q5_15_Field__c, 
            Comm_Q5_14_Field__c, Comm_Q5_13_Field__c, Comm_Q5_12_Field__c, Comm_Q5_11_Field__c, Comm_Q5_10_Field__c, 
            Comm_Q5_09_Field__c, Comm_Q5_08_Field__c, Comm_Q5_07_Field__c, Comm_Q5_06_Field__c, Comm_Q5_05_Field__c, 
            Comm_Q5_04_Field__c, Comm_Q5_03_Field__c, Comm_Q5_02_Field__c, Comm_Q5_01_Field__c, Comm_Q4_5_Field__c, 
            Comm_Q4_4_Field__c, Comm_Q4_3_Field__c, Comm_Q4_2_Field__c, Comm_Q4_1_Field__c, Comm_Q4_0_Field__c, 
            Comm_Q3_16_Field__c, Comm_Q3_13_Field__c, Comm_Q3_12_Field__c, Comm_Q3_11_Field__c, Comm_Q3_10_Field__c, 
            Comm_Q3_09_Field__c, Comm_Q3_08_Field__c, Comm_Q3_07_Field__c, Comm_Q3_06_Field__c, Comm_Q3_05_Field__c, 
            Comm_Q3_04_Field__c, Comm_Q3_03_Field__c, Comm_Q3_02_Field__c, Comm_Q3_01_Field__c, Comm_Q2_10_Field__c, 
            Comm_Q2_09_Field__c, Comm_Q2_07_Field__c, Comm_Q2_06b_Field__c, Comm_Q2_06a_Field__c, Comm_Q2_06_Field__c, 
            Comm_Q2_05_Field__c, Comm_Q2_04_4_2__c, Comm_Q2_04_4_1__c, Comm_Q2_04_3_2__c, Comm_Q2_04_3_1__c, 
            Comm_Q2_04_2_2__c, Comm_Q2_04_2_1__c, Comm_Q2_04_1__c, Comm_Q2_03_Field__c, Comm_Q2_02_Field__c, 
            Comm_Q2_01_Field__c, Comm_Q1_9_Field__c, Comm_Q1_8_Field__c, Comm_Q1_7_Field__c, Comm_Q1_6_Field__c, 
            Comm_Q1_5e_Field__c, Comm_Q1_5d_Field__c, Comm_Q1_5c_Field__c, Comm_Q1_5b_Field__c, Comm_Q1_5a_Field__c, 
            Comm_Q1_5_Field__c, Comm_Q1_4_Field__c, Comm_Q1_3_Field__c, Comm_Q1_2_Number2__c, Comm_Q1_2_Number1__c, 
            Comm_Project__c, Comm_ProjectSize__c, Comm_OtherPresent__c, Comm_BuildingOccupancy__c, Comm_As_Builts__c, 
            Case__c,Reviewer__c , Res_Per_Monitoring_Sys__c, Res_Per_Monitoring_Comments__c, Res_Ambrient__c, 
            Res_GroundPath_Inverter_MSP__c, Res_GroundPath_Inverter_MSP_Comment__c, Res_Consumtion_Monitoring_Sys__c, 
            Res_Consumtion_Monitoring_Comments__c,Res_flashing_lights__c, Res_flashing_lights_Comments__c, 
            Res_External_Bonding__c, Res_External_Bonding_Comments__c, Res_Mounting_Location_Other__c, 
            Res_Roofing_Material_Other__c, Res_Rack_Type_Other__c, Res_Mount_Type_Other__c,IsSaveByTSE__c, 
            InspectionNameType__c, Inspection_Name__c, InspectionByTSE__c, InspectionByTSE__r.Id, InspectionSavedBy__c            
            ,Result__c,Residential_Degree_of_roof_integration__c,Residential_Percentage_of_roof_integraci__c,
            Residential_Non_SPWR_Inverter__c,Residential_Inverter_operating_hours__c,Residential_String_Parallel_1__c,
            Residential_String_Parallel_2__c,Residential_String_Parallel_3__c,Residential_String_Parallel_4__c,
            Residential_Module_design_recomm__c,Residential_Module_design_recomm_Comment__c,
            Residential_Grounding_kit_installed__c,Residential_Grounding_kit_installed_Comm__c,
            Residential_Phases_balanced__c,Residential_Phases_balanced_Comment__c,Residential_Cable_size__c,
            Residential_Inverter_located__c,Residential_Inverter_located_Comment__c,Residential_laying_system__c,
            Residential_Overvoltage_protection_Q_40__c,Residential_Conductors_Insulated__c,
            Residential_Conductors_Insulated_Comment__c,Residential_Conductors_Installed__c,
            Residential_Conductors_Installed_Comment__c,Residential_DC_disconnects_rated__c,
            Residential_DC_disconnects_rated_Comment__c,Residential_PV_disconnects_labeled__c,
            Residential_PV_disconnects_labeled_Comme__c,Residential_Overvoltage_protection_Q_46__c,
            Residential_PV_Breaker__c, Resindential_Photo_MSP__c, Residential_Photo_Labels__c,Residential_Inverter_to_MSP_wiring__c, 
            Res_Mount_Type_text__c, Res_Rack_Type_text__c, Res_Roofing_Material_text__c, Residential_EU_Q13_Comments__c,
            Res_Roofing_Material_Comment__c, Res_Rack_Type_Comment__c, Res_Array_Invertor_Conductor_Size__c, Res_Invertor_MSP_Size__c, 
            Residential_Photo_Labels_de__c, Res_Grounding_Cable_Size__c, Residential_Q46_Distance_EU__c, Res_MSP_to_All_Size__c, Residential_Q46_Quantity_EU__c,
            Residential_Q01_SPR1_EU__c, Residential_Q01_SPR2_EU__c, Residential_Q28_1_EU__c, Residential_Q28_2_EU__c, Residential_Q28_3_EU__c, 
            Residential_Q28_4_EU__c, Res_Photo_array_to_mounting__c, Res_Photo_Mounting__c,
            Res_Photo_Array_to_Inverter__c, Res_Photo_Inverter__c
            //Start 99117
            , Overvoltage_protection_Comments__c
            //End 99117
             
            From Inspection__c where Id=:inspectionId]);
                   
            if(lstInspection.size()>0){
                this.inspection = lstInspection.get(0);                  
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
      cCase = [select id, RecordTypeId, job_supervisor_Email__c,Account.BillingPostalCode
        , Account.BillingStreet
        , Account.BillingState
        , Account.BillingCity,AccountId
        , Account.BillingCountry, Review_By__c, ContactId, Job_Supervisor_Name__c
        , Partner_Account__c
        , Contact.Email, Contact.Phone, Contact.Name
        , Contact.FirstName, Contact.LastName from Case where id =:this.inspection.Case__c];
      
      caseId = cCase.Id ;
      if(cCase.Account!=null)
        country = cCase.Account.BillingCountry;
       site_CityStateZip =  (cCase.Account.BillingCity == null ? '' : cCase.Account.BillingCity)  
                  + (cCase.Account.BillingState == null ? '' : ',' + cCase.Account.BillingState) 
                  + (cCase.Account.BillingPostalCode == null ? '' : ',' + cCase.Account.BillingPostalCode);        
        if(inspection.Reviewer__c==null)
            inspection.Reviewer__c = cCase.Review_By__c;
        if(inspection.Partner_Contact__c==null)
            inspection.Partner_Contact__c = cCase.Job_Supervisor_Name__c;        
       site_StreetAdd =  (cCase.Account.BillingStreet == null ? '' : '' + cCase.Account.BillingStreet) ;        
      
      inspection.Residential_Q04_C__c = null; 
      showInspectionTypeblock = false ;
      showSiteTypeblock = false ;
      
      selectedInspectorId = this.inspection.Contact__c;      
      
      if ( inspection.Residential_Q49_Rating__c != null && inspection.Residential_Q50_Rating__c != null && Decimal.valueOf(inspection.Residential_Q49_Rating__c) > 0 && Decimal.valueOf(inspection.Residential_Q50_Rating__c) > 0 )
        SolarBreakerRating = (Decimal.valueOf(inspection.Residential_Q49_Rating__c) * 1.2) - Decimal.valueOf(inspection.Residential_Q50_Rating__c);
        
      if( selectedInspectorId != null ){
         refreshInspector();
      }
      
      if(cCase.accountId != null){
              List<Account> lstAccount2 = new List<Account>([Select Id, Phone, Name, Email__c  From Account where Id=:cCase.accountId limit 1]);
              if(lstAccount2.size()>0){
                  Account customerAccount = lstAccount2.get(0);
                  site_ContactName = customerAccount.Name;                  
                  site_phone = customerAccount.Phone;
                  site_Email = customerAccount.Email__c ;                  
              }
        }
       
      if(this.inspection.site_type__c =='Residential'){
        showResidentialReportBlock = true ;
      }else{
        showCommercialReportBlock = true;
      }
    }
    selectedReviewerId = this.inspection.Reviewer__c;  
    selectedJobSupervisorId = inspection.Partner_Contact__c;
    if( selectedReviewerId != null ){
         refreshReviewer();
      }
      
      if( selectedJobSupervisorId != null ){
        refreshJobSupervisor();
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
    
    system.debug(loggingLevel.INFO, 'Country-> ' + country);
    listOptionRackType = new List<SelectOption>();
    listOptionMountingType = new List<SelectOption>();
    listOptionRoofMaterial = new List<SelectOption>();
    
    rack = inspection.Res_Rack_Type_text__c;
    roof = inspection.Res_Roofing_Material_text__c;
    mount = inspection.Res_Mount_Type_text__c;
    
    setCountry(country);
    //for pdf output
    String str = ApexPages.currentPage().getParameters().get('lang');
    if(str!=null && str !=''){
        selLang = str;
        lang = str;
        if(str == 'en-US')
            country = 'English';
        if(str == 'it')
            country = 'Italy';
        if(str == 'de')
            country = 'Germany';
    }
    //for pdf output    
    system.debug(loggingLevel.INFO, 'isItaly-> ' + isItaly);
    system.debug(loggingLevel.INFO, 'isGermany-> ' + isGermany);
    
  }
  public void setCountry(String count){
    SelectOption noneOption = new SelectOption('', '--None--');
    listOptionRoofMaterial.clear();
    listOptionRackType.clear();
    listOptionMountingType.clear();
    if(count == 'Italy'){
        SelectOption otherOption = new SelectOption('Other...', 'Other...');
        SelectOption naOption = new SelectOption('NA', 'NA');
        
        listOptionRoofMaterial.add(noneOption);
        listOptionRoofMaterial.add(new SelectOption('Tile - Portoghese', 'Tile - Portoghese'));
        listOptionRoofMaterial.add(new SelectOption('Tile – Roman', 'Tile – Roman'));
        listOptionRoofMaterial.add(new SelectOption('Tile – Marsigliese', 'Tile – Marsigliese'));       
        listOptionRoofMaterial.add(new SelectOption('Tile Marsigliesi', 'Metal Corrugate'));
        listOptionRoofMaterial.add(otherOption);
        listOptionRoofMaterial.add(naOption);
        
        listOptionRackType.add(noneOption);
        listOptionRackType.add(new SelectOption('Mounting Systems', 'Mounting Systems'));
        listOptionRackType.add(new SelectOption('Hilti', 'Hilti'));
        listOptionRackType.add(new SelectOption('Shuco', 'Shuco'));
        listOptionRackType.add(new SelectOption('Solrif ', 'Solrif '));
        listOptionRackType.add(new SelectOption('Fischer', 'Fischer'));
        listOptionRackType.add(otherOption);
        listOptionRackType.add(naOption);
        
        listOptionMountingType.add(noneOption);
        listOptionMountingType.add(new SelectOption('Roof Hook', 'Roof Hook'));
        listOptionMountingType.add(new SelectOption('None', 'None'));
        listOptionMountingType.add(new SelectOption('True Bolt', 'True Bolt'));
        listOptionMountingType.add(otherOption);
        listOptionMountingType.add(naOption);
        selLang = 'it';
        isItaly = true;
        isGermany = false;
        lang = 'it';
        this.message = 'QA Field Inspection Report ITALY '+System.today().year();
    }else if(count == 'Germany'){
    //}else if(lang=='de'){
        SelectOption andereOption = new SelectOption('Andere...', 'Andere...');
        listOptionRoofMaterial.add(noneOption);
        listOptionRoofMaterial.add(new SelectOption('Tonziegel', 'Tonziegel'));
        listOptionRoofMaterial.add(new SelectOption('Betonziegel', 'Betonziegel'));
        listOptionRoofMaterial.add(new SelectOption('Biberschwanz Ziegel', 'Schiefer'));
        listOptionRoofMaterial.add(new SelectOption('Bitumen', 'Bitumen'));
        listOptionRoofMaterial.add(andereOption);
        
        listOptionRackType.add(noneOption);
        listOptionRackType.add(new SelectOption('Mounting Systems', 'Mounting Systems'));
        listOptionRackType.add(new SelectOption('Schletter', 'Schletter'));
        listOptionRackType.add(new SelectOption('Hilti', 'Hilti'));
        listOptionRackType.add(new SelectOption('Schüco', 'Schüco'));
        listOptionRackType.add(new SelectOption('Fischer', 'Fischer'));
        listOptionRackType.add(andereOption);
        
        listOptionMountingType.add(noneOption);
        listOptionMountingType.add(new SelectOption('Dachhaken', 'Dachhaken'));
        listOptionMountingType.add(new SelectOption('Schwerlast-DH', 'Schwerlast-DH'));
        listOptionMountingType.add(new SelectOption('Biberschwanz-DH', 'Biberschwanz-DH'));
        listOptionMountingType.add(new SelectOption('Stockschraube', 'Stockschraube'));
        listOptionMountingType.add(andereOption);
        selLang = 'de';
        isItaly = false;
        isGermany = true;
        lang = 'de';
        this.message = 'QA Field Inspection Report Germany '+System.today().year();
    }else{
        isItaly = false;
        isGermany = false;
    }
  }
  public PageReference redirect() {      
    return pr;
  }
  
  public PageReference populateLanguage() {
    lang = selLang;
    if(lang!=null && lang !=''){        
        if(lang == 'en-US')
            country = 'English';
        if(lang == 'it')
            country = 'Italy';
        if(lang == 'de')
            country = 'Germany';
    }
    setCountry(country);
    System.debug('In Populate Language');    
    return null;
  }
  
  private string retrieveInspectionTypeRecordId() {     
    List<RecordType> lstRecordType = [SELECT Id FROM RecordType 
                                      WHERE SobjectType = 'Case' 
                                      And (Name ='New Inspections')];
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
  
  public pageReference save_EU(){    
    saveInspectionDetail_EU();
    
    PageReference pr = new PageReference( '/'+cCase.Id) ;
    pr.setRedirect(true) ;
    return pr ;
  }
  public PageReference cancelInspection_EU() {
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
  private void saveInspectionDetail_EU(){
    
    inspection.Res_Mount_Type_text__c = mount;
    inspection.Res_Rack_Type_text__c = rack;
    inspection.Res_Roofing_Material_text__c = roof;
    
      
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
        
        if(isNew){
            cCase.setOptions(dmo);
            Database.upsert(cCase);
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          req1.setObjectId(cCase.id);
          Approval.ProcessResult result = Approval.process(req1);
        }        
        inspection.Case__c = cCase.Id ;
        inspection.InspectionNameType__c = JobSupervisor_Company + '_' + site_ContactLastName;
        inspection.InspectionSavedBy__c = '';
        insert  inspection ;
      }else{  //Update Condition       
        
        update inspection ;  
        
        System.Debug('-- Inspection id value in save function -----' + inspection.Id);    
    } 
        
  }  
  
  
  //called on save button click
  public PageReference QuickSave_EU(){
      saveInspectionDetail_EU();
      System.Debug('------ inspection.Id-----'+ inspection.Id);
      if(inspection.Id != null ){
        inspectionId = inspection.Id;
        if( inspectionTSE != null && inspectionTSE.Id != null)
           inspectionId = inspectionTSE.Id;
        PageReference pr = new PageReference('/apex/InspectionReportEU?isEdit=true&id='+inspectionId+'&lang='+lang);
        
        pr.setRedirect(true);
        return pr;
      }
      return null;
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
             List<User> ReviewerList = [Select Name, Phone, Email From User Where id = : selectedReviewerId] ;
                                     
              if (ReviewerList.size() == 0)
                return null;
      
            User Reviewer = ReviewerList[0];
            Reviewer_Name = Reviewer.Name;
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
          
      JobSupervisor_Name = jobSupervisor.Name;
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
        , Account.BillingCountry, Review_By__c, Job_Supervisor_Name__c//added for case # 00045421
        , Partner_Account__c
        , Contact.Email, Contact.Phone, Contact.Name
        , Contact.FirstName, Contact.LastName
        , ContactId from Case where Id=:caseId]);
        
        if(lstCase.Size()>0){
            if(lstCase.get(0).Account!=null)            
                country = lstCase.get(0).Account.BillingCountry;
            if(inspection.Reviewer__c==null)
                inspection.Reviewer__c = lstCase.get(0).Review_By__c;
            if(inspection.Partner_Contact__c==null)
                inspection.Partner_Contact__c = lstCase.get(0).Job_Supervisor_Name__c; 
            casePartnerAccount = lstCase.get(0).Partner_Account__c;
            accountId = lstCase.get(0).AccountId;
            site_CityStateZip =  (lstCase.get(0).Account.BillingCity == null ? '' : lstCase.get(0).Account.BillingCity)  
                  + (lstCase.get(0).Account.BillingState == null ? '' : ',' + lstCase.get(0).Account.BillingState) 
                  + (lstCase.get(0).Account.BillingPostalCode == null ? '' : ',' + lstCase.get(0).Account.BillingPostalCode);
            site_StreetAdd =  (lstCase.get(0).Account.BillingStreet == null ? '' : lstCase.get(0).Account.BillingStreet);            
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
                //inspection.Partner_Contact__c = jobSupervisor.Id;
                partnerContactName = jobSupervisor.Name;
                InspectionDealerTier = jobSupervisor.Account.Type;
             }
        } 
        //From the case field "Account Name" get to the appropriate end customer account and pull 
        //address and contact information.
        
        if(accountId != null){
              List<Account> lstAccount2 = new List<Account>([Select Id, Phone, Name, Email__c  From Account where Id=:accountId limit 1]);
              if(lstAccount2.size()>0){
                  Account customerAccount = lstAccount2.get(0);
                  site_ContactName = customerAccount.Name;                  
                  site_phone = customerAccount.Phone;
                  site_Email = customerAccount.Email__c ;                  
              }
        }   
    }    
  }
  
  //function which used to print EU inspection
  public PageReference printResidential_EU(){
    PageReference pr ;
    if(inspectionId != null){
      pr = new PageReference('/apex/InspectionReportPdfEU?id='+ inspectionId + '&lang='+lang);
      
    }
    else if(caseId != null){
        pr = new PageReference('/apex/InspectionReportPdfEU?caseId='+ caseId + '&lang='+lang);
    }
    pr.setRedirect(true);
    return pr;
  } 
  
    private String CheckUserProfile() {
        
        String SteUserID = UserInfo.getUserId();
        User loggedUser = [Select id, Name,Email, UserRole.Name, Profile.Name from User where id = :SteUserID];
        currentUserEmail = loggedUser.Email;
        if ( loggedUser != null ) {
            
            String userProf = loggedUser.Profile.Name;
             return userProf;
        }
        else 
            return 'no profile';
        
    }

}