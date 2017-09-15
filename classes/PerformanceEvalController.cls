/*** Created by: Accenture
* Date : 1/24/2010 
* Purpose: This Controller contains logic to display the Performance Evaluation dashboard.
* Modified By :   hemant garg(Appirio offshore)
* Modified Date : Nov 24, 2010
* Purpose       : Changes in metric formulas According to SunRise 2b NA RVAR changes
**/
  
public class PerformanceEvalController{
    //Date gracePeriodDate;
    Performance_Metric__c currentPM;
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
    
    List<MetricsDetails> listMarketingChildren_Current = new List<MetricsDetails>();    
    List<MetricsDetails> listMarketingChildren_Next = new List<MetricsDetails>();
    public String expandParent{get;set;}
    
    Boolean hideHeaderForPartner;
    Boolean showNextTab;
    String StartDate;
    Boolean isExecutiveManager=false;
    public boolean isSchedular{get;set;}
    String accTheatre;
    String clkSave = 'abc';
    String UserId= userInfo.getuserId();
    //Case#00066053 start
    Static UserRole userrole = [select name from UserRole where id=: UserInfo.getUserRoleId()];
    Static Profile userprofile = [select name from Profile where id=: UserInfo.getProfileId()];
    //Case#00066053 end
    public Boolean isPartnerCombo{get;set;}
    //public Boolean isPortalUser{get;set;}
    /* Done for case # 00054448 */
    public String activeTab{get;set;}
    public Boolean isEUUser{get;set;}
    private Set<String> metricLabelsInStayTier;
    
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
       if(PerformanceEvalCst.profileHideHeaderForPartner.contains(userprofile.Name) || isPartnerCombo){
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
    public PerformanceEvalController(ApexPages.StandardController controller){
        isSchedular = false;
        activeTab = 'current';
        accountId = ApexPages.currentPage().getParameters().get('accId');
        this.disableButton= true;
        this.isPartnerCombo = false;
        metricLabelsInStayTier = new Set<String>();
        expandParent = '';
        this.retriveAccountInfo();
        //Added by Neeraj
        //gracePeriodDate = Date.today().addDays(-15);
    }
    public PerformanceEvalController(){
        isSchedular = false;
        accountId = ApexPages.currentPage().getParameters().get('accId');
        this.disableButton= true;
        metricLabelsInStayTier = new Set<String>();
        expandParent = '';
        this.retriveAccountInfo();
    }
    
    public PerformanceEvalController(String accId){
        isSchedular = true;
        if(accId!=null)
        {
            accountId = accId;
            this.disableButton= true;
            metricLabelsInStayTier = new Set<String>();
            expandParent = '';
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
        if(this.accountId == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Please provide account id in the URL parameter.'));
            return ;
        }
       if(this.accountId != null){
           //Account acc = [Select a.name , a.type,a.Country_Domain__c,a.Theater__c,a.Authorized_Partner_Date__c,a.Promoted_Premier_Date__c,a.Elite_partner_Date__c,a.Residential_Installer_Date__c from Account a where id =: this.accountId];
           Account acc;
           List<Account> listAccount = [Select a.name , a.type,a.Country_Domain__c,a.Theater__c,a.Authorized_Partner_Date__c,a.Promoted_Premier_Date__c,a.Elite_partner_Date__c,a.Residential_Installer_Date__c from Account a where id =: this.accountId];
           if(listAccount != null && listAccount.size() > 0){
               acc = listAccount.get(0);
           }else{
               Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Account does not exists.'));
               return ;
           }
           if(acc != null){
               this.accountName = acc.Name;
                /* Done for the case # 00051450 */
                accTheatre = acc.Theater__c;
                if(PerformanceEvalCst.usTheatersMap.containsKey(accTheatre)){
                       accTheatre = PerformanceEvalCst.usTheatersMap.get(accTheatre);
                }
                if(acc.Type != null && PerformanceEvalCst.PARTNER_TYPE_COMBO.contains(acc.Type) && accTheatre != null && accTheatre == 'North America'){
                   isPartnerCombo = true;
                }else{
                   isPartnerCombo = false;
                }
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
               //accTheatre = acc.Theater__c;
               if(this.partnerTier!=null){
                    nextTier = PerformanceEvalCst.tierMap.get(this.partnerTier);
               }
               if(accCountryDomain != null ){
                   if(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('us')){
                       if(accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('rvar') || accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('combo')){
                           accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                       }
                   }
                   else if((accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('it'))||(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('de'))||(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('fr'))){
                           accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
                   }
                   
                   country_full_name = PerformanceEvalCst.countryMap.get(accCountryDomain);
                   
                   //commented for case#00066053
                   /*List<Tier__c> tObj = [select Id from Tier__c where Tier_Name__c=: partnerTier and Country__c =:country_full_name];
                   if(tObj!=null && tObj.size()>0)
                   trId=tObj.get(0).Id;*/
               }
               Date tdat = Date.Today();
               system.debug('today'+tdat);
               List<Performance_Metric__c> performancelst = new List<Performance_Metric__c>();
               System.debug('===============this.ACCOUNT_CHANNEL_NAME=============='+this.ACCOUNT_CHANNEL_NAME);
               System.debug('===============country_full_name=============='+country_full_name);
               System.debug('===============accTheatre=============='+accTheatre);
               System.debug('===============tdat=============='+tdat);
               if( accCountryDomain != null && accCountryDomain.equals('us')){
                  performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c,Country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                  //Case#00069142
                  if(performancelst.size()== 0){                     
                      performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c,Country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  and (Performance_Period_Start_Date__c <=:tdat and Performance_Evaluation_Cut_off_Date__c >=:tdat ) ];                                           
                      if(performancelst.size()> 0)
                          PerformanceAchievementClass.updatePrevEvalDate(performancelst[0].Performance_Period_End_Date__c);
                  }
                  if(performancelst.size()== 0){
                      //Modified by Neeraj
                      performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c,Country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME  order by createdDate asc limit 1 ];
                      //performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c,Country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (: country_full_name) and channel__c =: this.ACCOUNT_CHANNEL_NAME and (Performance_Period_Start_Date__c <=:gracePeriodDate and Performance_Period_End_Date__c >=:gracePeriodDate )  order by createdDate desc limit 1 ];
                  } 
               }
               else if(accCountryDomain != null && ( accCountryDomain.equals('it')||accCountryDomain.equals('de') ||accCountryDomain.equals('fr') )){
                  performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c,Country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
                  //Case#00069142
                  if(performancelst.size()== 0){                     
                      performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c,Country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and (Performance_Period_Start_Date__c <=:tdat and Performance_Evaluation_Cut_off_Date__c >=:tdat ) ];                                           
                      if(performancelst.size()> 0)
                          PerformanceAchievementClass.updatePrevEvalDate(performancelst[0].Performance_Period_End_Date__c);
                  }
                  if(performancelst.size()==0){
                    //Modified by Neeraj
                    performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c,Country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name)  order by createdDate asc limit 1 ];
                    //performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c,Performance_Evaluation_Cut_off_Date__c, Performance_Period_End_Date__c,Country__c,channel__c from Performance_Metric__c where Thea__c in (: accTheatre) and Country__c in (:  country_full_name) and (Performance_Period_Start_Date__c <=:gracePeriodDate and Performance_Period_End_Date__c >=:gracePeriodDate )  order by createdDate asc limit 1 ];
                  }
                  system.debug('===============SIZE==================='+performancelst.size());
               }
              
               //Modified by Neeraj               
               if(performancelst == null || performancelst.size() == 0){
                    if(!isSchedular){
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'There is no Performance Metric found for this tier, account and channel.'));
	                    return;
                    } 
               }else{
                    System.debug('======================'+performancelst.get(0));
                    currentPM = performancelst.get(0);
               }
               /********/       
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
               
               //Case#00066053 start 
               Set<String> tiers = new Set<String>();               
               if(this.partnerTier!=null){
                    nextTier = PerformanceEvalCst.tierMap.get(this.partnerTier);
                    tiers.add(this.partnerTier);
                    if(nextTier != null)
                         tiers.add(nextTier);
               }
                  
               Tier__c currentTierObj;
               Tier__c nextTierObj;
               if(tiers.size() > 0){
                 for(Tier__c tier : [select Tier_Name__c from Tier__c where Tier_Name__c IN : tiers  and country__c = : country_full_name]){
                    currentTierObj = tier.Tier_Name__c == this.partnerTier ? tier : currentTierObj;
                    nextTierObj = tier.Tier_Name__c == nextTier ? tier : nextTierObj;
                 }                   
               }   
               //Case#00066053 end                               
               
               //Modified by Neeraj
               if(performancelst != null && performancelst.size() > 0 && currentTierObj != null)
                currentMetricList = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c,Account__c,Performance_metric__c,Metric_Min_Value__c,Metric_Max_Value__c from  Metrics__r where account__c =: this.accountId ),isRSMView__c from Metric_Tier_Relation__c where Tier__c =:currentTierObj.id and Performance_Metric__c=:performancelst.get(0).Id and Stay_Tier__c=: true and inactive__c=: false ORDER by Sequence_Order__c];//added for case # 00052695
                //currentMetricList = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r where account__c =: this.accountId ),isRSMView__c from Metric_Tier_Relation__c where Tier__c =:currentTierObj.get(0).id and Performance_Metric__c=:performancelst.get(0).Id and Stay_Tier__c=: true and inactive__c=: false ORDER by Sequence_Order__c];//Shishir: removed and isRSMView__c =: false condition REMOVED  OR Benefit_Tier__c=: true)
               
               if(performancelst != null && performancelst.size() > 0 && nextTierObj != null)
                nextMetricList = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Stay_Tier__c,Enter_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c,Account__c,Performance_metric__c,Metric_Min_Value__c,Metric_Max_Value__c from  Metrics__r where account__c =: this.accountId ),isRSMView__c from Metric_Tier_Relation__c where Tier__c =:nextTierObj.id and Performance_Metric__c=:performancelst.get(0).Id and Enter_Tier__c=: true and inactive__c=: false ORDER by Sequence_Order__c];//added for case # 00052695
                //nextMetricList = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Stay_Tier__c,Enter_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r where account__c =: this.accountId ),isRSMView__c from Metric_Tier_Relation__c where Tier__c =:nextTierObj.get(0).id and Performance_Metric__c=:performancelst.get(0).Id and Enter_Tier__c=: true and inactive__c=: false ORDER by Sequence_Order__c];//Shishir: removed and isRSMView__c =: false condition
               
               for(Metric_Tier_Relation__c mtr :currentMetricList){
                System.debug('=========currentMetricList=========='+mtr);
                if(mtr.Metric_Input_Type__c == 'Manual'){
                    metricLabelsInStayTier.add(mtr.Metric_Label__c);
                    
                }
               }
               for(Metric_Tier_Relation__c mtr1 :nextMetricList){
                System.debug('=========nextMetricList=========='+mtr1);
               }
               //System.debug('=========nextMetricList=========='+nextMetricList);
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
                   todayDate = Date.Today();
                   PerformanceCompositeController.addCompositeMetricForSPWR(compositeSPWRCurrentList,all_spwr_solutions_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                   PerformanceCompositeController.addCompositeMetricForSPWR(compositeSPWRNextList,all_spwr_solutions_Next,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId);                            
                   //For Market
                   PerformanceCompositeController.addCompositeMetricForMarket(compositeMarketCurrentList,marketing_Current,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId); 
                   PerformanceCompositeController.addCompositeMetricForMarket(compositeMarketNextList,marketing_Next,performancelst.get(0).Performance_Evaluation_Cut_off_Date__c,performancelst.get(0).Id,this.accountId);                            
                   //Added By hemant to check a new metric "Co Branding"
                   //System.debug('=======1.marketing_Current===='+marketing_Current);                
                   //checkMarketingAutomated(marketing_Current, this.partnerTier);  
                   //System.debug('=======2.marketing_Current===='+marketing_Current);                 
                   //checkMarketingAutomated(marketing_Next, this.partnerTier); 
                   checkMarketingAutomated(listMarketingChildren_Current, 'Current'); 
                   checkMarketingAutomated(listMarketingChildren_Next, 'Next');
                   // Done for Case # 00082034 [Making metrics present in Both Tiers Editable in Next Tier also]
                   //checkAllEnterLists();                  
               } 
               
               if(this.partnerTier!=null)
               {
                   if(this.partnerTier.equals('Premier')){
                       StartDate=getDateFormat(acc.Promoted_Premier_Date__c);
                   }else if(this.partnerTier.equals('Authorized')){
                       StartDate=getDateFormat(acc.Authorized_Partner_Date__c);
                   }else if(this.partnerTier.equals('Elite')){
                        System.debug('###Neeraj0###' + acc.Id);
                        System.debug('###Neeraj1###' + acc.Elite_partner_Date__c);
                        System.debug('###Neeraj2###' + getDateFormat(acc.Elite_partner_Date__c));
                        StartDate=getDateFormat(acc.Elite_partner_Date__c);
                   }else if(this.partnerTier.equals('SRI')){
                       StartDate=getDateFormat(acc.Residential_Installer_Date__c);
                   }
                   System.debug('####StartDate####' + StartDate);
               }
           }
       }
   }
   
   // check for error message
   public Boolean getHasErrorMessage(){   		
    	return ApexPages.hasMessages();    	
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
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Double achieve=PerformanceAchievementClass.computeBASICTRAINING(this.accountId);
                           m.metric.Achievement_Value__c=Math.round(achieve);
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
                       
                       Double achieve=PerformanceAchievementClass.computeBASICTRAINING(this.accountId);
                       met.Achievement_Value__c=Math.round(achieve);
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
               if(this.all_spwr_solutions_Current != null && this.all_spwr_solutions_Current.size()> 0)
                this.all_spwr_solutions_Current.clear();
               if(this.listMarketingChildren_Current != null && this.listMarketingChildren_Current.size() > 0)
                    this.listMarketingChildren_Current.clear();
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
               if(this.all_spwr_solutions_Next != null && this.all_spwr_solutions_Next.size()> 0)
                this.all_spwr_solutions_Next.clear();
               
               this.compositeSPWRNextList.clear();
               if(this.listMarketingChildren_Next != null && this.listMarketingChildren_Next.size() > 0)
                    this.listMarketingChildren_Next.clear();
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
                              if(expDate > Date.Today() && m.metric.Overriden__c==false){
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
                                     if(expDate > Date.Today() && m.metric.Overriden__c==false)
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
                                  if(expDate > Date.Today() && m.metric.Overriden__c==false){ 
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
                       /*Added by hemant*/
                       if(mtr.Child_Metric__c == true){
                           m.meetricTierRel = mtr;
                           List<Metric__c> mlst = mtr.Metrics__r;
                           if(mlst != null && mlst.size() > 0  ){
                                m.metric = mlst.get(0);                              
                           }else{
                                Metric__c met = new Metric__c();
                                met.Account__c = this.accountId;
                                met.Metric_Tier_Relation__c = mtr.Id;
                                met.Performance_Metric__c = performanceId;
                               
                                met.Boolean_Achievement__c = false;
                                met.Goal_Met__c=false;
                                m.metric = met; 
                           }
                        
                           if(tierType.equals('Current')){
                               this.listMarketingChildren_Current.add(m);    
                           }else{
                               this.listMarketingChildren_Next.add(m);    
                           }
                           continue;
                       }
                       /*end*/ 
                       
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
                                  if(expDate > Date.Today() && m.metric.Overriden__c==false){ 
                                      
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
                        //Not applied for Germany.
                        //If RVAR invoiced kW amount is below that the threshold described, 
                        //metric is disabled for that partner and it’s not taken into account for 
                        //the partner evaluation at the requirements to enter Premier set of metrics.
                        
                        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.RESIDENTIAL_LOAN_PA_EU_RVAR)){  
                            if(tierType.equals('Next') && country_full_name != 'Germany' && mtr.Thershold__c != null){
                                if(PerformanceAchievementClass.isMoveToPremier(this.accountID, mtr.Thershold__c)){
                                    continue;
                                }
                            }
                        }
                                    
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
                                  if(expDate > Date.Today() && m.metric.Overriden__c==false){
                                    AutomatedSPWRMetric(m.metric,mtr,startDate,endDate);
                                  }
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
                               System.debug('tierType==============' + tierType);
                               System.debug('$$$$$$$all_spwr_solutions_Next$$$$$$$$'+all_spwr_solutions_Next.size());
                               this.all_spwr_solutions_Next.add(m);
                               System.debug('$$$$$$$all_spwr_solutions_Next$$$$$$$$'+all_spwr_solutions_Next.size());
                           }                       
                        }  
                   }
               }
           }
       }
   }
   
   /*hemant */
   // Done for Case # 00082034 [Making metrics present in Both Tiers Editable in Next Tier also]
   /*public void checkAllEnterLists(){
       checkForBothTabs(this.customer_Satisfaction_Next);
       checkForBothTabs(this.training_Next);
       checkForBothTabs(this.performance_to_business_Plan_Next);
       checkForBothTabs(this.marketing_Next);
       checkForBothTabs(this.all_spwr_solutions_Next);     
   }*/
   
    /*hemant */
    // Done for Case # 00082034 [Making metrics present in Both Tiers Editable in Next Tier also]
   /*public void checkForBothTabs(List<MetricsDetails> metricData){
     for(MetricsDetails mtd : metricData){
        if(mtd.meetricTierRel.Metric_Input_Type__c == 'Manual' && metricLabelsInStayTier.contains(mtd.meetricTierRel.Metric_Label__c)){
            mtd.isPresentInBothTabs = true;
        }
     }
   }*/
   
   /*Created by hemant */
   //This metric is met when 2 of 8(for Premier)/6 of 8(for Elite) in marketing metrics will met.
   public void checkMarketingAutomated(List<MetricsDetails> metricData, String tierType){
        Integer counter = 0 ;
        Integer scoreForBonusExtraTraining = 0;
        List<MetricsDetails> childSPWRLogo = new List<MetricsDetails>();
        List<MetricsDetails> childCoBranding = new List<MetricsDetails>();
        
        //Since all the 8 metrics are manual we need to check their Goal_Met__c field to
        //to see whether met or not(no formula required for that)
        for(MetricsDetails mtd : metricData){
            if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_SHOWROOM_DISPLAY_RVAR)){
                childCoBranding.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_ALL_VEHICLES_RVAR)){
                childCoBranding.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_BUSINESS_CARDS_RVAR)){
                childCoBranding.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDED_SALES_INSTALLATION_APPAREL_RVAR)){
                childCoBranding.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CERT)){
                childCoBranding.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_LOCAL_EVENTS_RVAR)){
                childCoBranding.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKETADV)){
                childCoBranding.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_JOB)){
                childCoBranding.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    counter++;
                }
            }/*SunPower Dealer Webpage and Logo Usage :Elements(it has 4 elements)*/
            else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_HOMEPAGE)){
                childSPWRLogo.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    scoreForBonusExtraTraining++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_PRODUCTS_PAGE)){
                childSPWRLogo.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    scoreForBonusExtraTraining++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_DEALER_LOGO_ON_ABOUTUS_PAGE)){
                childSPWRLogo.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    scoreForBonusExtraTraining++;
                }
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MAINTAINS_WEBPAGE_CONSUMER_ADVANTAGE)){
                childSPWRLogo.add(mtd);
                if(mtd.metric.Goal_Met__c){
                    scoreForBonusExtraTraining++;
                }
            }
        }
        
        System.debug('====childCoBranding====='+childCoBranding);
        System.debug('====childSPWRLogo====='+childSPWRLogo);
        List<MetricsDetails> listMainMarketing;
        if(tierType == 'Current'){
            listMainMarketing = this.marketing_Current;
        }else{
            listMainMarketing = this.marketing_Next;
        }
                           
        
        //For Premier tier counter(met) should be greater than 2 and for Elite counter(met) should greater that 6
        for(MetricsDetails mtd : listMainMarketing){        
            if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CO_BRANDING_RVAR)){
                /*
                if(tierName == 'Premier'){
                    if(counter >= 2){
                        mtd.metric.Goal_Met__c = true;
                    }
                }else if(tierName == 'Elite'){
                    if(counter >= 6){
                        mtd.metric.Goal_Met__c = true;
                    }
                }*/
                mtd.isComposite = true;
                if(mtd.listChildren != null && mtd.listChildren.size() > 0){
                    mtd.listChildren.clear();
                }
                mtd.listChildren = childCoBranding;
                PerformanceAchievementClass.automatedDoubleGoalCheck(mtd.metric, mtd.meetricTierRel, counter);
            }else if(mtd.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_USA_M3)){
                mtd.isComposite = true;
                if(mtd.listChildren != null && mtd.listChildren.size() > 0){
                    mtd.listChildren.clear();
                }
                mtd.listChildren = childSPWRLogo;
                PerformanceAchievementClass.automatedDoubleGoalCheck(mtd.metric, mtd.meetricTierRel, scoreForBonusExtraTraining);
            }
        }
        
   }
   
   //calculation for Automated SPWR metric
   public void AutomatedSPWRMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_SALES_KITS)){
           Double achievement=PerformanceAchievementClass.computeSEVENTYSALESKITS(this.accountId,startDate,endDate);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.OPP_CLOSE_RATE)){
           Double achieve=PerformanceAchievementClass.computeOPPCLOSERATE(this.accountId);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_RES_KITS_EU)){
           //code added for phase2a on 5/5/10 waiting for confirmation
           
           //Added by neeraj
           //Double achievement=PerformanceAchievementClass.computeSEVENTYRESKITSEU(this.accountId,startDate,endDate);
           Double achievement=PerformanceAchievementClass.computeSEVENTYRESKITSEU(this.accountId,startDate,endDate,String.valueOf(mtr.Performance_Metric__r.country__c),mtr.Performance_Metric__r.racking_price__c);
          
           
           // PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achievement);
        }   
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_COM_INVTR_EU)){
           //code added for phase2a on 5/5/10 waiting for confirmation 
           Double achievement=PerformanceAchievementClass.computeSEVENTYCOMINVTREU(this.accountId,startDate,endDate);
           //PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achievement);
        }
        
         //Sunpower Residential Loan Program Signed(added by Neeraj)
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SPWR_RESIDENTIAL_LOAN_PS_EU_RVAR)){
            System.debug('=================In SPWR_RESIDENTIAL_LOAN_PS_EU_RVAR' + PerformanceEvalCst.SPWR_RESIDENTIAL_LOAN_PS_EU_RVAR);
            Boolean score = PerformanceAchievementClass.IsSunpowerResidentialLoanProgramSignedEU(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, score);
        }
   }
   //Calculation for Performance to Bussiness plan Automated metric
   public void AutomatedPbpMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
   {  
    System.debug('==============mtr.Metric_Label__c============== ' + mtr.Metric_Label__c);
       if(mtr.Metric_Label__c.equals(PerformanceEvalCst.ACTIVE_DEALER)){
            if(mtr.Tier__r.Tier_Name__c == 'Authorized'){
                Boolean achievement=PerformanceAchievementClass.computeACTIVEDEALER_AUTHO(this.accountId,startDate,endDate);
                PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
            }else{
                Boolean achievement=PerformanceAchievementClass.computeACTIVEDEALER(this.accountId,startDate,endDate);
                PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
            }
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
        //Code added for Phase2a for Credit Limit for SRI on 11may
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CREDIT_LIMIT_SRI)){
            Boolean goalMet=PerformanceAchievementClass.computeCREDITLIMITSRI(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,goalMet);
        }
        if((mtr.Metric_Label__c.equals(PerformanceEvalCst.SIX_MONTHS_AS_AUTH))
           || (mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_EXP_SIX_MONTHS_EU))){
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
            //Boolean achievement=PerformanceAchievementClass.computeRETROFITSOLARSYS(this.accountId);
            //PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
            //Modified by Neeraj (21-Dec-2010)
            Double score=PerformanceAchievementClass.computeRETROFITSOLAR_NA(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,score);
            
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.BGSM_SCORECARD_EU)
           || mtr.Metric_Label__c.equals(PerformanceEvalCst.BGSM_SCORECARD_EU_CLONE)){
            Double score=PerformanceAchievementClass.computeBGSMScore(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,score);
            
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_QUAT_SALES_EU)){
            system.debug('minimumSales');
            Boolean achievement=PerformanceAchievementClass.computeMINQUATSALESEU(this.accountId,startDate,endDate);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        } 
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_QUAT_SALES_EU_CLONE)){
            Boolean achievement=PerformanceAchievementClass.computeMINQUATSALESEUCLONE(this.accountId,startDate,endDate);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MIN_SALES_AUTHZ_EU)){
            Boolean achievement=PerformanceAchievementClass.computeMINSALESAUTHZEU(this.accountId);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,achievement);
        } 
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.KW_TARGET_EU)){
            Double score=PerformanceAchievementClass.computeKWTARGETEU(this.accountId,startDate,endDate);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,score);            
        }
        
         //Up to date with payments(added by Neeraj)
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.UP_TO_DATE_PAYMENT_EU_RVAR)){
            System.debug('=============inside========');
            Boolean score = PerformanceAchievementClass.isUpToDateWithPaymentEU(this.accountId);
            System.debug('=============Score========'+ score);
            PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, score);
        }
        
        
   }
   
   //Calculation for Training Automated metric
   public void AutomatedTrainingMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate)
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
            //for case # 00053810
            if(this.partnerTier!=null && this.partnerTier == PerformanceEvalCst.PA_TIER_AUTHORIZED)
                achieve = achieve + PerformanceAchievementClass.computeTRAININGASSSALES(this.accountId);
            //for case # 00053810
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
        // code added for phase2a  for training Bonus for Extra by Reshma
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_I)){
            Double achieve=PerformanceAchievementClass.computeEXTRABONUSI(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        // code added for phase2a  for training Bonus for Extra by Reshma
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II)){
            Double achieve=PerformanceAchievementClass.computeEXTRABONUSII(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        
        //Sunrise 2b (Smarter Selling) 
        //For Italy and Germany Premier
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.FUNDAMENTAL_TRAINING_SMARTER_SELLING_EU)){
            Double achieve = PerformanceAchievementClass.smarterSelling_EU(this.accountId, this.country_full_name);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m, mtr, achieve);
        }
        
        //For Italy and france SRI only
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.FUNDAMENTAL_TRAINING_DESIGN_SPFR_EU)){
            Double achieve = PerformanceAchievementClass.fundamentalDesignSPFRTraining_EU(this.accountId);
            PerformanceAchievementClass.automatedDoubleGoalCheck(m, mtr, achieve);
        }
        
        //For Italy and France SRI only
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
   //Calculation for Customer Satisfaction Automated Metric
   private void AutomatedCSATMetric(Metric__c m,Metric_Tier_Relation__c mtr,Date startDate,Date endDate,String tierType)
   {
      /* if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE)){
           Double csatScore=PerformanceAchievementClass.computeCSATSCORE(this.accountId,startDate,endDate);  
           m.Achievement_Value__c  = csatScore;
           Double min=mtr.Metric_Min_Value__c;
           Double max=mtr.Metric_Max_Value__c;
           Boolean csatGoalMet=PerformanceAchievementClass.checkGoalMet(min,max,csatScore);
           //code changed for phase2a on 3 may 10 Code commented till Dave's confirmation
           Double thershold = mtr.Thershold__c;
           Boolean countGoal = PerformanceAchievementClass.checkCSATCount(this.accountId,startDate,endDate,thershold);
           if(csatGoalMet && countGoal){
                m.Goal_Met__c = true;       
           }else{
                m.Goal_Met__c=false;    
           }
           
        }*/
        
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE_EU)||mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SCORE)){
           //for case # 00052350
           //Double csatScore=PerformanceAchievementClass.computeCSATSCORE(this.accountId,startDate,endDate);
           Double csatScore=PerformanceAchievementClass.computeCSATSCORE(this.accountId,startDate,endDate,currentPM);
           //for case # 00052350
           System.debug('ScoreResh'+csatScore);  
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,csatScore);
        }
        //code added for Phase 2a for CSAT Requirement on 11May
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CSAT_SURVEY_REQ)){
            //for case # 00052350
            //Double csatSurveyReq=PerformanceAchievementClass.computeCSATSURVEYREQ(this.accountId,startDate,endDate);  
            Double csatSurveyReq=PerformanceAchievementClass.computeCSATSURVEYREQ(this.accountId,startDate,endDate, currentPM);
            //for case # 00052350
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,csatSurveyReq);  
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION) ){ //|| mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_EU)
            //It is For NA                      
            Boolean siteInspection=PerformanceAchievementClass.coumputeSITEINSPECTION(this.accountId,startDate,endDate);  
            PerformanceAchievementClass.automatedBooleanGoalCheck(m,mtr,siteInspection);           
        }
        //code for phase2 on 29 apr 10
        /* commented by hemant 
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_EU)){
            Id acountId = this.accountId;
            Id t = mtr.Tier__c;
            if(tierType.equals('Current')){             
                Double siteInspection=PerformanceAchievementClass.coumputeSITEINSPECTIONEUSTAY(this.accountId,startDate,endDate);  //changed coumputeSITEINSPECTION to coumputeSITEINSPECTIONEUSTAY            
                m.Achievement_Value__c = Math.round(siteInspection); 
                Double min=mtr.Metric_Min_Value__c;
                Double max=mtr.Metric_Max_Value__c;
                Boolean inspectionGoalMet=PerformanceAchievementClass.checkGoalMet(min,max,siteInspection);            
                m.Goal_Met__c=inspectionGoalMet;                
            }else if(tierType.equals('Next')){              
                Double siteInspection=PerformanceAchievementClass.coumputeSITEINSPECTIONEU(acountId,startDate,endDate,t);                                           
                m.Achievement_Value__c = Math.round(siteInspection);
                Double min=mtr.Metric_Min_Value__c;
                Double max=mtr.Metric_Max_Value__c;             
                Boolean inspectionGoalMet=PerformanceAchievementClass.checkGoalMet(min,max,siteInspection);           
                m.Goal_Met__c=inspectionGoalMet;                
            }
        }*/
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.CUSTOMER_COMPLAINTS)){
            Double complaints=PerformanceAchievementClass.coumputeCUSTOMERCOMPLAINTS(this.accountId,startDate,endDate);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,complaints);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.PERCENT_INSTALL_CRM)){
           Double percentInstalls=PerformanceAchievementClass.computePERCENTINSTALLCRM(this.accountId,startDate,endDate);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,percentInstalls);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SITE_INSPECTION_NON_COMP)){
           Double achieve=PerformanceAchievementClass.coumputeSITEINSPECTIONNONCOMP(this.accountId,startDate,endDate);
           PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        // code added for SunrisePhase 2a on 28Apr 10 by Reshma for Warranty cards
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.WARRANTY_CARDS_NA)){
            Double achieve =PerformanceAchievementClass.computeWARRANTYCARDSNA(this.accountId,startDate,endDate) ;  
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
        if(mtr.Metric_Label__c.equals(PerformanceEvalCst.WARRANTY_CARDS_EU)){
            // Done for case # 00064909
            // Double achieve =PerformanceAchievementClass.computeWARRANTYCARDSEU(this.accountId,startDate,endDate) ;  
            Double achieve =PerformanceAchievementClass.computeWARRANTYCARDSEU(this.accountId,startDate,endDate,currentPM) ;
            PerformanceAchievementClass.automatedDoubleGoalCheck(m,mtr,achieve);
        }
         
        //Sunrise 2b (Automated Inspection Metric)
        if(mtr.Metric_Label__c.equalsIgnoreCase(PerformanceEvalCst.SITE_INSPECTION_EU)){
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
                    Boolean achieve;
                    if(tierType.equals('Current')){
                        achieve = PerformanceAchievementClass.inspectionAuthorised_EU(this.accountId, startDate, endDate, 'stay', this.country_full_name, currentPM);
                    }else{
                        achieve = PerformanceAchievementClass.inspectionAuthorised_EU(this.accountId, startDate, endDate, 'enter', this.country_full_name, currentPM);
                    }
                    PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, achieve);
                }else if(mtr.Tier__r.Tier_Name__c == 'Premier'){
                    Boolean achieve;
                    if(tierType.equals('Current')){
                        achieve = PerformanceAchievementClass.inspectionPremier_EU(this.accountId, startDate, endDate, 'stay', this.country_full_name, currentPM);
                    }else{
                        achieve = PerformanceAchievementClass.inspectionPremier_EU(this.accountId, startDate, endDate, 'enter', this.country_full_name, currentPM);
                    }
                    PerformanceAchievementClass.automatedBooleanGoalCheck(m, mtr, achieve);
                }
            }                
        }
   }
    
    public PageReference updateEvaluation(){
        System.debug('============1========' + all_spwr_solutions_Next.size());   
        updateMetricRecords();
        System.debug('============2========' + all_spwr_solutions_Next.size());
        //call constructor function
       // this.retriveAccountInfo();
        clkSave = ApexPages.currentPage().getParameters().get('clksave');
        System.debug('************************clicksave  '+clkSave);
        if(clksave == null){
            /* Done for case # 00054448 */             
            system.debug('-------activeTab----------'+activeTab); 
            if(activeTab == 'current' ){
                UpdateOtherTiers(customer_Satisfaction_Current,customer_Satisfaction_Next);
                
                System.debug('####performance_to_business_Plan_Current####' + performance_to_business_Plan_Current);
                System.debug('####performance_to_business_Plan_Next####' + performance_to_business_Plan_Next);
                
                UpdateOtherTiers(performance_to_business_Plan_Current,performance_to_business_Plan_Next);
                UpdateOtherTiers(training_Current,training_Next);
                
                System.debug('####marketing_Current####' + performance_to_business_Plan_Current);
                System.debug('####marketing_Next####' + performance_to_business_Plan_Next);
                
                //UpdateOtherTiers(this.listMarketingChildren_Current);
                UpdateOtherTiers(this.listMarketingChildren_Current,this.listMarketingChildren_Next);
                
                UpdateOtherTiers(marketing_Current,marketing_Next);
                System.debug('============3========' + all_spwr_solutions_Next.size());
                UpdateOtherTiers(all_spwr_solutions_Current,all_spwr_solutions_Next);
                System.debug('============4========' + all_spwr_solutions_Next.size());
                updateCompositeMetricForMarket(marketing_Next); 
            }else{
                UpdateOtherTiers(customer_Satisfaction_Next,customer_Satisfaction_Current);
            
                System.debug('####performance_to_business_Plan_Current####' + performance_to_business_Plan_Current);
                System.debug('####performance_to_business_Plan_Next####' + performance_to_business_Plan_Next);
                
                UpdateOtherTiers(performance_to_business_Plan_Next,performance_to_business_Plan_Current);
                UpdateOtherTiers(training_Next,training_Current);
                
                System.debug('####marketing_Current####' + performance_to_business_Plan_Current);
                System.debug('####marketing_Next####' + performance_to_business_Plan_Next);
                
                //UpdateOtherTiers(this.listMarketingChildren_Current);
                //Case#00092571 (commented lines)- Marketing metric should not be updated from Next Tier to Current Tier
                //UpdateOtherTiers(this.listMarketingChildren_Next,this.listMarketingChildren_Current);//for Case# 00092571
                 
                //UpdateOtherTiers(marketing_Next,marketing_Current);//for Case# 00092571
                System.debug('============3========' + all_spwr_solutions_Next.size());
                UpdateOtherTiers(all_spwr_solutions_Next,all_spwr_solutions_Current);
                System.debug('============4========' + all_spwr_solutions_Next.size());
                //updateCompositeMetricForMarket(marketing_Current);//for Case# 00092571
            }            
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
        /*hemant;insert/update marketing child metric*/
        System.debug('####this.listMarketingChildren_Current####' + this.listMarketingChildren_Current);
        updateAchievement(this.listMarketingChildren_Current);
        updateAchievement(this.listMarketingChildren_Next);
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
                                    mdu.metric.Achievement_Value__c = Math.round(mdo.metric.Achievement_Value__c);
                                    mdu.metric.Goal_Met__c = mdo.metric.Goal_Met__c ;   
                                }
                            }else if(mdu.meetricTierRel.Metric_Max_Value__c!=null && mdo.meetricTierRel.Metric_Max_Value__c!=null){
                                if(mdu.meetricTierRel.Metric_Max_Value__c == mdo.meetricTierRel.Metric_Max_Value__c){ 
                                    mdu.metric.Achievement_Value__c = Math.round(mdo.metric.Achievement_Value__c);
                                    mdu.metric.Goal_Met__c = mdo.metric.Goal_Met__c ;
                                }   
                            }
                        } 
                        //added by Neeraj
                        if(mdo.metric.Achievement_Value__c != null && mdu.meetricTierRel.Metric_Input_Type__c == 'Manual' && mdo.meetricTierRel.Metric_Input_Type__c=='Manual'){
                        mdu.metric.Achievement_Value__c =Math.round(mdo.metric.Achievement_Value__c);                   
                     }
                     
                }
                               
                metricsList.add(mdu.metric);
                }
                // check if this list is created.
            }
            System.debug('####metricsList####'+ metricsList);
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
                      Boolean goal=PerformanceCompositeController.checkMarketUSAGoalMet(currentTier);
                      m.metric.Goal_Met__c=goal;
                      m.metric.Boolean_Achievement__c=goal; 
                      update m.metric;
                  }
             }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.THREE_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                 {
                    Boolean goal=PerformanceCompositeController.checkMarketEUGoalMet(currentTier,'THREE');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal; 
                    update m.metric;
                 }   
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.FOUR_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                {
                    Boolean goal=PerformanceCompositeController.checkMarketEUGoalMet(currentTier,'FOUR');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    update m.metric;
                }    
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SIX_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                  {
                    Boolean goal=PerformanceCompositeController.checkMarketEUGoalMet(currentTier,'SIX');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    update m.metric;
                  }  
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SEVEN_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                 {
                    Boolean goal=PerformanceCompositeController.checkMarketEUGoalMet(currentTier,'SEVEN');
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
                            achieve=Math.round(md.metric.Achievement_Value__c);
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
                            achieve=Math.round(md.metric.Achievement_Value__c);
                            if(achieve<=max)
                            {
                                md.metric.Goal_Met__c=true;
                                
                            }    
                            else
                                md.metric.Goal_Met__c=false; 
                                
                             requiredLimit  = max;
                        }
                        //for case # 00052695
                        if(md.meetricTierRel.Metric_Description__c == PerformanceEvalCst.PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR
                            ||md.meetricTierRel.Metric_Label__c == PerformanceEvalCst.PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR){
                            System.debug('In Id->'+md.metric.Id);
                            System.debug('In Account->'+this.accountId);                         
                            Metric__c metric = updShareOfAccBonus(md.metric);
                            if(metric!=null){
                                metricsUpdate.add(metric);
                            }
                        }//for case # 00052695
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
        integer retryCounter = 0;
         while (retryCounter <= 5){
            try{
                 update metricsUpdate;
                 break;                   
                
             }catch(Exception e){
                if(e.getMessage().contains('UNABLE_TO_LOCK_ROW')){                                      
                    retryCounter++;
                }
            }
            
        }
       } 
       if(metricsNew.size()>0)
       insert metricsNew;
    }
    //for case # 00052965
    private Metric__c updShareOfAccBonus(Metric__c metric){
        //Metric__c oldMetric = [select Performance_Metric__c, Account__c from Metric__c where Id=:metric.Id limit 1];
        List<Metric__c> metricList = [select Achievement_Value__c, Metric_Tier_Relation__r.Metric_Min_Value__c 
                                        , Metric_Tier_Relation__r.Metric_Max_Value__c, Goal_Met__c
                                        //, Performance_Metric__c, Account__c  
                                        from Metric__c 
                                        where (Metric_Tier_Relation__r.Metric_Description__c = :PerformanceEvalCst.SHARE_OF_ACCOUNT_BONUS or Metric_Tier_Relation__r.Metric_Label__c = :PerformanceEvalCst.SHARE_OF_ACCOUNT_BONUS) 
                                        and Account__c = :metric.Account__c 
                                        and Performance_Metric__c = :metric.Performance_Metric__c limit 1];
        Double achieve = Math.round(metric.Achievement_Value__c);
        System.debug('return thru function->'+metricList.size());       
        if(metricList.size()==0)
            return null;
        Metric__c updmetric = metricList.get(0);
        updmetric.Achievement_Value__c = metric.Achievement_Value__c;
        /*if(updmetric.Metric_Tier_Relation__r.Metric_Min_Value__c!=null){
            Double min=updmetric.Metric_Tier_Relation__r.Metric_Min_Value__c;
            if(achieve>=min)
                updmetric.Goal_Met__c=true;
            else
                updmetric.Goal_Met__c=false;
        }else if(updmetric.Metric_Tier_Relation__r.Metric_Max_Value__c!=null){
            Double max=updmetric.Metric_Tier_Relation__r.Metric_Max_Value__c;
            if(achieve<=max)
                updmetric.Goal_Met__c=true;
            else
                updmetric.Goal_Met__c=false;
        }*/
        System.debug('return thru function->'+updmetric.Id);
        System.debug('return thru function->'+updmetric.Achievement_Value__c);
        System.debug('return thru function->'+updmetric.Goal_Met__c);
        return updmetric;
    }
    //for case # 00052965
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
        String currentQuarter=PerformanceAchievementClass.getCurrentQuarter();
        String perfmMetricId=this.performanceMetricID;
        String accId=this.accountId;
        if(perfmMetricId!=null && accId!=null)
        {
            quarterIncentice=[select Id,Total_Incentive_QTD__c,Total_Credit_Memo_QTD__c,Account__c,Performance_Metric__c from Quarterly_Performance_Evaluation__c where Account__c=:accId and Performance_Metric__c=:perfmMetricId and Quarter__c=:currentQuarter and Year__c=:(Date.Today().year())];
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
                obj.Year__c=Date.Today().year();
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
    
    public void expandChildren(){
       String mkId;
      
       if(ApexPages.currentPage().getParameters().get('mkId_Next') != null){
            mkId = ApexPages.currentPage().getParameters().get('mkId_Next');
            System.debug('==1. mkId===='+mkId);
            
            for(MetricsDetails mr: marketing_Next){
               if(mr.meetricTierRel.Id == mkId){
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
       }else{
            mkId = ApexPages.currentPage().getParameters().get('mkId_Current');
            System.debug('==2. mkId===='+mkId);
            for(MetricsDetails mr: marketing_Current){
               if(mr.meetricTierRel.Id == mkId){
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
       
      
   }
   
    //Inner Class 
    public class MetricsDetails{
        public Metric_Tier_Relation__c meetricTierRel;
        public Metric__c metric;
        public Boolean isPresentInBothTabs{get;set;}
        public List<MetricsDetails> listChildren{get;set;}
        public Boolean isComposite{get;set;}
        public Boolean expand{get;set;}
       
        public Metric_Tier_Relation__c getmeetricTierRel(){
            return this.meetricTierRel;
        }
        public Metric__c getMetric(){
            return this.metric;
        }
        public MetricsDetails(){
            isPresentInBothTabs = false;
            expand = false;
        }
        public MetricsDetails(Boolean isComposite){
            isPresentInBothTabs = false;
            this.isComposite = isComposite;
            expand = false;
            listChildren = new List<MetricsDetails>();
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
    
    public PageReference goToPreviousperformanceEvalPage(){
        return new PageReference('/apex/performanceEvalpreviousPage?accid='+this.accountId);
    } 
    
    public void updateMetrics(){
    }
    
    
}