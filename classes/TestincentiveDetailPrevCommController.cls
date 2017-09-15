/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

public with sharing class TestincentiveDetailPrevCommController {
    
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
    Test.setCurrentPage(Page.incentiveDetailPreviousComm);
    ApexPages.currentPage().getParameters().put('accId', acct.ID);
    ApexPages.currentPage().getParameters().put('period','2');
    ApexPages.currentPage().getParameters().put('year','2010');
    incentiveDetailPrevCommController controller = new incentiveDetailPrevCommController();
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
    controller.totalPDF = 2;
    controller.getChckRwd();
    controller.button();
    controller.getisactive();
//    controller.getTname();
    controller.gettotBonus();
    controller.showPb();
    controller.showTrg();
    controller.getTrnlFlag();
    controller.getPbplFlag();
    controller.getMrklFlag();
    controller.getSpwrlFlag();
    
    controller.updateEvaluation();
    controller.updateMetricRecords();
    
    Test.stopTest();
  }
  
   private static testmethod void incentiveTest2(){
    createTestData();
    Date tdat = Date.today();
    List<Performance_Metric__c> performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c ='North America' and Country__c ='USA' and channel__c ='Commercial'  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
    
    if(performancelst == null || performancelst.size() == 0){
        TestClassUtilities.createMetricData();
        performancelst = [select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c ='North America' and Country__c ='USA' and channel__c ='Commercial'  and (Performance_Period_Start_Date__c <=:tdat and Performance_Period_End_Date__c >=:tdat ) ];
    }
    
    Test.startTest();
    Test.setCurrentPage(Page.incentiveDetailPreviousComm);
    ApexPages.currentPage().getParameters().put('accId', acct.ID);
    //ApexPages.currentPage().getParameters().put('period','2');
    //ApexPages.currentPage().getParameters().put('year','2010');
    incentiveDetailPrevCommController controller = new incentiveDetailPrevCommController();
    List<Metric_Tier_Relation__c> listMetrics = new List<Metric_Tier_Relation__c>();     
    if(performancelst != null && performancelst.size() != 0){ 
	    listMetrics.add(createMTRObject(PerformanceEvalCst.MEET_SIX_MARKET,performancelst.get(0).Id, 'Marketing'));
	    insert listMetrics;
    }
    Metric__c mt = new Metric__c();
    mt.Account__c = acct.Id;
    if(listMetrics.size()>0){
    	mt.Metric_Tier_Relation__c = listMetrics.get(0).Id;
    }
    mt.Boolean_Achievement__c = true;
    mt.Goal_Met__c = true;
    Double d = 3.0;
    if(listMetrics.size()>0)
    	controller.automatedDoubleGoalCheckForIndividual(mt,listMetrics.get(0),d);
    Test.stopTest();
   } 
   
    private static Metric_Tier_Relation__c createMTRObject(String label, String perfId, String category){
        Metric_Tier_Relation__c marketMetric4 = new Metric_Tier_Relation__c(Performance_Metric__c = perfId);
        marketMetric4.Metric_Label__c = label;
        marketMetric4.Metric_Description__c = label;
        marketMetric4.Category__c = category;
        //marketMetric4.Boolean_Metric_Y_N__c = true;
        marketMetric4.Metric_Input_Type__c = 'Manual';
        marketMetric4.Metric_Min_Value__c = 3;
        return marketMetric4;
        //marketMetric4.Stay_Tier__c = true;
    }
  private static void createTestData(){
     // Get RecordTypeId for Opportunity
    RecordType rType = [select Id from RecordType where DeveloperName='Commercial' and SObjectType='Opportunity' limit 1];
    /*
    
    */
    
    //Account acct;
    List<Account> listAccs = [select Id, Name from account where type like '%Elite-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
    if(listAccs != null && listAccs.size() > 0){
        acct = listAccs.get(0);
    }else{
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
    }
    
    
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
        opp.Reason_Won_Lost__c='Best Economics';
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
    
    
    
    
    
    
    public static testMethod void testIncentivePrev11(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Elite-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.IncentiveDetailPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        incentiveDetailPrevCommController prevController = new incentiveDetailPrevCommController();
        prevController.backToAccount();
        prevController.button();
        prevController.enableInputFields();
        prevController.getaccountId(); 
        prevController.getAccountName();
        prevController.getAccTheatre();
        prevController.getall_spwr_solutions_Current();
        prevController.getBonus();
        prevController.getBussinessPlan();
        prevController.getChckRwd();
        prevController.getcomingSoon();
        prevController.getCreditMemo();
        prevController.getcreditMemoNumber();
        prevController.getcsatFlag();
        prevController.getCurrencySyb();
        prevController.getCurrencySybm();
        prevController.getcustomer_Satisfaction_Current();
        prevController.getDisableButton();
        prevController.getDisableEditButton();
        prevController.getEarnedIncentive();
        prevController.getHideHeaderForPartner();
        prevController.getisactive();
        prevController.getisExecutiveManager();
        //prevController.getmarketing_Current();
        prevController.getMinRequirementMet();
        prevController.getmrkFlag();
        //prevController.getMrklFlag();
        prevController.getnetAmount();
        prevController.getparamEndDate();
        prevController.getparamExpDate();
        prevController.getparamStartDate();
        prevController.getpartnerDevelopmentFunds();
        prevController.getPartnerExecutive();
        prevController.getpartnerTier();
        prevController.getPartnerType();
        prevController.getpbpFlag();
        prevController.getPbplFlag();
        prevController.getPDFNumber();
        prevController.getperformance_to_business_Plan_Current();
        prevController.getperRevenueTgt();
        prevController.getPfContri();
        prevController.getPossibleIncentive();
        prevController.getshipBonus();
        prevController.getShowLink();
        prevController.getspwrFlag();
        //prevController.getSpwrlFlag();
        prevController.getTierStartDate();
//      prevController.getTname();
        prevController.gettotalFunds();
        prevController.gettotalIncentive();
        prevController.gettotalPDFNumber();
        prevController.gettotBonus();
        prevController.gettraining_Current();
        prevController.getTrainings();
        prevController.gettrnFlag();
        prevController.getTrnlFlag();
        prevController.getValidEvalFromDate();
        prevController.getValidEvalToDate();
        //prevController.setBonus(1.99);
        prevController.setCreditMemo('12');
        prevController.setpartnerDevelopmentFunds('20');
        prevController.setPDFNumber('2');
        //prevController.setshipBonus(1.0);
        prevController.settotalFunds('4');
        prevController.settotalIncentive('6');
        //prevController.showAllsun();
        //prevController.showMkt();
        prevController.showPb();
        prevController.showTrg();
            prevController.saveEvaluationIncentive();
        
            
        Test.stopTest();
    }
    
    public static testMethod void testIncentivePrev2(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Premier-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.IncentiveDetailPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',null);
        ApexPages.currentPage().getParameters().put('period','');
        ApexPages.currentPage().getParameters().put('year','');
        incentiveDetailPrevCommController prevController = new incentiveDetailPrevCommController();
        Test.stopTest();
    }
    
    public static testMethod void testIncentivePrev3(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Authorized-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.IncentiveDetailPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        incentiveDetailPrevCommController prevController = new incentiveDetailPrevCommController();
        Test.stopTest();
    }
    
    public static testMethod void testIncentivePrev4(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Partner-Commercial%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.IncentiveDetailPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        incentiveDetailPrevCommController prevController = new incentiveDetailPrevCommController();
        Test.stopTest();
    }
    
    public static testMethod void testIncentivePrev5(){
        
        
        List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
    
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
       
       //  performance endate date    
        Date dt4 = date.newinstance(2012,12,12);
        
        //performance cut off date
        Date dt5 = date.newinstance(2012,08,04);
        
        Date dt6 = date.newinstance(2010,7,31);
        
        //performance start date
        Date dt7 = date.newinstance(2012,11,11);
        
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jul2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt4 );
        insert p;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier');
        insert t1;
        List<Metric_Tier_Relation__c> MTRList = new List<Metric_Tier_Relation__c>(); 
        
        Metric_Tier_Relation__c mtr01 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='RSM Objective1',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        insert mtr01;
        MTRList.add(mtr01);
        
        Metric_Tier_Relation__c mtr02 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='RSM Objective1',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr02;
        MTRList.add(mtr02);
        
        Metric_Tier_Relation__c mtr03 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='RSM Objective1',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr03;
        MTRList.add(mtr03);
        
        Metric_Tier_Relation__c mtr04 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Warranty card received EU',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr04;
        MTRList.add(mtr04);
        
        Metric_Tier_Relation__c mtr05 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr05;
        MTRList.add(mtr05);
       
        
                
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Authorized%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        
        metric__c m = new metric__c();
        m.Account__c=selectedAcc.id;
        m.Performance_Metric__c=p.id;
        m.Metric_Tier_Relation__c=mtr05.id;
        m.Overriden__c=false;
        insert m;
        
        String period='1';
        String year='2012';
       
        Test.startTest();
        Test.setCurrentPage(Page.IncentiveDetailPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2012');
        IncentiveDetailPrevCommController prevController = new IncentiveDetailPrevCommController();
        
         
         
        
        prevController.populateCategoriesForTiers(MTRList,p.id,p.Performance_Evaluation_Cut_off_Date__c ,p.Performance_Period_Start_Date__c,p.Performance_period_End_date__c);
        
        IncentiveDetailPrevCommController prevController1;
         prevController1 = new IncentiveDetailPrevCommController(selectedAcc.ID,period,year);
        
        Test.stopTest();
        
        
    }
    
    
}