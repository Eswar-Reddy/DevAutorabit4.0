/**************************************************
**Created By- Debasish Paul
**Created On- October 14 2016
**Case 00505731-Pivotal #114607243 - Release 45
**Desciption- Ability to export Dealer Program Funds list into excel/csv
*****************************************************/

public without sharing class MDTF_MultipleTab_ExcelController {
	//public string xmlheader1 {get;set;}
  	//public string endfile1{get;set;}
    public String accId{get;set;}
    public transient List<MDTF_Fund_Summary__c> mdtfFundSummary{get;set;}//FunSummary Tab
    public transient List<MDTF_Activities__c>  mdtfActivities{get;set;}//Transaction Tab
    public transient List<MDTF_Claim__c> mdtfClaim{get;set;}//Claims Tab
    public transient List<MDTF_Claim__c> mdtfTraining{get;set;}//Training Tab
    public List<SmartStore_Details__c> mdtfSmartStore{get;set;}//Marketing Resource Center Tab
    public transient List<MDTF_Lead_Generation_Fee__c> mdtfLeadGenFee{get;set;}//Lead Generation Fee Tab
    //public String xmlheader1;
    public String xmlheader1 {get {String strHeader = '';strHeader += '<?xml version="1.0"?>';strHeader += '<?mso-application progid="Excel.Sheet"?>';return strHeader;}}
    /*public String xmlheader2 {
        get {
            	String strHeader = '';
            	strHeader += '<?xml version="1.0"?>';
            	strHeader += '<?mso-application progid="Excel.Sheet"?>';
            	return strHeader;
        	}
    }*/

  	//-------------------------------------------------------------------------------------------------------------------------------
  	//Constructor
  	//-------------------------------------------------------------------------------------------------------------------------------
  	public MDTF_MultipleTab_ExcelController() {
    	//VF page gives some issues directly using the below code there, so wrap up in variable
    	//xmlheader1 ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
    	//endfile1 = '</Workbook>';
    	
        try{
        if(ApexPages.CurrentPage().getParameters().get('Id') != null){
          	accId = ApexPages.CurrentPage().getParameters().get('Id');
            
            mdtfActivities = new List<MDTF_Activities__c>([Select Transaction_Year__c, Transaction_Month__c, Sum_of_Transaction_Amt__c, Promotion_Description__c, Id, Comment__c, Account__c From MDTF_Activities__c where Account__c=:accId]);
            mdtfClaim = new List<MDTF_Claim__c>([Select Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c, Process_Date__c  From MDTF_Claim__c where Account__c=:accId]);
            mdtfTraining = new List<MDTF_Claim__c>([Select Process_Date__c, Pre_Approval_Number__c, Paid_Amt__c, Id, Comment__c, Claimed_Amt__c, Claim_Number__c, Approved_Amt__c, Activity_Description__c, Account__c From MDTF_Claim__c where Account__c=:accId and Activity_Description__c like '%LMS%']);
            mdtfFundSummary = new List<MDTF_Fund_Summary__c>([Select Spent__c, Promotion_Description__c, Id, Claimed_Amt__c, Balance__c, Approved__c, Allowance__c, Account__c, Expiration__c, Smart_Store_Purchase__c From MDTF_Fund_Summary__c where Account__c=:accId]);
            mdtfLeadGenFee = new List<MDTF_Lead_Generation_Fee__c>([Select Opportunity_Id__c, Opportunity_Name__c, Campaign_Id__c, Campaign_Name__c, Lead_Generation_Fee__c, Lead_Handling_Fee__c, Created_Date__c, Reference_Number__c, Transaction_Date__c, Name, LastModifiedDate, LastModifiedById, Id From MDTF_Lead_Generation_Fee__c where Partner_Account_Id__c=:accId and Status__c LIKE '%Success%']);
            mdtfSmartStore = new List<SmartStore_Details__c>([Select id,name,Tracking_Number__c, Status__c, Ship_State__c, Purchase_Type__c, Product_Name__c, Price__c, Order_Number__c, Order_Date__c From SmartStore_Details__c where Account__c=:accId]);
         }
      }
      catch(Exception ex){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
      }   
  }
}