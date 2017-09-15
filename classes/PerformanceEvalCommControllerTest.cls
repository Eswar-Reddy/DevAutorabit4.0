// 
// (c) 2010 Appirio, Inc.
//
// Test Class for PerformanceEvalComm(CVAR).
//
// 12/4/2010  Appirio offshore  Original
//
@isTest
private class PerformanceEvalCommControllerTest{
  private static Account acct;
  private static User partnerUser;
  
  private static testMethod  void evalTest1(){
    // Create test data
    Date tdat = Date.today();
    List<Performance_Metric__c> performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c ='North America' and Country__c ='USA' and channel__c ='Commercial'  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
    
    if(performancelst == null || performancelst.size() == 0){
        TestClassUtilities.createMetricData();
    }
    
    Date dt = date.newinstance(2006,1,1);
    Date dt1 = date.newinstance(2006,12,30);
    Date dt4 = date.newinstance(2010,7,4);
    Date dt5 = date.newinstance(2009,12,1);
    Date dt6 = date.newinstance(2010,7,31);
    Date dt7 = date.newinstance(2010,1,4);
    // Insert Account
    Account act = new Account(name='testResh2',type='Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='cvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
    insert act;
    
    // Insert Contact
    Contact cont = new Contact(LastName='test contact', AccountId = act.Id);
    insert cont;
    
    // Insert Customer Survey Result
    Customer_Survey_Result__c csr = new Customer_Survey_Result__c();
    //csr.Aggregate_Score_New__c = 10;
    csr.Partner_Service__c = 5;
    csr.Partner_Account__c = act.Id;
    csr.Survey_Response_Date__c = Date.today().addDays(2);
    insert csr;
    
    // Insert Inspection
    Inspection__c insp = new Inspection__c();
    insp.score__c = 10;
    insp.Score_Details__c ='PASS';
    insp.Case__c = null;
    insp.Partner_Contact__c = cont.Id;
    insp.Site_Type__c = 'Commercial';
    insp.Inspection_Date__c = Date.today().addDays(2);
    insert insp;
   
    PerformanceEvalCommController controller = new PerformanceEvalCommController(act.id);
    //System.assertequals(true,controller.getDisableEditButton()); //Shree- 27092012 : Due to Bluwolf Booking Template Module Faliure
    
    // Default Constructor
    controller = new PerformanceEvalCommController();
    
    // Standard Controller's Constructor
    ApexPages.StandardController stdController = new ApexPages.StandardController(act);
    controller = new PerformanceEvalCommController(stdController );
    
    controller.setDisableButton(true);
    System.assertEquals(true, controller.getDisableButton());
    
    System.assertEquals(null, controller.enableInputFields());
    System.assertEquals(false, controller.getSPWRNextFlag());
    System.assertEquals(false, controller.getSPWRCurrentFlag());
    System.assertNotEquals(null, controller.goToPreviousperformanceEvalPage());
    
    //controller.updateEvaluation();
    controller.getisExecutiveManager();
    controller.getAccTheatre();
    //controller.updateEvaluation();
    controller.getperformanceMetricID();
    controller.getparamStartDate();
    controller.getparamEndDate();
    controller.getparamExpDate();
    controller.getaccountId();
    controller.getvalidExpToDate();
    controller.getcustomer_Satisfaction_Current();
    controller.getperformance_to_business_Plan_Current();
    controller.gettraining_Current();
    controller.getpartnerTier();
    controller.getAccountName();
    controller.getPartnerType();
    controller.getValidEvalFromDate();
    controller.getValidEvalToDate();
    controller.getShowNextTab();
    //controller.updateEvaluation();
    controller.getTierStartDate();
    
    String testName = PerformanceEvalCst.PBP_SUNPOWER_DEALER_GROWTH_PLAN_CVAR;
    testName = PerformanceEvalCst.RSM_OBJECTIVES;
    testName = PerformanceEvalCst.PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR;
    testName = PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR;
    testName = PerformanceEvalCst.CSAT_SCORE_CVAR;
    testName = PerformanceEvalCst.T5_T10_Power_CVAR;
    testName = PerformanceEvalCst.WARRANTY_CARDS_CVAR;
    testName = PerformanceEvalCst.INSTALLATIONS_REGISTERED_CVAR;
    testName = PerformanceEvalCst.TRAINING_ASS_INSTALL_CVAR;
    
    testName = PerformanceEvalCst.TRAINING_ASS_SALES_CVAR;
    testName = PerformanceEvalCst.TRAINING_ASS_DESIGN_CVAR;
    testName = PerformanceEvalCst.TRAINING_ASS_SALES_CERT_CVAR;
    testName = PerformanceEvalCst.TRAINING_ASS_DESIGN_CERT_CVAR;
    testName = PerformanceEvalCst.TRAINING_ASS_INSTALL_CERT_CVAR;
    testName = PerformanceEvalCst.PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR;
    testName = PerformanceEvalCst.PBP_CREDIT_LINE_MAINTAINED_CVAR;
    Set<String> myset = PerformanceEvalCst.PARTNER_TYPE_COMBO;
    myset =  PerformanceEvalCst.PARTNER_TYPE_COMM;
    myset = PerformanceEvalCst.PARTNER_TYPE_RESI;
    //testName = PerformanceEvalCst
  }
  
  private static testMethod  void evalTest2(){  
    Date tdat = Date.today();
    List<Performance_Metric__c> performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c ='North America' and Country__c ='USA' and channel__c ='Commercial'  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
    
    if(performancelst == null || performancelst.size() == 0){
        TestClassUtilities.createMetricData();
    }
    createTestData();
    Test.startTest();
    Test.setCurrentPage(Page.PerformanceEvalPageComm);
    ApexPages.currentPage().getParameters().put('accId', acct.ID);
    ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(acct);
    PerformanceEvalCommController controller = new PerformanceEvalCommController(stdctrl);
    controller.getIsPortalUser();
    controller.getPartnerExecutive();
    controller.getHideHeaderForPartner();
   
    Test.stopTest();
  }
  
  private static testmethod void evalTest3(){
    createTestData();
    Date startDate = date.newinstance(Date.today().year(), 7, 1); 
    Date endDate = date.newinstance(Date.today().year(), 12, 31);
    
    Performance_Metric__c perfMetric = new Performance_Metric__c(channel__c='Commercial', Peformance_Metric_Name__c='USAJuly2010_to_Dec2010_Comm',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= startDate,Performance_period_End_date__c =endDate ,Metric_Setup_Cut_off_Date__c = startdate.adddays(-15),Performance_Evaluation_Cut_off_Date__c = enddate.adddays(15) ); 
    insert perfMetric;
    
    Tier__c tier = new Tier__c();
    tier.Country__c = 'USA';
    insert tier;
    
    Metric_Tier_Relation__c pbp3 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id, tier__c = tier.Id);
    pbp3.Metric_Label__c = 'Dealer Bonuses for meeting Business Objectives';
    pbp3.Metric_Description__c = 'Dealer Bonuses for meeting Business Objectives';
    pbp3.Category__c = 'Performance to Business Plan';
    pbp3.Boolean_Metric_Y_N__c = true;
    pbp3.Benefit_Tier__c = true;    
    pbp3.Incentive_Amount__c = 0.5;
    pbp3.Part_Of_Composite_Incentive__c = true;
    pbp3.Metric_Input_Type__c = 'Automated';
    pbp3.isRSMView__c = false;
    insert pbp3;
    
    Metric__c metric1 = new Metric__c();
    metric1.Account__c = acct.Id;
    metric1.Metric_Tier_Relation__c = pbp3.Id;
    metric1.Performance_Metric__c = perfMetric.Id;
    metric1.Boolean_Achievement__c = true;
    metric1.Goal_Met__c = true;
    insert metric1;
    
    Test.startTest();
    Test.setCurrentPage(Page.PerformanceEvalPageComm);
    ApexPages.currentPage().getParameters().put('accId', acct.ID);
    PerformanceEvalCommController controller = new PerformanceEvalCommController();
    controller.updateEvaluation();
    controller.getShowLink();
    PerformanceEvalCommController.MetricsDetails wrapper = new  PerformanceEvalCommController.MetricsDetails();
    wrapper.meetricTierRel = pbp3;
    wrapper.metric = metric1;
    wrapper.getmeetricTierRel();
    wrapper.getMetric();
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