// 
// (c) 2010 Appirio, Inc.
//
// Test Class for IncentiveCompositeController for CVAR methods
//
// 12/5/2010    Hemant Garg(Appirio offshore)   Original
//  
@isTest
private class IncentiveCompositeControllerTest {
  private static Account acct;
  private static User partnerUser;
  
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
    List<IncentiveCommCls.MetricsDetails> mdList = new list<incentiveCommCls.MetricsDetails>();
    IncentiveCommCls.MetricsDetails wrapper1 = new IncentiveCommCls.MetricsDetails();
    wrapper1.meetricTierRel = pbp3;
    wrapper1.metric = listAccountMetrics.get(0);
    mdList.add(wrapper1);
    
    IncentiveCommCls.MetricsDetails wrapper2 = new IncentiveCommCls.MetricsDetails();
    wrapper2.meetricTierRel = training2;
    wrapper2.metric = listAccountMetrics.get(1);
    mdList.add(wrapper2);
    
    IncentiveCompositeController IncentiveCmpCntrl=new IncentiveCompositeController();
    IncentiveCompositeController.updateCompositeMetricForPbp(mdList);  
    IncentiveCompositeController.addCompositeMetricForPbp(listMetrics, mdList, Date.Today(), perfMetric.Id, acct.Id);   
    IncentiveCompositeController.addCompositeMetricForTrn(listMetrics, mdList, Date.Today(), perfMetric.Id, acct.Id);
    
    
    Test.stopTest();
  }
  
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
        
        
        /*incentiveCls inc = new incentiveCls();
        incentiveCls inc1 = new incentiveCls(acc.Id);*/
        
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
                
        IncentiveCls incN = new incentiveCls();
        
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
       incentiveCls incNew = new incentiveCls();
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
       incNew.getEarnedIncentive();
       incNew.getPossibleIncentive();
       incentiveCls.MetricsDetails incMD = new incentiveCls.MetricsDetails();
       incMD.getmeetricTierRel();
       incMD.getMetric();
       List<incentiveCls.MetricsDetails> MDList = new List<incentiveCls.MetricsDetails>();
       incMD.meetricTierRel =mtr32;
       incMd.metric =mObj1;
       MDList.add(incMD);
       incNew.getIncentiveFromList(MDList);
       mtr32.Boolean_Metric_Y_N__c=false;
       Update mtr32;
       incNew.getIncentiveFromList(MDList);
       incNew.saveEvaluationIncentive();
       //insert MDList;
       //incNew.updateEvaluation();
       //incentiveCls.MtrDetail incMtr = new incentiveCls.MtrDetail();
       
        IncentiveCompositeController IncentiveCmpCntrl=new IncentiveCompositeController();
        System.debug('=====================MDLIST============' + MDList);
        IncentiveCompositeController.addCompositeMetricForMarket(upmtrlist, mdList, Date.Today(), P.Id, acc.Id);
        IncentiveCompositeController.checkMarketEUGoalMet(MDList, 'THREE');
        IncentiveCompositeController.checkMarketEUGoalMet(MDList, 'FOUR');
        IncentiveCompositeController.checkMarketEUGoalMet(MDList, 'SIX');
        IncentiveCompositeController.checkMarketEUGoalMet(MDList, 'SEVEN');
        IncentiveCompositeController.checkMarketUSAGoalMet(MDList);
        IncentiveCompositeController.updateCompositeMetricForMarket(MDList);
        IncentiveCompositeController.checkSPWRGoalMet2(MDList);
        IncentiveCompositeController.checkSPWRGoalMet1(MDList);
        IncentiveCompositeController.updateCompositeMetricForSPWR(MDList);
        IncentiveCompositeController.addCompositeMetricForSPWR(upmtrlist,MDList,dt4,p.Id,acc.Id);
        IncentiveCompositeController.addCompositeMetricForPbp(upmtrlist,MDList,dt4,p.Id,acc.Id);
        IncentiveCompositeController.checkPbpGoalMet1(MDList);
        IncentiveCompositeController.updateCompositeMetricForPbp(MDList);
        IncentiveCompositeController.addCompositeMetricForTrn(upmtrlist,MDList,dt4,p.Id,acc.Id);
        IncentiveCompositeController.checkTrainingGoalMet2(MDList);
        IncentiveCompositeController.checkSPWRsixGoalMet(MDList,'3');
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