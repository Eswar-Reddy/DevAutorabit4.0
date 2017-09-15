@isTest
private class TestPerformanceEvalPreviousController {
    
     public static testMethod void testPreviousPerformance1(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Elite%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        } 
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();
        prevController.getPartnerExecutive();
        prevController.getHideHeaderForPartner();
        prevController.getDisableEditButton();
        prevController.getDisableButton();
        prevController.setDisableButton(true);
        prevController.getparamExpDate();  
        prevController.getperformanceMetricID();
        prevController.getparamStartDate();
        prevController.getparamEndDate();
        prevController.getaccountId();
        prevController.getvalidExpToDate();
        prevController.getcustomer_Satisfaction_Current();
        prevController.getperformance_to_business_Plan_Current();
        prevController.gettraining_Current();
        prevController.gettraining_Current_Clone();
        prevController.getmarketing_Current();
        prevController.getall_spwr_solutions_Current();
        prevController.getall_spwr_solutions_Next();
        prevController.getcustomer_Satisfaction_Next();
        prevController.getperformance_to_business_Plan_Next();
        prevController.gettraining_Next();
        prevController.getmarketing_Next();
        prevController.getpartnerTier();
        prevController.getAccountName();
        prevController.getPartnerType();
        prevController.getValidEvalFromDate();
        prevController.getValidEvalToDate();
        prevController.getShowNextTab();
        prevController.getTierStartDate();
        prevController.getisExecutiveManager();
        prevController.getAccTheatre();
        prevController.enableInputFields();
        prevController.getShowLink();
        prevController.getSPWRCurrentFlag();
        prevController.getSPWRNextFlag();
        
        prevController.expandChildren();
        prevController.getIsPortalUser();
        prevController.updateEvaluation();
        ApexPages.StandardController sc = new ApexPages.StandardController(selectedAcc);
        PerformanceEvalPreviousController prevController1 = new PerformanceEvalPreviousController(sc);
        //PerformanceEvalPreviousController prevController2 = new PerformanceEvalPreviousController(selectedAcc.Id,'2','2010');
       
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance5(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Premier%' and Theater__c='Europe' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        } 
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        Metric_Tier_Relation__c m = [select id from Metric_Tier_Relation__c limit 1];
        ApexPages.currentPage().getParameters().put('mkId_Next',m.id);
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();
        prevController.goToPreviousperformanceEvalPage();
        prevController.expandChildren();
        PerformanceEvalPreviousController.MetricsDetails mtd = new PerformanceEvalPreviousController.MetricsDetails(true);
        mtd.getmeetricTierRel();
        mtd.getMetric();
        //ApexPages.StandardController sc = new ApexPages.StandardController(selectedAcc);
       // PerformanceEvalPreviousController prevController1 = new PerformanceEvalPreviousController(sc);
        //PerformanceEvalPreviousController prevController2 = new PerformanceEvalPreviousController(selectedAcc.Id,'2','2010');
       
      
       
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance6(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Authorized%' and Theater__c='Europe' and country_domain__c='rvar-de' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        } 
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        
        ApexPages.currentPage().getParameters().put('period',null);
        ApexPages.currentPage().getParameters().put('year',null);
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(selectedAcc);
        PerformanceEvalPreviousController prevController1 = new PerformanceEvalPreviousController(sc);
        //PerformanceEvalPreviousController prevController2 = new PerformanceEvalPreviousController(selectedAcc.Id,'2','2010');
        
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        prevController = new PerformanceEvalPreviousController();
        
        sc = new ApexPages.StandardController(selectedAcc);
        prevController1 = new PerformanceEvalPreviousController(sc);
        //prevController2 = new PerformanceEvalPreviousController(selectedAcc.Id,'2','2010');
         
        Test.stopTest();
    }
    
     public static testMethod void testPreviousPerformance9(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Residential I%' and Theater__c='Europe' and country_domain__c='rvar-it' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        } 
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();
         PerformanceEvalPreviousController prevController1 = new PerformanceEvalPreviousController(selectedAcc.ID,'2','2010');
        
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance2(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Premier%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();
        
         prevController.getPartnerExecutive();
        prevController.getHideHeaderForPartner();
        prevController.getDisableEditButton();
        prevController.getDisableButton();
        prevController.setDisableButton(true);
        prevController.getparamExpDate();
        prevController.getperformanceMetricID();
        prevController.getparamStartDate();
        prevController.getparamEndDate();
        prevController.getaccountId();
        prevController.getvalidExpToDate();
        prevController.getcustomer_Satisfaction_Current();
        prevController.getperformance_to_business_Plan_Current();
        prevController.gettraining_Current();
        prevController.gettraining_Current_Clone();
        prevController.getmarketing_Current();
        prevController.getall_spwr_solutions_Current();
        prevController.getall_spwr_solutions_Next();
        prevController.getcustomer_Satisfaction_Next();
        prevController.getperformance_to_business_Plan_Next();
        prevController.gettraining_Next();
        prevController.getmarketing_Next();
        prevController.getpartnerTier();
        prevController.getAccountName();
        prevController.getPartnerType();
        prevController.getValidEvalFromDate();
        prevController.getValidEvalToDate();
        prevController.getShowNextTab();
        prevController.getTierStartDate();
        prevController.getisExecutiveManager();
        prevController.getAccTheatre();
        prevController.enableInputFields();
        prevController.getShowLink();
        prevController.getSPWRCurrentFlag();
        prevController.getSPWRNextFlag();     
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance3(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Authorized%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();     
        Test.stopTest();
    }
    
    public static testMethod void testPcomCls(){
        PerformanceEvalPreviousController pc = new PerformanceEvalPreviousController ();
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Account acc = new Account(name='testSun1',BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1);
        insert acc;
        String accountId1 = acc.Id ;
        Performance_Metric__c p = new Performance_Metric__c(Country__c='USA',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010');
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
        
        list<PerformanceEvalController.MetricsDetails> pmdlst = new list<PerformanceEvalController.MetricsDetails>();
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
        
        list<Metric__c> ms = new list<Metric__c>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false);
            insert mObj;
            ms.add(mObj);
            PerformanceEvalController.MetricsDetails pmd = new PerformanceEvalController.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            system.debug('list** size'+pmd);
            pmdlst.clear();
            pmdlst.add(pmd);
            //PerformanceEvalPreviousController.checkMarketUSAGoalMet(pmdlst);
            //PerformanceEvalPreviousController.checkSPWRGoalMet1(pmdlst);
           // PerformanceEvalPreviousController.checkSPWRGoalMet2(pmdlst);
        }
        system.debug('list size'+pmdlst.size());
        system.debug('list detail'+pmdlst);
       // PerformanceEvalPreviousController.addCompositeMetricForMarket(mtrl,pmdlst,dt,p.Id,accountId1);
        
        list<PerformanceEvalController.MetricsDetails> pmdlst1 = new list<PerformanceEvalController.MetricsDetails>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=true);
            insert mObj;
            PerformanceEvalController.MetricsDetails pmd = new PerformanceEvalController.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            pmdlst1.add(pmd);
        }
       // PerformanceEvalPreviousController.checkMarketEUGoalMet(pmdlst1,'SIX');
       // PerformanceEvalPreviousController.checkMarketEUGoalMet(pmdlst1,'SEVEN');
       // PerformanceEvalPreviousController.checkMarketEUGoalMet(pmdlst1,'THREE');
       // PerformanceEvalPreviousController.checkMarketEUGoalMet(pmdlst1,'FOUR');
       // PerformanceEvalPreviousController.checkMarketEUGoalMet(pmdlst1,'two');
        
        list<Metric_Tier_Relation__c> mtrl1 = new list<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c mtrs1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='If 6 or more of the above are met');
        insert mtrs1;
        mtrls.add(mtrs1);
        Metric_Tier_Relation__c mtrs2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions');
        insert mtrs2;
        mtrls.add(mtrs2);
        //PerformanceEvalPreviousController.addCompositeMetricForSPWR(mtrls,pmdlst,dt,p.Id,accountId1);
       
               
    }
    public static testMethod void testPcomCls2(){
        PerformanceEvalPreviousController pc = new PerformanceEvalPreviousController();
        Date dt = date.newinstance(2011,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Account acc = new Account(name='testSun1',BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1);
        insert acc;
        String accountId1 = acc.Id ;
        Performance_Metric__c p = new Performance_Metric__c(Country__c='USA',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010');
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
        list<Id> mid = new list<Id>();
        for(Metric_Tier_Relation__c mt:mtrl){
            Metric__c mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
            insert mObj1;
            mid.add(mt.Id);
        }
        list<Metric_Tier_Relation__c> mtrl2 = [select Metric_Label__c,Id,(select Id,Overriden__c from Metrics__r)from Metric_Tier_Relation__c where Id In :mid];
        
        system.debug('size333'+mtr.Metrics__r);
        mtrl.add(mtr);
        
        list<PerformanceEvalController.MetricsDetails> pmdlst = new list<PerformanceEvalController.MetricsDetails>();
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
        
        
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false);
            insert mObj;
            
            PerformanceEvalController.MetricsDetails pmd = new PerformanceEvalController.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            system.debug('list** size'+pmd);
            pmdlst.clear();
            pmdlst.add(pmd);
            
        }
        system.debug('list size'+pmdlst.size());
        system.debug('list detail'+pmdlst);
        //PerformanceEvalPreviousController.addCompositeMetricForMarket(mtrl2,pmdlst,dt,p.Id,accountId1);

       list<Metric_Tier_Relation__c> mtrl1 = new list<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c mtrs1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='If 6 or more of the above are met');
        insert mtrs1;
        mtrls.add(mtrs1);
        Metric_Tier_Relation__c mtrs2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions');
        insert mtrs2;
        mtrls.add(mtrs2);
        list<Id> mid2 = new list<Id>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj3 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
            insert mObj3;
            mid2.add(mt.Id);
        }
        list<Metric_Tier_Relation__c> mtrl3 = [select Metric_Label__c,Id,(select Id,Overriden__c from Metrics__r)from Metric_Tier_Relation__c where Id In :mid2];
        //PerformanceEvalPreviousController .addCompositeMetricForSPWR(mtrl3,pmdlst,dt,p.Id,accountId1); 
    }
    
    
    public static testMethod void testPerformance1(){
        
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Elite%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();
        
        Date startDate = date.newinstance(2010,1,1);
        Date endDate = date.newinstance(2010,12,30);
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
        
//        Test.startTest();
        
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',acc.ID);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        prevController = new PerformanceEvalPreviousController();
        prevController.getPartnerExecutive();
        prevController.getHideHeaderForPartner();
        prevController.getDisableEditButton();
        prevController.getDisableButton();
        prevController.setDisableButton(true);
        prevController.getparamExpDate();  
        prevController.getperformanceMetricID();
        prevController.getparamStartDate();
        prevController.getparamEndDate();
        prevController.getaccountId();
        prevController.getvalidExpToDate();
        prevController.getcustomer_Satisfaction_Current();
        prevController.getperformance_to_business_Plan_Current();
        prevController.gettraining_Current();
        prevController.gettraining_Current_Clone();
        prevController.getmarketing_Current();
        prevController.getall_spwr_solutions_Current();
        prevController.getall_spwr_solutions_Next();
        prevController.getcustomer_Satisfaction_Next();
        prevController.getperformance_to_business_Plan_Next();
        prevController.gettraining_Next();
        prevController.getmarketing_Next();
        prevController.getpartnerTier();
        prevController.getAccountName();
        prevController.getPartnerType();
        prevController.getValidEvalFromDate();
        prevController.getValidEvalToDate();
        prevController.getShowNextTab();
        prevController.getTierStartDate();
        prevController.getisExecutiveManager();
        prevController.getAccTheatre();
        prevController.enableInputFields();
        prevController.getShowLink();
        prevController.getSPWRCurrentFlag();
        prevController.getSPWRNextFlag();
        
        prevController.expandChildren();
        prevController.getIsPortalUser();
        try{
        prevController.updateEvaluation();
        }
        catch(Exception ex){
        }
        
        
       /* prevController.addCompositeMetricForTrn(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        prevController.addCompositeMetricForSPWR(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        prevController.addCompositeMetricForPbp(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
        
        */
        
       /* IncentiveCompositePrevController.addCompositeMetricForMarket(listMetrics, pmdlst, perfMetric.Performance_Evaluation_Cut_off_Date__c, perfMetric.Id, acc.Id);
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
        IncentiveCompositePrevController.checkTrainingGoalMet2(pmdlst);
    IncentiveCompositePrevController.checkSPWRsixGoalMet(pmdlst,'3');*/
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
    
    
    
    public static testMethod void testPreviousPerformance11(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Authorized%' and Theater__c='North America' and status__c='active' order by name desc limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();
        prevController.getPartnerExecutive();
        prevController.getHideHeaderForPartner();
        prevController.getDisableEditButton();
        prevController.getDisableButton();
        prevController.setDisableButton(true);
        prevController.getparamExpDate();
        prevController.getperformanceMetricID();
        prevController.getparamStartDate();
        prevController.getparamEndDate();
        prevController.getaccountId();
        prevController.getvalidExpToDate();
        prevController.getcustomer_Satisfaction_Current();
        prevController.getperformance_to_business_Plan_Current();
        prevController.gettraining_Current();
        prevController.gettraining_Current_Clone();
        prevController.getmarketing_Current();
        prevController.getall_spwr_solutions_Current();
        prevController.getall_spwr_solutions_Next();
        prevController.getcustomer_Satisfaction_Next();
        prevController.getperformance_to_business_Plan_Next();
        prevController.gettraining_Next();
        prevController.getmarketing_Next();
        prevController.getpartnerTier();
        prevController.getAccountName();
        prevController.getPartnerType();
        prevController.getValidEvalFromDate();
        prevController.getValidEvalToDate();
        prevController.getShowNextTab();
        prevController.getTierStartDate();
        prevController.getisExecutiveManager();
        prevController.getAccTheatre();
        prevController.enableInputFields();
        prevController.getShowLink();
        prevController.getSPWRCurrentFlag();
        prevController.getSPWRNextFlag();
        
        prevController.expandChildren();
        prevController.getIsPortalUser();
        try{
        prevController.updateEvaluation();
        }
        catch(Exception ex){
        }
        ApexPages.StandardController sc = new ApexPages.StandardController(selectedAcc);
        PerformanceEvalPreviousController prevController1 = new PerformanceEvalPreviousController(sc);
        //PerformanceEvalPreviousController prevController2 = new PerformanceEvalPreviousController(selectedAcc.Id,'2','2010');
       
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance12(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Premier%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();
        
         prevController.getPartnerExecutive();
        prevController.getHideHeaderForPartner();
        prevController.getDisableEditButton();
        prevController.getDisableButton();
        prevController.setDisableButton(true);
        prevController.getparamExpDate();
        prevController.getperformanceMetricID();
        prevController.getparamStartDate();
        prevController.getparamEndDate();
        prevController.getaccountId();
        prevController.getvalidExpToDate();
        prevController.getcustomer_Satisfaction_Current();
        prevController.getperformance_to_business_Plan_Current();
        prevController.gettraining_Current();
        prevController.gettraining_Current_Clone();
        prevController.getmarketing_Current();
        prevController.getall_spwr_solutions_Current();
        prevController.getall_spwr_solutions_Next();
        prevController.getcustomer_Satisfaction_Next();
        prevController.getperformance_to_business_Plan_Next();
        prevController.gettraining_Next();
        prevController.getmarketing_Next();
        prevController.getpartnerTier();
        prevController.getAccountName();
        prevController.getPartnerType();
        prevController.getValidEvalFromDate();
        prevController.getValidEvalToDate();
        prevController.getShowNextTab();
        prevController.getTierStartDate();
        prevController.getisExecutiveManager();
        prevController.getAccTheatre();
        prevController.enableInputFields();
        prevController.getShowLink();
        prevController.getSPWRCurrentFlag();
        prevController.getSPWRNextFlag();     
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance13(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Authorized%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('accId',null);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();     
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance14(){
         Date exDate = date.newinstance(2011,5,1);
        Date startDate = date.newinstance(2011,1,1);
        Date endDate = date.newinstance(2011,12,30);
        
        Account acc = new Account(name='testSun1',BillingCity='New York',BillingCountry ='USA',BillingStreet='abc',BillingPostalCode='908',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=startDate,Promoted_Premier_Date__c = startDate);
        insert acc;
        String accountId1 = acc.Id ;
        
        
        Performance_Metric__c p = new Performance_Metric__c(Country__c='USA',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Thea__c ='North America',channel__c='Residential',Performance_period_End_date__c=date.today().addDays(60),open_edit_date__c=date.today().addDays(30));
        insert p;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        
        list<Metric_Tier_Relation__c> mtrls = new list<Metric_Tier_Relation__c>();
       
        Metric_Tier_Relation__c mtrr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Basic Product training',Metric_Input_Type__c='Automated',Part_Of_Composite_Incentive__c=true);
        insert mtrr1;
        mtrls.add(mtrr1);
        
        Metric_Tier_Relation__c mtrr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training Attendance:  Associate Design');
        insert mtrr2;
        mtrls.add(mtrr2);
        
        Metric_Tier_Relation__c mtrr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training Attendance:  Associate Install');
        insert mtrr3;
        mtrls.add(mtrr3);
        
        Metric_Tier_Relation__c mtrr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training Attendance:  Associate Sales');
        insert mtrr4;
        mtrls.add(mtrr4);
        
        Metric_Tier_Relation__c mtrr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage');
        insert mtrr5;
        mtrls.add(mtrr5);
        
        Metric_Tier_Relation__c mtrr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='All 6 of the above');
        insert mtrr6;
        mtrls.add(mtrr6);
        
        Metric_Tier_Relation__c mtrr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems');
        insert mtrr7;
        mtrls.add(mtrr7);
        
        Metric_Tier_Relation__c mtrr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training Attendance:  Associate Design');
        insert mtrr9;
        mtrls.add(mtrr9);
              
        Metric_Tier_Relation__c mtrr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum Premier credit or bank guarantee');
        insert mtrr10;
        mtrls.add(mtrr10);
        
      
        List<PerformanceEvalPreviousController.MetricsDetails> pmdlst = new list<PerformanceEvalPreviousController.MetricsDetails>();
        List<Metric__c> listAchievements = new List<Metric__c>();
        
        Metric__c mt = new Metric__c();
        mt.Account__c = acc.Id;
        mt.Metric_Tier_Relation__c = mtrr6.Id;
        mt.Boolean_Achievement__c = true;
        mt.Goal_Met__c = true;
        insert mt;
        
        listAchievements.add(mt);
        
        for(Metric_Tier_Relation__c mtr : mtrls){
            
            PerformanceEvalPreviousController.MetricsDetails mtd = new PerformanceEvalPreviousController.MetricsDetails();
            mtd.meetricTierRel = mtr;
            mtd.metric = mt;
            pmdlst.add(mtd);
            //mtr.Metrics__r = new List<Metric__c>{mt};
        }
        
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('ACCOUNT_CHANNEL_NAME','Residential');
        ApexPages.currentPage().getParameters().put('activeTab','current');
        ApexPages.currentPage().getParameters().put('accId',accountId1);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();     
        PerformanceEvalPreviousController prevController1 = new PerformanceEvalPreviousController(acc.Id);
        
        prevController.populateCategoriesForTiers(mtrls,p.id,exDate,startDate,endDate,'Current');
        prevController.checkTrainingGoalMet(pmdlst);
        prevController.addCompositeMetricForTrn(mtrls,pmdlst,exDate,p.id);
        prevController.updateEvaluation();
        prevController.updateMetricRecords();
        prevController.AutomatedSPWRMetric(mt,mtrr7,startDate,endDate);
        prevController.AutomatedPbpMetric(mt,mtrr10,startDate,endDate);
        prevController.AutomatedTrainingMetric(mt,mtrr9,startDate,endDate);
        Test.stopTest();
        
    }
    
    public static testMethod void testPreviousPerformance15(){
        Date dt = date.newinstance(2011,2,12);
        Date dt1 = date.newinstance(2006,12,30);
        Date exDate = date.today().addDays(30);
        Date stDate = date.today().addDays(-60);
        Date edDate =date.today().addDays(90);
        
        Account acc = new Account(name='testSun1',BillingCity='New York',BillingCountry ='USA',BillingStreet='abc',BillingPostalCode='908',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1);
        insert acc;
        String accountId1 = acc.Id ;
        
        Performance_Metric__c p = new Performance_Metric__c(Country__c='USA',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Thea__c ='North America',channel__c='Residential',Performance_period_End_date__c=date.today().addDays(-60));
        insert p;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        
       
        Metric_Tier_Relation__c mtrr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage');
        insert mtrr8;
        
        
        Metric_Tier_Relation__c mtrr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Credit Limit SRI');
        insert mtrr9;
        
        Metric_Tier_Relation__c mtrr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training Attendance:  Associate Install');
        insert mtrr10;
        
        
        List<PerformanceEvalPreviousController.MetricsDetails> pmdlst = new list<PerformanceEvalPreviousController.MetricsDetails>();
        List<Metric__c> listAchievements = new List<Metric__c>();
        
        Metric__c mt = new Metric__c();
        mt.Account__c = acc.Id;
        mt.Metric_Tier_Relation__c = mtrr9.Id;
        mt.Boolean_Achievement__c = true;
        mt.Goal_Met__c = true;
        insert mt;
        
        
        
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('ACCOUNT_CHANNEL_NAME','Residential');
        ApexPages.currentPage().getParameters().put('activeTab','current');
        ApexPages.currentPage().getParameters().put('accId',accountId1);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();     
        
        prevController.AutomatedSPWRMetric(mt,mtrr8,stDate,edDate);
        prevController.AutomatedPbpMetric(mt,mtrr9,stDate,edDate);
        prevController.AutomatedTrainingMetric(mt,mtrr10,stDate,edDate);
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance16(){
        Date dt = date.newinstance(2011,2,12);
        Date dt1 = date.newinstance(2006,12,30);
        Date exDate = date.today().addDays(30);
        Date stDate = date.today().addDays(-60);
        Date edDate =date.today().addDays(90);
        
        Account acc = new Account(name='testSun1',BillingCity='New York',BillingCountry ='USA',BillingStreet='abc',BillingPostalCode='908',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1);
        insert acc;
        String accountId1 = acc.Id ;
        
        Performance_Metric__c p = new Performance_Metric__c(Country__c='USA',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Thea__c ='North America',channel__c='Residential',Performance_period_End_date__c=date.today().addDays(-60));
        insert p;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        
       
        Metric_Tier_Relation__c mtrr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Opportunity Close rate for SunPower Opportunities');
        insert mtrr8;
        
        
        Metric_Tier_Relation__c mtrr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='100 Installs');
        insert mtrr9;
        
        Metric_Tier_Relation__c mtrr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training Attendance:  Associate Sales');
        insert mtrr10;
        
        
        List<PerformanceEvalPreviousController.MetricsDetails> pmdlst = new list<PerformanceEvalPreviousController.MetricsDetails>();
        List<Metric__c> listAchievements = new List<Metric__c>();
        
        Metric__c mt = new Metric__c();
        mt.Account__c = acc.Id;
        mt.Metric_Tier_Relation__c = mtrr9.Id;
        mt.Boolean_Achievement__c = true;
        mt.Goal_Met__c = true;
        insert mt;
        
        
        
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('ACCOUNT_CHANNEL_NAME','Residential');
        ApexPages.currentPage().getParameters().put('activeTab','current');
        ApexPages.currentPage().getParameters().put('accId',accountId1);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();     
        
        prevController.AutomatedSPWRMetric(mt,mtrr8,stDate,edDate);
        prevController.AutomatedPbpMetric(mt,mtrr9,stDate,edDate);
        prevController.AutomatedTrainingMetric(mt,mtrr10,stDate,edDate);
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance17(){
        Date dt = date.newinstance(2011,2,12);
        Date dt1 = date.newinstance(2006,12,30);
        Date exDate = date.today().addDays(30);
        Date stDate = date.today().addDays(-60);
        Date edDate =date.today().addDays(90);
        
        Account acc = new Account(name='testSun1',BillingCity='New York',BillingCountry ='USA',BillingStreet='abc',BillingPostalCode='908',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1);
        insert acc;
        String accountId1 = acc.Id ;
        
        Performance_Metric__c p = new Performance_Metric__c(Country__c='USA',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Thea__c ='North America',channel__c='Residential',Performance_period_End_date__c=date.today().addDays(-60));
        insert p;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        
       
        Metric_Tier_Relation__c mtrr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Sunpower Residential Loan Program Signed');
        insert mtrr8;
        
        
        Metric_Tier_Relation__c mtrr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum experience (20 Installs Or 200 Kws)');
        insert mtrr9;
        
        Metric_Tier_Relation__c mtrr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training Attendance:  Advanced Design');
        insert mtrr10;
        
        
        List<PerformanceEvalPreviousController.MetricsDetails> pmdlst = new list<PerformanceEvalPreviousController.MetricsDetails>();
        List<Metric__c> listAchievements = new List<Metric__c>();
        
        Metric__c mt = new Metric__c();
        mt.Account__c = acc.Id;
        mt.Metric_Tier_Relation__c = mtrr9.Id;
        mt.Boolean_Achievement__c = true;
        mt.Goal_Met__c = true;
        insert mt;
        
        
        
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('ACCOUNT_CHANNEL_NAME','Residential');
        ApexPages.currentPage().getParameters().put('activeTab','current');
        ApexPages.currentPage().getParameters().put('accId',accountId1);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();     
        
        prevController.AutomatedSPWRMetric(mt,mtrr8,stDate,edDate);
        prevController.AutomatedPbpMetric(mt,mtrr9,stDate,edDate);
        prevController.AutomatedTrainingMetric(mt,mtrr10,stDate,edDate);
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance18(){
        
        Date exDate = date.newinstance(2011,5,1);
        Date startDate = date.newinstance(2011,1,1);
        Date endDate = date.newinstance(2011,12,30);
        
        Account acc = new Account(name='testSun1',BillingCity='New York',BillingCountry ='USA',BillingStreet='abc',BillingPostalCode='908',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=startDate,Promoted_Premier_Date__c=startDate);
        insert acc;
        String accountId1 = acc.Id ;
        
        Performance_Metric__c p = new Performance_Metric__c(Country__c='USA',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Thea__c ='North America',channel__c='Residential',Performance_period_End_date__c=date.today().addDays(-60),Performance_Evaluation_Cut_off_Date__c=date.today().addDays(15));
        insert p;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        
       
        Metric_Tier_Relation__c mtrr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Commercial sales include Inverter');
        insert mtrr8;
        
        
        Metric_Tier_Relation__c mtrr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='BGSM Scorecard');
        insert mtrr9;
        
        Metric_Tier_Relation__c mtrr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training Attendance:  Advanced Design');
        insert mtrr10;
        
        
        List<PerformanceEvalPreviousController.MetricsDetails> pmdlst = new list<PerformanceEvalPreviousController.MetricsDetails>();
        List<Metric__c> listAchievements = new List<Metric__c>();
        
        Metric__c mt = new Metric__c();
        mt.Account__c = acc.Id;
        mt.Metric_Tier_Relation__c = mtrr9.Id;
        mt.Boolean_Achievement__c = true;
        mt.Goal_Met__c = true;
        insert mt;
        
        
        
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPrevious);
        ApexPages.currentPage().getParameters().put('ACCOUNT_CHANNEL_NAME','Residential');
        ApexPages.currentPage().getParameters().put('activeTab','current');
        ApexPages.currentPage().getParameters().put('accId',accountId1);
        ApexPages.currentPage().getParameters().put('period','1');
        ApexPages.currentPage().getParameters().put('year','2010');
        
        PerformanceEvalPreviousController prevController = new PerformanceEvalPreviousController();     
        
        prevController.AutomatedSPWRMetric(mt,mtrr8,startDate,endDate);
        prevController.AutomatedPbpMetric(mt,mtrr9,startDate,endDate);
        prevController.AutomatedTrainingMetric(mt,mtrr10,startDate,endDate);
        Test.stopTest();
    }
}