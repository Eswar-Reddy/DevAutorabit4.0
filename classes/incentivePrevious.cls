public class incentivePrevious {
         
    public String accountId; 
    final String  ACCOUNT_CHANNEL_NAME ='Residential';
    String UserId= userInfo.getuserId();
    String roleId = UserInfo.getUserRoleId();
    UserRole userrole = [select name from UserRole where id=: this.roleId];
    String profileId = UserInfo.getProfileId(); 
    Profile userprofile = [select name from Profile where id=: this.profileId];
    String accountName ;
    String partnerTier;
    String partnerType;
    String validEvalFromDate;
    String validEvalToDate;
    public String partnerDevelopmentFunds;
    public String totalIncentive;
    public String CreditMemo;
    public String totalFunds;
    public String PDFNumber;
    public String creditMemoNumber;
    public double totalPDF;
    String StartDate;
    String accTheatre;
    String comingSoon;
    Id trId;
    List<Tier__c> currentTierObj=new List<Tier__c>();
    List<Metric_Tier_Relation__c> currentMetricList=new List<Metric_Tier_Relation__c>();
    public List<MetricsDetails> customer_Satisfaction_Current = new List<MetricsDetails>();
    public List<MetricsDetails> performance_to_business_Plan_Current = new List<MetricsDetails>();
    public List<MetricsDetails> training_Current = new List<MetricsDetails>();
    public List<MetricsDetails> marketing_Current = new List<MetricsDetails>(); 
    public List<MetricsDetails> all_spwr_solutions_Current = new List<MetricsDetails>();
    List<Metric_Tier_Relation__c> compositeTrainingCurrentList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositePerformBPCurrentList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositeSPWRCurrentList=new List<Metric_Tier_Relation__c>();
    List<Metric_Tier_Relation__c> compositeMarketCurrentList=new List<Metric_Tier_Relation__c>();
    List<Performance_Metric__c> performancelst = new List<Performance_Metric__c>();
    Boolean disableButton,disableEditButton,partnerExecutive,ShowLink;
    Boolean csatFlag,trnFlag,pbpFlag,mrkFlag,spwrFlag;
    String minRequirementMet;
    public Double possibleIncentive,earnedIncentive;
    String paramStartDate,paramEndDate,paramExpDate,performanceMetricID;
    Boolean hideHeaderForPartner;
    Double shipBonus ;
    Double Bonus ;
    Double PfContri =0.0;
    Double ChckRwd =0.0;
    String tname;
    boolean isactive= false;
    public Double totBonus =0.0;
    list<MetricsDetails>  mtrlistP = new list<MetricsDetails>();
    list<MetricsDetails>  mtrlistC = new list<MetricsDetails>();
    public list<MtrDetail> mtrdetailList = new list<MtrDetail>();
    list<MtrDetail> mtrBPList = new list<MtrDetail>();
    list<MtrDetail> mtrTrngList = new list<MtrDetail>();
    list<MtrDetail> mtrAllSunList = new list<MtrDetail>();
    Double perRvneTrgt =0; // String to Double as on 24 June
    Boolean mkt = false;
    public Boolean isExecutiveManager=false;
    String CurrencySyb;
    String CurrencySybm;
    Double netPurchase =0;
    
    public Boolean getcsatFlag(){
        if(customer_Satisfaction_Current.size()>0)
        return true;
        else
        return false;
    }
    public Boolean gettrnFlag(){
        if(training_Current.size()>0)
        return true;
        else
        return false;
    }
    public Boolean getpbpFlag(){
        if(performance_to_business_Plan_Current.size()>0)
        return true;
        else
        return false;
    }
    public Boolean getmrkFlag(){
        if(marketing_Current.size()>0)
        return true;
        else
        return false;
    }
    public Boolean getspwrFlag(){
        if(all_spwr_solutions_Current.size()>0)
        return true;
        else
        return false;
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
    public Boolean getDisableButton(){
        return this.disableButton;
    }
    
    public Boolean getHideHeaderForPartner(){
        if(PerformanceEvalCst.profileHideHeaderForPartner.contains(userprofile.Name)){
              return false;
          }else{
              return true;
          }
    }
    public Boolean getShowLink(){
        if(PerformanceEvalCst.profileShowLink.contains(userprofile.Name)){
            return false;
        }else{
            return true;
        }
    }
    public Boolean getPartnerExecutive(){
        if(PerformanceEvalCst.profilePartnerExecutive.contains(userprofile.Name)){
              return true;
          }else{
             return false;
         } 
    }
    public Boolean getDisableEditButton(){
       if(PerformanceEvalCst.profileDisableEditButton.contains(userprofile.Name)){
              return false;
          }else{
              return true;
          }
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
    public List<MetricsDetails>  getmarketing_Current(){
        return this.marketing_Current;
    }
    public List<MetricsDetails>  getall_spwr_solutions_Current(){
        return this.all_spwr_solutions_Current;
    }
    public void setpartnerDevelopmentFunds(String s){
        this.partnerDevelopmentFunds= s;
    }
    public void settotalIncentive(String s){
        this.totalIncentive= s;
    }
    public void setCreditMemo(String s){
        this.CreditMemo= s;
    }
    public void settotalFunds(String s){
        this.totalFunds= s;
    }
    public void setPDFNumber(String s){
        this.PDFNumber= s;
    }
    public void setcreditMemoNumber(String s){
        this.creditMemoNumber= s;
    }
    
    public String getpartnerDevelopmentFunds(){
        return this.partnerDevelopmentFunds;
    }
    public String gettotalIncentive(){
        return this.totalIncentive;
    }
    public String getCreditMemo(){
        return this.CreditMemo;
    }
    public String gettotalFunds(){
        return this.totalFunds;
    }
    public String getPDFNumber(){
        return this.PDFNumber;
    }
    public String getcreditMemoNumber(){
        return this.creditMemoNumber;
    }
    

    public incentivePrevious(){
        accountId = ApexPages.currentPage().getParameters().get('accId');
        this.disableButton= true;
        this.retriveIncentiveInfo();
    }
    //For APEX Scheduler
    //START
    public incentivePrevious(String accId)
    {
        if(accId!=null)
        {
            accountId=accId; 
            retriveIncentiveInfo();
            saveEvaluationIncentive();
        }    
    }
    //END
    public PageReference enableInputFields(){
        this.disableButton = false;
        return null;
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
    /**start**/
    
    public String getTierStartDate(){
        return StartDate;    
    }
    /**end**/
    
    public String getAccTheatre(){
       return accTheatre;
    }
    
    public Boolean getisExecutiveManager(){
        return isExecutiveManager;
    }
  
    public String getCurrencySyb(){
        return CurrencySyb;
    }
    
     public String getCurrencySybm(){
        return CurrencySybm;
    }
    //Start 5/Feb/2010
    
    public String getcomingSoon(){
        return comingSoon;
    }
    //End 5/Feb/2010
    //code to populate account ,tier,performance metric and the Metrics infor.
    public void retriveIncentiveInfo(){
        if(this.accountId != null){
           Account acc = [Select a.name, a.CurrencyIsoCode, a.type,a.Country_Domain__c,a.Theater__c,a.Authorized_Partner_Date__c,a.Promoted_Premier_Date__c,a.Elite_partner_Date__c,a.Residential_Installer_Date__c from Account a where id =: this.accountId];
           if(acc != null){
                   if(acc.CurrencyIsoCode == 'USD'){
                       CurrencySyb = '$';
                       CurrencySybm='';
                   }else if(acc.CurrencyIsoCode == 'EUR'){
                       CurrencySyb = '';
                       CurrencySybm ='€';
                   }
                   this.accountName = acc.Name;
                   /**extract Partner Type and Partner Tier**/
                   if(acc.Type != null && acc.Type.contains('-')){
                       this.partnerTier = acc.Type.subString(0,acc.Type.indexOf('-'));
                       this.partnerType = acc.Type.subString(acc.Type.indexOf('-')+1,acc.Type.length());
                   }
                   else if(acc.Type != null && acc.Type.equals('Residential Installer')){
                       this.partnerTier='SRI';
                       this.partnerType=acc.Type;
                   }
                   String accCountryDomain = acc.Country_Domain__c;
                   accTheatre = acc.Theater__c;
                   if(accCountryDomain != null ){
                       if(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('us')){
                           if(accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('rvar') || accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('combo')){
                               accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                           }
                       }
                       else if((accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('it'))||(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('de'))){
                               accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                       }
                   }
                   String country_full_name ='';
                   
                   if(accCountryDomain != null){
                        comingSoon= PerformanceEvalCst.comingSoonMap.get(accCountryDomain);
                        country_full_name = PerformanceEvalCst.countryMap.get(accCountryDomain);
                   }
                   Date tdat = date.newinstance(2010,7,4);
                   if( accCountryDomain != null && accCountryDomain.equals('us')){
                        this.performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                        if(performancelst.size()== 0){
                            this.performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  order by createdDate asc limit 1 ];
                        }
                   }
                   else if(accCountryDomain != null && ( accCountryDomain.equals('it')||accCountryDomain.equals('de') )){
                        this.performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                        if(performancelst.size()==0){
                            this.performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name)  order by createdDate asc limit 1 ];
                        }
                   }
                   if(performancelst != null && performancelst.size() > 0 ){
                       this.validEvalFromDate = ''+ getDateFormat(performancelst.get(0).Performance_Period_Start_Date__c);
                       this.validEvalToDate = ''+ getDateFormat(performancelst.get(0).Performance_Period_End_Date__c);
                       this.paramStartDate = ''+performancelst.get(0).Performance_Period_Start_Date__c;
                       this.paramEndDate = ''+performancelst.get(0).Performance_Period_End_Date__c;
                       this.paramExpDate = ''+performancelst.get(0).Performance_Evaluation_Cut_off_Date__c;
                       if(performancelst.get(0).User_To_Override__c!=null && UserId.equals(performancelst.get(0).User_To_Override__c))
                       {
                           isExecutiveManager=true;
                       }
                   }
                   /**retrive the PDF values**/
                   if(this.partnerTier!=null){
                       currentTierObj = [select Id,Tier_Name__c from Tier__c where Tier_Name__c =:this.partnerTier and country__c in (: country_full_name ) limit 1];
                    } 
                   //for benefit tier
                   if(performancelst != null && performancelst.size() > 0 && currentTierObj != null && currentTierObj.size()> 0)
                   currentMetricList = [select isRSMView__c,Metric_Description__c,Manual_Partner__c,Tier__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c, ParentMetricRelation__c,Part_Of_Composite_Incentive__c,HelpText__c,(select Overriden__c,Metric_Description__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c,Incentive_Amount__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:performancelst.get(0).Id and Benefit_Tier__c=: true ORDER by Sequence_Order__c];
                   if(currentMetricList!=null && currentMetricList.size()>0)
                   {
                      trId=currentTierObj.get(0).Id;
                      this.performanceMetricID=performancelst.get(0).Id;
                      this.populateCategoriesForTiers(currentMetricList,performancelst.get(0).Id,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Performance_Period_Start_Date__c,performancelst.get(0).Performance_Period_End_Date__c); 
                      //For Market
                       incentiveCompositePrevious.addCompositeMetricForMarket(compositeMarketCurrentList,marketing_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                       incentiveCompositePrevious.addCompositeMetricForSPWR(compositeSPWRCurrentList,all_spwr_solutions_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                       incentiveCompositePrevious.addCompositeMetricForPbp(compositePerformBPCurrentList,performance_to_business_Plan_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                       // code added as a part of Phase2a on 21 Apr10 
                       incentiveCompositePrevious.addCompositeMetricForTrn(compositeTrainingCurrentList,training_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId);
                       incentiveCalculation();
                       
                       // parent child list call modified on 27/01/10
                       //method to group the composite and their child metric
                        getAllSunpowerMtr();
                        getTrainings();
                        getBussinessPlan();
                        getMarketMtr();
                        getperRevenueTgt();
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
    //check if all the min requirement to acheive incentive is met
    public String getMinRequirementMet()
    {
        Boolean flag=false;
        if(currentTierObj != null && currentTierObj.size()> 0 && this.performanceMetricID!=null)
        {
            List<Metric_Tier_Relation__c> metricTierList = [select Id,Boolean_Metric_Y_N__c,(select Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:this.performanceMetricID and Stay_Tier__c=: true];
           // system.debug('13july'+metricTierList +'/'+metricTierList.size());
            if(metricTierList.size()>0)
            {
                for(Metric_Tier_Relation__c mtr : metricTierList){
              //  system.debug('123july '+mtr );
                 if(mtr != null)
                 {
                     List<Metric__c> mlst = mtr.Metrics__r;
                    // system.debug('1234julyMetric '+mlst.get(0) );
                     if(mlst != null && mlst.size() > 0  )
                     {
                         flag=true;
                         if(mtr.Boolean_Metric_Y_N__c==true)
                         {
                             if(!mlst.get(0).Goal_Met__c) //mlst.get(0).Boolean_Achievement__c
                             {
                                 return 'No';
                             }
                         }
                         else
                         {
                             if(!mlst.get(0).Goal_Met__c)
                             {
                                 return 'No';
                             }
                         }
                      }
                   }
                }
            }
        }
        if(flag)
        return 'Yes';
        else
        return 'No';    
    }
    //calculate the earned Incentives
    public Double getEarnedIncentive()
    {
        Double totalIncentive=0;
        Double csatIncentive=getIncentiveFromList(customer_Satisfaction_Current); 
        list<MetricsDetails> PBpList = changeBack(mtrBPList);
        Double trnIncentive=getIncentiveFromList(PBpList); //Changed form performance_to_business_Plan_Current to PBpList
        list<MetricsDetails> TrainingList = changeBack(mtrTrngList);
        Double pbpIncentive=getIncentiveFromList(TrainingList);//Changed form training_Current to TrainingList
        list<MetricsDetails> MarketList = changeBack(mtrdetailList);
        Double mrktIncentive=getIncentiveFromList(MarketList );//Changed form marketing_Current to MarketList
        list<MetricsDetails> AllSPWList = changeBack(mtrAllSunList);
        Double spwrIncentive=getIncentiveFromList(AllSPWList );//Changed form all_spwr_solutions_Current to AllSPWList    
        totalIncentive=csatIncentive+trnIncentive+pbpIncentive+mrktIncentive+spwrIncentive;
        return totalIncentive;        
    }
    
    public Double getIncentiveFromList(List<MetricsDetails> mdList)
    {
        Double incentive=0;
        for(MetricsDetails md: mdList)
        {
           if(md.meetricTierRel.Boolean_Metric_Y_N__c==true)
           {
               if(md.meetricTierRel.Incentive_Amount__c!=null && (md.metric.Boolean_Achievement__c==true || md.metric.Goal_Met__c==true))
               {
                    incentive=incentive+md.meetricTierRel.Incentive_Amount__c;
               }
           }
           else
           {
               if(md.meetricTierRel.Incentive_Amount__c!=null && md.metric.Goal_Met__c==true)
               {
                   incentive=incentive+md.meetricTierRel.Incentive_Amount__c;
               }
           }   
        }
        return incentive;
    }
    //Calculate total incentive that a partner can get
    public Double getPossibleIncentive()
    {
        Double totalIncentive=0;
        if(currentMetricList!=null && currentMetricList.size()>0)
        {
            for(Metric_Tier_Relation__c mtr : currentMetricList){
                 if(mtr != null)
                 {
                     if(mtr.Incentive_Amount__c!=null)
                     {
                          totalIncentive=totalIncentive+mtr.Incentive_Amount__c;       
                     }
                 }
            }
        }
        return totalIncentive;        
    }
    
    //populate the metric to each category of each tier .
    public void populateCategoriesForTiers(List<Metric_Tier_Relation__c> tierList,Id performanceId,Date expDate,Date startDate,Date endDate){
       if(tierList!= null){
           this.customer_Satisfaction_Current.clear();
           this.training_Current.clear();
           this.performance_to_business_Plan_Current.clear();
           this.marketing_Current.clear();
           this.compositeMarketCurrentList.clear();
           this.compositeTrainingCurrentList.clear();
           this.compositePerformBPCurrentList.clear();
           this.compositeSPWRCurrentList.clear();              
           
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
                                   AutomatedCSATMetric(m.metric,mtr,startDate,endDate);
                               }
                           }//For Manual but not required as data will come from DB
                           else{}
                       }
                       else{
                        Metric__c met = new Metric__c();
                        met.Account__c = this.accountId;
                        met.Metric_Tier_Relation__c = mtr.Id;
                        met.Performance_Metric__c = performanceId;
                        if(mtr.Metric_Input_Type__c.equals('Automated')){
                             AutomatedCSATMetric(met,mtr,startDate,endDate);
                           }//For Manual
                           else
                           {
                               met.Boolean_Achievement__c = false;
                               met.Goal_Met__c=false; 
                           }
                         m.metric=met;                       
                       }
                       this.customer_Satisfaction_Current.add(m);   
                   }
                   else if(mtr.Category__c != null && mtr.Category__c.equals('Training')){
                       
                       if(mtr.Part_Of_Composite_Incentive__c)
                       {
                          this.compositeTrainingCurrentList.add(mtr); 
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
                                    else{}
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
                               this.training_Current.add(m);
                         }                       
                   }
                   else if( mtr.Category__c != null && mtr.Category__c.equals('Performance to Business Plan')){
                       if(mtr.Part_Of_Composite_Incentive__c)
                       {
                          this.compositePerformBPCurrentList.add(mtr); 
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
                                else{}
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
                           this.performance_to_business_Plan_Current.add(m);                      
                         } 
                   }
                   else if( mtr.Category__c != null && mtr.Category__c.equals('Marketing')){
                       if(mtr.Part_Of_Composite_Incentive__c)
                       {
                          this.compositeMarketCurrentList.add(mtr);
                        }
                        else
                        {   
                           m.meetricTierRel = mtr;
                           List<Metric__c> mlst = mtr.Metrics__r;
                           if(mlst != null && mlst.size() > 0  ){
                               m.metric = mlst.get(0);
                               if(mtr.Metric_Input_Type__c.equals('Automated')){
                                  if(expDate > date.newinstance(2010,7,4) && m.metric.Overriden__c==false){ }
                                }
                                else{}
                            }
                            else
                            {
                                Metric__c met = new Metric__c();
                                met.Account__c = this.accountId;
                                met.Metric_Tier_Relation__c = mtr.Id;
                                met.Performance_Metric__c = performanceId;
                                if(mtr.Metric_Input_Type__c.equals('Automated')){}
                                //Manual
                                else
                                {
                                    met.Boolean_Achievement__c = false;
                                     met.Goal_Met__c=false;
                                }
                                m.metric=met;  
                            } 
                           this.marketing_Current.add(m);                     
                         }  
                   }
                   else if(mtr.Category__c != null &&  mtr.Category__c.equals('All SPWR solutions')){
                       if(mtr.Part_Of_Composite_Incentive__c)
                       {
                          this.compositeSPWRCurrentList.add(mtr);
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
                                else{}
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
                           this.all_spwr_solutions_Current.add(m);                       
                        }  
                   }
               }
           }
       }
   }
   //calculation for SPWR automated metric
   private void AutomatedSPWRMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_SALES_KITS)){
           //code changed for phase2a on 19Apr. Boolean Achivement is changed to Double 
           Double achievement=performanceAchievePrevious.computeSEVENTYSALESKITS(this.accountId,startDate,endDate);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achievement);
           
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.OPP_CLOSE_RATE)){
           Double achieve=performanceAchievePrevious.computeOPPCLOSERATE(this.accountId);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if((mtr.Metric_Label__c).trim().equals((PerformanceEvalCst.SEVENTY_RES_KITS_EU).trim())){
          //code added for phase2a on 5/5/10 waiting for confirmation
          Double achievement=performanceAchievePrevious.computeSEVENTYRESKITSEU(this.accountId,startDate,endDate);
          //PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
          performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achievement);
        }
        if((mtr.Metric_Label__c).trim().equals((PerformanceEvalCst.SEVENTY_COM_INVTR_EU).trim())){
           //code added for phase2a on 5/5/10 waiting for confirmation
           Double achievement=performanceAchievePrevious.computeSEVENTYCOMINVTREU(this.accountId,startDate,endDate);
           //PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achievement);
        }
   }
   //calculation for performance to business plan automated metric
   private void AutomatedPbpMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
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
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SIX_MONTHS_TARGET)){
            Double score=performanceAchievePrevious.computeSIXMONTHSTARGET(this.accountId,startDate,endDate);
            performanceAchievePrevious.automatedDoubleGoalCheckKW(m,mtr,score);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.KW_TARGET_EU)){
            Double score=performanceAchievePrevious.computeKWTARGETEU(this.accountId,startDate,endDate);
            performanceAchievePrevious.automatedDoubleGoalCheckKW(m,mtr,score);
        } 
   }
   
   //calculation for training automated metric 
   private void AutomatedTrainingMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
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
        // code added for phase2a on 19Apr10 for training Bonus for Extra 
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_I)){
            Double achieve=performanceAchievePrevious.computeTRAININGADVDESIGN(this.accountId);
            System.debug('TestT'+achieve);//computeEXTRABONUSI
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        // code added for phase2a on 19Apr10 for training Bonus for Extra 
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II)){
            Double achieve=performanceAchievePrevious.computeEXTRABONUSII(this.accountId); //
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_III)){
            Double achieve=performanceAchievePrevious.computeTRAININGADVINSTALL(this.accountId);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,achieve);
        }

 
   } 
   // calculation for customer satisfaction automated metric
   private void AutomatedCSATMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
       if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE) || mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE_EU)){
           Double csatScore=performanceAchievePrevious.computeCSATSCORE(this.accountId,startDate,endDate);  
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,csatScore);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION) || mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_EU)){
           Double siteInspection=performanceAchievePrevious.coumputeSITEINSPECTION(this.accountId,startDate,endDate);  
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,siteInspection);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CUSTOMER_COMPLAINTS)){
            Double complaints=performanceAchievePrevious.coumputeCUSTOMERCOMPLAINTS(this.accountId,startDate,endDate);
            performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,complaints);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PERCENT_INSTALL_CRM)){
           Double percentInstalls=performanceAchievePrevious.computePERCENTINSTALLCRM(this.accountId,startDate,endDate);
           performanceAchievePrevious.automatedDoubleGoalCheck(m,mtr,percentInstalls);
        }
       
   }
   
   public void saveEvaluationIncentive()
   {
        updateMetricRecords();
        String minRequirementMet1=getMinRequirementMet();
        if(minRequirementMet1.equals('Yes'))
        {
            saveTotalIncentive(trId);
        }
   }
   //update evaluation
   public PageReference updateEvaluation()
    {   
        
        updateMetricRecords();
        saveNextData();
        String minRequirementMet1=getMinRequirementMet();
        system.debug('Today123'+minRequirementMet1);
        if(minRequirementMet1.equals('Yes'))
        {
            system.debug('Today1234'+minRequirementMet1);
            saveTotalIncentive(trId);
        }
       //call constructor function
      
         this.retriveIncentiveInfo();
            
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
        
        list<MetricsDetails> PBpList = changeBack(mtrBPList);
        updateAchievement(customer_Satisfaction_Current);

        updateAchievement(PBpList); //Changed form performance_to_business_Plan_Current to PBpList
       incentiveCompositePrevious.updateCompositeMetricForPbp(PBpList); //Changed form performance_to_business_Plan_Current to PBpList

        list<MetricsDetails> TrainingList = changeBack(mtrTrngList);
        updateAchievement(TrainingList);//Changed form training_Current to TrainingList
        //For Market
        list<MetricsDetails> MarketList = changeBack(mtrdetailList);
        updateAchievement(MarketList); //Changed form marketing_Current to MarketList
      incentiveCompositePrevious.updateCompositeMetricForMarket(MarketList);//Changed form marketing_Current to MarketList 
        
        list<MetricsDetails> AllSPWList = changeBack(mtrAllSunList);
        updateAchievement(AllSPWList); //Changed form all_spwr_solutions_Current to AllSPWList
       incentiveCompositePrevious.updateCompositeMetricForSPWR(AllSPWList);//
        
        //Total Incentive
          
        return null;
    }
    public void updateAchievement(List<MetricsDetails> mdList)
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
                        md.metric.Goal_Met__c=true;
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
                                md.metric.Goal_Met__c=true;
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
    //save total incentives
    public void saveTotalIncentive(Id tierId  )
    {
        Double csatIncentive=getIncentiveFromList(customer_Satisfaction_Current);
        list<MetricsDetails> PBpList = changeBack(mtrBPList);
        Double trnIncentive=getIncentiveFromList(PBpList);//Changed form performance_to_business_Plan_Current to PBpList 
        list<MetricsDetails> TrainingList = changeBack(mtrTrngList);
        Double pbpIncentive=getIncentiveFromList(TrainingList );//Changed form training_Current to TrainingList
        list<MetricsDetails> MarketList = changeBack(mtrdetailList);
        Double mrktIncentive=getIncentiveFromList(MarketList );//Changed form marketing_Current to MarketList
        list<MetricsDetails> AllSPWList = changeBack(mtrAllSunList);
        Double spwrIncentive=getIncentiveFromList(AllSPWList );//Changed form all_spwr_solutions_Current to AllSPWList    
        Double totalIncentive=csatIncentive+trnIncentive+pbpIncentive+mrktIncentive+spwrIncentive;
        system.debug('Total I '+totalIncentive);
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
                //listIncentice.get(0).Total_Incentive__c=totalIncentive;
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
        system.debug('qwert123');
        saveQuarterlyIncentive(pdfLimit,totalIncentive,tierId);
    }
    
    //save quaterly incentives
    private void saveQuarterlyIncentive(Double pdfLimit,Double totalIncentive,Id tierId)
    {
        List<Quarterly_Performance_Evaluation__c> quarterIncentice=new List<Quarterly_Performance_Evaluation__c>();
        String currentQuarter=performanceAchievePrevious.getCurrentQuarter();
        String perfmMetricId=this.performanceMetricID;
        String accId=this.accountId;
        if(perfmMetricId!=null && accId!=null)
        {
            quarterIncentice=[select Id,Total_Incentive_QTD__c,Total_Credit_Memo_QTD__c,Account__c,Performance_Metric__c from Quarterly_Performance_Evaluation__c where Account__c=:accId and Performance_Metric__c=:perfmMetricId and Quarter__c=:currentQuarter and Year__c=:(date.newinstance(2010,7,4).year())];
            system.debug('ABC'+quarterIncentice);
            if(quarterIncentice!=null && quarterIncentice.size()>0)
            {
                Double value = 0.0;
                //quarterIncentice.get(0).Total_Incentive_QTD__c=totalIncentive;
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
   //Incentive calculation 
    public void incentiveCalculation()
    {
        Double totIncentive = 0 ;
        Double totCreditMemo = 0 ;
        Double totPDFNum = 0 ;
        Integer qCnt=0;
        if(this.performancelst.size()>0 && currentTierObj.size()>0)
        {
            List<PDF_Limit__c> pdfList = [select Partner__c from PDF_Limit__c where Performance_Metric__c =:this.performancelst.get(0).Id and Tier__c =: currentTierObj.get(0).Id  ];
            if(pdfList != null && pdfList.size() >0){
                this.partnerDevelopmentFunds =  String.ValueOf(pdfList.get(0).Partner__c);
                totPDFNum = pdfList.get(0).Partner__c;
                totalPDF = pdfList.get(0).Partner__c;
            }
        }    
       
        Date tDate1 = date.newinstance(2010,7,4);
        Integer yri = tDate1.year();
        String yr= String.valueOf(yri);
        Double tCreditM=0;
        Double purchaseAmt=0;
        Double npurchase =0;
        Double qNpurchase =0;
        if(performancelst.size()>0)
        {
            List<String> currentQlist = performanceAchievePrevious.getQuartesBetweenDates(performancelst.get(0).Performance_Period_Start_Date__c,tDate1);
            // Changed as a part of phase2a
            String currentQuarter = performanceAchievePrevious.getCurrentQuarter();
            String performancePeriod = performanceAchievePrevious.getCurrentPerformancePeriod(currentQuarter);
            List<order_detail_sunrise2__c> orderDetail = [select Quarter__c,QTD_Net_Purchase_Amount__c,Quarter_Net_Purchase_Amount__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and year__c =:yr ]; //Quarter__c =:quart
            
            if(orderDetail.size() > 0){
                if(orderDetail.get(0).QTD_Net_Purchase_Amount__c!=null){
                    npurchase=orderDetail.get(0).QTD_Net_Purchase_Amount__c;
                }
            }
            for(String quart:currentQlist){
                List<Quarterly_Performance_Evaluation__c> quarterIncentice=[select Id,Total_Incentive_QTD__c,Total_Credit_Memo_QTD__c,Account__c,Performance_Metric__c from Quarterly_Performance_Evaluation__c where Account__c=:this.accountId and Performance_Metric__c=:this.performancelst.get(0).id and Quarter__c = :quart and Year__c=:(date.newinstance(2010,7,4).year())];
                //List<order_detail_sunrise2__c> orderDetail = [select QTD_Net_Purchase_Amount__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Quarter__c =:quart and year__c =:yr ]; 
                if(currentQlist.size()==1 && orderDetail.size() > 0){
                    if(orderDetail.get(0).Quarter__c.equals('Q1')|| orderDetail.get(0).Quarter__c.equals('Q3')){
                        if(quarterIncentice.size()>0 && npurchase!=null)
                        {                   
                            Double qIncentive=quarterIncentice.get(0).Total_Incentive_QTD__c;
                            Double qCreditM=quarterIncentice.get(0).Total_Credit_Memo_QTD__c;
                            if(npurchase  != null && npurchase  > 0 && qIncentive!=null && qIncentive>0)
                            {
                                purchaseAmt +=(npurchase * qIncentive/100);
                                if(qCreditM!=null && qCreditM>0)
                                tCreditM +=(npurchase * qCreditM/100);
                            }
                        }
                    }
                }else{
                    system.debug('Reshma14'+orderDetail.size()+'Reshma141'+qCnt+'Resh'+orderDetail);
                    if(orderDetail.size() > 0 && (orderDetail.get(0).Quarter__c.equals('Q2')|| orderDetail.get(0).Quarter__c.equals('Q4'))){
                        system.debug('Reshma151');
                        if(qCnt == 0){
                                if(orderDetail.size() > 0){
                                    if(orderDetail.get(0).Quarter_Net_Purchase_Amount__c!=null){
                                        qNpurchase = orderDetail.get(0).Quarter_Net_Purchase_Amount__c;
                                        system.debug('Reshma15'+qNpurchase);
                                    }
                                    qCnt++;
                                }
                        }else{
                            if(orderDetail.size() > 0){
                                if(orderDetail.get(0).Quarter_Net_Purchase_Amount__c!=null && orderDetail.get(0).QTD_Net_Purchase_Amount__c!=null){
                                    qNpurchase = orderDetail.get(0).QTD_Net_Purchase_Amount__c - orderDetail.get(0).Quarter_Net_Purchase_Amount__c;
                                    system.debug('Reshma16'+qNpurchase);
                                }
                            }
                        }
                        if(quarterIncentice.size()>0){
                            Double qIncentive=quarterIncentice.get(0).Total_Incentive_QTD__c;
                            Double qCreditM=quarterIncentice.get(0).Total_Credit_Memo_QTD__c;
                            if(qNpurchase  != null && qNpurchase  > 0 && qIncentive!=null && qIncentive>0)
                                {
                                    purchaseAmt +=(qNpurchase * qIncentive/100);
                                    if(qCreditM!=null && qCreditM>0)
                                    tCreditM +=(qNpurchase * qCreditM/100);
                                }
                        }
                    }
                }
                
            }
            this.netPurchase=0;
            this.netPurchase=npurchase;
           /* List<order_detail_sunrise2__c> orderDetail = [select QTD_Net_Purchase_Amount__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Quarter__c in :currentQlist and year__c =:yr ]; 
            for(order_detail_sunrise2__c os:orderDetail)
            {
                this.netPurchase += os.QTD_Net_Purchase_Amount__c;
            }*/
        }
        
        
        if(purchaseAmt  != null && purchaseAmt  > 0 )
        {
            this.totalFunds = String.valueOf(Decimal.valueOf(purchaseAmt).setScale(2) );   
            if(tCreditM!=null )//&& tCreditM>0
            {
                this.PDFNumber = String.valueOf(Decimal.valueOf(purchaseAmt - tCreditM).setScale(2) );
                this.creditMemoNumber = String.valueOf(Decimal.valueOf(tCreditM).setScale(2) );
            }    
        }
        
    }
    
    public Double getnetAmount(){
        return netPurchase;
    }
     public Double gettotalPDFNumber(){
        return totalPDF;
    }
    
    public String getDateFormat(Date myDT){
        String ddttmm =null;
        if(myDT!=null){
            Datetime myDate = Datetime.newInstance(myDT.year(),myDT.month(),myDT.day(),0,0,0);
            ddttmm =myDate.format('MM/dd/yyyy');
        }
        return ddttmm;    
    }  
    public PageReference backToAccount(){
        return new PageReference('/'+this.accountId);
    }
   /*** Code for formula fields**/
   
   public void setshipBonus(Double s){
       shipBonus = s;
   }
   public Double getshipBonus(){
       return shipBonus;
   }
   public void setBonus(Double b){
       Bonus = b;
   }
   public Double getBonus(){
       return Bonus;
   }
   public Double getPfContri(){
       if(shipBonus!= null && Bonus!=null){
           if(totalPDF!=null && totalPDF<=Bonus)
           {
               PfContri = shipBonus * (totalPDF/100);
           }
           else
           {
               PfContri = shipBonus * (Bonus/100);
           }    
       }
       return PfContri;    
   }
   public Double getChckRwd(){
       if(Bonus!=null){
           if((Bonus - totalPDF )>0){
               ChckRwd = (((Bonus - totalPDF)/100)*shipBonus);
            }
           else if(totalPDF!=null && totalPDF>=Bonus)
           {
               ChckRwd=0;
           } 
       }
       return ChckRwd;
   }
   
  
   public void button(){
      isactive = true;

   }
   public boolean getisactive(){
       return isactive;
   }
   
   public String getTname(){
     if(currentTierObj!=null && currentTierObj.size()>0)
     {      
       for(Tier__c t :currentTierObj){
         if(t.Tier_Name__c!=null)  
          tname= t.Tier_Name__c;
       }
     }  
       return tname;
   }
   
  
   public Double gettotBonus(){
       if(shipBonus!= null && Bonus!=null){
           totBonus = (shipBonus * Bonus)/100;
       }    
       return totBonus;
   }
   
   /***end**/
   
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
    
    /***/
    //Inner class to the dropdown function of the metric
    public class MtrDetail{
        Public MetricsDetails  mtrP  { get; set; }
        Public list<MetricsDetails> mtrC  { get; set; }
        public Boolean expand {get;set;}
        public MtrDetail(){
            mtrP = new MetricsDetails();
            mtrC = new list<MetricsDetails>();
            expand = false;
        }
        
    }
   

   // Split the metric as parent and Child[MtrDetail]
   public void splitMetric(list<MetricsDetails> mdlist){
       for(MetricsDetails m:mdlist ){//this.marketing_Current
           if(m.meetricTierRel.Incentive_Amount__c >0){
               mtrlistP.add(m);  
           }else{
               mtrlistC.add(m);
               
           }
       }
   }

   
   public list<MtrDetail> getMarketMtr(){
       if(mtrdetailList.size()==0){
       splitMetric(this.marketing_Current);
       for(MetricsDetails md:mtrlistP){
           MtrDetail mnew = new MtrDetail();
           if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.FOUR_MARKET_EU )){ //4 Marketing requirements met
               mnew.mtrP =  md; 
               for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_AUTH_FOUR_M1)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_AUTH_FOUR_M2)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_AUTH_FOUR_M3)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_AUTH_FOUR_M4)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKETADV)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKETPR)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKETLogo)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M1)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M7)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M6)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_BANNER)){
                        mnew.mtrC.add(md1);    
                   }
                                       
               }
              mtrdetailList.add(mnew);
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MEET_SIX_MARKET)){
               mnew.mtrP =  md;
               for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_WRAP)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_JOB)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_USA_M4)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_USA_M2)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_CERT)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKETADV)){
                       mnew.mtrC.add(md1);   
                   }
               }
               mtrdetailList.add(mnew);
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_USA_M3)){
               mnew.mtrP =  md;
               mtrdetailList.add(mnew);
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_SALEKIT)){
               mnew.mtrP =  md;
               mtrdetailList.add(mnew);    
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SEVEN_MARKET_EU)){
               mnew.mtrP =  md;
               for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M1)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M4)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M6)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M2)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M7)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M3)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_EU_PREM_SEV_M5)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKETADV)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKETPR)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKETLogo)){
                       mnew.mtrC.add(md1);   
                   }
               }
               mtrdetailList.add(mnew);
           }
           
       }
       }
        if(mtrdetailList.size()>0){
        mkt = true;
        }
       return mtrdetailList;
   }
   

   public list<MtrDetail> getBussinessPlan(){
       if(mtrBPList.size()==0){
       splitMetric(this.performance_to_business_Plan_Current);
       for(MetricsDetails md:mtrlistP){
           MtrDetail mnew = new MtrDetail();
           if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES )){ //4 Marketing requirements met
               mnew.mtrP =  md; 
               for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_1)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_2)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_3)){
                        mnew.mtrC.add(md1); 
                   }
               }
              mtrBPList.add(mnew);
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SIX_MONTHS_TARGET)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew);
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.EXCEP_FOREST)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew);    
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.KW_TARGET_EU)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew); 
           } else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES_EU )){ //4 Marketing requirements met
               mnew.mtrP =  md; 
               for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_1)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_2)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_3)){
                        mnew.mtrC.add(md1); 
                   }
               }
              mtrBPList.add(mnew);
           }
           
       }
       }
       return mtrBPList;
   }
  
   //code changed for phase2a on 21 Apr 10 
   public list<MtrDetail> getTrainings(){
       if(mtrTrngList.size()==0){
            splitMetric(this.training_Current);
            for(MetricsDetails md:mtrlistP){
               MtrDetail mnew = new MtrDetail();
               if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS)){
                   mnew.mtrP =  md;
                   for(MetricsDetails md1:mtrlistC){
                        if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_I)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_III)){
                            mnew.mtrC.add(md1); 
                        }
                   }
                   mtrTrngList.add(mnew);
               }
            }
       }
       return mtrTrngList;
   }
   

   public list<MtrDetail> getAllSunpowerMtr(){
     if(mtrAllSunList.size()==0){
       splitMetric(this.all_spwr_solutions_Current);
       for(MetricsDetails md:mtrlistP){
           MtrDetail mnew = new MtrDetail();
           if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MEET_SIX_SWPR)){ //'If 6 or more of the above are met'
               mnew.mtrP =  md; 
               for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M4)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M5)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M9)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M3)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M7)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M8)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M2)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M6)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_M1)){
                        mnew.mtrC.add(md1); 
                   }
               }
              mtrAllSunList.add(mnew);
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SEVENTY_SALES_KITS)){ //'Bonus for SmartPack Usage'
               mnew.mtrP =  md;
               mtrAllSunList.add(mnew);    
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.ALL_SWPR_EU )){ //Meet all SPWR Solutions
               mnew.mtrP =  md; 
               for(MetricsDetails md1:mtrlistC){
                   String str1='greater than 70 of  Residential sales are systems'.trim();
                   String str2='greater than 70 of  Commercial sales include Inverter'.trim();
                   if((md1.meetricTierRel.Metric_label__c).trim().equals(str1) || (md1.meetricTierRel.Metric_label__c).trim().equals(str2)){
                        mnew.mtrC.add(md1); 
                   }
               }
              mtrAllSunList.add(mnew);
           }
           
       }
       }
       return mtrAllSunList;
   }
   //method to change back to MetricsDetails 
   public list<MetricsDetails> changeBack(list<MtrDetail> mlist){
       list<MetricsDetails> mdlist = new list<MetricsDetails>();
       for(MtrDetail m:mlist){
         MetricsDetails md = new MetricsDetails();
         md = m.mtrP;
         mdlist.add(md);
         if(m.mtrC.size()>0){
             for(MetricsDetails mc:m.mtrC){
                
                 mdlist.add(mc);        
             }
         }
       }
       return mdlist;
   }
   
 
   
   public void showAllsun(){
       String sId = ApexPages.currentPage().getParameters().get('sId');
       for(MtrDetail mr: mtrAllSunList){
           if(mr.mtrP.meetricTierRel.Id == sId){
               if(mr.expand){
                   mr.expand = false;
               }else{
                   mr.expand = true;
               }
               
           }
           else{
               mr.expand = false;
           }
       }
   }
   
   public void showMkt(){
       String mkId = ApexPages.currentPage().getParameters().get('mkId');
       for(MtrDetail mr: mtrdetailList){
           if(mr.mtrP.meetricTierRel.Id == mkId){
               if(mr.expand){
                   mr.expand = false;
               }else{
                   mr.expand = true;
               }
               
           }
           else{
               mr.expand = false;
           }
       }
   }
   
   public void showPb(){
       String pbId = ApexPages.currentPage().getParameters().get('pbId');
       for(MtrDetail mr: mtrBPList){
           if(mr.mtrP.meetricTierRel.Id == pbId){
               if(mr.expand){
                   mr.expand = false;
               }else{
                   mr.expand = true;
               }
               
           }
           else{
               mr.expand = false;
           }
       }
   }
   
   public void showTrg(){
       String trId = ApexPages.currentPage().getParameters().get('trId'); 
       for(MtrDetail mr: mtrTrngList){
           if(mr.mtrP.meetricTierRel.Id == trId){
               if(mr.expand){
                   mr.expand = false;
               }else{
                   mr.expand = true;
               }
               
           }
           else{
               mr.expand = false;
           }
       }
   }
  public order_detail_sunrise2__c ordSun {get;set;}
  
    public void getperRevenueTgt(){
       /* for(MtrDetail mr: mtrBPList){
            if(mr.mtrP.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.KW_TARGET_EU)||mr.mtrP.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SIX_MONTHS_TARGET)){
               if(mr.mtrP.metric.Metric_Min_Value__c!= null && mr.mtrP.metric.Metric_Max_Value__c!= null){
                   perRvneTrgt =  String.valueOf(mr.mtrP.metric.Metric_Min_Value__c) +'-'+ String.valueOf(mr.mtrP.metric.Metric_Max_Value__c);
               }else if(mr.mtrP.metric.Metric_Min_Value__c == null){
                   perRvneTrgt = String.valueOf(mr.mtrP.metric.Metric_Max_Value__c);
               }else if(mr.mtrP.metric.Metric_Max_Value__c== null){
                   perRvneTrgt = String.valueOf(mr.mtrP.metric.Metric_Min_Value__c);
               }
                
            }
        }
        return perRvneTrgt;*/
       
        String year_c=''+date.newinstance(2010,7,4).year();
        String currentQuarter_c = performanceAchievePrevious.getCurrentQuarter();
        String performancePeriod_c = performanceAchievePrevious.getCurrentPerformancePeriod(currentQuarter_c);
        ordsun= new order_detail_sunrise2__c();
        List<order_detail_sunrise2__c> ordList = new List<order_detail_sunrise2__c>();
        ordList = [select QTD_Net_Purchase_Amount__c from order_detail_sunrise2__c where Year__c =:year_c and Performance_Period__c=:performancePeriod_c and Account_Name__c=:this.accountId];
        if(ordList.size() > 0){
            ordsun = ordList.get(0);
        }
        //if(ordSun.size() > 0){
            //if(ordSun.get(0).QTD_Net_Purchase_Amount__c!=null){
                //perRvneTrgt = ordSun.get(0).QTD_Net_Purchase_Amount__c ;
                //if(ordSun.QTD_Net_Purchase_Amount__c!=null){
                //return ordSun.QTD_Net_Purchase_Amount__c;//perRvneTrgt;
            //}
        //}
       // return 0;
        
    }
    
    public Boolean getTrnlFlag(){
    list<MtrDetail> Trngl= getTrainings(); 
        if(Trngl.size()>0)
            return true;
        else
            return false;
    }
    public Boolean getPbplFlag(){
    list<MtrDetail> BPl = getBussinessPlan(); 
        if(BPl.size()>0)
            return true;
        else
            return false;
    }
    
    public Boolean getMrklFlag(){
    list<MtrDetail> mktl = getMarketMtr(); 
        if(mktl.size()>0)
            return true;
        else
            return false;
    }
    public Boolean getSpwrlFlag(){
    list<MtrDetail> spwl = getAllSunpowerMtr(); 
        if(spwl.size()>0)
            return true;
        else
            return false;
    } 
    
    
    //Save Data to next tier
    public void saveNextData(){
        String nextTier = null;
        if(this.partnerTier!=null){
             nextTier = PerformanceEvalCst.tierMap.get(this.partnerTier);
        }
        if(nextTier!=null ){
            Account acc1 = [Select Country_Domain__c from Account where Id=:this.accountId];
            String accCountryDomain1 = acc1.Country_Domain__c;
            if(accCountryDomain1 != null ){
                   if(accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1,accCountryDomain1.length()).equals('us')){
                       if(accCountryDomain1.Substring(0,accCountryDomain1.indexOf('-')).equals('rvar') || accCountryDomain1.Substring(0,accCountryDomain1.indexOf('-')).equals('combo')){
                           accCountryDomain1 = accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1 ,accCountryDomain1.length());
                       }
                   }
                   else if((accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1,accCountryDomain1.length()).equals('it'))||(accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1,accCountryDomain1.length()).equals('de'))){
                           accCountryDomain1 = accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1 ,accCountryDomain1.length());
                   }
            }
            String countryfullname ='';
            if(accCountryDomain1 != null){
                countryfullname = PerformanceEvalCst.countryMap.get(accCountryDomain1);
            }
            Tier__c tc = [select Id,Tier_Name__c from Tier__c where Tier_Name__c =:this.partnerTier and country__c =:countryfullname limit 1];
            Tier__c tcn = [select Id,Tier_Name__c from Tier__c where Tier_Name__c =:nextTier and country__c =:countryfullname limit 1];
            List<Metric__c> mlistmc = [select Id,Boolean_Achievement__c,Metric_Description__c from Metric__c where Metric_Tier_Relation__r.Tier__c=:tc.Id and Performance_Metric__c =:performancelst.get(0).Id and account__c=:this.accountId and (Metric_Tier_Relation__r.Metric_Label__c='RSM Objective1'OR Metric_Tier_Relation__r.Metric_Label__c='RSM Objective2'OR Metric_Tier_Relation__r.Metric_Label__c='RSM Objective3')];
            List<Metric__c> mlistm = [select Id,Boolean_Achievement__c,Metric_Description__c from Metric__c where Metric_Tier_Relation__r.Tier__c=:tcn.Id and Performance_Metric__c =:performancelst.get(0).Id and account__c=:this.accountId and (Metric_Tier_Relation__r.Metric_Label__c='RSM Objective1'OR Metric_Tier_Relation__r.Metric_Label__c='RSM Objective2'OR Metric_Tier_Relation__r.Metric_Label__c='RSM Objective3')];
            for(Metric__c m : mlistmc){
                for(Metric__c m1 : mlistm){
                    if(m.Metric_Description__c.equals(m1.Metric_Description__c)){
                        system.debug('colors'+m.Boolean_Achievement__c+'/'+m);
                        m1.Boolean_Achievement__c = m.Boolean_Achievement__c;
                        system.debug('zee'+m1);
                        update m1;
                        system.debug('zee1'+m1);
                    }
                }
            }
        }
    }
}