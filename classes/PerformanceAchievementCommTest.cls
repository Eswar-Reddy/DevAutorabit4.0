// 
// (c) 2010 Appirio, Inc.
//
// Contains unit test methods for Class PerformanceAchievementComm.
//
// 11/1/2010  (Appirio offshore)  Original
// 
@isTest
private class PerformanceAchievementCommTest{
  private static Account acct;
  private static User partnerUser;
  
  private static testMethod  void computeCSATSCORE_Test(){
    Date tdat = Date.today();
    List<Performance_Metric__c> performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c ='North America' and Country__c ='USA' and channel__c ='Commercial'  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
    
    if(performancelst == null || performancelst.size() == 0){
        TestClassUtilities.createMetricData();
    }
    
    // Create test data
    Date dt = date.newinstance(2006,1,1);
    Date dt1 = date.newinstance(2006,12,30);
    Date dt4 = date.newinstance(2010,7,4);
    Date dt5 = date.newinstance(2009,12,1);
    Date dt6 = date.newinstance(2010,7,31);
    Date dt7 = date.newinstance(2010,1,4);
    // Insert Account
    Account act = new Account(name='testResh2',type='Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='cvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
    insert act;
    
    //act.Credit_Hold__c = true;
    //act.Available_Credit__c = 100;
    //update act;
    
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
    
    // Get RecordTypeId for Opportunity
    RecordType rType = [select Id from RecordType where DeveloperName='Commercial' and SObjectType='Opportunity' limit 1];
    
    // Insert Opportunity
    Opportunity opp = new Opportunity();
    opp.Name = 'TestOpp';
    opp.CloseDate = Date.today().addDays(2);
    opp.Account = act;
    opp.StageName = '100% - Won';
    opp.RecordTypeId = rType.Id;
    opp.Closed_Won_Date__c = Date.today().addDays(2);
    insert opp;
    
    // Insert order_detail_sunrise2__c
    order_detail_sunrise2__c ods = new order_detail_sunrise2__c();
    ods.Account_Name__c = act.Id;
    ods.Performance_Period__c = 'P2';
    ods.Year__c = String.valueOf(Date.today().year());
    ods.Number_of_QTD_Commercial_PV_Order__c = 5;
    insert ods;
    
    Test.startTest();
    PerformanceAchievementComm.updatePrevEvalDate(dt);
     PerformanceAchievementComm.computeCSATSCORE(act.Id,dt,dt1);
     PerformanceAchievementComm.computeInspections(act.Id,dt,dt1);
    
    PerformanceAchievementComm controller = new PerformanceAchievementComm();
    
    
/*    
    System.assertEquals(100, PerformanceAchievementComm.computeCSATSCORE(act.Id, Date.today(), Date.today().addDays(5)));
    
    System.assertEquals(100, PerformanceAchievementComm.computeInspections(act.Id, Date.today(), Date.today().addDays(5)));
    */
    Double instRegistered = PerformanceAchievementComm.calcInstallationsRegistered(act.Id, Date.today(), Date.today().addDays(5));
    
    Double warCards = PerformanceAchievementComm.calcWarrantyCards(act.Id, Date.today(), Date.today().addDays(5));
    
    Double calsTFCDAD = PerformanceAchievementComm.calcTrainingFundCommDesignAssocDesign(act.Id);
    
    Double calsTFCDAI = PerformanceAchievementComm.calcTrainingFundCommDesignAssocInstall(act.Id);
    
    Double calsTFCDAS = PerformanceAchievementComm.calcTrainingFundCommDesignAssocSales(act.Id);
    
    Double calsTFCDADCert = PerformanceAchievementComm.calcTrainingFundCommDesignAssocDesignCert(act.Id);
    
    Double calsTFCDAICert = PerformanceAchievementComm.calcTrainingFundCommDesignAssocInstallCert(act.Id);
    
    Double calsTFCDASCert = PerformanceAchievementComm.calcTrainingFundCommDesignAssocSalesCert(act.Id);
    
     
    
    Map<String,boolean> mapActiveDealerMetricAchievement = new Map<String,boolean>();
    Boolean activeDealer ;
    mapActiveDealerMetricAchievement = PerformanceAchievementComm.mustBeAnActiveDealer(act.Id, Date.today(), Date.today().addDays(5));
    if(mapActiveDealerMetricAchievement.size()>0)
        activeDealer = true;
    else
        activeDealer = false;
    
    Boolean crLineMaintained = PerformanceAchievementComm.isCreditLineMaintained(act.Id, Date.today(), Date.today().addDays(5));
    
    System.assertEquals(true, PerformanceAchievementComm.calcDealerGrowthPlan(act.Id, Date.today(), Date.today().addDays(5)));
    //System.assertEquals(100, PerformanceAchievementComm.calcInstallationsRegistered(act.Id, Date.today(), Date.today().addDays(5)));
    
    Double pvpInKw = PerformanceAchievementComm.calculatePVPurchasesInKw(act.Id, Date.today(), Date.today().addDays(5));
    
    System.assertEquals(true, PerformanceAchievementComm.calculateDealerBonuses());
    
    List<String> lstStr = PerformanceAchievementComm.getQuartesBetweenDates(Date.today(), Date.today().addDays(5));
    
    lstStr = PerformanceAchievementComm.getQuartesBetweenDates(Date.today().addMonths(2), Date.today().addMonths(12));
    
    lstStr = PerformanceAchievementComm.getQuartesBetweenDates(Date.today().addMonths(10), Date.today().addMonths(2));
    
    PerformanceAchievementComm.automatedBooleanGoalCheck(new Metric__c(), new Metric_Tier_Relation__c(), true);
    
    PerformanceAchievementComm.automatedDoubleGoalCheck(new Metric__c(), new Metric_Tier_Relation__c(), 5);
    
    System.assertEquals(PerformanceAchievementComm.getCurrentPerformancePeriod('Q1'), 'P1');
    
    System.assertEquals(PerformanceAchievementComm.getCurrentPerformancePeriod('Q3'), 'P2');
    
    System.assertEquals(PerformanceAchievementComm.getCurrentPerformancePeriod('Q0'), null);
    Test.stopTest();
  }
  
  private static testMethod  void calculationTest(){
    Date tdat = Date.today();
    List<Performance_Metric__c> performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c ='North America' and Country__c ='USA' and channel__c ='Commercial'  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
    
    if(performancelst == null || performancelst.size() == 0){
        TestClassUtilities.createMetricData();
    }
    
    createTestData();
    Test.startTest();
    Date startDate = date.newinstance(Date.today().year(), 7, 1); 
    Date endDate = date.newinstance(Date.today().year(), 12, 31);
    System.debug('========acct.Id from test class============'+acct.Id);
    //PerformanceAchievementComm controller = new PerformanceAchievementComm();
    PerformanceAchievementComm.calcInstallationsRegistered(partnerUser.Contact.AccountId, startDate, endDate);
    PerformanceAchievementComm.mustBeAnActiveDealer(acct.Id, startDate, endDate);
    PerformanceAchievementComm.calcWarrantyCards(partnerUser.Contact.AccountId, startDate, endDate);
    PerformanceAchievementComm.isCreditLineMaintained(acct.Id, startDate, endDate);
    
    Integer quarter = PerformanceAchievementComm.getQuarterByDate(Date.newinstance(Date.today().year(),2,4));
    quarter = PerformanceAchievementComm.getQuarterByDate(Date.newinstance(Date.today().year(),5,4));
    quarter = PerformanceAchievementComm.getQuarterByDate(Date.newinstance(Date.today().year(),8,4));
    quarter = PerformanceAchievementComm.getQuarterByDate(Date.newinstance(Date.today().year(),11,4));
    
    Test.stopTest();
  }
  
  private static void createTestData(){
     // Get RecordTypeId for Opportunity
    RecordType rType = [select Id from RecordType where DeveloperName='Commercial' and SObjectType='Opportunity' limit 1];
    
    acct = new Account(Name='Test Account'+System.now());
    acct.status__c = 'Active';
    acct.type = 'Premier-Partner-Combo';
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