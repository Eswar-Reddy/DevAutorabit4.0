@isTest
private class incentiveCommClsTest{
  private static Account acct;
  private static User partnerUser;
  
  private static testmethod void incentiveTest1(){
  	createTestData();
  	Date tdat = Date.today();
    List<Performance_Metric__c> performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c ='North America' and Country__c ='USA' and channel__c ='Commercial'  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
    
    if(performancelst == null || performancelst.size() == 0){
    	TestClassUtilities.createMetricData();
    }
    
  	Test.startTest();
    Test.setCurrentPage(Page.IncentrailComm);
    ApexPages.currentPage().getParameters().put('accId', acct.ID);
    IncentiveCommCLS controller = new IncentiveCommCLS();
    controller.getcsatFlag();
    controller.gettrnFlag();
    controller.getpbpFlag();
    controller.getmrkFlag();
    controller.getspwrFlag();
    controller.getparamStartDate();
    controller.getparamEndDate();
    controller.getparamExpDate();
    controller.getaccountId();
    controller.getDisableButton();
    controller.getHideHeaderForPartner();
    controller.getShowLink();
    controller.getPartnerExecutive();
    controller.getDisableEditButton();
    controller.getcustomer_Satisfaction_Current();
    controller.getperformance_to_business_Plan_Current();
    controller.gettraining_Current();
    controller.getmarketing_Current();
    controller.getall_spwr_solutions_Current();
    controller.setpartnerDevelopmentFunds('123');
    controller.settotalIncentive('123');
    controller.setCreditMemo('123');
    controller.settotalFunds('123');
    controller.setPDFNumber('123');
    controller.setcreditMemoNumber('123');
    controller.getpartnerDevelopmentFunds();
    controller.gettotalIncentive();
    controller.getCreditMemo();
    controller.gettotalFunds();
    controller.getPDFNumber();
    controller.getcreditMemoNumber();
    controller.enableInputFields();
    controller.getpartnerTier();
    controller.getAccountName();
    controller.getPartnerType();
    controller.getValidEvalFromDate();
    controller.getValidEvalToDate();
    controller.getTierStartDate();
    controller.getAccTheatre();
    controller.getisExecutiveManager();
    controller.getCurrencySyb();
    controller.getCurrencySybm();
    controller.getcomingSoon();
    controller.goToPreviousIncentivePage();
    
    controller.getEarnedIncentive();
    controller.updateEvaluation();
    controller.getPossibleIncentive();
    controller.getnetAmount();
    controller.gettotalPDFNumber();
    controller.backToAccount();
    controller.setshipBonus(10);
    controller.getshipBonus();
    controller.setBonus(100);
    controller.getBonus();
    controller.getPfContri();
    controller.getChckRwd();
    controller.button();
    controller.getisactive();
    controller.getTname();
    controller.gettotBonus();
    controller.showPb();
    controller.showTrg();
    controller.getTrnlFlag();
    controller.getPbplFlag();
    controller.getMrklFlag();
    controller.getSpwrlFlag();
    
    controller.updateEvaluation();
    
    Test.stopTest();
  }
  
  private static void createTestData(){
  	 // Get RecordTypeId for Opportunity
    RecordType rType = [select Id from RecordType where DeveloperName='Commercial' and SObjectType='Opportunity' limit 1];
  	
  	acct = new Account(Name='Test Account'+System.now());
  	acct.status__c = 'Active';
  	acct.type = 'Partner-Combo';
  	acct.Credit_Hold__c = false;
  	acct.Credit_Limit__c = 200000;
  	acct.Available_Credit__c = 200;
  	acct.Credit_Limit_Date__c = Date.today().addDays(-30);
  	acct.CurrencyIsoCode='USD';
  	acct.Country_Domain__c ='combo-us' ;
  	acct.Theater__c = 'North America';
  	acct.Authorized_Partner_Date__c = Date.today().addDays(-30);
  	acct.Promoted_Premier_Date__c = Date.today().addDays(-30);
  	acct.BillingCountry = 'United States';
  	acct.BillingStreet = '1035 FOLGER AVENUE';
  	acct.BillingCity = 'Berkeley';
  	acct.BillingPostalCode = '94710';
  	acct.Oracle_Account_Number__c='140x';
  	
  	insert acct;
  	
  	Contact cont = new Contact(LastName='test contact', AccountId = acct.Id);
    insert cont;
    
    order_detail_sunrise2__c ord1 = new order_detail_sunrise2__c(Quarter__c='Q3',year__c=''+Date.today().year(),Account_Name__c=acct.Id);
    ord1.Performance_Period__c = 'P2';
    ord1.Net_purchase_amount_for_NA_CVAR__c = 100;
    ord1.Cumulative_No_of_Commercial_PV_orders__c = 100;
    ord1.Number_of_QTD_Commercial_PV_Order__c = 200;
    ord1.Cumulative_kW_for_Commercial_Orders__c = 200;
    ord1.Oracle_Customer_No__c ='140x';
    insert ord1; 
    
    //System.debug('====ORD1===='+[select Quarter__c, year__c, Account_Name__c, Performance_Period__c from order_detail_sunrise2__c where Id=:ord1.Id]);
    //System.debug('====ORD1===='+[select Quarter__c, year__c, Account_Name__c, Performance_Period__c from order_detail_sunrise2__c where Id=:ord1.Id].Account_Name__c);
    order_detail_sunrise2__c ord2 = new order_detail_sunrise2__c(Quarter__c='Q4',year__c=''+Date.today().year(),Account_Name__c=acct.Id);
    ord2.Performance_Period__c = 'P2';
    ord2.Net_purchase_amount_for_NA_CVAR__c = 100;
    ord2.Cumulative_No_of_Commercial_PV_orders__c = 200;
    ord2.Number_of_QTD_Commercial_PV_Order__c = 200;
    ord2.Cumulative_kW_for_Commercial_Orders__c = 200;
    ord2.Oracle_Customer_No__c ='140x';
    insert ord2;
    
    List<Opportunity> listOpps = new List<Opportunity>();
    partnerUser =  TestClassUtilities.getPartnerPortalUser(acct); 
    partnerUser = [Select Id, ContactId, Contact.AccountId from User where Id=:partnerUser.Id];
    for(integer j = 0; j < 5; j++){
	    Opportunity opp = new Opportunity(Name='test opport'+j);	   
	    opp.OwnerId = partnerUser.Id; 
	    opp.AccountId = acct.Id;
	    opp.StageName = '100% - Won';
	    opp.CloseDate = Date.today();
	    opp.Closed_Won_Date__c = Date.today();
	    opp.RecordTypeId = rType.Id;
	    listOpps.add(opp);
    }
    insert listOpps;
    
    List<Asset> listAsset = new List<Asset>();
    for(integer i=0;i<5;i++){
    	Asset testAsset = new Asset(AccountId=acct.Id, Name='asset'+i);
    	listAsset.add(testAsset);
    }
    insert listAsset;   
  }
}