public class PartnerApplicationScoreController{
  
  //properties
  private final Partner_Application__c partnerAppObj{get;set;}
  //for case 00039606
  private Boolean isCVARApplication;
  public Partner_Application__c partnerObj{get; set;}
  public String id{get;set;}
  public Integer score{get;set;}
  public Boolean autoComplete{get;set;}
  public Boolean isItaly{get;set;}
  public Boolean isAus{get;set;}
  //Start 95084
  public Boolean isGermany{get;set;}
  //End 95084
  static String auPartnerAppRecTypeId;
  //for case 00039606
  
  public PartnerApplicationScoreController(ApexPages.StandardController controller){
    this.partnerAppObj = (Partner_Application__c)controller.getRecord();
    fetchPartnerData(); //for case 00039606   
  }
  
  public PageReference returnToApplication(){
    PageReference newPage = new PageReference('/' + partnerAppObj.Id);
    newPage.setRedirect(true);
    return newPage;
  }
  //for case 00039606
  public void fetchPartnerData(){
  	isItaly = false;
  	//Start 95084
  	isGermany = false;
  	//End 95084
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
        
        //Start 95084 add field in the query
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
        Manager_Sales_Employees__c, New_to_Solar__c, Employees_Details__c, Employees_Score__c, Application_Score__c ,Tabelle_e_abilitazioni_es_46_90__c,Quality_Certification__c, 
        Manager_Employees__c, Tabelle_e_abilitazioni_more_than_5_years__c, Abilitazioni_Score__c, Abilitazioni_Details__c, Commercial_Sales_process_Details__c,
        Commercial_Employees_Score__c, Commercial_Employees_Details__c, Proposal_Package_Score__c, Proposal_Package_Details__c, Commercial_Sales_process_Score__c,
        Greater_than_20_CAGR_over_last_2_years__c,Y_0_Total_Partner_Sales_kW__c,PV_Watts_Sold_Q1__c,PV_Watts_Sold_Q2__c,PV_Watts_Sold_Q3__c,PV_Watts_Sold_Q4__c,
        PV_Watts_Sold_last_year__c,PV_Watts_Sold_2_years_ago__c,PV_Watts_Sold_3_years_ago__c,Language__c, BCSE_Install__c
        ,Insurance_Carrier_1__c, Insurance_Coverage_1__c, Insurance_Policy_Number_1__c, RecordTypeId, Bank_Guarantee__c,Qualifies_for_50_000_credit_limit__c
        ,CRM__c,Showroom__c,Field_Level_Design_Employees__c,Installation_Vehicle_Fleet__c,PV_Experience_years__c,Web_Page__c,Marketing_Material__c
        ,Formal_office_workshop_warehouse_Score__c,Tabelle_e_abilitazioni_es_46_90_Score__c,Quality_Certification_Score__c, BCSE_Accreditation__c
        ,Company_have_fulltime_master_electrician__c,Electrician_Score__c ,Electrician_Details__c, Company_have_ft_master_electrician__c , Country__c
        from Partner_Application__c where id =:id];   
        //End 95084
        if(lstPartnerApps.size() > 0){
          partnerObj = new Partner_Application__c();    
          partnerObj = lstPartnerApps[0];
          if(partnerObj.Language__c == 'Italian'){
          	isItaly = true;
          	score = 4;
          }else{
          	//Start 95084
          	/*if(partnerObj.Language__c == 'German'){
          		isGermany = true;
          	}*/
          	if(partnerObj.Country__c == 'Germany'){
          		isGermany = true;
          	}
          	//End 95084
          	isItaly = false;
          	score = 5;
          }
          auPartnerAppRecTypeId=null;                
          for(RecordType recType : [Select Id, Name From RecordType where SobjectType = 'Partner_Application__c' and Name='AUS Partner Application']){
                    auPartnerAppRecTypeId = recType.Id;
           }//for end
          if(partnerObj.RecordTypeId==auPartnerAppRecTypeId){
          	isAus = true;
          	if(this.partnerObj.Existing_Pending_Litigation__c == false)
        		this.partnerObj.No_major_partner_faulted_litigation__c = true;      		
      		if(this.partnerObj.Website__c != null)
       			this.partnerObj.Basic_Website__c = true;      		
      		if(this.partnerObj.Insurance_Carrier_1__c!=null || this.partnerObj.Insurance_Coverage_1__c!=null || this.partnerObj.Insurance_Policy_Number_1__c!=null)
      			this.partnerObj.Relevant_Insurance__c = true;
      		if(this.partnerObj.PV_Experience_years__c > 2){
      			this.partnerObj.Business_focused_on_PV__c = true;
      		}
          }
          else{
          	isAus = false;
          }
        }          
    }
  }  
  
  public Boolean calculate(){
     Boolean isSuccess = false;
     if(this.partnerObj != null){
      //checkbox fields
      if(this.partnerObj.Insurance_Coverage_1__c !=null && this.partnerObj.Insurance_Coverage_1__c != '0')
      		this.partnerObj.Relevant_Insurance__c = true;
      if(this.partnerObj.Solar_License_Certification__c == true){
        this.partnerObj.Relevant_contractors_licenses_held__c = this.partnerObj.Solar_License_Certification__c;
      }      
      if(this.partnerObj.Bank_Guarantee__c == true){
        this.partnerObj.Qualifies_for_50_000_credit_limit__c = this.partnerObj.Bank_Guarantee__c;
      }
      if(this.partnerObj.Total_Employee_Base__c > 6){
        this.partnerObj.Full_time_employees__c = true;
      }      
      if(this.partnerObj.Existing_Pending_Litigation__c == false){
        this.partnerObj.No_major_partner_faulted_litigation__c = true;
      }
      //Start 95084
      if(this.partnerObj.Company_have_fulltime_master_electrician__c == true){
      	this.partnerObj.Company_have_ft_master_electrician__c = true;
      }      
      //End 95084
      if(this.partnerObj.Location_1__c != null || this.partnerObj.Formal_office_workshop_warehouse__c){
        this.partnerObj.Formal_office_workshop_warehouse_Score__c = true;
      }      
      if(this.partnerObj.Current_Industry__c != null && this.partnerObj.Current_Industry__c == 'PV'){
        this.partnerObj.Business_focused_on_PV__c = true;
      }else{
      	this.partnerObj.Business_focused_on_PV__c = false;
      }
     	if(this.partnerObj.Quality_Certification__c){
     		this.partnerObj.Quality_Certification_Score__c = this.partnerObj.Quality_Certification__c;
     	}
     	if(this.partnerObj.Tabelle_e_abilitazioni_es_46_90__c){
     		this.partnerObj.Tabelle_e_abilitazioni_es_46_90_Score__c = this.partnerObj.Tabelle_e_abilitazioni_es_46_90__c;
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
      }else if(this.partnerObj.Web_Page__c == true){
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
      
      this.partnerObj.Y_0_Total_Partner_Sales_kW__c = 0;
      if(this.partnerObj.PV_Watts_Sold_Q1__c!=null)
      	this.partnerObj.Y_0_Total_Partner_Sales_kW__c = this.partnerObj.Y_0_Total_Partner_Sales_kW__c+this.partnerObj.PV_Watts_Sold_Q1__c;
      if(this.partnerObj.PV_Watts_Sold_Q2__c!=null)
      	this.partnerObj.Y_0_Total_Partner_Sales_kW__c = this.partnerObj.Y_0_Total_Partner_Sales_kW__c+this.partnerObj.PV_Watts_Sold_Q2__c;      
      if(this.partnerObj.PV_Watts_Sold_Q3__c!=null)
      	this.partnerObj.Y_0_Total_Partner_Sales_kW__c = this.partnerObj.Y_0_Total_Partner_Sales_kW__c+this.partnerObj.PV_Watts_Sold_Q3__c;
      if(this.partnerObj.PV_Watts_Sold_Q4__c!=null)
      	this.partnerObj.Y_0_Total_Partner_Sales_kW__c = this.partnerObj.Y_0_Total_Partner_Sales_kW__c+this.partnerObj.PV_Watts_Sold_Q4__c;
      	
      	System.debug(loggingLevel.INFO,'Debug: Y_0_Total_Partner_Sales_kW__c ' + this.partnerObj.Y_0_Total_Partner_Sales_kW__c);
      Double PV_Watts_sold_2_years_YOY = 0;
     Double PV_Watts_sold_1_years_YOY = 0;
     Double PV_Watts_sold_this_years_YOY = 0;
     if (this.partnerObj.Y_0_Total_Partner_Sales_kW__c!=null && this.partnerObj.PV_Watts_Sold_last_year__c!=null){
     		if(this.partnerObj.PV_Watts_Sold_last_year__c!=0)//for case 00050642
          		PV_Watts_sold_this_years_YOY = ((this.partnerObj.Y_0_Total_Partner_Sales_kW__c - this.partnerObj.PV_Watts_Sold_last_year__c)/this.partnerObj.PV_Watts_Sold_last_year__c)*100;
          	else//for case 00050642
          		PV_Watts_sold_this_years_YOY = 0;//for case 00050642
     } 
     if (this.partnerObj.PV_Watts_Sold_2_years_ago__c!=null && this.partnerObj.PV_Watts_Sold_3_years_ago__c!=null){
     	if(this.partnerObj.PV_Watts_Sold_3_years_ago__c!=0)//for case 00050642
          	PV_Watts_sold_2_years_YOY = ((this.partnerObj.PV_Watts_Sold_2_years_ago__c - this.partnerObj.PV_Watts_Sold_3_years_ago__c)/this.partnerObj.PV_Watts_Sold_3_years_ago__c)*100;
        else//for case 00050642
          	PV_Watts_sold_2_years_YOY = 0;//for case 00050642  	
     }    	
     if (this.partnerObj.PV_Watts_Sold_last_year__c!=null && this.partnerObj.PV_Watts_Sold_2_years_ago__c!=null){
     	if(this.partnerObj.PV_Watts_Sold_2_years_ago__c!=0)//for case 00050642
          	PV_Watts_sold_1_years_YOY = ((this.partnerObj.PV_Watts_Sold_last_year__c - this.partnerObj.PV_Watts_Sold_2_years_ago__c)/this.partnerObj.PV_Watts_Sold_2_years_ago__c)*100;
        else//for case 00050642
          	PV_Watts_sold_1_years_YOY = 0;//for case 00050642  	
     }
     if(PV_Watts_sold_2_years_YOY>20 && PV_Watts_sold_1_years_YOY>20){
     	this.partnerObj.Greater_than_20_CAGR_over_last_2_years__c = true;
     }	
        System.debug(loggingLevel.INFO,'Debug: PV_Watts_sold_2_years_YOY ' + PV_Watts_sold_2_years_YOY);
        System.debug(loggingLevel.INFO,'Debug: PV_Watts_sold_1_years_YOY ' + PV_Watts_sold_1_years_YOY);
        System.debug(loggingLevel.INFO,'Debug: PV_Watts_sold_this_years_YOY ' + PV_Watts_sold_this_years_YOY);
      
      if(this.partnerObj.Existing_Pending_Litigation__c != null 
        && this.partnerObj.Existing_Pending_Litigation__c == false){            
            this.partnerObj.Litigation_Score__c = 3;    
      }
      
      if(this.partnerObj.Field_Level_Design_Employees__c !=null && 
        this.partnerObj.Field_Level_Design_Employees__c >=5){
            this.partnerObj.Engineering_Score__c = 5;
      }else{
      	this.partnerObj.Engineering_Score__c = this.partnerObj.Field_Level_Design_Employees__c;
      }
      
      if(this.partnerObj.Showroom__c == true){
            this.partnerObj.Showroom_Score__c = 3;
      }else{
      	    this.partnerObj.Showroom_Score__c = 0;
      }
      
      if(this.partnerObj.CRM__c == true){
            this.partnerObj.CRM_Score__c = 2;
      }else{
      	this.partnerObj.CRM_Score__c = 0;
      }
      
      
      if(this.partnerObj.Installation_Vehicle_Fleet__c == true){
            this.partnerObj.Install_truck_Score__c = 3;
      }else{
      	this.partnerObj.Install_truck_Score__c = 0;
      }
      

      if(this.partnerObj.Current_Industry__c != null 
        && this.partnerObj.Current_Industry__c == 'PV or Solar'){      
            
        if (this.partnerObj.Years_in_Business__c!=null){
            //Start 95084 set maximum to 5 for Germany ,8 for others    
            if(isGermany && this.partnerObj.Years_in_Business__c >= 5){
              this.partnerObj.History_in_PV_Score__c = 5;
            }else if(!isGermany && this.partnerObj.Years_in_Business__c >= 8){
              this.partnerObj.History_in_PV_Score__c = 8;
            }//End 95084
            else{
              this.partnerObj.History_in_PV_Score__c = this.partnerObj.Years_in_Business__c;
            }
        }
      }
       else if (this.partnerObj.PV_Experience_years__c!=null){      
       	    //Start 95084 set maximum to 5 for Germany ,8 for others      
            if(isGermany && this.partnerObj.PV_Experience_years__c >= 5){
              this.partnerObj.History_in_PV_Score__c = 5;
            }else if(!isGermany && this.partnerObj.PV_Experience_years__c >= 8){
              this.partnerObj.History_in_PV_Score__c = 8;
            }//End 95084
            else{
              this.partnerObj.History_in_PV_Score__c = this.partnerObj.PV_Experience_years__c;
            }
        }                
        Double average = ( PV_Watts_sold_1_years_YOY
                + PV_Watts_sold_2_years_YOY
                + PV_Watts_sold_this_years_YOY) / 3;
                
        if(average < 30){
          this.partnerObj.Historic_growth_rate_Score__c = 0;    
        }
        else if(average > 80){
          this.partnerObj.Historic_growth_rate_Score__c = 5;
        }else{
        	this.partnerObj.Historic_growth_rate_Score__c = 3;
        }
        System.debug(loggingLevel.INFO,'Debug: average ' + average);
      System.debug(loggingLevel.INFO,'Debug: Historic_growth_rate_Score__c ' + this.partnerObj.Historic_growth_rate_Score__c);
      
      if(this.partnerObj.Bank_Guarantee__c == true){
        this.partnerObj.Well_capitalized_Score__c = score;
      }else{
      	this.partnerObj.Well_capitalized_Score__c = 0;
      }
      
      //Start 95084
      if(isGermany && this.partnerObj.Company_have_fulltime_master_electrician__c){
      	this.partnerObj.Electrician_Score__c = 3;
      }else{
      	this.partnerObj.Electrician_Score__c = 0;
      }
      //End 95084
      if(isItaly && this.partnerObj.Tabelle_e_abilitazioni_more_than_5_years__c){
      	this.partnerObj.Abilitazioni_Score__c = 3;
      }else{
      	this.partnerObj.Abilitazioni_Score__c = 0;
      } 
      if(this.partnerObj.Marketing_Material__c!=null){   
      	this.partnerObj.Basic_sales_collateral__c = this.partnerObj.Marketing_Material__c;
      }
      Double empScore;      
      if (this.partnerObj.Manager_Level_Employees__c != null && this.partnerObj.Manager_Level_Employees__c >= 3) {
          empScore = 3;
      } else {
          empScore = this.partnerObj.Manager_Level_Employees__c;
      }
      
      if (isCVARApplication == true) {
          this.partnerObj.Commercial_Employees_Score__c = empScore;
      } else {
          this.partnerObj.Employees_Score__c = empScore;
      }

      if(this.partnerObj.Manager_Sales_Employees__c != null 
        && this.partnerObj.Manager_Sales_Employees__c >= 1){
            this.partnerObj.Sales_manager_Score__c = score;
      }     
    
      
      if(this.partnerObj.Manager_Marketing_Employees__c != null && 
        this.partnerObj.Manager_Marketing_Employees__c >= 1){
            this.partnerObj.Marketing_Manager_Score__c = score;
      }
      
      setEUApplicationScore();
      update partnerObj;   
      isSuccess = true;     
    }    
    return isSuccess;
    
  }
  
  public void setEUApplicationScore(){
  	if(partnerObj.Employees_Score__c==null)
        partnerObj.Employees_Score__c =0;
      if(partnerObj.Litigation_Score__c==null)
        partnerObj.Litigation_Score__c =0;
      if(partnerObj.Engineering_Score__c==null)
        partnerObj.Engineering_Score__c =0;
      if(partnerObj.Showroom_Score__c==null)
        partnerObj.Showroom_Score__c =0;
      if(partnerObj.Install_truck_Score__c==null)
        partnerObj.Install_truck_Score__c =0;  
      if(partnerObj.History_in_PV_Score__c==null)
        partnerObj.History_in_PV_Score__c =0;
      if(partnerObj.Historic_growth_rate_Score__c==null)
        partnerObj.Historic_growth_rate_Score__c =0;
      if(partnerObj.Well_capitalized_Score__c==null)
        partnerObj.Well_capitalized_Score__c =0;
      if(partnerObj.Sales_manager_Score__c==null)
        partnerObj.Sales_manager_Score__c =0;
      if(partnerObj.CRM_Score__c==null)
        partnerObj.CRM_Score__c =0;
      if(partnerObj.Marketing_Manager_Score__c==null)
        partnerObj.Marketing_Manager_Score__c =0;
      if(this.partnerObj.Abilitazioni_Score__c == null){
      	this.partnerObj.Abilitazioni_Score__c = 0;
      }
      //Start 95084
      if(partnerObj.Electrician_Score__c==null)
        partnerObj.Electrician_Score__c =0;
  	partnerObj.Calculated_Application_Score__c =
      	  partnerObj.Employees_Score__c +
      	  partnerObj.Litigation_Score__c +
      	  partnerObj.Engineering_Score__c+
      	  partnerObj.Showroom_Score__c+
      	  partnerObj.Install_truck_Score__c+
      	  partnerObj.History_in_PV_Score__c+
      	  partnerObj.Historic_growth_rate_Score__c+
      	  partnerObj.Well_capitalized_Score__c+
      	  partnerObj.Sales_manager_Score__c+
      	  partnerObj.CRM_Score__c +
      	  partnerObj.Marketing_Manager_Score__c+
      	  partnerObj.Abilitazioni_Score__c+
      	  partnerObj.Electrician_Score__c;
     //End 95084 	  
  }
    
    public PageReference calculateFieldValues_ES(){
    PageReference pr = null;     
    if(calculate()) {
        pr = new PageReference('/apex/Partner_Application_Score_es?id='+id +'&Type=BGSM');
        pr.setRedirect(true);
    }   
     return pr;  
    }
    
  public PageReference quickSavePartnerApp_es(){
    if(this.partnerObj != null){
    	setEUApplicationScore();
      update partnerObj;
      partnerObj = null;  
    }   
    
    String prUrl;
    if (isCVARApplication == true) {
        prUrl = '/apex/New_Partner_Scorecard_CVAR?id=' + id;
    } else {
        prUrl = '/apex/Partner_Application_Score_es?id=' + id;
    }
    
    if (autoComplete) {
        prUrl += '&Type=BGSM';
    }
    
    PageReference pr = new PageReference(prUrl);
    pr.setRedirect(true);
    return pr;
  }
  
  public PageReference savePartnerApp_es(){
    if(this.partnerObj != null){
    	setEUApplicationScore();
      update partnerObj;    
    }
    PageReference pr = new PageReference('/' + id);
    pr.setRedirect(true);
    return pr;   
  }
}