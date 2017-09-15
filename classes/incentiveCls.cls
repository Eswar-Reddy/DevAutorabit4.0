/*** Created by: Accenture
* Date : 1/24/2010 
* Purpose: This Controller contains Logic to display the incentive Tab.
**/
      
public class incentiveCls {
    Performance_Metric__c currentPM;
    public String accountId; 
    final String  ACCOUNT_CHANNEL_NAME ='Residential';
    /****** Modified By Birlasoft*********/
    String country_full_name ='';
    String UserId ='';
    String roleId ='';
    UserRole userrole = new UserRole();
    String profileId =''; 
    Profile userprofile = new Profile();
    /********* End***********/
    /******Old Code 
    String UserId= userInfo.getuserId();
    String roleId = UserInfo.getUserRoleId();
    UserRole userrole = [select name from UserRole where id=: this.roleId];
    String profileId = UserInfo.getProfileId(); 
    Profile userprofile = [select name from Profile where id=: this.profileId];
    End Old Code ***********/
    String accountName;
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
    //Metrics of category CSAT
    List<MtrDetail> mtrCSATList = new list<MtrDetail>();
    list<MtrDetail> mtrBPList = new list<MtrDetail>();
    list<MtrDetail> mtrTrngList = new list<MtrDetail>();
    list<MtrDetail> mtrAllSunList = new list<MtrDetail>();
    Double perRvneTrgt =0; // String to Double as on 24 June
    Boolean mkt = false;
    public boolean isSchedular{get;set;}
    public Boolean isExecutiveManager=false;
    String CurrencySyb;
    String CurrencySybm;
    Double netPurchase =0;
    
    // Done for case # 00068766
    Double NetPeriodPurchases = 0;
    
    public Double getNetPeriodPurchases(){
        return NetPeriodPurchases;      
    }
 
    public Boolean isPartnerCombo{get;set;}
    //Total Number of Requirements met in the current tier
    private Integer numberOfReqMet;
    
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
    

    public incentiveCls(){
        isSchedular = false;
        accountId = ApexPages.currentPage().getParameters().get('accId');
        this.disableButton= true;
        this.isPartnerCombo = false;
        numberOfReqMet = 0;
        this.retriveIncentiveInfo();
        
        
        User usr_info = [Select id, UserRole.Name,UserRole.Id, Profile.Name, Profile.Id FROM User WHERE id=:Userinfo.getUserId()];
        UserId= usr_info.Id;
        roleId = usr_info.UserRole.Id;
        userrole = new UserRole(id= usr_info.UserRole.Id, name= usr_info.UserRole.Name);
        profileId = usr_info.Profile.Id; 
        userprofile = new Profile(id= usr_info.Profile.Id, name= usr_info.Profile.Name);
    }
    //For APEX Scheduler
    //START
    public incentiveCls(String accId)
    {
        isSchedular = true;
        this.isPartnerCombo = false;
        numberOfReqMet = 0;
        if(accId!=null)
        {
            accountId=accId; 
            retriveIncentiveInfo();
            saveEvaluationIncentive();
        }  


        User usr_info = [Select id, UserRole.Name,UserRole.Id, Profile.Name, Profile.Id FROM User WHERE id=:Userinfo.getUserId()];
        UserId= usr_info.Id;
        roleId = usr_info.UserRole.Id;
        userrole = new UserRole(id= usr_info.UserRole.Id, name= usr_info.UserRole.Name);
        profileId = usr_info.Profile.Id; 
        userprofile = new Profile(id= usr_info.Profile.Id, name= usr_info.Profile.Name);
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
        if(this.accountId == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Please provide account id in the URL parameter.'));
            return ;
        }
        if(this.accountId != null){
           //Account acc = [Select a.name, a.CurrencyIsoCode, a.type,a.Country_Domain__c,a.Theater__c,a.Authorized_Partner_Date__c,a.Promoted_Premier_Date__c,a.Elite_partner_Date__c,a.Residential_Installer_Date__c from Account a where id =: this.accountId];
           Account acc;
           List<Account> listAccount = [Select a.name, a.CurrencyIsoCode, a.type,a.Country_Domain__c,a.Theater__c,a.Authorized_Partner_Date__c,a.Promoted_Premier_Date__c,a.Elite_partner_Date__c,a.Residential_Installer_Date__c from Account a where id =: this.accountId];
           if(listAccount != null && listAccount.size() > 0){
               acc = listAccount.get(0);
           }else{
               Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Account does not exists.'));
               return ;
           }
           
           if(acc != null){
                   if(acc.CurrencyIsoCode == 'USD'){
                       CurrencySyb = '$';
                       CurrencySybm='';
                   }else if(acc.CurrencyIsoCode == 'EUR'){
                       CurrencySyb = '';
                       CurrencySybm ='€';
                   }
                   this.accountName = acc.Name;
                   /* Done for the case # 00051450 */
                    accTheatre = acc.Theater__c;
                    if(PerformanceEvalCst.usTheatersMap.containsKey(accTheatre)){
                       accTheatre = PerformanceEvalCst.usTheatersMap.get(accTheatre);
                    }
                   /*Check for Combo*/
                   if(acc.Type != null && PerformanceEvalCst.PARTNER_TYPE_COMBO.contains(acc.Type) && accTheatre != null && accTheatre == 'North America'){
                        isPartnerCombo = true;
                   }else{
                        isPartnerCombo = false;
                   }
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
                   //accTheatre = acc.Theater__c;
                   if(accCountryDomain != null ){
                       if(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('us')){
                           if(accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('rvar') || accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('combo')){
                               accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                           }
                       }
                       else if((accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('it'))||(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('de'))||(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('fr'))){
                               accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                       }
                   }
                   
                   Date tdat = Date.Today();
                   if(accCountryDomain != null){
                        comingSoon= PerformanceEvalCst.comingSoonMap.get(accCountryDomain);
                        country_full_name = PerformanceEvalCst.countryMap.get(accCountryDomain);
                   }
                   
                   if( accCountryDomain != null && accCountryDomain.equals('us')){
                      performancelst = [select User_To_Override__c,Thea__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c,country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                       //Case#00069142
                       if(performancelst.size()== 0){
                         this.performancelst = [select User_To_Override__c,Thea__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c,country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and (Performance_Period_Start_Date__c <=:tdat and Performance_Evaluation_Cut_off_Date__c >=:tdat ) ];
                         if(performancelst.size()> 0)
                             PerformanceAchievementClass.updatePrevEvalDate(performancelst[0].Performance_Period_End_Date__c);
                       }
                       
                       if(performancelst.size()== 0){
                         this.performancelst = [select User_To_Override__c,Thea__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c,country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  order by createdDate asc limit 1 ];
                       }
                   }
                   else if(accCountryDomain != null && ( accCountryDomain.equals('it')||accCountryDomain.equals('de')||accCountryDomain.equals('fr') )){
                       performancelst = [select User_To_Override__c,Thea__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c,country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                      //Case#00069142
                      if(performancelst.size()==0){
                         this.performancelst = [select User_To_Override__c,Thea__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c,country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and (Performance_Period_Start_Date__c <=:tdat and Performance_Evaluation_Cut_off_Date__c >=:tdat ) ];
                         if(performancelst.size()> 0)
                             PerformanceAchievementClass.updatePrevEvalDate(performancelst[0].Performance_Period_End_Date__c);
                      }
                      
                      if(performancelst.size()==0){
                         this.performancelst = [select User_To_Override__c,Thea__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c,racking_price__c,country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name)  order by createdDate asc limit 1 ];
                      }
                   }
                   
                   if(performancelst == null || performancelst.size() == 0){
                        if(!isSchedular){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'There is no Performance Metric found for this tier, account and channel.'));
                            return;
                        }
                   }else{
                        currentPM = performancelst.get(0);
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
                   //start for case # 00057658
                   {
                       //currentMetricList = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,isRSMView__c,Metric_Description__c,Manual_Partner__c,Tier__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c, ParentMetricRelation__c,Part_Of_Composite_Incentive__c,HelpText__c,Bonus_Requirement__c
                       //,(select Overriden__c,Metric_Description__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c,Incentive_Amount__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:performancelst.get(0).Id and Benefit_Tier__c=: true and inactive__c=: false ORDER by Sequence_Order__c];
                       currentMetricList = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,isRSMView__c,Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c, ParentMetricRelation__c,Part_Of_Composite_Incentive__c,HelpText__c,Bonus_Requirement__c
                       ,(select Overriden__c,Metric_Description__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c,Incentive_Amount__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:performancelst.get(0).Id and Benefit_Tier__c=: true and inactive__c=: false ORDER by Sequence_Order__c];
                       getperRevenueTgt();
                   }
                   //end for case #00057658
                   if(currentMetricList!=null && currentMetricList.size()>0)
                   {
                      trId=currentTierObj.get(0).Id;
                      this.performanceMetricID=performancelst.get(0).Id;
                      getMinRequirementMet();
                      this.populateCategoriesForTiers(currentMetricList,performancelst.get(0).Id,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Performance_Period_Start_Date__c,performancelst.get(0).Performance_Period_End_Date__c); 
                      //For Market
                       IncentiveCompositeController.addCompositeMetricForMarket(compositeMarketCurrentList,marketing_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                       System.debug('============customer_Satisfaction_Curreninretrieve========='+customer_Satisfaction_Current);
                       System.debug('====before====='+all_spwr_solutions_Current); 
                       IncentiveCompositeController.addCompositeMetricForSPWR(compositeSPWRCurrentList,all_spwr_solutions_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                       System.debug('====before====='+all_spwr_solutions_Current);
                       IncentiveCompositeController.addCompositeMetricForPbp(compositePerformBPCurrentList,performance_to_business_Plan_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                       // code added as a part of Phase2a on 21 Apr10 
                       IncentiveCompositeController.addCompositeMetricForTrn(compositeTrainingCurrentList,training_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId);
                       checkMarketingAutomated(marketing_Current);  
                       incentiveCalculation();
                       //getMinRequirementMet();
                       // parent child list call modified on 27/01/10
                       //method to group the composite and their child metric
                        //getCSATMetrics();
                        getAllSunpowerMtr();
                        getTrainings();
                        getBussinessPlan();
                        getMarketMtr();                        
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
    
    // check for error message
    public Boolean getHasErrorMessage(){
        return ApexPages.hasMessages();
    }
    
   //for case # 00052696
    //check if all the min requirement to acheive incentive is met
    public String getMinRequirementMet()
    {       
        this.numberOfReqMet = 0;  
        Integer overriddenNumberOfReqMet = null;       
        //Boolean flag = false;
        Boolean flag = true;
        if(currentTierObj != null && currentTierObj.size()> 0 && this.performanceMetricID!=null)
        {
            List<Metric_Tier_Relation__c> metricTierList = [select Id,Boolean_Metric_Y_N__c,Metric_Label__c,Stay_Tier__c,Bonus_Requirement__c,(select Goal_Met__c,Boolean_Achievement__c,Overriden__c,Achievement_Value__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:this.performanceMetricID and (Stay_Tier__c=: true OR Bonus_Requirement__c != null OR Metric_Label__c =:PerformanceEvalCst.BONUS_FOR_MEETING_ALL_TIER_REQUIREMENTS )and inactive__c=: false and Child_Metric__c=: false];
            if(metricTierList.size()>0)
            {
                for(Metric_Tier_Relation__c mtr : metricTierList){
                 if(mtr != null)
                 {
                     List<Metric__c> mlst = mtr.Metrics__r;
                     if(mlst != null && mlst.size() > 0){
                         //Check if metric exist for the tier and overidden
                         //Case#00072546
                         if((mtr.Metric_Label__c).trim().equals((PerformanceEvalCst.BONUS_FOR_MEETING_ALL_TIER_REQUIREMENTS).trim())
                            && mlst.get(0).Overriden__c){
                            overriddenNumberOfReqMet = Integer.valueOf(mlst.get(0).Achievement_Value__c);
                            if(!mtr.Stay_Tier__c && mtr.Bonus_Requirement__c==null){
                                continue;
                            }
                         }
                                                 
                         //flag=true;
                         if(mtr.Boolean_Metric_Y_N__c == true){
                             if(!mlst.get(0).Boolean_Achievement__c)
                                 flag = false ; //return 'No';
                             else                                
                                 this.numberOfReqMet = this.numberOfReqMet + 1;                             
                         }
                         else{
                             if(!mlst.get(0).Goal_Met__c)
                                 flag = false ; //return 'No';
                             else                               
                                this.numberOfReqMet = this.numberOfReqMet + 1;                             
                         }
                      }
                   }
                }
            }
        }
        System.debug('====numberOfReqMet==='+this.numberOfReqMet);
        System.debug('====numberOfReqMet==='+overriddenNumberOfReqMet);
        //For NA-Case#00072546        
        if(accTheatre=='North America'){
            Integer reqvalue = numberOfReqMet;
            if(overriddenNumberOfReqMet!=null)
                reqvalue = overriddenNumberOfReqMet;
            if(partnerTier=='Authorized' && reqvalue>=6)
                return 'Yes'; 
            else if((partnerTier=='Premier' || partnerTier=='Elite') && reqvalue>=12)
                return 'Yes';       
            else
                return 'No';    
        }
        
        //For Europe-check if all the min requirement to acheive incentive is met
        if(flag)
        return 'Yes';
        else
        return 'No';    
    }
    /*public String getMinRequirementMet()
    {       
        this.numberOfReqMet = 0;        
        //Boolean flag = false;
        Boolean flag = true;
        if(currentTierObj != null && currentTierObj.size()> 0 && this.performanceMetricID!=null)
        {
            List<Metric_Tier_Relation__c> metricTierList = [select Child_Metric__c,Id,Boolean_Metric_Y_N__c,Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,(select Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r where account__c =: this.accountId ) from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:this.performanceMetricID and (Stay_Tier__c=: true OR Bonus_Requirement__c != null )and inactive__c=: false ];
            if(metricTierList.size()>0)
            {
                for(Metric_Tier_Relation__c mtr : metricTierList){
                 if(mtr != null)
                 {
                     List<Metric__c> mlst = mtr.Metrics__r;
                     if(mlst != null && mlst.size() > 0  )
                     {
                         //flag=true;
                         if(mtr.Boolean_Metric_Y_N__c==true)
                         {
                             if(!mlst.get(0).Boolean_Achievement__c)
                             {
                                 flag = false ; //return 'No';
                             }else{
                                 if(!mtr.Child_Metric__c)
                                    this.numberOfReqMet = this.numberOfReqMet + 1;
                             }
                         }
                         else
                         {
                             if(!mlst.get(0).Goal_Met__c)
                             {
                                 flag = false ; //return 'No';
                             }else{
                                if(!mtr.Child_Metric__c)
                                    this.numberOfReqMet = this.numberOfReqMet + 1;
                             }
                         }
                      }
                   }
                }
            }
        }
        System.debug('====numberOfReqMet==='+this.numberOfReqMet);
        if(flag)
        return 'Yes';
        else
        return 'No';    
    }*/    
    //for case # 00052696
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
                      System.debug('=========Neeraj1===========' + mtr);
                   if(mtr.Category__c != null && mtr.Category__c.equals('Customer Satisfaction') ){
                      System.debug('=========Neeraj2===========' + mtr);
                       m.meetricTierRel = mtr;
                       List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                       if(mlst != null && mlst.size() > 0  ){
                           m.metric = mlst.get(0);
                           if(mtr.Metric_Input_Type__c.equals('Automated')){
                              if(expDate > Date.Today() && m.metric.Overriden__c==false){ 
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
                                     if(expDate > Date.Today() && m.metric.Overriden__c==false)
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
                        System.debug('=========mtr.metric_label__c=========####' + mtr.metric_label__c);
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
                                  if(expDate >= Date.Today() && m.metric.Overriden__c==false){ 
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
                                  if(expDate > Date.Today() && m.metric.Overriden__c==false){ }
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
                                  if(expDate > Date.Today() && m.metric.Overriden__c==false){
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
   
    /*Created by hemant */
   public void checkMarketingAutomated(List<MetricsDetails> metricData){
        Integer counter = 0 ;
        Integer counterCoBranding = 0;
        /*SunPower Dealer Webpage and Logo Usage :Elements(it has 4 elements)*/
        for(MetricsDetails mtd : metricData){
            if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_HOMEPAGE)){
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_PRODUCTS_PAGE)){
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_ABOUTUS_PAGE)){
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MAINTAINS_WEBPAGE_CONSUMER_ADVANTAGE)){
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }
            /*For Co-Branding*/
            if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_SHOWROOM_DISPLAY_RVAR)){                 
                if(mtd.metric.Goal_Met__c){
                    counterCoBranding++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_ALL_VEHICLES_RVAR)){                
                if(mtd.metric.Goal_Met__c){
                    counterCoBranding++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_BUSINESS_CARDS_RVAR)){              
                if(mtd.metric.Goal_Met__c){
                    counterCoBranding++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_SALES_INSTALLATION_APPAREL_RVAR)){                  
                if(mtd.metric.Goal_Met__c){
                    counterCoBranding++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CERT)){            
                if(mtd.metric.Goal_Met__c){
                    counterCoBranding++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_LOCAL_EVENTS_RVAR)){               
                if(mtd.metric.Goal_Met__c){
                    counterCoBranding++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKETADV)){                  
                if(mtd.metric.Goal_Met__c){
                    counterCoBranding++; 
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_JOB)){             
                if(mtd.metric.Goal_Met__c){
                    counterCoBranding++;
                }
            }
        }
        
        //For Premier tier counter(met) should be greater than 2 and for Elite counter(met) should greater that 6
        for(MetricsDetails mtd : metricData){       
            if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_USA_M3)){
                PerformanceAchievementClass.automatedDoubleGoalCheck(mtd.metric, mtd.meetricTierRel, counter);
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDING_RVAR)){
                PerformanceAchievementClass.automatedDoubleGoalCheck(mtd.metric, mtd.meetricTierRel, counterCoBranding);
            }
        }   
                
   }
   //calculation for SPWR automated metric
   private void AutomatedSPWRMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_SALES_KITS)){
           //code changed for phase2a on 19Apr. Boolean Achivement is changed to Double 
           Double achievement=PerformanceAchievementClass.computeSEVENTYSALESKITS(this.accountId,startDate,endDate);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achievement);
           
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.OPP_CLOSE_RATE)){
           Double achieve=PerformanceAchievementClass.computeOPPCLOSERATE(this.accountId);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if((mtr.Metric_Label__c).trim().equals((PerformanceEvalCst.SEVENTY_RES_KITS_EU).trim())){
          //code added for phase2a on 5/5/10 waiting for confirmation 
          Double achievement=PerformanceAchievementClass.computeSEVENTYRESKITSEU(this.accountId,startDate,endDate,String.valueOf(mtr.Performance_Metric__r.country__c),mtr.Performance_Metric__r.racking_price__c);
          //PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement); 
          PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achievement); 
        }
        if((mtr.Metric_Label__c).trim().equals((PerformanceEvalCst.SEVENTY_COM_INVTR_EU).trim())){
           //code added for phase2a on 5/5/10 waiting for confirmation
           Double achievement=PerformanceAchievementClass.computeSEVENTYCOMINVTREU(this.accountId,startDate,endDate);
           //PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achievement);
        }
        
        /*Added by hemant */
        if((mtr.Metric_Label__c).trim().equals((PerformanceEvalCst.BONUS_FOR_ONLINE_ORDERING).trim())){
           System.debug('===BONUS FOR ONLINE=======');
           Double achievement = PerformanceAchievementClass.computeBonusForOnlineOrdering(this.accountId,startDate,endDate);
           System.debug('===BONUS FOR ONLINE===achievement===='+achievement);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m, mtr, achievement);
        }
        
        if((mtr.Metric_Label__c).trim().equals((PerformanceEvalCst.BONUS_FOR_MEETING_ALL_TIER_REQUIREMENTS).trim())){
           System.debug('===ALL TIER REQ numberOfReqMet======='+this.numberOfReqMet);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m, mtr, this.numberOfReqMet);
           System.debug('===ALL TIER REQ m======='+m);
        }
   }
   //calculation for performance to business plan automated metric
   private void AutomatedPbpMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
     
       if(mtr.Metric_Label__c.equals(PerformanceEvalCst.ACTIVE_DEALER)){
            Boolean achievement=PerformanceAchievementClass.computeACTIVEDEALER(this.accountId,startDate,endDate);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CREDIT_LIMIT)){
            Double creditLimit=PerformanceAchievementClass.computeCREDITLIMIT(this.accountId);
            Double max=null;
            Boolean goalMet=PerformanceAchievementClass.checkGoalMet(100000,max,creditLimit);
            m.Boolean_Achievement__c =goalMet;
            m.Goal_Met__c=goalMet;
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CREDIT_LIMIT_EU)){
            Boolean goalMet=PerformanceAchievementClass.computeCREDITLIMITEU(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,goalMet);
        }
        if((mtr.Metric_Label__c.equals(PerformanceEvalCst.SIX_MONTHS_AS_AUTH))|| (mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_EXP_SIX_MONTHS_EU))){
            Boolean achievement=PerformanceAchievementClass.computeSIXMONTHSASAUTH(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.TWENTY_INSTALLS_AS_AUTH)){
            Boolean achievement=PerformanceAchievementClass.computeTWENTYINSTALLSASAUTH(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement); 
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SIX_MONTHS_AS_PREM)){
            Boolean achievement=PerformanceAchievementClass.computeSIXMONTHSASPREM(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.HUNDRED_INSTALLS_AS_PREM)){
            Boolean achievement=PerformanceAchievementClass.computeHUNDREDINSTALLSASPREM(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_EXP_TWENTY_INSTALLS_EU)){
            Boolean achievement=PerformanceAchievementClass.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.RETROFIT_SOLAR_SYS)){
            Boolean achievement=PerformanceAchievementClass.computeRETROFITSOLARSYS(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.BGSM_SCORECARD_EU)
           || mtr.Metric_Label__c.equals(PerformanceEvalCst.BGSM_SCORECARD_EU_CLONE)){
            Double score=PerformanceAchievementClass.computeBGSMScore(this.accountId);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,score);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_QUAT_SALES_EU)){
            Boolean achievement=PerformanceAchievementClass.computeMINQUATSALESEU(this.accountId,startDate,endDate);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        } 
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_QUAT_SALES_EU_CLONE)){
            Boolean achievement=PerformanceAchievementClass.computeMINQUATSALESEUCLONE(this.accountId,startDate,endDate);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_SALES_AUTHZ_EU)){
            //Boolean achievement=PerformanceAchievementClass.computeMINSALESAUTHZEU(this.accountId);
            //Changed by Neeraj
            Boolean achievement=PerformanceAchievementClass.computeBonusForMINSALESAUTHZEU(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SIX_MONTHS_TARGET)){
            Double score=PerformanceAchievementClass.computeSIXMONTHSTARGET(this.accountId,startDate,endDate);            
            PerformanceAchievementClass.automatedDoubleGoalCheckKW(m,mtr,score);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.KW_TARGET_EU)){
            Double score=PerformanceAchievementClass.computeKWTARGETEU(this.accountId,startDate,endDate);
            PerformanceAchievementClass.automatedDoubleGoalCheckKW(m,mtr,score);
        } 
        
        //Up to date with payments(added by Neeraj)
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.UP_TO_DATE_PAYMENT_EU_RVAR)){
            Boolean score = PerformanceAchievementClass.isUpToDateWithPaymentEU(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, score);
        } 
        
        //Sunpower Residential Loan Program Signed(added by Neeraj)
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SPWR_RESIDENTIAL_LOAN_PS_EU_RVAR)){
            Boolean score = PerformanceAchievementClass.IsSunpowerResidentialLoanProgramSignedEU(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, score);
        }
        
       
   }
   
   //calculation for training automated metric 
   private void AutomatedTrainingMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
       if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_DESIGN)){
           Double achieve=PerformanceAchievementClass.computeTRAININGASSDESIGN(this.accountId);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_INSTALL)){
            Double achieve=PerformanceAchievementClass.computeTRAININGASSINSTALL(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ASS_SALES)){
            Double achieve=PerformanceAchievementClass.computeTRAININGASSSALES(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ADV_DESIGN)){
            Double achieve=PerformanceAchievementClass.computeTRAININGADVDESIGN(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ADV_INSTALL)){
            Double achieve=PerformanceAchievementClass.computeTRAININGADVINSTALL(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_ADV_SALES)){
            Double achieve=PerformanceAchievementClass.computeTRAININGADVSALES(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.ADVANCE_PROD_TRAINING)){
            Double achieve=PerformanceAchievementClass.computeADVANCEPRODTRAINING(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.ADVANCE_TRAINING_EU)){
            Double achieve=PerformanceAchievementClass.computeADVANCE_TRAINING_EU(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.BASIC_TRAINING_EU)){
            Double achieve=PerformanceAchievementClass.computeBASICTRAININGEU(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.BASIC_TRAINING_EU_CLONE)){
            Double achieve=PerformanceAchievementClass.computeBASICTRAINING(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        // code added for phase2a on 19Apr10 for training Bonus for Extra 
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_I)){
            Double achieve=PerformanceAchievementClass.computeTRAININGADVDESIGN(this.accountId);
            System.debug('TestT'+achieve);//computeEXTRABONUSI
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        // code added for phase2a on 19Apr10 for training Bonus for Extra 
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II)){
            Double achieve=PerformanceAchievementClass.computeEXTRABONUSII(this.accountId); //
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_III)){
            Double achieve=PerformanceAchievementClass.computeTRAININGADVINSTALL(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //Sunrise 2b (Smarter Selling) 
        //For Italy and Germany Premier
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.FUNDAMENTAL_TRAINING_SMARTER_SELLING_EU)){
            Double achieve = PerformanceAchievementClass.smarterSelling_EU(this.accountId, this.country_full_name);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m, mtr, achieve);
        }
        
        //For Italy SRI only
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.FUNDAMENTAL_TRAINING_DESIGN_SPFR_EU)){
            Double achieve = PerformanceAchievementClass.fundamentalDesignSPFRTraining_EU(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m, mtr, achieve);
        }
        
        //For Italy SRI only
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.FUNDAMENTAL_TRAINING_SAL_CORE_EU)){
            Double achieve = PerformanceAchievementClass.fundamentalSALCORETraining_EU(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m, mtr, achieve);
        }
        
        // Done for case # 00060258
        // Done for case # 00060076
        //For SRI Italy and FRANCE
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.FUNDAMENTAL_TRAINING_INSTALLATION_EU)){
            Double achieve = PerformanceAchievementClass.fundamentalINSTALLATIONTraining_EU(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m, mtr, achieve);
        }
 
   } 
   // calculation for customer satisfaction automated metric
   private void AutomatedCSATMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
       if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE) || mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE_EU)){
           //for case # 00052350
           //Double csatScore=PerformanceAchievementClass.computeCSATSCORE(this.accountId,startDate,endDate);
           Double csatScore=PerformanceAchievementClass.computeCSATSCORE(this.accountId,startDate,endDate,currentPM);  
           PerformanceAchievementClass.automatedBonusGoalCheck(m,mtr,csatScore);
           //for case # 00052350
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,csatScore);
           
           
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION) ){//|| mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_EU)){
           /*
           Double siteInspection=PerformanceAchievementClass.coumputeSITEINSPECTION(this.accountId,startDate,endDate);  
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,siteInspection);
           */
           Boolean siteInspection=PerformanceAchievementClass.coumputeSITEINSPECTION(this.accountId,startDate,endDate);  
           PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,siteInspection);    
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CUSTOMER_COMPLAINTS)){
            Double complaints=PerformanceAchievementClass.coumputeCUSTOMERCOMPLAINTS(this.accountId,startDate,endDate);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,complaints);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PERCENT_INSTALL_CRM)){
           Double percentInstalls=PerformanceAchievementClass.computePERCENTINSTALLCRM(this.accountId,startDate,endDate);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,percentInstalls); 
        }
       
        /************************************************/
        //Added by neeraj
        /************************************************/
       if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SURVEY_REQ)){
           //for case # 00052350
           //Double percentInstalls=PerformanceAchievementClass.computeCSATSURVEYREQ(this.accountId,startDate,endDate);         
           Double percentInstalls=PerformanceAchievementClass.computeCSATSURVEYREQ(this.accountId,startDate,endDate,currentPM);
           //for case # 00052350
           PerformanceAchievementClass.automatedBonusGoalCheck(m,mtr,percentInstalls);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.WARRANTY_CARDS_EU)){
           // Done for case # 00064909
           // Double percentInstalls=PerformanceAchievementClass.computeWARRANTYCARDSEU(this.accountId,startDate,endDate);
           Double percentInstalls=PerformanceAchievementClass.computeWARRANTYCARDSEU(this.accountId,startDate,endDate,currentPM);
           PerformanceAchievementClass.automatedBonusGoalCheck(m,mtr,percentInstalls);
        }
        //for case # 00052350
        /*if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE_EU)){
           Double percentInstalls=PerformanceAchievementClass.computeCSATSCORE(this.accountId,startDate,endDate);
           PerformanceAchievementClass.automatedBonusGoalCheck(m,mtr,percentInstalls);
        }*/
        //for case # 00052350
        //Sunrise 2b (Automated Inspection Metric)
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_EU)){
            // Done for case # 00060076
            /* Goal met by default for Partner Accounts except 
               Partners that has been inspected (Partner with related Cases type Inspections)*/
            List<Case> caseList = new List<Case>([select Id from Case Where (Partner_Name__c=:this.accountId OR Partner_Account__c=:this.accountId) and Type=:'Inspection']);
            if(caseList.size() == 0){
                PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, true);    
            }
            else{
                if(mtr.Tier__r.Tier_Name__c == 'SRI'){ 
                    Boolean achieve = PerformanceAchievementClass.inspectionSRI_EU(this.accountId, startDate, endDate, currentPM) ; 
                    PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, achieve);             
                }else if(mtr.Tier__r.Tier_Name__c == 'Authorized'){                         
                    Boolean achieve = PerformanceAchievementClass.inspectionAuthorised_EU(this.accountId, startDate, endDate, 'stay', this.country_full_name, currentPM);           
                    PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, achieve);
                }else if(mtr.Tier__r.Tier_Name__c == 'Premier'){            
                    Boolean achieve = PerformanceAchievementClass.inspectionPremier_EU(this.accountId, startDate, endDate, 'stay', this.country_full_name, currentPM);              
                    PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, achieve);
                }
            }
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
        if(minRequirementMet1.equals('Yes'))
        {
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
        System.debug('=======mtrBPList=========='+mtrBPList);
        list<MetricsDetails> PBpList = changeBack(mtrBPList);
        System.debug('=======1. Before PBpList to be updated=========='+PBpList);
        updateAchievement(customer_Satisfaction_Current);
        System.debug('=======2. after PBpList to be updated=========='+PBpList);
        updateAchievement(PBpList); //Changed form performance_to_business_Plan_Current to PBpList
        IncentiveCompositeController.updateCompositeMetricForPbp(PBpList); //Changed form performance_to_business_Plan_Current to PBpList

        list<MetricsDetails> TrainingList = changeBack(mtrTrngList);
        updateAchievement(TrainingList);//Changed form training_Current to TrainingList
        //For Market
        list<MetricsDetails> MarketList = changeBack(mtrdetailList);
        updateAchievement(MarketList); //Changed form marketing_Current to MarketList
        IncentiveCompositeController.updateCompositeMetricForMarket(MarketList);//Changed form marketing_Current to MarketList 
        
        list<MetricsDetails> AllSPWList = changeBack(mtrAllSunList);
        updateAchievement(AllSPWList); //Changed form all_spwr_solutions_Current to AllSPWList
        IncentiveCompositeController.updateCompositeMetricForSPWR(AllSPWList);//
        
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
        Map<Id, Metric__c> mapMetricsToBeUpdated = new Map<Id, Metric__c>();
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
                         //metricsUpdate.add(md.metric);
                         mapMetricsToBeUpdated.put(md.metric.Id, md.metric);
                     }
                 }
                 else
                 {
                     //metricsUpdate.add(md.metric);
                     mapMetricsToBeUpdated.put(md.metric.Id, md.metric);
                 }
             }
             else
             {
                 metricsNew.add(md.metric);
             }
        }
       
       /*
       if(metricsUpdate.size()>0)
       {
        System.debug('================metricsUpdate========'+metricsUpdate);
        update metricsUpdate;
       } */
       if(mapMetricsToBeUpdated.size() > 0){
         System.debug('================mapMetricsToBeUpdated.values()========'+mapMetricsToBeUpdated.values());
         update mapMetricsToBeUpdated.values();
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
        saveQuarterlyIncentive(pdfLimit,totalIncentive,tierId);
    }
    
    //save quaterly incentives
    private void saveQuarterlyIncentive(Double pdfLimit,Double totalIncentive,Id tierId)
    {
        List<Quarterly_Performance_Evaluation__c> quarterIncentice=new List<Quarterly_Performance_Evaluation__c>();
        String currentQuarter=PerformanceAchievementClass.getCurrentQuarter();
        //Case 00096123
        String performancePeriod = PerformanceAchievementClass.getCurrentPerformancePeriod(currentQuarter);
        String yearS = PerformanceAchievementClass.getCurrentYear(performancePeriod);
        Decimal year = Decimal.valueOf(yearS);
        
        String perfmMetricId=this.performanceMetricID;
        String accId=this.accountId;
        if(perfmMetricId!=null && accId!=null)
        {
            quarterIncentice=[select Id,Total_Incentive_QTD__c,Total_Credit_Memo_QTD__c,Account__c,Performance_Metric__c from Quarterly_Performance_Evaluation__c where Account__c=:accId and Performance_Metric__c=:perfmMetricId and Quarter__c=:currentQuarter and Year__c=:year];
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
                obj.Year__c=year;
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
            System.debug('====hemant : pdfList==='+pdfList);
            if(pdfList != null && pdfList.size() >0){
                this.partnerDevelopmentFunds =  String.ValueOf(pdfList.get(0).Partner__c);
                totPDFNum = pdfList.get(0).Partner__c;
                totalPDF = pdfList.get(0).Partner__c;
            }
        }    
               
        Double tCreditM=0;
        Double purchaseAmt=0;
        Double npurchase =0;
        Double qNpurchase =0;
        if(performancelst.size()>0)
        {
            List<String> currentQlist = PerformanceAchievementClass.getQuartesBetweenDates(performancelst.get(0).Performance_Period_Start_Date__c,PerformanceAchievementClass.EvalDate);
            // Changed as a part of phase2a
            String currentQuarter = PerformanceAchievementClass.getCurrentQuarter();
            String performancePeriod = PerformanceAchievementClass.getCurrentPerformancePeriod(currentQuarter);
            //Case 00096123
            String yrS = PerformanceAchievementClass.getCurrentYear(performancePeriod);
            Decimal yr = Decimal.valueOf(yrS);
            List<order_detail_sunrise2__c> orderDetail = [select Quarter__c,QTD_Net_Purchase_Amount__c,Quarter_Net_Purchase_Amount__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and year__c =:yrS ]; //Quarter__c =:quart
            
            if(orderDetail.size() > 0){
                if(orderDetail.get(0).QTD_Net_Purchase_Amount__c!=null){
                    npurchase=orderDetail.get(0).QTD_Net_Purchase_Amount__c;
                }
            }
            for(String quart:currentQlist){
                List<Quarterly_Performance_Evaluation__c> quarterIncentice=[select Id,Total_Incentive_QTD__c,Total_Credit_Memo_QTD__c,Account__c,Performance_Metric__c from Quarterly_Performance_Evaluation__c where Account__c=:this.accountId and Performance_Metric__c=:this.performancelst.get(0).id and Quarter__c = :quart and Year__c=:yr];
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
       /*Added */
       // Done for Case # 00068766
       //Case#00071353-Now purchase amount is stored in NetPeriodPurchases for all theater
       if(NetPeriodPurchases!=null){
            Bonus = (getEarnedIncentive() * NetPeriodPurchases) / 100 ;
       }
       else
        return 0;
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
           if(m.meetricTierRel.Incentive_Amount__c >0 || m.meetricTierRel.Bonus_Requirement__c != null){
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
               /*Added by hemant */
                for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_HOMEPAGE)||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_PRODUCTS_PAGE)||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_ABOUTUS_PAGE)||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MAINTAINS_WEBPAGE_CONSUMER_ADVANTAGE)){
                      
                      mnew.mtrC.add(md1);    
                   }                                      
               }
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
           /*hemant:added Co-Branding */
           else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDING_RVAR)){
                mnew.mtrP =  md;            
                for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_SHOWROOM_DISPLAY_RVAR)||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_ALL_VEHICLES_RVAR)||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_BUSINESS_CARDS_RVAR)||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_SALES_INSTALLATION_APPAREL_RVAR) ||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_CERT) ||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_LOCAL_EVENTS_RVAR) ||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKETADV) ||
                      md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MARKET_JOB)){
                      
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
    System.debug('###mtrBPList###' + mtrBPList);
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
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES_EU )){ //4 Marketing requirements met
               mnew.mtrP =  md; 
               for(MetricsDetails md1:mtrlistC){
                   if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_1)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_2)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_3)){
                        mnew.mtrC.add(md1); 
                   }
               }
              mtrBPList.add(mnew);
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.UP_TO_DATE_PAYMENT_EU_RVAR)){
                System.debug('========UP_TO_DATE_PAYMENT_EU_RVAR==========='+PerformanceEvalCst.UP_TO_DATE_PAYMENT_EU_RVAR);
               mnew.mtrP =  md;
               mtrBPList.add(mnew); 
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SPWR_RESIDENTIAL_LOAN_PS_EU_RVAR)){
               mnew.mtrP =  md;
               mtrBPList.add(mnew); 
           }/*else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.CSAT_SCORE_EU)){
            System.debug('========PerformanceEvalCst.CSAT_SCORE_EU==========='+PerformanceEvalCst.CSAT_SCORE_EU);
               mnew.mtrP =  md;
               mtrBPList.add(mnew); 
           }*/
           else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.SHARE_OF_ACCOUNT_BONUS)){
                mnew.mtrP =  md; 
                mtrBPList.add(mnew); 
            }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MIN_SALES_AUTHZ_EU)){
                    mnew.mtrP =  md; 
                    mtrBPList.add(mnew); 
            }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.MIN_QUAT_SALES_EU_CLONE)){
                    mnew.mtrP =  md; 
                    mtrBPList.add(mnew); 
            }
           System.debug('=====================' + md.meetricTierRel.Metric_label__c);
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
                        /*Changed by hemantin Sunrise2b:
                        Revise Algorithm ; remove 2  Addl personnel for Advance Design and Install; retain advance Sales metric
                        */
                        /*
                        if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_I)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II)||md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_III)){
                            mnew.mtrC.add(md1); 
                        }*/
                        if(md1.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II)){
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
     System.debug('====mtrAllSunList====='+mtrAllSunList.size());
     if(mtrAllSunList.size()==0){
       System.debug('====all_spwr_solutions_Current====='+all_spwr_solutions_Current);
       splitMetric(this.all_spwr_solutions_Current);
       System.debug('====mtrlistP====='+mtrlistP);
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
                   /*Modified by Neeraj*/
                   String str1= PerformanceEvalCst.SEVENTY_RES_KITS_EU.trim();
                   String str2= PerformanceEvalCst.SEVENTY_COM_INVTR_EU.trim();
                   if((md1.meetricTierRel.Metric_label__c).trim().equals(str1) || (md1.meetricTierRel.Metric_label__c).trim().equals(str2)){
                        mnew.mtrC.add(md1); 
                   }
               }
              mtrAllSunList.add(mnew);
           }
           /*Added by hemant */
           else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.BONUS_FOR_MEETING_ALL_TIER_REQUIREMENTS)){
               mnew.mtrP =  md;
               mtrAllSunList.add(mnew);    
           }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.BONUS_FOR_ONLINE_ORDERING)){ 
               mnew.mtrP =  md;
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
   
   /* changed for RVAR metrics*/
   public list<MtrDetail> getCSATMetrics(){
       //System.debug('=====before mtrlistP size='+mtrlistP.size());
       //System.debug('=====Before IF =====customer_Satisfaction_Current='+customer_Satisfaction_Current);
       //System.debug('=====mtrCSATList='+mtrCSATList);
       //if(mtrCSATList.size() > 0)
       //       mtrCSATList.clear();
            
       if(mtrCSATList.size()==0){
           System.debug('==========customer_Satisfaction_Current='+customer_Satisfaction_Current);
           splitMetric(this.customer_Satisfaction_Current);
           System.debug('==========mtrlistP='+mtrlistP);
           System.debug('=====after mtrlistP size='+mtrlistP.size());
           for(MetricsDetails md:mtrlistP){
               MtrDetail mnew = new MtrDetail();
               System.debug('=============md.meetricTierRel.Metric_label__c=========' + md.meetricTierRel.Metric_label__c);           
               if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.WARRANTY_CARDS_EU)){
                   System.debug('======1.=====');
                   mnew.mtrP =  md;
                   mtrCSATList.add(mnew);
               }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.CSAT_SURVEY_REQ)){
                   System.debug('======2.=====');
                   mnew.mtrP =  md;
                   mtrCSATList.add(mnew);    
               }else if(md.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.CSAT_SCORE_EU)){
                    System.debug('========3==========='+PerformanceEvalCst.CSAT_SCORE_EU);
                    mnew.mtrP =  md;
                    mtrCSATList.add(mnew); 
           }  
           }
       }
       SYstem.debug('=======mtrCSATList.size'+mtrCSATList.size());
       return mtrCSATList;
   }
   
   public void showCSAT(){
       String csatId = ApexPages.currentPage().getParameters().get('csatId');
       System.debug('====================1===============' + csatId);
       System.debug('====================mtrCSATList===============' + mtrCSATList.size());
       for(MtrDetail mr: mtrCSATList){
           if(mr.mtrP.meetricTierRel.Id == csatId){
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
        String currentQuarter_c = PerformanceAchievementClass.getCurrentQuarter();
        String performancePeriod_c = PerformanceAchievementClass.getCurrentPerformancePeriod(currentQuarter_c);
        ////Case#  00102806(00096123) - used achievement class method
        String year_c = PerformanceAchievementClass.getCurrentYear(performancePeriod_c);
        system.debug('---currentQuarter_c---'+currentQuarter_c+'---performancePeriod_c---'+performancePeriod_c);
        ordsun= new order_detail_sunrise2__c();
        
        List<order_detail_sunrise2__c> lstOrderDetail = new List<order_detail_sunrise2__c>([select QTD_Net_Purchase_Amount__c,QTD_Revenue_Override__c from order_detail_sunrise2__c where Year__c =:year_c and Performance_Period__c=:performancePeriod_c and Account_Name__c=:this.accountId]);
        //Case#00071354- QTD Revenue overide 
        Boolean isOverideDone = false;
        for(order_detail_sunrise2__c o:lstOrderDetail){
            system.debug('=====QTD_Revenue_Override__c====='+o.QTD_Revenue_Override__c);
            if(o.QTD_Revenue_Override__c!=null){
                system.debug('=====isOverideDone======');
                NetPeriodPurchases = NetPeriodPurchases + o.QTD_Revenue_Override__c;
                isOverideDone = true;
            }           
        }
        if(isOverideDone){
            return;
        } 
        
        if(accTheatre=='Europe'){           
            //Case#00071353-Show Net Period purchases for both quarter for EU.
            for(order_detail_sunrise2__c o:lstOrderDetail){
                if(o.QTD_Net_Purchase_Amount__c != null){
                    NetPeriodPurchases = NetPeriodPurchases + o.QTD_Net_Purchase_Amount__c;
                }
            }
        }
        else{
            //Case#00068766-For north america                   
            NetPeriodPurchases=PerformanceAchievementClass.computeSIXMONTHSTARGET(this.accountId,currentPM.Performance_Period_Start_Date__c,currentPM.Performance_Period_End_Date__c);
        }                
    }
    
    public Boolean getcsatlFlag(){
    list<MtrDetail> csatl= getCSATMetrics(); 
        if(csatl.size()>0)
            return true;
        else
            return false;
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
        System.debug('####this.partnerTier####' + this.partnerTier);
        if(this.partnerTier!=null){
             System.debug('####this.partnerTier####' + this.partnerTier);
             nextTier = PerformanceEvalCst.tierMap.get(this.partnerTier);
             System.debug('####nextTier####' + nextTier);
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
                   else if((accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1,accCountryDomain1.length()).equals('it'))||(accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1,accCountryDomain1.length()).equals('de'))||(accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1,accCountryDomain1.length()).equals('fr'))){
                           accCountryDomain1 = accCountryDomain1.Substring(accCountryDomain1.indexOf('-')+1 ,accCountryDomain1.length());
                   }
            }
            String countryfullname ='';
            if(accCountryDomain1 != null){
                countryfullname = PerformanceEvalCst.countryMap.get(accCountryDomain1);
            }
            Tier__c tc = [select Id,Tier_Name__c from Tier__c where Tier_Name__c =:this.partnerTier and country__c =:countryfullname limit 1];
            List<Tier__c> tcnLst = new List<Tier__c>([select Id,Tier_Name__c from Tier__c where Tier_Name__c =:nextTier and country__c =:countryfullname limit 1]);
            if(tcnLst.size()==0){
                return;
            }
            Tier__c tcn = tcnLst[0];
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
    
    public PageReference goToPreviousIncentivePage(){
        return new PageReference('/apex/incentivePreviousPage?accid='+this.accountId);
    } 
}