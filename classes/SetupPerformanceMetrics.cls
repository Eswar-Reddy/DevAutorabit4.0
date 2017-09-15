/*
	Last Modified By: Anuradha Appirio
	Last Modified Date : Aug 9 2011
*/
public class SetupPerformanceMetrics{

   private Performance_Metric__c performanceMetric;
   private String validFrom;
   private String validTo;
   private String cutOffDate;
   private Date openEditDate;
   private List<Metric_Tier_Relation__c> customerSatisfactionTier1List=new List<Metric_Tier_Relation__c>(); 
   private List<Metric_Tier_Relation__c> customerSatisfactionTier2List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> customerSatisfactionTier3List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> trainingTier1List=new List<Metric_Tier_Relation__c>(); 
   private List<Metric_Tier_Relation__c> trainingTier2List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> trainingTier3List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> performanceToBPTier1List=new List<Metric_Tier_Relation__c>(); 
   private List<Metric_Tier_Relation__c> performanceToBPTier2List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> performanceToBPTier3List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> spwrSolutionTier1List=new List<Metric_Tier_Relation__c>(); 
   private List<Metric_Tier_Relation__c> spwrSolutionTier2List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> spwrSolutionTier3List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> marketingTier1List=new List<Metric_Tier_Relation__c>(); 
   private List<Metric_Tier_Relation__c> marketingTier2List=new List<Metric_Tier_Relation__c>();
   private List<Metric_Tier_Relation__c> marketingTier3List=new List<Metric_Tier_Relation__c>();
   private List<Tier__c> tierList;
   private List<SelectOption> tiers= new List<selectOption>();
   public String selectedTier;
   public List<MetricsDetails> rsmList=new List<MetricsDetails>();
   private List<Metric_Tier_Relation__c> currentMetricList;
   public String accountId;
   public String ProfileNameSys='System Administrator';
   //Added Start
   private Performance_Metric__c performanceMetricNEW;
   public String accountList;
   
   // Done for Case # 00071804
   public List<Performance_Metric__c> performanceMetricList{get;set;}
   
   public List <SelectOption> accOptionList= new List<selectOption>(); 
    
   String UserId= userInfo.getuserId();
   String UserName= userInfo.getName();
   User u = new User();
   Boolean showAccountView;
   String roleId = UserInfo.getUserRoleId();
   UserRole userrole = [select name from UserRole where id=: this.roleId];
   String profileId = UserInfo.getProfileId(); 
   Profile userprofile = [select name from Profile where id=: this.profileId];
   
   //End
   Boolean freezeMetric;
   private PDF_Limit__c pdfObjTier1;
   private PDF_Limit__c pdfObjTier2;
   private PDF_Limit__c pdfObjTier3;
   private Double pdfTier1;
   private Double pdfTier2;
   private Double pdfTier3;
   private Date expDate;
   public  Date periodEndDate;
   public String performanceMetricId;
   private String tier1Id;
   private String tier2Id;
   private String tier3Id;
   private String tier1Label;
   private String tier2Label;
   private String tier3Label;
   private String theater;
   private String country;
   private Boolean marketAddRow;
   private Boolean freezeRSMMetric;     
   private final static String AUTHORIZED='Authorized';
   private final static String PREMIER='Premier';
   private final static String ELITE='Elite';
   private final static String SRI='SRI';
   
   private final static String ITALY='Italy';
   private final static String FRANCE='France';
   private final static String CUSTOMER_SATISFACTION='Customer Satisfaction';
   private final static String TRAINING='Training';
   private final static String PERFORMANCE_TO_BP='Performance to Business Plan'; 
   private final static String SPWR_SOLUTIONS='All SPWR solutions';
   private final static String MARKETING='Marketing';
   private final static String NAME_TO_APPEND='-Partner-Residential';      
   private final static String NAME_TO_APPEND_COMBO='-Partner-Combo';
   
   private final static Set<String> editableLables = new Set<String>{'Bonus for Meeting 6 Month Revenue Target',
                                                        'Kw agreed target',
                                                        'SunPower Showroom Display',
                                                        'Co-branded All Vehicles',
                                                        'Co-branded Business Cards',
                                                        'Co-branded sales and installation apparel',
                                                        'Display of SunPower Training Certificates',
                                                        'Local events',
                                                        'Advertising',
                                                        'Co-branded Signs at job-site' };
   //Added by Neeraj    
   public String rackingprice{
        get{
            return String.valueof(performanceMetric.Racking_Price__c);
        }set{
            performanceMetric.Racking_Price__c = Double.valueOf(value);
        }
   }
   public SetupPerformanceMetrics(ApexPages.StandardController controller) {
   	
      // system.debug('Profilename'+userprofile);
       if(userprofile.Name.equals('System Administrator')||userprofile.Name.equals('Systemadministrator')||userprofile.Name.equals('Amministratore del sistema')){
           ProfileNameSys = userprofile.Name;   
       }
       if(performanceMetricId == null)
        performanceMetricId=ApexPages.currentPage().getParameters().get('id');
       
        if(performanceMetricId == null || performanceMetricId == '')
        {
         	ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'PerformanceMetric Id is null'));
        } 
       system.debug('qwert'+performanceMetricId);      
       
        // Done for Case # 00071804
       //performanceMetric=[SELECT Channel__c,Thea__c,Country__c,Performance_Period_Start_Date__c,Racking_Price__c,
       //Performance_period_End_date__c,Metric_Setup_Cut_off_Date__c,Open_Edit_date__c FROM Performance_Metric__c WHERE id = :performanceMetricId];
       
       performanceMetricList = new List<Performance_Metric__c>([SELECT Channel__c,Thea__c,Country__c,Performance_Period_Start_Date__c,Racking_Price__c,
       															Performance_period_End_date__c,Metric_Setup_Cut_off_Date__c,Open_Edit_date__c FROM Performance_Metric__c WHERE id = :performanceMetricId]);
	   if(performanceMetricList.size() > 0){       															
	   		performanceMetric = performanceMetricList[0];	
	   }else{
	   		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Performance Metric does not found.'));		
	   	  return;
	   }
       
       //Added by Sagar-Start 
       u = [Select name,Country_Domain__c from User where Id =: UserId];
       openEditDate = performanceMetric.Open_Edit_date__c;
       validFrom=getDateFormat(performanceMetric.Performance_Period_Start_Date__c);
       validTo=getDateFormat(performanceMetric.Performance_period_End_date__c);
       cutOffDate=getDateFormat(performanceMetric.Metric_Setup_Cut_off_Date__c);
       theater=performanceMetric.Thea__c; 
       country=performanceMetric.Country__c;
       expDate=performanceMetric.Metric_Setup_Cut_off_Date__c;
       periodEndDate=performanceMetric.Performance_period_End_date__c;
       //Check if this performanceMetricId exists in Metric Tier Object, If not then  call copy function
            
       //Fill All the Category Lists
       fillCategoryListBasedOnTiers(performanceMetric,performanceMetricId);
       
       //onLoad tiers SelectOption first Value
       String tierName;
       if(tiers.size()>0){
           if((tiers.get(0).getValue()).equals('SRI'))
           {
               tierName='Residential Installer';
           }
           else
           {
               tierName=tiers.get(0).getValue();
           }
       }       
       accOptionList=checkAccountList(tierName);
       if(accOptionList!=null && accOptionList.size()>0)
       {
           this.accountId=accOptionList.get(0).getValue();
       }   
       showRSMView();
   }
   
   public void copyMetricTierRecords(String country,String channel,String perfId)
   {
       List<Metric_Tier_Relation__c> newRecords=new List<Metric_Tier_Relation__c>(); 
       List<Performance_Metric__c> performanceMetricList=[SELECT Id,racking_Price__c,Country__c FROM Performance_Metric__c WHERE Channel__c = :channel and Country__c=:country];
       if(performanceMetricList.size()>0)
       {
           List<Metric_Tier_Relation__c> mtrList=[select Accept_Attachment__c,Metric_Description__c,Metric_Label__c,Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Incentive_Amount__c,Metric_Input_Type__c,
            Enter_Tier__c,Stay_Tier__c,Benefit_Tier__c,Market_Add_Row__c,isRSMView__c,Manual_Partner__c,Part_Of_Composite_Incentive__c,HelpText__c,Tier__c,Category__c,Bonus_Requirement__c  from Metric_Tier_Relation__c where Performance_Metric__c=:performanceMetricList.get(0).Id];
            for(Metric_Tier_Relation__c mtr:mtrList)
            {
                Metric_Tier_Relation__c obj=new Metric_Tier_Relation__c();
                obj.Performance_Metric__c=perfId;
                obj.Tier__c=mtr.Tier__c;
                obj.Metric_Label__c=mtr.Metric_Label__c;
                obj.Metric_Description__c=mtr.Metric_Description__c;
                obj.Category__c=mtr.Category__c;
                obj.Metric_Input_Type__c=mtr.Metric_Input_Type__c;
                obj.Boolean_Metric_Y_N__c=mtr.Boolean_Metric_Y_N__c;
                obj.Metric_Min_Value__c=mtr.Metric_Min_Value__c;
                obj.Metric_Max_Value__c=mtr.Metric_Max_Value__c;
                obj.Incentive_Amount__c=mtr.Incentive_Amount__c;
                obj.Enter_Tier__c=mtr.Enter_Tier__c;
                obj.Stay_Tier__c=mtr.Stay_Tier__c;
                obj.Benefit_Tier__c=mtr.Benefit_Tier__c;
                obj.Market_Add_Row__c=mtr.Market_Add_Row__c;
                obj.Manual_Partner__c =mtr.Manual_Partner__c;
                obj.isRSMView__c = mtr.isRSMView__c;
                obj.Part_Of_Composite_Incentive__c = mtr.Part_Of_Composite_Incentive__c;
                obj.HelpText__c = mtr.HelpText__c;
                
                newRecords.add(obj);    
            }
            system.debug('Ronak Copy Metric'+newRecords);
       }
   }
    
    public void filterTierDropDown()
    {
        accOptionList.clear();
        String tierOnChange;
       if(selectedTier.equals('SRI'))
       {
           tierOnChange='Residential Installer';
       }
       else
       {
           tierOnChange=selectedTier;
       }
        accOptionList=checkAccountList(tierOnChange);
        accountList=null;
        showRSMView();
    }
    
    public Boolean getFreezeMetric()
    {
        /* Done for the case # 00049203 on 4Feb2011 */
        if(!userprofile.Name.equals(ProfileNameSys)
            && !userrole.Name.equals('Business Development Manager')
            && !userrole.Name.equals('Channel Manager')
            && !PerformanceEvalCst.exemptedUsersSet.contains(UserName))
        {
            return true;
        }
        return false;
    }
    
    /***Added Start***/
    public Boolean getMarketAddRow(){
        if(userprofile.Name.equals(ProfileNameSys)){
            return true;
        }
        else
        {
            return false;
        }
    }
    
    public Boolean getFreezeRSMMetric()
    {
       /*
       if(Date.Today()>periodEndDate)
        {
            return true;
        }
        else
        {
            return false;
        }*/
        
        /* Done for the case # 00049203 on 4Feb2011 */
        if(!PerformanceEvalCst.exemptedUsersSet.contains(UserName)){    
          if(openEditDate != null && Date.Today() > openEditDate){
           return true;
          }else{
           return false;
          }
        }else{
           return false;
        } 
    }
    
    /**Flag to indicate if the user is  System Admin**/
    public Boolean getShowAccountView(){
         
         /* Done for the case # 00050543 on 19Feb2011 */         
         //if(userrole.Name.equals('Regional Sales Manager')
         if(userrole.Name.contains('Regional Sales Manager')
            //|| userprofile.Name.equals(ProfileNameSys) ||userrole.Name.equals('Area Sales Manager')||userrole.Name.equals('National Sales Director')||userrole.Name.equals('Director of Sales')||userrole.Name.equals('Channel Manager')||userrole.Name.equals('Business Development Manager') ){
            || PerformanceEvalCst.exemptedUsersSet.contains(UserName) 
            || userprofile.Name.equals(ProfileNameSys) ||userrole.Name.contains('Area Sales Manager')||userrole.Name.contains('National Sales Director')||userrole.Name.equals('Director of Sales')||userrole.Name.equals('Channel Manager')||userrole.Name.equals('Business Development Manager') ){
            
            return true;
        }
        else{
            return false;
        }
        
    }
    
    public List<SelectOption> checkAccountList(String tierName){
        if(tierName == null)
            return null;
        List<Account> accountList = new List<Account>();
        System.debug('RONAK Tier Name '+ tierName);
        System.debug('RONAK loggen in user Country Name '+ u.Country_Domain__c);
        String domain1,domain2,domain3;
        if(country.equals('USA'))
        {
           domain1='rvar-us'; 
           domain2='combo-us';
        }
        else if(country.equals('Italy'))
        {
            domain1='rvar-it';
            domain2='cvar-it';
            domain3='combo-it'; 
        }
        else if(country.equals('Germany'))
        {
            domain1='rvar-de';
            domain2='cvar-de'; 
            domain3='combo-de';
        }else if(country.equals('France'))
        {
            domain1='rvar-fr';
            domain2='cvar-fr'; 
            domain3='combo-fr';
        }
        //Added for UK domain for Case 00072314
        else if(country.equals('United Kingdom'))
        {
            domain1='rvar-uk';
            domain2='cvar-uk'; 
            domain3='combo-uk';
        }
        //Start 00105774
        else if(country.equals('Australia'))
        {
            domain1 = 'rvar-au';
            domain2 = 'cvar-au'; 
            domain3 = 'combo-au';
        }
        //End 00105774
        // Added for case 00050644
        else if(country.equals('Belgium'))
        {
            domain1='rvar-be';
            domain2='cvar-be'; 
            domain3='combo-be';
        }
        if(tierName.equals('Residential Installer'))
        {
            /* Done for the case # 00050543 on 19Feb2011 */
            //if(userrole.Name.equals('Regional Sales Manager')){
            if(userrole.Name.contains('Regional Sales Manager')){
                accountList = [SELECT name,Type,Id,RSM__c from Account where (Country_Domain__c =: domain1 OR Country_Domain__c =: domain2 OR Country_Domain__c =: domain3) and Type=:tierName and RSM__c=:userId and Status__c ='Active' ORDER BY name]; //REMOVED and RSM__c=:userId     
            }else{
                accountList = [SELECT name,Type,Id from Account where (Country_Domain__c =: domain1 OR Country_Domain__c =: domain2 OR Country_Domain__c =: domain3) and Type=:tierName and Status__c ='Active' ORDER BY name];     
            }
        }
        else
        {
            String tier1=tierName+NAME_TO_APPEND;
            String tier2=tierName+NAME_TO_APPEND_COMBO;
            /* Done for the case # 00050543 on 19Feb2011 */
            //if(userrole.Name.equals('Regional Sales Manager')){
            if(userrole.Name.contains('Regional Sales Manager')){
                if(country.equals('USA'))
                    accountList = [SELECT name,Type,Id,RSM__c from Account where (Country_Domain__c =: domain1 OR Country_Domain__c =: domain2) and (Type=:tier1 or Type=:tier2) and RSM__c=:userId and Status__c ='Active'ORDER BY name]; //REMOVED and RSM__c=:userId 
                else
                    accountList = [SELECT name,Type,Id,RSM__c from Account where (Country_Domain__c =: domain1 OR Country_Domain__c =: domain2 OR Country_Domain__c =: domain3) and (Type=:tier1 or Type=:tier2) and RSM__c=:userId and Status__c ='Active'ORDER BY name];    
            }else{
                if(country.equals('USA'))
                    accountList = [SELECT name,Type,Id from Account where (Country_Domain__c =: domain1 OR Country_Domain__c =: domain2) and (Type=:tier1 or Type=:tier2) and Status__c ='Active'ORDER BY name]; 
                else
                    accountList = [SELECT name,Type,Id from Account where (Country_Domain__c =: domain1 OR Country_Domain__c =: domain2 OR Country_Domain__c =: domain3) and (Type=:tier1 or Type=:tier2) and Status__c ='Active'ORDER BY name];     
            }
        }
        List<SelectOption> optionList=new List<SelectOption>(); 
        System.debug('$$Shishir '+ accountList);
        for(Account acc: accountList){
            optionList.add(new SelectOption(acc.Id,acc.name));
        }
        return optionList;
    }
    
    /*** End ***/   
    private void fillCategoryListBasedOnTiers(Performance_Metric__c performanceMetric,String id)
    {
        //Query Tier object based on Country & get the Tier Name
       //Based on the performance metric id & tier id query MetricTier Object
        tierList=[select Id,Country__c,Tier_Name__c from Tier__c where Country__c= :performanceMetric.Country__c];
       //For different Tiers populate the tabs & corresponding data
        for(Tier__c tier:tierList)
        {
            String tier_id=tier.Id;
            String tierName=tier.Tier_Name__c;
            String tierCountry=tier.Country__c;
            //Based on Performance Metric Id & TierId get the list of 5 different Categories
            //Also Check the Country=Italy then Tier will include SRI & Elite will be removed
            if(tierCountry.equals(ITALY)||tierCountry.equals(FRANCE))
            {
                if(tierName.equals(SRI))
                {
                    tier1Id=tier_id;
                    tier1Label=tierName;
                    
                    //tiers.add(new SelectOption(tier1Label,tier1Label));
                    
                    List<PDF_Limit__c> pdfList=[select Partner__c from PDF_Limit__c where Performance_Metric__c=:id and Tier__c=:tier_id];
                    if(pdfList.size() > 0)
                    {
                        pdfObjTier1 = pdfList.get(0);
                        pdfTier1=pdfObjTier1.Partner__c;
                    }   
                    customerSatisfactionTier1List=getCategoryList(CUSTOMER_SATISFACTION,id,tier_id);
                    trainingTier1List=getCategoryList(TRAINING,id,tier_id);
                    performanceToBPTier1List=getCategoryList(PERFORMANCE_TO_BP,id,tier_id);
                    spwrSolutionTier1List=getCategoryList(SPWR_SOLUTIONS,id,tier_id);
                    marketingTier1List=getCategoryList(MARKETING,id,tier_id);
                }
                else if(tierName.equals(AUTHORIZED))
                {
                    tier2Id=tier_id;
                    tier2Label=tierName;
                    tiers.add(new SelectOption(tier2Label,tier2Label));
                    List<PDF_Limit__c> pdfList=[select Partner__c from PDF_Limit__c where Performance_Metric__c=:id and Tier__c=:tier_id];
                    if(pdfList.size()>0)
                    {
                        pdfObjTier2=pdfList.get(0);
                        pdfTier2=pdfObjTier2.Partner__c;
                    }   
                    customerSatisfactionTier2List=getCategoryList(CUSTOMER_SATISFACTION,id,tier_id);
                    trainingTier2List=getCategoryList(TRAINING,id,tier_id);
                    performanceToBPTier2List=getCategoryList(PERFORMANCE_TO_BP,id,tier_id);
                    spwrSolutionTier2List=getCategoryList(SPWR_SOLUTIONS,id,tier_id);
                    marketingTier2List=getCategoryList(MARKETING,id,tier_id);
                }
                else if(tierName.equals(PREMIER))
                {
                    tier3Id=tier_id;
                    tier3Label=tierName;
                    tiers.add(new SelectOption(tier3Label,tier3Label));
                    List<PDF_Limit__c> pdfList=[select Partner__c from PDF_Limit__c where Performance_Metric__c=:id and Tier__c=:tier_id];
                    if(pdfList.size()>0)
                    {
                        pdfObjTier3=pdfList.get(0);
                        pdfTier3=pdfObjTier3.Partner__c;
                    }    
                    customerSatisfactionTier3List=getCategoryList(CUSTOMER_SATISFACTION,id,tier_id);
                    trainingTier3List=getCategoryList(TRAINING,id,tier_id);
                    performanceToBPTier3List=getCategoryList(PERFORMANCE_TO_BP,id,tier_id);
                    spwrSolutionTier3List=getCategoryList(SPWR_SOLUTIONS,id,tier_id);
                    marketingTier3List=getCategoryList(MARKETING,id,tier_id);
                }
            }
            else
            {
                if(tierName.equals(AUTHORIZED))
                {
                    tier1Id=tier_id;
                    tier1Label=tierName;
                    
                    if(tierCountry.equals('Germany'))
                      tiers.add(new SelectOption(tier1Label,tier1Label));
                    
                    List<PDF_Limit__c> pdfList=[select Partner__c from PDF_Limit__c where Performance_Metric__c=:id and Tier__c=:tier_id];
                    if(pdfList.size() > 0)
                    {
                        pdfObjTier1 = pdfList.get(0);
                        pdfTier1=pdfObjTier1.Partner__c;
                    }   
                    customerSatisfactionTier1List=getCategoryList(CUSTOMER_SATISFACTION,id,tier_id);
                    trainingTier1List=getCategoryList(TRAINING,id,tier_id);
                    performanceToBPTier1List=getCategoryList(PERFORMANCE_TO_BP,id,tier_id);
                    spwrSolutionTier1List=getCategoryList(SPWR_SOLUTIONS,id,tier_id);
                    marketingTier1List=getCategoryList(MARKETING,id,tier_id);
                }
                else if(tierName.equals(PREMIER))
                {
                    tier2Id=tier_id;
                    tier2Label=tierName;
                    tiers.add(new SelectOption(tier2Label,tier2Label));
                    List<PDF_Limit__c> pdfList=[select Partner__c from PDF_Limit__c where Performance_Metric__c=:id and Tier__c=:tier_id];
                    if(pdfList.size()>0)
                    {
                        pdfObjTier2=pdfList.get(0);
                        pdfTier2=pdfObjTier2.Partner__c;
                    } 
                    customerSatisfactionTier2List=getCategoryList(CUSTOMER_SATISFACTION,id,tier_id);
                    trainingTier2List=getCategoryList(TRAINING,id,tier_id);
                    performanceToBPTier2List=getCategoryList(PERFORMANCE_TO_BP,id,tier_id);
                    spwrSolutionTier2List=getCategoryList(SPWR_SOLUTIONS,id,tier_id);
                    marketingTier2List=getCategoryList(MARKETING,id,tier_id);
                }
                else if(tierName.equals(ELITE) && !tierCountry.equals('Germany'))
                {
                    tier3Id=tier_id;
                    tier3Label=tierName;
                    tiers.add(new SelectOption(tier3Label,tier3Label));
                    List<PDF_Limit__c> pdfList=[select Partner__c from PDF_Limit__c where Performance_Metric__c=:id and Tier__c=:tier_id];
                    if(pdfList.size()>0)
                    {
                        pdfObjTier3=pdfList.get(0);
                        pdfTier3=pdfObjTier3.Partner__c;
                    }    
                    customerSatisfactionTier3List=getCategoryList(CUSTOMER_SATISFACTION,id,tier_id);
                    trainingTier3List=getCategoryList(TRAINING,id,tier_id);
                    performanceToBPTier3List=getCategoryList(PERFORMANCE_TO_BP,id,tier_id);
                    spwrSolutionTier3List=getCategoryList(SPWR_SOLUTIONS,id,tier_id);
                    marketingTier3List=getCategoryList(MARKETING,id,tier_id);
                }   
            }
        }
    }
    
    private List<Metric_Tier_Relation__c> getCategoryList(String category,String performanceMetricId,String tierId)
    {
       List<Metric_Tier_Relation__c> listToReturn=[select Accept_Attachment__c, Sequence_Order__c,Metric_Description__c,Metric_Label__c,Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Incentive_Amount__c,Metric_Input_Type__c,
            Enter_Tier__c,Stay_Tier__c,Benefit_Tier__c,Market_Add_Row__c,Manual_Partner__c,Part_Of_Composite_Incentive__c,HelpText__c,isRSMView__c,Bonus_Requirement__c  from Metric_Tier_Relation__c where Performance_Metric__c=:performanceMetricId and Tier__c=:tierId and Category__c=:category and inactive__c=:false ORDER by Sequence_Order__c];    

        return listToReturn;
    }
        
    public PageReference saveObj() {
        try{
            //Save PDF data
            saveOrUpdatePDF();
             //Save Metric Data by Category
            //Customer Satisfaction
            removeEmptyFields(customerSatisfactionTier1List); //For Min,Max&Incentive
            removeEmptyFields(customerSatisfactionTier2List);
            removeEmptyFields(customerSatisfactionTier3List);
            update customerSatisfactionTier1List;
            update customerSatisfactionTier2List;
            update customerSatisfactionTier3List;
            //Trning
            removeEmptyFields(trainingTier1List);
            removeEmptyFields(trainingTier2List);
            removeEmptyFields(trainingTier3List);
            update trainingTier1List;
            update trainingTier2List;
            update trainingTier3List;
            //Performance to BP
            removeEmptyFields(performanceToBPTier1List);
            removeEmptyFields(performanceToBPTier2List);
            removeEmptyFields(performanceToBPTier3List);
            update performanceToBPTier1List;
            update performanceToBPTier2List;
            update performanceToBPTier3List;
            //SPWR Solution
            removeEmptyFields(spwrSolutionTier1List);
            removeEmptyFields(spwrSolutionTier2List);
            removeEmptyFields(spwrSolutionTier3List);
            update spwrSolutionTier1List;
            update spwrSolutionTier2List;
            update spwrSolutionTier3List;
            //Marketing
            removeEmptyFields(marketingTier1List);
            removeEmptyFields(marketingTier2List);
            removeEmptyFields(marketingTier3List);
            //update null label records 

               
            update marketingTier1List;
            update marketingTier2List;
            update marketingTier3List;
           }
        catch(System.DMLException e) {
        ApexPages.addMessages(e);
        }
        return null;
    }
    
    public PageReference saveMarketingObj() {
        try{
            //Delete
            List<Metric_Tier_Relation__c> deleteMarketTier1=removeEmptyRecords(marketingTier1List);
            if(deleteMarketTier1.size()>0)
                delete deleteMarketTier1;
            List<Metric_Tier_Relation__c> deleteMarketTier2=removeEmptyRecords(marketingTier2List);
            if(deleteMarketTier2.size()>0)
                delete deleteMarketTier2;
            List<Metric_Tier_Relation__c> deleteMarketTier3=removeEmptyRecords(marketingTier3List);
            if(deleteMarketTier3.size()>0)
                delete deleteMarketTier3; 
            //Insert
              //Save Marketing newly added rows
            insertMarketDataTier1();
            insertMarketDataTier2();
            insertMarketDataTier3();
            
            removeEmptyFields(marketingTier1List);
            removeEmptyFields(marketingTier2List);
            removeEmptyFields(marketingTier3List);  
        }
        catch(System.DMLException e) {
        ApexPages.addMessages(e);
        }
        return null;
    }
        
    private void insertMarketDataTier1()
    {
        Integer startIndex=(marketingTier1List.size()+1);
       
        Integer endIndex=Integer.valueOf(ApexPages.currentPage().getParameters().get('marketing1rows'));
        
        if(endIndex>=startIndex)
        {
            List<Metric_Tier_Relation__c> marketTier1=new List<Metric_Tier_Relation__c>();
            for(Integer row=startIndex;row<=endIndex;row++)
            {
                String metricLabel=ApexPages.currentPage().getParameters().get('row1Label'+row);
               if(metricLabel!=null && !metricLabel.equals('') && !metricLabel.equals(' '))
                {
                    Boolean booleanMetric=getBooleanFromString(ApexPages.currentPage().getParameters().get('boolean1Metric'+row));
                    Boolean stay=getBooleanFromString(ApexPages.currentPage().getParameters().get('stayTier1'+row));
                    Boolean enter=getBooleanFromString(ApexPages.currentPage().getParameters().get('enterTier1'+row));
                    Boolean benefit=getBooleanFromString(ApexPages.currentPage().getParameters().get('benefitTier1'+row));
                    Boolean partnerIn=getBooleanFromString(ApexPages.currentPage().getParameters().get('allowPartner1'+row));

                    Double incentive=null;
                    if(ApexPages.currentPage().getParameters().get('incentive1'+row)!=null
                        && !(ApexPages.currentPage().getParameters().get('incentive1'+row)).equals(' ')
                        && !(ApexPages.currentPage().getParameters().get('incentive1'+row)).equals(''))
                    {
                        incentive=Double.valueOf(ApexPages.currentPage().getParameters().get('incentive1'+row));
                    }   
                    marketTier1.add(newMetricTierObj('Marketing',tier1Id,metricLabel,booleanMetric,stay,enter,benefit,incentive,true,partnerIn,false ));

                }
            }
            insert marketTier1;
            for(Metric_Tier_Relation__c metric:marketTier1)
            {
                marketingTier1List.add(metric);
            }
        }
    }
    
    private void insertMarketDataTier2()
    {
        Integer startIndex=(marketingTier2List.size()+1);
        Integer endIndex=Integer.valueOf(ApexPages.currentPage().getParameters().get('marketing2rows'));
        if(endIndex>=startIndex)
        {
            List<Metric_Tier_Relation__c> marketTier2=new List<Metric_Tier_Relation__c>();
            for(Integer row=startIndex;row<=endIndex;row++)
            {
                String metricLabel=ApexPages.currentPage().getParameters().get('row2Label'+row);
                if(metricLabel!=null && !metricLabel.equals('') && !metricLabel.equals(' '))
                {
                    Boolean booleanMetric=getBooleanFromString(ApexPages.currentPage().getParameters().get('boolean2Metric'+row));
                    Boolean stay=getBooleanFromString(ApexPages.currentPage().getParameters().get('stayTier2'+row));
                    Boolean enter=getBooleanFromString(ApexPages.currentPage().getParameters().get('enterTier2'+row));
                    Boolean benefit=getBooleanFromString(ApexPages.currentPage().getParameters().get('benefitTier2'+row));
                    Boolean partnerIn=getBooleanFromString(ApexPages.currentPage().getParameters().get('allowPartner2'+row));

                    Double incentive=null;
                    if(ApexPages.currentPage().getParameters().get('incentive2'+row)!=null
                        && !(ApexPages.currentPage().getParameters().get('incentive2'+row)).equals(' ')
                        && !(ApexPages.currentPage().getParameters().get('incentive2'+row)).equals(''))
                    {
                        incentive=Double.valueOf(ApexPages.currentPage().getParameters().get('incentive2'+row));
                    }   
                    marketTier2.add(newMetricTierObj('Marketing',tier2Id,metricLabel,booleanMetric,stay,enter,benefit,incentive,true,partnerIn,false));
                    
                }
            }
            insert marketTier2;
            for(Metric_Tier_Relation__c metric:marketTier2)
            {
                marketingTier2List.add(metric);
            }
        }
    }
    
    private void insertMarketDataTier3()
    {
        Integer startIndex=(marketingTier3List.size()+1);
        Integer endIndex=Integer.valueOf(ApexPages.currentPage().getParameters().get('marketing3rows'));
        if(endIndex>=startIndex)
        {
            List<Metric_Tier_Relation__c> marketTier3=new List<Metric_Tier_Relation__c>();
            for(Integer row=startIndex;row<=endIndex;row++)
            {
                String metricLabel=ApexPages.currentPage().getParameters().get('row3Label'+row);
                if(metricLabel!=null && !metricLabel.equals('') && !metricLabel.equals(' '))
                {
                    Boolean booleanMetric=getBooleanFromString(ApexPages.currentPage().getParameters().get('boolean3Metric'+row));
                    Boolean stay=getBooleanFromString(ApexPages.currentPage().getParameters().get('stayTier3'+row));
                    Boolean enter=getBooleanFromString(ApexPages.currentPage().getParameters().get('enterTier3'+row));
                    Boolean benefit=getBooleanFromString(ApexPages.currentPage().getParameters().get('benefitTier3'+row));
                    Boolean partnerIn=getBooleanFromString(ApexPages.currentPage().getParameters().get('allowPartner3'+row));

                    Double incentive=null;
                    if(ApexPages.currentPage().getParameters().get('incentive3'+row)!=null
                        && !(ApexPages.currentPage().getParameters().get('incentive3'+row)).equals(' ')
                        && !(ApexPages.currentPage().getParameters().get('incentive3'+row)).equals(''))
                    {
                        incentive=Double.valueOf(ApexPages.currentPage().getParameters().get('incentive3'+row));
                    }   
                    marketTier3.add(newMetricTierObj('Marketing',tier3Id,metricLabel,booleanMetric,stay,enter,benefit,incentive,true,partnerIn,false));
                    
                }
            }
            insert marketTier3;
            for(Metric_Tier_Relation__c metric:marketTier3)
            {
                marketingTier3List.add(metric);
            }
        }
    }
    
    public PageReference showRSMView()
    {   system.debug('resh'+rsmlist);
    
        this.rsmList.clear();
        String accountId1=null;
        String partnerTier=null; 
        if(accountList!=null)
        {
            accountId1=accountList;
        }
        else if(accOptionList!=null && accOptionList.size()>0)
        {
            accountId1=accOptionList.get(0).getValue();
        }
        if(selectedTier!=null)
        {
           partnerTier=selectedTier; 
        } 
        else
        {
            partnerTier=tiers.get(0).getValue();
        }
        
        if(accountId1!=null)
        {   
            List<Tier__c> currentTierObj = [select Tier_Name__c from Tier__c where Tier_Name__c =:partnerTier and country__c=:performanceMetric.Country__c];
            if(currentTierObj != null && currentTierObj.size()> 0)
            currentMetricList = [select Metric_Description__c,Metric_Label__c,Category__c,Metric_Min_Value__c,Metric_Max_Value__c,Incentive_Amount__c,Boolean_Metric_Y_N__c,Metric_Input_Type__c,HelpText__c,Enter_Tier__c,Stay_Tier__c,Benefit_Tier__c,(select Metric_Description__c,Incentive_Amount__c,Stay_Tier__c,Benefit_Tier__c,Enter_Tier__c,Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c from  Metrics__r where account__c =: accountId1 ),Bonus_Requirement__c  from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:performanceMetricId and isRSMView__c=:true and inactive__c=:false ORDER by Sequence_Order__c];
                       system.debug('axxx'+currentMetricList.size());
                       if(currentMetricList.size()>0)
                       {
                           // MTR is present
                           //But check for Metric object with this account
                           //If Metric object not present create blank object and show
                            for(Metric_Tier_Relation__c mtr : currentMetricList)
                            {
                                if(mtr != null)
                                { 
                                   MetricsDetails m = new MetricsDetails();
                                   m.meetricTierRel = mtr;
                                   List<Metric__c> mlst = mtr.Metrics__r;
                                   system.debug('Ronak Metric '+mlst);
                                   //filtered mlst by Account Id
                                   if(mlst != null && mlst.size() > 0)
                                   {
                                         m.metric = mlst.get(0);   
                                   }
                                   else
                                   {
                                       Metric__c met = new Metric__c();
                                        met.Account__c = accountId1;
                                        met.Metric_Tier_Relation__c = mtr.Id;
                                        met.Performance_Metric__c = performanceMetricId;
                                        met.Metric_Description__c=mtr.metric_label__c;
                                        met.Boolean_Metric_Y_N__c = true;
                                        met.Metric_Min_Value__c = null;
                                        met.Metric_Max_Value__c = null;
                                        met.Metric_Input_Type__c = 'Manual';
                                        met.Enter_Tier__c = false;
                                        met.Benefit_Tier__c = false;
                                        met.Stay_Tier__c = false;
                                        met.Incentive_Amount__c = null;
                                        m.metric=met;
                                   }
                                   //m.setEditableLabels();
                                   rsmList.add(m);
                                }
                            }
                            //Dont add blank metric detail object if Theater=EU & Tier=Authorized
                            if(theater!=null && theater.equals('Europe') && partnerTier!=null && partnerTier.equals('Authorized'))
                            {}
                            else
                            { 
                                system.debug('size of rsmList ='+rsmList.size());
                                if(rsmList.size()==3){
                                    MetricsDetails mdObj1 = new MetricsDetails();
                                    mdObj1.metric.Metric_Input_Type__c='Manual';
                                    mdObj1.meetricTierRel.Metric_Input_Type__c='Manual';
                                    rsmlist.add(mdObj1);
                                }
                                if(rsmList.size()==2){
                                    MetricsDetails mdObj1 = new MetricsDetails();
                                    mdObj1.metric.Metric_Input_Type__c='Manual';
                                    mdObj1.meetricTierRel.Metric_Input_Type__c='Manual';
                                    MetricsDetails mdObj2 = new MetricsDetails();
                                    mdObj2.metric.Metric_Input_Type__c='Manual';
                                    mdObj2.meetricTierRel.Metric_Input_Type__c='Manual';
                                    rsmlist.add(mdObj2);
                                    rsmlist.add(mdObj1);
                                }
                                if(rsmList.size()==1){
                                   MetricsDetails mdObj1 = new MetricsDetails();
                                   mdObj1.metric.Metric_Input_Type__c='Manual';
                                   mdObj1.meetricTierRel.Metric_Input_Type__c='Manual';
                                   MetricsDetails mdObj2 = new MetricsDetails();
                                   mdObj2.metric.Metric_Input_Type__c='Manual';
                                   mdObj2.meetricTierRel.Metric_Input_Type__c='Manual';
                                   MetricsDetails mdObj3 = new MetricsDetails();
                                   mdObj3.metric.Metric_Input_Type__c='Manual';
                                   mdObj3.meetricTierRel.Metric_Input_Type__c='Manual';
                                   rsmlist.add(mdObj1); 
                                   rsmlist.add(mdObj2);
                                   rsmlist.add(mdObj3);
                                }
                           }
                       }
                    }
        /*setting editable labels */
        for(MetricsDetails mtd : rsmlist){
            mtd.setEditableLabels();
        }
        /*end hemant */
        return null;   
    }
    
    String nextTier1 ='';
    public PageReference saveRSMRows()
    {
        String accid=null;
        if(accountList!=null)
        {
            accid=accountList;
        }
        else
        {
            accid=this.accountId;
        }

        List<Tier__c> currentTierObj = [select Tier_Name__c from Tier__c where Tier_Name__c =:selectedTier and country__c=:performanceMetric.Country__c];
        system.debug('T**'+selectedTier+'P**'+performanceMetric.Country__c+'Lst@@'+currentTierObj);
        if(currentTierObj != null && currentTierObj.size()> 0)
        {
           // System.debug(currentTierObj.get(0));
            String tierId=currentTierObj.get(0).id;
            addRowNewRSMRows2(accid,tierId);
            //new code
            if(selectedTier!=null){
                nextTier1 = PerformanceEvalCst.tierMap.get(this.selectedTier);
            }
            List<Tier__c> NexTierObj = [select Tier_Name__c,Id from Tier__c where Tier_Name__c =:nextTier1 and country__c=:performanceMetric.Country__c];
            
            //end code
            updateRSMRows();
            if(NexTierObj.size()>0){
                String nTierId=NexTierObj.get(0).id;
                MTRNextTier(nTierId,accid,tierId);      
            }
            
        }
          
        showRSMView();
    
            removeEmptyFields(customerSatisfactionTier1List); //For Min,Max&Incentive
            removeEmptyFields(customerSatisfactionTier2List);
            removeEmptyFields(customerSatisfactionTier3List);
            removeEmptyFields(trainingTier1List);
            removeEmptyFields(trainingTier2List);
            removeEmptyFields(trainingTier3List);
            removeEmptyFields(performanceToBPTier1List);
            removeEmptyFields(performanceToBPTier2List);
            removeEmptyFields(performanceToBPTier3List);
            removeEmptyFields(spwrSolutionTier1List);
            removeEmptyFields(spwrSolutionTier2List);
            removeEmptyFields(spwrSolutionTier3List);
            removeEmptyFields(marketingTier1List);
            removeEmptyFields(marketingTier2List);
            removeEmptyFields(marketingTier3List);
        return null;
    }
    
    public void updateRSMRows()
    {
       List<Metric__c> metricsNew=new List<Metric__c>();
       List<Metric__c> metricsUpdate=new List<Metric__c>();  
       List<Metric__c> metricsDel=new List<Metric__c>();
       List<Metric_Tier_Relation__c> mtrUpdate=new List<Metric_Tier_Relation__c>();
       List<Metric_Tier_Relation__c> mtrDelete=new List<Metric_Tier_Relation__c>();
       //system.debug('shradu'+rsmlist);
       for(MetricsDetails md: rsmList)
       {
           if(md.meetricTierRel.Id!=null)
           {
               if((!md.meetricTierRel.metric_label__c.equals('Kw agreed target') && !md.meetricTierRel.metric_label__c.equals('Bonus for Meeting 6 Month Revenue Target')) 
               && (md.metric.Metric_Description__c==null || ((md.metric.Metric_Description__c).trim()).equals('')))
               {
                   if(md.metric.Id!=null)
                   {
                    metricsDel.add(md.metric);   
                   }
               }
               else
               {
                   mtrUpdate.add(md.meetricTierRel);
                   if(md.metric.Id!=null)
                   {   
                        metricsUpdate.add(md.metric);
                   }
                   else 
                   {
                        metricsNew.add(md.metric);
                   }
               }
           }
       }
       if(metricsDel.size()>0)
        delete metricsDel;
       if(mtrDelete.size()>0)
        delete mtrDelete;
       if(mtrUpdate.size()>0)
       {
        removeEmptyFields(mtrUpdate);
        update mtrUpdate;
       } 
       if(metricsNew.size()>0)
       insert metricsNew;
       if(metricsUpdate.size()>0)
       {
           removeEmptyMetricFields(metricsUpdate);
           update metricsUpdate;
       }    
    }
    
    public void removeEmptyMetricFields(List<Metric__c> list1)
    {
        if(list1!=null && list1.size()>0)
        {
            for(Metric__c metric:list1)
            {
                if(metric.Metric_Min_Value__c==0)
                {
                    metric.Metric_Min_Value__c=null;
                }
                if(metric.Metric_Max_Value__c==0)
                {
                    metric.Metric_Max_Value__c=null;
                }
                if(metric.Incentive_Amount__c==0)
                {
                    metric.Incentive_Amount__c=null;
                }
            }
        }
    }
    /***add functionality code addrow2**/
  public void addRowNewRSMRows2(String accid,String tierId){
    Boolean booleanMetric=true;
    Boolean stay=false;
    Boolean enter=false;
    Boolean benefit=false;
    Double incentive=null;
    Integer startIndex=1;
    Double min=null;
    Double max=null;
    String metricLabel=null;
    List<Metric_Tier_Relation__c> PBTier1=new List<Metric_Tier_Relation__c>();
        for(MetricsDetails m :rsmList)
            {
                metricLabel=m.meetricTierRel.Metric_Label__c;
                if(metricLabel==null)
                    metricLabel=m.metric.Metric_Description__c;
                if(metricLabel!=null && !(metricLabel.trim()).equals('') && m.meetricTierRel.Id==null)
                {
                     List<Metric_Tier_Relation__c> mtrObjlist = [Select Accept_Attachment__c, Id,Metric_Label__c,Metric_Description__c,Bonus_Requirement__c  from Metric_Tier_Relation__c where Metric_Description__c = : metricLabel and Performance_Metric__c=:performanceMetricId and Tier__c=:tierId]; 
                     if(mtrObjlist.size()==0)
                     {                        
                        stay=m.metric.Stay_Tier__c;
                        enter=m.metric.Enter_Tier__c;
                        benefit=m.metric.Benefit_Tier__c;
                        min=m.metric.Metric_Min_Value__c;
                        max=m.metric.Metric_Max_Value__c;
  
                        if(m.metric.Incentive_Amount__c!=null)                         
                        {
                            incentive=Double.valueOf(m.metric.Incentive_Amount__c);
                            benefit=true;
                        }   
                        PBTier1.add(newMetricTierObj(PERFORMANCE_TO_BP,tierId,metricLabel,booleanMetric,stay,enter,benefit,incentive,false,false,true));
                    }
                }
            } 
            
             List<Metric__c> newMetricList=new List<Metric__c>();               
             for(Integer i=0;i< PBTier1.size();i++)
             {
                Database.SaveResult sr = Database.insert(PBTier1[i]);
                String MtrId= sr.getId();
                List<Metric__c> mObj = [Select Id from Metric__c where Account__c =:accid and Metric_Tier_Relation__c =: MtrId and Performance_Metric__c=:performanceMetricId];
                if(mObj.size()==0)
                    newMetricList.add(newMetricObj(accid,MtrId,booleanMetric,stay,enter,benefit,incentive,min,max,metricLabel)); 
             }
             insert newMetricList;
           
             this.accountId=accid;
    }
    /****end ***/
    
    /*** Added Start ***/
    public void addRowNewRSMRows(String accid,String tierId){
    Boolean booleanMetric=true;
    Boolean stay=false;
    Boolean enter=false;
    Boolean benefit=false;
    Double incentive=null;
    Double min=null;
    Double max=null;
    Integer startIndex=1;
    String metricLabel=null;
    if(rsmList!=null)
        startIndex=(rsmList.size()+1);
       // system.debug('rsms*'+startIndex);
        Integer endIndex=Integer.valueOf(ApexPages.currentPage().getParameters().get('rsmrows'));
        if(endIndex>=startIndex)
        {
            List<Metric_Tier_Relation__c> PBTier1=new List<Metric_Tier_Relation__c>();
            for(Integer row=startIndex;row<=endIndex;row++)
            {
                metricLabel=ApexPages.currentPage().getParameters().get('row1Labelrsm'+row);
               // system.debug('PML**'+metricLabel);
                if(metricLabel!=null && !metricLabel.equals('') && !metricLabel.equals(' '))
                {
                     List<Metric_Tier_Relation__c> mtrObjlist = [Select Id,Metric_Label__c,Metric_Description__c,Bonus_Requirement__c  from Metric_Tier_Relation__c where Metric_Description__c = : metricLabel and Performance_Metric__c=:performanceMetricId and Tier__c=:tierId]; 
                    // system.debug('R**'+performanceMetricId );
                     if(mtrObjlist.size()==0)
                     {                        
                        booleanMetric=true;
                        stay=getBooleanFromString(ApexPages.currentPage().getParameters().get('stayTier1rsm'+row));
                        enter=getBooleanFromString(ApexPages.currentPage().getParameters().get('enterTier1rsm'+row));
                        benefit=getBooleanFromString(ApexPages.currentPage().getParameters().get('benefitTier1rsm'+row));
                        if(ApexPages.currentPage().getParameters().get('incentive1rsm'+row)!=null
                            && !(ApexPages.currentPage().getParameters().get('incentive1rsm'+row)).equals(' ')
                            && !(ApexPages.currentPage().getParameters().get('incentive1rsm'+row)).equals(''))
                        {
                            incentive=Double.valueOf(ApexPages.currentPage().getParameters().get('incentive1rsm'+row));
                            benefit=true;
                        }   
                        PBTier1.add(newMetricTierObj(PERFORMANCE_TO_BP,tierId,metricLabel,booleanMetric,stay,enter,benefit,incentive,false,false,true));
                    }
                }
            } 
             
             List<Metric__c> newMetricList=new List<Metric__c>();               
             for(Integer i=0;i< PBTier1.size();i++)
             {
                Database.SaveResult sr = Database.insert(PBTier1[i]);
                String MtrId= sr.getId();
                List<Metric__c> mObj = [Select Id from Metric__c where Account__c =:accid and Metric_Tier_Relation__c =: MtrId and Performance_Metric__c=:performanceMetricId];
                if(mObj.size()==0)
                    newMetricList.add(newMetricObj(accid,MtrId,booleanMetric,stay,enter,benefit,incentive,min,max,metricLabel)); 
             }
             if(newMetricList.size()>0)
             insert newMetricList;
           
             this.accountId=accid;
             showRSMView();                 
       }
    }
    
    /*** End ***/
    
    private Boolean getBooleanFromString(String value)
    {
        if(value!=null && value.equals('on'))
         return true;
         
        return false;
    }
    /*** Added Start ***/
    private Metric__c newMetricObj(String Aid,String MtrId,Boolean metricFlag,Boolean stay,Boolean enter,Boolean benefit,Double incentive,Double min,Double max,String metricLabel)
    {
        Metric__c obj=new Metric__c();
        obj.Account__c=Aid;
        obj.Metric_Tier_Relation__c= MtrId;
        obj.Performance_Metric__c=performanceMetricId;
        obj.Metric_Input_Type__c='Manual';
        obj.Boolean_Metric_Y_N__c=metricFlag;
        obj.Incentive_Amount__c=incentive;
        obj.Enter_Tier__c=enter;
        obj.Stay_Tier__c=stay;
        obj.Benefit_Tier__c=benefit;
        obj.Metric_Min_Value__c=min;    
        obj.Metric_Max_Value__c=max;
        obj.Metric_Description__c=metricLabel;
        return obj;
    }
    /*** End ***/
    private Metric_Tier_Relation__c newMetricTierObj(String category,String tierid,String label,Boolean metricFlag,Boolean stay,Boolean enter,Boolean benefit,Double incentive,Boolean marketAddRow,Boolean partnerValue,Boolean isRSMVIewFlag)
    {
        Metric_Tier_Relation__c obj=new Metric_Tier_Relation__c();
        obj.Performance_Metric__c=performanceMetricId;
        obj.Tier__c=tierid;
        obj.Metric_Label__c=label;
        obj.Metric_Description__c=label;
        obj.Category__c=category;
        obj.Metric_Input_Type__c='Manual';
        obj.Boolean_Metric_Y_N__c=metricFlag;
        obj.Incentive_Amount__c=incentive;
        obj.Enter_Tier__c=enter;
        obj.Stay_Tier__c=stay;
        obj.Benefit_Tier__c=benefit;
        obj.Market_Add_Row__c=marketAddRow;
        obj.Manual_Partner__c =partnerValue;
        obj.isRSMView__c = isRSMViewFlag;
        return obj;
    }
    
    private List<Metric_Tier_Relation__c> removeEmptyRecords(List<Metric_Tier_Relation__c> list1)
    {
        List<Metric_Tier_Relation__c> deleteRecords=new List<Metric_Tier_Relation__c>();
        List<Metric_Tier_Relation__c> list2=list1.deepClone();
        Integer count=0; 
        for(Metric_Tier_Relation__c metric:list2)
        {
            if(metric.Metric_Description__c==null || ((metric.Metric_Description__c).trim()).equals(''))
            {
               list1.remove(count);
                deleteRecords.add(metric);
            }
            count++;
        }
        return deleteRecords;
    }
    
    private void removeEmptyFields(List<Metric_Tier_Relation__c> list1)
    {
        if(list1!=null && list1.size()>0)
        {
            for(Metric_Tier_Relation__c metric:list1)
            {
                if(metric.Metric_Min_Value__c==0)
                {
                    metric.Metric_Min_Value__c=null;
                }
                if(metric.Metric_Max_Value__c==0)
                {
                    metric.Metric_Max_Value__c=null;
                }
                if(metric.Incentive_Amount__c==0)
                {
                    metric.Incentive_Amount__c=null;
                }
            }
        }
    }
        
    public void saveOrUpdatePDF()
    {
        //PDF for Tier1
        //system.debug('pdfObjTier1==null is'+pdfObjTier1==null);
        if(pdfObjTier1==null || pdfObjTier1.id==null)
        {
            Double tier1Limit=Double.valueOf(this.pdfTier1);
            PDF_Limit__c newPDFObj=newPDFObj(performanceMetricId,tier1Id,tier1Limit);        
            insert newPDFObj;
        }
        else
        {
            pdfObjTier1.Partner__c=this.pdfTier1;
            update pdfObjTier1;
        }
        //PDF for Tier2
        if(pdfObjTier2==null || pdfObjTier2.id==null)
        {
            Double tier2Limit=Double.valueOf(this.pdfTier2);
            PDF_Limit__c newPDFObj=newPDFObj(performanceMetricId,tier2Id,tier2Limit);        
            insert newPDFObj;
        }
        else
        {
            pdfObjTier2.Partner__c=this.pdfTier2;
            update pdfObjTier2;
        }
        //PDF for Tier3
        if(pdfObjTier3==null || pdfObjTier3.id==null)
        {
            Double tier3Limit=Double.valueOf(this.pdfTier3);
            PDF_Limit__c newPDFObj=newPDFObj(performanceMetricId,tier3Id,tier3Limit);        
            insert newPDFObj;
        }
        else
        {
            pdfObjTier3.Partner__c=this.pdfTier3;
            update pdfObjTier3;
        }
    }
    
    public PDF_Limit__c newPDFObj(String perfMetricId,String tierId,Double pdflimit)
    {
         PDF_Limit__c obj=new PDF_Limit__c();
         obj.Performance_Metric__c=perfMetricId;
         obj.Tier__c=tierId;
         obj.Partner__c=pdflimit;
         return obj;   
    }
    
    public String getDateFormat(Date myDT)
    {
        String ddttmm =null;
        if(myDT!=null)
        {
            Datetime myDate = Datetime.newInstance(myDT.year(),myDT.month(),myDT.day(),0,0,0);
            ddttmm =myDate.format('MM/dd/yyyy');
        }
        return ddttmm;    
    }


    public Performance_Metric__c getPerformanceMetric(){
        return performanceMetric;
    } 
    
  
    list<Metric_Tier_Relation__c> lmtr = new list<Metric_Tier_Relation__c>();
    public List<Metric_Tier_Relation__c> getCustomerSatisfactionTier1List(){
          
     for(Metric_Tier_Relation__c mtr : customerSatisfactionTier1List){ 
         /*Metric_Tier_Relation__c mtrob = new Metric_Tier_Relation__c();
         Integer in1 = (mtr.Metric_Min_Value__c).intValue();
         mtrob.Metric_Min_Value__c = in1;
         lmtr.add(mtrob);*/
            system.debug('reshmadas'+mtr.Metric_Min_Value__c);
           
       }
        return customerSatisfactionTier1List;
        
        }
    
    public List<Metric_Tier_Relation__c> getCustomerSatisfactionTier2List(){
        return customerSatisfactionTier2List;
    }
    public List<Metric_Tier_Relation__c> getCustomerSatisfactionTier3List(){
        return customerSatisfactionTier3List;
    }
    public list<Tier__c> getTierList(){
        return tierList;
    }
    
    public Double getPdfTier1(){
        return pdfTier1;
    }
    public void setPdfTier1(Double pdfTier1){
        this.pdfTier1=pdfTier1;
    }
    
    public Double getPdfTier2(){
        return pdfTier2;
    }
    public void setPdfTier2(Double pdfTier2){
        this.pdfTier2=pdfTier2;
    }
    public Double getPdfTier3(){
        return pdfTier3;
    }
    public void setPdfTier3(Double pdfTier3){
        this.pdfTier3=pdfTier3;
    }
    public String getValidFrom(){
        return validFrom;
    }
    public void setValidFrom(String validFrom){
        this.validFrom=validFrom;
    }
    
    public String getValidTo(){
        return validTo;
    }
    public void setValidTo(String validTo){
        this.validTo=validTo;
    }
    
    public String getCutOffDate(){
        return cutOffDate;
    }
    public void setCutOffDate(String cutOffDate){
        this.cutOffDate=cutOffDate;
    }
    
    public String getTier1Label(){
        return tier1Label;
    }
    public String getTier2Label(){
        return tier2Label;
    }
    public String getTier3Label(){
        return tier3Label;
    }
    public List<Metric_Tier_Relation__c> getTrainingTier1List(){
        return trainingTier1List;
    }
    public List<Metric_Tier_Relation__c> getTrainingTier2List(){
        return trainingTier2List;
    }
    public List<Metric_Tier_Relation__c> getTrainingTier3List(){
        return trainingTier3List;
    }
    public List<Metric_Tier_Relation__c> getPerformanceToBPTier1List(){
        return performanceToBPTier1List;
    }
    public List<Metric_Tier_Relation__c> getPerformanceToBPTier2List(){
        return performanceToBPTier2List;
    }
    public List<Metric_Tier_Relation__c> getPerformanceToBPTier3List(){
        return performanceToBPTier3List;
    }
    public List<Metric_Tier_Relation__c> getSpwrSolutionTier1List(){
        return spwrSolutionTier1List;
    }
    public List<Metric_Tier_Relation__c> getSpwrSolutionTier2List(){
        return spwrSolutionTier2List;
    }
    public List<Metric_Tier_Relation__c> getSpwrSolutionTier3List(){
        return spwrSolutionTier3List;
    }
    public List<Metric_Tier_Relation__c> getMarketingTier1List(){
        system.debug('Size of MarketingTier1 List = '+ this.marketingTier1List.size());
        return this.marketingTier1List;
    }
    public List<Metric_Tier_Relation__c> getMarketingTier2List(){
        return marketingTier2List;
    }
    public List<Metric_Tier_Relation__c> getMarketingTier3List(){
        return marketingTier3List;
    }
    public String getTheater(){
        return theater;
    }
    public String getCountry(){
        return country;
    }
    
    public List<SelectOption> getAccOptionList(){ 
        return accOptionList;
    }
    public String getAccountList(){
        return accountList ;
    }
    public void setAccountList (String accountList){
        this.accountList = accountList ;
    }
    public List<MetricsDetails> getRsmList(){
        return rsmList;
    }
    public void setRsmList(List<MetricsDetails> s){
        rsmList = s;
    }
    public String getAccountId(){
        return accountId;
    }
    public void setAccountId(String accountId){
        this.accountId=accountId;
    }
    public String getSelectedTier()
    {
        return selectedTier;
    }
    public void setSelectedTier(String selectedTier)
    {
        this.selectedTier=selectedTier;
    }
    public List<SelectOption> getTiers(){ 
        return tiers;
    }
    
    /**Define a inner class to hold the inforamtions required for the
    * performance evaluation of the Account 
    **/
   public class MetricsDetails{
        Metric_Tier_Relation__c meetricTierRel;
        Metric__c metric;
        public Boolean isLabelEditable{get;set;}
        
        public Metric_Tier_Relation__c getmeetricTierRel(){
            return this.meetricTierRel;
        }
        
        public Metric__c getMetric(){
           
            return this.metric;
        }
        /**addcode**/
        public void setmeetricTierRel(Metric_Tier_Relation__c mt){
            this.meetricTierRel = mt;
        }
        public void setMetric(Metric__c m){
            this.metric = m;
            this.metric.Boolean_Metric_Y_N__c = true;
            this.metric.Metric_Input_Type__c = 'Manual';
        }
        /**addcode**/
        
        
        public MetricsDetails(){
            meetricTierRel = new Metric_Tier_Relation__c();
            metric = new Metric__c();
            isLabelEditable = true;
        }
        
        public void setEditableLabels(){
            if(editableLables.contains(this.meetricTierRel.Metric_Label__c)){
                isLabelEditable = false;
            }
        }
    }
   
    
    public PageReference goToperformanceEvalPage(){
        return new PageReference('/apex/PerformanceEvalPage?accid='+this.accountList);
    } 
    
    public void MTRNextTier(String tierIds,String AccountId,String tierIdP){
        SET<ID> mtrSet = new SET<ID>();
        SET<ID> mtrSet1 = new SET<ID>();
        Integer i = 0;
        String pMetricId=ApexPages.currentPage().getParameters().get('id');
        if(pMetricId == null || pMetricId == '')
        {
         	ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Id is null'));
        }
        List<Metric__c> MLst = [Select Account__c,Boolean_Achievement__c,Performance_Metric__c ,Boolean_Metric_Y_N__c, Enter_Tier__c, Metric_Description__c, Metric_Tier_Relation__c, Metric_Tier_Relation__r.Benefit_Tier__c, Metric_Tier_Relation__r.Boolean_Metric_Y_N__c,Metric_Tier_Relation__r.isRSMView__c, Metric_Tier_Relation__r.Enter_Tier__c, Metric_Tier_Relation__r.Incentive_Amount__c, Metric_Tier_Relation__r.Metric_Label__c, Metric_Tier_Relation__r.Stay_Tier__c, Metric_Tier_Relation__r.Tier__c,Metric_Tier_Relation__r.Performance_Metric__c,  Stay_Tier__c from Metric__c where Metric_Tier_Relation__r.Metric_Label__c LIKE 'RSM%'and Account__c=:AccountId and Metric_Tier_Relation__r.Tier__c =:tierIdP and  Metric_Tier_Relation__r.Performance_Metric__c=:pMetricId];
        List<Metric__c> mlst1 = [select Id,Metric_Description__c,Metric_Tier_Relation__r.Metric_Label__c from Metric__c where Account__c=:AccountId and Metric_Tier_Relation__r.Metric_Label__c LIKE 'RSM%' and Metric_Tier_Relation__r.Tier__c =:tierIds and Metric_Tier_Relation__r.Performance_Metric__c=:pMetricId];
        //system.debug('MetricRSM'+mlst1.size()+'/wer'+MLst);
        if(MLst.size()>0){
            if(!(mlst1.size()>0)){
                List<Metric_Tier_Relation__c> mtrL = [select Id,Metric_Description__c,Metric_Label__c,Category__c,Metric_Min_Value__c,Metric_Max_Value__c,Incentive_Amount__c,Boolean_Metric_Y_N__c,Metric_Input_Type__c,HelpText__c,Enter_Tier__c,Stay_Tier__c,Benefit_Tier__c,Bonus_Requirement__c  from Metric_Tier_Relation__c where Tier__c =:tierIds and Performance_Metric__c =:pMetricId and isRSMView__c=true and Metric_Label__c LIKE 'RSM%'];
                for(Metric_Tier_Relation__c mtr : mtrL){
                    mtrSet.add(mtr.Id);
                }
                //system.debug('hello');
                for(Metric__c m:Mlst){
                    if(i<mtrSet.size()){
                
                         
                        //Insert Metric
                       // system.debug('joy'+m);
                        Metric__c ms = new Metric__c();
                        ms.Account__c =m.Account__c;
                        ms.Boolean_Metric_Y_N__c =m.Boolean_Metric_Y_N__c;
                        ms.Enter_Tier__c = m.Enter_Tier__c;
                        ms.Metric_Description__c = m.Metric_Description__c;
                        ms.Performance_Metric__c =m.Performance_Metric__c;
                        ms.Metric_Tier_Relation__c =mtrL[i].Id; //mr.Id;
                        ms.Boolean_Achievement__c = m.Boolean_Achievement__c;
                        insert ms;
                        i++;
                    }
                }   
                
            }else{ // start of else code
                //system.debug('RSMwon');
                for(Metric__c m:Mlst){
                    for(Metric__c m1:mlst1){
                       // system.debug('RSMfail'+m.Metric_Tier_Relation__r.Metric_Label__c+'/'+m1.Metric_Tier_Relation__r.Metric_Label__c);
                        if(m.Metric_Tier_Relation__r.Metric_Label__c.equals(m1.Metric_Tier_Relation__r.Metric_Label__c)){
                           // system.debug('RSMwonfail');
                            m1.Metric_Description__c = m.Metric_Description__c;
                           // system.debug('Rws1'+m1+'/'+m);
                            update m1;
                           // system.debug('Rws'+m1+'/'+m);
                        }
                    }
                }   
                
            } // end of else code
        }
        
        List<Metric__c> MLstB = [Select Account__c,Metric_Min_Value__c,Boolean_Achievement__c,Performance_Metric__c ,Boolean_Metric_Y_N__c, Enter_Tier__c, Metric_Description__c, Metric_Tier_Relation__c, Metric_Tier_Relation__r.Benefit_Tier__c, Metric_Tier_Relation__r.Boolean_Metric_Y_N__c,Metric_Tier_Relation__r.isRSMView__c, Metric_Tier_Relation__r.Enter_Tier__c, Metric_Tier_Relation__r.Incentive_Amount__c, Metric_Tier_Relation__r.Metric_Label__c, Metric_Tier_Relation__r.Stay_Tier__c, Metric_Tier_Relation__r.Tier__c,Metric_Tier_Relation__r.Performance_Metric__c,  Stay_Tier__c from Metric__c where (Metric_Tier_Relation__r.Metric_Label__c='Bonus for Meeting 6 Month Revenue Target'OR Metric_Tier_Relation__r.Metric_Label__c='Kw agreed target') and Account__c=:AccountId and Metric_Tier_Relation__r.Tier__c =:tierIdP and Metric_Tier_Relation__r.Performance_Metric__c=:pMetricId ];
        List<Metric__c> mlstB1 = [select Id,Metric_Min_Value__c,Metric_Tier_Relation__r.Metric_Label__c from Metric__c where Account__c=:AccountId and (Metric_Tier_Relation__r.Metric_Label__c='Bonus for Meeting 6 Month Revenue Target'OR Metric_Tier_Relation__r.Metric_Label__c='Kw agreed target') and Metric_Tier_Relation__r.Tier__c =:tierIds and Metric_Tier_Relation__r.Performance_Metric__c=:pMetricId];
        if(MLstB.size()>0){
            if(!(mlstB1.size()>0)){
                List<Metric_Tier_Relation__c> mtrL1 = [select Id,Metric_Description__c,Metric_Label__c,Category__c,Metric_Min_Value__c,Metric_Max_Value__c,Incentive_Amount__c,Boolean_Metric_Y_N__c,Metric_Input_Type__c,HelpText__c,Enter_Tier__c,Stay_Tier__c,Benefit_Tier__c,Bonus_Requirement__c  from Metric_Tier_Relation__c where Tier__c =:tierIds and Performance_Metric__c =:pMetricId and isRSMView__c=true and (Metric_Label__c='Bonus for Meeting 6 Month Revenue Target'OR Metric_Label__c='Kw agreed target')];
                for(Metric_Tier_Relation__c mtr : mtrL1){
                    mtrSet1.add(mtr.Id);
                }
                system.debug('hello1'+mtrL1+'/'+pMetricId );
                for(Metric__c m:MLstB){
                    if(i<mtrSet1.size()){
                        //Insert Metric
                       // system.debug('joy'+m);
                        Metric__c ms = new Metric__c();
                        ms.Account__c =m.Account__c;
                        ms.Boolean_Metric_Y_N__c =m.Boolean_Metric_Y_N__c;
                        ms.Enter_Tier__c = m.Enter_Tier__c;
                        ms.Metric_Min_Value__c = m.Metric_Min_Value__c;
                        ms.Metric_Description__c = m.Metric_Description__c;
                        ms.Performance_Metric__c =m.Performance_Metric__c;
                        ms.Metric_Tier_Relation__c =mtrL1[i].Id; //mr.Id;
                        ms.Boolean_Achievement__c = m.Boolean_Achievement__c;
                        insert ms;
                        i++;
                    }
                }   
                
            }else{ //start of else code
                 // start of else code
                //system.debug('RSMwon');
                for(Metric__c m:MLstB){
                    for(Metric__c m1:mlstB1){
                        //system.debug('RSMfail'+m.Metric_Tier_Relation__r.Metric_Label__c+'/'+m1.Metric_Tier_Relation__r.Metric_Label__c);
                        if(m.Metric_Tier_Relation__r.Metric_Label__c.equals(m1.Metric_Tier_Relation__r.Metric_Label__c)){
                            //system.debug('RSMwonfail');
                            m1.Metric_Min_Value__c = m.Metric_Min_Value__c;
                            //system.debug('Rws1'+m1+'/'+m);
                            update m1;
                            //system.debug('Rws'+m1+'/'+m);
                        }
                    }
                }   
                
            
                
            } //end of else code
        }
    }
    
}