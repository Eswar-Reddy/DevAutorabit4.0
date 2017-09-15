public class Incomptestcls{
    @isTest(seeAllData=true)
    static void testIcomCls(){
        IncentiveCompositeController pc = new IncentiveCompositeController();
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Account acc = new Account(name='testSun1',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908');
        insert acc;
        String accountId1 = acc.Id ;
        Performance_Metric__c p = new Performance_Metric__c(Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA');
        insert p;
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        list<Metric_Tier_Relation__c> mtrl = new list<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='All 6 of the above');
        insert mtr;
        mtrl.add(mtr);
        Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='3 Marketing requirements met');
        insert mtr1;
        mtrl.add(mtr1);
        Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='4 Marketing requirements met');
        insert mtr2;
        mtrl.add(mtr2);
        Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='6 Marketing requirements met');
        insert mtr3;
        mtrl.add(mtr3);
        Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='7 Marketing requirements met');
        insert mtr4;
        mtrl.add(mtr4);
        
        list<incentiveCls.MetricsDetails> pmdlst = new list<incentiveCls.MetricsDetails>();
        list<Metric_Tier_Relation__c> mtrls = new list<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c mtrr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Adhere to Brand Guidelines');
        insert mtrr1;
        mtrls.add(mtrr1);
        Metric_Tier_Relation__c mtrr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Local events');
        insert mtrr2;
        mtrls.add(mtrr2);
        Metric_Tier_Relation__c mtrr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Dealer Webpage and Logo Usage');
        insert mtrr3;
        mtrls.add(mtrr3);
        Metric_Tier_Relation__c mtrr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Co-branded sales and installation apparel');
        insert mtrr4;
        mtrls.add(mtrr4);
        Metric_Tier_Relation__c mtrr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Display panels/cells in showroom');
        insert mtrr5;
        mtrls.add(mtrr5);
        Metric_Tier_Relation__c mtrr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Advertising');
        insert mtrr6;
        mtrls.add(mtrr6);
        //
        Metric_Tier_Relation__c mtrr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems');
        insert mtrr7;
        mtrls.add(mtrr7);
        Metric_Tier_Relation__c mtrr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Commercial sales include Inverter');
        insert mtrr8;
        mtrls.add(mtrr8);
        //SPW
        Metric_Tier_Relation__c mtrr01 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Solar Loan OR Same-As-cash loan applications');
        insert mtrr01;
        mtrls.add(mtrr01);
        Metric_Tier_Relation__c mtrr02 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Opportunity Close rate for SunPower Opportunities');
        insert mtrr02;
        mtrls.add(mtrr02);
        Metric_Tier_Relation__c mtrr03 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Demo Product Purchase');
        insert mtrr03;
        mtrls.add(mtrr03);
        Metric_Tier_Relation__c mtrr04 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Alliance Partner Lead');
        insert mtrr04;
        mtrls.add(mtrr04);
        Metric_Tier_Relation__c mtrr05 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Attend instructor led class');
        insert mtrr05;
        mtrls.add(mtrr05);
        Metric_Tier_Relation__c mtrr06 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Foundation alliance');
        insert mtrr06;
        mtrls.add(mtrr06);
        Metric_Tier_Relation__c mtrr07 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='New Product Introduction');
        insert mtrr07;
        mtrls.add(mtrr07);
        Metric_Tier_Relation__c mtrr08 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SmartMount Installation');
        insert mtrr08;
        mtrls.add(mtrr08);
        Metric_Tier_Relation__c mtrr09 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Consulting Seminar/ Peer Group Meeting');
        insert mtrr09;
        mtrls.add(mtrr09);
        mtrls.add(mtr);
        mtrls.add(mtr1);
        mtrls.add(mtr2);
        mtrls.add(mtr3);
        mtrls.add(mtr4);
        
        list<Metric_Tier_Relation__c> mtrl1 = new list<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c mtrs1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='If 6 or more of the above are met');
        insert mtrs1;
        mtrls.add(mtrs1);
        Metric_Tier_Relation__c mtrs2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions');
        insert mtrs2;
        mtrls.add(mtrs2);
        
        Metric_Tier_Relation__c mtrs3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Dealer Bonuses for meeting Business Objectives');
        insert mtrs3;
        mtrls.add(mtrs3);
        Metric_Tier_Relation__c mtrs4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='3 Agreed Upon RSM Objectives',isRSMView__c=true);
        insert mtrs4;
        mtrls.add(mtrs4);
       
        
        list<Metric__c> ms = new list<Metric__c>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false);
            insert mObj;
            ms.add(mObj);
            incentiveCls.MetricsDetails pmd = new incentiveCls.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            system.debug('list** size'+pmd);
            pmdlst.clear();
            pmdlst.add(pmd);
            IncentiveCompositeController.checkMarketUSAGoalMet(pmdlst);
            IncentiveCompositeController.checkSPWRGoalMet1(pmdlst);
            IncentiveCompositeController.checkSPWRGoalMet2(pmdlst);
            IncentiveCompositeController.updateCompositeMetricForMarket(pmdlst);
            IncentiveCompositeController.updateCompositeMetricForSPWR(pmdlst);
            IncentiveCompositeController.checkPbpGoalMet1(pmdlst);
            IncentiveCompositeController.updateCompositeMetricForPbp(pmdlst);
        }
        
        
        
        system.debug('list size'+pmdlst.size());
        system.debug('list detail'+pmdlst);
        IncentiveCompositeController.addCompositeMetricForMarket(mtrl,pmdlst,dt,p.Id,accountId1);
        
        list<incentiveCls.MetricsDetails> pmdlst1 = new list<incentiveCls.MetricsDetails>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=true);
            insert mObj;
            incentiveCls.MetricsDetails pmd = new incentiveCls.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            pmdlst1.add(pmd);
        }
        IncentiveCompositeController.checkMarketEUGoalMet(pmdlst1,'SIX');
        IncentiveCompositeController.checkMarketEUGoalMet(pmdlst1,'SEVEN');
        IncentiveCompositeController.checkMarketEUGoalMet(pmdlst1,'THREE');
        IncentiveCompositeController.checkMarketEUGoalMet(pmdlst1,'FOUR');
        IncentiveCompositeController.checkMarketEUGoalMet(pmdlst1,'two');
        
        
        IncentiveCompositeController.addCompositeMetricForSPWR(mtrls,pmdlst,dt,p.Id,accountId1);
         IncentiveCompositeController.addCompositeMetricForPbp(mtrls,pmdlst,dt,p.Id,accountId1);
    }
    
    @isTest(seeAllData=true)
    static void testIcomCls2(){
        IncentiveCompositeController pc = new IncentiveCompositeController();
        Date dt = date.newinstance(2011,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Account acc = new Account(name='testSun11',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908');
        insert acc;
        String accountId1 = acc.Id ;
        Performance_Metric__c p = new Performance_Metric__c(Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA');
        insert p;
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        list<Metric_Tier_Relation__c> mtrl = new list<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='All 6 of the above');
        insert mtr;
        mtrl.add(mtr);
        Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='3 Marketing requirements met');
        insert mtr1;
        mtrl.add(mtr1);
        Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='4 Marketing requirements met');
        insert mtr2;
        mtrl.add(mtr2);
        Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='6 Marketing requirements met');
        insert mtr3;
        mtrl.add(mtr3);
        Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='7 Marketing requirements met');
        insert mtr4;
        mtrl.add(mtr4);
        
       
        
        
        list<incentiveCls.MetricsDetails> pmdlst = new list<incentiveCls.MetricsDetails>();
        list<Metric_Tier_Relation__c> mtrls = new list<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c mtrr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Adhere to Brand Guidelines');
        insert mtrr1;
        mtrls.add(mtrr1);
        Metric_Tier_Relation__c mtrr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Local events');
        insert mtrr2;
        mtrls.add(mtrr2);
        Metric_Tier_Relation__c mtrr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Dealer Webpage and Logo Usage');
        insert mtrr3;
        mtrls.add(mtrr3);
        Metric_Tier_Relation__c mtrr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Co-branded sales and installation apparel');
        insert mtrr4;
        mtrls.add(mtrr4);
        Metric_Tier_Relation__c mtrr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Display panels/cells in showroom');
        insert mtrr5;
        mtrls.add(mtrr5);
        Metric_Tier_Relation__c mtrr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Advertising');
        insert mtrr6;
        mtrls.add(mtrr6);
        //
        Metric_Tier_Relation__c mtrr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems');
        insert mtrr7;
        mtrls.add(mtrr7);
        Metric_Tier_Relation__c mtrr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Commercial sales include Inverter');
        insert mtrr8;
        mtrls.add(mtrr8);
        //SPW
        Metric_Tier_Relation__c mtrr01 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Solar Loan OR Same-As-cash loan applications');
        insert mtrr01;
        mtrls.add(mtrr01);
        Metric_Tier_Relation__c mtrr02 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Opportunity Close rate for SunPower Opportunities');
        insert mtrr02;
        mtrls.add(mtrr02);
        Metric_Tier_Relation__c mtrr03 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Demo Product Purchase');
        insert mtrr03;
        mtrls.add(mtrr03);
        Metric_Tier_Relation__c mtrr04 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Alliance Partner Lead');
        insert mtrr04;
        mtrls.add(mtrr04);
        Metric_Tier_Relation__c mtrr05 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Attend instructor led class');
        insert mtrr05;
        mtrls.add(mtrr05);
        Metric_Tier_Relation__c mtrr06 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Foundation alliance');
        insert mtrr06;
        mtrls.add(mtrr06);
        Metric_Tier_Relation__c mtrr07 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='New Product Introduction');
        insert mtrr07;
        mtrls.add(mtrr07);
        Metric_Tier_Relation__c mtrr08 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SmartMount Installation');
        insert mtrr08;
        mtrls.add(mtrr08);
        Metric_Tier_Relation__c mtrr09 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Consulting Seminar/ Peer Group Meeting');
        insert mtrr09;
        mtrls.add(mtrr09);
        
        //list<Metric_Tier_Relation__c> mtrl3 = [select Metric_Label__c,Id,(select Id,Overriden__c from Metrics__r)from Metric_Tier_Relation__c where Id In :mid2];
        mtrls.add(mtr);
        mtrls.add(mtr1);
        mtrls.add(mtr2);
        mtrls.add(mtr3);
        mtrls.add(mtr4);
        
        list<Metric_Tier_Relation__c> mtrl1 = new list<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c mtrs1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='If 6 or more of the above are met');
        insert mtrs1;
        mtrls.add(mtrs1);
        Metric_Tier_Relation__c mtrs2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions');
        insert mtrs2;
        mtrls.add(mtrs2);
        
        Metric_Tier_Relation__c mtrs3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Dealer Bonuses for meeting Business Objectives');
        insert mtrs3;
        mtrls.add(mtrs3);
        Metric_Tier_Relation__c mtrs4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='3 Agreed Upon RSM Objectives',isRSMView__c=true);
        insert mtrs4;
        mtrls.add(mtrs4);
       
         list<Id> mid2 = new list<Id>();
        list<Metric__c> ms = new list<Metric__c>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false);
            insert mObj;
            ms.add(mObj);
            incentiveCls.MetricsDetails pmd = new incentiveCls.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            system.debug('list** size'+pmd);
            pmdlst.clear();
            pmdlst.add(pmd);
            mid2.add(mt.Id);
        }
        
       list<Metric_Tier_Relation__c> mtrl3 = [select Metric_Label__c,Id,(select Id,Overriden__c from Metrics__r)from Metric_Tier_Relation__c where Id In :mid2];
        
        system.debug('list size'+pmdlst.size());
        system.debug('list detail'+pmdlst);
        IncentiveCompositeController.addCompositeMetricForMarket(mtrl3,pmdlst,dt,p.Id,accountId1);
        
        list<incentiveCls.MetricsDetails> pmdlst1 = new list<incentiveCls.MetricsDetails>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=true);
            insert mObj;
            incentiveCls.MetricsDetails pmd = new incentiveCls.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            pmdlst1.add(pmd);
        }
        
       /* list<Id> mid2 = new list<Id>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj3 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
            insert mObj3;
            mid2.add(mt.Id);
        }*/
        //list<Metric_Tier_Relation__c> mtrl3 = [select Metric_Label__c,Id,(select Id,Overriden__c from Metrics__r)from Metric_Tier_Relation__c where Id In :mid2];
        IncentiveCompositeController.addCompositeMetricForSPWR(mtrl3,pmdlst,dt,p.Id,accountId1);
        IncentiveCompositeController.addCompositeMetricForPbp(mtrl3,pmdlst,dt,p.Id,accountId1);
    }
    
    /*Test Coverage for CVAR methods */
    
    private static Account acct;
    private static User partnerUser;
    @isTest(seeAllData=true)
    static void incentiveCVARTest1(){    
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
        
        IncentiveCompositeController.updateCompositeMetricForPbp(mdList);  
            
        IncentiveCompositeController.addCompositeMetricForPbp(listMetrics, mdList, Date.Today(), perfMetric.Id, acct.Id);   
        IncentiveCompositeController.addCompositeMetricForTrn(listMetrics, mdList, Date.Today(), perfMetric.Id, acct.Id);
        
        Test.stopTest();
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