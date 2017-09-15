// 
// (c) 2010 Appirio, Inc.
//
// Setting performance metrics for commercial channel(CVAR addition)
//
// 10/25/2010   Hemant Garg(Appirio offshore)   Original
//
public class SetupPerformanceMetricsComm{
   //----------------------------Variables-------------------------------//
   public List<Metric_Tier_Relation__c> customerSatisfactionList{get;set;}  
   public List<Metric_Tier_Relation__c> trainingList{get;set;}
   public List<Metric_Tier_Relation__c> performanceToBPList{get;set;}  
   
   public Performance_Metric__c performanceMetric{get;set;} 
   public String validFrom{get;set;}
   public String validTo{get;set;}
   public String cutOffDate{get;set;}
   private Date openEditDate;
   public List<MetricsDetails> rsmList{get;set;}
   private List<Metric_Tier_Relation__c> currentMetricList;
   public String accountId;
   public String ProfileNameSys ='System Administrator';    
   String UserName= userInfo.getName();
   
   public PDF_Limit__c pdfObject{get;set;}
   
   public List <SelectOption> accOptionList{get;set;} 
    
   String UserId = userInfo.getuserId();
   Boolean showAccountView;
   String roleId = UserInfo.getUserRoleId();
   UserRole userrole = [select name from UserRole where id=: this.roleId];
   String profileId = UserInfo.getProfileId(); 
   Profile userprofile = [select name from Profile where id=: this.profileId];
  
   public Boolean freezeMetric;
  
   public Date expDate{get;set;} 
   public  Date periodEndDate{get;set;} 
   public String performanceMetricId{get;set;} 
  
   public String theater{get;set;} 
   public String country{get;set;} 
   private Boolean marketAddRow;
   //public Boolean freezeRSMMetric{get;set;}     
   public Boolean freezeRSMMetric;     
   
   public String accountSelected{get;set;}
   private final static String CUSTOMER_SATISFACTION = 'customer satisfaction';
   private final static String TRAINING = 'training';
   private final static String PERFORMANCE_TO_BP = 'performance to business plan';    
   
   private User currentUser;
   /**
    * Constructor
    */   
   public SetupPerformanceMetricsComm(ApexPages.StandardController controller) {
      //Initializing lists
      customerSatisfactionList = new List<Metric_Tier_Relation__c>();  
      trainingList = new List<Metric_Tier_Relation__c>(); 
      performanceToBPList = new List<Metric_Tier_Relation__c>();      
      accOptionList = new List<selectOption>(); 
      rsmList = new List<MetricsDetails>();
      
      if(userprofile.Name.equals('System Administrator')||userprofile.Name.equals('Systemadministrator')||userprofile.Name.equals('Amministratore del sistema')){
        ProfileNameSys = userprofile.Name;   
      }
      
      currentUser = [Select u.Country_Domain__c From User u where Id=:UserInfo.getUserId()];
      
      //Getting performance metric id from URL parameter
      performanceMetricId = ApexPages.currentPage().getParameters().get('id');
      //Validation for performanceMetricId(It is required parameter in the URL)
      if(performanceMetricId == null || performanceMetricId == ''){   
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Performance Metric id is required parameter in URL.'));
        return;
      }
      
      //Querying Metric_tier_relationship__c records for a Performance_Metric__c
      performanceMetric = [Select Channel__c,Thea__c,Country__c,Performance_Period_Start_Date__c,
                          Performance_period_End_date__c,Metric_Setup_Cut_off_Date__c,Open_Edit_date__c,
                          (Select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, 
                              CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ConnectionReceivedId, 
                              ConnectionSentId, Benefit_Tier__c, Boolean_Metric_Y_N__c, Category__c, Child_Metric__c, 
                              Enter_Tier__c, HelpText__c, Incentive_Amount__c, Manual_Partner__c, Market_Add_Row__c,
                              Metric_Description__c, Metric_Input_Type__c, Metric_Label__c, Metric_Max_Value__c,
                              Metric_Min_Value__c, ParentMetricRelation__c, Part_Of_Composite_Incentive__c, Performance_Metric__c, 
                              Sequence_Order__c, Stay_Tier__c, Tier__c, isRSMView__c, Thershold__c, Accept_Attachment__c 
                              From Metric_Tier_Relations__r where isRSMView__c =: false) 
                          From Performance_Metric__c p where Id=:performanceMetricId];
      
      openEditDate = performanceMetric.Open_Edit_date__c;
      validFrom = getDateFormat(performanceMetric.Performance_Period_Start_Date__c);
      validTo = getDateFormat(performanceMetric.Performance_period_End_date__c);
      cutOffDate = getDateFormat(performanceMetric.Metric_Setup_Cut_off_Date__c);
      theater = performanceMetric.Thea__c; 
      country = performanceMetric.Country__c;
      expDate = performanceMetric.Metric_Setup_Cut_off_Date__c;
      periodEndDate = performanceMetric.Performance_period_End_date__c;
      
      //Arranging metric tier relationships according to categories           
      for(Metric_Tier_Relation__c mtr : performanceMetric.Metric_Tier_Relations__r){
        if(mtr.Category__c.toLowerCase() == CUSTOMER_SATISFACTION){
            customerSatisfactionList.add(mtr);
        }else if(mtr.Category__c.toLowerCase() == TRAINING){
            trainingList.add(mtr);
        }else if(mtr.Category__c.toLowerCase() == PERFORMANCE_TO_BP){
            performanceToBPList.add(mtr);
        }
     }
     
     //Querying PDF Limit record
     //if it exists then using that one otherwise creating new one.
     List<PDF_Limit__c> pdfList = [select Partner__c from PDF_Limit__c where Performance_Metric__c=:performanceMetricId limit 1];
     if(pdfList.size() > 0){
        pdfObject = pdfList.get(0);       
     }else{
        pdfObject = new PDF_Limit__c();
        pdfObject.Performance_Metric__c = performanceMetricId;
     }
     
     //Filling account optoin list                   
     accOptionList = createAccountPicklist();
     //Populating RSM objectives
     showRSMView();      
   }
   
   /**
    * function to add a row in marketing metric list.
    */
   public void addMarketingRow(){
    /*
        Metric_Tier_Relation__c tempRow = new Metric_Tier_Relation__c();
        tempRow.Metric_Description__c = '';
        tempRow.Performance_Metric__c = performanceMetricId;
        tempRow.Market_Add_Row__c = true;
        tempRow.Metric_Label__c = 'SunPower Dealer Webpage and Logo Usage';
        tempRow.Category__c = 'Marketing';
        tempRow.Metric_Input_Type__c = 'Manual';
        tempRow.CurrencyIsoCode = 'USD';
        marketingList.add(tempRow);
        */
   }
   
   /**
    * getter method for FreezeMetric.
    * @return Boolean
    */
   public Boolean getFreezeMetric(){
    /*
    if(!userprofile.Name.equals(ProfileNameSys)
        && !userrole.Name.equals('Business Development Manager')
        && !userrole.Name.equals('Channel Manager')){
        return true;
    }
    return false;
    */
    CVAR_Country_Domains__c cvarDomain = CVAR_Country_Domains__c.getOrgDefaults();
    CVAR_Roles__c cvarRole = CVAR_Roles__c.getOrgDefaults();

    if(userprofile.Name.equals(ProfileNameSys) ||  
       (userrole.Name.equals(cvarRole.CM__c) && 
         (currentUser.Country_Domain__c.equalsIgnoreCase(cvarDomain.CVAR_US__c) 
           || currentUser.Country_Domain__c.equalsIgnoreCase(cvarDomain.COMBO_US__c)
          )
        )
      ){
        return false;
      }else{
        return true;
      }
   }
    
    /**
     * getter method for MarketAddRow.
     * @return Boolean
     */
    public Boolean getMarketAddRow(){
        if(userprofile.Name.equals(ProfileNameSys)){
            return true;
        }
        else{
            return false;
        }
    }
    
    /**
     * getter method for FreezeRSMMetric.
     * @return Boolean
     */
    public Boolean getFreezeRSMMetric(){
       /*
       if(Date.Today()>periodEndDate){
            return true;
       }else{
            return false;
       } */
       /* Done for the case # 00049203 on 4Feb2011 */
       if(!PerformanceEvalCst.exemptedUsersSet.contains(UserName)){   
           if(openEditDate != null && Date.Today() > openEditDate){
            System.debug('**************************FreezeRSMMetric = true');
            return true;
           }else{
            System.debug('**************************FreezeRSMMetric = false');
            return false;
           }
       }else{
           return false;
       }
       
    }
    
    /**
     * Action function for save objects.
     * @return PageReference
     */
    public PageReference saveObj() {
        //First save/update PDF limit object
        saveOrUpdatePDF();
        saveRSMRows();
        //Creating a list all all category Metric_Tier_Relation__c and upserting that
        List<Metric_Tier_Relation__c> listToBeUpserted = new List<Metric_Tier_Relation__c>();
        if(customerSatisfactionList != null && customerSatisfactionList.size() > 0)
            listToBeUpserted.addAll(customerSatisfactionList);
        if(trainingList != null && trainingList.size() > 0)
            listToBeUpserted.addAll(trainingList);
        if(performanceToBPList != null && performanceToBPList.size() > 0)
            listToBeUpserted.addAll(performanceToBPList);
        
        if(listToBeUpserted.size() > 0){
            try{
                upsert listToBeUpserted;
            }catch(Exception ex){
                System.debug('****Exception in updating records****'+ex);
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Exception in updating'+ex));
            }
        }
        return null;
    }
    
    /**
     * Action function for save marketing objects.
     * @return PageReference
     */
    public PageReference saveMarketingObj() {
        /*
        if(marketingList != null && marketingList.size() > 0){
            try{
                upsert marketingList;
            }catch(Exception ex){
                System.debug('****Exception in saveMarketingObj updating records****'+ex);
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Exception in updating'+ex));
            }
        }*/
        return null;
    }       
    
    /**
     * Action function to get RSM Objectives metrics.
     * @return PageReference
     */
    public PageReference showRSMView(){   
        //Showing RSM Objectives    
        //If the selected account is null, then by default show for first account in the
        //list of accounts picklist(as in case of page load) 
        if(accountSelected == null){
            if(accOptionList != null && accOptionList.size() > 0)
                accountSelected = accOptionList.get(0).getValue();
        }
        
        if(accountSelected != null && accountSelected != '') {
            this.rsmList.clear();
            MetricsDetails mtrDetail;
            //Querying Metric_Tier_Relation__c and related metrics for the account selected
            for(Metric_Tier_Relation__c mtr : [select Metric_Description__c,Metric_Label__c,Category__c,
                                                Metric_Min_Value__c,Metric_Max_Value__c,Incentive_Amount__c,
                                                Boolean_Metric_Y_N__c,Metric_Input_Type__c,HelpText__c,
                                                Enter_Tier__c,Stay_Tier__c,Benefit_Tier__c,
                                                (select Metric_Description__c,Incentive_Amount__c,Stay_Tier__c,
                                                    Benefit_Tier__c,Enter_Tier__c,Boolean_Metric_Y_N__c,Metric_Min_Value__c,
                                                    Metric_Max_Value__c,Metric_Input_Type__c from  Metrics__r where account__c =:accountSelected) 
                                                 from Metric_Tier_Relation__c where  Performance_Metric__c=:performanceMetricId 
                                                 and isRSMView__c=:true ORDER by Sequence_Order__c]){
                mtrDetail = new MetricsDetails();
                mtrDetail.meetricTierRel = mtr;
                if(mtr.Metrics__r != null && mtr.Metrics__r.size() > 0){                                    
                    mtrDetail.metric = mtr.Metrics__r.get(0);   
                }else{
                    Metric__c met = new Metric__c();
                    met.Account__c = accountSelected;
                    met.Metric_Tier_Relation__c = mtr.Id;
                    met.Performance_Metric__c = performanceMetricId;
                    met.Metric_Description__c = mtr.metric_label__c;
                    met.Boolean_Metric_Y_N__c = true;
                    met.Metric_Min_Value__c = null;
                    met.Metric_Max_Value__c = null;
                    met.Metric_Input_Type__c = 'Manual';
                    met.Enter_Tier__c = false;
                    met.Benefit_Tier__c = false;
                    met.Stay_Tier__c = false;
                    met.Incentive_Amount__c = null;
                    mtrDetail.metric = met;
                }
                rsmList.add(mtrDetail);                 
            }
        }       
        return null;   
    }
    
    String nextTier1 ='';
    
    /**
     * Action function to save RSM rows.
     */
    public PageReference saveRSMRows(){      
        //upserting RMS objectives  
        List<Metric__c> listMetric = new List<Metric__c>();
        List<Metric_Tier_Relation__c> listTierRelations = new List<Metric_Tier_Relation__c>();
        for(MetricsDetails mDetail : rsmList){
            listMetric.add(mDetail.metric);
            if(mDetail.meetricTierRel != null)
                listTierRelations.add(mDetail.meetricTierRel);
        }
        
        try{
        if(listMetric.size() > 0){
            upsert listMetric;
        }
        if(listTierRelations.size() > 0){
            //upsert listTierRelations;
        }
        }catch(Exception ex){
            System.debug('****Exception in saveRSMRows updating records****'+ex);
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Exception in updating:'+ex));
        }
        return null;
    }
    
    /**
     * Action function to update RSM rows.
     */
    public void updateRSMRows(){
       
    }
    
    /**
     * getter function to ShowAccountView.
     * return Boolean
     */
    public Boolean getShowAccountView(){       
        /* Done for the case # 00050543 on 19Feb2011 */
        //if(userrole.Name.equals('Regional Sales Manager')
        //    || userprofile.Name.equals(ProfileNameSys) ||userrole.Name.equals('Area Sales Manager')||userrole.Name.equals('National Sales Director')||userrole.Name.equals('Director of Sales')||userrole.Name.equals('Channel Manager')||userrole.Name.equals('Business Development Manager') ){            
        if(userrole.Name.contains('Regional Sales Manager')
            || userprofile.Name.equals(ProfileNameSys) ||userrole.Name.contains('Area Sales Manager')||userrole.Name.contains('National Sales Director')||userrole.Name.equals('Director of Sales')||userrole.Name.equals('Channel Manager')||userrole.Name.equals('Business Development Manager') ){            

            return true;
        }else{
            return false;
        }       
    }
    
    /**
     * Utility function to date formatting.
     * return String
     */
    public String getDateFormat(Date myDT){
        String ddttmm =null;
        if(myDT!=null)
        {
            Datetime myDate = Datetime.newInstance(myDT.year(),myDT.month(),myDT.day(),0,0,0);
            ddttmm =myDate.format('MM/dd/yyyy');
        }
        return ddttmm;    
    }
    
    /**
     * getter function for PerformanceMetric.
     * return Performance_Metric__c
     */
    public Performance_Metric__c getPerformanceMetric(){
        return performanceMetric;
    } 
    
    /**
     * function to create accounts picklist.
     * @return List<SelectOption>
     */
    private List<SelectOption> createAccountPicklist(){       
        List<Account> accountList = new List<Account>();     
        Set<String> domains = new Set<String>();
        Set<String> accountTypes = new Set<String>{'Partner-Commercial', 'Authorized-Partner-Combo', 'Premier-Partner-Combo', 'Partner', 'VAR', 'Elite-Partner-Combo'};
        
        if(country.equals('USA')){
           domains.add('cvar-us'); 
           domains.add('combo-us');
        }

        /* Done for case # 00050543 on 19Feb2011 */
        //if(userrole.Name.equals('Regional Sales Manager')){          
        if(userrole.Name.contains('Regional Sales Manager')){          
            accountList = [SELECT name, Type, Id, RSM__c from Account where Country_Domain__c IN: domains and ( RSM__c=:userId OR CRSM__c=:userId ) and Status__c ='Active' and type in : accountTypes  ORDER BY name ];         
        }else{          
            accountList = [SELECT name, Type, Id from Account where Country_Domain__c IN: domains and Status__c ='Active' and type in : accountTypes ORDER BY name ];                
        }
        
        List<SelectOption> optionList = new List<SelectOption>();      
        for(Account acc: accountList){
            optionList.add(new SelectOption(acc.Id,acc.name));
        }
        return optionList;
    }
       
   /** Define a inner class to hold the inforamtions required for the
    *  performance evaluation of the Account 
    */
   public class MetricsDetails{
        Metric_Tier_Relation__c meetricTierRel;
        Metric__c metric;
        
        public Metric_Tier_Relation__c getmeetricTierRel(){
            return this.meetricTierRel;
        }        
        public Metric__c getMetric(){          
            return this.metric;
        }      
        public void setmeetricTierRel(Metric_Tier_Relation__c mt){
            this.meetricTierRel = mt;
        }
        public void setMetric(Metric__c m){
            this.metric = m;
            this.metric.Boolean_Metric_Y_N__c = true;
            this.metric.Metric_Input_Type__c = 'Manual';
        }    
        public MetricsDetails(){
            meetricTierRel = new Metric_Tier_Relation__c();
            metric = new Metric__c();
        }
    }  
    
    /**
     * Function to save/update PDF(partner development fund).
     */  
    public void saveOrUpdatePDF(){
        try{                
            upsert pdfObject;
        }catch(Exception ex){
            System.debug('****Exception in saveOrUpdatePDF ****'+ex);
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Exception in updating:'+ex));
        }
    }
    
    /**
     * Action function to navigate to Evaluate page.
     * @return PageReference
     */
    public PageReference goToperformanceEvalPage(){
        if(this.accountSelected != null){
            Account accSelected = [Select Type from Account where Id=:this.accountSelected];
            if(accSelected.Type != null && PerformanceEvalCst.PARTNER_TYPE_COMBO.contains(accSelected.Type)){
                return new PageReference('/apex/PerformanceEvalPageCombo?accid='+this.accountSelected);
            }else{
                return new PageReference('/apex/PerformanceEvalPageComm?accId='+this.accountSelected);
            }     
        }else{
            return null;
        }
    }
    
    /**
     * Getter function to check whether Benefit tier/Required Checkboxes in RSM Objective Tab
     * will be editable or not(Only Channel Manager and System admins are allowed).
     * @return Boolean
     */
    public Boolean getIsAllowedChkFields(){
        CVAR_Roles__c cvarRole = CVAR_Roles__c.getOrgDefaults();
        if(userrole.Name.equals(cvarRole.CM__c) || userprofile.Name.equals(ProfileNameSys)){                       
            return true;
        }else{
            return false;
        }      
    } 
    
    public Boolean getPermittedForRSMTab(){
        CVAR_Roles__c cvarRole = CVAR_Roles__c.getOrgDefaults();
        /* Done for the case # 00049203 on 4Feb2011 */
        if( (userrole.Name.equals(cvarRole.CM__c) || userrole.Name.equals(cvarRole.RSM__c) || userprofile.Name.equals(ProfileNameSys)) ||
                     (PerformanceEvalCst.exemptedUsersSet.contains(UserName)) ){                       
            return true;
        }else{
            return false;
        } 
    }
    
    public Boolean getPermittedForOthers(){
        CVAR_Roles__c cvarRole = CVAR_Roles__c.getOrgDefaults();
        if(userrole.Name.equals(cvarRole.CM__c) || userprofile.Name.equals(ProfileNameSys)){                       
            return true;
        }else{
            return false;
        } 
    }   
}