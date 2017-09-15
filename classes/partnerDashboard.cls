//PRASHNAT
//Optimizing the Dashboard page
public class partnerDashboard
{

    public String propSelPartenr { get; set; }
    public List<SelectOption> getPortalUserItems() 
    {   
            Map<String, String> mLang = new Map<String, String>();
              mLang.put('en_US', 'English');
              mLang.put('es'   , 'Spanish');
              mLang.put('fr'   , 'French');
              mLang.put('de'   , 'German');
              mLang.put('nl_NL', 'Dutch');
              mLang.put('it'   , 'Italian');
               
       List<SelectOption> lstPortalUserItems = new List<SelectOption>();                                           
            lstPortalUserItems.add(new SelectOption('-1', '')); 
            for(User usr : [SELECT Id, Name, LocaleSidKey, LanguageLocaleKey, Firstname, ContactId, Country_Domain__c, ProfileId, Profile.Name 
                            FROM User 
                            WHERE IsActive = true AND IsPortalEnabled = true AND ContactId <> null ORDER BY Name ASC LIMIT 6000])
            {
                lstPortalUserItems.add(new SelectOption(usr.Id + '--' + usr.LanguageLocaleKey, usr.Name + '\t\t ['  + ((mLang.containsKey(usr.LanguageLocaleKey )) ? mLang.get(usr.LanguageLocaleKey) : usr.LanguageLocaleKey).toLowerCase() + ']')); 
            }
       return lstPortalUserItems;       
    }//End prop getItems
    
    public String propPortalUsrId { get; set; }
    public void ChangePortalUser()
    { 
  SYSTEM.DEBUG('==> ' + propPortalUsrId);
      if(propPortalUsrId != null && propPortalUsrId != '-1')
      {
         if(propPortalUsrId.contains('--'))
         {
            propPortalUsrId = propPortalUsrId.split('--')[0];
             LoadData();
         }
      }
    }   

/***** VARIBABLE *****/
    public String MetricCodeBypass;
    public String bypassMetCode;
    Public String accType;  
    public boolean rescollapse;
    public boolean commcollapse;
    public boolean resRender;
    public boolean commRender;
    Public String countryDomain;
    Public String accountType;   
    public String accountName,partnerType,partnerTier;
    public String validEvalFromDate,validEvalToDate;
    public String SinceDate;
    String accTheatre;
    public Date todayDate;
    private List<Metrics__c> List_Metrics_Customer_Satisfaction = new List<Metrics__c>();
    private List<Metrics__c> List_Metrics_Dealer_Training= new List<Metrics__c>();
    private List<Metrics__c> List_Metrics_Perf_to_BusinessPlan = new List<Metrics__c>();
    private List<Metrics__c> List_Metrics_Marketing_Branding = new List<Metrics__c>();
    private List<WrapCat> lstWC = new List<WrapCat>();
    private List<WrapCat_COM> lstWC_MEU = new List<WrapCat_COM>();  
    private List<WrapCat_COM> lstWC_COM = new List<WrapCat_COM>();
    private List<WrapCat_RUS_Overall> lstWC_RUS = new List<WrapCat_RUS_Overall>();
    private List<WrapCat_CUS_Overall> lstWC_CUS = new List<WrapCat_CUS_Overall>();
    private List<WrapCat_EU_Overall> lstWC_EU = new List<WrapCat_EU_Overall>(); 

    User usr; 
    private List<Metrics__c> metricslist = new List<Metrics__c>();
    private String sPeriod = ''; 
    
    private List<WrapFinancial_RUS> lstWF11 = new List<WrapFinancial_RUS>();  //AMIT
    private List<WrapFinancial_CUS> lstWF12 = new List<WrapFinancial_CUS>(); // AMIT 

    private HideShowHandler objHSH_RES = new HideShowHandler(false, false, false, false);
    private HideShowHandler objHSH_COM = new HideShowHandler(false, false, false, false);
    private HideShowHandler objHSH_EU = new HideShowHandler(false, false, false, false);
    
/*** END VARIBABLE ***/ 

/***** PROPERTY *****/
    public Account relAccount {get;set;}
    public String propAccType{ get{ return accType; }  private set; }       
    public boolean prop_resCollapse{get{ return rescollapse;} set{rescollapse=value;}}
    public boolean prop_commCollapse{get{ return commcollapse;} set{commcollapse=value;}}
    public boolean prop_resRender{get{ return resRender;} set{resRender=value;}}
    public boolean prop_commRender{get{ return commRender;} set{commRender=value;}}
    public List<Metrics__c> propCustomer { get {return List_Metrics_Customer_Satisfaction;} private set;}
    public List<Metrics__c> propDealer { get {return List_Metrics_Dealer_Training;} private set;}
    public List<Metrics__c> propBusiness { get {return List_Metrics_Perf_to_BusinessPlan;} private set;}
    public List<Metrics__c> propMarketing { get {return List_Metrics_Marketing_Branding;} private set; }    
    public String propCDomain{ get{ return accountType; } }
    public String getAccountName(){ return this.accountName; }   
    public String getSinceDate(){ return this.SinceDate; } 
    public String getpartnerTier(){ return this.partnerTier; }
    public String getPartnerType(){ return this.partnerType; }   
    public String getAccTheatre(){ return accTheatre; }
    public String getValidEvalFromDate(){ return this.validEvalFromDate; }
    public String getValidEvalToDate(){ return this.validEvalToDate; }
    public List<WrapCat> propWC { get { return lstWC; } set { lstWC = value; } }
    public List<WrapCat_COM> propWC_EU { get { return lstWC_MEU; } set { lstWC_MEU = value; } }     
    public List<WrapCat_COM> propWC_COM { get { return lstWC_COM; } set { lstWC_COM = value; } }    
    public List<WrapCat_RUS_Overall> propWC_Overall_RUS { get { return lstWC_RUS; } set { lstWC_RUS = value; } }
    public List<WrapCat_CUS_Overall> propWC_Overall_CUS { get { return lstWC_CUS; } set { lstWC_CUS = value; } }
    public List<WrapCat_EU_Overall> propWC_Overall_EU { get { return lstWC_EU; } set { lstWC_EU = value; } }
    public String propEUAchieBypass { get {return MetricCodeBypass;} private set;}
    
    
// Commented on 20/06/12
   // public contact getContact(){ return [SELECT id, firstname, lastname, Email, Phone, Birthdate, Authorized_to_Order__c FROM Contact WHERE Id =:usr.ContactId]; } 

    //AMIT ###
    public List<WrapFinancial_CUS> propLstFin_Cus { get { return lstWF12; } set { lstWF12 = value; } } //Today
    public List<WrapFinancial_RUS> propLstFin_Rus { get { return lstWF11; } set { lstWF11 = value; } } //Today 
    
    
    
    public List<SelectOption> getItems()
    {
      Map<String, Global_Dealer_Program__c> mPPvsGDP = new Map<String, Global_Dealer_Program__c>();
      for(Global_Dealer_Program__c gdp : [SELECT Performance_Period_Final__c, 
                                                 Current_Performance_Period_Start_Date__c, 
                                                 Current_Performance_Period_End_Date__c 
                                          FROM Global_Dealer_Program__c 
                                          ORDER BY Performance_Period_Final__c, CreatedDate ASC
                                          LIMIT 10000])
      {
        if(mPPvsGDP.isEmpty())
          mPPvsGDP.put(gdp.Performance_Period_Final__c, gdp);
        else if(!mPPvsGDP.containsKey(gdp.Performance_Period_Final__c))
          mPPvsGDP.put(gdp.Performance_Period_Final__c, gdp);
      }

      List<SelectOption> options = new List<SelectOption>();
      if(!mPPvsGDP.isEmpty())
      {
        for(String str : mPPvsGDP.keySet())
        {
          String key = DateToString(mPPvsGDP.get(str).Current_Performance_Period_Start_Date__c) + '--' + DateToString(mPPvsGDP.get(str).Current_Performance_Period_End_Date__c); 
          options.add(new SelectOption(key, str));      
        }       
      }
      return options;
    }//End prop getItems
    
    
    public String propPeriod { get { return sPeriod; } set { sPeriod = value; } }
    public string propLastUpdated { get; private set; }    
    public User propUser { get{ return usr; } private set;}
    
    public HideShowHandler propHideShowHandler_RES { get { return objHSH_RES; } set; }
    public HideShowHandler propHideShowHandler_COM { get { return objHSH_COM; } set; }
    public HideShowHandler propHideShowHandler_EU { get { return objHSH_EU; } set; }    
    
/*** END PROPERTY ***/

/***** CONSTRUCTOR *****/
  public partnerDashboard()
  {
    LoadData();
  }
/*** END CONSTRUCTOR ***/    

/***** FUNCTION *****/

  public void LoadData()
  {
  
    MetricCodeBypass = GlobalDealerProgram__c.getInstance('EU').Override_Achievement__c;
    
    rescollapse =true;
    commcollapse =true;
    resRender =true;
    commRender =true;
          
  
    if(propPortalUsrId != null && propPortalUsrId != '-1' && (propPortalUsrId.length() == 15 || propPortalUsrId.length() == 18))
    {
      usr = [SELECT Id, Name, LocaleSidKey, LanguageLocaleKey, Firstname, ContactId, Country_Domain__c, ProfileId, Profile.Name 
                    FROM User WHERE id =: propPortalUsrId];                  
      if(usr != null && usr.Id != null)     
          AccntName();  
    }
    else
      usr = new User();  
  }
  
  public String DateToString(Date d)
  { 
    if(d != null)
      return (String.valueOf(d.year()) + '-' + String.valueOf(d.month()) + '-' + String.valueOf(d.day()));
    else
      return ('1900-01-01');
  }//End Func DateToString

  public void AccntName()
  {
    if(!List_Metrics_Customer_Satisfaction.isEmpty()) List_Metrics_Customer_Satisfaction.clear();
    if(!List_Metrics_Dealer_Training.isEmpty()) List_Metrics_Dealer_Training.clear();
    if(!List_Metrics_Perf_to_BusinessPlan.isEmpty()) List_Metrics_Perf_to_BusinessPlan.clear();
    if(!List_Metrics_Marketing_Branding.isEmpty()) List_Metrics_Marketing_Branding.clear();
    if(!lstWC.isEmpty()) lstWC.clear();
    if(!lstWC_COM.isEmpty()) lstWC_COM.clear(); 
    if(!lstWC_RUS.isEmpty()) lstWC_RUS.clear();
    if(!lstWC_CUS.isEmpty()) lstWC_CUS.clear();
    if(!lstWC_MEU.isEmpty()) lstWC_MEU.clear();
    if(!lstWC_EU.isEmpty()) lstWC_EU.clear();      
    if(!lstWF11.isEmpty()) lstWF11.clear();
    if(!lstWF12.isEmpty()) lstWF12.clear();
    
    //Set the Start/End Date to get the Metrix Data
    Date dStaD = null;
    Date dEndD = null;
    
System.debug('\n---0.0--propPeriod--> ' + propPeriod);    

    if(propPeriod != null && propPeriod != '-1' && propPeriod != ''){   
      dStaD = ChangetoDate(propPeriod, 'SD');
      dEndD = ChangetoDate(propPeriod, 'ED');
    }
    else{    
      dStaD = Date.Today();
      dEndD = Date.Today();
    }
    
    try
    {   
      Contact cObj = [SELECT id, Country_Domain__c, Account_Type__c,
                              Account.Id, Account.name, Account.type, 
                              Account.Country_Domain__c, Account.Theater__c, Account.Authorized_Partner_Date__c
                      FROM Contact 
                      WHERE Id =: usr.ContactId];
                      
System.debug('---0.2--cObj--> ' + cObj);
        relAccount = new Account(id= cObj.Account.Id,
                                 name= cObj.Account.Name,
                                 Type= cObj.Account.type,
                                 Country_Domain__c= cObj.Account.Country_Domain__c,
                                 Theater__c= cObj.Account.Theater__c,
                                 Authorized_Partner_Date__c= cObj.Account.Authorized_Partner_Date__c);//cObj.Account.Id; //accountId  
      accType = cObj.Account_Type__c; 
      countryDomain = cObj.Country_Domain__c;         
System.debug('>>>>4>>>> ' + relAccount);         
      if(relAccount != null && this.relAccount.Id != null)
      {
System.debug('>>>>5>>>> ');   
        Account acc = relAccount;
System.debug('---0.3--acc--> ' + acc);                 
System.debug('---0.4--propUser--> ' + propUser);        
        if(acc.type != null && acc.type.contains('Residential') && propUser.LanguageLocaleKey == 'en_US'){       
          resCollapse = false;
          resRender =true;
          commRender = false;
        } 
        if(acc.type != null && acc.type.contains('Commercial') && propUser.LanguageLocaleKey == 'en_US'){        
          commCollapse = false;
          commRender =true;
          resRender = false;
        } 
        if(acc.type != null && acc.type.contains('Combo') && (!acc.Country_Domain__c.contains('us')) && propUser.LanguageLocaleKey == 'en_US'){       
          commCollapse = false;
          commRender =true;
          resRender = false;
        }       
     
        if(acc != null)
        {
System.debug('>>>>6>>>> ' + relAccount);        
System.debug('---0--dStaD--> ' + dStaD + ' --dEndD--> ' +dEndD);        
          this.accountName = acc.Name;
          this.SinceDate = ''+ getDateFormat(acc.Authorized_Partner_Date__c);
         
          if(acc.Type != null && acc.Type.contains('-'))
          {
            this.partnerTier = acc.Type.subString(0,acc.Type.indexOf('-'));
            this.partnerType = acc.Type.subString(acc.Type.indexOf('-')+1,acc.Type.length());
          }             

          List<Metrics__c> CurrentMetrics = [SELECT id, Metric_Name__c, Metric_Parent_Code__c, Current_Performance_Period_End_Date__c,
                                                    Metric_Category__c, Current_Performance_Period_Start_Date__c, LastModifiedDate 
                                             FROM Metrics__c 
                                             WHERE account__c =: this.relAccount.Id AND  
                                                  (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD )];
        
          if(CurrentMetrics != null && CurrentMetrics.size() > 0 ){
            validEvalFromDate = ''+ getDateFormat(CurrentMetrics.get(0).Current_Performance_Period_Start_Date__c);
            validEvalToDate = ''+ getDateFormat(CurrentMetrics.get(0).Current_Performance_Period_End_Date__c);
            if(propUser.LanguageLocaleKey == 'en_US')// Case: 00155445
                propLastUpdated = CurrentMetrics.get(0).LastModifiedDate.format('MMMMM, dd yyyy HH:mmaaa z');
            else
                propLastUpdated = CurrentMetrics.get(0).LastModifiedDate.format('dd, MMMMM yyyy HH:mmaaa');
          }
          
/***** RESIDENTIAL START *****/
          List<String> lstCategory = new List<String>{'Customer Satisfaction', 'Dealer Training', 'Performance to Business Plan', 'Marketing / Branding'};          
          List<Metrics__c> lstMCode_Rus = [SELECT Metric_Code__c 
                                           FROM metrics__c 
                                           WHERE account__c =: this.relAccount.Id AND 
                                                 Where_to_Display__c = 'METRIC' AND 
                                                 Display_Flag__c ='Y' AND 
                                                 Metric_Code__c LIKE '%RUS%' AND
                                                 (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD )];                                  
       
          List<String> lstCode = new List<String>{};
            for(Metrics__c mt : lstMCode_Rus)
              lstCode.add( mt.Metric_Code__c);

          List<Metrics__c> lstAllME = [SELECT  id, 
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c,                                            
                                             Metric_Template__r.Global_Dealer_Program__r.id,                                            
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Achievement_Result__c,
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Stay_in_Same_Tier_Results__c,
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Promotion_to_Next_Tier_Results__c, 
                                             Goal_for_Bonus_Display_Final__c, Goal_for_Promotion_Display_Final__c, 
                                             Goal_for_Retention_Display_Final__c, Metric_Template__r.Metric_parentChild__c,
                                             Result__c, Metric_Order__c, Birlasoft_partner_Portal__c, Metric_Result_Type__c, 
                                             Metric_Template__r.Metric_Name__c, Metric_Template__r.Goal_for_Bonus_Help_Text__c,
                                             Goal_for_Retention_Value__c, Status_for_Retention__c,
                                             Status_for_Retention_Final__c, Goal_for_Promotion_Value__c,
                                             Status_for_Promotion_Final__c, Status_for_Promotion__c,
                                             Metric_Template__r.Goal_for_Promotion_Help_Text__c, 
                                             Metric_Template__r.Goal_for_Retention_Help_Text__c,
                                             Metric_Template__r.Metric_Result_Type__c, Metric_Template__r.Bonus_Value__c,
                                             Metric_Parent_Code__c, Metric_Code__c,
                                             Goal_for_Promotion_Help_Text_dutch__c, Goal_for_Promotion_Help_Text_English__c,
                                             Metric_Template__r.Goal_for_Promotion_Help_Text_English__c,
                                             Goal_for_Promotion_Help_Text_French__c, Goal_for_Promotion_Help_Text_German__c,
                                             Goal_for_Promotion_Help_Text_Italian__c, Goal_for_Promotion_Help_Text_Spanish__c,
                                             Goal_for_Retention_Help_Text_Dutch__c, Goal_for_Retention_Help_Text_English__c,
                                             Goal_for_Retention_Help_Text_French__c, Goal_for_Retention_Help_Text_German__c,
                                             Goal_for_Retention_Help_Text_Italian__c, Goal_for_Retention_Help_Text_Spanish__c,
                                             Goal_For_Bonus_Help_Text_English__c, Goal_For_Bonus_Help_Text_French__c, 
                                             Goal_For_Bonus_Help_Text_German__c, Goal_For_Bonus_Help_Text_Italian__c, 
                                             Goal_For_Bonus_Help_Text_Spanish__c, Goal_For_Bonus_Help_Text_Dutch__c,
                                             Metric_Category__c, Metric_Category_Dutch__c, Metric_Category_French__c,
                                             Metric_Category_German__c, Metric_Category_Italian__c, Metric_Category_Spanish__c,
                                             Metric_Name__c, Metric_Name_Dutch__c, Metric_Name_French__c,
                                             Metric_Name_German__c, Metric_Name_Italian__c, Metric_Name_Spanish__c,
                                             Result_Concat__c, Status_for_Bonus_Final__c,
                                             Calculated_Bonus_Final__c
                                    FROM Metrics__c 
                                    WHERE account__c =: this.relAccount.Id AND 
                                         (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD) AND 
                                          Metric_Category__c IN : lstCategory AND 
                                          Metric_Code__c IN : lstCode order by Metric_Order__c];
                                          
          System.debug('lstCategory--------------------'+lstCategory);
          Global_Dealer_Program__c tempGDP_RUS = new Global_Dealer_Program__c();
          
          for(String sC : lstCategory)
          {
            WrapCat tWC = new WrapCat();
            List<WrapMet> tWM = new lIST<WrapMet>();      
            for(Metrics__c mE : lstAllME )
            {
              tempGDP_RUS.Display_Bonus_Result__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c;                                                   
              tempGDP_RUS.Display_Achievement_Result__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Achievement_Result__c;
              tempGDP_RUS.Display_Stay_in_Same_Tier_Results__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Stay_in_Same_Tier_Results__c;
              tempGDP_RUS.Display_Promotion_to_Next_Tier_Results__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Promotion_to_Next_Tier_Results__c;  
              
              if(me.Metric_Category__c == sC )
              {
                String strMetName = '';
                String strGoalFRHText = mE.Goal_for_Retention_Help_Text_English__c; //Goal_for_Retention_Help_Text_<Locale>__c; Defaulted to english
                String strGoalFPHText = mE.Goal_for_Promotion_Help_Text_English__c; //Goal_for_Promotion_Help_Text_<Locale>__c; Defaulted to english
                String strGoalFBHText = mE.Goal_For_Bonus_Help_Text_English__c; //Goal_For_Bonus_Help_Text_<Locale>__c; Defaulted to english
                if(propUser.LanguageLocaleKey == 'en_US')
                {
                  tWC.propCategory = mE.Metric_Category__c;
                  strMetName = mE.Metric_Name__c;
                  strGoalFRHText = mE.Goal_for_Retention_Help_Text_English__c;
                  strGoalFPHText = mE.Goal_for_Promotion_Help_Text_English__c;
                  strGoalFBHText = mE.Goal_For_Bonus_Help_Text_English__c;
                }                   
                else if(propUser.LanguageLocaleKey == 'es')
                {
                  tWC.propCategory = mE.Metric_Category_Spanish__c;
                  strMetName = mE.Metric_Name_Spanish__c;
                  strGoalFRHText = mE.Goal_for_Retention_Help_Text_Spanish__c;
                  strGoalFPHText = mE.Goal_for_Promotion_Help_Text_Spanish__c;
                  strGoalFBHText = mE.Goal_For_Bonus_Help_Text_Spanish__c;
                }
                else if(propUser.LanguageLocaleKey == 'nl_NL')
                {
                  tWC.propCategory = mE.Metric_Category_Dutch__c;
                  strMetName = mE.Metric_Name_Dutch__c; 
                  strGoalFRHText = mE.Goal_for_Retention_Help_Text_Dutch__c;
                  strGoalFPHText = mE.Goal_for_Promotion_Help_Text_Dutch__c; 
                  strGoalFBHText = mE.Goal_For_Bonus_Help_Text_Dutch__c;                  
                }
                else if(propUser.LanguageLocaleKey == 'fr')
                {
                  tWC.propCategory = mE.Metric_Category_French__c;
                  strMetName = mE.Metric_Name_French__c;
                  strGoalFRHText = mE.Goal_for_Retention_Help_Text_French__c;
                  strGoalFPHText = mE.Goal_for_Promotion_Help_Text_French__c;  
                  strGoalFBHText = mE.Goal_For_Bonus_Help_Text_French__c;                 
                }
                else if(propUser.LanguageLocaleKey == 'de')
                {
                  tWC.propCategory = mE.Metric_Category_German__c;
                  strMetName = mE.Metric_Name_German__c;
                  strGoalFRHText = mE.Goal_for_Retention_Help_Text_German__c;
                  strGoalFPHText = mE.Goal_for_Promotion_Help_Text_German__c; 
                  strGoalFBHText = mE.Goal_For_Bonus_Help_Text_German__c;                 
                }
                else if(propUser.LanguageLocaleKey == 'it')
                {
                  tWC.propCategory = mE.Metric_Category_Italian__c;
                  strMetName = mE.Metric_Name_Italian__c;
                  strGoalFRHText = mE.Goal_for_Retention_Help_Text_Italian__c;
                  strGoalFPHText = mE.Goal_for_Promotion_Help_Text_Italian__c;
                  strGoalFBHText = mE.Goal_For_Bonus_Help_Text_Italian__c;                
                }                   
                tWM.add(new WrapMet (strMetName,
                                    currencyFormat(mE.Result_Concat__c),
                                    Double.valueOf(mE.Goal_for_Retention_Value__c),
                                    strGoalFRHText,
                                    Double.valueOf(mE.Goal_for_Promotion_Value__c),
                                    strGoalFPHText,
                                    Double.valueOf(mE.Metric_Template__r.Bonus_Value__c),
                                    strGoalFBHText,
                                    mE.Status_for_Promotion__c,
                                    mE.Status_for_Retention__c,
                                    mE.Status_for_Promotion_Final__c,
                                    mE.Status_for_Retention_Final__c,
                                    mE.Status_for_Bonus_Final__c,
                                    mE.Metric_Template__r.Metric_Result_Type__c,
                                    mE.Metric_Template__r.Metric_parentChild__c,
                                    mE.Calculated_Bonus_Final__c,
                                    currencyFormat(mE.Goal_for_Promotion_Display_Final__c),
                                    currencyFormat(mE.Goal_for_Retention_Display_Final__c),
                                    mE.Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c,
                                    currencyFormat(mE.Goal_for_Bonus_Display_Final__c),
                                    mE.Id)); 
              }//End if sC Check
            }//End For mE
            tWC.propMet = tWM;
            lstWC.add(tWC);
          }//End For sC 
          
          objHSH_RES = new HideShowHandler(tempGDP_RUS.Display_Achievement_Result__c, 
                                           tempGDP_RUS.Display_Stay_in_Same_Tier_Results__c, 
                                           tempGDP_RUS.Display_Promotion_to_Next_Tier_Results__c, 
                                           tempGDP_RUS.Display_Bonus_Result__c);          
/***** RESIDENTIAL END *****/

/***** COMMERCIAL START *****/
          List<String> lstCategory_COM = new List<String>{'Customer Satisfaction', 'Dealer Training', 'Performance to Business Plan', 'Marketing / Branding'};
          List<Metrics__c> lstMCode_CUS_AEU = [SELECT Metric_Code__c 
                                               FROM metrics__c 
                                               WHERE account__c =: this.relAccount.Id AND 
                                                     Where_to_Display__c = 'METRIC' AND 
                                                     Display_Flag__c ='Y' AND 
                                                    (Metric_Code__c LIKE '%CUS%' or Metric_Code__c LIKE '%AEU%') AND 
                                                    (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD)];

          List<String> lstCode_COM = new List<String>{};
          for(Metrics__c mt : lstMCode_CUS_AEU)
            lstCode_COM.add( mt.Metric_Code__c);

          List<Metrics__c> lstCOM = [SELECT  id, 
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c,                                            
                                             Metric_Template__r.Global_Dealer_Program__r.id,                                            
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Achievement_Result__c,
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Stay_in_Same_Tier_Results__c,
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Promotion_to_Next_Tier_Results__c,       
                                             Goal_for_Bonus_Display_Final__c, Goal_for_Promotion_Display_Final__c,
                                             Goal_for_Retention_Display_Final__c, Metric_Template__r.Metric_parentChild__c,
                                             Result__c, Metric_Order__c, Birlasoft_partner_Portal__c,
                                             Metric_Result_Type__c, Metric_Template__r.Metric_Name__c, 
                                             Metric_Template__r.Goal_for_Bonus_Help_Text__c, Goal_for_Retention_Value__c,
                                             Status_for_Retention__c, Status_for_Retention_Final__c,
                                             Goal_for_Promotion_Value__c, Status_for_Promotion_Final__c,
                                             Status_for_Bonus_Final__c, Status_for_Promotion__c,
                                             Metric_Template__r.Goal_for_Promotion_Help_Text__c, 
                                             Metric_Template__r.Goal_for_Retention_Help_Text__c,
                                             Metric_Template__r.Metric_Result_Type__c, Metric_Template__r.Bonus_Value__c,
                                             Metric_Parent_Code__c, Metric_Code__c,
                                             Goal_for_Promotion_Help_Text_dutch__c, Goal_for_Promotion_Help_Text_English__c,
                                             Metric_Template__r.Goal_for_Promotion_Help_Text_English__c,
                                             Goal_for_Promotion_Help_Text_French__c, Goal_for_Promotion_Help_Text_German__c,
                                             Goal_for_Promotion_Help_Text_Italian__c, Goal_for_Promotion_Help_Text_Spanish__c,
                                             Goal_for_Retention_Help_Text_Dutch__c, Goal_for_Retention_Help_Text_English__c,
                                             Goal_for_Retention_Help_Text_French__c, Goal_for_Retention_Help_Text_German__c,
                                             Goal_for_Retention_Help_Text_Italian__c, Goal_for_Retention_Help_Text_Spanish__c,
                                             Goal_For_Bonus_Help_Text_English__c, Goal_For_Bonus_Help_Text_French__c, 
                                             Goal_For_Bonus_Help_Text_German__c, Goal_For_Bonus_Help_Text_Italian__c, 
                                             Goal_For_Bonus_Help_Text_Spanish__c, Goal_For_Bonus_Help_Text_Dutch__c,
                                             Metric_Category__c, Metric_Category_Dutch__c,
                                             Metric_Category_French__c, Metric_Category_German__c,
                                             Metric_Category_Italian__c, Metric_Category_Spanish__c,
                                             Metric_Name__c, Metric_Name_Dutch__c, Metric_Name_French__c,
                                             Metric_Name_German__c, Metric_Name_Italian__c,
                                             Metric_Name_Spanish__c, Result_Concat__c,
                                             Calculated_Bonus_Final__c                                           
                                    FROM Metrics__c 
                                    WHERE account__c =: this.relAccount.Id AND 
                                         (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD) AND 
                                         Metric_Category__c IN : lstCategory_COM AND 
                                         Metric_Code__c IN : lstCode_COM order by Metric_Order__c];

          Global_Dealer_Program__c tempGDP_COM = new Global_Dealer_Program__c();
          
            for(String sC : lstCategory_COM)
            {
              WrapCat_COM tWC = new WrapCat_COM();
              List<WrapMet_COM> tWM = new lIST<WrapMet_COM>();
              for(Metrics__c mE : lstCOM )
              {
                tempGDP_COM.Display_Bonus_Result__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c;                                                   
                tempGDP_COM.Display_Achievement_Result__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Achievement_Result__c;
                tempGDP_COM.Display_Stay_in_Same_Tier_Results__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Stay_in_Same_Tier_Results__c;
                tempGDP_COM.Display_Promotion_to_Next_Tier_Results__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Promotion_to_Next_Tier_Results__c; 
              
                if(me.Metric_Category__c == sC )
                {
                  String strMetName = '';
                  String strGoalFPHText = mE.Goal_for_Promotion_Help_Text_English__c;//Goal_for_Promotion_Help_Text_<Locale>__c; Defaulted to english
                  String strGoalFRHText = mE.Goal_for_Retention_Help_Text_English__c;//Goal_for_Retention_Help_Text_<Locale>__c; Defaulted to english
                  String strGoalFBHText = mE.Goal_For_Bonus_Help_Text_English__c; //Goal_For_Bonus_Help_Text_<Locale>__c; Defaulted to english
                  if(propUser.LanguageLocaleKey == 'en_US')
                  {
                    tWC.propCategory_COM = mE.Metric_Category__c;
                    strMetName = mE.Metric_Name__c;
                    strGoalFPHText = mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = mE.Goal_For_Bonus_Help_Text_English__c;
                  }
                  else if(propUser.LanguageLocaleKey == 'es')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_Spanish__c;
                    strMetName = mE.Metric_Name_Spanish__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_Spanish__c != null) ? mE.Goal_for_Promotion_Help_Text_Spanish__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_Spanish__c != null) ? mE.Goal_for_Retention_Help_Text_Spanish__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_Spanish__c != null) ? mE.Goal_For_Bonus_Help_Text_Spanish__c: mE.Goal_For_Bonus_Help_Text_English__c;                    
                  } 
                  else if(propUser.LanguageLocaleKey == 'nl_NL')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_Dutch__c;
                    strMetName = mE.Metric_Name_Dutch__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_Dutch__c != null) ? mE.Goal_for_Promotion_Help_Text_Dutch__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_Dutch__c != null) ? mE.Goal_for_Retention_Help_Text_Dutch__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_Dutch__c != null) ? mE.Goal_For_Bonus_Help_Text_Dutch__c: mE.Goal_For_Bonus_Help_Text_English__c;                  
                  } 
                  else if(propUser.LanguageLocaleKey == 'fr')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_French__c;
                    strMetName = mE.Metric_Name_French__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_French__c != null) ? mE.Goal_for_Promotion_Help_Text_French__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_French__c != null) ? mE.Goal_for_Retention_Help_Text_French__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_French__c != null) ? mE.Goal_For_Bonus_Help_Text_French__c: mE.Goal_For_Bonus_Help_Text_English__c;                 
                  }
                  else if(propUser.LanguageLocaleKey == 'de')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_German__c;
                    strMetName = mE.Metric_Name_German__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_German__c != null) ? mE.Goal_for_Promotion_Help_Text_German__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_German__c != null) ? mE.Goal_for_Retention_Help_Text_German__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_German__c != null) ? mE.Goal_For_Bonus_Help_Text_German__c: mE.Goal_For_Bonus_Help_Text_English__c;                 
                  } 
                  else if(propUser.LanguageLocaleKey == 'it')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_Italian__c;
                    strMetName = mE.Metric_Name_Italian__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_Italian__c != null) ? mE.Goal_for_Promotion_Help_Text_Italian__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_Italian__c != null) ? mE.Goal_for_Retention_Help_Text_Italian__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_Italian__c != null) ? mE.Goal_For_Bonus_Help_Text_Italian__c: mE.Goal_For_Bonus_Help_Text_English__c;                    
                  }                   
                  tWM.add(new WrapMet_COM (strMetName,
                                    currencyFormat(mE.Result_Concat__c),
                                    Double.valueOf(mE.Goal_for_Retention_Value__c),
                                    strGoalFPHText,
                                    Double.valueOf(mE.Goal_for_Promotion_Value__c),
                                    strGoalFRHText,
                                    Double.valueOf(mE.Metric_Template__r.Bonus_Value__c),
                                    strGoalFBHText,
                                    mE.Status_for_Promotion__c,
                                    mE.Status_for_Retention__c,
                                    mE.Status_for_Promotion_Final__c,
                                    mE.Status_for_Retention_Final__c,
                                    mE.Status_for_Bonus_Final__c,
                                    mE.Metric_Template__r.Metric_Result_Type__c,
                                    mE.Metric_Template__r.Metric_parentChild__c,
                                    mE.Calculated_Bonus_Final__c,
                                    currencyFormat(mE.Goal_for_Promotion_Display_Final__c),
                                    currencyFormat(mE.Goal_for_Retention_Display_Final__c),
                                    mE.Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c,
                                    currencyFormat(mE.Goal_for_Bonus_Display_Final__c),
                                    mE.Id,
                                    mE.Metric_Code__c
                                    )); 
                }//End if sC Check
              }//End For mE
              tWC.propWrapMet_COM = tWM;
              lstWC_COM.add(tWC);
            }//End For sC
            
            objHSH_COM = new HideShowHandler(tempGDP_COM.Display_Achievement_Result__c, 
                                             tempGDP_COM.Display_Stay_in_Same_Tier_Results__c, 
                                             tempGDP_COM.Display_Promotion_to_Next_Tier_Results__c, 
                                             tempGDP_COM.Display_Bonus_Result__c);                      
/***** COMMERCIAL END *****/ 

/***** EU START *****/
          List<String> lstCategory_EU= new List<String>{'Customer Satisfaction', 'Dealer Training', 'Performance to Business Plan', 'Marketing / Branding'};
          List<Metrics__c> lstMCode_EU = [SELECT Metric_Code__c 
                                               FROM metrics__c 
                                               WHERE account__c =: this.relAccount.Id AND 
                                                     Where_to_Display__c = 'METRIC' AND 
                                                     Display_Flag__c ='Y' AND 
                                                    (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD)];                                                   

          List<String> lstCode_EU = new List<String>{};
          for(Metrics__c mt : lstMCode_EU)
            lstCode_EU.add( mt.Metric_Code__c);

          List<Metrics__c> lstEU = [SELECT  id, 
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c,
                                             Metric_Template__r.Global_Dealer_Program__r.id,                                            
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Achievement_Result__c,
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Stay_in_Same_Tier_Results__c,
                                             Metric_Template__r.Global_Dealer_Program__r.Display_Promotion_to_Next_Tier_Results__c,       
                                             Goal_for_Bonus_Display_Final__c, Goal_for_Promotion_Display_Final__c,
                                             Goal_for_Retention_Display_Final__c, Metric_Template__r.Metric_parentChild__c,
                                             Result__c, Metric_Order__c, Birlasoft_partner_Portal__c,
                                             Metric_Result_Type__c, Metric_Template__r.Metric_Name__c, 
                                             Metric_Template__r.Goal_for_Bonus_Help_Text__c, Goal_for_Retention_Value__c,
                                             Status_for_Retention__c, Status_for_Retention_Final__c,
                                             Goal_for_Promotion_Value__c, Status_for_Promotion_Final__c,
                                             Status_for_Bonus_Final__c, Status_for_Promotion__c,
                                             Metric_Template__r.Goal_for_Promotion_Help_Text__c, 
                                             Metric_Template__r.Goal_for_Retention_Help_Text__c,
                                             Metric_Template__r.Metric_Result_Type__c, Metric_Template__r.Bonus_Value__c,
                                             Metric_Parent_Code__c, Metric_Code__c,
                                             Goal_for_Promotion_Help_Text_dutch__c, Goal_for_Promotion_Help_Text_English__c,
                                             Metric_Template__r.Goal_for_Promotion_Help_Text_English__c,
                                             Goal_for_Promotion_Help_Text_French__c, Goal_for_Promotion_Help_Text_German__c,
                                             Goal_for_Promotion_Help_Text_Italian__c, Goal_for_Promotion_Help_Text_Spanish__c,
                                             Goal_for_Retention_Help_Text_Dutch__c, Goal_for_Retention_Help_Text_English__c,
                                             Goal_for_Retention_Help_Text_French__c, Goal_for_Retention_Help_Text_German__c,
                                             Goal_for_Retention_Help_Text_Italian__c, Goal_for_Retention_Help_Text_Spanish__c,
                                             Goal_For_Bonus_Help_Text_English__c, Goal_For_Bonus_Help_Text_French__c, 
                                             Goal_For_Bonus_Help_Text_German__c, Goal_For_Bonus_Help_Text_Italian__c, 
                                             Goal_For_Bonus_Help_Text_Spanish__c, Goal_For_Bonus_Help_Text_Dutch__c,
                                             Metric_Category__c, Metric_Category_Dutch__c,
                                             Metric_Category_French__c, Metric_Category_German__c,
                                             Metric_Category_Italian__c, Metric_Category_Spanish__c,
                                             Metric_Name__c, Metric_Name_Dutch__c, Metric_Name_French__c,
                                             Metric_Name_German__c, Metric_Name_Italian__c,
                                             Metric_Name_Spanish__c, Result_Concat__c,
                                             Calculated_Bonus_Final__c                                           
                                    FROM Metrics__c 
                                    WHERE account__c =: this.relAccount.Id AND 
                                         (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD) AND 
                                         Metric_Category__c IN : lstCategory_EU AND 
                                         Metric_Code__c IN : lstCode_EU
                                    ORDER BY Metric_Order__c];                                         

          Global_Dealer_Program__c tempGDP_EU = new Global_Dealer_Program__c();                         
                                    
            for(String sC : lstCategory_EU)
            {
              WrapCat_COM tWC = new WrapCat_COM();
              List<WrapMet_COM> tWM = new lIST<WrapMet_COM>();
              for(Metrics__c mE : lstEU)
              {
                tempGDP_EU.Display_Bonus_Result__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c;                                                   
                tempGDP_EU.Display_Achievement_Result__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Achievement_Result__c;
                tempGDP_EU.Display_Stay_in_Same_Tier_Results__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Stay_in_Same_Tier_Results__c;
                tempGDP_EU.Display_Promotion_to_Next_Tier_Results__c = mE.Metric_Template__r.Global_Dealer_Program__r.Display_Promotion_to_Next_Tier_Results__c; 
              
                if(me.Metric_Category__c == sC)
                {
                  String strMetName = '';
                  String strGoalFPHText = mE.Goal_for_Promotion_Help_Text_English__c;//Goal_for_Promotion_Help_Text_<Locale>__c; Defaults to English
                  String strGoalFRHText = mE.Goal_for_Retention_Help_Text_English__c;//Goal_for_Retention_Help_Text_<Locale>__c; Defaults to English
                  String strGoalFBHText = mE.Goal_For_Bonus_Help_Text_English__c; //Goal_For_Bonus_Help_Text_<Locale>__c; Defaults to English
                  if(propUser.LanguageLocaleKey == 'en_US')
                  {
                    tWC.propCategory_COM = mE.Metric_Category__c;
                    strMetName = mE.Metric_Name__c;
                    strGoalFPHText = mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = mE.Goal_For_Bonus_Help_Text_English__c;                    
                  }
                  else if(propUser.LanguageLocaleKey == 'es')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_Spanish__c;
                    strMetName = mE.Metric_Name_Spanish__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_Spanish__c != null) ? mE.Goal_for_Promotion_Help_Text_Spanish__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_Spanish__c != null) ? mE.Goal_for_Retention_Help_Text_Spanish__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_Spanish__c != null) ? mE.Goal_For_Bonus_Help_Text_Spanish__c: mE.Goal_For_Bonus_Help_Text_English__c;                    
                  } 
                  else if(propUser.LanguageLocaleKey == 'nl_NL')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_Dutch__c;
                    strMetName = mE.Metric_Name_Dutch__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_Dutch__c != null) ? mE.Goal_for_Promotion_Help_Text_Dutch__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_Dutch__c != null) ? mE.Goal_for_Retention_Help_Text_Dutch__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_Dutch__c != null) ? mE.Goal_For_Bonus_Help_Text_Dutch__c: mE.Goal_For_Bonus_Help_Text_English__c;                  
                  } 
                  else if(propUser.LanguageLocaleKey == 'fr')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_French__c;
                    strMetName = mE.Metric_Name_French__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_French__c != null) ? mE.Goal_for_Promotion_Help_Text_French__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_French__c != null) ? mE.Goal_for_Retention_Help_Text_French__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_French__c != null) ? mE.Goal_For_Bonus_Help_Text_French__c: mE.Goal_For_Bonus_Help_Text_English__c;                 
                  }
                  else if(propUser.LanguageLocaleKey == 'de')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_German__c;
                    strMetName = mE.Metric_Name_German__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_German__c != null) ? mE.Goal_for_Promotion_Help_Text_German__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_German__c != null) ? mE.Goal_for_Retention_Help_Text_German__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_German__c != null) ? mE.Goal_For_Bonus_Help_Text_German__c: mE.Goal_For_Bonus_Help_Text_English__c;                 
                  } 
                  else if(propUser.LanguageLocaleKey == 'it')
                  {
                    tWC.propCategory_COM = mE.Metric_Category_Italian__c;
                    strMetName = mE.Metric_Name_Italian__c;
                    strGoalFPHText = (mE.Goal_for_Promotion_Help_Text_Italian__c != null) ? mE.Goal_for_Promotion_Help_Text_Italian__c: mE.Goal_for_Promotion_Help_Text_English__c;
                    strGoalFRHText = (mE.Goal_for_Retention_Help_Text_Italian__c != null) ? mE.Goal_for_Retention_Help_Text_Italian__c: mE.Goal_for_Retention_Help_Text_English__c;
                    strGoalFBHText = (mE.Goal_For_Bonus_Help_Text_Italian__c != null) ? mE.Goal_For_Bonus_Help_Text_Italian__c : mE.Goal_For_Bonus_Help_Text_English__c;                    
                  }                   
                  tWM.add(new WrapMet_COM (strMetName,
                                    currencyFormat(mE.Result_Concat__c),
                                    Double.valueOf(mE.Goal_for_Retention_Value__c),
                                    strGoalFPHText,
                                    Double.valueOf(mE.Goal_for_Promotion_Value__c),
                                    strGoalFRHText,
                                    Double.valueOf(mE.Metric_Template__r.Bonus_Value__c),
                                    strGoalFBHText,
                                    mE.Status_for_Promotion__c,
                                    mE.Status_for_Retention__c,
                                    mE.Status_for_Promotion_Final__c,
                                    mE.Status_for_Retention_Final__c,
                                    mE.Status_for_Bonus_Final__c,
                                    mE.Metric_Template__r.Metric_Result_Type__c,
                                    mE.Metric_Template__r.Metric_parentChild__c,
                                    mE.Calculated_Bonus_Final__c,
                                    currencyFormat(mE.Goal_for_Promotion_Display_Final__c),
                                    currencyFormat(mE.Goal_for_Retention_Display_Final__c),
                                    mE.Metric_Template__r.Global_Dealer_Program__r.Display_Bonus_Result__c,
                                    currencyFormat(mE.Goal_for_Bonus_Display_Final__c),
                                    mE.Id,
                                    mE.Metric_Code__c)); 
                }//End if sC Check
              }//End For mE
              tWC.propWrapMet_COM = tWM;
              lstWC_MEU.add(tWC);
            }//End For sC
            
            objHSH_EU = new HideShowHandler(tempGDP_EU.Display_Achievement_Result__c, 
                                            tempGDP_EU.Display_Stay_in_Same_Tier_Results__c, 
                                            tempGDP_EU.Display_Promotion_to_Next_Tier_Results__c, 
                                            tempGDP_EU.Display_Bonus_Result__c);                               
/***** EU END *****/
       
//====================FIN EUR- START==============================================
       List<String> lstCode_Fin_Cus = new List<String>{};
        for(Metrics__c mt : [SELECT Metric_Code__c 
                             FROM metrics__c 
                             WHERE account__c =: this.relAccount.Id AND 
                                   Where_to_Display__c = 'SIDEBAR' AND 
                                   Display_Flag__c ='Y' AND 
                                   (Metric_Code__c like '%CUS%' OR Metric_Code__c like '%AEU%') AND 
                                   (Current_Performance_Period_Start_Date__c <=:dStaD AND Current_Performance_Period_End_Date__c >=:dStaD ) AND 
                                   Metric_Category__c = 'Financials'])
        {
          lstCode_Fin_Cus.add( mt.Metric_Code__c);
        } 
        
        List<Metrics__c> lstFinancME_CUS = [SELECT  id, Result_Concat__c,
                                                 Metric_Category__c, Metric_Category_Dutch__c,
                                                 Metric_Category_French__c, Metric_Category_German__c,
                                                 Metric_Category_Italian__c, Metric_Category_Spanish__c, 
                                                 Metric_Name__c, Metric_Name_Dutch__c,
                                                 Metric_Name_French__c, Metric_Name_German__c,
                                                 Metric_Name_Italian__c, Metric_Name_Spanish__c                                         
                                            FROM Metrics__c 
                                            WHERE account__c =: this.relAccount.Id AND 
                                                 (Current_Performance_Period_Start_Date__c <=:dStaD AND 
                                                 Current_Performance_Period_End_Date__c >=:dStaD ) AND 
                                                 Metric_Category__c = 'Financials' AND 
                                                 Metric_Code__c IN : lstCode_Fin_Cus order by Metric_Order__c]; 
                                                 

          if(!lstFinancME_CUS.isEmpty())
          {
            for(Metrics__c mt : lstFinancME_CUS)
            {
              WrapFinancial_CUS tWF = new WrapFinancial_CUS();
              if(propUser.LanguageLocaleKey == 'en_US')
              {
                tWF.propMName_CUS_FIN  = mt.Metric_Name__c;
                tWF.propCategory_CUS_FIN = mt.Metric_Category__c;              
              }
              else if(propUser.LanguageLocaleKey == 'es')
              {
                tWF.propMName_CUS_FIN  = mt.Metric_Name_Spanish__c;
                tWF.propCategory_CUS_FIN = mt.Metric_Category_Spanish__c;              
              }
              else if(propUser.LanguageLocaleKey == 'nl_NL')
              {
                tWF.propMName_CUS_FIN  = mt.Metric_Name_Dutch__c;
                tWF.propCategory_CUS_FIN = mt.Metric_Category_Dutch__c;                
              }
              else if(propUser.LanguageLocaleKey == 'fr')
              {
                tWF.propMName_CUS_FIN  = mt.Metric_Name_French__c;
                tWF.propCategory_CUS_FIN = mt.Metric_Category_French__c;               
              }
              else if(propUser.LanguageLocaleKey == 'de')
              {
                tWF.propMName_CUS_FIN  = mt.Metric_Name_German__c; 
                tWF.propCategory_CUS_FIN = mt.Metric_Category_German__c;               
              }
              else if(propUser.LanguageLocaleKey == 'it')
              {
                tWF.propMName_CUS_FIN  = mt.Metric_Name_Italian__c;
                tWF.propCategory_CUS_FIN = mt.Metric_Category_Italian__c;              
              } 

              if(mt.Result_Concat__c != null && mt.Result_Concat__c.contains('€'))
                tWF.propAmount_CUS_FIN =  String.valueOf(ConvertToDecimal(mt.Result_Concat__c)) + '€';
              else if (mt.Result_Concat__c != null && mt.Result_Concat__c.contains('$'))
                tWF.propAmount_CUS_FIN = '$' + String.valueOf(ConvertToDecimal(mt.Result_Concat__c));
              //else if (mt.Result_Concat__c != null && mt.Result_Concat__c.contains('%'))
              else if (mt.Result_Concat__c != null  )
                tWF.propAmount_CUS_FIN = mt.Result_Concat__c;
              lstWF12.add(tWF);           
            }             
          }//End If lstFinancME_CUS

//====================FIN EUR- END======================================================
                                                 
//====================FIN US RUS- START=========================
       List<String> lstCode_Fin_Rus1 = new List<String>{};
        for(Metrics__c mt : [SELECT Metric_Code__c 
                             FROM metrics__c 
                             WHERE account__c =: this.relAccount.Id AND 
                                   Where_to_Display__c = 'SIDEBAR' AND 
                                   Display_Flag__c ='Y' AND 
                                   Metric_Code__c like '%RUS%'  AND 
                                   (Current_Performance_Period_Start_Date__c <=:dStaD AND Current_Performance_Period_End_Date__c >=:dStaD ) AND 
                                   Metric_Category__c = 'Financials'])
        {
          lstCode_Fin_Rus1.add( mt.Metric_Code__c);
        } 
        
        List<Metrics__c> lstFinancME_CUS1 = [SELECT  id, Result_Concat__c,
                                                 Metric_Category__c, Metric_Category_Dutch__c,
                                                 Metric_Category_French__c, Metric_Category_German__c,
                                                 Metric_Category_Italian__c, Metric_Category_Spanish__c, 
                                                 Metric_Name__c, Metric_Name_Dutch__c,
                                                 Metric_Name_French__c, Metric_Name_German__c,
                                                 Metric_Name_Italian__c, Metric_Name_Spanish__c                                         
                                            FROM Metrics__c 
                                            WHERE account__c =: this.relAccount.Id AND 
                                                 (Current_Performance_Period_Start_Date__c <=:dStaD AND 
                                                 Current_Performance_Period_End_Date__c >=:dStaD ) AND 
                                                 Metric_Category__c = 'Financials' AND 
                                                 Metric_Code__c IN : lstCode_Fin_Rus1 order by Metric_Order__c]; 
                                                 

          if(!lstFinancME_CUS1.isEmpty())
          {
            for(Metrics__c mt : lstFinancME_CUS1)
            {
              WrapFinancial_RUS tWF = new WrapFinancial_RUS();
              if(propUser.LanguageLocaleKey == 'en_US')
              {
                tWF.propMName_RUS_FIN  = mt.Metric_Name__c;
                tWF.propCategory_RUS_FIN = mt.Metric_Category__c;              
              }
              else if(propUser.LanguageLocaleKey == 'es')
              {
                tWF.propMName_RUS_FIN  = mt.Metric_Name_Spanish__c;
                tWF.propCategory_RUS_FIN = mt.Metric_Category_Spanish__c;              
              }
              else if(propUser.LanguageLocaleKey == 'nl_NL')
              {
                tWF.propMName_RUS_FIN  = mt.Metric_Name_Dutch__c;
                tWF.propCategory_RUS_FIN = mt.Metric_Category_Dutch__c;                
              }
              else if(propUser.LanguageLocaleKey == 'fr')
              {
                tWF.propMName_RUS_FIN  = mt.Metric_Name_French__c;
                tWF.propCategory_RUS_FIN = mt.Metric_Category_French__c;               
              }
              else if(propUser.LanguageLocaleKey == 'de')
              {
                tWF.propMName_RUS_FIN  = mt.Metric_Name_German__c; 
                tWF.propCategory_RUS_FIN = mt.Metric_Category_German__c;               
              }
              else if(propUser.LanguageLocaleKey == 'it')
              {
                tWF.propMName_RUS_FIN  = mt.Metric_Name_Italian__c;
                tWF.propCategory_RUS_FIN = mt.Metric_Category_Italian__c;              
              } 
 
              if(mt.Result_Concat__c != null && mt.Result_Concat__c.contains('€'))
                tWF.propAmount_RUS_FIN =  String.valueOf(ConvertToDecimal(mt.Result_Concat__c)) + '€';
              else if (mt.Result_Concat__c != null && mt.Result_Concat__c.contains('$'))
                tWF.propAmount_RUS_FIN = '$' + String.valueOf(ConvertToDecimal(mt.Result_Concat__c));
              //else if (mt.Result_Concat__c != null && mt.Result_Concat__c.contains('%'))
              else if (mt.Result_Concat__c != null  )
                tWF.propAmount_RUS_FIN = mt.Result_Concat__c;
              lstWF11.add(tWF);           
            }             
          }//End If lstFinancME_CUS1
//====================FIN US- END=========================

  //---OVERALL--- 
  //---RUS Overall Start--- 
          
          //Map<String, String> mValsRES = new Map<String, String>{'Status'=>'SY_RUS_001', 'Retention'=>'SY_RUS_003', 'Bonus'=>'SY_RUS_005'};
          
          Map<String, String> mValsRES = new Map<String, String>{'Promotion'=>'SY_RUS_004', 'Retention'=>'SY_RUS_003', 'Bonus'=>'SY_RUS_005'};
          //Case 00160791
          Map<String,String> mValsRES1 = new Map<String,String>{'Promotion'=>'SY_RUS_004','Retention'=>'SY_RUS_002', 'Bonus'=>'SY_RUS_005'};
          //End Case 00160791
          List<String> lstCategory_RUS_OverAll = new List<String>{'Summary'};
    
          List<Metrics__c> lstMCode_OvAll_Rus = [SELECT Metric_Code__c 
                                                FROM metrics__c 
                                                WHERE account__c =: this.relAccount.Id AND 
                                                      Where_to_Display__c = 'OVERALL' AND 
                                                      Display_Flag__c ='Y' AND 
                                                      Metric_Code__c like '%RUS%' AND 
                                                      (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD) AND 
                                                      Metric_Category__c = 'Summary'];
                                                      
          List<String> lstCode_OvAll_RUS = new List<String>{};
          for(Metrics__c mt : lstMCode_OvAll_Rus)
            lstCode_OvAll_RUS.add( mt.Metric_Code__c);

          List<Metrics__c> lstOverAll_RUS = [SELECT  id, Metric_Result_Type__c, 
                                                     Status_for_Retention__c, Status_for_Promotion__c,
                                                     Status_for_Retention_Final__c, Status_for_Promotion_Final__c,
                                                     Calculated_Bonus_Final__c, Status_For_Bonus_Final__c, Bonus_Value__c,                                                   
                                                     Metric_Code__c, Metric_Name__c,
                                                     Metric_Name_Dutch__c, Metric_Name_French__c,
                                                     Metric_Name_German__c, Metric_Name_Italian__c,
                                                     Metric_Name_Spanish__c, Metric_Category__c,
                                                     Metric_Category_Dutch__c, Metric_Category_French__c,
                                                     Metric_Category_German__c, Metric_Category_Italian__c,
                                                     Metric_Category_Spanish__c, 
                                                     Result_Concat__c, Result__c, 
                                                     Metric_Template__r.Bonus_Value__c, Metric_Template__r.Result_Post_Concat__c                                                  
                                             FROM Metrics__c 
                                             WHERE account__c =: this.relAccount.Id AND 
                                                  (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD) AND 
                                                   Metric_Category__c = 'Summary' AND 
                                                  (Metric_Code__c IN : lstCode_OvAll_RUS)];
   
            for(String sC : lstCategory_RUS_OverAll)
            {           
              WrapCat_RUS_Overall tWC = new WrapCat_RUS_Overall();
              List<WrapMet_RUS_Overall> tWM = new lIST<WrapMet_RUS_Overall>();
              String strMetNme = '';
              String strSFPF = '';
              String strSFRF = '';
              String strBon = '';
              String strStatusBon = '';  
              String strPostCon = '';
              for(Metrics__c mE : lstOverAll_RUS )
              {               
                if(me.Metric_Category__c == sC )
                {
                  if(mValsRES.get('Promotion') == mE.Metric_Code__c)
                    strSFPF = mE.Status_for_Promotion_Final__c;
                  //if(mValsRES.get('Retention') == mE.Metric_Code__c)
                  //Case 00160791
                  if(mValsRES.get('Retention') == mE.Metric_Code__c || mValsRES1.get('Retention') == mE.Metric_Code__c ) //End case 00160791
                    strSFRF = mE.Status_for_Retention_Final__c;
                  if(mValsRES.get('Bonus') == mE.Metric_Code__c)
                  {
                    strBon = ((mE.Calculated_Bonus_Final__c != null)? mE.Calculated_Bonus_Final__c : '');
                    strStatusBon = mE.Status_For_Bonus_Final__c;
                    strPostCon = ((mE.Metric_Template__r.Result_Post_Concat__c != null)? mE.Metric_Template__r.Result_Post_Concat__c : '');
                  }                 
                }//End if sC Check
              }//End For mE
              
              tWM.add(new WrapMet_RUS_Overall (strMetNme,
                                   strBon ,
                                   strStatusBon,                             
                                   strSFPF,
                                   strSFRF));                                  
              tWC.propMet = tWM;
              lstWC_RUS.add(tWC);         
            }//End For sC   
  //---RUS Overall End---
  
  //---CUS Overall Start---
          Map<String, String> mValsCOM = new Map<String, String>{'Status'=>'SY_CUS_001', 'Retention'=>'SY_CUS_002', 'Bonus'=>'SY_CUS_004'};    
          List<String> lstCategory_CUS_OverAll = new List<String>{'Summary'};  
          List<Metrics__c> lstMCode_OvAll_Cus_Aeu = [SELECT Metric_Code__c 
                                                     FROM metrics__c 
                                                     WHERE account__c =: this.relAccount.Id AND 
                                                           Where_to_Display__c = 'OVERALL' AND 
                                                           Display_Flag__c ='Y' AND 
                                                          (Metric_Code__c like '%CUS%' or Metric_Code__c like '%AEU%')  AND 
                                                          (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD ) AND 
                                                           Metric_Category__c = 'Summary'];
                                                            
          List<String> lstCode_OvAll_CUS_AEU = new List<String>{};
          for(Metrics__c mt : lstMCode_OvAll_Cus_Aeu)
            lstCode_OvAll_CUS_AEU.add( mt.Metric_Code__c);
            
          List<Metrics__c> lstOverAll_CUS = [SELECT  id, Metric_Result_Type__c, 
                                                     Status_for_Retention__c, Status_for_Promotion__c,
                                                     Status_for_Retention_Final__c, Status_for_Promotion_Final__c, 
                                                     Metric_Code__c, Metric_Name__c,
                                                     Metric_Name_Dutch__c, Metric_Name_French__c,
                                                     Metric_Name_German__c, Metric_Name_Italian__c,
                                                     Metric_Name_Spanish__c, Metric_Category__c,
                                                     Metric_Category_Dutch__c, Metric_Category_French__c,
                                                     Metric_Category_German__c, Metric_Category_Italian__c,
                                                     Metric_Category_Spanish__c, Result_Concat__c,
                                                     Metric_Template__r.Bonus_Value__c, Bonus_Value__c, 
                                                     Result__c, Metric_Template__r.Result_Post_Concat__c, Status_For_Bonus_Final__c, Calculated_Bonus_Final__c 
                                             FROM Metrics__c 
                                             WHERE account__c =: this.relAccount.Id AND 
                                                   (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD) AND 
                                                   Metric_Category__c = 'Summary' AND 
                                                   (Metric_Code__c IN: lstCode_OvAll_CUS_AEU)];
                                                   
            for(String sC : lstCategory_CUS_OverAll)
            {
              WrapCat_CUS_Overall tWC = new WrapCat_CUS_Overall();
              List<WrapMet_CUS_Overall> tWM = new lIST<WrapMet_CUS_Overall>();
              String strMetNme = '';
              String strSFPF = '';
              String strSFRF = '';
              String strBon = '';
              String strStatusBon = '';
              String strPostCon = '';             
              for(Metrics__c mE : lstOverAll_CUS)
              {       
                if(me.Metric_Category__c == sC )
                {                 
                  if(mValsCOM.get('Status') == mE.Metric_Code__c)
                    strSFPF = mE.Status_for_Promotion_Final__c;
                  if(mValsCOM.get('Retention') == mE.Metric_Code__c)
                    strSFRF = mE.Status_for_Retention_Final__c;
                  if(mValsCOM.get('Bonus') == mE.Metric_Code__c)
                  {
                    strBon = ((mE.Calculated_Bonus_Final__c != null)? mE.Calculated_Bonus_Final__c : '');
                    strStatusBon = mE.Status_For_Bonus_Final__c;
                    strPostCon = ((mE.Metric_Template__r.Result_Post_Concat__c != null)? mE.Metric_Template__r.Result_Post_Concat__c : '');
                  } 
                }//End if sC Check
              }//End For mE
              
              tWM.add(new WrapMet_CUS_Overall(strMetNme,
                                             strBon,
                                             strStatusBon,                             
                                             strSFPF,
                                             strSFRF));                                              
              tWC.propMet_CUS = tWM;
              lstWC_CUS.add(tWC);
            }//End For sC
          
  //---CUS Overall End --- 
  
//--- OVERALL STATUS : EU ---
          //Map<String, String> mValsEU = new Map<String, String>{'Status'=>'SY_AEU_001', 'Retention'=>'SY_AEU_002', 'Bonus'=>'SY_AEU_004'}; 
          Map<String, String> mValsEU = new Map<String, String>{'Promotion'=>'SY_AEU_003', 'Retention'=>'SY_AEU_002', 'Bonus'=>'SY_AEU_004'}; 
          List<String> lstCatEU = new List<String>{'Summary'};
          List<Metrics__c> lstMCode_OvAll_EU = [SELECT Metric_Code__c 
                                                FROM metrics__c 
                                                WHERE account__c =: this.relAccount.Id AND 
                                                      Where_to_Display__c = 'OVERALL' AND 
                                                      Display_Flag__c ='Y' AND 
                                                      (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD) AND 
                                                      Metric_Category__c IN : lstCatEU];
                                                      
          List<String> lstCode_OvAll_EU = new List<String>();
          for(metrics__c mt : lstMCode_OvAll_EU)
            lstCode_OvAll_EU.add(mt.Metric_Code__c);

          List<Metrics__c> lstOverAll_EU = [SELECT  id, Metric_Result_Type__c, Result__c, 
                                                    Metric_Template__r.Result_Post_Concat__c, Status_For_Bonus_Final__c, 
                                                    Status_for_Retention__c, Status_for_Promotion__c,
                                                    Status_for_Retention_Final__c, Status_for_Promotion_Final__c, 
                                                    Metric_Code__c, Metric_Name__c,
                                                    Metric_Name_Dutch__c, Metric_Name_French__c,
                                                    Metric_Name_German__c, Metric_Name_Italian__c,
                                                    Metric_Name_Spanish__c, Metric_Category__c,
                                                    Metric_Category_Dutch__c, Metric_Category_French__c,
                                                    Metric_Category_German__c, Metric_Category_Italian__c,
                                                    Metric_Category_Spanish__c, Result_Concat__c,
                                                    Metric_Template__r.Bonus_Value__c, Bonus_Value__c, Calculated_Bonus_Final__c   
                                             FROM Metrics__c 
                                             WHERE account__c =: this.relAccount.Id AND 
                                                   (Current_Performance_Period_Start_Date__c <=: dStaD AND Current_Performance_Period_End_Date__c >=: dEndD) AND 
                                                   Metric_Category__c = 'Summary' AND 
                                                   Metric_Code__c IN: lstCode_OvAll_EU];    

            for(String sC : lstCatEU)
            {
              WrapCat_EU_Overall tWC = new WrapCat_EU_Overall();
              List<WrapMet_EU_Overall> tWM = new lIST<WrapMet_EU_Overall>();
              String strMetNme = '';
              String strSFPF = '';
              String strSFRF = '';
              String strBon = '';
              String strStatusBon = '';
              String strPostCon = '';             
              for(Metrics__c mE : lstOverAll_EU)
              {       
                if(me.Metric_Category__c == sC )
                {                 
                  if(mValsEU.get('Promotion') == mE.Metric_Code__c)
                    strSFPF = mE.Status_for_Promotion_Final__c;
                  if(mValsEU.get('Retention') == mE.Metric_Code__c)
                    strSFRF = mE.Status_for_Retention_Final__c;
                  if(mValsEU.get('Bonus') == mE.Metric_Code__c)
                  {
                    strBon = ((mE.Calculated_Bonus_Final__c != null)? mE.Calculated_Bonus_Final__c : '');
                    strStatusBon = mE.Status_For_Bonus_Final__c;
                    strPostCon = ((mE.Metric_Template__r.Result_Post_Concat__c != null)? mE.Metric_Template__r.Result_Post_Concat__c : '');
                  } 
                }//End if sC Check
              }//End For mE  
              tWM.add(new WrapMet_EU_Overall(strMetNme,
                                             strBon,
                                             strStatusBon,                             
                                             strSFPF,
                                             strSFRF));                                              
              tWC.propMet_EU = tWM;
              lstWC_EU.add(tWC);
            }//End For sC                   
//--- END OVERALL STATUS : EU ---       
        }
      }
    }//End Try     
    catch (System.QueryException e){}       
  }//End Func AccntName

    
    
    public String currencyFormat(String str)
    {
        Decimal decStr = 0.0;
        String reStr = str;
        try
        {
          if(str!='' && (str.contains('$') || str.contains('€')))
          {
            String symb = '';
            if(str.contains('$'))
            {
              symb = '$';
              str = str.replace('$','').trim(); 
              try
              {
                decStr = Decimal.valueof(str);
                return ('$'+returnFormattedCurr(str , '$', decStr.scale()));  
              }
              catch(Exception e)
              {
                return reStr;
              }
            }
           else if(str.contains('€'))
           {
              symb = '€';
              str = str.replace('€','').trim();
              try
              { 
                decStr = Decimal.valueof(str);         
                return (returnFormattedCurr(str ,'€', decStr.scale())+'€');    
              }
              catch(Exception e)
              {
                return reStr;
              }
           }
            
          }
          else if(str!='' && str.toLowerCase().contains('months'))
          {
            if(str.toLowerCase().contains('months'))
            {
                String stri = str.toLowerCase().replace('months','').trim();
                try{
                     return decimal.valueOf(stri).round(RoundingMode.HALF_UP) + ' Months';
                }
                catch(Exception e)
                {
                    return '0 Month';
                }
            }
          }
          else if(str!='' && str.toLowerCase().contains('month'))
          {
            String stri = str.toLowerCase().replace('month','').trim();
            try{
                 return decimal.valueOf(stri).round(RoundingMode.HALF_UP)+ ' Month';
            }
            catch(Exception e)
            {
                return '0 Month';
            }           
         }
         return reStr;
       } 
       catch(Exception ex)
       { 
            System.debug('---ERROR : currencyFormat--> \n' + ex);
            return reStr; 
       } 
    }//End Func currencyFormat  
    
    public String returnFormattedCurr(String str, String sym, Integer scl)
    {
        if(str!=null || str!='')
        {
            String formatStr = Decimal.valueOf(str).setScale(2).format(); 
            if(str.contains('.') && scl==1)
            {
                return formatStr+'0';
            }
            else if(str.contains('.') && scl>=2)
            {
                return formatStr;
            }
            else if(scl==0 && sym=='$')
            {
                return formatStr+'.00';
            }
            else if(scl==0 && sym=='€')
            {
                return formatStr+',00';
            }
        }
        return str;     
    }
  
  //Function to return decimal portion of string like "$1234.65432", "$ 1234.65432", "1234.65432€", "1234.65432 €"; scaled to 2 decimal places as decimal
  public Decimal ConvertToDecimal(String str)
  {
    decimal decVal;
    if(str!=null && str.contains('$')) {
      str = str.replace('$','').trim();
      if(str!=null && str.contains('€'))
        str = str.replace('€','').trim();
    }
    else if(str!=null && str.contains('€')) {
      str = str.replace('€','').trim();
      if(str!=null && str.contains('$'))
        str = str.replace('$','').trim();     
    }
    try { decVal = Decimal.valueOf(str); }
    catch(Exception ex) { decVal = 0.0; }
    return decVal.setScale(2);
  }//End Func COnvertToDecimal
  
  //Function to return Start Date/End Date Based on String "<START DATE>--<END DATE>", example:"2012-01-14--2012-07-02"
  public Date ChangetoDate(String strD, String whichD)
  {
    Date dDate = null;
    String str = strD;
    if(str != null && str.contains('--') && whichD == 'SD')
      dDate = date.newinstance(Integer.valueOf(str.split('--')[0].split('-')[0]),Integer.valueOf(str.split('--')[0].split('-')[1]),Integer.valueOf(str.split('--')[0].split('-')[2]));
    else if(str != null && str.contains('--') && whichD == 'ED')
      dDate = date.newinstance(Integer.valueOf(str.split('--')[1].split('-')[0]),Integer.valueOf(str.split('--')[1].split('-')[1]),Integer.valueOf(str.split('--')[1].split('-')[2]));
    return dDate;
  }//End Func ChangetoDate
  
  public String getDateFormat(Date myDT)
  {
    String ddttmm = null;
    if(myDT!=null)
        ddttmm = Datetime.newInstance(myDT.year(),myDT.month(),myDT.day(),0,0,0).format('MM/dd/yyyy');
    return ddttmm;    
  }//End Func getDateFormat 
  
  //This function will convert display the amount in Fincial Section uption 2 decimal places
  public static string DecimaltoCurrency(Decimal val) 
  {
    if (val==0) 
      return '0.00';
    string str = val.divide(1,2,RoundingMode.HALF_UP).format()+'.00';
    integer dec = str.lastindexOf('.');
    if (dec==-1 ) 
      return str.substring(0,str.length()-2)+'.00';     
    else 
      return str.substring(0,dec+3);
  }//End Func DecimaltoCurrency  
/*** END FUNCTION ***/ 

/***** WRAPPER *****/
  public class WrapCat
  {
    String cat = '';
    List<WrapMet> lstWM = new List<WrapMet>();
    public String propCategory { get { return cat; }  set { cat = value; } }
    public List<WrapMet> propMet { get { return lstWM; } set { lstWM = value; } }
  }//End Class WrapCat

  public class WrapMet
  {    
    String mMId;
    String MName;
    String Achie;
    String Mrtype;
    Double Stay;
    String StayHelp;
    Double Prom;
    String PromHelp;
    Double Bon;
    String BonusHelp;
    Integer iSfPf = 0;
    Integer iSfRf = 0; 
    Integer iAchie = 0;
    //String MRType ;
    Boolean bIndent = false;
    Integer iSfBf = 0;
    String GfPdf;
    String GfRdf;
    String GfBdf;
    Boolean DbR;
    String GfBdf1; // Goal for bonus will come from Goal_for_Bonus_Display_Final__c
        
    public WrapMet(String tMName, String tAchie, Double tStay, String tStayHelp, Double tProm, String tPromHelp, Double tBon, String tBonusHelp, String tSfP, String tSfR, String tSfPf, String tSfRf,String tSfBf,String tMrT,String tParChild,String tGfB,String tGfP,String tGfR, Boolean tDbResult,String tGfBDF, String tmMId)
    {
      mMId = tmMId;
      MName = tMName; 
      Achie = (tAchie == null) ? '': tAchie;
      if(tMrT == null)
        Mrtype = 'D';
      else if(tMrT == 'Numeric')
        Mrtype = 'N';
      else if(tMrT == 'Checkbox')
        Mrtype = 'C';     
      Stay = tStay; 
      StayHelp = tStayHelp; 
      Prom = tProm; 
      PromHelp = tPromHelp; 
      Bon = tBon;
      BonusHelp = tBonusHelp;
      //if Status_for_Bonus_Final__c = Y/N    
      if(tSfBf != null && tSfBf == 'Y')
        iSfBf = 1;
      else if(tSfBf != null && tSfBf == 'N')
        iSfBf = 2;
      else
        iSfBf = 0;
        
      if(tSfPf != null && tSfPf == 'Y')
        iSfPf = 1;
      else if(tSfPf != null && tSfPf == 'N')
        iSfPf = 2;
      else
        iSfPf = 0; 

      if(tSfRf != null && tSfRf == 'Y')
        iSfRf = 1;
      else if(tSfRf != null && tSfRf == 'N')
        iSfRf = 2;
      else
        iSfRf = 0;
      if (tParChild != null && tParChild == 'Child')
            bIndent = true; 
      //GfBdf = tGfB; 
      GfBdf = (tGfB == null) ? '': tGfB;      
      //GfPdf = tGfP;
      GfPdf = (tGfP == null) ? '': tGfP;
      //GfRdf = tGfR;
      GfRdf = (tGfR == null) ? '': tGfR;
      DbR = tDbResult; 
      GfBdf1 = (tGfBDF == null) ? '': tGfBDF; // Goal for bonus will come from Goal_for_Bonus_Display_Final__c
    }
    public String propMMId { get { return mMId;} set { mMId = value; } }    
    public String propMName { get { return MName;} set { MName = value; } }
    public String propAchie { get { return Achie;} set { Achie = value; } }
    public String propMrType { get { return Mrtype;} set { Mrtype = value; } }
    //public Integer propiAchie { get { return iAchie;} set { iAchie = value; } }
    public Double propStay { get { return Stay;} set { Stay = value; } }
    public String propStayHelp { get { return StayHelp;} set { StayHelp = value; } }
    public Double propProm { get { return Prom;} set { Prom = value; } }
    public String propPromHelp { get { return PromHelp;} set { PromHelp = value; } }
    public Double propBon { get { return Bon;} set { Bon = value; } } 
    public String propBonusHelp { get { return BonusHelp; } set { BonusHelp = value; } }    
    public Integer propSfP { get { return iSfPf;} set { iSfPf = value; } } 
    public Integer propSfR { get { return iSfRf;} set { iSfRf = value; } }
    public Integer propSfB { get { return iSfBf;} set { iSfBf = value; } }
    //public Integer propMrt { get { return iAchie;} set { iAchie = value; } }
    public Boolean propIndent { get { return bIndent;} set { bIndent = value; } } 
    public String propGfB_rus { get { return GfBdf;} set { GfBdf = value; } }
    public String propGfP_rus { get { return GfPdf;} set { GfPdf = value; } }
    public String propGfR_rus { get { return GfRdf;} set { GfRdf = value; } }
    public Boolean propDbResult_RUS { get { return DbR;} set { DbR = value; } } 
    public String propGfBDF_rus { get { return GfBdf1;} set { GfBdf1 = value; } } // Goal for bonus will come from Goal_for_Bonus_Display_Final__c
  }//End Class WrapMet
  

   
/***** WRAPPER For RUS Overall*****/
  public class WrapCat_RUS_Overall
  {
    String cat = '';
    List<WrapMet_RUS_Overall> lstWM = new List<WrapMet_RUS_Overall>();
    public String propCat_RUS_Ovrall { get { return cat; }  set { cat = value; } }
    public List<WrapMet_RUS_Overall> propMet { get { return lstWM; } set { lstWM = value; } }
  }//End Class WrapCat_RUS_Overall

  public class WrapMet_RUS_Overall
  {
    String MName;
    String Achie;
    Integer Bon;
    Integer iSfPf = 0;
    Integer iSfRf = 0; 
        
    WrapMet_RUS_Overall(String tMName, String tAchie, String tBon, String tSfPf, String tSfRf)
    {
      MName = tMName; 
      Achie = tAchie;

      if(tBon != null && tBon == 'Y')
      {  Bon = 1;
         if(tAchie == null || tAchie == '')
           Bon = 0;
      }
      else if(tBon != null && tBon == 'N')
      {
         Bon = 2;
         if(tAchie == null || tAchie == '')
           Bon = 0;
      }
      else
        Bon = 0; 
        
      if(tSfPf != null && tSfPf == 'Y')
        iSfPf = 1;
      else if(tSfPf != null && tSfPf == 'N')
        iSfPf = 2;
      else
        iSfPf = 0; 

      if(tSfRf != null && tSfRf == 'Y')
        iSfRf = 1;
      else if(tSfRf != null && tSfRf == 'N')
        iSfRf = 2;
      else
        iSfRf = 0; 
            
    }
    public String propMName_RUS { get { return MName;} set { MName = value; } }
    public String propAchie_RUS { get { return Achie;} set { Achie = value; } }
    public Integer propBon_RUS { get { return Bon;} set { Bon = value; } } 
    public Integer propSfP_RUS { get { return iSfPf;} set { iSfPf = value; } } 
    public Integer propSfR_RUS { get { return iSfRf;} set { iSfRf = value; } }
   }//End Class WrapMet_RUS_Overall
   
   /***** WRAPPER For CUS Overall*****/
 
  public class WrapCat_CUS_Overall
  {
    String cat = '';
    List<WrapMet_CUS_Overall> lstWM = new List<WrapMet_CUS_Overall>();
    public String propCat_CUS_Ovrall { get { return cat; }  set { cat = value; } }
    public List<WrapMet_CUS_Overall> propMet_CUS { get { return lstWM; } set { lstWM = value; } }
  }//End Class WrapCat_CUS_Overall

  public class WrapMet_CUS_Overall
  {
    String MName;
    String Achie;
    Integer Bon;
    Integer iSfPf = 0;
    Integer iSfRf = 0; 
        
    WrapMet_CUS_Overall(String tMName, String tAchie, String tBon, String tSfPf, String tSfRf)
    {
      MName = tMName; 
      Achie = tAchie;

      if(tBon != null && tBon == 'Y')
      {  Bon = 1;
         if(tAchie == null || tAchie == '')
           Bon = 0;
      }
      else if(tBon != null && tBon == 'N')
      {
         Bon = 2;
         if(tAchie == null || tAchie == '')
           Bon = 0;
      }
      else
        Bon = 0;     
      
      if(tSfPf != null && tSfPf == 'Y')
        iSfPf = 1;
      else if(tSfPf != null && tSfPf == 'N')
        iSfPf = 2;
      else
        iSfPf = 0; 

      if(tSfRf != null && tSfRf == 'Y')
        iSfRf = 1;
      else if(tSfRf != null && tSfRf == 'N')
        iSfRf = 2;
      else
        iSfRf = 0;             
    }
    public String propMName_CUS { get { return MName;} set { MName = value; } }
    public String propAchie_CUS { get { return Achie;} set { Achie = value; } }
    public Integer propBon_CUS { get { return Bon;} set { Bon = value; } } 
    public Integer propSfP_CUS { get { return iSfPf;} set { iSfPf = value; } } 
    public Integer propSfR_CUS { get { return iSfRf;} set { iSfRf = value; } }
   }//End Class WrapMet_CUS_Overall

  //***** WRAPPER for EU OVERALL *****   
  public class WrapCat_EU_Overall
  {
    String cat = '';
    List<WrapMet_EU_Overall> lstWM = new List<WrapMet_EU_Overall>();
    public String propCat_EU_Ovrall { get { return cat; }  set { cat = value; } }
    public List<WrapMet_EU_Overall> propMet_EU { get { return lstWM; } set { lstWM = value; } }
  }//End Class WrapCat_CUS_Overall

  public class WrapMet_EU_Overall
  {
    private String MName;
    private String Achie;
    private Integer Bon;
    private Integer iSfPf = 0;
    private Integer iSfRf = 0; 
        
    WrapMet_EU_Overall(String tMName, String tAchie, String tBon, String tSfPf, String tSfRf)
    {
      MName = tMName; 
      Achie = tAchie;
      
      if(tBon != null && tBon == 'Y')
      {  Bon = 1;
         if(tAchie == null || tAchie == '')
           Bon = 0;
      }
      else if(tBon != null && tBon == 'N')
      {
         Bon = 2;
         if(tAchie == null || tAchie == '')
           Bon = 0;
      }
      else
        Bon = 0;     

      if(tSfPf != null && tSfPf == 'Y')
        iSfPf = 1;
      else if(tSfPf != null && tSfPf == 'N')
        iSfPf = 2;
      else
        iSfPf = 0; 

      if(tSfRf != null && tSfRf == 'Y')
        iSfRf = 1;
      else if(tSfRf != null && tSfRf == 'N')
        iSfRf = 2;
      else
        iSfRf = 0;             
    }
    public String propMName_EU { get { return MName;} set { MName = value; } }
    public String propAchie_EU { get { return Achie;} set { Achie = value; } }
    public Integer propBon_EU { get { return Bon;} set { Bon = value; } } 
    public Integer propSfP_EU { get { return iSfPf;} set { iSfPf = value; } } 
    public Integer propSfR_EU { get { return iSfRf;} set { iSfRf = value; } }
   }//End Class WrapMet_EU_Overall
   
  public class WrapCat_COM
  {
    String cat = '';
    List<WrapMet_COM> lstWM_COM = new List<WrapMet_COM>();
    public String propCategory_COM { get { return cat; }  set { cat = value; } }
    public List<WrapMet_COM> propWrapMet_COM { get { return lstWM_COM; } set { lstWM_COM = value; } }
  }//End Class WrapCat

  public class WrapMet_COM
  {
    String mc;
    String mMId;
    String MName;
    String Achie;
    Double Stay;
    String StayHelp;
    Double Prom;
    String PromHelp;
    Double Bon;
    String BonusHelp;
    Integer iSfPf = 0;
    Integer iSfRf = 0; 
    Integer iAchie = 0;
    String MRType ;
    Boolean bIndent = false;
    Integer iSfBf = 0;
    String GfPdf;
    String GfRdf;
    String GfBdf;
    Boolean DbR; 
    String GfBdf1;  // Goal for Bonus = will come from Goal_for_Bonus_Display_Final__c
    
    WrapMet_COM(String tMName, String tAchie, Double tStay, String tStayHelp, Double tProm, String tPromHelp, Double tBon, String tBonusHelp, String tSfP, String tSfR, String tSfPf, String tSfRf,String tSfBf,String tMrT,String tParChild,String tGfB,String tGfP,String tGfR,Boolean tDbResult,String tGfBDF, String tmMId,String tmc )
    {
      mc = tmc;
      mMId = tmMId;
      MName = tMName; 
      //Achie = tAchie; 
      Achie = (tAchie == null) ? '': tAchie;
      if(tMrT == null)
        Mrtype = 'D';
      else if(tMrT == 'Numeric')
        Mrtype = 'N';
      else if(tMrT == 'Checkbox')
        Mrtype = 'C';     
      Stay = tStay; 
      StayHelp = tStayHelp; 
      Prom = tProm; 
      PromHelp = tPromHelp; 
      Bon = tBon;
      BonusHelp = tBonusHelp;
      //if Status_for_Bonus_Final__c = Y/N    
      if(tSfBf != null && tSfBf == 'Y')
        iSfBf = 1;
      else if(tSfBf != null && tSfBf == 'N')
        iSfBf = 2;
      else
        iSfBf = 0;    
      if(tSfPf != null && tSfPf == 'Y')
        iSfPf = 1;
      else if(tSfPf != null && tSfPf == 'N')
        iSfPf = 2;
      else
        iSfPf = 0; 
      if(tSfRf != null && tSfRf == 'Y')
        iSfRf = 1;
      else if(tSfRf != null && tSfRf == 'N')
        iSfRf = 2;
      else
        iSfRf = 0;        
      if (tParChild != null && tParChild == 'Child')
            bIndent = true; 
      //GfBdf = tGfB; 
      GfBdf = (tGfB == null) ? '': tGfB;      
      //GfPdf = tGfP;
      GfPdf = (tGfP == null) ? '': tGfP;
      //GfRdf = tGfR; 
      GfRdf = (tGfR == null) ? '': tGfR;
      DbR = tDbResult; 
      GfBdf1 = (tGfBDF == null) ? '': tGfBDF;   // Goal for Bonus = will come from Goal_for_Bonus_Display_Final__c + 18 April + Amit saha  
    }
    public String propMetricCode_COM { get { return mc;} set { mc = value; } } 
    public String propMMId_COM { get { return mMId;} set { mMId = value; } }    
    public String propMName_COM { get { return MName;} set { MName = value; } }
    public String propAchie_COM { get { return Achie;} set { Achie = value; } }
    public String propMrType_COM { get { return Mrtype;} set { Mrtype = value; } }
    public Double propStay_COM { get { return Stay;} set { Stay = value; } }
    public String propStayHelp_COM { get { return StayHelp;} set { StayHelp = value; } }
    public Double propProm_COM { get { return Prom;} set { Prom = value; } }
    public String propPromHelp_COM { get { return PromHelp;} set { PromHelp = value; } }
    public Double propBon_COM { get { return Bon;} set { Bon = value; } } 
    public String propBonusHelp_COM { get { return BonusHelp;} set { BonusHelp = value; } }     
    public Integer propSfP_COM { get { return iSfPf;} set { iSfPf = value; } } 
    public Integer propSfR_COM { get { return iSfRf;} set { iSfRf = value; } }
    public Integer propSfB_COM { get { return iSfBf;} set { iSfBf = value; } }  
    public Integer propMrt_COM { get { return iAchie;} set { iAchie = value; } } 
    public Boolean propIndent_COM { get { return bIndent;} set { bIndent = value; } }
    public String propGfB_cus { get { return GfBdf;} set { GfBdf = value; } }
    public String propGfP_cus { get { return GfPdf;} set { GfPdf = value; } }
    public String propGfR_cus { get { return GfRdf;} set { GfRdf = value; } }
    public Boolean propDbResult_CUS_AEU { get { return DbR;} set { DbR = value; } }
    public String propGfBDF_cus { get { return GfBdf1;} set { GfBdf1 = value; } } //Goal for Bonus = Goal_for_Bonus_Display_Final__c + 18 April + Amit saha  

  }//End Class WrapMet_COM 
  
  /*** WRAPPER For FIN EUR - START ***/
  public class WrapFinancial_CUS  
  {
    public String propMName_CUS_FIN {get; set;}
    public String propAmount_CUS_FIN {get; set;}  
    public String propCategory_CUS_FIN {get; set;}  
  }//End Class WrapFinancial_CUS 
  /**** WRAPPER For FIN EUR - END ****/
 
  /*** WRAPPER For FIN US - START ***/
  public class WrapFinancial_RUS
  {
    public String propMName_RUS_FIN {get; set;}
    public String propAmount_RUS_FIN {get; set;} 
    public String propCategory_RUS_FIN {get; set;}  
  }//End Class WrapFinancial_RUS   
  /**** WRAPPER For FIN US - START ****/ 

  public class HideShowHandler
  {
    private Boolean bARes = false;
    private Boolean bSSTRes = false;
    private Boolean bPNTRes = false;
    private Boolean bBRes = false;
  
    private Integer C1,C2,C3,C4,C5,C6,C7 =0;
  
    public Boolean propARes { get {return bARes;} set;}
    public Boolean propSSTRes { get {return bSSTRes;} set;}
    public Boolean propPNTRes { get {return bPNTRes;} set;}
    public Boolean propBRes { get {return bBRes;} set;}
    
    public Integer propC1{ get { return C1;} set { C1 = value;}}
    public Integer propC2{ get { return C2;} set { C2 = value;}}
    public Integer propC3{ get { return C3;} set { C3 = value;}}
    public Integer propC4{ get { return C4;} set { C4 = value;}}
    public Integer propC5{ get { return C5;} set { C5 = value;}}
    public Integer propC6{ get { return C6;} set { C6 = value;}}
    public Integer propC7{ get { return C7;} set { C7 = value;}}  
    
    HideShowHandler(Boolean tARes, Boolean tSSTRes, Boolean tPNTRes, Boolean tBRes )
    {
      Map<String, Integer> mWid =new Map<String, Integer> {'C1' => 9, 'C2'=> 18, 'C3' => 18, 'C4' => 18};
      Integer tot = 63;
      Integer PSet = (tARes ? mWid.get('C1') :0 ) + (tSSTRes ? mWid.get('C2') :0) + (tPNTRes ? mWid.get('C3') :0) + (tBRes ? mWid.get('C4') :0);
      if(tARes)
      {
        bARes = tARes;
        Decimal D = mWid.get('C1');
        C1 = Integer.valueOf(((D.Divide(PSet, 2))*tot).setScale( 0, System.RoundingMode.HALF_UP )); 
      }
      else
      {
        C1 = 0;
      }
      if(tSSTRes)
      {
        bSSTRes = tSSTRes;
        Decimal D = mWid.get('C2');     
        Decimal temp = ((D.Divide(PSet, 2))*tot).setScale( 0, System.RoundingMode.HALF_UP );  
        C2 = Integer.valueOf(temp.Divide(2,2).setScale( 0, System.RoundingMode.HALF_UP ));
        C3 = Integer.valueOf(temp) - C2;
      }
      else 
      {
      C2 = 0;
      C3 = 0;
      }
      if(tPNTRes)
      {
        bPNTRes = tPNTRes;
        Decimal D = mWid.get('C3');     
        Decimal temp = ((D.Divide(PSet, 2))*tot).setScale( 0, System.RoundingMode.HALF_UP );  
        C4 = Integer.valueOf(temp.Divide(2,2).setScale( 0, System.RoundingMode.HALF_UP ));
        C5 = Integer.valueOf(temp) - C4; 
      }
      else 
      {
        C4 = 0;
        C5 = 0;
      }
      if(tBRes)
      {
        bBRes = tBRes;
        Decimal D = mWid.get('C4');     
        Decimal temp = ((D.Divide(PSet, 2))*tot).setScale( 0, System.RoundingMode.HALF_UP );  
        C6 = Integer.valueOf(temp.Divide(2,2).setScale( 0, System.RoundingMode.HALF_UP ));
        C7 = Integer.valueOf(temp) - C6; 
      } 
      else 
      {
        C6 = 0;
        C7 = 0;
      }
    }// End Constructor HideShowHandler 
  }//End Class HideShowHandler

/*** END WRAPPER ***/  
}//End Class partnerDashboard