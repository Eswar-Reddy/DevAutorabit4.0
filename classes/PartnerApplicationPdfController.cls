public class PartnerApplicationPdfController {

  public Partner_Application__c partnerApp{get;set;}
  public string id{get;set;} 
  //public Boolean temp{get;set;}
  public List<ListOption> listopt{get;set;}
  //for Electrical License? :
  public List<ListOption> loEL{get;set;}
  //for Solar License/Certification? :
  public List<ListOption> loSLC{get;set;}
    
  //Electrician_on_staff__c
  public List<ListOption> loES{get;set;}
    
  //Roofing_License__c
  public List<ListOption> loRL{get;set;}
   
  //CAD_Designer_Available__c
  public List<ListOption> loCDA{get;set;}
    
  //Insurance_Coverage__c
  public List<ListOption> loIC{get;set;}
    
  //Company_Profitable__c
  public List<ListOption> loCP{get;set;}
    
  //Secured_Performance_Bond__c
  public List<ListOption> loSPB{get;set;}
    
  //Credit_Report__c
  public List<ListOption> loCRFE{get;set;}
    
  //Business_Plan__c
  public List<ListOption> loBP{get;set;}
    
  //Existing_Pending_Litigation__c
  public List<ListOption> loEPL{get;set;}
    
  //Consumer_Reporting_Agency__c
  public List<ListOption> loCRE{get;set;}
    
  //Member_of_Local_Business_Orgs__c
  public List<ListOption> loMOfLBO{get;set;}
    
  //Currently_Bondable__c
  public List<ListOption> loCB{get;set;}
    
  //Formalized_Referral_Program__c
  public List<ListOption> loFRP{get;set;}
  
  //Bank_Guarantee__c
  public List<ListOption> loBankGuarantee{get;set;}
  
  //Formal_office_workshop_warehouse__c
  public List<ListOption> loFormalOfficeWorkshopWarehouse{get;set;}
  
  //Web_Page__c
  public List<ListOption> loWebPage{get;set;}
  
  //Marketing_Material__c
  public List<ListOption> loMarketingMaterial{get;set;}
  
  //Showroom__c
  public List<ListOption> loShowroom{get;set;}
  
  //Installation_Vehicle_Fleet__c
  public List<ListOption> loInstallationVehicleFleet{get;set;}
  
  //CRM__c
  public List<ListOption> loCRM{get;set;}
  
  //Existing_Pending_Litigation__c
  public List<ListOption> loExistingPendingLitigation{get;set;}  
    
  public Boolean isCommercial{get;set;}
  //for case # 00039606
  //public boolean bcsea{get;set;}
  //BCSE_Install__c
  public List<ListOption> loBI{get;set;}
  
  //Electrical_Class_A__c
  public List<ListOption> loECA{get;set;}
  
  //Electrical_Class_C__c
  public List<ListOption> loECC{get;set;}
  
  //Electrical_Contractor__c
  public List<ListOption> loEC{get;set;}
  //for case # 00039606  
  //load all picklist and checkbox values
  public void populate(){      
    partnerApp = new Partner_Application__c();
    List<Partner_Application__c> partList  = [Select Zip__c, Years_in_Business__c, Years_in_Business_Score__c, Well_capitalized_Score__c, 
      Well_capitalized_Details__c, Website__c, Website_Score__c, Web_Page__c, Vehicle_with_Logo__c,
      VAR_business_model_Score__c, VAR_business_model_Details__c, Total_Revenue_MM_last_year__c, Total_Revenue_MM_Q4__c,
      Total_Revenue_MM_Q3__c, Total_Revenue_MM_Q2__c, Total_Revenue_MM_Q1__c, Total_Revenue_MM_3_years_ago__c, 
      Total_Revenue_MM_2_years_ago__c, Total_Employee_Base__c, Total_Employee_Base_Score__c, Title__c, Theater__c,
      Territory__c, Tabelle_e_abilitazioni_more_than_5_years__c, Tabelle_e_abilitazioni_es_46_90__c, SystemModstamp,
      Status__c, State__c, Sophisticated_website_Score__c, Sophisticated_website_Details__c, 
      Sophisticated_sales_collateral_Score__c, Sophisticated_sales_collateral_Details__c, Solar_License_Certification__c,
      Signage_Score__c, Signage_Details__c, Showroom__c, Showroom_Score__c, Showroom_Details__c, 
    Secured_Performance_Bond__c, Scorecard_Score__c, Sales_training_Score__c, Sales_training_Details__c,
    Sales_process_Score__c, Sales_process_Details__c, Sales_meetings_Score__c, Sales_meetings_Details__c,
    Sales_manager_Score__c, Sales_manager_Details__c, Sales_Employees__c, Sales_Employees_Score__c, Roofing_License__c,
    Residential_Systems_installed_to_date__c, Residential_PV_installed_to_date__c, Residential_Focus__c, 
    Residential_Customer_Base__c, Resellers_License__c, Reputation_Score__c, Reputation_Details__c,
    Relevant_contractors_licenses_held__c, Relevant_Insurance__c, RecordTypeId, Reason__c, Racking_Product_4__c,
    Racking_Product_3__c, Racking_Product_2__c, Racking_Product_1__c, Racking_Distributor_4__c, 
    Racking_Distributor_3__c, Racking_Distributor_2__c, Racking_Distributor_1__c, RSM__c, Quality_Certification__c,
    Qualifies_for_100000_credit_limit__c, Q_plus_4_Total_Partner_Sales_kW__c, Q_plus_4_SunPower_Sales_to_Partner_kW__c,
    Q_plus_3_Total_Partner_Sales_kW__c, Q_plus_3_SunPower_Sales_to_Partner_kW__c, Q_plus_2_Total_Partner_Sales_kW__c, 
    Q_plus_2_SunPower_Sales_to_Partner_kW__c, Q_plus_1_Total_Partner_Sales_kW__c, Q_plus_1_SunPower_Sales_to_Partner_kW__c,
    Q_minus_3_Total_Partner_Sales_kW__c, Q_minus_3_SunPower_Sales_to_Partner_kW__c, Q_minus_2_Total_Partner_Sales_kW__c, 
    Q_minus_2_SunPower_Sales_to_Partner_kW__c, Q_minus_1_Total_Partner_Sales_kW__c, 
    Q_minus_1_SunPower_Sales_to_Partner_kW__c, Q0_Total_Partner_Sales_kW__c, Q0_SunPower_Sales_to_Partner_kW__c,
    Provide_Workers_Compensation__c, Projects_completed_last_year__c, Projects_Completed_Last_Year_Score__c, 
    Projected_current_FY_YOY__c, Projected_current_FY_Score__c, Projected_Revenue_This_Year__c, 
    Projected_Revenue_Next_Year__c, Projected_Next_FY_YOY__c, Projected_Next_FY_Score__c, Professional_uniforms_Score__c,
    Professional_uniforms_Details__c, Product_Type_3__c, Product_Type_2__c, Product_Type_1__c, Phone__c, 
    Percentage_Residential_Projects__c, Percentage_Ground_Projects__c, Percentage_Commercial_Projects__c, 
    Partner_Application_Type__c, PV_Watts_Sold_last_year__c, PV_Watts_Sold_Q4__c, PV_Watts_Sold_Q3__c, 
    PV_Watts_Sold_Q2__c, PV_Watts_Sold_Q1__c, PV_Watts_Sold_3_years_ago__c, PV_Watts_Sold_2_years_ago__c,
    PV_Product_4__c, PV_Product_3__c, PV_Product_2__c, PV_Product_1__c, PV_Experience_years__c, PV_Distributors__c,
    PV_Distributor_4__c, PV_Distributor_3__c, PV_Distributor_2__c, PV_Distributor_1__c, Owner__c, OwnerId, 
    Organized_referral_program_Score__c, Organized_referral_program_Details__c, Number_of_Employees_last_year__c,
    Number_of_Employees_Q4__c, Number_of_Employees_Q3__c, Number_of_Employees_Q2__c, Number_of_Employees_Q1__c, 
    Number_of_Employees_3_years_ago__c, Number_of_Employees_2_years_ago__c, No_major_partner_faulted_litigation__c,
    New_to_Solar__c, Name, Monitoring_Product_4__c, Monitoring_Product_3__c, Monitoring_Product_2__c, 
    Monitoring_Product_1__c, Monitoring_Distributor_4__c, Monitoring_Distributor_3__c, Monitoring_Distributor_2__c,
    Monitoring_Distributor_1__c, Mobile__c, Member_of_Local_Business_Orgs__c, Member_of_Local_Business_Orgs_Score__c, 
    Member_of_Local_Business_Orgs_Details__c, Meeting_Date__c, Meeting_Attendee_Title_4__c, Meeting_Attendee_Title_3__c,
    Meeting_Attendee_Title_2__c, Meeting_Attendee_Title_1__c, Meeting_Attendee_Name_4__c, Meeting_Attendee_Name_3__c, 
    Meeting_Attendee_Name_2__c, Meeting_Attendee_Name_1__c, Marketing_Source_3__c, Marketing_Source_3_Percent__c, 
    Marketing_Source_2__c, Marketing_Source_2_Score__c, Marketing_Source_2_Percent__c, Marketing_Source_1__c, 
    Marketing_Source_1_Score__c, Marketing_Source_1_Percent__c, Marketing_Material__c, Marketing_Manager_Score__c,
    Marketing_Manager_Details__c, Marketing_Employees__c, Marketing_Employees_Score__c, Manufacturer_3__c, 
    Manufacturer_3_Credit_Line__c, Manufacturer_2__c, Manufacturer_2_Credit_Line__c, Manufacturer_1__c, 
    Manufacturer_1_Credit_Line__c, Manager_Sales_Employees__c, Manager_Other_Employees__c, 
    Manager_Operations_Employees__c, Manager_Marketing_Employees__c, Manager_Level_Employees__c,
    Manager_Installation_Employees__c, Manager_Finance_Employees__c, Manager_Employees__c, Manager_Design_Employees__c,
    Location_4__c, Location_4_Primary_Competition__c, Location_4_Number_of_Employees__c, Location_4_Markets__c, 
    Location_3__c, Location_3_Primary_Competition__c, Location_3_Number_of_Employees__c, Location_3_Markets__c, 
    Location_2__c, Location_2_Primary_Competition__c, Location_2_Number_of_Employees__c, Location_2_Markets__c, 
    Location_1__c, Location_1_Primary_Competition__c, Location_1_Number_of_Employees__c, Location_1_Markets__c, 
    Litigation_Score__c, Litigation_Details__c, License_or_qualification_Score__c, License_or_qualification_Details__c,
    License_Score__c, License_Details__c, Legal_Name__c, Lead__c, Last_Name__c, LastModifiedDate, LastModifiedById, 
    LastActivityDate, Language__c, IsDeleted, Inverter_Product_4__c, Inverter_Product_3__c, Inverter_Product_2__c, 
    Inverter_Product_1__c, Inverter_Distributor_4__c, Inverter_Distributor_3__c, Inverter_Distributor_2__c, 
    Inverter_Distributor_1__c, Insurance_Type_4__c, Insurance_Type_3__c, Insurance_Type_2__c, Insurance_Type_1__c,
    Insurance_Policy_Number_4__c, Insurance_Policy_Number_3__c, Insurance_Policy_Number_2__c, 
    Insurance_Policy_Number_1__c, Insurance_Coverage__c, Insurance_Coverage_4__c, Insurance_Coverage_3__c,
    Insurance_Coverage_2__c, Insurance_Coverage_1__c, Insurance_Carrier_4__c, Insurance_Carrier_3__c, 
    Insurance_Carrier_2__c, Insurance_Carrier_1__c, Installation_Vehicle_Fleet__c, Installation_Employees__c,
    Installation_Employees_Score__c, Install_truck_Score__c, Install_truck_Details__c, Id, History_in_PV_Score__c,
    History_in_PV_Details__c, Historic_growth_rate_Score__c, Historic_growth_rate_Details__c, 
    Growth_plan_greater_than_50_of_median__c, Greater_than_30_CAGR_over_last_2_years__c, Geographic_Coverage_Score__c,
    Full_time_employees__c, Formalized_Referral_Program__c, Formalized_Referral_Program_Score__c, 
    Formal_office_workshop_warehouse__c, First_Name__c, Field_Level_Sales_Employees__c, Field_Level_Other_Employees__c, 
    Field_Level_Operations_Employees__c, Field_Level_Marketing_Employees__c, Field_Level_Installation_Employees__c, 
    Field_Level_Finance_Employees__c, Field_Level_Employees__c, Field_Level_Design_Employees__c, Fax__c, 
    Existing_Pending_Litigation__c, Existing_Pending_Litigation_Specify__c, Existing_Pending_Litigation_Score__c,
    Engineering_Score__c, Engineering_Details__c, Employees__c, Employees_Score__c, Employees_Details__c, Email__c,
    Electrician_on_staff__c, Electrician_on_staff_Score__c, Electrical_Permits_last_36_months__c, Electrical_License__c,
    EIN__c, Details__c, Customer_Base__c, Customer_Base_Score__c, Currently_Bondable__c, Current_Industry__c, 
    CurrencyIsoCode, Credit_Report__c, Credit_Report_Score__c, CreatedDate, CreatedById, Country__c, 
    Contractor_License_Number__c, Contact__c, Consumer_Reporting_Agency__c, Consumer_Reporting_Agency_Score__c,
    Company_Profitable__c, Company_Profitable_Score__c, Company_Phone_Support__c, Company_Name__c, 
    Commercial_Systems_installed_to_date__c, Commercial_PV_installed_to_date__c, Commercial_Focus__c,
    Commercial_Customer_Base__c, City__c, Campaign__c, Calculated_Application_Score__c, CRM__c, CRM_Score__c,
    CRM_Details__c, CAD_Designer_Available__c, CAD_Designer_Available_Score__c, Business_focused_on_PV__c, 
    Business_Plan__c, Business_Plan_Score__c, Business_Plan_2_Score__c, Business_Plan_2_Details__c, 
    Business_Plan_1_Score__c, Business_Plan_1_Details__c, Building_Permits_last_36_months__c, 
    Branded_sales_vehicle_Score__c, Branded_sales_vehicle_Details__c, Basics_sales_metrics_tracking_Score__c,
    Basics_sales_metrics_tracking_Details__c, Basic_sales_collateral__c, Basic_Website__c, Bank_Guarantee__c,
    Average_Size_Residential_Projects__c, Average_Size_Ground_Projects__c, Average_Size_Commercial_Projects__c,
    At_least_one_mid_level_employee__c, At_least_one_marketing_person__c, At_least_one_dedicated_salesperson__c,
    At_least_one_branded_truck__c, Area_Sales_Manager__c, Application_Score__c, Application_Date__c, 
    Annual_Revenue_2_year_ago__c, Annual_Revenue_1_year_ago__c, Annual_Revenue_1_year_ago_YOY__c, 
    Annual_Revenue_1_year_ago_Score__c, Address__c, Additional_License_4_Specify__c, Additional_License_3_Specify__c,
    Additional_License_2_Specify__c, Additional_License_1_Specify__c, Account__c, Abilitazioni_Score__c, 
    Abilitazioni_Details__c,
    //for case 00039606
    ABN__c, BCSE_Install__c, Electrical_Class_A__c, Electrical_Class_C__c, Electrical_Contractor__c,
     Annual_Revenue_2_year_ago_in_kW__c, Annual_Revenue_1_year_ago_in_kW__c, 
    Projected_Revenue_This_Year_in_kW__c, Projected_Revenue_next_Year_in_kW__c, Estimated_Number_of_Employees_this_year__c, 
    Estimated_Number_of_Employees_next_year__c,Insurance_Type_5__c,
    //Insurance_Type_6__c,Insurance_Policy_Number_6__c,Insurance_Carrier_6__c , Insurance_Coverage_6__c,
    //Invoicing_address__c, 
    Insurance_Coverage_5__c ,Insurance_Carrier_5__c , Insurance_Policy_Number_5__c ,   
    PV_share_1__c ,PV_share_2__c ,PV_share_3__c, PV_share_4__c , PV_Credit_Limit_1__c ,
    PV_Credit_Limit_2__c ,PV_Credit_Limit_3__c ,PV_Credit_Limit_4__c,Inverter_share_1__c , Inverter_share_2__c, 
    Inverter_share_3__c, Inverter_share_4__c, Inverter_Credit_Limit_1__c , Inverter_Credit_Limit_2__c , 
    Inverter_Credit_Limit_3__c , Inverter_Credit_Limit_4__c,
    //Other_Sales_Employees__c, Other_Operations_Employees__c,Other_Design_Employees__c, 
    //Other_Marketing_Employees__c, Other_Finance_Employees__c, Other_Employees__c, Other_Direct_Installation_Employees__c, 
    BCSE_Accreditation__c
    //Start 00095084
    , Company_have_fulltime_master_electrician__c
    //End 00095084
//for case # 00039606
    
    From Partner_Application__c  where Id=:id limit 1];
        
    if(partList != null && partList.size() > 0){
      partnerApp = partList[0];   
    }
    
    if(partnerApp.Partner_Application_Type__c == 'Commercial'){
      this.isCommercial = true;
    }
    else{
      this.isCommercial = false;
    }
    loadCustomerBasePicklistValues();
        
    loEL = new List<ListOption>(); 
    loEL = loadCheckBoxValues('Electrical_License__c');
        
    loSLC = new List<ListOption>();
    loSLC = loadCheckBoxValues('Solar_License_Certification__c');
        
    loES = new List<ListOption>();
    loES = loadCheckBoxValues('Electrician_on_staff__c');
       
    loRL = new List<ListOption>();
    loRL = loadCheckBoxValues('Roofing_License__c');
        
    loCDA = new List<ListOption>();
    loCDA = loadCheckBoxValues('CAD_Designer_Available__c');
        
    loIC = new List<ListOption>();
    loIC = loadCheckBoxValues('Insurance_Coverage__c');
        
    loCP = new List<ListOption>();
    loCP = loadCheckBoxValues('Company_Profitable__c');
        
    loSPB = new List<ListOption>();
    loSPB = loadCheckBoxValues('Secured_Performance_Bond__c');
        
    loCRFE = new List<ListOption>();
    loCRFE = loadCheckBoxValues('Credit_Report__c');
        
    loBP = new List<ListOption>();
    loBP = loadCheckBoxValues('Business_Plan__c');
        
    loEPL = new List<ListOption>();
    loEPL = loadCheckBoxValues('Existing_Pending_Litigation__c');
        
    loCRE = new List<ListOption>();
    loCRE = loadCheckBoxValues('Consumer_Reporting_Agency__c');
        
    //only show NO value
    loMOfLBO = new List<ListOption>();
    loMOfLBO = loadCheckBoxValuesOnlyNO('Member_of_Local_Business_Orgs__c');        
        
    loCB = new List<ListOption>();
    loCB = loadCheckBoxValues('Currently_Bondable__c');
        
    loFRP = new List<ListOption>();
    loFRP = loadCheckBoxValues('Formalized_Referral_Program__c'); 
    
    loFormalOfficeWorkshopWarehouse = new List<ListOption>();
    loFormalOfficeWorkshopWarehouse = loadCheckBoxValues('Formal_office_workshop_warehouse__c');    
    
    loWebPage = new List<ListOption>();
    loWebPage = loadCheckBoxValues('Web_Page__c');
    
    loMarketingMaterial = new List<ListOption>();
    loMarketingMaterial = loadCheckBoxValues('Marketing_Material__c');
    
    loShowroom = new List<ListOption>();
    loShowroom = loadCheckBoxValues('Showroom__c');
    
    loInstallationVehicleFleet = new List<ListOption>();
    loInstallationVehicleFleet = loadCheckBoxValues('Installation_Vehicle_Fleet__c');
    
    loCRM = new List<ListOption>();
    loCRM = loadCheckBoxValues('CRM__c');
    
    loExistingPendingLitigation = new List<ListOption>();
    loExistingPendingLitigation = loadCheckBoxValues('Existing_Pending_Litigation__c');
    //for case # 00039606
    loBI = new List<ListOption>(); 
    loBI = loadCheckBoxValues('BCSE_Install__c');
    
    loECA = new List<ListOption>(); 
    loECA = loadCheckBoxValues('Electrical_Class_A__c');    
    
    loECC = new List<ListOption>(); 
    loECC = loadCheckBoxValues('Electrical_Class_C__c');
    
    loEC = new List<ListOption>(); 
    loEC = loadCheckBoxValues('Electrical_Contractor__c');
  } 
     
  public PartnerApplicationPdfController(ApexPages.StandardController stdController){
    //partnerApp = (Partner_Application__c)stdController.getRecord();
    if(ApexPages.CurrentPage().getParameters().get('id') != null){
      id = ApexPages.CurrentPage().getParameters().get('id');
    }
    populate();
  }
  
  //to show all picklist values on pdf
  public void loadCustomerBasePicklistValues(){
    listopt = new List<ListOption>();
    String customerBaseSelectedValue = getCustomerBaseSelectedValue();
    ListOption lo;
    Schema.DescribeFieldResult F;
    List<Schema.PicklistEntry> P;
    
    if(this.isCommercial == true){
      F = Partner_Application__c.Commercial_Customer_Base__c.getDescribe();  
    }
    else{
      F = Partner_Application__c.Residential_Customer_Base__c.getDescribe();
    }
    P = F.getPicklistValues();
    
    //Schema.DescribeFieldResult F = Partner_Application__c.Customer_Base__c.getDescribe();
    //List<Schema.PicklistEntry> P = F.getPicklistValues();
    for(Schema.PicklistEntry entry : P){      
      lo =  new ListOption(entry.getLabel());
      if(customerBaseSelectedValue == entry.getLabel()){
        lo.renderChecked = true;
      }
      else{
        lo.renderChecked = false; 
      }  
      listopt.add(lo);
    }        
  }
  
  //to show yes no on pdf
  public List<ListOption> loadCheckBoxValues(String fieldname){
    List<ListOption> loTemp = new List<ListOption>();
    Boolean val = getValue(fieldname);
    ListOption lo =  new ListOption('Yes');
    lo.renderChecked = true;
    if(val){
      lo.renderChecked = true;
    }
    else{
      lo.renderChecked = false;
    }
    loTemp.add(lo);
    lo =  new ListOption('No');
    lo.renderChecked = true;
    if(val){
      lo.renderChecked = false;
    }
    else{
      lo.renderChecked = true;
    }
    loTemp.add(lo);
    return loTemp;          
  }
    
  public List<ListOption> loadCheckBoxValuesOnlyNO(String fieldname){
    List<ListOption> loTemp = new List<ListOption>();
    Boolean val = getValue(fieldname);
    ListOption lo =  new ListOption('No');
    lo.renderChecked = true;
    if(val){
      lo.renderChecked = false;
    }
    else{
      lo.renderChecked = true;
    }
    loTemp.add(lo);
    return loTemp;          
  }
   
  public Boolean getValue(String fieldname){
    Boolean val;
    if(partnerApp != null && partnerApp.get(fieldname) != null) {
      val = Boolean.valueOf(partnerApp.get(fieldname));
      return val;  
    }
    return false;
  }
    
  //to get customerBase selected value     
  public String getCustomerBaseSelectedValue(){
    String customerBaseSelectedValue;
    List<Partner_Application__c> lpa = new List<Partner_Application__c>([Select Electrical_License__c , Customer_Base__c from Partner_Application__c where Id=:id]);
    if(lpa.Size()>0){
      customerBaseSelectedValue = lpa.get(0).Customer_Base__c;
    }
    return customerBaseSelectedValue;
  }
    
  //class to show checkbox and picklist values on pdf 
  public class ListOption{
    public listOption(string name){
      this.name = name;
    }
    public string name{get;set;}
    //public string imageName{get;set;}
    public Boolean renderChecked{get;set;}
  }
}