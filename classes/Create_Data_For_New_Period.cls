/************ CLASS TO GENERATE METRICS FOR A GIVEN PERIOD********************/
public class Create_Data_For_New_Period 
{
/***** VARIABLES *****/
    public boolean flag {get{return flag;} set{flag=value;}}
    public Integer currentYear;    
    public Integer previousYear;
    public Integer NextYear;
    public String period1 = 'P1';
    public String period2 = 'P2';
    public List<Global_Dealer_Program__c> newGdp = new List<Global_Dealer_Program__c>();
    public List<Metrics__c> loMetrics = new List<Metrics__c>();     
    private Global_Dealer_Program__c  lo_GlobalDealerProgram = new Global_Dealer_Program__c(); 
    public List<Metric_Template__c> newMT = new List<Metric_Template__c>();
    
/***** END VARIABLES *****/
 
/******CONSTRUCTOR ******/
    public  Create_Data_For_New_Period(ApexPages.StandardController controller)
    {
        flag = false;// Indicates whether the metrics has been created or not
        currentYear = System.TODAY().YEAR();
        previousYear = currentYear-1;
        nextYear = currentYear+1;  
       
    }
/*****END CONSTRUCTOR******/  
     
/***** PROPERTY *****/
    public Global_Dealer_Program__c  prop_GDP{ get{return lo_GlobalDealerProgram;} set{lo_GlobalDealerProgram = value;}}
/***** END PROPERTY *****/   

/***** FUNCTION *****/  
    public PageReference Cancel()
    {
        PageReference GDP_List = new PageReference('/apex/GDPTab');
        return GDP_List;
    } 
    public PageReference Save() 
    {// Check For Duplicate Period Data
        List<Global_Dealer_Program__c> lst_checkGDP =[SELECT id,
                                                        Account_Type__c,
                                                        Country_Domain__c,
                                                        Current_Performance_Period_Start_Date__c,
                                                        Current_Performance_Period_End_Date__c,
                                                        Previous_Performance_Period_Start_Date__c,
                                                        Previous_Performance_Period_End_Date__c,
                                                        Display_Row__c
                                                        FROM Global_Dealer_Program__c WHERE Performance_Period__c=:lo_GlobalDealerProgram.Performance_Period__c AND Performance_Year__c=:lo_GlobalDealerProgram.Performance_Year__c];
        
    if(lst_checkGDP.isEmpty())
    { // Check whether the data specified by the user is for current year and for period 2
      if(lo_GlobalDealerProgram.Performance_Year__c == currentYear && lo_GlobalDealerProgram.Performance_Period__c == period2)
      { 
         Create_Global_Dealer_Programs(period1,currentYear);
         try
         {      
            insert newGdp;// Insert new Global Dealer Programs
         }
         catch(DMLException e)
         {
            ApexPages.Message gdp4Msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Insert Failed on Global Dealer Program due to the following error:'+e.getMessage());
            ApexPages.addMessage(gdp4Msg);
            flag = false;
         }//END TRY-CATCH
         InsertMetricTemplates(period1,currentYear);//Insert New Metric Templates
         startbatch();
         ApexPages.Message success = new ApexPages.Message(ApexPages.Severity.INFO,'The batch job for creating Metrics has been invoked. You will be notified when it is completed. Thank You.');
         ApexPages.addMessage(success);
      }             
      else if((lo_GlobalDealerProgram.Performance_Year__c == currentYear ) && lo_GlobalDealerProgram.Performance_Period__c == period1)
      {
        Create_Global_Dealer_Programs(period2,previousYear);    
        try
        {       
            insert newGdp;// Insert new Global Dealer Programs          
        }
        catch(DMLException e)
        {
            ApexPages.Message gdp1Msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Insert Failed on Global Dealer Program due to the following error:'+e.getMessage());
            ApexPages.addMessage(gdp1Msg);
            flag = false;
        }//END TRY-CATCH 
        InsertMetricTemplates(period2,previousYear);//Insert New Metric Templates   
        startbatch();
        ApexPages.Message success = new ApexPages.Message(ApexPages.Severity.INFO,'The batch job for creating Metrics has been invoked. You will be notified when it completed. Thank You.');
        ApexPages.addMessage(success);
      }
      else if(( lo_GlobalDealerProgram.Performance_Year__c == nextYear) && lo_GlobalDealerProgram.Performance_Period__c == period1)
      {
        Create_Global_Dealer_Programs(period2,nextYear-1);  
        try
        {                 
            insert newGdp;// Insert new Global Dealer Programs          
        }
        catch(DMLException e)
        {
            ApexPages.Message gdp1Msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Insert Failed on Global Dealer Program due to the following error:'+e.getMessage());
            ApexPages.addMessage(gdp1Msg);
            flag = false;
        }//END TRY-CATCH  
        InsertMetricTemplates(period1,nextYear);//Insert New Metric Templates
        startbatch();
        ApexPages.Message success = new ApexPages.Message(ApexPages.Severity.INFO,'The batch job for creating Metrics has been invoked. You will be notified when it completed. Thank You.');
        ApexPages.addMessage(success);
      }
      else
      {
        ApexPages.Message gdp3Msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the data for Next Period Only');
        ApexPages.addMessage(gdp3Msg);
        flag = false;
      }// END ELSE-IF
      return null;
    }
    else
    {
        ApexPages.Message duplicateGDP = new ApexPages.Message(ApexPages.Severity.ERROR,'The Global Dealer Programs for this Period already exist');
        ApexPages.addMessage(duplicateGDP);
        return null;
    }
   }//END FUNCTION Save     
    
/******************** Mehod To Create Global Dealer programs*********************/  
 public void Create_Global_Dealer_Programs(String str_loPeriod,Integer int_currYear)
 {//fetch all the Global Dealer Programs that exist for the previous period
     List<Global_Dealer_Program__c> lst_gdp =[SELECT id,
                                            Account_Type__c,
                                            Country_Domain__c,
                                            Current_Performance_Period_Start_Date__c,
                                            Current_Performance_Period_End_Date__c,
                                            Previous_Performance_Period_Start_Date__c,
                                            Previous_Performance_Period_End_Date__c,
                                            Countries_Supported__c,
                                            Display_Row__c
                                            FROM Global_Dealer_Program__c WHERE Performance_Period__c=:str_loPeriod AND Performance_Year__c=:int_currYear]; 
    if(!lst_gdp.isEmpty())
   {// Loop To iterate over each Global Dealer Program that belongs to Period 1 to copy the data into the new Global Dealer Program
     for(Global_Dealer_Program__c gd :lst_gdp)
     {
        newGdp.add(new Global_Dealer_Program__c(Account_Type__c = gd.Account_Type__c,
                    Country_Domain__c=gd.Country_Domain__c,                
                    Current_Performance_Period_Start_Date__c = lo_GlobalDealerProgram.Current_Performance_Period_Start_Date__c,
                    Current_Performance_Period_End_Date__c = lo_GlobalDealerProgram.Current_Performance_Period_End_Date__c,
                    First_Quarter_of_Performance_Period__c = lo_GlobalDealerProgram.First_Quarter_of_Performance_Period__c,            
                    Second_Quarter_of_Performance_Period__c = lo_GlobalDealerProgram.Second_Quarter_of_Performance_Period__c,
                    Performance_Year__c = lo_GlobalDealerProgram.Performance_Year__c,
                    Performance_Period__c = lo_GlobalDealerProgram.Performance_Period__c,
                    Previous_Performance_Period_Start_Date__c= gd.Current_Performance_Period_Start_Date__c,
                    Previous_Performance_Period_End_Date__c = gd.Current_Performance_Period_End_Date__c,
                    Display_Row__c = gd.Display_Row__c,
                    Countries_Supported__c = gd.Countries_Supported__c,
                    Data_Load_Identifier__c = 'GDP'+Math.random()));                
     }//END FOR 
   }
   else
    {
        ApexPages.Message gdp2Msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please create the data for next period only');
        ApexPages.addMessage(gdp2Msg);
        flag = false;
    }//END IF-ELSE  
 }//END FUNC Create_Global_Dealer_Programs
 /***************************Method to insert the Metric Templates for the Global Dealer Programs*******************************/
 public void InsertMetricTemplates(String arg_Period,Integer arg_Year)
 {
    
    
    //Loop to iterate over the newly created Global Dealer Program  
    for(Global_Dealer_Program__c gdr :newGdp)
    {
        //Fetch all the Metric Templates for Previous Period that matches the Account Type and Country Domain in the GDP
        for(List<Metric_Template__c> mtemp :[SELECT id,                                                
                                    Account_Type__c, 
                                    Bonus_Display__c, 
                                    Bonus_Value__c, 
                                    Countries_Supported__c, 
                                    Country_Domain__c, 
                                    Current_Performance_Period_End_Date__c,
                                    Current_Performance_Period_Start_Date__c,
                                    Display_Flag__c, 
                                    First_Quarter_of_Performance_Period__c, 
                                    Global_Dealer_Program__c,
                                    Goal_for_Bonus_Display__c, 
                                    Goal_for_Bonus_Help_Text__c, 
                                    Goal_For_Bonus_Help_Text_Dutch__c, 
                                    Goal_For_Bonus_Help_Text_English__c, 
                                    Goal_For_Bonus_Help_Text_French__c, 
                                    Goal_For_Bonus_Help_Text_German__c, 
                                    Goal_For_Bonus_Help_Text_Italian__c, 
                                    Goal_For_Bonus_Help_Text_Spanish__c, 
                                    Goal_for_Bonus_Value__c, 
                                    Goal_for_Promotion_Display__c, 
                                    Goal_for_Promotion_Help_Text__c, 
                                    Goal_for_Promotion_Help_Text_dutch__c, 
                                    Goal_for_Promotion_Help_Text_English__c, 
                                    Goal_for_Promotion_Help_Text_French__c, 
                                    Goal_for_Promotion_Help_Text_German__c, 
                                    Goal_for_Promotion_Help_Text_Italian__c, 
                                    Goal_for_Promotion_Help_Text_Spanish__c, 
                                    Goal_for_Promotion_Value__c, 
                                    Goal_for_Retention_Display__c, 
                                    Goal_for_Retention_Help_Text__c, 
                                    Goal_for_Retention_Help_Text_Dutch__c, 
                                    Goal_for_Retention_Help_Text_English__c, 
                                    Goal_for_Retention_Help_Text_French__c, 
                                    Goal_for_Retention_Help_Text_German__c, 
                                    Goal_for_Retention_Help_Text_Italian__c, 
                                    Goal_for_Retention_Help_Text_Spanish__c, 
                                    Goal_for_Retention_Value__c, 
                                    Metric_Category__c, 
                                    Metric_Category_Dutch__c, 
                                    Metric_Category_French__c, 
                                    Metric_Category_German__c,
                                    Metric_Category_Italian__c, 
                                    Metric_Category_Spanish__c, 
                                    Metric_Code__c, 
                                    Metric_Name__c, 
                                    Metric_Name_Dutch__c, 
                                    Metric_Name_French__c, 
                                    Metric_Name_German__c, 
                                    Metric_Name_Italian__c, 
                                    Metric_Name_Spanish__c,
                                    Metric_Parent_Code__c,
                                    Metric_Result_Type__c,
                                    Performance_Period__c,
                                    Performance_Year__c,
                                    Previous_Performance_Period_End_Date__c,
                                    Previous_Performance_Period_Start_Date__c,
                                    Result_Goal_Comparison__c, 
                                    Result_Post_Concat__c,
                                    Result_Pre_Concat__c, 
                                    Second_Quarter_of_Performance_Period__c,
                                    Submetric_Identifier__c, 
                                    Summary_Metric__c, 
                                    Where_to_Display__c,
                                    Metric_Order__c
                                    FROM Metric_Template__c WHERE Account_Type__c=:gdr.Account_Type__c AND Country_Domain__c=:gdr.Country_Domain__c AND Performance_Period__c=:arg_Period AND Performance_Year__c=:arg_Year])
                                    
        if(!mtemp.isEmpty())
        {
           // Loop to iterate over all the Period 1 Metric Templates in order to copy the same data while creating new Metric Templates for Period 2
            for(Metric_Template__c mt : mtemp)
            { 
                
                newMT.add(new Metric_Template__c(Bonus_Display__c =  mt.Bonus_Display__c,
                                                Bonus_Value__c =  mt.Bonus_Value__c,
                                                Display_Flag__c =  mt.Display_Flag__c,
                                                Global_Dealer_Program__c=  gdr.id,
                                                Goal_for_Bonus_Display__c =  mt.Goal_for_Bonus_Display__c,
                                                Goal_for_Bonus_Help_Text__c =  mt.Goal_for_Bonus_Help_Text__c,
                                                Goal_For_Bonus_Help_Text_Dutch__c =  mt.Goal_For_Bonus_Help_Text_Dutch__c,
                                                Goal_For_Bonus_Help_Text_English__c =  mt.Goal_For_Bonus_Help_Text_English__c,
                                                Goal_For_Bonus_Help_Text_French__c =  mt.Goal_For_Bonus_Help_Text_French__c,
                                                Goal_For_Bonus_Help_Text_German__c =  mt.Goal_For_Bonus_Help_Text_German__c,
                                                Goal_For_Bonus_Help_Text_Italian__c =  mt.Goal_For_Bonus_Help_Text_Italian__c,
                                                Goal_For_Bonus_Help_Text_Spanish__c =  mt.Goal_For_Bonus_Help_Text_Spanish__c,
                                                Goal_for_Bonus_Value__c =  mt.Goal_for_Bonus_Value__c,
                                                Goal_for_Promotion_Display__c =  mt.Goal_for_Promotion_Display__c,
                                                Goal_for_Promotion_Help_Text__c =  mt.Goal_for_Promotion_Help_Text__c,
                                                Goal_for_Promotion_Help_Text_dutch__c =  mt.Goal_for_Promotion_Help_Text_dutch__c,
                                                Goal_for_Promotion_Help_Text_English__c =  mt.Goal_for_Promotion_Help_Text_English__c,
                                                Goal_for_Promotion_Help_Text_French__c =  mt.Goal_for_Promotion_Help_Text_French__c,
                                                Goal_for_Promotion_Help_Text_German__c =  mt.Goal_for_Promotion_Help_Text_German__c,
                                                Goal_for_Promotion_Help_Text_Italian__c =  mt.Goal_for_Promotion_Help_Text_Italian__c,
                                                Goal_for_Promotion_Help_Text_Spanish__c =  mt.Goal_for_Promotion_Help_Text_Spanish__c,
                                                Goal_for_Promotion_Value__c =  mt.Goal_for_Promotion_Value__c,
                                                Goal_for_Retention_Display__c =  mt.Goal_for_Retention_Display__c,
                                                Goal_for_Retention_Help_Text__c =  mt.Goal_for_Retention_Help_Text__c,
                                                Goal_for_Retention_Help_Text_Dutch__c =  mt.Goal_for_Retention_Help_Text_Dutch__c,
                                                Goal_for_Retention_Help_Text_English__c =  mt.Goal_for_Retention_Help_Text_English__c,
                                                Goal_for_Retention_Help_Text_French__c =  mt.Goal_for_Retention_Help_Text_French__c,
                                                Goal_for_Retention_Help_Text_German__c =  mt.Goal_for_Retention_Help_Text_German__c,
                                                Goal_for_Retention_Help_Text_Italian__c =  mt.Goal_for_Retention_Help_Text_Italian__c,
                                                Goal_for_Retention_Help_Text_Spanish__c =  mt.Goal_for_Retention_Help_Text_Spanish__c,
                                                Goal_for_Retention_Value__c =  mt.Goal_for_Retention_Value__c,
                                                Metric_Category__c =  mt.Metric_Category__c,
                                                Metric_Category_Dutch__c =  mt.Metric_Category_Dutch__c,
                                                Metric_Category_French__c =  mt.Metric_Category_French__c,
                                                Metric_Category_German__c=  mt.Metric_Category_German__c,
                                                Metric_Category_Italian__c =  mt.Metric_Category_Italian__c,
                                                Metric_Category_Spanish__c =  mt.Metric_Category_Spanish__c,
                                                Metric_Code__c =  mt.Metric_Code__c,
                                                Metric_External_ID__c =  'MT'+Math.random(),
                                                Metric_Name__c =  mt.Metric_Name__c,
                                                Metric_Name_Dutch__c =  mt.Metric_Name_Dutch__c,
                                                Metric_Name_French__c =  mt.Metric_Name_French__c,
                                                Metric_Name_German__c =  mt.Metric_Name_German__c,
                                                Metric_Name_Italian__c =  mt.Metric_Name_Italian__c,
                                                Metric_Name_Spanish__c=  mt.Metric_Name_Spanish__c,
                                                Metric_Parent_Code__c=  mt.Metric_Parent_Code__c,
                                                Metric_Result_Type__c=  mt.Metric_Result_Type__c,                                                
                                                Result_Goal_Comparison__c =  mt.Result_Goal_Comparison__c,
                                                Result_Post_Concat__c=  mt.Result_Post_Concat__c,
                                                Result_Pre_Concat__c =  mt.Result_Pre_Concat__c,
                                                Submetric_Identifier__c =  mt.Submetric_Identifier__c,
                                                Summary_Metric__c =  mt.Summary_Metric__c,
                                                Where_to_Display__c=  mt.Where_to_Display__c,
                                                Metric_Order__c = mt.Metric_Order__c));                                                    
                  
            }//END FOR                  
        }
        else
        {
            ApexPages.Message newMTMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'There were no metric Templates matching the criteria and therefore no new Metric Templates were created');
            ApexPages.addMessage(newMTMsg); 
            flag = false;
        }//END IF-ELSE                    
    }//END FOR           
    try
    {         
        insert newMT;
    }
    catch(DMLException e)
    {
        ApexPages.Message newMT1Msg = new ApexPages.Message(ApexPages.Severity.FATAL,'Insert on Metric Templates failed due to the following error'+e.getMessage());
        ApexPages.addMessage(newMT1Msg);         
    }//END TRY-CATCH
 }//END FUNC InsertMetricTemplates  
 
 /*************** METHOD TO INVOKE BATCH APEX*************/
 public void startbatch()
 {
    Batch_Create_Metrics_for_Accounts bcm = new Batch_Create_Metrics_for_Accounts();
    List<String> lstAccTypes = new List<String>();
    List<String> lst_CountrySupp = new List<String>();
    
    List<AsyncApexJob> openJobs = [select Id from AsyncApexJob where Status = 'Processing' OR Status = 'Queued']; 
    if(openJobs.size() < 5)
    {
        
       if(!newGdp.isEmpty())
       for(Global_Dealer_Program__c mts : newGdp)
       {
            lstAccTypes.add(mts.Account_Type__c);
            lst_CountrySupp.add(mts.Countries_Supported__c);
       }    
        bcm.prop_CurrentPeriod = lo_GlobalDealerProgram.Performance_Period__c;
        bcm.prop_CurrentYear = (Integer)lo_GlobalDealerProgram.Performance_Year__c; 
        bcm.prop_lst_InsertedMetricTemplate = newMT;
        bcm.lstAccTypes = lstAccTypes;
        bcm.lst_CountrySupp = lst_CountrySupp;      
        
        if(!Test.isRunningTest())
        {
            ID batchprocessid = Database.executeBatch(bcm,50);
        }
        else
        {
            ID batchprocessid = Database.executeBatch(bcm,200);
        }
    }
    else
    {
        ApexPages.Message batchError = new ApexPages.Message(ApexPages.Severity.FATAL,'Only five batch jobs at a time.');
        ApexPages.addMessage(batchError);    
    }
    
    
 }//END FUNC startBatch
 
 
 
/*** END FUNCTION ***/                 
} // END CLASS Birlasoft_DataforPeriod2