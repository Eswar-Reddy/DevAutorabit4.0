/*********************************************** 
**PR-01771
**by- Kapil Goutam
**on - May 20 2009  
**Description- Controller class for MDTF_Account

**  Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016
**  Case 00505731-Pivotal #114607087-Debasish-Sum of balance on Fund Summary tab-Release 45 - 10/05/2016
**  Case 00505731-Pivotal #114607243-Debasish-Ability to export Dealer Program Funds list into excel/csv - Release 45 - 10/10/2016
************************************************************************************************************************************/
public class MDTF_AccountController {
   //public Account acc{get;set;}
    public String accId{get;set;}
    public List<SmartStore_Details__c> smartStore{get;set;}
    public transient List<MDTF_Activities__c>  mdtfActivities{get;set;}
    //public List<MDTF_Prior_Approvals__c> mdtfPriorApprovals{get;set;}
    public transient List<MDTF_Claim__c> mdtfClaim{get;set;}
    public transient List<MDTF_Claim__c> mdtfTraining{get;set;}
    public transient List<MDTF_Fund_Summary__c> mdtfFundSummary{get;set;} 
    //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Starts
    public transient List<MDTF_Lead_Generation_Fee__c> mdtfLeadGenFee{get;set;}
    //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Ends
    //public List<FundSummary> lstMDTFFundSummary{get;set;}
    //To add column 'Paid' in Fund Summary list
    private map<String,double> mapFundSummaryPaid{get;set;} 
    private String sortDirection = 'ASC';   
    private String sortExp = 'name';   
    //case 12594
    public Account account{get;set;}
    //Case 00505731-Pivotal #114607087-Debasish-Sum of balance on Fund Summary tab-Release 45 - 10/05/2016 Starts
    public Decimal sumOfAccrual{get;set;}
    public Decimal sumOfAdvertisingClaims{get;set;}
    public Decimal sumOfMRCPurchase{get;set;}
    public Decimal sumOfLMSSpent{get;set;}
    public Decimal sumOfAvailableBalance{get;set;}
    //Case 00505731-Pivotal #114607087-Debasish-Sum of balance on Fund Summary tab-Release 45 - 10/05/2016 Ends
        
   // public String ACBParanetId{get;set;}
    //proprty for sorting
    //public boolean isEU{get;set;}
    //public boolean isNA{get;set;}
    public String sortExpression   {     
        get{        
            return sortExp;     
        }     
        set{       
            //if the column is clicked on then switch between Ascending and Descending modes       
            if (value == sortExp)         
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';      
            else         
                sortDirection = 'DESC';       
                
            sortExp = value;     
        }   
     }
    //proprty for sorting
    public String getSortDirection() {    
        //if not column is selected    
        if (sortExpression == null || sortExpression == '')      
            return 'ASC';    
        else     
            return sortDirection; 
     } 
    //for sorting 
    public void setSortDirection(String value) {     
        sortDirection = value; 
     }
    
    public MDTF_AccountController(ApexPages.StandardController controller) {
      //this.acc = (Account)controller.getRecord();
      try{
        if(ApexPages.CurrentPage().getParameters().get('Id') != null){
          accId = ApexPages.CurrentPage().getParameters().get('Id');
          // acc = [Select Website, Type, SystemModstamp, Status__c, ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity, RecordTypeId, Phone, Partner_Application__c, ParentId, OwnerId, Override_Duplicate_Check__c, NumberOfEmployees, Name, MasterRecordId, Manage_Opportunities__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsPartner, IsDeleted, Industry, Id, Fax, Description, CurrencyIsoCode, CreatedDate, CreatedById, Country_Domain__c, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, AnnualRevenue, Account_Type__c, Account_Territory__c, Smart_Store_Purchase__c , Expiration__c From Account a where Id=:accId];          
          populate();
          //Case 00505731-Pivotal #114607087-Debasish-Sum of balance on Fund Summary tab-Release 45 - 10/05/2016 Starts  
          sumOfAccrual = getTotalAccrual();
          sumOfAdvertisingClaims = getTotalAdvertisingClaims();
 		  sumOfMRCPurchase = getTotalMRCPurchase();
    	  sumOfLMSSpent = getTotalLMSSpent();
          sumOfAvailableBalance = getTotalAvailableBalance();
          //Case 00505731-Pivotal #114607087-Debasish-Sum of balance on Fund Summary tab-Release 45 - 10/05/2016 Ends
        }
      }
      catch(Exception ex){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
      }            
    }
    
    // Start for Case # 00071201
    public boolean getHasError(){
        if(!Apexpages.currentPage().getParameters().containsKey('id') || ApexPages.hasMessages()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account does not found.'));   
            return true;
        }
        return false;
    }
    // End Case # 00071201.
    
    //Prepare map of FundSummary with Paid amount by adding up Paid column of MDTF Claim according to
    //Promotion field mapping from Fund Summary to MDTF Claim
  /*  private void populateFunSummaryPaidMap(List<MDTF_Fund_Summary__c> lstMDTFfSummary){
        mapFundSummaryPaid = new map<String,double>();
        //Prepare map of promotion with Fund Summary ID 
        map<String,String> mapPromotionSummary = new map<String,String>();
        for(MDTF_Fund_Summary__c objSummary:lstMDTFfSummary){
            mapPromotionSummary.put(objSummary.promotion__c,objSummary.ID);
        }
        
        //Prepare map of fund summary with paid amount      
        for(MDTF_Claim__c objClaim:[Select Paid_Amt__c,promotion__c,account__c from MDTF_Claim__c where promotion__c in :mapPromotionSummary.keySet() and account__c =:accID]){
            if(mapFundSummaryPaid.containsKey(mapPromotionSummary.get(objClaim.promotion__c))){
                double amt = mapFundSummaryPaid.get(mapPromotionSummary.get(objClaim.promotion__c))+ objClaim.Paid_Amt__c;
                mapFundSummaryPaid.put(mapPromotionSummary.get(objClaim.promotion__c),amt);
            }
            else{
                mapFundSummaryPaid.put(mapPromotionSummary.get(objClaim.promotion__c),objClaim.Paid_Amt__c);
            }
        }
    }*/
    
    //Populate fund summary in wrapper class list
    /*private void populateFunSummaryList(List<MDTF_Fund_Summary__c> lstMDTFfSummary){
        lstMDTFFundSummary = new List<FundSummary>();
        for(MDTF_Fund_Summary__c objFS:lstMDTFfSummary){
            FundSummary FS = new FundSummary();
            if(mapFundSummaryPaid.containsKey(objFS.ID)){
                FS.Claim.Paid_amt__c = mapFundSummaryPaid.get(objFS.ID);
            }   
            else{
                FS.Claim.Paid_amt__c = 0;
            }
            FS.Summary.Name = objFS.Name; 
            FS.Summary.Spent__c = objFS.Spent__c;       
            FS.Summary.Promotion_Description__c = objFS.Promotion_Description__c;
            FS.Summary.Allowance__c = objFS.Allowance__c;
            FS.Summary.Claimed_Amt__c = objFS.Claimed_Amt__c;
            FS.Summary.Approved__c = objFS.Approved__c;
            FS.Summary.Balance__c = objFS.Balance__c;
            FS.Summary.Expiration__c = objFS.Expiration__c;
            FS.Summary.Smart_Store_Purchase__c = objFS.Smart_Store_Purchase__c;
            lstMDTFFundSummary.Add(FS);
        }
    }
    */
    //Sort for paid column
   /* public void sortOnPaid(){
        if(lstMDTFFundSummary.size() ==0 )return;      
        for(Integer index =0 ;index<lstMDTFFundSummary.size();index++){
            for(Integer nextIndex = index+1; nextIndex < lstMDTFFundSummary.size();nextIndex++){
                if(sortDirection=='ASC'){        
                    if(lstMDTFFundSummary[index].Claim.Paid_amt__c > lstMDTFFundSummary[nextIndex].Claim.Paid_amt__c){ 
                        FundSummary tmp = lstMDTFFundSummary[index];   
                        lstMDTFFundSummary.set(index,lstMDTFFundSummary[nextIndex]);
                        lstMDTFFundSummary.set(nextIndex,tmp);
                    }
                }else{
                     if(lstMDTFFundSummary[index].Claim.Paid_amt__c < lstMDTFFundSummary[nextIndex].Claim.Paid_amt__c){ 
                        FundSummary tmp = lstMDTFFundSummary[index];   
                        lstMDTFFundSummary.set(index,lstMDTFFundSummary[nextIndex]);
                        lstMDTFFundSummary.set(nextIndex,tmp);
                     }
                } 
            }         
        }//for ends
    }*/
    //sorting for first tab     
    public PageReference sortSmartStore() {       
        //build the full sort expression       
        string sortFullExp = sortExpression  + ' ' + sortDirection;             
        //query the database based on the sort expression       
        smartStore = Database.query('Select id,name,Tracking_Number__c, Status__c, Ship_State__c, Purchase_Type__c, Product_Name__c, Price__c, Order_Number__c, Order_Date__c From SmartStore_Details__c where Account__c=\''+ accId +'\' order by ' + sortFullExp + ' limit 1000');       
        mdtfActivities = new List<MDTF_Activities__c>([Select Transaction_Year__c, Transaction_Month__c, Sum_of_Transaction_Amt__c, Promotion_Description__c, Id, Comment__c, Account__c From MDTF_Activities__c where Account__c=:accId]);
        mdtfClaim = new List<MDTF_Claim__c>([Select Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c, Process_Date__c  From MDTF_Claim__c where Account__c=:accId]);
        mdtfTraining = new List<MDTF_Claim__c>([Select Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=:accId and Activity_Description__c like '%LMS%']);
        mdtfFundSummary = new List<MDTF_Fund_Summary__c>([Select Spent__c, Promotion_Description__c, Id, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=:accId]);
        //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Starts
        string accId15 = accId.substring(0, 15);
        mdtfLeadGenFee = new List<MDTF_Lead_Generation_Fee__c>([Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Transaction_Date__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Partner_Account_Id__c=:accId and Status__c LIKE '%Success%']);
       //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Ends
       
        return null;   
     }
    
    //sorting for second tab
   /* public PageReference sortPriorApprovals(){
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        mdtfPriorApprovals = Database.query('Select SystemModstamp, Promotion__c, Promotion_Year__c, Promotion_Description__c, Open__c, Name, Media__c, Media_Description__c, LastModifiedDate, LastModifiedById, IsDeleted, Id, Expire_Date__c, Estimated_Cost__c, Date_To__c, Date_From__c, CurrencyIsoCode, CreatedDate, CreatedById, Balance__c, Appr_Num__c, Account__c From MDTF_Prior_Approvals__c where Account__c=\''+ accId +'\' order by ' + sortFullExp + ' limit 1000');
        return null;
        
    }*/
    
    //sorting for third tab
    public PageReference sortMdtfActivities(){
        string sortFullExp='';
        if(sortExpression.indexOf('-')>=0){
            String[] str = sortExpression.split('-');
            sortFullExp = str[0]  + ' ' + sortDirection +','+str[1]  + ' ' + sortDirection +' ';
        }
        else{
            sortFullExp = sortExpression  + ' ' + sortDirection;
        }
        system.debug('#######'+sortFullExp);
        //mdtfActivities = Database.query('Select Transaction_Year__c, Transaction_Type__c, Transaction_Month__c, SystemModstamp, Sum_of_Transaction_Amt__c, Promotion__c, Promotion_Year__c, Promotion_Description__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, CurrencyIsoCode, CreatedDate, CreatedById, Comment__c, Account__c From MDTF_Activities__c where Account__c=\''+ accId +'\' order by ' + sortFullExp);        
        /* JAJA - APR-8-2015 - CASE 00481604 */
        mdtfActivities = Database.query('Select Transaction_Year__c, Transaction_Month__c, Sum_of_Transaction_Amt__c, Promotion_Description__c, Id, Comment__c, Account__c From MDTF_Activities__c where Account__c=\''+ accId +'\' order by ' + sortFullExp);
        mdtfClaim = new List<MDTF_Claim__c>([Select Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c, Process_Date__c  From MDTF_Claim__c where Account__c=:accId]);
        mdtfTraining = new List<MDTF_Claim__c>([Select Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=:accId and Activity_Description__c like '%LMS%']);
        mdtfFundSummary = new List<MDTF_Fund_Summary__c>([Select Spent__c, Promotion_Description__c, Id, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=:accId]);
        //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Starts
        string accId15 = accId.substring(0, 15);
        mdtfLeadGenFee = new List<MDTF_Lead_Generation_Fee__c>([Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Transaction_Date__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Partner_Account_Id__c=:accId and Status__c LIKE '%Success%']);
       //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Ends
       
        return null;
        
    }
    //sorting for fifth tab
    public PageReference sortMdtfClaim(){
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        //mdtfClaim = Database.query('Select SystemModstamp, Promotion__c, Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, CurrencyIsoCode, Credit_Memo__c, CreatedDate, CreatedById, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_to_Date__c, Activity_from_Date__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=\''+ accId +'\' order by ' + sortFullExp);
        /* JAJA - APR-8-2015 - CASE 00481604 */
        mdtfClaim = Database.query('Select Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c, Process_Date__c  From MDTF_Claim__c where Account__c=\''+ accId +'\' order by ' + sortFullExp);
        mdtfActivities = new List<MDTF_Activities__c>([Select Transaction_Year__c, Transaction_Month__c, Sum_of_Transaction_Amt__c, Promotion_Description__c, Id, Comment__c, Account__c From MDTF_Activities__c where Account__c=:accId]);
        mdtfTraining = new List<MDTF_Claim__c>([Select Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=:accId and Activity_Description__c like '%LMS%']);
        mdtfFundSummary = new List<MDTF_Fund_Summary__c>([Select Spent__c, Promotion_Description__c, Id, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=:accId]);
        //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Starts
        string accId15 = accId.substring(0, 15);
        mdtfLeadGenFee = new List<MDTF_Lead_Generation_Fee__c>([Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Transaction_Date__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Partner_Account_Id__c=:accId and Status__c LIKE '%Success%']);
       //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Ends
       return null;
        
    }
    public PageReference sortMdtfTraining(){
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        //mdtfTraining = Database.query('Select SystemModstamp, Promotion__c, Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, CurrencyIsoCode, Credit_Memo__c, CreatedDate, CreatedById, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_to_Date__c, Activity_from_Date__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=\''+ accId +'\' and Activity_Description__c like \'%LMS%\' order by ' + sortFullExp);
        /* JAJA - APR-8-2015 - CASE 00481604 */
        mdtfTraining = Database.query('Select SystemModstamp, Promotion__c, Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, CurrencyIsoCode, Credit_Memo__c, CreatedDate, CreatedById, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_to_Date__c, Activity_from_Date__c, Activity_Description__c, Account__c,ACBParanet_ID__c From MDTF_Claim__c where Account__c=\''+ accId +'\' and Activity_Description__c like \'%LMS%\' order by ' + sortFullExp);
        mdtfActivities = new List<MDTF_Activities__c>([Select Transaction_Year__c, Transaction_Month__c, Sum_of_Transaction_Amt__c, Promotion_Description__c, Id, Comment__c, Account__c From MDTF_Activities__c where Account__c=:accId]);
        mdtfClaim = new List<MDTF_Claim__c>([Select Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c, Process_Date__c  From MDTF_Claim__c where Account__c=:accId]);
        mdtfFundSummary = new List<MDTF_Fund_Summary__c>([Select Spent__c, Promotion_Description__c, Id, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=:accId]);
        //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Starts
        string accId15 = accId.substring(0, 15);
        mdtfLeadGenFee = new List<MDTF_Lead_Generation_Fee__c>([Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Transaction_Date__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Partner_Account_Id__c=:accId and Status__c LIKE '%Success%']);
       //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Ends
       return null;
        
    }
    //sorting for sixth tab
    public PageReference sortMdtfFundSummary(){
        /*if(sortExpression=='Paid'){
            //sortOnPaid();
            return null;
        }*/
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        //mdtfFundSummary = Database.query('Select Years_in_Business__c, SystemModstamp, Spent__c, Promotion__c, Promotion_Description__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, Frozen__c, CurrencyIsoCode, CreatedDate, CreatedById, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=\''+ accId +'\' order by ' + sortFullExp);
        /* JAJA - APR-8-2015 - CASE 00481604 */
        mdtfFundSummary = Database.query('Select Spent__c, Promotion_Description__c, Id, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=\''+ accId +'\' order by ' + sortFullExp);
        mdtfActivities = new List<MDTF_Activities__c>([Select Transaction_Year__c, Transaction_Month__c, Sum_of_Transaction_Amt__c, Promotion_Description__c, Id, Comment__c, Account__c From MDTF_Activities__c where Account__c=:accId]);
        mdtfClaim = new List<MDTF_Claim__c>([Select Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c, Process_Date__c  From MDTF_Claim__c where Account__c=:accId]);
        mdtfTraining = new List<MDTF_Claim__c>([Select Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=:accId and Activity_Description__c like '%LMS%']);
        //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Starts
        string accId15 = accId.substring(0, 15);
        mdtfLeadGenFee = new List<MDTF_Lead_Generation_Fee__c>([Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Transaction_Date__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Partner_Account_Id__c=:accId and Status__c LIKE '%Success%']);
       //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Ends
        //populateFunSummaryList(mdtfFundSummary);
        return null;
        
    }
    
    //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Starts
    //sorting for Lead Generation Fees tab    
    public PageReference sortMdtfLeadGenerationFee(){
        //string sortFullExp = sortExpression  + ' ' + sortDirection;
        //string sortFullExp = 'Account__c' + ' ' + 'ASC';
        
        system.debug('Account ID***='+ accId);
        string accId15 = accId.substring(0, 15);
        //mdtfLeadGenFee = Database.query('Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Account_Id__c=\''+ accId +'\' order by ' + sortFullExp);
        
        mdtfLeadGenFee = Database.query('Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Transaction_Date__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Partner_Account_Id__c=\''+ accId + '\' and Status__c LIKE \'%Success%\''); 
        mdtfClaim = new List<MDTF_Claim__c>([Select Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c, Process_Date__c  From MDTF_Claim__c where Account__c=:accId]);
        mdtfActivities = new List<MDTF_Activities__c>([Select Transaction_Year__c, Transaction_Month__c, Sum_of_Transaction_Amt__c, Promotion_Description__c, Id, Comment__c, Account__c From MDTF_Activities__c where Account__c=:accId]);
        mdtfTraining = new List<MDTF_Claim__c>([Select Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=:accId and Activity_Description__c like '%LMS%']);
        mdtfFundSummary = new List<MDTF_Fund_Summary__c>([Select Spent__c, Promotion_Description__c, Id, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=:accId]);
       return null;
        
    }
   //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Ends
   
    //Case 00505731-Pivotal #114607087-Debasish-Sum of balance on Fund Summary tab-Release 45 - 10/05/2016 Starts
    public Decimal getTotalAccrual(){
        Decimal lsumOfAccrual = 0.00;
        AggregateResult[] groupedResultAccrual = [Select sum(Allowance__c) total From MDTF_Fund_Summary__c where Account__c=:accId and Allowance__c !=0];
        return lsumOfAccrual = (Decimal)groupedResultAccrual[0].get('total') == null ? 0.00 : (Decimal)groupedResultAccrual[0].get('total');
    }
   
    public Decimal getTotalAdvertisingClaims(){
        Decimal lsumOfClaimedAmt = 0.00;
        AggregateResult[] groupedResultClaimedAmt = [Select sum(Claimed_Amt__c) total From MDTF_Fund_Summary__c where Account__c=:accId and Claimed_Amt__c !=0];
        return lsumOfClaimedAmt = (Decimal)groupedResultClaimedAmt[0].get('total') == null ? 0.00 : (Decimal)groupedResultClaimedAmt[0].get('total');
    }
    
    public Decimal getTotalMRCPurchase(){
        Decimal lsumOfSmartStorePurchase = 0.00;
        AggregateResult[] groupedResultSmartStorePurchase = [Select sum(Smart_Store_Purchase__c) total From MDTF_Fund_Summary__c where Account__c=:accId and Smart_Store_Purchase__c !=0];
        return lsumOfSmartStorePurchase = (Decimal)groupedResultSmartStorePurchase[0].get('total') == null ? 0.00 : (Decimal)groupedResultSmartStorePurchase[0].get('total');
    }
    
    public Decimal getTotalLMSSpent(){
        Decimal lsumOfSpent = 0.00;
        AggregateResult[] groupedResultSpent = [Select sum(Spent__c) total From MDTF_Fund_Summary__c where Account__c=:accId and Spent__c !=0];
        return lsumOfSpent = (Decimal)groupedResultSpent[0].get('total') == null ? 0.00 : (Decimal)groupedResultSpent[0].get('total');
    }
    
    public Decimal getTotalAvailableBalance(){
        Decimal lsumOfBalance = 0.00;
        AggregateResult[] groupedResultBalance = [Select sum(Balance__c) total From MDTF_Fund_Summary__c where Account__c=:accId and Balance__c !=0];
        return lsumOfBalance = (Decimal)groupedResultBalance[0].get('total') == null ? 0.00 : (Decimal)groupedResultBalance[0].get('total');
    }
    //Case 00505731-Pivotal #114607087-Debasish-Sum of balance on Fund Summary tab-Release 45 - 10/05/2016 Ends    

    
    
    //function which popualete all related records list
    public void populate(){
        sortExpression = 'Product_Name__c';
        sortDirection = 'ASC';
        sortSmartStore();
      
       
       //Added By Debasish Starts
        //sortExpression = 'Created_Date__c';
        //sortDirection = 'ASC';        
        //sortMdtfLeadGenerationFee();
       //Added By Debasish Ends
       
         
        /* JAJA - MAR-18-2015 - CASE 00481604 */ 
       //mdtfPriorApprovals = new List<MDTF_Prior_Approvals__c>([Select SystemModstamp, Promotion__c, Promotion_Year__c, Promotion_Description__c, Open__c, Name, Media__c, Media_Description__c, LastModifiedDate, LastModifiedById, IsDeleted, Id, Expire_Date__c, Estimated_Cost__c, Date_To__c, Date_From__c, CurrencyIsoCode, CreatedDate, CreatedById, Balance__c, Appr_Num__c, Account__c From MDTF_Prior_Approvals__c where Account__c=:accId limit 1000]);
       //mdtfActivities = new List<MDTF_Activities__c>([Select Transaction_Year__c, Transaction_Type__c, Transaction_Month__c, SystemModstamp, Sum_of_Transaction_Amt__c, Promotion__c, Promotion_Year__c, Promotion_Description__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, CurrencyIsoCode, CreatedDate, CreatedById, Comment__c, Account__c From MDTF_Activities__c where Account__c=:accId limit 1000]);
       //mdtfClaim = new List<MDTF_Claim__c>([Select SystemModstamp, Promotion__c, Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, CurrencyIsoCode, Credit_Memo__c, CreatedDate, CreatedById, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_to_Date__c, Activity_from_Date__c, Activity_Description__c, Account__c,ACBParanet_ID__c From MDTF_Claim__c where Account__c=:accId limit 1000]);
       //mdtfTraining = new List<MDTF_Claim__c>([Select SystemModstamp, Promotion__c, Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, CurrencyIsoCode, Credit_Memo__c, CreatedDate, CreatedById, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_to_Date__c, Activity_from_Date__c, Activity_Description__c, Account__c,ACBParanet_ID__c From MDTF_Claim__c where Account__c=:accId and Activity_Description__c like '%LMS%' limit 1000]);
       //mdtfFundSummary = new List<MDTF_Fund_Summary__c>([Select Years_in_Business__c, promotion__c, SystemModstamp, Spent__c, Promotion_Description__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, Frozen__c, CurrencyIsoCode, CreatedDate, CreatedById, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c,ACBParanet_ID__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=:accId limit 1000]);
       mdtfActivities = new List<MDTF_Activities__c>([Select Transaction_Year__c, Transaction_Month__c, Sum_of_Transaction_Amt__c, Promotion_Description__c, Id, Comment__c, Account__c From MDTF_Activities__c where Account__c=:accId]);
       mdtfClaim = new List<MDTF_Claim__c>([Select Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c, Process_Date__c  From MDTF_Claim__c where Account__c=:accId]);
       mdtfTraining = new List<MDTF_Claim__c>([Select Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=:accId and Activity_Description__c like '%LMS%']);
       mdtfFundSummary = new List<MDTF_Fund_Summary__c>([Select Spent__c, Promotion_Description__c, Id, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=:accId]);
       //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Starts
       string accId15 = accId.substring(0, 15);
       mdtfLeadGenFee = new List<MDTF_Lead_Generation_Fee__c>([Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Transaction_Date__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Partner_Account_Id__c=:accId and Status__c LIKE '%Success%']);
       //Case 00505731-Pivotal #114607117-Debasish-MDTF Lead Generation Fee Tab-Release 42-09/22/2016 Ends 
        /* JAJA - MAR-18-2015 - CASE 00481604 */
        
       //Prepare a map of FundSummary with Paid Amount
       // populateFunSummaryPaidMap(mdtfFundSummary);
       // populateFunSummaryList(mdtfFundSummary);
       
       List<Account> accountList = new List<Account>([Select Id,Name,ACBParanet_ID__c,theater__c,type from Account where Id=:accId limit 1 ]);
       if(accountList!=null && accountList.size()>0){
            account = accountList.get(0);
       /*       if(account.theater__c.equalsIgnoreCase('Europe')){
                isEU = true;
                isNA = false;
            }else if(account.theater__c.equalsIgnoreCase('North America')){
                isEU = false;
                isNA = true;
            }
            else{
                isEU = isNA = false;
            }
       }else
       {
                isEU = isNA = false;*/
       }
        
    }
    
   /* public class FundSummary{
        public MDTF_Fund_Summary__c summary {get;set;}
        public MDTF_Claim__c claim {get;set;}
                
        public FundSummary(){           
            summary = new MDTF_Fund_Summary__c();
            claim = new MDTF_Claim__c();
        }
    }*/    

}