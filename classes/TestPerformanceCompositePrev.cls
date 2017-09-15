@isTest
private class TestPerformanceCompositePrev {
    
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
        insert listMetrics;    
        
        List<Metric__c> listAchievements = new List<Metric__c>();
        List<PerformanceEvalPreviousController.MetricsDetails> pmdlst = new list<PerformanceEvalPreviousController.MetricsDetails>();
        for(Metric_Tier_Relation__c mtr : listMetrics){
            Metric__c mt = new Metric__c();
            mt.Account__c = acc.Id;
            mt.Metric_Tier_Relation__c = mtr.Id;
            mt.Boolean_Achievement__c = true;
            mt.Goal_Met__c = true;
            listAchievements.add(mt);
            PerformanceEvalPreviousController.MetricsDetails mtd = new PerformanceEvalPreviousController.MetricsDetails();
            mtd.meetricTierRel = mtr;
            mtd.metric = mt;
            pmdlst.add(mtd);
            //mtr.Metrics__r = new List<Metric__c>{mt};
        }
        insert listAchievements;
         
        listMetrics = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r),isRSMView__c from Metric_Tier_Relation__c where inactive__c=: false and Id IN : listMetrics ORDER by Sequence_Order__c];//Shishir: removed and isRSMView__c =: false condition REMOVED  OR Benefit_Tier__c=: true)
      
        Test.startTest();
        PerformanceCompositePrev.addCompositeMetricForMarket(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        boolean result = PerformanceCompositePrev.checkSPWRGoalMet2(pmdlst);
        System.assert(true, result);
        result = PerformanceCompositePrev.checkSPWRGoalMet1(pmdlst);
        System.assert(true, result);
        PerformanceCompositePrev.addCompositeMetricForSPWR(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        PerformanceCompositePrev.checkMarketUSAGoalMet(pmdlst);
        PerformanceCompositePrev.checkMarketEUGoalMet(pmdlst,'SIX');
        Test.stopTest();
    }
    
    public static testMethod void testPerfCompositePrev2(){
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
        insert listMetrics;
        //listMetrics = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from Metrics__r),isRSMView__c from Metric_Tier_Relation__c where inactive__c=: false and Id IN : listMetrics ORDER by Sequence_Order__c];

        
        List<Metric__c> listAchievements = new List<Metric__c>();
        List<PerformanceEvalPreviousController.MetricsDetails> pmdlst = new list<PerformanceEvalPreviousController.MetricsDetails>();
        for(Metric_Tier_Relation__c mtr : listMetrics){
            Metric__c mt = new Metric__c();
            mt.Account__c = acc.Id;
            mt.Metric_Tier_Relation__c = mtr.Id;
            mt.Boolean_Achievement__c = true;
            mt.Goal_Met__c = true;
            listAchievements.add(mt);
            PerformanceEvalPreviousController.MetricsDetails mtd = new PerformanceEvalPreviousController.MetricsDetails();
            mtd.meetricTierRel = mtr;
            mtd.metric = mt;
            pmdlst.add(mtd);
            //mtr.Metrics__r = new List<Metric__c>{mt};
        }
        insert listAchievements;
         
        //listMetrics = [select Performance_Metric__r.country__c,Performance_Metric__r.racking_price__c,Accept_Attachment__c, Metric_Description__c,Manual_Partner__c,Tier__c,Tier__r.Tier_Name__c,Incentive_Amount__c,child_metric__c,Benefit_Tier__c,Enter_Tier__c,Stay_Tier__c,Metric_Label__c,Category__c, Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Metric_Input_Type__c,Part_Of_Composite_Incentive__c,HelpText__c,Thershold__c,(select Attachment_Disabled__c,Overriden__c,Metric_Tier_Relation__r.HelpText__c,Goal_Met__c,Achievement_Value__c,Boolean_Achievement__c from  Metrics__r),isRSMView__c from Metric_Tier_Relation__c where inactive__c=: false and Id IN : listMetrics ORDER by Sequence_Order__c];//Shishir: removed and isRSMView__c =: false condition REMOVED  OR Benefit_Tier__c=: true)
      
        Test.startTest();
        PerformanceCompositePrev.addCompositeMetricForMarket(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        boolean result = PerformanceCompositePrev.checkSPWRGoalMet2(pmdlst);
        System.assert(true, result);
        result = PerformanceCompositePrev.checkSPWRGoalMet1(pmdlst);
        System.assert(true, result);
        PerformanceCompositePrev.addCompositeMetricForSPWR(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        PerformanceCompositePrev.checkMarketUSAGoalMet(pmdlst);
        PerformanceCompositePrev.checkMarketEUGoalMet(pmdlst,'SIX');
        Test.stopTest();
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
}