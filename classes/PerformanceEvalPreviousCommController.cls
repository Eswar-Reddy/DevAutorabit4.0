// 
// (c) 2010 Appirio, Inc.
//
// Performance Evaluation of previous period for CVAR.
// 1/6/2011   Hemant Garg(Appirio offshore)   Original
//
public class PerformanceEvalPreviousCommController{ 
    public String period;
    public String year;
    public String previousType;
    public Date prevDate_2010 ;//= Date.newInstance(2010,12,31);
    Performance_Metric__c currentPM;
    public String accountId; // = ApexPages.currentPage().getParameters().get('accId');
    public String accountName,partnerType,partnerTier,validEvalFromDate,validEvalToDate,validExpToDate,paramStartDate;
    String paramEndDate,paramExpDate,performanceMetricID;
    Boolean disableButton,disableEditButton,partnerExecutive;
    public String country_full_name ='';
    Id trId;
    Boolean ShowLink;    
    public Date todayDate;
    final String  ACCOUNT_CHANNEL_NAME ='Commercial';
    Map<String,boolean> mapActiveDealerMetricAchievement = new Map<String,boolean>();
    //3 lists to show on the page
    public List<MetricsDetails> customer_Satisfaction_Current = new List<MetricsDetails>() ;
    public List<MetricsDetails> performance_to_business_Plan_Current = new List<MetricsDetails>();
    public List<MetricsDetails> training_Current = new List<MetricsDetails>();
    
    List<Metric_Tier_Relation__c> currentMetricList = new List<Metric_Tier_Relation__c>();    
    List<Metric_Tier_Relation__c> compositeTrainingCurrentList = new List<Metric_Tier_Relation__c>();   
    List<Metric_Tier_Relation__c> compositePerformBPCurrentList = new List<Metric_Tier_Relation__c>();  
   
    Boolean hideHeaderForPartner;
    Boolean showNextTab;
    String StartDate;
    Boolean isExecutiveManager=false;
    String accTheatre;
    String clkSave = 'abc';    
    String UserId= userInfo.getuserId();
    String UserName= userInfo.getName();
    
    //Case#00064832 start
    Static UserRole userrole = [select name from UserRole where id=: UserInfo.getUserRoleId()];
    Static Profile userprofile = [select name from Profile where id=: UserInfo.getProfileId()];
    //Case#00064832 end
    public Boolean isPartnerCombo{get;set;}
    public ID expandID {get;set;}
    public boolean isSchedular{get;set;}
    /**
     * getter function to check whether currently logged-in user is a portal user.
     * @return Boolean
     */
    public Boolean getIsPortalUser(){  
        List<user> listUser = [select id, contactId from User where Id=:userInfo.getuserId()];
        if(listUser != null && listUser.size() > 0){
            if(listUser.get(0).ContactId == null){
                return false;
            }else{
                return true;
            }
        }
        return false;
    }
    
    /**
     * getter function to check whether user profile is Partner-Executive.
     * @return Boolean
     */
    public Boolean getPartnerExecutive(){
       if(PerformanceEvalCst.profilePartnerExecutive.contains(userprofile.Name)){
           return true;
       }else{
           return false;
       } 
    }
    
    /**
     * hiding Header for combo-patners and partners.
     * @return Boolean
     */
    public Boolean getHideHeaderForPartner(){
       if(PerformanceEvalCst.profileHideHeaderForPartner.contains(userprofile.Name) || isPartnerCombo){
           return false;
       }else{
           return true;
       }
    }
    
    /**
     * getter function.
     * @return Boolean
     */
    public Boolean getDisableEditButton(){
        /*
        if(PerformanceEvalCst.profileDisableEditButton.contains(userprofile.Name)){
            return false;
        }else{
            return true;
        }*/
        /*changed by hemant : role-based access */
        if(PerformanceEvalCst.roleEditButton.contains(userrole.Name) || userprofile.Name == 'System Administrator'){
            return true;
        }else{
            return false;
        }        
    }
    public Boolean getDisableButton(){
        return this.disableButton;
    }
    public void setDisableButton(Boolean b){
        this.disableButton = b;
    }
    public String getperformanceMetricID(){
        return this.performanceMetricID;
    }
    public String getparamStartDate(){
        return this.paramStartDate;
    }
    public String getparamEndDate(){
        return this.paramEndDate;
    }
    public String getparamExpDate(){
        return this.paramExpDate;
    }
    
    public String getaccountId(){
        return this.accountId ;
    }
    public String getvalidExpToDate(){
        return this.validExpToDate;
    }
    public List<MetricsDetails>  getcustomer_Satisfaction_Current(){
        return this.customer_Satisfaction_Current;
    }
    public List<MetricsDetails>  getperformance_to_business_Plan_Current(){
        return this.performance_to_business_Plan_Current;
    }
    public List<MetricsDetails>  gettraining_Current(){
        return this.training_Current;
    }
    public String getpartnerTier(){
        return this.partnerTier;
    }
    public String getAccountName(){
        return this.accountName;
    }
    public String getPartnerType(){
        return this.partnerType;
    }
    public String getValidEvalFromDate(){
        return this.validEvalFromDate;
    }
    public String getValidEvalToDate(){
        return this.validEvalToDate;
    }
   
    public Boolean getShowNextTab()
    {        
        return false;
    }
    
    public String getTierStartDate(){
        return StartDate;    
    }
    
    /**
     * Constructor
     * @param ApexPages.StandardController
     */
    public PerformanceEvalPreviousCommController(ApexPages.StandardController controller){    
        isSchedular = false;  
        if(ApexPages.currentPage().getParameters().get('accId') != null && ApexPages.currentPage().getParameters().get('accId') != ''){
            accountId = ApexPages.currentPage().getParameters().get('accId');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Account ID is required.'));
            return ;
        }
        
        if(ApexPages.currentPage().getParameters().get('period') != null && ApexPages.currentPage().getParameters().get('period') != '' ){
            period = 'P' + ApexPages.currentPage().getParameters().get('period');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Performance Period is required.'));
            return ;
        }
        
        if(ApexPages.currentPage().getParameters().get('year') != null && ApexPages.currentPage().getParameters().get('year') != ''){
            year = ApexPages.currentPage().getParameters().get('year');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Performance Year is required.'));
            return ;
        }
        this.disableButton= true;
        this.isPartnerCombo = false;
        this.retriveAccountInfo();
    }
    
    /**
     * Default Constructor
     */
    public PerformanceEvalPreviousCommController(){
        isSchedular = false;     
        if(ApexPages.currentPage().getParameters().get('accId') != null && ApexPages.currentPage().getParameters().get('accId') != ''){
            accountId = ApexPages.currentPage().getParameters().get('accId');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Account ID is required.'));
            return ;
        }
        
        if(ApexPages.currentPage().getParameters().get('period') != null && ApexPages.currentPage().getParameters().get('period') != '' ){
            period = 'P' + ApexPages.currentPage().getParameters().get('period');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Performance Period is required.'));
            return ;
        }
        
        if(ApexPages.currentPage().getParameters().get('year') != null && ApexPages.currentPage().getParameters().get('year') != ''){
            year = ApexPages.currentPage().getParameters().get('year');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Performance Year is required.'));
            return ;
        }
        this.disableButton= true;
        this.retriveAccountInfo();
    }
    public PerformanceEvalPreviousCommController(String accId){
        isSchedular = false;
        //PerformanceEvalPreviousCommController(accId,'2','2010');
    }
    /**
     * Constructor
     * @param accId
     */
     //APEX SCHEDULAR
   public PerformanceEvalPreviousCommController(String accId,String PrevPeriod,String PrevYear){
        isSchedular = true;     
        if(accId!=null && PrevPeriod!=null && PrevYear!=null ){
            accountId = accId;
            period = 'P' + PrevPeriod;
            year = PrevYear;
            this.disableButton= true;
            this.retriveAccountInfo();
            updateMetricRecords();
        }
    }
    
   public Boolean getisExecutiveManager(){
        return isExecutiveManager;
   }
  
   public String getAccTheatre(){
           return accTheatre;
   }
  
   /**
    * Function to Retrieve the account,performance metric and the current 
    * Metric Tier Relation info.
    */
   public void retriveAccountInfo(){ 
     
       if(this.accountId != null){
           Account acc = [Select a.name , a.type,a.Country_Domain__c,a.Theater__c from Account a where id =: this.accountId];
           if(acc != null){
               this.accountName = acc.Name;
               if(acc.Type != null && PerformanceEvalCst.PARTNER_TYPE_COMBO.contains(acc.Type)){
                   isPartnerCombo = true;
               }else{
                   isPartnerCombo = false;
               }
               if(acc.Type != null && acc.Type.contains('-')){
                   this.partnerTier = acc.Type.subString(0,acc.Type.indexOf('-'));
                   this.partnerType = acc.Type.subString(acc.Type.indexOf('-')+1,acc.Type.length());
               }             
               
               String accCountryDomain = acc.Country_Domain__c;
               accTheatre = acc.Theater__c;
               /* Done for the case # 00051450 */
               if(PerformanceEvalCst.usTheatersMap.containsKey(accTheatre)){
                   accTheatre = PerformanceEvalCst.usTheatersMap.get(accTheatre);
               }
              
               if(accCountryDomain != null ){
                   if(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('us')){
                       /* Done for the case # 00053854 */
                       //if(accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('cvar') || accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('combo')){
                           accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                       //}
                   }
                   else if((accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('it'))||(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('de'))){
                       accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                   }
                   
                   country_full_name = PerformanceEvalCst.countryMap.get(accCountryDomain);
                  
               }
               //Date tdat = Date.Today();
              
               List<Performance_Metric__c> performancelst = new List<Performance_Metric__c>();
               if( accCountryDomain != null && accCountryDomain.equals('us')){
                  performancelst = [select open_edit_date__c,calculation_End_Date__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and Performance_Year__c=:Integer.valueOf(year) and  Performance_Period__c=:period ];
                
                  if(performancelst.size()== 0){
                      performancelst = [select open_edit_date__c,calculation_End_Date__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  order by createdDate asc limit 1 ];
                  }                  
               }
               else if(accCountryDomain != null && ( accCountryDomain.equals('it')||accCountryDomain.equals('de') )){
                  performancelst = [select open_edit_date__c,calculation_End_Date__c,User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and Performance_Year__c=:Integer.valueOf(year) and  Performance_Period__c=:period ];
                  if(performancelst.size()==0){
                    performancelst = [select open_edit_date__c,calculation_End_Date__c,User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name)  order by createdDate asc limit 1 ];
                  }
               }
               if(performancelst != null && performancelst.size() > 0 ){
                   validEvalFromDate = ''+ getDateFormat(performancelst.get(0).Performance_Period_Start_Date__c);
                   validEvalToDate = ''+ getDateFormat(performancelst.get(0).Performance_Period_End_Date__c);
                   validExpToDate = ''+  getDateFormat(performancelst.get(0).Performance_Evaluation_Cut_off_Date__c);
                   this.paramStartDate = ''+performancelst.get(0).Performance_Period_Start_Date__c;
                   this.paramEndDate = ''+performancelst.get(0).Performance_Period_End_Date__c;
                   this.paramExpDate = ''+performancelst.get(0).Performance_Evaluation_Cut_off_Date__c;
                   //userrole.Name
                   if(performancelst.get(0).User_To_Override__c!=null && UserId.equals(performancelst.get(0).User_To_Override__c))
                   {
                       isExecutiveManager=true;
                   }
                   /*added*/
                   currentPM = performancelst.get(0);
               }
               if(currentPM == null)
                return ;
               
               if(performancelst == null || performancelst.size() == 0){
                if(isSchedular)
                    return;
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Performance Metric  does not exists for this country, period, account type and tier combination.'));
                return ;
               }
               if(performancelst.get(0).Performance_Period_Start_Date__c == null || performancelst.get(0).Performance_Period_End_Date__c == null){
                    if(isSchedular)
                        return;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Start date or End date of performance period is null.'));
                    return;
               }
                /*Querying previous account type from AccountHistory records:Hemant */
               prevDate_2010 = performancelst.get(0).calculation_End_Date__c;
               if(prevDate_2010 != null){
                PerformanceAchievementClass.updatePrevEvalDate(prevDate_2010);
                PerformanceAchievementComm.updatePrevEvalDate(prevDate_2010); 
               } 
               DateTime dtStart = DateTime.newInstance(performancelst.get(0).Performance_Period_Start_Date__c.year(), performancelst.get(0).Performance_Period_Start_Date__c.month(),performancelst.get(0).Performance_Period_Start_Date__c.day());
               DateTime dtEnd = DateTime.newInstance(performancelst.get(0).Performance_Period_End_Date__c.year(), performancelst.get(0).Performance_Period_End_Date__c.month(),performancelst.get(0).Performance_Period_End_Date__c.day());
               previousType = PerformanceEvalCst.findPreviousType(accountId, dtStart, dtEnd);
               System.debug('========previousType==========='+previousType);
               if(previousType != null && previousType.contains('-')){
                   this.partnerTier = previousType.subString(0,previousType.indexOf('-'));
                   this.partnerType = previousType.subString(previousType.indexOf('-')+1,previousType.length());
               }
               else if(previousType != null && previousType.equals('Residential Installer')){
                   this.partnerTier = 'SRI';
                   this.partnerType = previousType;
               }
               if(previousType != null && PerformanceEvalCst.PARTNER_TYPE_COMBO.contains(previousType)){
                   isPartnerCombo = true;
               }
               
               if(performancelst != null && performancelst.size() > 0 )
                   currentMetricList = [select isRSMView__c, ParentMetricRelation__c, Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Performance_Metric__c=:performancelst.get(0).Id and Stay_Tier__c=: true and isRSMView__c =: false  ORDER by Sequence_Order__c];//Shishir: removed and isRSMView__c =: false condition REMOVED  OR Benefit_Tier__c=: true)
               
               if(currentMetricList != null && currentMetricList.size() > 0){
                   this.performanceMetricID=performancelst.get(0).Id;
                   // populate metric for each category.
                   this.populateCategoriesForTiers(currentMetricList,performancelst.get(0).Id,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Performance_Period_Start_Date__c,performancelst.get(0).Performance_Period_End_Date__c);                  
                    /*not needed(not sure)*/
                   /*
                   //Show Training data in Composite way
                   addCompositeMetricForTrn(compositeTrainingCurrentList,training_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id);                                          
                   */
               }              
           }
       }
   }
   
   /**
    * Function to populate metric to each category of a tier.
    * @param tierList
    * @param performanceId
    * @param expDate
    * @param startDate
    * @param endDate
    */
   public void populateCategoriesForTiers(List<Metric_Tier_Relation__c> tierList,Id performanceId,Date expDate,Date startDate,Date endDate ){    
       if(tierList!= null){       
           this.customer_Satisfaction_Current.clear();
           this.training_Current.clear();
           this.performance_to_business_Plan_Current.clear();                 
           this.compositeTrainingCurrentList.clear();
           
           //Case-00050804
           Map<ID, List<MetricsDetails>> mapParentChildMTR = new Map<ID, List<MetricsDetails>>();
               
           for(Metric_Tier_Relation__c mtr : tierList){                      
               MetricsDetails m = new MetricsDetails();
                              
               if(mtr.Category__c != null && mtr.Category__c.equals('Customer Satisfaction') ){                         
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                   //filter mlst by Account Id
                   if(mlst != null && mlst.size() > 0  ){
                       m.metric = mlst.get(0);                          
                       if(mtr.Metric_Input_Type__c.equals('Automated')){                                
                           if(expDate > Date.Today() && m.metric.Overriden__c==false){                              
                               automatedCSATMetric(m.metric,mtr,startDate,endDate);                               
                           }
                       }else{
                        //code for manual
                       }
                   }else{
                       Metric__c met = new Metric__c();
                       met.Account__c = this.accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       if(mtr.Metric_Input_Type__c.equals('Automated')){                          
                           automatedCSATMetric(met,mtr,startDate,endDate);                           
                       }else{
                           met.Boolean_Achievement__c = false;
                           met.Goal_Met__c=false; 
                       }
                       m.metric = met;                       
                   }
                       
                   this.customer_Satisfaction_Current.add(m);
                        
               }else if(mtr.Category__c != null && mtr.Category__c.equals('Training')){
                       
                       if(mtr.Part_Of_Composite_Incentive__c){                          
                           this.compositeTrainingCurrentList.add(mtr);                              
                       }else{
                           m.meetricTierRel = mtr;
                           List<Metric__c> mlst = mtr.Metrics__r;
                           if(mlst != null && mlst.size() > 0  ){
                               m.metric = mlst.get(0);
                               if(mtr.Metric_Input_Type__c.equals('Automated')){
                                   if(expDate > Date.Today() && m.metric.Overriden__c==false){
                                       automatedTrainingMetric(m.metric,mtr,startDate,endDate);
                                   }
                               }else{
                                    //manual
                               }
                            }else{
                                    Metric__c met = new Metric__c();
                                    met.Account__c = this.accountId;
                                    met.Metric_Tier_Relation__c = mtr.Id;
                                    met.Performance_Metric__c = performanceId;
                                    if(mtr.Metric_Input_Type__c.equals('Automated')){
                                        automatedTrainingMetric(met,mtr,startDate,endDate);
                                    }else{
                                        met.Boolean_Achievement__c = false;
                                        met.Goal_Met__c=false; 
                                    }
                                    m.metric = met;  
                             }                     
                             this.training_Current.add(m);                           
                         }                       
                   }else if( mtr.Category__c != null && mtr.Category__c.equals('Performance to Business Plan')){
                       if(mtr.Part_Of_Composite_Incentive__c){                        
                           this.compositePerformBPCurrentList.add(mtr);                             
                       }else{   
                           m.meetricTierRel = mtr;
                           List<Metric__c> mlst = mtr.Metrics__r;
                           if(mlst != null && mlst.size() > 0  ){
                               m.metric = mlst.get(0);
                               if(mtr.Metric_Input_Type__c.equals('Automated')){
                                  if(expDate > Date.Today() && m.metric.Overriden__c==false){ 
                                    automatedPbpMetric(m.metric,mtr,startDate,endDate);
                                  }
                                }else{
                                    //For Manual but not required as data will come DB
                                }
                            }else{
                                Metric__c met = new Metric__c();
                                met.Account__c = this.accountId;
                                met.Metric_Tier_Relation__c = mtr.Id;
                                met.Performance_Metric__c = performanceId;
                                if(mtr.Metric_Input_Type__c.equals('Automated')){
                                    automatedPbpMetric(met,mtr,startDate,endDate);
                                }else{
                                    //For Manual
                                    met.Boolean_Achievement__c = false;
                                    met.Goal_Met__c=false; 
                                }  
                                m.metric = met;
                            }  
                            //If condition put for case-00050804
                            if(!mtr.Child_Metric__c){                             
                                this.performance_to_business_Plan_Current.add(m);  
                            }                                                                        
                         } 
                   } 
                   //Case-00050804
                   //Prepare parent child map
                   if(mtr.Child_Metric__c){
                        if(mapParentChildMTR.containsKey(mtr.ParentMetricRelation__c)){
                            mapParentChildMTR.get(mtr.ParentMetricRelation__c).add(m);
                        }
                        else{
                            List<MetricsDetails> lst = new List<MetricsDetails>();
                            lst.Add(m);
                            mapParentChildMTR.put(mtr.ParentMetricRelation__c,lst);
                        }
                   }                                             
           }
           
           //Case-00050804
           //Currently done for performance to business paln metrics
           for(MetricsDetails md : this.performance_to_business_Plan_Current){
                if(mapParentChildMTR.containsKey(md.meetricTierRel.ID)){
                    md.listChildren = mapParentChildMTR.get(md.meetricTierRel.ID);                      
                }
           }
       }
   }
   
   //Case-00050804
   public void expandChildren(){
       for(MetricsDetails md : this.performance_to_business_Plan_Current){
            if(md.meetricTierRel.ID == expandID){
                md.expand= true;                      
            }
       }
   }
   
   /**
    * Calculation for Performance to Bussiness plan Automated metric.
    * @param Metric__c
    * @param Metric_Tier_Relation__c
    * @param startDate
    * @param endDate
    */
   public void automatedPbpMetric(Metric__c m, Metric_Tier_Relation__c mtr, Date startDate, Date endDate){      
        //C-19 Must be an Active Dealer   
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR)){
            System.debug('===in '+PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR);
            mapActiveDealerMetricAchievement = PerformanceAchievementComm.mustBeAnActiveDealer(accountId, startDate, endDate);
            Boolean achievement=false;
            if(mapActiveDealerMetricAchievement.size()>0){
                achievement=true;
            }            
            PerformanceAchievementComm.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        else if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR_50KW) && mapActiveDealerMetricAchievement.containsKey(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR_50KW)){
            PerformanceAchievementComm.automatedBooleanGoalCheck(m,mtr,true);
        }
        else if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR_2SYSTEM) && mapActiveDealerMetricAchievement.containsKey(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR_2SYSTEM)){
            PerformanceAchievementComm.automatedBooleanGoalCheck(m,mtr,true);
        }
        //C-26 SunPower Share of Account (PV purchases in kW) 
        //commented because it is manual metric, calculation is not needed  
        /*if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR)){
            Double sunpowerShare = PerformanceAchievementComm.calculatePVPurchasesInKw(accountId, startDate, endDate);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, sunpowerShare);
        }*/
                
        //C-24- Credit Limit Maintained 
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PBP_CREDIT_LINE_MAINTAINED_CVAR)){
            Boolean isMaintained = PerformanceAchievementComm.isCreditLineMaintained(accountId, startDate, endDate);
            PerformanceAchievementComm.automatedBooleanGoalCheck(m, mtr, isMaintained);
        }
        //TODO: 2 other metrics are remaining(not clear)
        //C-25 SunPower and Dealer Growth Plan - semi-annual
        //C-29 Dealer Bonuses for meeting Business Objectives
        
        //C-5 SunPower Installations Registered at CRM
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.INSTALLATIONS_REGISTERED_CVAR)){
           System.debug('===============Entered in=========== '+mtr.Metric_Label__c);
           Double installations = PerformanceAchievementComm.calcInstallationsRegistered(accountId, startDate, endDate);               
           System.debug('===============installations=========== '+installations);
           PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, installations);
        }         
   }
   
   /**
    * Calculation for raining Automated metric.
    * @param Metric__c
    * @param Metric_Tier_Relation__c
    * @param startDate
    * @param endDate
    */
   public void automatedTrainingMetric(Metric__c m, Metric_Tier_Relation__c mtr, Date startDate, Date endDate){     
       //C-14.1 Training: Fundamentals of Commercial Design 
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_DESIGN_CVAR)){
           System.debug('====in automatedTrainingMetric===='+PerformanceEvalCst.TRAINING_ASS_DESIGN_CVAR);
           Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocDesign(accountId);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-15.1 Training: Fundamentals of Commercial Installation
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_INSTALL_CVAR)){
            Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocInstall(accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-16.1 Training: Fundamentals of Commercial Sales
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_SALES_CVAR)){
           Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocSales(accountId);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-14.2 Training: Associate Commercial Design Certification      
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_DESIGN_CERT_CVAR)){         
           Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocDesignCert(accountId);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-15.2 Training: Associate Commercial Installation Certification
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_INSTALL_CERT_CVAR)){
            Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocInstallCert(accountId);           
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-16.2 Training: Associate Commercial Sales Certification
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_SALES_CERT_CVAR)){
           Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocSalesCert(accountId);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
   } 
   
   /**
    * Calculation for Customer Satisfaction Automated Metric.
    * @param Metric__c
    * @param Metric_Tier_Relation__c
    * @param startDate
    * @param endDate
    */
   private void automatedCSATMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate){    
        System.debug('Enter here populateCategoriesForTiers:populateCategoriesForTiers 10:::'+mtr.Metric_Label__c);
        
        //C-1 Customer Satisfaction Score
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE_CVAR)){
            Double csatScore = PerformanceAchievementComm.computeCSATSCORE(this.accountId,startDate,endDate);
            System.debug('::::::::::::::::'+PerformanceEvalCst.CSAT_SCORE_CVAR+':::::::CSAT Score:::::::::::'+csatScore);  
            PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, csatScore); 
        }
        
        //C-3 Installation Inspections – Powerguard, T5 and T10 Systems
        //T5, T10 and Powerguard installation inspections Passed (90%)       
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.T5_T10_Power_CVAR)){
            Double installInspectScore = PerformanceAchievementComm.computeInspections(this.accountId,startDate,endDate);
            System.debug('::::::::::::::::'+PerformanceEvalCst.T5_T10_Power_CVAR+':::::::T5_T10_Power_CVAR:::::::::::'+installInspectScore);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, installInspectScore);
        }
        
        //C7 - Warranty Card Received
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.WARRANTY_CARDS_CVAR)){
            Double warrantyCards = PerformanceAchievementComm.calcWarrantyCards(accountId, startDate, endDate);
            System.debug('::::::::::::::::'+PerformanceEvalCst.WARRANTY_CARDS_CVAR+':::::::WARRANTY_CARDS_CVAR:::::::::::'+warrantyCards);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, warrantyCards);
        } 
         
        //C-5 SunPower Installations Registered at CRM
      /*  if(mtr.Metric_Label__c.equals(PerformanceEvalCst.INSTALLATIONS_REGISTERED_CVAR)){
            System.debug('===============Entered in=========== '+mtr.Metric_Label__c);
            Double installations = PerformanceAchievementComm.calcInstallationsRegistered(accountId, startDate, endDate);               
            System.debug('===============installations=========== '+installations);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, installations);
        }*/         
   }
   
   /**
    * Function to update Metric Evaluation.
    * @return PageReference
    */
   public PageReference updateEvaluation(){   
        //Metrics should not update if the Performance Metric period they are 
        //related to is not current (TODAY > Performance Period End Date).  
        /* Done for case # 00053853 */
        /* if(Date.Today() <= currentPM.Performance_period_End_date__c){
            updateMetricRecords();
        }*/
        updateMetricRecords();
        //call constructor function
       // this.retriveAccountInfo();
        clkSave = ApexPages.currentPage().getParameters().get('clksave');
        if(clksave == null){
            //UpdateOtherTiers(customer_Satisfaction_Current,customer_Satisfaction_Next);
            //UpdateOtherTiers(performance_to_business_Plan_Current,performance_to_business_Plan_Next);
            //UpdateOtherTiers(training_Current,training_Next);
            //UpdateOtherTiers(marketing_Current,marketing_Next);
            //UpdateOtherTiers(all_spwr_solutions_Current,all_spwr_solutions_Next);
            //updateCompositeMetricForMarket(marketing_Next);   
        }
        this.retriveAccountInfo();
        return null;
    }
    
    /**
     * Function to update metric records.
     * @return PageReference
     */
    public PageReference updateMetricRecords(){
        /* Done for the case # 00053853 */
        //Metrics should not update if the Performance Metric period they are 
        //related to is not current (TODAY > Performance Period End Date).
        if(currentPM == null)
            return null; 
        /* Done for the case # 00049203 on 3Feb2011 */
        this.disableButton = true;
        if(!PerformanceEvalCst.exemptedUsersSet.contains(UserName)){   
            if(currentPM.open_edit_date__c !=null){
                if(Date.Today() > currentPM.open_edit_date__c){
                    return null;
                }
            }
            else if(Date.Today() > currentPM.Performance_period_End_date__c){
                return null;
            }
        }
                 
        updateAchievement(customer_Satisfaction_Current);
        updateAchievement(performance_to_business_Plan_Current);
        updateAchievement(training_Current);       
        return null;
    }
    
    /**
     * Function to update metric records.
     * @param List<MetricsDetails>
     */
    private void updateAchievement(List<MetricsDetails> mdList)
    {
        Double achieve = 0;
        Double requiredLimit = 0;
        Id tierId ;
        if(mdList != null && mdList.size() > 0 && mdList.get(0).meetricTierRel != null && mdList.get(0).meetricTierRel.Tier__c != null )
        tierId = mdList.get(0).meetricTierRel.Tier__c;
        List<Metric__c> metricsNew=new List<Metric__c>();
        List<Metric__c> metricsUpdate=new List<Metric__c>();  
        for(MetricsDetails md: mdList)
        {
            if(md.meetricTierRel.Metric_Input_Type__c.equals('Manual'))
            {
                if(md.meetricTierRel.Boolean_Metric_Y_N__c==true)
                {
                    if(md.metric.Boolean_Achievement__c==true)
                    {
                        md.metric.Goal_Met__c=true;
                        
                    }    
                    else
                        md.metric.Goal_Met__c=false;         
                }
                else
                {
                    if(md.metric.Achievement_Value__c!=null)
                    {
                        if(md.meetricTierRel.Metric_Min_Value__c!=null)
                        {
                            Double min=md.meetricTierRel.Metric_Min_Value__c;
                            achieve=md.metric.Achievement_Value__c;
                            if(achieve>=min){
                                md.metric.Goal_Met__c=true;
                                
                            }
                            else{
                                md.metric.Goal_Met__c=false;  
                            }
                            requiredLimit  = min;
                        }
                        else if(md.meetricTierRel.Metric_Max_Value__c!=null)
                        {
                            Double max=md.meetricTierRel.Metric_Max_Value__c;
                            achieve=md.metric.Achievement_Value__c;
                            if(achieve<=max)
                            {
                                md.metric.Goal_Met__c=true;
                                
                            }    
                            else
                                md.metric.Goal_Met__c=false; 
                                
                             requiredLimit  = max;
                        }
                    }
                    else
                    {
                        md.metric.Goal_Met__c=false;
                    }
                }  
            }
             if(md.metric.Id!=null)
             {
                 //if user is executive manager & metric=automated && Override=true
                 if(md.meetricTierRel.Metric_Input_Type__c.equals('Automated') && isExecutiveManager)
                 {
                     //get Overriden value from database
                     Metric__c obj=[select Overriden__c,goal_met__c from metric__c where Id=:md.metric.Id];
                     if(md.metric.goal_met__c!=obj.goal_met__c)
                     {
                         md.metric.Overriden__c=(!obj.Overriden__c);
                         metricsUpdate.add(md.metric);
                     }
                 }
                 else
                 {
                     metricsUpdate.add(md.metric);
                 }    
             }
             else
             {
                 metricsNew.add(md.metric);
             }
        }
      
       if(metricsUpdate.size()>0)
       {
        update metricsUpdate;
       } 
       if(metricsNew.size()>0)
       insert metricsNew;
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
    
    //Inner Class 
    public class MetricsDetails{
        public Metric_Tier_Relation__c meetricTierRel;
        public Metric__c metric;
        public List<MetricsDetails> listChildren{get;set;}
        public Boolean expand{get;set;}
        
        public Metric_Tier_Relation__c getmeetricTierRel(){
            return this.meetricTierRel;
        }
        public Metric__c getMetric(){
            return this.metric;
        }
        public MetricsDetails(){
            listChildren = new List<MetricsDetails>();
            expand = false;
        }
    }
    public PageReference enableInputFields(){
        this.disableButton = false;
        return null;
    }
      
    public Boolean getShowLink(){
       if(PerformanceEvalCst.profileShowLink.contains(userprofile.Name)){
            return false;
        }else{
            return true;
        }
    }
    
}