/***************************************
***PR-01808
***Last Modified- Kapil Goutam
***Last Modified On - May 30 2009
***Description- Controller Class
****************************************/
public class NewPartnerScorecardController{
  private Boolean isCVARApplication;
  
  //properties 
  public Partner_Application__c partnerObj{get; set;}
  public String id{get;set;}
  public Boolean autoComplete{get;set;}
  public NewPartnerScorecardController(ApexPages.StandardController controller){
    isCVARApplication = false;
    String sTmp = ApexPages.CurrentPage().getURL();
    if (sTmp != null && sTmp.toLowerCase().contains('_cvar')) {
        isCVARApplication = true;
    }
    System.debug('Debug: isCVARApplication ' + isCVARApplication);
    
    //this.partnerObj = (Partner_Application__c)controller.getRecord();
    //partnerObj = new Partner_Application__c();
    if(ApexPages.currentPage().getParameters().get('Type') != null){
        String bgsmType  = ApexPages.currentPage().getParameters().get('Type');
        if(bgsmType == 'BGSM'){
            autoComplete = true;
        }else{
            autoComplete = false;
        }
    }else{
        autoComplete = false;
    }
    List<Partner_Application__c> lstPartnerApps = new List<Partner_Application__c>();
    if(ApexPages.currentPage().getParameters().get('id') != null){
        id = ApexPages.currentPage().getParameters().get('id');
        
        //get partner object by query        
        lstPartnerApps = [select Id, Name, Company_Name__c, Application_Date__c, Owner__c, RSM__c, Meeting_Attendee_Name_1__c, 
        Meeting_Attendee_Name_2__c, Meeting_Attendee_Name_3__c, Meeting_Attendee_Name_4__c, Meeting_Attendee_Title_1__c, 
        Meeting_Attendee_Title_2__c,Meeting_Attendee_Title_3__c, Meeting_Attendee_Title_4__c, Relevant_contractors_licenses_held__c, Full_time_employees__c, Qualifies_for_100000_credit_limit__c, 
        Relevant_Insurance__c, No_major_partner_faulted_litigation__c, At_least_one_branded_truck__c, Formal_office_workshop_warehouse__c, Qualifies_for_250000_credit_limit__c,
        Business_focused_on_PV__c, Greater_than_30_CAGR_over_last_2_years__c, Growth_plan_greater_than_50_of_median__c,
        At_least_one_mid_level_employee__c, At_least_one_dedicated_salesperson__c, At_least_one_marketing_person__c, 
        Basic_sales_collateral__c, Basic_commercial_sales_collateral__c, Basic_Website__c, Q_minus_3_Total_Partner_Sales_kW__c, Q_minus_2_Total_Partner_Sales_kW__c,
        Q_minus_1_Total_Partner_Sales_kW__c, Q0_Total_Partner_Sales_kW__c, Q_plus_1_Total_Partner_Sales_kW__c,
        Q_plus_2_Total_Partner_Sales_kW__c, Q_plus_3_Total_Partner_Sales_kW__c, Q_plus_4_Total_Partner_Sales_kW__c, 
        Q_minus_3_SunPower_Sales_to_Partner_kW__c, Q_minus_2_SunPower_Sales_to_Partner_kW__c, Q_minus_1_SunPower_Sales_to_Partner_kW__c,
        Q0_SunPower_Sales_to_Partner_kW__c, Q_plus_1_SunPower_Sales_to_Partner_kW__c,
        Q_plus_2_SunPower_Sales_to_Partner_kW__c, Q_plus_3_SunPower_Sales_to_Partner_kW__c, 
        Q_plus_4_SunPower_Sales_to_Partner_kW__c, License_Score__c, License_Details__c, 
        License_or_qualification_Score__c, License_or_qualification_Details__c, 
        Litigation_Score__c, Litigation_Details__c, Reputation_Score__c, Reputation_Details__c,
        Engineering_Score__c, Engineering_Details__c, Showroom_Score__c, Showroom_Details__c, 
        Branded_sales_vehicle_Score__c, Branded_sales_vehicle_Details__c, Install_truck_Score__c, 
        Install_truck_Details__c, History_in_PV_Score__c, History_in_PV_Details__c, Signage_Score__c,
        Signage_Details__c, Historic_growth_rate_Score__c, Historic_growth_rate_Details__c, Business_Plan_1_Score__c,
        Business_Plan_1_Details__c, Business_Plan_2_Score__c, Business_Plan_2_Details__c, 
        Well_capitalized_Score__c, Well_capitalized_Details__c, VAR_business_model_Score__c, 
        VAR_business_model_Details__c, Sales_manager_Score__c, Sales_manager_Details__c, 
        Sales_training_Score__c, Sales_training_Details__c, Sales_meetings_Score__c, Sales_meetings_Details__c,
        Sales_process_Score__c, Sales_process_Details__c, Basics_sales_metrics_tracking_Score__c, 
        Basics_sales_metrics_tracking_Details__c, CRM_Score__c, CRM_Details__c, Marketing_Manager_Score__c, 
        Marketing_Manager_Details__c, Sophisticated_sales_collateral_Score__c, Sophisticated_sales_collateral_Details__c,
        Professional_uniforms_Score__c, Professional_uniforms_Details__c, Organized_referral_program_Score__c, 
        Organized_referral_program_Details__c, Sophisticated_website_Score__c, Sophisticated_website_Details__c, 
        Solar_License_Certification__c, Total_Employee_Base__c, Existing_Pending_Litigation__c, Location_1__c,
        Website__c, Marketing_Employees__c, Sales_Employees__c, Manager_Level_Employees__c, Annual_Revenue_1_year_ago_YOY__c,
        Current_Industry__c, Business_Plan__c, Formalized_Referral_Program__c, Manager_Marketing_Employees__c, Projected_current_FY_YOY__c,
        Years_in_Business__c, Consumer_Reporting_Agency__c, Electrician_on_staff__c, Customer_Base__c, CAD_Designer_Available__c, 
        Annual_Revenue_1_year_ago_Score__c, Projected_current_FY_Score__c, Projected_Next_FY_Score__c, Company_Profitable__c, 
        Manager_Sales_Employees__c, New_to_Solar__c, Employees_Details__c, Employees_Score__c, Scorecard_Score__c ,Tabelle_e_abilitazioni_es_46_90__c,Quality_Certification__c, 
        Manager_Employees__c, Tabelle_e_abilitazioni_more_than_5_years__c, Abilitazioni_Score__c, Abilitazioni_Details__c, Commercial_Sales_process_Details__c,
        Commercial_Employees_Score__c, Commercial_Employees_Details__c, Proposal_Package_Score__c, Proposal_Package_Details__c, Commercial_Sales_process_Score__c
        //for case 00039606
        ,Y_0_Total_Partner_Sales_kW__c,PV_Watts_Sold_Q1__c,PV_Watts_Sold_Q2__c,PV_Watts_Sold_Q3__c,PV_Watts_Sold_Q4__c,
        PV_Watts_Sold_last_year__c,PV_Watts_Sold_2_years_ago__c,PV_Watts_Sold_3_years_ago__c,Projected_Revenue_next_Year_in_kW__c, Estimated_Number_of_Employees_this_year__c, 
    Estimated_Number_of_Employees_next_year__c,Insurance_Type_5__c,
    //Insurance_Type_6__c, ,Insurance_Policy_Number_6__c,Insurance_Carrier_6__c , Insurance_Coverage_6__c
    Insurance_Coverage_5__c , Insurance_Carrier_5__c ,Insurance_Policy_Number_5__c,
    PV_share_1__c ,PV_share_2__c ,PV_share_3__c, PV_share_4__c , PV_Credit_Limit_1__c ,
    PV_Credit_Limit_2__c ,PV_Credit_Limit_3__c ,PV_Credit_Limit_4__c,Inverter_share_1__c , Inverter_share_2__c, 
    Inverter_share_3__c, Inverter_share_4__c, Inverter_Credit_Limit_1__c , Inverter_Credit_Limit_2__c , 
    Inverter_Credit_Limit_3__c , Inverter_Credit_Limit_4__c,
    //Other_Marketing_Employees__c, Other_Finance_Employees__c, Other_Employees__c, Other_Direct_Installation_Employees__c, 
    //Other_Design_Employees__c, Other_Sales_Employees__c, Other_Operations_Employees__c, 
    PV_Distributor_1__c, PV_Distributor_2__c, PV_Distributor_3__c, PV_Distributor_4__c,PV_Product_1__c
    ,PV_Product_2__c,PV_Product_3__c,PV_Product_4__c,Inverter_Distributor_1__c,Inverter_Distributor_2__c,
    Inverter_Distributor_4__c,Inverter_Distributor_3__c,Inverter_Product_1__c,Inverter_Product_2__c,Inverter_Product_3__c,Inverter_Product_4__c,
    Location_1_Type__c,Location_2_Type__c,Location_3_Type__c,Location_4_Type__c,Location_1_Primary_Competition__c
    ,Location_2_Primary_Competition__c,Location_3_Primary_Competition__c,Location_4_Primary_Competition__c,Annual_Revenue_2_year_ago_in_kW__c
    ,Annual_Revenue_2_year_ago__c,Number_of_Employees_2_years_ago__c,Annual_Revenue_1_year_ago_in_kW__c,Annual_Revenue_1_year_ago__c,Number_of_Employees_last_year__c
    ,Projected_Revenue_This_Year_in_kW__c,Projected_Revenue_This_Year__c,Projected_Revenue_Next_Year__c
    //for case 00039606
        from Partner_Application__c where id =:id];   
        
        if(lstPartnerApps.size() > 0){
          partnerObj = new Partner_Application__c();    
          partnerObj = lstPartnerApps[0];
        }          
        this.partnerObj.Y_0_Total_Partner_Sales_kW__c = 0;
      if(this.partnerObj.PV_Watts_Sold_Q1__c!=null)
      	this.partnerObj.Y_0_Total_Partner_Sales_kW__c = this.partnerObj.Y_0_Total_Partner_Sales_kW__c+this.partnerObj.PV_Watts_Sold_Q1__c;
      if(this.partnerObj.PV_Watts_Sold_Q2__c!=null)
      	this.partnerObj.Y_0_Total_Partner_Sales_kW__c = this.partnerObj.Y_0_Total_Partner_Sales_kW__c+this.partnerObj.PV_Watts_Sold_Q2__c;      
      if(this.partnerObj.PV_Watts_Sold_Q3__c!=null)
      	this.partnerObj.Y_0_Total_Partner_Sales_kW__c = this.partnerObj.Y_0_Total_Partner_Sales_kW__c+this.partnerObj.PV_Watts_Sold_Q3__c;
      if(this.partnerObj.PV_Watts_Sold_Q4__c!=null)
      	this.partnerObj.Y_0_Total_Partner_Sales_kW__c = this.partnerObj.Y_0_Total_Partner_Sales_kW__c+this.partnerObj.PV_Watts_Sold_Q4__c;
      
    }              
  }
  
  public PageReference quickSavePartnerApp(){
    if(this.partnerObj != null){
      update partnerObj;
      partnerObj = null;  
    }   
    
    String prUrl;
    if (isCVARApplication == true) {
        prUrl = '/apex/New_Partner_Scorecard_CVAR?id=' + id;
    } else {
        prUrl = '/apex/New_Partner_Scorecard?id=' + id;
    }
    
    if (autoComplete) {
        prUrl += '&Type=BGSM';
    }
    
    PageReference pr = new PageReference(prUrl);
    pr.setRedirect(true);
    return pr;
  }
  
  public PageReference savePartnerApp(){
    if(this.partnerObj != null){
      update partnerObj;    
    }
    PageReference pr = new PageReference('/' + id);
    pr.setRedirect(true);
    return pr;   
  }
  
  public Boolean calculate(){
     Boolean isSuccess = false;
     if(this.partnerObj != null){
      
      //checkbox fields
      if(this.partnerObj.Solar_License_Certification__c == true){
        this.partnerObj.Relevant_contractors_licenses_held__c = true;
      }      
      if(this.partnerObj.Total_Employee_Base__c > 6){
        this.partnerObj.Full_time_employees__c = true;
      }      
      if(this.partnerObj.Existing_Pending_Litigation__c == false){
        this.partnerObj.No_major_partner_faulted_litigation__c = true;
      }      
      if(this.partnerObj.Location_1__c != null){
        this.partnerObj.Formal_office_workshop_warehouse__c = true;
      }      
      if(this.partnerObj.Current_Industry__c != null && this.partnerObj.Current_Industry__c == 'PV or Solar'){
        this.partnerObj.Business_focused_on_PV__c = true;
      }      
      if(this.partnerObj.Annual_Revenue_1_year_ago_YOY__c != null && this.partnerObj.Annual_Revenue_1_year_ago_YOY__c > 30 
      && this.partnerObj.Projected_current_FY_YOY__c != null && this.partnerObj.Projected_current_FY_YOY__c > 30){
        this.partnerObj.Greater_than_30_CAGR_over_last_2_years__c = true;
      }      
      if(this.partnerObj.Manager_Level_Employees__c != null && this.partnerObj.Manager_Level_Employees__c > 1){
        this.partnerObj.At_least_one_mid_level_employee__c = true;
      }      
      if(this.partnerObj.Sales_Employees__c != null && this.partnerObj.Sales_Employees__c > 1){
        this.partnerObj.At_least_one_dedicated_salesperson__c = true;
      }      
      if(this.partnerObj.Marketing_Employees__c != null && this.partnerObj.Marketing_Employees__c > 1){
        this.partnerObj.At_least_one_marketing_person__c = true;
      }
      if(this.partnerObj.Website__c != null){
        this.partnerObj.Basic_Website__c = true;
      }
      if(this.partnerObj.New_to_Solar__c == true){
        this.partnerObj.Q_minus_3_Total_Partner_Sales_kW__c = 0;
        this.partnerObj.Q_minus_2_Total_Partner_Sales_kW__c = 0;
        this.partnerObj.Q_minus_1_Total_Partner_Sales_kW__c = 0;
        this.partnerObj.Q_minus_3_SunPower_Sales_to_Partner_kW__c = 0;
        this.partnerObj.Q_minus_2_SunPower_Sales_to_Partner_kW__c = 0;
        this.partnerObj.Q_minus_1_SunPower_Sales_to_Partner_kW__c = 0;
      }
      
      //Score fields
      if(this.partnerObj.Solar_License_Certification__c == true 
        && this.partnerObj.Years_in_Business__c != null 
        && this.partnerObj.Years_in_Business__c > 5){        
            this.partnerObj.License_Score__c = 2;
      }

/*      
      if(this.partnerObj.License_or_qualification_Details__c != null 
        && this.partnerObj.License_or_qualification_Details__c == 'YES'){
            this.partnerObj.License_or_qualification_Score__c = 3;           
      }
*/      
      
      if(this.partnerObj.Existing_Pending_Litigation__c != null 
        && this.partnerObj.Existing_Pending_Litigation__c == false){            
            this.partnerObj.Litigation_Score__c = 3;    
      }

      if(this.partnerObj.Consumer_Reporting_Agency__c == true 
        && this.partnerObj.Customer_Base__c == '1000+ customers'){
            this.partnerObj.Reputation_Score__c = 3;
      }
      if(this.partnerObj.Electrician_on_staff__c == true || 
        this.partnerObj.CAD_Designer_Available__c == true){
            this.partnerObj.Engineering_Score__c = 3;
      }
      

      if(this.partnerObj.Current_Industry__c != null 
        && this.partnerObj.Current_Industry__c == 'PV or Solar'){      
            
        if (this.partnerObj.Years_in_Business__c!=null){
                
            if(this.partnerObj.Years_in_Business__c > 3){
              this.partnerObj.History_in_PV_Score__c = 3;
            }
            else{
              this.partnerObj.History_in_PV_Score__c = this.partnerObj.Years_in_Business__c;
            }
        }
      }
      else{
        
        if (this.partnerObj.Years_in_Business__c!=null){
            if(this.partnerObj.Years_in_Business__c / 2 > 3){
              this.partnerObj.History_in_PV_Score__c = 3;
            }
            else{
              this.partnerObj.History_in_PV_Score__c = this.partnerObj.Years_in_Business__c / 2;
            }           
        }
      }
      if(this.partnerObj.Annual_Revenue_1_year_ago_Score__c != null 
        && this.partnerObj.Projected_current_FY_Score__c != null 
        && this.partnerObj.Projected_Next_FY_Score__c != null){
            
            Double average = (this.partnerObj.Annual_Revenue_1_year_ago_Score__c 
                + this.partnerObj.Projected_current_FY_Score__c 
                + this.partnerObj.Projected_Next_FY_Score__c) / 3;
                
        if(average < .3){
          this.partnerObj.Historic_growth_rate_Score__c = 0;    
        }
        else if(average > .8){
          this.partnerObj.Historic_growth_rate_Score__c = 5;
        }
      }      
/*      
      if(this.partnerObj.Branded_sales_vehicle_Details__c == 'YES'){
        this.partnerObj.Branded_sales_vehicle_Score__c = 3;
      }      
*/
/*
      if(this.partnerObj.Signage_Details__c == 'YES'){
        this.partnerObj.Signage_Score__c = 3;
      }      
*/
      
      if(this.partnerObj.Business_Plan__c == true){
        this.partnerObj.Business_Plan_1_Score__c = 5;
      }    
        
 
      if(this.partnerObj.Company_Profitable__c == true){
        this.partnerObj.Well_capitalized_Score__c = 3;
      }      
      if(this.partnerObj.Current_Industry__c != null 
        && (this.partnerObj.Current_Industry__c == 'contracting'
            || this.partnerObj.Current_Industry__c == 'installation' 
            || this.partnerObj.Current_Industry__c == 'solar focused')){
            
            this.partnerObj.VAR_business_model_Score__c = 5;
            
      }      
      
      Double empScore;
      if (this.partnerObj.Manager_Employees__c != null && this.partnerObj.Manager_Employees__c >= 3) {
          empScore = 3;
      } else {
          empScore = this.partnerObj.Manager_Employees__c;
      }
      
      if (isCVARApplication == true) {
          this.partnerObj.Commercial_Employees_Score__c = empScore;
      } else {
          this.partnerObj.Employees_Score__c = empScore;
      }

      if(this.partnerObj.Manager_Sales_Employees__c != null 
        && this.partnerObj.Manager_Sales_Employees__c >= 1){
            this.partnerObj.Sales_manager_Score__c = 5;
      }     
/*                   
      if(this.partnerObj.Sales_training_Details__c != null 
        && this.partnerObj.Sales_training_Details__c == 'YES'){
            this.partnerObj.Sales_training_Score__c = 3;
      }     
*/      
/*
      if(this.partnerObj.Sales_meetings_Details__c != null 
        && this.partnerObj.Sales_meetings_Details__c == 'YES'){
            this.partnerObj.Sales_meetings_Score__c = 3;
      }      
*/
/*
      if(this.partnerObj.Sales_process_Details__c != null 
        && this.partnerObj.Sales_process_Details__c == 'YES'){
            this.partnerObj.Sales_process_Score__c = 3;
      }
      
      if(this.partnerObj.Commercial_Sales_process_Details__c != null 
        && this.partnerObj.Commercial_Sales_process_Details__c == 'YES'){
            this.partnerObj.Commercial_Sales_process_Score__c = 3;
      }      
*/
/*
      if(this.partnerObj.Basics_sales_metrics_tracking_Details__c != null && 
        this.partnerObj.Basics_sales_metrics_tracking_Details__c == 'YES'){
        this.partnerObj.Basics_sales_metrics_tracking_Score__c = 3;
      }     
*/
/*       
      if(this.partnerObj.CRM_Details__c == 'YES'){
        this.partnerObj.CRM_Score__c = 2;
      }      
*/      
      
      if(this.partnerObj.Manager_Marketing_Employees__c != null && 
        this.partnerObj.Manager_Marketing_Employees__c >= 1){
            this.partnerObj.Marketing_Manager_Score__c = 5;
      }      

/*           
      if(this.partnerObj.Professional_uniforms_Details__c == 'YES'){
        this.partnerObj.Professional_uniforms_Score__c = 5;
      }      
*/
      if(this.partnerObj.Formalized_Referral_Program__c == true){
        this.partnerObj.Organized_referral_program_Score__c = 5;
      }      
      
      if(this.partnerObj.Website__c != null){
        this.partnerObj.Sophisticated_website_Score__c = 3;
      }
        
      update partnerObj;   
      isSuccess = true;     
    }    
    return isSuccess;
    
  }
  
  public PageReference calculateFieldValues(){
    PageReference pr = null;     
    if(calculate()) {
        if (isCVARApplication == true) {
            pr = new PageReference('/apex/New_Partner_Scorecard_CVAR?id='+id +'&Type=BGSM');
        } else {
            pr = new PageReference('/apex/New_Partner_Scorecard?id='+id +'&Type=BGSM');
        }
        pr.setRedirect(true);
    }   
    return pr;  
  }
  
  public PageReference calculateFieldValues_GE(){
    PageReference pr = null;     
    if(calculate()) {
        pr = new PageReference('/apex/New_Partner_Scorecard_ge?id='+id +'&Type=BGSM');
        pr.setRedirect(true);
    }   
    return pr;  
  }
  public PageReference calculateFieldValues_EU(){
    PageReference pr = null;     
    if(calculate()) {
        pr = new PageReference('/apex/EU_New_Partner_Scorecard?id='+id +'&Type=BGSM');
        pr.setRedirect(true);
    }   
    return pr;  
   }
   public PageReference calculateFieldValues_IT(){
    PageReference pr = null;     
    if(calculate()) {
        pr = new PageReference('/apex/New_Partner_Scorecard_it?id='+id +'&Type=BGSM');
        pr.setRedirect(true);
    }   
     return pr;  
    }
    
    public PageReference calculateFieldValues_ES(){
    PageReference pr = null;     
    if(calculate()) {
        pr = new PageReference('/apex/New_Partner_Scorecard_es?id='+id +'&Type=BGSM');
        pr.setRedirect(true);
    }   
     return pr;  
    }
    public PageReference calculateFieldValues_FR(){
    PageReference pr = null;     
    if(calculate()) {
        pr = new PageReference('/apex/New_Partner_Scorecard_fr?id='+id +'&Type=BGSM');
        pr.setRedirect(true);
    }   
     return pr;  
    }
  
  /*** For EU ***/
   public PageReference quickSavePartnerApp_EU(){
    if(this.partnerObj != null){
      update partnerObj;
      partnerObj = null;      
    }
       
    PageReference pr = null;
    if(autoComplete){ 
        pr = new PageReference('/apex/EU_New_Partner_Scorecard?id='+id +'&Type=BGSM');
    }
    else{
        pr = new PageReference('/apex/EU_New_Partner_Scorecard?id='+id);
    }    
    pr.setRedirect(true);
    return pr;
  }
 
  /*** For French ***/
   public PageReference quickSavePartnerApp_FR(){
    if(this.partnerObj != null){
      update partnerObj;
      partnerObj = null;      
    }
    PageReference pr = null;
    if(autoComplete){    
        pr = new PageReference('/apex/New_Partner_Scorecard_fr?id='+id +'&Type=BGSM');
    }
    else{
        pr = new PageReference('/apex/New_Partner_Scorecard_fr?id='+id);
    }
    pr.setRedirect(true);
    return pr;
  }
 
  /*** For ITALIAN ***/
   public PageReference quickSavePartnerApp_IT(){
    if(this.partnerObj != null){
      update partnerObj;
      partnerObj = null;      
    } 
    PageReference pr = null;
    if(autoComplete){    
        pr = new PageReference('/apex/New_Partner_Scorecard_it?id='+id +'&Type=BGSM');
    }
    else{
        pr = new PageReference('/apex/New_Partner_Scorecard_it?id='+id);
    }   
    pr.setRedirect(true);
    return pr;
  }
  
  /*** For GERMAN ***/
  public PageReference quickSavePartnerApp_GE(){
    if(this.partnerObj != null){
      update partnerObj;
      partnerObj = null;      
    }
    PageReference pr = null;
    if(autoComplete){      
        pr = new PageReference('/apex/New_Partner_Scorecard_ge?id='+id +'&Type=BGSM');
    }
    else{
        pr = new PageReference('/apex/New_Partner_Scorecard_ge?id='+id);
    }   
    pr.setRedirect(true);
    return pr;
  }
  //for case 00039606
public PageReference quickSavePartnerApp_au(){
    if(this.partnerObj != null){
      update partnerObj;
      partnerObj = null;  
    }     
    PageReference pr = new PageReference('/apex/New_Partner_Scorecard_au?id=' + id);
    pr.setRedirect(true);
    return pr;
  }
  
  public PageReference savePartnerApp_au(){
    if(this.partnerObj != null){
      update partnerObj;    
    }
    PageReference pr = new PageReference('/' + id);
    pr.setRedirect(true);
    return pr;   
  }
  //for case 00039606
}