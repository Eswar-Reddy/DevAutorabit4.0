public with sharing class IncentiveDetailPrevCommController {
    private Performance_Metric__c currentPM;
    public String period;
    public String year;
    public String previousType;
    public Date prevDate_2010 ;//= Date.newInstance(2010,12,31);
    public String accountId; 
    final String  ACCOUNT_CHANNEL_NAME ='Commercial';
    String UserId= userInfo.getuserId();
    String UserName= userInfo.getName();
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
    public Boolean isPartnerCombo{get;set;}
    public double netPurchaseAmt{get;set;}
    public boolean isSchedular{get;set;}
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
        if(PerformanceEvalCst.profileHideHeaderForPartner.contains(userprofile.Name) || isPartnerCombo){
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
       /*
       if(PerformanceEvalCst.profileDisableEditButton.contains(userprofile.Name)){
          return false;
       }else{
          return true;
       }*/
       if(PerformanceEvalCst.roleEditButton.contains(userrole.Name) || userprofile.Name == 'System Administrator'){
            return true;
       }else{
            return false;
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
  
    public IncentiveDetailPrevCommController(){
        isSchedular = false;
        //accountId = ApexPages.currentPage().getParameters().get('accId');
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
        this.retriveIncentiveInfo();
    }
    //For APEX Scheduler
    //START 
       public IncentiveDetailPrevCommController(String accId,String PrevPeriod,String PrevYear)
        { isSchedular = true;
            this.isPartnerCombo = false;
            if(accId!=null && PrevPeriod != null && PrevYear!= null)
            {
                accountId =accId; 
                period = 'P' + PrevPeriod;
                year = PrevYear;
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
        //PerformanceAchievementComm.updatePrevEvalDate(prevDate_2010); 
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
                  
                   if(acc.Type != null && PerformanceEvalCst.PARTNER_TYPE_COMBO.contains(acc.Type)){
                        isPartnerCombo = true;
                   }else{
                        isPartnerCombo = false;
                   }
                   
                   /**extract Partner Type and Partner Tier**/
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
                   }
                   String country_full_name ='';
                   //Date tdat = Date.Today();
                   System.debug('=======accCountryDomain======change::'+accCountryDomain);
                   if(accCountryDomain != null){
                        comingSoon= PerformanceEvalCst.comingSoonMap.get(accCountryDomain);
                        country_full_name = PerformanceEvalCst.countryMap.get(accCountryDomain);
                   }
                   System.debug('=======country_full_name======change::'+country_full_name);
                   if( accCountryDomain != null && accCountryDomain.equals('us')){
                      //performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                      this.performancelst = [select open_edit_date__c,calculation_End_Date__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and Performance_Year__c=:Integer.valueOf(year) and  Performance_Period__c=:period ];
                       if(performancelst.size()== 0){
                         //this.performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  order by createdDate asc limit 1 ];
                         this.performancelst = [select open_edit_date__c,calculation_End_Date__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  order by createdDate desc limit 1 ];                          
                       }
                   }
                   else if(accCountryDomain != null && ( accCountryDomain.equals('it')||accCountryDomain.equals('de') )){
                       //performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                       this.performancelst = [select open_edit_date__c,calculation_End_Date__c,User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and Performance_Year__c=:Integer.valueOf(year) and  Performance_Period__c=:period ];
                        
                      if(performancelst.size()==0){
                        // this.performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name)  order by createdDate asc limit 1 ];
                        this.performancelst = [select open_edit_date__c,calculation_End_Date__c,User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name)  order by createdDate asc limit 1 ];
                      }
                   }
                   System.debug('Debug::::: Point :: PRakash ::: 1');
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
                       currentPM = performancelst.get(0);
                   }
                   System.debug('Debug::::: Point :: PRakash ::: 2');
                   
                   if(currentPM == null){
                        return;
                   }
                   
                   System.debug('Debug::::: Point :: PRakash ::: 3');
                   /*Querying previous account type from AccountHistory records:Hemant */
                   if(performancelst != null && performancelst.size() > 0)
                    prevDate_2010 = performancelst.get(0).calculation_End_Date__c;
                   if(prevDate_2010 != null){
                    PerformanceAchievementClass.updatePrevEvalDate(prevDate_2010);
                    PerformanceAchievementComm.updatePrevEvalDate(prevDate_2010); 
                   } 
                    System.debug('Debug::::: Point :: PRakash ::: 4');
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
                   /*
                   if(accCountryDomain != null ){
                       List<Tier__c> tObj = [select Id from Tier__c where Tier_Name__c=: partnerTier and Country__c =:country_full_name];
                       if(tObj!=null && tObj.size()>0)
                       trId=tObj.get(0).Id;
                   }
               */
                   
                   
                   
                   
                   /**retrive the PDF values**/
                  
                   //for benefit tier
                   if(performancelst != null && performancelst.size() > 0){
                   //currentMetricList = [select isRSMView__c,Metric_Description__c,Manual_Partner__c,Tier__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c, ParentMetricRelation__c,Part_Of_Composite_Incentive__c,HelpText__c,(select Overriden__c,Metric_Description__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c,Incentive_Amount__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Performance_Metric__c=:performancelst.get(0).Id and Benefit_Tier__c=: true  ORDER by Sequence_Order__c];
                     currentMetricList = [select isRSMView__c,Metric_Description__c,Manual_Partner__c,Tier__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c, ParentMetricRelation__c,Part_Of_Composite_Incentive__c,HelpText__c,(select Overriden__c,Metric_Description__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c,Incentive_Amount__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where  Performance_Metric__c=:performancelst.get(0).Id and Benefit_Tier__c=: true ORDER by Sequence_Order__c];
                 
                   }if(currentMetricList!=null && currentMetricList.size()>0){                             
                      System.debug('***Hemant*****currentMetricList'+currentMetricList);
                      this.performanceMetricID=performancelst.get(0).Id;
                      this.populateCategoriesForTiers(currentMetricList,performancelst.get(0).Id,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Performance_Period_Start_Date__c,performancelst.get(0).Performance_Period_End_Date__c); 
                      System.debug('================1.training_Current=========='+training_Current);
                      System.debug('================1.performance_to_business_Plan_Current=========='+performance_to_business_Plan_Current);
                      //For Market
                      //IncentiveCompositePrevController.addCompositeMetricForMarket(compositeMarketCurrentList,marketing_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                      //IncentiveCompositePrevController.addCompositeMetricForSPWR(compositeSPWRCurrentList,all_spwr_solutions_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                      IncentiveCompositePrevController.addCompositeMetricForPbp(compositePerformBPCurrentList,performance_to_business_Plan_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId);                    
                      System.debug('================performance_to_business_Plan_Current=========='+performance_to_business_Plan_Current);
                      // code added as a part of Phase2a on 21 Apr10 
                      System.debug('================compositeTrainingCurrentList=========='+compositeTrainingCurrentList);
                      IncentiveCompositePrevController.addCompositeMetricForTrn(compositeTrainingCurrentList,training_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId);
                      incentiveCalculation();
                      System.debug('================3.training_Current=========='+training_Current);
                      // parent child list call modified on 27/01/10
                      //method to group the composite and their child metric
                      //getAllSunpowerMtr();
                      getTrainings();
                      getBussinessPlan(); 
                     // getMarketMtr();
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
        if(this.performanceMetricID!=null)
        {
            List<Metric_Tier_Relation__c> metricTierList = [select Id,Boolean_Metric_Y_N__c,(select Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Performance_Metric__c=:this.performanceMetricID and Stay_Tier__c=: true];
            if(metricTierList.size()>0)
            {
                for(Metric_Tier_Relation__c mtr : metricTierList){
                 if(mtr != null)
                 {
                     List<Metric__c> mlst = mtr.Metrics__r;
                     
                     if(mlst != null && mlst.size() > 0  )
                     {
                         flag=true;
                         if(mtr.Boolean_Metric_Y_N__c==true)
                         {
                             if(!mlst.get(0).Boolean_Achievement__c)
                             {
                                 System.debug('========1.Failing to meet goal====mtr=='+mtr);
                                 System.debug('========1.Failing to meet goal====mlst.get(0)=='+mlst.get(0));
                                 return 'No';
                             }
                         }
                         else
                         {
                             if(!mlst.get(0).Goal_Met__c)
                             {
                                 System.debug('========2.Failing to meet goal====mtr=='+mtr);
                                 System.debug('=====mlst.size()====='+mlst.size());
                                 System.debug('=====mlst====='+mlst);
                                 System.debug('========2.Failing to meet goal====mlst.get(0)=='+mlst.get(0));
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
                       System.debug('=====CUSTOMER SATISFACTION mtr===='+mtr);
                       m.meetricTierRel = mtr;
                       List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                       if(mlst != null && mlst.size() > 0 ){
                           m.metric = mlst.get(0);
                           if(mtr.Metric_Input_Type__c.equals('Automated')){
                              if(expDate > Date.Today() && m.metric.Overriden__c==false){ 
                                   AutomatedCSATMetric(m.metric,mtr,startDate,endDate);
                               }
                           }else{
                               //For Manual but not required as data will come from DB
                           }
                       }
                       else{
                        Metric__c met = new Metric__c();
                        met.Account__c = this.accountId;
                        met.Metric_Tier_Relation__c = mtr.Id;
                        met.Performance_Metric__c = performanceId;
                        if(mtr.Metric_Input_Type__c.equals('Automated')){
                             AutomatedCSATMetric(met,mtr,startDate,endDate);
                        }else{
                            //For Manual
                            met.Boolean_Achievement__c = false;
                            met.Goal_Met__c=false; 
                        }
                        m.metric=met;                       
                       }
                       this.customer_Satisfaction_Current.add(m);   
                   }else if(mtr.Category__c != null && mtr.Category__c.equals('Training')){
                       System.debug('===Training = 1.======='+mtr.metric_label__c);
                       if(mtr.Part_Of_Composite_Incentive__c) {
                           System.debug('===Training= 2.======='+mtr.metric_label__c);
                           this.compositeTrainingCurrentList.add(mtr); 
                       }else{
                           m.meetricTierRel = mtr;                          
                           List<Metric__c> mlst = mtr.Metrics__r;
                           if(mlst != null && mlst.size() > 0  ){                           
                               m.metric = mlst.get(0);
                               if(mtr.Metric_Input_Type__c.equals('Automated')){
                                 if(expDate > Date.Today() && m.metric.Overriden__c==false){
                                     AutomatedTrainingMetric(m.metric,mtr,startDate,endDate);
                                 }
                               }else{
                                //Manual
                               }                                                                                    
                            }else{
                                Metric__c met = new Metric__c();
                                met.Account__c = this.accountId;
                                met.Metric_Tier_Relation__c = mtr.Id;
                                met.Performance_Metric__c = performanceId;
                                if(mtr.Metric_Input_Type__c.equals('Automated')){
                                    AutomatedTrainingMetric(met,mtr,startDate,endDate);
                                }else{
                                    met.Boolean_Achievement__c = false;
                                    met.Goal_Met__c=false; 
                                }
                                m.metric=met;  
                            } 
                            this.training_Current.add(m);
                         }                       
                   }else if( mtr.Category__c != null && mtr.Category__c.equals('Performance to Business Plan')){
                       system.debug('======mtr======'+mtr);
                       if(mtr.Part_Of_Composite_Incentive__c){
                          System.debug('===PBP= 2.======='+mtr.metric_label__c);
                          this.compositePerformBPCurrentList.add(mtr); 
                       }else{   
                           m.meetricTierRel = mtr;
                           List<Metric__c> mlst = mtr.Metrics__r;
                           system.debug('======mtr======'+mtr);
                           if(mlst != null && mlst.size() > 0  ){
                               m.metric = mlst.get(0);
                               if(mtr.Metric_Input_Type__c.equals('Automated')){
                                  if(expDate >= Date.Today() && m.metric.Overriden__c==false){ 
                                    AutomatedPbpMetric(m.metric,mtr,startDate,endDate);
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
                                    AutomatedPbpMetric(met,mtr,startDate,endDate);
                                }else{
                                    //For Manual
                                    met.Boolean_Achievement__c = false;
                                    met.Goal_Met__c=false; 
                                }  
                                m.metric=met;
                           }      
                           this.performance_to_business_Plan_Current.add(m);                      
                         } 
                   }                                
               }
           }
       }
   }
  
   //calculation for performance to business plan automated metric
   private void AutomatedPbpMetric(Metric__c m, Metric_Tier_Relation__c mtr, Date startDate, Date endDate){
        //C-19 Must be an Active Dealer
        //Modified By Neeraj as per function structure
        Map<String,boolean> mapActiveDealerMetricAchievement = new Map<String,boolean>();  
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR)){
            mapActiveDealerMetricAchievement = PerformanceAchievementComm.mustBeAnActiveDealer(this.accountId, startDate, endDate);
            Boolean achievement=false;
            if(mapActiveDealerMetricAchievement.size()>0){
                achievement=true;
            } 
            PerformanceAchievementComm.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        
        //C-26 SunPower Share of Account (PV purchases in kW)  
        /*
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR)){
            Double sunpowerShare = PerformanceAchievementComm.calculatePVPurchasesInKw(this.accountId, startDate, endDate);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, sunpowerShare);
        }*/
        
        //C-24- Credit Limit Maintained 
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PBP_CREDIT_LINE_MAINTAINED_CVAR)){
            Boolean isMaintained = PerformanceAchievementComm.isCreditLineMaintained(this.accountId, startDate, endDate);
            PerformanceAchievementComm.automatedBooleanGoalCheck(m, mtr, isMaintained);
        }
        
        //C-5 SunPower Installations Registered at CRM
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.INSTALLATIONS_REGISTERED_CVAR)){
            System.debug('===============Entered in=========== '+mtr.Metric_Label__c);
            Double installations = PerformanceAchievementComm.calcInstallationsRegistered(accountId, startDate, endDate);               
            System.debug('===============installations=========== '+installations);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, installations);
        }
        
        //TODO: 2 other metrics are remaining(not clear)
        //C-25 SunPower and Dealer Growth Plan - semi-annual                      
   }
   
   //calculation for training automated metric 
   private void AutomatedTrainingMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate) {
        //C-14.1 Training: Fundamentals of Commercial Design 
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_DESIGN_CVAR)){
           Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocDesign(this.accountId);
           PerformanceAchievementComm.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-15.1 Training: Fundamentals of Commercial Installation
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_INSTALL_CVAR)){
            Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocInstall(this.accountId);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-16.1 Training: Fundamentals of Commercial Sales
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_SALES_CVAR)){
           Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocSales(this.accountId);
           PerformanceAchievementComm.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-14.2 Training: Associate Commercial Design Certification
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_DESIGN_CERT_CVAR)){
           Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocDesignCert(this.accountId);
           PerformanceAchievementComm.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-15.2 Training: Associate Commercial Installation Certification
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_INSTALL_CERT_CVAR)){
            Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocInstallCert(this.accountId);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //C-16.2 Training: Associate Commercial Sales Certification
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_SALES_CERT_CVAR)){
           Double achieve = PerformanceAchievementComm.calcTrainingFundCommDesignAssocSalesCert(this.accountId);
           PerformanceAchievementComm.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
   } 
   
   // calculation for customer satisfaction automated metric
   private void AutomatedCSATMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate){      
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
        /* if(mtr.Metric_Label__c.equals(PerformanceEvalCst.INSTALLATIONS_REGISTERED_CVAR)){
            System.debug('===============Entered in=========== '+mtr.Metric_Label__c);
            Double installations = PerformanceAchievementComm.calcInstallationsRegistered(accountId, startDate, endDate);               
            System.debug('===============installations=========== '+installations);
            PerformanceAchievementComm.automatedDoubleGoalCheck(m, mtr, installations);
        }  */                
   }
   
   public void saveEvaluationIncentive(){
        updateMetricRecords();
        String minRequirementMet1=getMinRequirementMet();
        System.debug('============minRequirementMet1======='+minRequirementMet1);
        //if(minRequirementMet1.equals('Yes')){
            saveTotalIncentive();
        //}
   }
   
   //update evaluation
   public PageReference updateEvaluation(){  
        //Metrics should not update if the Performance Metric period they are 
        //related to is not current (TODAY > Performance Period End Date).
        if(currentPM == null)
            return null;   
            
        system.debug('====currentPM.open_edit_date__c======='+currentPM.open_edit_date__c);
        //Case-
        updateMetricRecords();
       
        //saveNextData();
        String minRequirementMet1=getMinRequirementMet();
        System.debug('====minRequirementMet1===='+minRequirementMet1);
        //Now it is not necessary to met all the requirements for Bonus Calculation
        //if(minRequirementMet1.equals('Yes')){
            saveTotalIncentive();
        //}
        
        //call constructor function
      
        this.retriveIncentiveInfo();
            
        return null;
    }
    
    public PageReference updateMetricRecords(){ 
        //Metrics should not update if the Performance Metric period they are 
        //related to is not current (TODAY > Performance Period End Date).
        if(currentPM == null)
            return null;    
        this.disableButton = true;
        /* Done for the case # 00049203 on 3Feb2011 */
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
        
        Date expdate;
        if(this.paramExpDate!=null)
        {
            expdate=Date.valueof(this.paramExpDate);
        }

        list<MetricsDetails> PBpList = changeBack(mtrBPList);
        updateAchievement(customer_Satisfaction_Current);

        updateAchievement(PBpList); //Changed form performance_to_business_Plan_Current to PBpList
        IncentiveCompositePrevController.updateCompositeMetricForPbp(PBpList); //Changed form performance_to_business_Plan_Current to PBpList

        list<MetricsDetails> TrainingList = changeBack(mtrTrngList);
        updateAchievement(TrainingList);//Changed form training_Current to TrainingList
        //For Market
        //list<MetricsDetails> MarketList = changeBack(mtrdetailList);
        //updateAchievement(MarketList); //Changed form marketing_Current to MarketList
        //IncentiveCompositePrevController.updateCompositeMetricForMarket(MarketList);//Changed form marketing_Current to MarketList 
        
        //list<MetricsDetails> AllSPWList = changeBack(mtrAllSunList);
        //updateAchievement(AllSPWList); //Changed form all_spwr_solutions_Current to AllSPWList
        //IncentiveCompositePrevController.updateCompositeMetricForSPWR(AllSPWList);//
        
        //Total Incentive
          
        return null;
    }
    
    public void updateAchievement(List<MetricsDetails> mdList){
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
                        if(!md.meetricTierRel.isRSMView__c){
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
                        //Is RSM view true then min value is stored in Metric object
                        else{
                            if(md.metric.Metric_Min_Value__c!=null)
                            {
                                Double min=md.metric.Metric_Min_Value__c;
                                achieve=md.metric.Achievement_Value__c;
                                if(achieve>=min){
                                    md.metric.Goal_Met__c=true;                                 
                                }
                                else{
                                    md.metric.Goal_Met__c=false;  
                                }
                                requiredLimit  = min;
                            }
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
    public void saveTotalIncentive(){
        Double csatIncentive = getIncentiveFromList(customer_Satisfaction_Current);
        list<MetricsDetails> PBpList = changeBack(mtrBPList);
        Double pbpIncentive = getIncentiveFromList(PBpList);//Changed form performance_to_business_Plan_Current to PBpList 
        list<MetricsDetails> TrainingList = changeBack(mtrTrngList);
        Double trnIncentive = getIncentiveFromList(TrainingList );//Changed form training_Current to TrainingList
        //list<MetricsDetails> MarketList = changeBack(mtrdetailList);
        //Double mrktIncentive=getIncentiveFromList(MarketList );//Changed form marketing_Current to MarketList
        //list<MetricsDetails> AllSPWList = changeBack(mtrAllSunList);
        //Double spwrIncentive=getIncentiveFromList(AllSPWList );//Changed form all_spwr_solutions_Current to AllSPWList    
        Double totalIncentive=csatIncentive+trnIncentive+pbpIncentive;//+mrktIncentive+spwrIncentive;
        system.debug('===========csatIncentive====='+csatIncentive);
        system.debug('===========trnIncentive====='+trnIncentive);
        system.debug('===========pbpIncentive====='+pbpIncentive);
        system.debug('Total I '+totalIncentive);
        String perfmMetricId=this.performanceMetricID;
        String accId=this.accountId;
        Double pdfLimit = 0;
        //hemant : removed and Tier__c =: tierId
        List<PDF_Limit__c> pdfList = [select Partner__c from PDF_Limit__c where Performance_Metric__c =:perfmMetricId ];
        System.debug('====pdfList==='+pdfList);
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
        System.debug('====going to saveQuarterlyIncentive====');
        saveQuarterlyIncentive(pdfLimit,totalIncentive);
    }
    
    //save quaterly incentives
    private void saveQuarterlyIncentive(Double pdfLimit,Double totalIncentive)
    {
        List<Quarterly_Performance_Evaluation__c> quarterIncentice=new List<Quarterly_Performance_Evaluation__c>();
        String currentQuarter=PerformanceAchievementComm.getCurrentQuarter();
        String perfmMetricId=this.performanceMetricID;
        String accId=this.accountId;
        System.debug('===========perfmMetricId============'+perfmMetricId);
        System.debug('===========accId============'+accId);
        if(perfmMetricId!=null && accId!=null)
        {
            quarterIncentice=[select Id,Total_Incentive_QTD__c,Total_Credit_Memo_QTD__c,Account__c,Performance_Metric__c from Quarterly_Performance_Evaluation__c where Account__c=:accId and Performance_Metric__c=:perfmMetricId and Quarter__c=:currentQuarter and Year__c=:(Date.Today().year())];
            System.debug('===========currentQuarter============'+currentQuarter);
            System.debug('===========quarterIncentice============'+quarterIncentice);
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
                System.debug('===========o1============'+o1);
            }
            else
            {
                Double value=0;
                Quarterly_Performance_Evaluation__c obj=new Quarterly_Performance_Evaluation__c();
                obj.Account__c=accId;
                obj.Performance_Metric__c=perfmMetricId;
                //obj.Tier__c=tierId;
                obj.Total_Incentive_QTD__c=totalIncentive;
                if(totalIncentive > pdfLimit )
                {
                    value =  totalIncentive - pdfLimit ;
                }    
                obj.Total_Credit_Memo_QTD__c=value;
                obj.Year__c=Date.Today().year();
                obj.Quarter__c=currentQuarter;   
                insert obj;
                 System.debug('===========obj============'+obj);
            }
        }         
    }
    
    public void incentiveCalculation(){
        Boolean firstQ = false;
        Boolean secondQ = false;
        Double totIncentive = 0 ;
        Double totCreditMemo = 0 ;
        Double totPDFNum = 0 ;
        Integer qCnt=0;
        Date tDate1 = Date.Today();
        Integer yri = tDate1.year();
        String yr= String.valueOf(yri);
        Double tCreditM=0;
        Double purchaseAmt=0;
        Double npurchase =0;
        Double qNpurchase =0;
        if(this.performancelst.size() > 0){
            List<PDF_Limit__c> pdfList = [select Partner__c from PDF_Limit__c where Performance_Metric__c =:this.performancelst.get(0).Id ];
            if(pdfList != null && pdfList.size() > 0){
                this.partnerDevelopmentFunds =  String.ValueOf(pdfList.get(0).Partner__c);
                totPDFNum = pdfList.get(0).Partner__c;
                totalPDF = pdfList.get(0).Partner__c;
            }
        }  
        
        //netPurchaseAmt 
        //List<Quarterly_Performance_Evaluation__c> quarterIncentive = [select Id,Total_Incentive_QTD__c,Total_Credit_Memo_QTD__c,Account__c,Performance_Metric__c from Quarterly_Performance_Evaluation__c where Account__c=:this.accountId and Performance_Metric__c=:this.performancelst.get(0).id and Quarter__c = :quart and Year__c=:(Date.Today().year())];
        List<Overall_Performance_Evaluation__c> overallIncentives = [select Id,Total_Incentive__c,Total_Credit_Memo__c,Account__c,Performance_Metric__c from Overall_Performance_Evaluation__c where Account__c=:this.accountId and Performance_Metric__c=:this.performancelst.get(0).id limit 1];
        if(overallIncentives.size()>0){
            Double qIncentive = overallIncentives.get(0).Total_Incentive__c;
            Double qCreditM = overallIncentives.get(0).Total_Credit_Memo__c;
            if(netPurchaseAmt != null && netPurchaseAmt  > 0 && qIncentive != null && qIncentive > 0){
                    purchaseAmt += (netPurchaseAmt * qIncentive/100);
                    if(qCreditM != null && qCreditM > 0)
                    tCreditM += (netPurchaseAmt * qCreditM/100);
            }
        }
        
        if(purchaseAmt  != null && purchaseAmt  > 0 ){
            this.totalFunds = String.valueOf(Decimal.valueOf(purchaseAmt).setScale(2) );   
            if(tCreditM != null ){
                this.PDFNumber = String.valueOf(Decimal.valueOf(purchaseAmt - tCreditM).setScale(2) );
                this.creditMemoNumber = String.valueOf(Decimal.valueOf(tCreditM).setScale(2) );
            }    
        }
        
        System.debug('============purchaseAmt=========='+purchaseAmt);
        System.debug('============totalFunds=========='+totalFunds); //displayed
        System.debug('============tCreditM=========='+tCreditM);
        System.debug('============PDFNumber=========='+PDFNumber); //displayed
        System.debug('============creditMemoNumber=========='+creditMemoNumber); //displayed
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
   
  /* public String getTname(){
     if(currentTierObj!=null && currentTierObj.size()>0)
     {      
       for(Tier__c t :currentTierObj){
         if(t.Tier_Name__c!=null)  
          tname= t.Tier_Name__c;
       }
     }  
       return tname;
   }
   */
  
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
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR)){              
               mnew.mtrP =  md;
               mtrBPList.add(mnew);
           }else if(md.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew);
           }else if(md.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.PBP_CREDIT_LINE_MAINTAINED_CVAR)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew);
           }
           //Case-00049927
           else if(md.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.PBP_BONUS_PURCHASE_TARGET)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew);
           }
           else if(md.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew);
           }
           
           /*new lines by hemant*/
           /*else if(md.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.PBP_SUNPOWER_DEALER_GROWTH_PLAN_CVAR)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew);
           }*/
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
               System.debug('====1.======'+md.meetricTierRel.Metric_label__c);
               if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS)){
                   System.debug('===2.=======');
                   mnew.mtrP =  md;
                   System.debug('===============mtrlistC==========='+mtrlistC);
                   for(MetricsDetails md1:mtrlistC){
                         System.debug('===3.======='+md1.meetricTierRel.Metric_label__c);
                        if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_ASS_SALES_CERT_CVAR)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_ASS_DESIGN_CERT_CVAR)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_ASS_INSTALL_CERT_CVAR)){
                            System.debug('===4.=======');
                            mnew.mtrC.add(md1); 
                        }
                   }
                   mtrTrngList.add(mnew);
               }
            }
       }
       return mtrTrngList;
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
   
 /*
   
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
    */
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
               
        String currentQuarter_c = PerformanceAchievementComm.getCurrentQuarter();
        String performancePeriod_c = PerformanceAchievementComm.getCurrentPerformancePeriod(currentQuarter_c);
        ////Case#  00102806(00096123) - used achievement class method
        String year_c= PerformanceAchievementComm.getCurrentYear(performancePeriod_c);
        
        ordsun= new order_detail_sunrise2__c();
        List<order_detail_sunrise2__c> ordList = new List<order_detail_sunrise2__c>();
        netPurchaseAmt = 0;
        /*
        ordList = [select QTD_Net_Purchase_Amount__c from order_detail_sunrise2__c where Year__c =:year_c and Performance_Period__c=:performancePeriod_c and Account_Name__c=:this.accountId];
        
        if(ordList.size() > 0){
            ordsun = ordList.get(0);
        }*/
        System.debug('================performancePeriod_c==='+performancePeriod_c);
        for(order_detail_sunrise2__c ord :[select QTD_Net_Purchase_Amount__c, Net_purchase_amount_for_NA_CVAR__c from order_detail_sunrise2__c where Year__c =:year and Performance_Period__c=:performancePeriod_c and Account_Name__c=:this.accountId]){
            System.debug('======ord==='+ord);
            if(ord.Net_purchase_amount_for_NA_CVAR__c != null){
                netPurchaseAmt = netPurchaseAmt + ord.Net_purchase_amount_for_NA_CVAR__c;
            }else{
                netPurchaseAmt = netPurchaseAmt + 0;
            }
        } 
         System.debug('================netPurchaseAmt==='+netPurchaseAmt);
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
       return false;
    }
    public Boolean getSpwrlFlag(){  
       return false;
    } 
    
    /*not needed for CVAR */
    //Save Data to next tier
    /*
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
    */
    
    public PageReference goToPreviousIncentivePage(){
        return new PageReference('/apex/incentivePreviousPage?accid='+this.accountId);
    } 
    
    public void automatedDoubleGoalCheckForIndividual(Metric__c m, Metric_Tier_Relation__c mtr, Double achieve){
        m.Achievement_Value__c = achieve;
        Double min = m.Metric_Min_Value__c;
        Double max = m.Metric_Max_Value__c;
        Boolean goalMet = PerformanceAchievementClass.checkGoalMet(min, max, achieve);
        m.Goal_Met__c = goalMet; 
    }
}