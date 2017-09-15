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
@isTest
private class TestIncentiveCompositePrevController {
  private static Account acct;
  private static User partnerUser;
  
  
  public static testmethod void test2(){
  try{
    List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt4 = date.newinstance(2010,7,4);
        Date dt5 = date.newinstance(2009,12,1);
        Date dt6 = date.newinstance(2010,7,31);
        Date dt7 = date.newinstance(2010,1,4);
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
            //delete pmObjx ;
        }
        List<Tier__c>tObjx = [Select Id from Tier__c];
        if(tObjx.size()>0){
            //delete tObjx ;
        }
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='Italy1-Jan2010_to_Jun2010',Country__c='Italy',Thea__c='Europe',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt6 );
        insert p;
        //list<Performance_Metric__c> pmobj = [select Id from Performance_Metric__c where Country__c = 'USA' and Thea__c = 'North America'];
        Account acc = new Account(name='testResh1',type = 'Authorized-Partner-Combo',CurrencyIsoCode='EUR',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        
         
        String accountId1 = acc.Id ;
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Authorized');
        insert t1;  
        //Tier__c tObj = [select Id,Tier_Name__c,Country__c from Tier__c where Tier_Name__c='Premier' and Country__c='USA'];
        Double x=1.75; 
        PDF_Limit__c pdflmt = new PDF_Limit__c(Partner__c=x,Performance_Metric__c=p.id,Tier__c=t1.Id);
        insert pdflmt;        
        
        
        /*IncentiveDetailPrevController inc = new IncentiveDetailPrevController();
        IncentiveDetailPrevController inc1 = new IncentiveDetailPrevController(acc.Id);*/
        
        Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr1); 
        
        Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - No. certified for Adv. Design ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr2);
        
        Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Meeting 6 Month Revenue Target ',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr3);
        
        Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage ',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr4);

        Metric_Tier_Relation__c mtr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Dealer Webpage and Logo Usage ',Category__c='Marketing',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr5);
      
        Metric_Tier_Relation__c mtr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Customer Complaints ',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr6);
        
        Metric_Tier_Relation__c mtr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower installations Registered ',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr7);
        
        Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - percent of Sales People with Adv Training ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr8);

        Metric_Tier_Relation__c mtr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Basic training ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr9);

        Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Fundamental Design and Installation ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr10);

        Metric_Tier_Relation__c mtr11 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Advanced design and Installation ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr11);
        
        Metric_Tier_Relation__c mtr12 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Advanced Product Training ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr12);

        Metric_Tier_Relation__c mtr13 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training: Advanced Sales Certification ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr13);

        Metric_Tier_Relation__c mtr14 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training: Advanced Installation Certification ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr14);

        Metric_Tier_Relation__c mtr15 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training: Advanced Design Certification ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr15);

        Metric_Tier_Relation__c mtr16 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Sales Certification',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr16);
       
        Metric_Tier_Relation__c mtr17 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Design Certification',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr17);
        
        Metric_Tier_Relation__c mtr18 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Kw agreed target',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr18);

        Metric_Tier_Relation__c mtr19 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum sales and experience (SRI to Authorized)',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr19);

        Metric_Tier_Relation__c mtr20 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum quarterly sales',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr20);

        Metric_Tier_Relation__c mtr21 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum quarterly sales as SRI',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr21);
        
        Metric_Tier_Relation__c mtr22 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Installation Certification',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr22);
        
        Metric_Tier_Relation__c mtr23 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MEET_SIX_MARKET,Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr23);
        
        Metric_Tier_Relation__c mtr24 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.THREE_MARKET_EU,Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr24);
        
        Metric_Tier_Relation__c mtr25 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.FOUR_MARKET_EU,Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr25);
        
        Metric_Tier_Relation__c mtr26 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SIX_MARKET_EU,Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr26);
        
        Metric_Tier_Relation__c mtr27 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SEVEN_MARKET_EU,Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr27);
        
        Metric_Tier_Relation__c mtr28 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SEVENTY_COM_INVTR_EU,Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        upmtrlist.add(mtr28);
        
        insert upmtrlist;
                
        IncentiveDetailPrevController incN = new IncentiveDetailPrevController();
        
        /*
        for(Metric_Tier_Relation__c mtr :upmtrlist){
            Metric__c mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Goal_Met__c= TRUE);
            insert mObj1;
        }      
        for(Metric_Tier_Relation__c mtr :upmtrlist){
            mtr.Metric_Input_Type__c = 'Automated'; 
            Update mtr;
        }*/

       Quarterly_Performance_Evaluation__c qpe = new Quarterly_Performance_Evaluation__c(Total_Incentive_QTD__c=10,Total_Credit_Memo_QTD__c=80,Quarter__c='Q2',Year__c=2010,Performance_Metric__c=p.Id,Account__c=acc.Id);
       insert qpe;
       IncentiveDetailPrevController incNew = new IncentiveDetailPrevController();
       incNew.incentiveCalculation();
       incNew.getnetAmount();
       incNew.gettotalPDFNumber(); 
       incNew.backToAccount();
       Double s= 10;
       incNew.setshipBonus(s);
       incNew.getshipBonus();
       incNew.setBonus(s); 
       incNew.getBonus();
       incNew.getPfContri();
       //incNew.getChckRwd();
       //incNew.button();
       //incNew.getisactive();
       //incNew.getTname();
       //incNew.gettotBonus();
       Integer a = 10;
       Integer c = 80;
       Metric_Tier_Relation__c mtr32 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum quarterly sales as SRI',Category__c='Performance to Business Plan',Incentive_Amount__c = a,Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Boolean_Metric_Y_N__c=TRUE);
       insert mtr32;
       Metric__c mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr32.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Boolean_Achievement__c=true,Goal_Met__c=true);
       insert mObj1;
       
       Metric_Tier_Relation__c mtr33 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_WRAP,Category__c='Marketing',Incentive_Amount__c = a,Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE,Boolean_Metric_Y_N__c=TRUE);
       insert mtr33;
       Metric__c mObj33 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr33.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Boolean_Achievement__c=true,Goal_Met__c=true);
       insert mObj33;
       
      /* Metric_Tier_Relation__c mtr44 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=erformanceEvalCst.SPWR_M1,Category__c='All SPWR solutions',Incentive_Amount__c = a,Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE,Boolean_Metric_Y_N__c=TRUE);
       insert mtr44;
       Metric__c mObj44 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr44.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Boolean_Achievement__c=true,Goal_Met__c=true);
       insert mObj44;
       */
       
       incNew.getEarnedIncentive();
       incNew.getPossibleIncentive();
       IncentiveDetailPrevController.MetricsDetails incMD = new IncentiveDetailPrevController.MetricsDetails();
       incMD.getmeetricTierRel();
       incMD.getMetric();
       List<IncentiveDetailPrevController.MetricsDetails> MDList = new List<IncentiveDetailPrevController.MetricsDetails>();
       incMD.meetricTierRel =mtr32;
       incMd.metric =mObj1;
       MDList.add(incMD);
       
       IncentiveDetailPrevController.MetricsDetails incMD1 = new IncentiveDetailPrevController.MetricsDetails();
       incMD1.meetricTierRel =mtr33;
       incMd1.metric =mObj33;
       MDList.add(incMD1);
       
       incNew.getIncentiveFromList(MDList);
       mtr32.Boolean_Metric_Y_N__c=false;
       Update mtr32;
       incNew.getIncentiveFromList(MDList);
       incNew.saveEvaluationIncentive();
       //insert MDList;
       //incNew.updateEvaluation();
       //IncentiveDetailPrevController.MtrDetail incMtr = new IncentiveDetailPrevController.MtrDetail();
       
        IncentiveCompositePrevController IncentiveCmpCntrl=new IncentiveCompositePrevController();
        System.debug('=====================MDLIST============' + MDList);
        IncentiveCompositePrevController.addCompositeMetricForMarket(upmtrlist, mdList, Date.Today(), P.Id, acc.Id);
        IncentiveCompositePrevController.checkMarketEUGoalMet(MDList, 'THREE');
        IncentiveCompositePrevController.checkMarketEUGoalMet(MDList, 'FOUR');
        IncentiveCompositePrevController.checkMarketEUGoalMet(MDList, 'SIX');
        IncentiveCompositePrevController.checkMarketEUGoalMet(MDList, 'SEVEN');
        IncentiveCompositePrevController.checkMarketUSAGoalMet(MDList);
        IncentiveCompositePrevController.updateCompositeMetricForMarket(MDList);
        IncentiveCompositePrevController.checkSPWRGoalMet2(MDList);
        IncentiveCompositePrevController.checkSPWRGoalMet1(MDList);
        IncentiveCompositePrevController.updateCompositeMetricForSPWR(MDList);
        IncentiveCompositePrevController.addCompositeMetricForSPWR(upmtrlist,MDList,dt4,p.Id,acc.Id);
        IncentiveCompositePrevController.addCompositeMetricForPbp(upmtrlist,MDList,dt4,p.Id,acc.Id);
        IncentiveCompositePrevController.checkPbpGoalMet1(MDList);
        IncentiveCompositePrevController.updateCompositeMetricForPbp(MDList);
        IncentiveCompositePrevController.addCompositeMetricForTrn(upmtrlist,MDList,dt4,p.Id,acc.Id);
        IncentiveCompositePrevController.checkTrainingGoalMet2(MDList);
        IncentiveCompositePrevController.checkSPWRsixGoalMet(MDList,'3');
           
       
      }catch(Exception ex){

      } 
       
  }
  
  
  private static void createTestData(){
    //Get RecordTypeId for Opportunity
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
  
  
  
  
  private static testmethod void incentiveCVARTest1(){  
    createTestData();
    Date startDate = date.newinstance(Date.today().year(), 7, 1); 
    Date endDate = date.newinstance(Date.today().year(), 12, 31);
    
    Performance_Metric__c perfMetric = new Performance_Metric__c(channel__c='Commercial', Peformance_Metric_Name__c='USAJuly2010_to_Dec2010_Comm',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= startDate,Performance_period_End_date__c =endDate ,Metric_Setup_Cut_off_Date__c = startdate.adddays(-15),Performance_Evaluation_Cut_off_Date__c = enddate.adddays(15) ); 
    insert perfMetric;
    
    Tier__c tier = new Tier__c();
    tier.Country__c = 'USA';
    insert tier;
    
    List<Metric_Tier_Relation__c> listMetrics = new List<Metric_Tier_Relation__c>();
        
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
    listMetrics.add(pbp3);
    
    Metric_Tier_Relation__c training2 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id, tier__c = tier.Id);
    training2.Metric_Label__c = 'Bonus for Extra Training';
    training2.Metric_Description__c = 'Bonus for Extra Training';
    training2.Category__c = 'Training';
    training2.Incentive_Amount__c = 0.5;
    training2.Part_Of_Composite_Incentive__c = true;    
    training2.Boolean_Metric_Y_N__c = true;
    training2.Metric_Input_Type__c = 'Automated';
    training2.Benefit_Tier__c = true;
    training2.isRSMView__c = false;
    listMetrics.add(training2);
        
    insert listMetrics;
    
    List<Metric__c> listAccountMetrics = new List<Metric__c>();
    Metric__c metric1 = new Metric__c();
    metric1.Account__c = acct.Id;
    metric1.Metric_Tier_Relation__c = listMetrics.get(0).Id;
    metric1.Performance_Metric__c = perfMetric.Id;
    metric1.Boolean_Achievement__c = true;
    metric1.Goal_Met__c = true;
    //insert metric1;
    
    listAccountMetrics.add(metric1);
    
    Metric__c metric2 = new Metric__c();
    metric2.Account__c = acct.Id;
    metric2.Metric_Tier_Relation__c = listMetrics.get(1).Id;
    metric2.Performance_Metric__c = perfMetric.Id;
    metric2.Boolean_Achievement__c = true;
    metric2.Goal_Met__c = true;
    
    listAccountMetrics.add(metric2);
    
    
    insert listAccountMetrics;
    
    Test.startTest();
    List<incentiveDetailPrevCommController.MetricsDetails> mdList = new list<incentiveDetailPrevCommController.MetricsDetails>();
    incentiveDetailPrevCommController.MetricsDetails wrapper1 = new incentiveDetailPrevCommController.MetricsDetails();
    wrapper1.meetricTierRel = pbp3;
    wrapper1.metric = listAccountMetrics.get(0);
    mdList.add(wrapper1);
    
    incentiveDetailPrevCommController.MetricsDetails wrapper2 = new incentiveDetailPrevCommController.MetricsDetails();
    wrapper2.meetricTierRel = training2;
    wrapper2.metric = listAccountMetrics.get(1);
    mdList.add(wrapper2);
    
    IncentiveCompositePrevController IncentiveCmpCntrl=new IncentiveCompositePrevController();
    IncentiveCompositePrevController.updateCompositeMetricForPbp(mdList);  
    IncentiveCompositePrevController.addCompositeMetricForTrn(listMetrics, mdList, Date.Today(), perfMetric.Id, acct.Id);   
    IncentiveCompositePrevController.addCompositeMetricForPbp(listMetrics, mdList, Date.Today(), perfMetric.Id, acct.Id);   
    IncentiveCompositePrevController.addCompositeMetricForTrn(listMetrics, mdList, Date.Today(), perfMetric.Id, acct.Id);
    
    Test.stopTest();
  }
  
  
  
  
  
  //Neeraj
    public static testMethod void testPerfCompositePrev1(){
        Date startDate = date.newinstance(2011,1,1);
        Date endDate = date.newinstance(2011,12,30);
        Performance_Metric__c perfMetric = new Performance_Metric__c(channel__c='Residential', Peformance_Metric_Name__c='USAJuly2010_to_Dec2010_Comm',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= startDate,Performance_period_End_date__c =endDate ,Metric_Setup_Cut_off_Date__c = startdate.adddays(-15),Performance_Evaluation_Cut_off_Date__c = enddate.adddays(15) ); 
        insert perfMetric;
        
        Tier__c tier = new Tier__c();
        tier.Country__c = 'USA';
        insert tier;
        
        Account acc = new Account(name='testSun1',BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America');
        insert acc;
        
        List<Metric_Tier_Relation__c> listMetrics = new List<Metric_Tier_Relation__c>();      
        listMetrics.add(createMTRObject(PerformanceEvalCst.MEET_SIX_MARKET,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.THREE_MARKET_EU,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.FOUR_MARKET_EU,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SIX_MARKET_EU,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SEVEN_MARKET_EU,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MARKET_USA_M1,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MARKET_USA_M2,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MARKET_USA_M3,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MARKET_USA_M4,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MARKET_USA_M5,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MARKET_USA_M6,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MARKET_USA_M5,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SEVENTY_RES_KITS_EU,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SEVENTY_COM_INVTR_EU,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SPWR_M1,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SPWR_M2,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SPWR_M3,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SPWR_M4,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SPWR_M5,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SPWR_M6,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MEET_SIX_SWPR,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.ALL_SWPR_EU,perfMetric.Id,tier.Id, 'All SPWR solutions'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.MARKET_WRAP,perfMetric.Id,tier.Id, 'Marketing'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.RSM_OBJECTIVES,perfMetric.Id,tier.Id, 'Performance to Business Plan'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.SIX_MONTHS_TARGET,perfMetric.Id,tier.Id, 'Performance to Business Plan'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.KW_TARGET_EU,perfMetric.Id,tier.Id, 'Performance to Business Plan'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.TRAINING_EXTRA_BONUS,perfMetric.Id,tier.Id, 'Training'));
        listMetrics.add(createMTRObject(PerformanceEvalCst.TRAINING_ASS_SALES_CERT_CVAR,perfMetric.Id,tier.Id, 'Training'));
        insert listMetrics;
        
        List<Metric__c> listAchievements = new List<Metric__c>();
        List<IncentiveDetailPrevController.MetricsDetails> pmdlst = new list<IncentiveDetailPrevController.MetricsDetails>();
        for(Metric_Tier_Relation__c mtr : listMetrics){
            Metric__c mt = new Metric__c();
            mt.Account__c = acc.Id;
            mt.Metric_Tier_Relation__c = mtr.Id;
            mt.Boolean_Achievement__c = true;
            mt.Goal_Met__c = true;
            listAchievements.add(mt);
            IncentiveDetailPrevController.MetricsDetails mtd = new IncentiveDetailPrevController.MetricsDetails();
            mtd.meetricTierRel = mtr; 
            mtd.metric = mt;
            pmdlst.add(mtd);
            //mtr.Metrics__r = new List<Metric__c>{mt};
        }
        insert listAchievements;
        
        listMetrics = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r),isRSMView__c from Metric_Tier_Relation__c where inactive__c=: false and Id IN : listMetrics ORDER by Sequence_Order__c];//Shishir: removed and isRSMView__c =: false condition REMOVED  OR Benefit_Tier__c=: true)
        
        Test.startTest();
        IncentiveCompositePrevController.addCompositeMetricForMarket(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        boolean result = IncentiveCompositePrevController.checkSPWRGoalMet2(pmdlst);
        System.assert(true, result);
        result = IncentiveCompositePrevController.checkSPWRGoalMet1(pmdlst);
        //System.assert(true, result);
        
        result = IncentiveCompositePrevController.checkMarketUSAGoalMet(pmdlst);
        //System.assert(true, result);
        IncentiveCompositePrevController.updateCompositeMetricForMarket(pmdlst);
        IncentiveCompositePrevController.updateCompositeMetricForSPWR(pmdlst);
        IncentiveCompositePrevController.addCompositeMetricForSPWR(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        IncentiveCompositePrevController.checkPbpGoalMet1(pmdlst);
        IncentiveCompositePrevController.addCompositeMetricForPbp(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        IncentiveCompositePrevController.checkTrainingGoalMet2(pmdlst);
        IncentiveCompositePrevController.checkSPWRsixGoalMet(pmdlst,'3');
        
        IncentiveCompositePrevController.addCompositeMetricForMarket(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
    IncentiveCompositePrevController.checkMarketEUGoalMet(pmdlst, 'THREE');
    IncentiveCompositePrevController.checkMarketEUGoalMet(pmdlst, 'FOUR');
    IncentiveCompositePrevController.checkMarketEUGoalMet(pmdlst, 'SIX');
    IncentiveCompositePrevController.checkMarketEUGoalMet(pmdlst, 'SEVEN');
    IncentiveCompositePrevController.checkMarketUSAGoalMet(pmdlst);
    IncentiveCompositePrevController.updateCompositeMetricForMarket(pmdlst);
    IncentiveCompositePrevController.checkSPWRGoalMet2(pmdlst);
    IncentiveCompositePrevController.checkSPWRGoalMet1(pmdlst);
    IncentiveCompositePrevController.updateCompositeMetricForSPWR(pmdlst);
    IncentiveCompositePrevController.addCompositeMetricForSPWR(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
    //IncentiveCompositePrevController.addCompositeMetricForPbp(listMetrics, mdList, Date.Today(), perfMetric.Id, acct.Id);
    IncentiveCompositePrevController.checkPbpGoalMet1(pmdlst);
    IncentiveCompositePrevController.updateCompositeMetricForPbp(pmdlst);
    IncentiveCompositePrevController.addCompositeMetricForTrn(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
    IncentiveCompositePrevController.checkTrainingGoalMet2(pmdlst);
    IncentiveCompositePrevController.checkSPWRsixGoalMet(pmdlst,'3');
    Test.stopTest();
    }
    
    public static testMethod void testPerfCompositePrev2(){
       
    }
    
    private static Metric_Tier_Relation__c createMTRObject(String label, String perfId, String tierId, String category){
        Metric_Tier_Relation__c marketMetric4 = new Metric_Tier_Relation__c(Performance_Metric__c = perfId,Tier__c = tierId);
        marketMetric4.Metric_Label__c = label;
        marketMetric4.Metric_Description__c = label;
        marketMetric4.Category__c = category;
        marketMetric4.Boolean_Metric_Y_N__c = true;
        marketMetric4.Metric_Input_Type__c = 'Manual';
        return marketMetric4;
        //marketMetric4.Stay_Tier__c = true;
    }
    
    public static testMethod void testIncentivePrev5(){
                
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt4 = date.newinstance(2010,12,12);
        Date dt5 = date.newinstance(2010,08,04);
        Date dt6 = date.newinstance(2010,7,31);
        Date dt7 = date.newinstance(2010,11,11);
        
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jul2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt4 );
        insert p;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier');
        insert t1;
        
        List<Metric_Tier_Relation__c> MTRList = new List<Metric_Tier_Relation__c>(); 
        
        Metric_Tier_Relation__c mtr01 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='All 6 of the above',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        insert mtr01;
        MTRList.add(mtr01);
        
        
        Metric_Tier_Relation__c mtr02 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='If 6 or more of the above are met',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr02;
        MTRList.add(mtr02);
        
        Metric_Tier_Relation__c mtr03 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr03;
        MTRList.add(mtr03);
        
        Metric_Tier_Relation__c mtr04 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Dealer Bonuses for meeting Business Objectives',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr04;
        MTRList.add(mtr04);
        
        Metric_Tier_Relation__c mtr05 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr05;
        MTRList.add(mtr05);
        
        
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Residential%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        
       List<IncentiveDetailPrevController.MetricsDetails> MDList = new list<IncentiveDetailPrevController.MetricsDetails>(); 
       
       IncentiveDetailPrevController.MetricsDetails incMD1 = new IncentiveDetailPrevController.MetricsDetails();
       incMD1.meetricTierRel =mtr02;
        MDList.add(incMD1);
        
        
        Test.startTest();
        IncentiveCompositePrevController incentive = new IncentiveCompositePrevController();
        IncentiveCompositePrevController.addCompositeMetricForMarket(MTRList, MDList, dt4, p.Id, selectedAcc.Id);
        IncentiveCompositePrevController.addCompositeMetricForSPWR(MTRList,MDList,dt4, p.id,selectedAcc.Id);
        IncentiveCompositePrevController.addCompositeMetricForPbp(MTRList,MDList,dt4, p.id,selectedAcc.Id);
        IncentiveCompositePrevController.addCompositeMetricForTrn(MTRList,MDList,dt4, p.id,selectedAcc.Id);
        
        Test.stopTest();
        
        
    } 
    
    public static testMethod void testIncentivePrev6(){
                
        
        //End_date
        Date dt4 = date.newinstance(2011,08,12);
        //Setup_Cut_off_Date__c
        Date dt5 = date.newinstance(2011,01,02);
        //Evaluation_Cut_off_Date__c
        Date dt6 = date.newinstance(2011,09,12);
        //Start_Date
        Date dt7 = date.newinstance(2011,02,02);
        
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jul2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt6 );
        insert p;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier');
        insert t1;
        
        List<Metric_Tier_Relation__c> MTRList = new List<Metric_Tier_Relation__c>(); 
        
        Metric_Tier_Relation__c mtr01 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='3 Marketing requirements met',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        insert mtr01;
        MTRList.add(mtr01);
        
        Metric_Tier_Relation__c mtr02 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='4 Marketing requirements met',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        insert mtr02;
        MTRList.add(mtr02);
        
        Metric_Tier_Relation__c mtr03 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='6 Marketing requirements met',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        insert mtr03;
        MTRList.add(mtr03);
        
        Metric_Tier_Relation__c mtr04 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='7 Marketing requirements met',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        insert mtr04;
        MTRList.add(mtr04);
        
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Premier%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        
        
        metric__c m1 = new metric__c();
        m1.Account__c=selectedAcc.id;
        m1.Performance_Metric__c=p.id;
        m1.Metric_Tier_Relation__c=mtr01.id;
        m1.Overriden__c=false;
        m1.Metric_Input_Type__c='Manual';
        m1.Achievement_Value__c=4;
        m1.Metric_Min_Value__c=2;
        insert m1;
        
        List<IncentiveDetailPrevController.MetricsDetails> MDList = new list<IncentiveDetailPrevController.MetricsDetails>(); 
       
      
        Test.startTest();
        IncentiveCompositePrevController incentive = new IncentiveCompositePrevController();
        IncentiveCompositePrevController.addCompositeMetricForMarket(MTRList,MDList,dt4, p.id,selectedAcc.Id);
        Test.stopTest();
        
        
    } 
 
}