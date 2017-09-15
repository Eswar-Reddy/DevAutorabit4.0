@IsTest
public class TestIncentiveCompositePrevious {
    
    public static testMethod void testIcomCls(){
        incentiveCompositePrevious pc = new incentiveCompositePrevious();
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
        
        list<incentivePrevious.MetricsDetails> pmdlst = new list<incentivePrevious.MetricsDetails>();
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
            incentivePrevious.MetricsDetails pmd = new incentivePrevious.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            system.debug('list** size'+pmd);
            pmdlst.clear();
            pmdlst.add(pmd);
            incentiveCompositePrevious.checkMarketUSAGoalMet(pmdlst);
            incentiveCompositePrevious.checkSPWRGoalMet1(pmdlst);
            incentiveCompositePrevious.checkSPWRGoalMet2(pmdlst);
            incentiveCompositePrevious.updateCompositeMetricForMarket(pmdlst);
            incentiveCompositePrevious.updateCompositeMetricForSPWR(pmdlst);
            incentiveCompositePrevious.checkPbpGoalMet1(pmdlst);
            incentiveCompositePrevious.updateCompositeMetricForPbp(pmdlst);
        }
        
        
        
        system.debug('list size'+pmdlst.size());
        system.debug('list detail'+pmdlst);
        incentiveCompositePrevious.addCompositeMetricForMarket(mtrl,pmdlst,dt,p.Id,accountId1);
        
        list<incentivePrevious.MetricsDetails> pmdlst1 = new list<incentivePrevious.MetricsDetails>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=true);
            insert mObj;
            incentivePrevious.MetricsDetails pmd = new incentivePrevious.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            pmdlst1.add(pmd);
        }
        incentiveCompositePrevious.checkMarketEUGoalMet(pmdlst1,'SIX');
        incentiveCompositePrevious.checkMarketEUGoalMet(pmdlst1,'SEVEN');
        incentiveCompositePrevious.checkMarketEUGoalMet(pmdlst1,'THREE');
        incentiveCompositePrevious.checkMarketEUGoalMet(pmdlst1,'FOUR');
        incentiveCompositePrevious.checkMarketEUGoalMet(pmdlst1,'two');
        
        
        incentiveCompositePrevious.addCompositeMetricForSPWR(mtrls,pmdlst,dt,p.Id,accountId1);
         incentiveCompositePrevious.addCompositeMetricForPbp(mtrls,pmdlst,dt,p.Id,accountId1);
    }
    
    
    public static testMethod void testIcomCls2(){
        incentiveCompositePrevious pc = new incentiveCompositePrevious();
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
        
       
        
        
        list<incentivePrevious.MetricsDetails> pmdlst = new list<incentivePrevious.MetricsDetails>();
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
            incentivePrevious.MetricsDetails pmd = new incentivePrevious.MetricsDetails();
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
        incentiveCompositePrevious.addCompositeMetricForMarket(mtrl3,pmdlst,dt,p.Id,accountId1);
        
        list<incentivePrevious.MetricsDetails> pmdlst1 = new list<incentivePrevious.MetricsDetails>();
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=true);
            insert mObj;
            incentivePrevious.MetricsDetails pmd = new incentivePrevious.MetricsDetails();
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
        incentiveCompositePrevious.addCompositeMetricForSPWR(mtrl3,pmdlst,dt,p.Id,accountId1);
        incentiveCompositePrevious.addCompositeMetricForPbp(mtrl3,pmdlst,dt,p.Id,accountId1);
    }
    

}