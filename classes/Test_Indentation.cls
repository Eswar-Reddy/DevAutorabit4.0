/********************* Controller To Override the Metrics data w.r.t the selected Account ****************************/
public class Test_Indentation
{    
/******* VARIABLES *************/
 //public String prop_acctSelected{get;set;}
 //public List<SelectOption> prop_accList{get;set;}
 public List<SelectOption> lst_selectedAcc = new List<SelectOption>();  
 public List<SelectOption> lst_AccOption = new List<SelectOption>();  
 public List<Account> lst_Account = new List<Account>();
 public List<Metrics__c> prop_MetricList{get;set;}
 public String str_color;
 public ID id_GDP;
 public Integer str_currentYear;
 public Boolean flag=false;
 public Boolean prop_check{get;set;}
 public Boolean showSave;
 public Boolean disable_text; 
 public Integer count;
 public String str_GDP_PerformancePeriod ;
 public Double int_GDP_PerformanceYear ;
 public Boolean parentOrChild;
 public List<String> lst_Alphabets;
 /* String value for the Alphabets */
    String strAlpha; 
    String AccSel;
    /*******END VARIABLES**********/ 

/************CONSTRUCTOR*******/    
 public Test_Indentation(ApexPages.StandardController controller) 
 {
    id_GDP = controller.getId();   
    prop_MetricList = new List<Metrics__c>();   
    parentOrChild = false;
    disable_text = true;
    showSave = false;
    count=0;
    showMetrics();  
 }
/**********END CONSTRUCTOR*******/
/**********PROPERTY*************/
 public Boolean bool_rend { get{return flag;} set{flag=value;}}
 Public Boolean check{get{return disable_text;} set{disable_text=value;}}
 public Boolean prop_showSave { get{return showSave;} set{showSave = value;}} 
/* Getter for the category value */
public String getprop_alphaSelected() { return this.strAlpha; }

/* Setter for the category value */
public void setprop_alphaSelected(String s) { this.strAlpha = s; }

public String getprop_acctSelected() { return this.AccSel; }

/* Setter for the category value */
public void setprop_acctSelected(String s) { this.AccSel = s; }
public Boolean prop_Img{get{return  parentOrChild;} set{ parentOrChild =value;}}
    
/********END PROPERTY***********/

/***********FUNCTION**************/
  public PageReference showMetrics()
  {
    //String str_getCurrentPeriod = Determine_Current_Period();
    List<Metrics__c> lst_Parent_metrics  = new List<Metrics__c>();
    String str_substring;
    if(AccSel == null)
    {
      if(lst_selectedAcc!=null && lst_selectedAcc.size() > 0)
      {
        AccSel = lst_selectedAcc.get(0).getvalue();
      }
    }
    if(AccSel!=null && AccSel!='' && str_GDP_PerformancePeriod !=null )
    {
        this.prop_MetricList.clear();
            prop_MetricList = [SELECT Goal_for_Bonus_Display__c,
                                    Goal_for_Bonus_Value__c,
                                    Goal_for_Promotion_Display__c,
                                    Goal_for_Promotion_Value__c,
                                    Goal_for_Retention_Display__c,
                                    Goal_for_Retention_Value__c,
                                    Goal_Override__c,
                                    Goal_for_Bonus_Display_Overridden__c,
                                    Goal_for_Bonus_Value_Overridden__c,
                                    Goal_for_Promotion_Display_Overridden__c,
                                    Goal_for_Promotion_Overridden__c,
                                    Goal_for_Retention_Display_Overidden__c,
                                    Goal_for_Retention_Overridden__c,
                                    Status_for_Bonus__c,
                                    Status_for_Promotion__c,
                                    Status_for_Retention__c,
                                    Result__c,
                                    Result_Override__c,
                                    Status_for_Bonus_Overidden__c,
                                    Status_for_Promotion_Overidden__c,
                                    Status_for_Retention_Overidden__c,
                                    Result_Overidden__c,
                                    Metric_Category__c,
                                    Type__c,
                                    Metric_Parent_Code__c,
                                    Metric_Code__c,
                                    Metric_parentChild__c,
                                    Metric_Name__c FROM Metrics__c WHERE Account__c=:AccSel AND Performance_Period__c=:str_GDP_PerformancePeriod AND Performance_Year__c=:int_GDP_PerformanceYear AND Where_to_Display__c='METRIC' ORDER BY Metric_Order__c];
       
                                    
      
    }
    bool_rend = true;
    return null;        
  }//END FUNC showMetrics

  public List<SelectOption> getprop_accList()
  {
    /******Local Valriables******/
    String r = strAlpha+'%';
    ID Id_AccRecordId;
    
     
    String str_GDP_AccType = [SELECT Account_Type__c FROM Global_Dealer_Program__c WHERE id =: id_GDP].Account_Type__c;
    String str_GDP_CoSupp = [SELECT Countries_Supported__c FROM Global_Dealer_Program__c WHERE id =: id_GDP].Countries_Supported__c;    
    Id_AccRecordId = [SELECT id,Name FROM RecordType WHERE sObjectType='Account' AND Name='Partner'].Id;
    str_GDP_PerformancePeriod = [SELECT Performance_Period__c FROM Global_Dealer_Program__c WHERE id=:id_GDP].Performance_Period__c;
    int_GDP_PerformanceYear = [SELECT Performance_Year__c FROM Global_Dealer_Program__c WHERE id=:id_GDP].Performance_Year__c;
    Set<String> lstAccTypes = new Set<String>();
    Set<String> lst_CountrySupp = new  Set<String>();   
    /******End Local Valriables******/
    //List<Metrics__c> lst_mt_acc= [SELECT id,Account__c FROM Metrics__c WHERE Performance_Period__c=:str_GDP_PerformancePeriod AND Performance_Year__c=:int_GDP_PerformanceYear LIMIT 49999];
   
    lstAccTypes = SplitAccTypes(str_GDP_AccType);
    
    lst_CountrySupp = SplitAccTypes(str_GDP_CoSupp);
    if(strAlpha!= NULL)
    {
        this.lst_AccOption.clear();
        lst_AccOption.add(new SelectOption('','- None -'));
        if(strAlpha != 'All' && strAlpha != 'Other')
        {
            lst_Account = [SELECT Name, Type, Country_Domain__c FROM Account WHERE Type IN:lstAccTypes AND BillingCountry IN :lst_CountrySupp AND RecordTypeId=:Id_AccRecordId AND id IN(SELECT Account__c FROM Metrics__c WHERE Performance_Period__c=:str_GDP_PerformancePeriod AND Performance_Year__c=:int_GDP_PerformanceYear) AND Name LIKE:strAlpha+'%'  ORDER BY Name]; 
        }
        if (strAlpha == 'al')
        {
            lst_Account = [SELECT Name, Type, Country_Domain__c FROM Account WHERE Type IN:lstAccTypes AND BillingCountry IN :lst_CountrySupp AND RecordTypeId=:Id_AccRecordId AND id IN(SELECT Account__c FROM Metrics__c WHERE Performance_Period__c=:str_GDP_PerformancePeriod AND Performance_Year__c=:int_GDP_PerformanceYear) ORDER BY Name]; 
        }
        if (strAlpha == 'ot')
        {
            lst_Account = [SELECT Name, Type, Country_Domain__c FROM Account WHERE Type IN:lstAccTypes AND BillingCountry IN :lst_CountrySupp AND RecordTypeId=:Id_AccRecordId AND id IN(SELECT Account__c FROM Metrics__c WHERE Performance_Period__c=:str_GDP_PerformancePeriod AND Performance_Year__c=:int_GDP_PerformanceYear) AND (NOT(Name LIKE 'A%'OR Name LIKE 'B%'OR Name LIKE 'C%'OR Name LIKE 'D%'OR Name LIKE 'E%'OR Name LIKE 'F%'OR Name LIKE 'G%'OR Name LIKE 'H%'OR Name LIKE 'I%'OR Name LIKE 'J%'OR Name LIKE 'K%'OR Name LIKE 'L%'OR Name LIKE 'M%'OR Name LIKE 'N%'OR Name LIKE 'O%'OR Name LIKE 'P%'OR Name LIKE 'Q%'OR Name LIKE 'R%'OR Name LIKE 'S%'OR Name LIKE 'T%'OR Name LIKE 'U%'OR Name LIKE 'V%'OR Name LIKE 'W%'OR Name LIKE 'X%'OR Name LIKE 'Y%'OR Name LIKE 'Z%'))ORDER BY Name]; 
        }
        if(!lst_Account.isEmpty())
        {
            for(Account ac: lst_Account)
            {
             lst_AccOption.add(new Selectoption(ac.Id,ac.Name));
            }
        
        }
    }
        return lst_AccOption;
  }//END FUNC CreateAccountList
  public void setprop_accList(List<SelectOption> se)
  {
    this.lst_selectedAcc = se;
  }
  
  public Set<String> SplitAccTypes(String sp)
  {
    List<String> lst_MatchAccTypes = new List<String>();
    List<String> splString = new List<String>();
    Set<String> set_splAcc; 
    splString = sp.split(', ');     
    set_splAcc = new Set<String>(splString);
    if(set_splAcc != null)
    {
        return set_splAcc;
    }
    else 
    {
        return null;
    }//END IF- ELSE
  }
  /*public String Determine_Current_Period()
  { 
    String str_currentPeriod;
    Set<String> set_Periods = new Set<String>();
    for(AggregateResult ar : [SELECT Performance_Period__c , Count(id) cou FROM Global_Dealer_Program__c WHERE Performance_Year__c=:str_currentYear GROUP BY Performance_Period__c ])
    {
        set_Periods.add(String.valueOf(ar.get('Performance_Period__c')));
    }
    if(!set_Periods.isEmpty())
    {
      if(set_Periods.contains('P2'))
      {
        str_currentPeriod = 'P2';
      }
      else
      {
        str_currentPeriod = 'P1';
      }
      return str_currentPeriod;
    }
    else
    {
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'This account does not have the Metrics for current period'));
        return null;
    }
   
  }//END Determine_Current_Period*/
   public PageReference saveMetrics()
   {
        update prop_MetricList;
         showSave = false;
         disable_text =true;
         prop_check =false;
        return null;
   }
   public pageReference setDisable()
   {
     if(prop_check==true) 
     {
        disable_text = false;
        showSave = true;
     }
     else
     {
        disable_text=true;
        showSave = false;
     }
     return null;
   }  
   public List<SelectOption> getprop_alphaList() 
    {
      List<SelectOption> optionList = new List<SelectOption>();
      lst_Alphabets = new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
      /* Add a null option to force the user to make a selection. */
     optionList.add(new SelectOption('','- None -'));
     optionList.add(new SelectOption('al','All'));
     optionList.add(new SelectOption('ot','Other'));
        for(String ls : lst_Alphabets)
        optionList.add(new SelectOption(ls,ls));
      
      return optionList;     
    }
/**********END FUNCTION**********/
}//END Class Test_Indentation