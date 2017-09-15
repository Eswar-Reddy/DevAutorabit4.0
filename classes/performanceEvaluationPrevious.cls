public class performanceEvaluationPrevious {
	  
    public String accountId; // = ApexPages.currentPage().getParameters().get('accId');
    public String accountName,partnerType,partnerTier,validEvalFromDate,validEvalToDate,validExpToDate,paramStartDate;
    String paramEndDate,paramExpDate,performanceMetricID;
    Boolean disableButton,disableEditButton,partnerExecutive;
    public String country_full_name ='';
    Id trId;
    Boolean ShowLink;
    public Date todayDate;
    final String  ACCOUNT_CHANNEL_NAME ='Residential';
    public List<MetricsDetails> customer_Satisfaction_Current = new List<MetricsDetails>() ;
    public List<MetricsDetails> performance_to_business_Plan_Current = new List<MetricsDetails>();
    public List<MetricsDetails> training_Current = new List<MetricsDetails>();
    public List<MetricsDetails> training_Current_Clone = new List<MetricsDetails>();
    public List<MetricsDetails> marketing_Current = new List<MetricsDetails>(); 
    public List<MetricsDetails> all_spwr_solutions_Current = new List<MetricsDetails>();
    public List<MetricsDetails> customer_Satisfaction_Next = new List<MetricsDetails>() ;
    public List<MetricsDetails> performance_to_business_Plan_Next = new List<MetricsDetails>();
    public List<MetricsDetails> training_Next = new List<MetricsDetails>();
    public List<MetricsDetails> marketing_Next = new List<MetricsDetails>();
    public List<MetricsDetails> all_spwr_solutions_Next = new List<MetricsDetails>(); 
    List<Metric_Tier_Relation__c> currentMetricList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> nextMetricList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositeTrainingCurrentList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositeTrainingNextList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositePerformBPCurrentList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositePerformBPNextList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositeSPWRCurrentList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositeSPWRNextList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositeMarketCurrentList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositeMarketNextList=new List<Metric_Tier_Relation__c>();
    Boolean hideHeaderForPartner;
    Boolean showNextTab;
    String StartDate;
	Boolean isExecutiveManager=false;
	String accTheatre;
	String clkSave = 'abc';
    String UserId= userInfo.getuserId();
    String roleId = UserInfo.getUserRoleId();
    UserRole userrole = [select name from UserRole where id=: this.roleId];
    String profileId = UserInfo.getProfileId(); 
    Profile userprofile = [select name from Profile where id=: this.profileId];
    
    public Boolean getPartnerExecutive(){
       if(PerformanceEvalCst.profilePartnerExecutive.contains(userprofile.Name)){
              return true;
          }
         else
         {
             return false;
         } 
    }
    
    public Boolean getHideHeaderForPartner(){
       if(PerformanceEvalCst.profileHideHeaderForPartner.contains(userprofile.Name)){
              return false;
          }
          else{
              return true;
          }
    }

    public Boolean getDisableEditButton(){
        if(PerformanceEvalCst.profileDisableEditButton.contains(userprofile.Name)){
              return false;
          }
          else{
              return true;
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
    public List<MetricsDetails>  gettraining_Current_Clone(){
        return this.training_Current_Clone;
    }
    public List<MetricsDetails>  getmarketing_Current(){
        return this.marketing_Current;
    }
    public List<MetricsDetails>  getall_spwr_solutions_Current(){
        return this.all_spwr_solutions_Current;
    }
    public List<MetricsDetails>  getall_spwr_solutions_Next(){
        return this.all_spwr_solutions_Next;
    }
    public List<MetricsDetails>  getcustomer_Satisfaction_Next(){
        return this.customer_Satisfaction_Next;
    }
    public List<MetricsDetails>  getperformance_to_business_Plan_Next(){
        return this.performance_to_business_Plan_Next;
    }
    public List<MetricsDetails>  gettraining_Next(){
        return this.training_Next;
    }
    public List<MetricsDetails>  getmarketing_Next(){
        return this.marketing_Next;
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
        if(customer_Satisfaction_Next.size()==0 && training_Next.size()==0
        && performance_to_business_Plan_Next.size()==0 && all_spwr_solutions_Next.size()==0
        && marketing_Next.size()==0)
        {
            return false;
        }
        return true;
    }
    
    public String getTierStartDate(){
        return StartDate;    
    }
    public performanceEvaluationPrevious(ApexPages.StandardController controller){
    	accountId = ApexPages.currentPage().getParameters().get('accId');
        this.disableButton= true;
        this.retriveAccountInfo();
    }
    public performanceEvaluationPrevious(){
    	accountId = ApexPages.currentPage().getParameters().get('accId');
        this.disableButton= true;
        this.retriveAccountInfo();
    }
    
    public performanceEvaluationPrevious(String accId){
    	if(accId!=null)
        {
	    	accountId = accId;
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
  
  // Code to retrieve the account,tier,performance metric and the current/next Metric Tier Relation info.
   public void retriveAccountInfo(){
       if(this.accountId != null){
           Account acc = [Select a.name , a.type,a.Country_Domain__c,a.Theater__c,a.Authorized_Partner_Date__c,a.Promoted_Premier_Date__c,a.Elite_partner_Date__c,a.Residential_Installer_Date__c from Account a where id =: this.accountId];
           if(acc != null){
               this.accountName = acc.Name;
               if(acc.Type != null && acc.Type.contains('-')){
                   this.partnerTier = acc.Type.subString(0,acc.Type.indexOf('-'));
                   this.partnerType = acc.Type.subString(acc.Type.indexOf('-')+1,acc.Type.length());
               }
               else if(acc.Type != null && acc.Type.equals('Residential Installer')){
                   this.partnerTier='SRI';
                   this.partnerType=acc.Type;
               }
               String nextTier = '';
               String accCountryDomain = acc.Country_Domain__c;
               accTheatre = acc.Theater__c;
               if(this.partnerTier!=null){
               		nextTier = PerformanceEvalCst.tierMap.get(this.partnerTier);
               }
               if(accCountryDomain != null ){
                   if(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('us')){
                       if(accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('rvar') || accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('combo')){
                           accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                       }
                   }
                   else if((accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('it'))||(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('de'))){
                           accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                   }
                   
                   country_full_name = PerformanceEvalCst.countryMap.get(accCountryDomain);
                   
                   List<Tier__c> tObj = [select Id from Tier__c where Tier_Name__c=: partnerTier and Country__c =:country_full_name];
                   if(tObj!=null && tObj.size()>0)
                   trId=tObj.get(0).Id;
               }
               //new code for new tab
               
               Date tdat = date.newinstance(2010,7,4);  //Date.Today()
               List<Performance_Metric__c> performancelst = new List<Performance_Metric__c>();
               if( accCountryDomain != null && accCountryDomain.equals('us')){
                  performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                  if(performancelst.size()== 0){
                      performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  order by createdDate asc limit 1 ];
                  }
               }
               else if(accCountryDomain != null && ( accCountryDomain.equals('it')||accCountryDomain.equals('de') )){
                  performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                  if(performancelst.size()==0){
                  	performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name)  order by createdDate asc limit 1 ];
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
               }
               List<Tier__c> currentTierObj=new List<Tier__c>();
               List<Tier__c> nextTierObj=new List<Tier__c>();
               if(this.partnerTier!=null)
               {
                   currentTierObj = [select Tier_Name__c from Tier__c where Tier_Name__c =:this.partnerTier and country__c in (: country_full_name ) limit 1];
                   if(nextTier != null ){ 
                        nextTierObj = [select Tier_Name__c from Tier__c where Tier_Name__c =:nextTier and country__c in (: country_full_name ) limit 1];
                   }
               }
               if(performancelst != null && performancelst.size() > 0 && currentTierObj != null && currentTierObj.size()> 0)
               	currentMetricList = [select Metric_Description__c,Manual_Partner__c,Tier__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:performancelst.get(0).Id and Stay_Tier__c=: true ORDER by Sequence_Order__c];//Shishir: removed and isRSMView__c =: false condition REMOVED  OR Benefit_Tier__c=: true)
               if(performancelst != null && performancelst.size() > 0 && nextTierObj != null && nextTierObj.size() > 0  )
               	nextMetricList = [select Metric_Description__c,Manual_Partner__c,Tier__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Stay_Tier__c,Enter_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Tier__c =:nextTierObj.get(0).id and Performance_Metric__c=:performancelst.get(0).Id and Enter_Tier__c=: true ORDER by Sequence_Order__c];//Shishir: removed and isRSMView__c =: false condition
               if(currentMetricList!=null && currentMetricList.size()>0)
               {
                   this.performanceMetricID=performancelst.get(0).Id;
                   // populate metric for each tier and category.
                   this.populateCategoriesForTiers(currentMetricList,performancelst.get(0).Id,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Performance_Period_Start_Date__c,performancelst.get(0).Performance_Period_End_Date__c,'Current');
                   this.populateCategoriesForTiers(nextMetricList,performancelst.get(0).Id,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Performance_Period_Start_Date__c,performancelst.get(0).Performance_Period_End_Date__c,'Next');
                   //Show Training data in Composite way
                   addCompositeMetricForTrn(compositeTrainingCurrentList,training_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id); 
                   addCompositeMetricForTrn(compositeTrainingNextList,training_Next,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id); 
                   //Show SPWR data in Composite way
                   todayDate = date.newinstance(2010,7,4);
                  performanceEvalCompositePrevious.addCompositeMetricForSPWR(compositeSPWRCurrentList,all_spwr_solutions_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId,todayDate); 
                  performanceEvalCompositePrevious.addCompositeMetricForSPWR(compositeSPWRNextList,all_spwr_solutions_Next,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId,todayDate);                            
                   //For Market  
                  performanceEvalCompositePrevious.addCompositeMetricForMarket(compositeMarketCurrentList,marketing_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId,todayDate); 
                  performanceEvalCompositePrevious.addCompositeMetricForMarket(compositeMarketNextList,marketing_Next,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId,todayDate);                            
               } 
               if(this.partnerTier!=null)
               {
                   if(this.partnerTier.equals('Premier')){
                       StartDate=getDateFormat(acc.Promoted_Premier_Date__c);
                   }else if(this.partnerTier.equals('Authorized')){
                       StartDate=getDateFormat(acc.Authorized_Partner_Date__c);
                   }else if(this.partnerTier.equals('Elite')){
                       StartDate=getDateFormat(acc.Elite_partner_Date__c);
                   }else if(this.partnerTier.equals('SRI')){
                       StartDate=getDateFormat(acc.Residential_Installer_Date__c);
                   }
               }
           }
       }
   }
   
   //calculation for training composite metric
   public void addCompositeMetricForTrn(List<Metric_Tier_Relation__c> composite,List<MetricsDetails> currentTier,Date expDate,Id performanceId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
           if(mtr.Metric_Label__c.equals(PerformanceEvalCst.BASIC_TRAINING))
           {
               if(mtr != null)
               {
                   MetricsDetails m = new MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > date.newinstance(2010,7,4) && m.metric.Overriden__c==false)
                       {
                           Double achieve=performanceAchievePrevious.computeBASICTRAINING(this.accountId);
                           m.metric.Achievement_Value__c=achieve;
                           Boolean goal=checkTrainingGoalMet(currentTier);
                           m.metric.Goal_Met__c=goal;    
                       }
                   }
                   else
                   {
                       Metric__c met = new Metric__c();
                       met.Account__c = this.accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Double achieve=performanceAchievePrevious.computeBASICTRAINING(this.accountId);
                       met.Achievement_Value__c=achieve;
                       Boolean goal=checkTrainingGoalMet(currentTier);
                       met.Goal_Met__c=goal;
                       m.metric=met;           
                   }
                   currentTier.add(m);       
               }    
           }
       }
   }
   
   public Boolean checkTrainingGoalMet(List<MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_ASS_DESIGN))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_ASS_INSTALL))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_ASS_SALES))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
       }
       
       if(flag)
         return true;
       else
         return false;  
   }
   
   //code to populate metric to each category of a tier for Current and Next tab.
   public void populateCategoriesForTiers(List<Metric_Tier_Relation__c> tierList,Id performanceId,Date expDate,Date startDate,Date endDate,String tierType){
       if(tierList!= null){
           if(tierType.equals('Current'))
           {
               this.customer_Satisfaction_Current.clear();
               this.training_Current.clear();
               this.performance_to_business_Plan_Current.clear();
               this.marketing_Current.clear();
               this.compositeMarketCurrentList.clear();
               this.compositeTrainingCurrentList.clear();
               this.compositePerformBPCurrentList.clear();
               this.compositeSPWRCurrentList.clear();
           }
           else
           {
               this.customer_Satisfaction_Next.clear();
               this.training_Next.clear();
               this.performance_to_business_Plan_Next.clear();
               this.marketing_Next.clear();
               this.compositeTrainingNextList.clear();
               this.compositeMarketNextList.clear();
               this.compositePerformBPNextList.clear();
               this.compositeSPWRNextList.clear();
           }
             for(Metric_Tier_Relation__c mtr : tierList){
                if(mtr != null){
               MetricsDetails m = new MetricsDetails();
                   if(mtr.Category__c != null && mtr.Category__c.equals('Customer Satisfaction') ){
                       m.meetricTierRel = mtr;
                       List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                       if(mlst != null && mlst.size() > 0  ){
                           m.metric = mlst.get(0);
                           
                           if(mtr.Metric_Input_Type__c.equals('Automated')){
                              if(expDate > date.newinstance(2010,7,4) && m.metric.Overriden__c==false){
                                 if(tierType.equals('Current')){
                                 	AutomatedCSATMetric(m.metric,mtr,startDate,endDate,'Current');
                                 }else{
                                 	AutomatedCSATMetric(m.metric,mtr,startDate,endDate,'Next');
                                 }
                               }
                           }//For Manual but not required as data will come from DB
                           else
                           {
                           }
                       }
                       else{
                        Metric__c met = new Metric__c();
                        met.Account__c = this.accountId;
                        met.Metric_Tier_Relation__c = mtr.Id;
                        met.Performance_Metric__c = performanceId;
                        if(mtr.Metric_Input_Type__c.equals('Automated')){
                            if(tierType.equals('Current')){
                                 	AutomatedCSATMetric(met,mtr,startDate,endDate,'Current');
                                 }else{
                                 	AutomatedCSATMetric(met,mtr,startDate,endDate,'Next');
                                 }
                           }//For Manual
                           else
                           {
                               met.Boolean_Achievement__c = false;
                               met.Goal_Met__c=false; 
                           }
                         m.metric=met;                       
                       }
                       if(tierType.equals('Current'))
                       {
                           this.customer_Satisfaction_Current.add(m);
                       }
                       else
                       {
                           this.customer_Satisfaction_Next.add(m);
                       }    
                   }
                   else if(mtr.Category__c != null && mtr.Category__c.equals('Training')){
                       
                       if(mtr.Part_Of_Composite_Incentive__c)
                       {
                          if(tierType.equals('Current'))
                          {
                               this.compositeTrainingCurrentList.add(mtr);    
                          }
                          else
                          {
                               this.compositeTrainingNextList.add(mtr);    
                          }
                        }
                        else
                        {
                               m.meetricTierRel = mtr;
                               List<Metric__c> mlst = mtr.Metrics__r;
                               if(mlst != null && mlst.size() > 0  )
                               {
                                   m.metric = mlst.get(0);
                                   if(mtr.Metric_Input_Type__c.equals('Automated'))
                                   {
                                     if(expDate > date.newinstance(2010,7,4) && m.metric.Overriden__c==false)
                                      {
                                         AutomatedTrainingMetric(m.metric,mtr,startDate,endDate);
                                      }
                                    }
                                    else
                                    {
                                    }
                                }
                                else
                                {
                                    Metric__c met = new Metric__c();
                                    met.Account__c = this.accountId;
                                    met.Metric_Tier_Relation__c = mtr.Id;
                                    met.Performance_Metric__c = performanceId;
                                    if(mtr.Metric_Input_Type__c.equals('Automated')){
                                        AutomatedTrainingMetric(met,mtr,startDate,endDate);
                                    }
                                    else
                                    {
                                        met.Boolean_Achievement__c = false;
                                        met.Goal_Met__c=false; 
                                    }
                                    m.metric=met;  
                                } 
                               if(tierType.equals('Current'))
                               {
                                   this.training_Current.add(m);
                               }
                               else
                               {
                                   this.training_Next.add(m);
                               }
                         }                       
                   }
                   else if( mtr.Category__c != null && mtr.Category__c.equals('Performance to Business Plan')){
                       if(mtr.Part_Of_Composite_Incentive__c)
                       {
                          if(tierType.equals('Current'))
                          {
                               this.compositePerformBPCurrentList.add(mtr);    
                          }
                          else
                          {
                               this.compositePerformBPNextList.add(mtr);    
                          }
                        }
                        else
                        {   
                           m.meetricTierRel = mtr;
                           List<Metric__c> mlst = mtr.Metrics__r;
                           if(mlst != null && mlst.size() > 0  ){
                               m.metric = mlst.get(0);
                               if(mtr.Metric_Input_Type__c.equals('Automated')){
                                  if(expDate > date.newinstance(2010,7,4) && m.metric.Overriden__c==false){ 
                                    AutomatedPbpMetric(m.metric,mtr,startDate,endDate);
                                  }
                                }//For Manual but not required as data will come DB
                                else
                                {
                                }
                            }
                            else
                            {
                                Metric__c met = new Metric__c();
                                met.Account__c = this.accountId;
                                met.Metric_Tier_Relation__c = mtr.Id;
                                met.Performance_Metric__c = performanceId;
                                if(mtr.Metric_Input_Type__c.equals('Automated')){
                                    AutomatedPbpMetric(met,mtr,startDate,endDate);
                                  }//For Manual
                                  else
                                  {
                                     met.Boolean_Achievement__c = false;
                                     met.Goal_Met__c=false; 
                                  }  
                                m.metric=met;
                            }      
                           
                           if(tierType.equals('Current'))
                           {
                               this.performance_to_business_Plan_Current.add(m);
                           }
                           else
                           {
                               this.performance_to_business_Plan_Next.add(m);
                           }                       
                         } 
                   }
                   else if( mtr.Category__c != null && mtr.Category__c.equals('Marketing')){
                       if(mtr.Part_Of_Composite_Incentive__c)
                       {
                          if(tierType.equals('Current'))
                          {
                               this.compositeMarketCurrentList.add(mtr);    
                          }
                          else
                          {
                               this.compositeMarketNextList.add(mtr);    
                          }
                        }
                        else
                        {   
                           m.meetricTierRel = mtr;
                           List<Metric__c> mlst = mtr.Metrics__r;
                           if(mlst != null && mlst.size() > 0  ){
                               m.metric = mlst.get(0);
                               if(mtr.Metric_Input_Type__c.equals('Automated')){
                                  if(expDate > date.newinstance(2010,7,4) && m.metric.Overriden__c==false){ 
                                      
                                  }
                                }
                                else
                                {
                                }
                            }
                            else
                            {
                                Metric__c met = new Metric__c();
                                met.Account__c = this.accountId;
                                met.Metric_Tier_Relation__c = mtr.Id;
                                met.Performance_Metric__c = performanceId;
                                if(mtr.Metric_Input_Type__c.equals('Automated')){
                                
                                }
                                //Manual
                                else
                                {
                                    met.Boolean_Achievement__c = false;
                                     met.Goal_Met__c=false;
                                }
                                m.metric=met;  
                            } 
                           if(tierType.equals('Current'))
                           {
                               this.marketing_Current.add(m);
                           }
                           else
                           {
                               this.marketing_Next.add(m);
                           }                       
                         }  
                   }
                   else if(mtr.Category__c != null &&  mtr.Category__c.equals('All SPWR solutions')){
                       if(mtr.Part_Of_Composite_Incentive__c)
                       {
                          if(tierType.equals('Current'))
                          {
                               this.compositeSPWRCurrentList.add(mtr);    
                          }
                          else
                          {
                               this.compositeSPWRNextList.add(mtr);    
                          }
                        }
                        else
                        {        
                           m.meetricTierRel = mtr;
                           List<Metric__c> mlst = mtr.Metrics__r;
                           if(mlst != null && mlst.size() > 0  ){
                               m.metric = mlst.get(0);
                               if(mtr.Metric_Input_Type__c.equals('Automated')){
                                  if(expDate > date.newinstance(2010,7,4) && m.metric.Overriden__c==false){
                                    AutomatedSPWRMetric(m.metric,mtr,startDate,endDate);
                                  }
                                }
                                else
                                {
                                }
                            }
                            else
                            {
                                Metric__c met = new Metric__c();
                                met.Account__c = this.accountId;
                                met.Metric_Tier_Relation__c = mtr.Id;
                                met.Performance_Metric__c = performanceId;
                                if(mtr.Metric_Input_Type__c.equals('Automated')){
                                    AutomatedSPWRMetric(met,mtr,startDate,endDate);
                                }
                                else
                                {
                                   met.Boolean_Achievement__c = false;
                                   met.Goal_Met__c=false; 
                                }
                                m.metric=met;  
                            } 
                           if(tierType.equals('Current'))
                           {
                               this.all_spwr_solutions_Current.add(m);
                               
                           }
                           else
                           {
                               this.all_spwr_solutions_Next.add(m);
                           }                       
                        }  
                   }
               }
           }
       }
   }
   
   //calculation for Automated SPWR metric
   public void AutomatedSPWRMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_SALES_KITS)){
           Double achievement=performanceAchievePrevious.computeSEVENTYSALESKITS(this.accountId,startDate,endDate);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.OPP_CLOSE_RATE)){
           Double achieve=performanceAchievePrevious.computeOPPCLOSERATE(this.accountId);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_RES_KITS_EU)){
           //code added for phase2a on 5/5/10 waiting for confirmation
           Double achievement=performanceAchievePrevious.computeSEVENTYRESKITSEU(this.accountId,startDate,endDate);
          // PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achievement);
        }   
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_COM_INVTR_EU)){
           //code added for phase2a on 5/5/10 waiting for confirmation 
           Double achievement=performanceAchievePrevious.computeSEVENTYCOMINVTREU(this.accountId,startDate,endDate);
           //PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achievement);
        }
   }
   //Calculation for Performance to Bussiness plan Automated metric
   public void AutomatedPbpMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
       if(mtr.Metric_Label__c.equals(PerformanceEvalCst.ACTIVE_DEALER)){
            Boolean achievement=performanceAchievePrevious.computeACTIVEDEALER(this.accountId,startDate,endDate);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CREDIT_LIMIT)){
            Double creditLimit=performanceAchievePrevious.computeCREDITLIMIT(this.accountId);
            Double max=null;
            Boolean goalMet=performanceAchievePrevious.checkGoalMet(100000,max,creditLimit);
            m.Boolean_Achievement__c =goalMet;
            m.Goal_Met__c=goalMet;
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CREDIT_LIMIT_EU)){
            Boolean goalMet=performanceAchievePrevious.computeCREDITLIMITEU(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,goalMet);
        }
        //Code added for Phase2a for Credit Limit for SRI on 11may
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CREDIT_LIMIT_SRI)){
            Boolean goalMet=performanceAchievePrevious.computeCREDITLIMITSRI(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,goalMet);
        }
        if((mtr.Metric_Label__c.equals(PerformanceEvalCst.SIX_MONTHS_AS_AUTH))
           || (mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_EXP_SIX_MONTHS_EU))){
            Boolean achievement=performanceAchievePrevious.computeSIXMONTHSASAUTH(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.TWENTY_INSTALLS_AS_AUTH)){
            Boolean achievement=performanceAchievePrevious.computeTWENTYINSTALLSASAUTH(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SIX_MONTHS_AS_PREM)){
            Boolean achievement=performanceAchievePrevious.computeSIXMONTHSASPREM(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.HUNDRED_INSTALLS_AS_PREM)){
            Boolean achievement=performanceAchievePrevious.computeHUNDREDINSTALLSASPREM(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_EXP_TWENTY_INSTALLS_EU)){
            Boolean achievement=performanceAchievePrevious.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.RETROFIT_SOLAR_SYS)){
            Boolean achievement=performanceAchievePrevious.computeRETROFITSOLARSYS(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.BGSM_SCORECARD_EU)
           || mtr.Metric_Label__c.equals(PerformanceEvalCst.BGSM_SCORECARD_EU_CLONE)){
            Double score=performanceAchievePrevious.computeBGSMScore(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,score);
            
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_QUAT_SALES_EU)){
        	system.debug('minimumSales');
            Boolean achievement=performanceAchievePrevious.computeMINQUATSALESEU(this.accountId,startDate,endDate);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        } 
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_QUAT_SALES_EU_CLONE)){
            Boolean achievement=performanceAchievePrevious.computeMINQUATSALESEUCLONE(this.accountId,startDate,endDate);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_SALES_AUTHZ_EU)){
            Boolean achievement=performanceAchievePrevious.computeMINSALESAUTHZEU(this.accountId);
            performanceAchievePrevious.automatedBooleanGoalCheck(m,mtr,achievement);
        } 
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.KW_TARGET_EU)){
            Double score=performanceAchievePrevious.computeKWTARGETEU(this.accountId,startDate,endDate);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,score);
            
        }
   }
   
   //Calculation for Training Automated metric
   public void AutomatedTrainingMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
       if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_DESIGN)){
           Double achieve=performanceAchievePrevious.computeTRAININGASSDESIGN(this.accountId);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_INSTALL)){
            Double achieve=performanceAchievePrevious.computeTRAININGASSINSTALL(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_SALES)){
            Double achieve=performanceAchievePrevious.computeTRAININGASSSALES(this.accountId);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ADV_DESIGN)){
            Double achieve=performanceAchievePrevious.computeTRAININGADVDESIGN(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ADV_INSTALL)){
            Double achieve=performanceAchievePrevious.computeTRAININGADVINSTALL(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ADV_SALES)){
            Double achieve=performanceAchievePrevious.computeTRAININGADVSALES(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.ADVANCE_PROD_TRAINING)){
            Double achieve=performanceAchievePrevious.computeADVANCEPRODTRAINING(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);            
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.ADVANCE_TRAINING_EU)){
            Double achieve=performanceAchievePrevious.computeADVANCE_TRAINING_EU(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.BASIC_TRAINING_EU)){
            Double achieve=performanceAchievePrevious.computeBASICTRAININGEU(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.BASIC_TRAINING_EU_CLONE)){
            Double achieve=performanceAchievePrevious.computeBASICTRAINING(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        // code added for phase2a  for training Bonus for Extra by Reshma
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_I)){
            Double achieve=performanceAchievePrevious.computeEXTRABONUSI(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        // code added for phase2a  for training Bonus for Extra by Reshma
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II)){
            Double achieve=performanceAchievePrevious.computeEXTRABONUSII(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        

   } 
   //Calculation for Customer Satisfaction Automated Metric
   private void AutomatedCSATMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate,String tierType)
   {
      /* if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE)){
           Double csatScore=performanceAchievePrevious.computeCSATSCORE(this.accountId,startDate,endDate);  
           m.Achievement_Value__c  = csatScore;
           Double min=mtr.Metric_Min_Value__c;
           Double max=mtr.Metric_Max_Value__c;
           Boolean csatGoalMet=performanceAchievePrevious.checkGoalMet(min,max,csatScore);
           //code changed for phase2a on 3 may 10 Code commented till Dave's confirmation
           Double thershold = mtr.Thershold__c;
           Boolean countGoal = performanceAchievePrevious.checkCSATCount(this.accountId,startDate,endDate,thershold);
           if(csatGoalMet && countGoal){
           		m.Goal_Met__c = true;		
           }else{
           		m.Goal_Met__c=false;	
           }
           
        }*/
        
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE_EU)||mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE)){
           Double csatScore=performanceAchievePrevious.computeCSATSCORE(this.accountId,startDate,endDate);
           System.debug('ScoreResh'+csatScore);  
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,csatScore);
        }
        //code added for Phase 2a for CSAT Requirement on 11May
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SURVEY_REQ)){
        	Double csatSurveyReq=performanceAchievePrevious.computeCSATSURVEYREQ(this.accountId,startDate,endDate);  
           	performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,csatSurveyReq);	
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION) ){ //|| mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_EU)
            Double siteInspection=performanceAchievePrevious.coumputeSITEINSPECTION(this.accountId,startDate,endDate);  
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,siteInspection);
        }
        //code for phase2 on 29 apr 10
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_EU)){
        	Id acountId = this.accountId;
        	Id t = mtr.Tier__c;
        	if(tierType.equals('Current')){
	            Double siteInspection=performanceAchievePrevious.coumputeSITEINSPECTIONEUSTAY(this.accountId,startDate,endDate);  //changed coumputeSITEINSPECTION to coumputeSITEINSPECTIONEUSTAY
	            m.Achievement_Value__c = siteInspection;
	            Double min=mtr.Metric_Min_Value__c;
	            Double max=mtr.Metric_Max_Value__c;
	            Boolean inspectionGoalMet=performanceAchievePrevious.checkGoalMet(min,max,siteInspection);
	            m.Goal_Met__c=inspectionGoalMet;
        	}else if(tierType.equals('Next')){
        		Double siteInspection=performanceAchievePrevious.coumputeSITEINSPECTIONEU(acountId,startDate,endDate,t);  
	            m.Achievement_Value__c = siteInspection;
	            Double min=mtr.Metric_Min_Value__c;
	            Double max=mtr.Metric_Max_Value__c;
	            Boolean inspectionGoalMet=performanceAchievePrevious.checkGoalMet(min,max,siteInspection);
	            m.Goal_Met__c=inspectionGoalMet;
        	}
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CUSTOMER_COMPLAINTS)){
            Double complaints=performanceAchievePrevious.coumputeCUSTOMERCOMPLAINTS(this.accountId,startDate,endDate);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,complaints);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PERCENT_INSTALL_CRM)){
           Double percentInstalls=performanceAchievePrevious.computePERCENTINSTALLCRM(this.accountId,startDate,endDate);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,percentInstalls);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_NON_COMP)){
           Double achieve=performanceAchievePrevious.coumputeSITEINSPECTIONNONCOMP(this.accountId,startDate,endDate);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        // code added for SunrisePhase 2a on 28Apr 10 by Reshma for Warranty cards
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.WARRANTY_CARDS_NA)){
        	Double achieve =performanceAchievePrevious.computeWARRANTYCARDSNA(this.accountId,startDate,endDate) ;	
        	performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.WARRANTY_CARDS_EU)){
        	Double achieve =performanceAchievePrevious.computeWARRANTYCARDSEU(this.accountId,startDate,endDate) ;	
        	performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
   }
    
    public PageReference updateEvaluation(){   
        updateMetricRecords();
        //call constructor function
       // this.retriveAccountInfo();
        clkSave = ApexPages.currentPage().getParameters().get('clksave');
        if(clksave == null){
        	UpdateOtherTiers(customer_Satisfaction_Current,customer_Satisfaction_Next);
        	UpdateOtherTiers(performance_to_business_Plan_Current,performance_to_business_Plan_Next);
        	UpdateOtherTiers(training_Current,training_Next);
        	UpdateOtherTiers(marketing_Current,marketing_Next);
        	UpdateOtherTiers(all_spwr_solutions_Current,all_spwr_solutions_Next);
        	updateCompositeMetricForMarket(marketing_Next);	
        }
        this.retriveAccountInfo();
        return null;
    }
    public PageReference updateMetricRecords()
    {   
        Date expdate;
        if(this.paramExpDate!=null)
        {
            expdate=Date.valueof(this.paramExpDate);
        }
        this.disableButton = true;
        updateAchievement(customer_Satisfaction_Current);
        updateAchievement(performance_to_business_Plan_Current);
        updateAchievement(training_Current);
        //For Market
        updateAchievement(marketing_Current);
        updateCompositeMetricForMarket(marketing_Current); 

        updateAchievement(all_spwr_solutions_Current);
        //Total Incentive
        updateAchievement(customer_Satisfaction_Next);
        updateAchievement(performance_to_business_Plan_Next);
        updateAchievement(training_Next);
                                    
        updateAchievement(marketing_Next);
        updateCompositeMetricForMarket(marketing_Next);
        
        updateAchievement(all_spwr_solutions_Next);
        return null;
    }
    
    /* new code to syn the tier data*/
	Private void UpdateOtherTiers(List<MetricsDetails> currentTierL,List<MetricsDetails> nextTierL){
    	List<Metric__c> metricsList= new List<Metric__c>();
    	for(MetricsDetails mdo : currentTierL){
        	for(MetricsDetails mdu: nextTierL){
                if(mdo.meetricTierRel.Metric_Label__c == mdu.meetricTierRel.Metric_Label__c){
                    if(mdu.meetricTierRel.Boolean_Metric_Y_N__c == true && mdo.meetricTierRel.Boolean_Metric_Y_N__c == true){ 
                    	mdu.metric.Boolean_Achievement__c = mdo.metric.Boolean_Achievement__c;
                        mdu.metric.Goal_Met__c = mdo.metric.Goal_Met__c;        
                    }else{  
                        if(mdu.metric.Boolean_Achievement__c != null && mdo.metric.Boolean_Achievement__c!= null){
                            if(mdu.meetricTierRel.Metric_Min_Value__c!=null && mdo.meetricTierRel.Metric_Min_Value__c!=null){
                                if(mdu.meetricTierRel.Metric_Min_Value__c == mdo.meetricTierRel.Metric_Min_Value__c){
                                	mdu.metric.Achievement_Value__c = mdo.metric.Achievement_Value__c;
                                	mdu.metric.Goal_Met__c = mdo.metric.Goal_Met__c ;	
                                }
                            }else if(mdu.meetricTierRel.Metric_Max_Value__c!=null && mdo.meetricTierRel.Metric_Max_Value__c!=null){
                            	if(mdu.meetricTierRel.Metric_Max_Value__c == mdo.meetricTierRel.Metric_Max_Value__c){ 
                            		mdu.metric.Achievement_Value__c =mdo.metric.Achievement_Value__c;
                            		mdu.metric.Goal_Met__c = mdo.metric.Goal_Met__c ;
                            	}   
                            }
                        }
                    }
                    metricsList.add(mdu.metric);                               
                }
                // check if this list is created.
            }
        } 
    	if(metricsList.size()>0){
        	update metricsList;
    	}  
	}
    /* end of data */
   //Update the Composite Market metric
   private void updateCompositeMetricForMarket(List<MetricsDetails> currentTier)
   {
       for(MetricsDetails m: currentTier)
       {
             if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_MARKET))
             {
                  if(m.metric.Overriden__c==false)
                  {
                      Boolean goal=performanceEvalCompositePrevious.checkMarketUSAGoalMet(currentTier);
                      m.metric.Goal_Met__c=goal;
                      m.metric.Boolean_Achievement__c=goal; 
                      update m.metric;
                  }
             }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.THREE_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                 {
                    Boolean goal=performanceEvalCompositePrevious.checkMarketEUGoalMet(currentTier,'THREE');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal; 
                    update m.metric;
                 }   
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.FOUR_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                {
                    Boolean goal=performanceEvalCompositePrevious.checkMarketEUGoalMet(currentTier,'FOUR');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    update m.metric;
                }    
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SIX_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                  {
                  Boolean goal=performanceEvalCompositePrevious.checkMarketEUGoalMet(currentTier,'SIX');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    update m.metric;
                  }  
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SEVEN_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                 {
                    Boolean goal=performanceEvalCompositePrevious.checkMarketEUGoalMet(currentTier,'SEVEN');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal; 
                    update m.metric;   
                 }   
            }
       }
   }
    
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
    //Incentive Calculation
    public void saveTotalIncentive(Id tierId  )
    {
        Double csatIncentive=getIncentiveFromList(customer_Satisfaction_Current); 
        Double trnIncentive=getIncentiveFromList(performance_to_business_Plan_Current);
        Double pbpIncentive=getIncentiveFromList(training_Current);
        Double mrktIncentive=getIncentiveFromList(marketing_Current);
        Double spwrIncentive=getIncentiveFromList(all_spwr_solutions_Current);    
        Double totalIncentive=csatIncentive+trnIncentive+pbpIncentive+mrktIncentive+spwrIncentive;
        String perfmMetricId=this.performanceMetricID;
        String accId=this.accountId;
        Double pdfLimit = 0;
        List<PDF_Limit__c> pdfList = [select Partner__c from PDF_Limit__c where Performance_Metric__c =:perfmMetricId and Tier__c =: tierId   ];
        if(pdfList != null && pdfList.size() > 0){
           pdfLimit =  pdfList.get(0).Partner__c; 
        }
        
        List<Overall_Performance_Evaluation__c> listIncentice=new List<Overall_Performance_Evaluation__c>();
        if(perfmMetricId!=null && accId!=null)
        {
            listIncentice=[select Id,Total_Incentive__c,Total_Credit_Memo__c,Account__c,Performance_Metric__c from Overall_Performance_Evaluation__c where Account__c=:accId and Performance_Metric__c=:perfmMetricId];
            if(listIncentice!=null && listIncentice.size()>0)
            {
                Double value = 0.0;
                if(totalIncentive > pdfLimit)
                {
                    value = totalIncentive - pdfLimit ;
                }
                Overall_Performance_Evaluation__c o1= new Overall_Performance_Evaluation__c(id=listIncentice.get(0).id);
                o1.Total_Incentive__c=totalIncentive;   
                o1.Total_Credit_Memo__c=value;
                update o1;
            }
            else
            {
                Double value=0;
                Overall_Performance_Evaluation__c obj=new Overall_Performance_Evaluation__c();
                obj.Account__c=accId;
                obj.Performance_Metric__c=perfmMetricId;
                obj.Total_Incentive__c=totalIncentive;
                if(totalIncentive > pdfLimit )
                {
                    value =  totalIncentive - pdfLimit ;
                }    
                obj.Total_Credit_Memo__c=value;   
                insert obj;
            }
        }
        saveQuarterlyIncentive(pdfLimit,totalIncentive,tierId);
    }
    //Save Quaterly Incentive data 
    private void saveQuarterlyIncentive(Double pdfLimit,Double totalIncentive,Id tierId)
    {
        List<Quarterly_Performance_Evaluation__c> quarterIncentice=new List<Quarterly_Performance_Evaluation__c>();
        String currentQuarter=performanceAchievePrevious.getCurrentQuarter();
        String perfmMetricId=this.performanceMetricID;
        String accId=this.accountId;
        if(perfmMetricId!=null && accId!=null)
        {
            quarterIncentice=[select Id,Total_Incentive_QTD__c,Total_Credit_Memo_QTD__c,Account__c,Performance_Metric__c from Quarterly_Performance_Evaluation__c where Account__c=:accId and Performance_Metric__c=:perfmMetricId and Quarter__c=:currentQuarter and Year__c=:(date.newinstance(2010,7,4).year())];
            if(quarterIncentice!=null && quarterIncentice.size()>0)
            {
                Double value = 0.0;
                if(totalIncentive > pdfLimit)
                {
                    value = totalIncentive - pdfLimit ;
                }
                Quarterly_Performance_Evaluation__c o1= new Quarterly_Performance_Evaluation__c(id=quarterIncentice.get(0).id);
                o1.Total_Incentive_QTD__c=totalIncentive;   
                o1.Total_Credit_Memo_QTD__c=value;
                update o1;
            }
            else
            {
                Double value=0;
                Quarterly_Performance_Evaluation__c obj=new Quarterly_Performance_Evaluation__c();
                obj.Account__c=accId;
                obj.Performance_Metric__c=perfmMetricId;
                obj.Tier__c=tierId;
                obj.Total_Incentive_QTD__c=totalIncentive;
                if(totalIncentive > pdfLimit )
                {
                    value =  totalIncentive - pdfLimit ;
                }    
                obj.Total_Credit_Memo_QTD__c=value;
                obj.Year__c=date.newinstance(2010,7,4).year();
                obj.Quarter__c=currentQuarter;   
                insert obj;
            }
        }         
    }
    
    private Double getIncentiveFromList(List<MetricsDetails> mdList)
    {
        Double incentive=0;
        for(MetricsDetails md: mdList)
        {
           if(md.meetricTierRel.Incentive_Amount__c!=null && md.metric.Goal_Met__c==true)
           {
               incentive=incentive+md.meetricTierRel.Incentive_Amount__c;
           }   
        }
        return incentive;
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
        public Metric_Tier_Relation__c getmeetricTierRel(){
            return this.meetricTierRel;
        }
        public Metric__c getMetric(){
            return this.metric;
        }
        public MetricsDetails(){}
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
    //Flag to show SPWR metric if any for current
    public Boolean getSPWRCurrentFlag(){
      if(all_spwr_solutions_Current.size()>0)
            return true;
        else
            return false;
    }
    //Flag to show SPWR metric if any for Next
    public Boolean getSPWRNextFlag(){
      if(all_spwr_solutions_Next.size()>0)
            return true;
        else
            return false;
    }
	

}