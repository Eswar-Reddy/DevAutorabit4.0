@IsTest
public class TestPerformanceEvaluationPrevious {
    
    
     // method to test all the getter methods.
     public static testMethod void tstMethodEval(){
        PerformanceEvaluationPrevious pEvalObjN = new PerformanceEvaluationPrevious() ;
        pEvalObjN.getall_spwr_solutions_Current();
        pEvalObjN.getall_spwr_solutions_Next();
        pEvalObjN.getcustomer_Satisfaction_Next();
        pEvalObjN.getperformance_to_business_Plan_Next();
        pEvalObjN.gettraining_Next();
        pEvalObjN.getmarketing_Next();
        String partnerTier = pEvalObjN.getpartnerTier();
        String AccountName = pEvalObjN.getAccountName();
        String PartnerType = pEvalObjN.getPartnerType();
        String ValidEvalFromDate = pEvalObjN.getValidEvalFromDate();
        String ValidEvalToDate = pEvalObjN.getValidEvalToDate();
        String TierStartDate = pEvalObjN.getTierStartDate();
        Boolean ExecutiveManager = pEvalObjN.getisExecutiveManager();
        String AccTheatre = pEvalObjN.getAccTheatre();
     }
    // method to test metric for USA Premier metric 
    public static testMethod void testPfEvalUSAPremier(){ 
    try{
        List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
        List<Metric_Tier_Relation__c> upmtrlis = new List<Metric_Tier_Relation__c>();
        List<Metric__c> mlist = new List<Metric__c>();
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c();
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        String accountId = '';
        Double x=1.75;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt4 = date.newinstance(2010,7,4);
        Date dt5 = date.newinstance(2009,12,1);
        Date dt6 = date.newinstance(2010,7,31);
        Date dt7 = date.newinstance(2010,1,4);
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
        //    delete pmObjx ;
        }
        
        Test.startTest();
        Account acc = new Account(name='testSun1',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt6 );
        insert p;
        Test.stopTest();
        
        List<Tier__c>tObjx = [Select Id from Tier__c];
        if(tObjx.size()>0){
           // delete tObjx ;
        }
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier');
        insert t1;  
        Tier__c t2 = new Tier__c(Country__c='USA',Tier_Name__c='Elite');
        insert t2; 
        PDF_Limit__c pdflmt = new PDF_Limit__c(Partner__c=x,Performance_Metric__c=p.Id,Tier__c=t1.Id);//pmobj.get(0).id
        insert pdflmt;
        Metric_Tier_Relation__c mtrNxt = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t2.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Enter_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated');
        insert mtrNxt;
        Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual');
        insert mtr1;
        upmtrlist.add(mtr1);
        Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Residential Installation Inspections',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =2,Metric_Input_Type__c='Manual');
        insert mtr2;
        upmtrlist.add(mtr2);
        Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Customer Complaints',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =3,Metric_Input_Type__c='Manual');
        insert mtr3;
        upmtrlist.add(mtr3);
        Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower installations Registered',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =4,Metric_Input_Type__c='Manual');
        insert mtr4;
        upmtrlist.add(mtr4);
        Metric_Tier_Relation__c mtr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Warranty card received NA',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =5,Metric_Input_Type__c='Manual');
        insert mtr5;
        upmtrlist.add(mtr5);
        Metric_Tier_Relation__c mtr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training: Associate Design Certification',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =5,Metric_Input_Type__c='Manual');
        insert mtr6;
        upmtrlist.add(mtr6);
        Metric_Tier_Relation__c mtr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Must be an Active Dealer',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =5,Metric_Input_Type__c='Manual');
        insert mtr7;
        upmtrlist.add(mtr7);
        Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =5,Metric_Input_Type__c='Manual');
        insert mtr8;
        upmtrlist.add(mtr8);
        Metric_Tier_Relation__c mtr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Opportunity Referral Program',Category__c='Marketing',Stay_Tier__c=true,Sequence_Order__c =5,Metric_Input_Type__c='Manual');
        insert mtr9;
        upmtrlist.add(mtr9);
        
        
       
        ApexPages.StandardController aps = new ApexPages.StandardController(mtr);
        PerformanceEvaluationPrevious pEvalObj = new PerformanceEvaluationPrevious(aps) ;
        PerformanceEvaluationPrevious pEvalObj1 = new PerformanceEvaluationPrevious() ;
        System.assertEquals(true, PEvalObj1.getDisableEditButton());
        System.assertEquals(false, PEvalObj1.getPartnerExecutive());
        PEvalObj1.setDisableButton(false);
        
        System.assertEquals(false,PEvalObj1.getDisableButton());//system.debug('R0'+PEvalObj1.getDisableButton());
        System.assertEquals(null,PEvalObj1.getperformanceMetricID());
        System.assertEquals(null,PEvalObj1.getparamStartDate());
        System.assertEquals(null,PEvalObj1.getparamEndDate());
        System.assertEquals(null,PEvalObj1.getparamExpDate());
        System.assertEquals(null,PEvalObj1.getaccountId());
        System.assertEquals(null,PEvalObj1.getvalidExpToDate());
        
        system.debug('customer_Satisfaction_Current'+PEvalObj1.getcustomer_Satisfaction_Current());
        system.debug('performance_to_business_Plan_Current'+PEvalObj1.getperformance_to_business_Plan_Current());
        system.debug('training_Current'+PEvalObj1.gettraining_Current());
        system.debug('training_Current_Clone'+PEvalObj1.gettraining_Current_Clone());
        system.debug('marketing_Current'+PEvalObj1.getmarketing_Current());
     
        PEvalObj1.accountId =acc.Id ;
        PEvalObj1.retriveAccountInfo();
        system.debug('teaq'+PEvalObj1.country_full_name);
        pEvalObj1.saveTotalIncentive(t1.Id);
        
        for(Metric_Tier_Relation__c mt:upmtrlist){
            mt.Metric_Input_Type__c='Automated';
            upmtrlis.add(mt);
        }
        Update upmtrlis;
        PEvalObj1.retriveAccountInfo();
        
        upmtrlis.clear();
        for(Metric_Tier_Relation__c mt:upmtrlist){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.Id,CurrencyIsoCode = 'USD');//pmObj.get(0).Id
            mlist.add(mObj);
        }
        insert mlist;
        PEvalObj1.retriveAccountInfo();
        
        for(Metric_Tier_Relation__c m:upmtrlist){
            m.Part_Of_Composite_Incentive__c = true;
            upmtrlis.add(m);
        }
        Update upmtrlis;
        PEvalObj1.retriveAccountInfo();
        }catch(Exception ex){
        }
    }
    
    public static testMethod void testPfEvalUSAElite(){
    try{
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
         //   delete pmObjx ;
        }
        List<Tier__c>tObjx = [Select Id from Tier__c];
        if(tObjx.size()>0){
         //   delete tObjx ;
        }
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c();
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        String accountId = '';
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Account acc = new Account(name='testSun1',type = 'Elite-Partner-Residential',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;
        ApexPages.StandardController aps = new ApexPages.StandardController(mtr);
        PerformanceEvaluationPrevious pEvalObj = new PerformanceEvaluationPrevious(aps) ;
        PerformanceEvaluationPrevious pEvalObj1 = new PerformanceEvaluationPrevious() ;
        PEvalObj1.setDisableButton(false);
        System.assertEquals(false,PEvalObj1.getShowNextTab()); 
        System.assertEquals(true,pEvalObj1.getHideHeaderForPartner()); 
        PEvalObj1.accountId =acc.Id ;
        PEvalObj1.retriveAccountInfo();
        }catch(Exception ex)
        {
        }
   }
    
    public static testMethod void testPfEvalGermanyPremier(){
    try{
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
         //   delete pmObjx ;
        }
        List<Tier__c>tObjx = [Select Id from Tier__c];
        if(tObjx.size()>0){
          //  delete tObjx ;
        }
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c();
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        String accountId = '';
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Account acc = new Account(name='testSun1',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-de',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;
        ApexPages.StandardController aps = new ApexPages.StandardController(mtr);
        PerformanceEvaluationPrevious pEvalObj = new PerformanceEvaluationPrevious(aps) ;
        PerformanceEvaluationPrevious pEvalObj1 = new PerformanceEvaluationPrevious() ;
        PEvalObj1.accountId =acc.Id ;
        PEvalObj1.retriveAccountInfo();   
        }catch(Exception ex){
        }
    }
    public static testMethod void testPfEvalItalyPremier(){
    try{
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
         //   delete pmObjx ;
        }
        List<Tier__c>tObjx = [Select Id from Tier__c];
        if(tObjx.size()>0){
         //   delete tObjx ;
        }
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        String accountId = '';
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c();
        Account acc = new Account(name='testSun1',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;
        ApexPages.StandardController aps = new ApexPages.StandardController(mtr);
        PerformanceEvaluationPrevious pEvalObj = new PerformanceEvaluationPrevious(aps) ;
        PerformanceEvaluationPrevious pEvalObj1 = new PerformanceEvaluationPrevious() ;
        PEvalObj1.setDisableButton(false);
        PEvalObj1.accountId =acc.Id ;
        PEvalObj1.retriveAccountInfo();
        PageReference pgObj = pEvalObj1.updateEvaluation();
        }catch(Exception ex){
        }
    }

    public static testMethod void testPfEvalItalyAuthorized(){
    try{
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
         //   delete pmObjx ;
        }
        List<Tier__c>tObjx = [Select Id from Tier__c];
        if(tObjx.size()>0){
         //   delete tObjx ;
        }
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        String accountId = '';
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c();
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Account acc = new Account(name='testSun1',type = 'Authorized-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;ApexPages.StandardController aps = new ApexPages.StandardController(mtr);
        PerformanceEvaluationPrevious pEvalObj = new PerformanceEvaluationPrevious(aps) ;
        PerformanceEvaluationPrevious pEvalObj1 = new PerformanceEvaluationPrevious() ;
        PEvalObj1.setDisableButton(false);
        PEvalObj1.accountId =acc.Id ;
        PEvalObj1.retriveAccountInfo();
        }catch(Exception ex){
        
        }
    }


   public static testMethod void testPfEvalItalyResidential(){
   try{
    List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
           // delete pmObjx ;
        }
        List<Tier__c>tObjx = [Select Id from Tier__c];
        if(tObjx.size()>0){
           // delete tObjx ;
        }        
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        String accountId = '';
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c();
        Double x=1.75;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt4 = date.newinstance(2010,7,4);
        Date dt5 = date.newinstance(2009,12,1);
        Date dt6 = date.newinstance(2010,7,31);
        Date dt7 = date.newinstance(2010,1,4);
        
        Account acc = new Account(name='testSun1',type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='SRI' );
        insert t1;
        ApexPages.StandardController aps = new ApexPages.StandardController(mtr);PerformanceEvaluationPrevious pEvalObj = new PerformanceEvaluationPrevious(aps) ;
        PerformanceEvaluationPrevious pEvalObj1 = new PerformanceEvaluationPrevious() ;
        PEvalObj1.setDisableButton(false);
        PEvalObj1.accountId =acc.Id ;
        PEvalObj1.retriveAccountInfo();
        }catch(Exception ex){
        }
    }
    
    public static testMethod void testPfEvalItalyResidential1(){
    try{
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
            //delete pmObjx ;
        }
        List<Tier__c>tObjx = [Select Id from Tier__c];
        if(tObjx.size()>0){
            //delete tObjx ;
        }       
        Metric_Tier_Relation__c mtr0 = new Metric_Tier_Relation__c();
        
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        String accountId = '';
        Double x=1.75;
        Profile p = [select id from profile where name='EU Partner Operations'];
        list<User> u =[select Id from User where profileid =:p.id and isActive=true];
        if (u.size() > 0)
        System.runAs(u[0]) {
            Date dt = date.newinstance(2006,1,1);
            Date dt1 = date.newinstance(2006,12,30);
            Date dt4 = date.newinstance(2010,7,4);
            Date dt5 = date.newinstance(2009,12,1);
            Date dt6 = date.newinstance(2010,7,31);
            Date dt7 = date.newinstance(2010,1,4);
            Account acc = new Account(name='testSun1',type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
            insert acc;
            ApexPages.StandardController aps = new ApexPages.StandardController(mtr0);
            PerformanceEvaluationPrevious pEvalObj = new PerformanceEvaluationPrevious(aps) ;
            PerformanceEvaluationPrevious pEvalObj1 = new PerformanceEvaluationPrevious() ;
            PEvalObj1.setDisableButton(false);
            system.debug('r12'+pEvalObj1.getHideHeaderForPartner());
            system.debug('getDisableEditButton()'+pEvalObj1.getDisableEditButton());
            PEvalObj1.accountId =acc.Id ;
            PEvalObj1.retriveAccountInfo();
                   
          
            
                        
        }
        }catch(Exception ex){
        }

    }
    
    public static testMethod void testPEval(){
    try{
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
            //delete pmObjx ;
        }
        PerformanceEvaluationPrevious pEc = new PerformanceEvaluationPrevious() ;
        list<PerformanceEvaluationPrevious.MetricsDetails> pmdlst = new list<PerformanceEvaluationPrevious.MetricsDetails>();
        list<Metric_Tier_Relation__c> mtrls = new list<Metric_Tier_Relation__c>();
        list<Metric_Tier_Relation__c> mtrl = new list<Metric_Tier_Relation__c>();
        list<Id> mid = new list<Id>();
        
        Date dt = date.newinstance(2011,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Account acc = new Account(name='testSun1',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;
        String accountId1 = acc.Id ;
        Performance_Metric__c p = new Performance_Metric__c(Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA');
        insert p;
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Basic Product training');
        insert mtr;
        mtrl.add(mtr);Metric_Tier_Relation__c mtrr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Design Certification');
        insert mtrr1;
        mtrls.add(mtrr1);
        Metric_Tier_Relation__c mtrr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Installation Certification');
        insert mtrr2;
        mtrls.add(mtrr2);
        Metric_Tier_Relation__c mtrr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Sales Certification');
        insert mtrr3;
        mtrls.add(mtrr3);
        Metric_Tier_Relation__c mtrr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Co-branded sales and installation apparel');
        insert mtrr4;
        mtrls.add(mtrr4);
        for(Metric_Tier_Relation__c mt:mtrls){
            Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false);
            insert mObj;
            PerformanceEvaluationPrevious.MetricsDetails pmd = new PerformanceEvaluationPrevious.MetricsDetails();
            pmd.meetricTierRel = mt;
            pmd.metric =mObj;
            pmd.getmeetricTierRel();
            pmd.getMetric();
            pmdlst.clear();
            pmdlst.add(pmd);
            pEc.checkTrainingGoalMet(pmdlst);
            pEc.getSPWRCurrentFlag();
            pEc.getSPWRNextFlag();
            pEc.enableInputFields();
            pEc.getShowLink();
        }
        
        pEc.addCompositeMetricForTrn(mtrl,pmdlst,dt,p.Id);
        for(Metric_Tier_Relation__c mt:mtrl){
            Metric__c mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mt.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
            insert mObj1;
            mid.add(mt.Id);
        }
        list<Metric_Tier_Relation__c> mtrl2 = [select Metric_Label__c,Id,(select Id,Overriden__c from Metrics__r)from Metric_Tier_Relation__c where Id In :mid];
        pEc.addCompositeMetricForTrn(mtrl2,pmdlst,dt,p.Id);
        }catch(Exception ex){
        }
     }
     
     public static testMethod void testPEvalMethod(){
     try{
        List<Performance_Metric__c> pmObjx = [Select Id from Performance_Metric__c];
        if(pmObjx.size()>0){
           // delete pmObjx ;
        }
        List<Metric_Tier_Relation__c> mtrList = new List<Metric_Tier_Relation__c>();
        PerformanceEvaluationPrevious pEc = new PerformanceEvaluationPrevious() ;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,11,1);
        
        Account acc = new Account(name='testSun1',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;
        pEc.accountId  = acc.Id ;
        Performance_Metric__c p = new Performance_Metric__c(Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA');
        insert p;
        Id p1 = p.Id;
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage',Category__c='All SPWR solutions',Metric_Input_Type__c='Automated',Part_Of_Composite_Incentive__c= true);
        insert mtr;
        Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj;
        Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Opportunity Close rate for SunPower Opportunities',Category__c='All SPWR solutions',Metric_Input_Type__c='Automated');
        insert mtr1;
        Metric__c mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr1.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj1;
        Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems',Category__c='All SPWR solutions',Metric_Input_Type__c='Automated');
        insert mtr2;
        Metric__c mObj2 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr2.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj2;
        Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Commercial sales include Inverter',Category__c='All SPWR solutions',Metric_Input_Type__c='Automated');
        insert mtr3;
        Metric__c mObj3 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr3.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj3;
        Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Credit Limit SRI');
        insert mtr4;
        Metric__c mObj4 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr4.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj4;
        Metric_Tier_Relation__c mtr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Kw agreed target');
        insert mtr5;
        Metric__c mObj5 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr5.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj5;
        Metric_Tier_Relation__c mtr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Basic training');
        insert mtr6;
        Metric__c mObj6 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr6.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj6;
        Metric_Tier_Relation__c mtr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Fundamental Design and Installation');
        insert mtr7;
        Metric__c mObj7 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr7.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj7;
        Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Advanced design and Installation');
        insert mtr8;
        Metric__c mObj8 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr7.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj8;
        Metric_Tier_Relation__c mtr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Advanced Product Training');
        insert mtr9;
        Metric__c mObj9 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr7.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj9;
        Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Good Credit',Metric_Input_Type__c='Automated');
        insert mtr10;
        Metric__c mObj10 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr10.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj10;
        
        mtrList.add(mtr);
        mtrList.add(mtr1);
        mtrList.add(mtr2);
        mtrList.add(mtr3);
        
        pEc.populateCategoriesForTiers(mtrList,p1,dt2,dt,dt1,'Current');
        pEc.AutomatedSPWRMetric(mObj,mtr,dt,dt1); 
        pEc.AutomatedSPWRMetric(mObj1,mtr1,dt,dt1);
        pEc.AutomatedSPWRMetric(mObj2,mtr2,dt,dt1);
        pEc.AutomatedSPWRMetric(mObj3,mtr3,dt,dt1);
        pEc.AutomatedPbpMetric(mObj4,mtr4,dt,dt1);
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
        pEc.AutomatedPbpMetric(mObj5,mtr5,dt,dt1);
        pEc.AutomatedTrainingMetric(mObj6,mtr6,dt,dt1);
        pEc.AutomatedTrainingMetric(mObj7,mtr7,dt,dt1);
        pEc.AutomatedTrainingMetric(mObj8,mtr8,dt,dt1);
        pEc.AutomatedTrainingMetric(mObj9,mtr9,dt,dt1);
        
        // change labels
        mtr10.Metric_Label__c =PerformanceEvalCst.CREDIT_LIMIT;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.CREDIT_LIMIT_EU;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.CREDIT_LIMIT_SRI;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.SIX_MONTHS_AS_AUTH;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.TWENTY_INSTALLS_AS_AUTH;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.SIX_MONTHS_AS_PREM;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.HUNDRED_INSTALLS_AS_PREM;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.MIN_EXP_TWENTY_INSTALLS_EU;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.RETROFIT_SOLAR_SYS;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.BGSM_SCORECARD_EU;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.MIN_QUAT_SALES_EU;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.MIN_QUAT_SALES_EU_CLONE;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.MIN_SALES_AUTHZ_EU;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.KW_TARGET_EU;
        pEc.AutomatedPbpMetric(mObj10,mtr10,dt,dt1);
        
         mtr10.Metric_Label__c =PerformanceEvalCst.TRAINING_ASS_DESIGN;
        pEc.AutomatedTrainingMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.TRAINING_ASS_INSTALL;
        pEc.AutomatedTrainingMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.TRAINING_ASS_SALES;
        pEc.AutomatedTrainingMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.TRAINING_ADV_DESIGN;
        pEc.AutomatedTrainingMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.TRAINING_ADV_INSTALL;
        pEc.AutomatedTrainingMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.TRAINING_ADV_SALES;
        pEc.AutomatedTrainingMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.TRAINING_EXTRA_BONUS_I;
        pEc.AutomatedTrainingMetric(mObj10,mtr10,dt,dt1);
         mtr10.Metric_Label__c =PerformanceEvalCst.TRAINING_EXTRA_BONUS_II;
        pEc.AutomatedTrainingMetric(mObj10,mtr10,dt,dt1);
        
        List<Metric_Tier_Relation__c> lstMTR = new List<Metric_Tier_Relation__c>();

         dt2 = date.today()+1;
         mtr10.Metric_Label__c =PerformanceEvalCst.CSAT_SCORE_EU;
         mtr10.Category__c='Customer Satisfaction';
          mtr10.Part_Of_Composite_Incentive__c= true;
         lstMTR.add(mtr10);
         pEc.populateCategoriesForTiers(lstMTR,p.Id,dt2,dt,dt1,'Current');
        
         mtr10.Metric_Label__c =PerformanceEvalCst.CSAT_SURVEY_REQ;
          mtr10.Category__c='Customer Satisfaction';
         lstMTR.clear();
         lstMTR.add(mtr10);
         pEc.populateCategoriesForTiers(lstMTR,p.Id,dt2,dt,dt1,'Current');
         
         mtr10.Metric_Label__c =PerformanceEvalCst.SITE_INSPECTION;
         mtr10.Category__c='Customer Satisfaction';
         lstMTR.clear();
         lstMTR.add(mtr10);
         pEc.populateCategoriesForTiers(lstMTR,p.Id,dt2,dt,dt1,'Next');
         
         mtr10.Metric_Label__c =PerformanceEvalCst.SITE_INSPECTION_EU;
          mtr10.Category__c='Customer Satisfaction';
         lstMTR.clear();
         lstMTR.add(mtr10);
         pEc.populateCategoriesForTiers(lstMTR,p.Id,dt2,dt,dt1,'Current');
         
         mtr10.Metric_Label__c =PerformanceEvalCst.SITE_INSPECTION_EU;
         mtr10.Category__c='Customer Satisfaction';
         lstMTR.clear();
         lstMTR.add(mtr10);
         pEc.populateCategoriesForTiers(lstMTR,p.Id,dt2,dt,dt1,'Next');
         
         mtr10.Metric_Label__c =PerformanceEvalCst.SITE_INSPECTION_NON_COMP;
         mtr10.Category__c='Customer Satisfaction';
         lstMTR.clear();
         lstMTR.add(mtr10);
         pEc.populateCategoriesForTiers(lstMTR,p.Id,dt2,dt,dt1,'Current');
        
         mtr10.Metric_Label__c =PerformanceEvalCst.WARRANTY_CARDS_EU;
         mtr10.Category__c='Customer Satisfaction' ;
         lstMTR.clear();
         lstMTR.add(mtr10);
         pEc.populateCategoriesForTiers(lstMTR,p.Id,dt2,dt,dt1,'Next');

         mtr10.Metric_Label__c =PerformanceEvalCst.WARRANTY_CARDS_NA;
         mtr10.Category__c='Customer Satisfaction';
         lstMTR.clear();
         lstMTR.add(mtr10);
         pEc.populateCategoriesForTiers(lstMTR,p.Id,dt2,dt,dt1,'Current');
        
        }catch(Exception ex){
        }
        
     }



   //test coverage for updateEvaluation method
     public static testmethod void testUpdateEvaluation(){
        
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.today()+1;
        
        Account acc = new Account(name='testSun1',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',ShippingCity='New York',ShippingCountry ='abc',ShippingStreet='abc',ShippingPostalCode='908');
        insert acc;
        
        //pEc.accountId  = acc.Id ;
        
        Performance_Metric__c p = new Performance_Metric__c(Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA');
        insert p;
        
        Id p1 = p.Id;
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
        insert t1;
        
        Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Good Credit',Metric_Input_Type__c='Automated');
        insert mtr10;
        Metric__c mObj10 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr10.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Incentive_Amount__c = 10,Boolean_Achievement__c=false,Overriden__c=false);
        insert mObj10;
        
        PerformanceEvaluationPrevious pEc = new PerformanceEvaluationPrevious() ;
         
        List<Metric_Tier_Relation__c> lstMTR = new List<Metric_Tier_Relation__c>();
        
       
        
        ApexPages.currentPage().getParameters().put('clksave',null);
        List<PerformanceEvaluationPrevious.MetricsDetails> lstMtrxDetail = new List<PerformanceEvaluationPrevious.MetricsDetails>();
        PerformanceEvaluationPrevious.MetricsDetails md1 = new PerformanceEvaluationPrevious.MetricsDetails();
        md1.meetricTierRel =mtr10;
        md1.metric =mObj10 ;
        
        lstMtrxDetail.add(md1);
        pEc.customer_Satisfaction_Current =lstMtrxDetail ;
        lstMtrxDetail.clear();
        lstMtrxDetail.add(md1);
        pEc.customer_Satisfaction_Next =lstMtrxDetail;
        pEc.updateEvaluation();
        
        
        lstMtrxDetail.clear();
        md1.meetricTierRel.Boolean_Metric_Y_N__c=true;
        lstMtrxDetail.add(md1);
        pEc.customer_Satisfaction_Current =lstMtrxDetail ;
        lstMtrxDetail.clear();
        md1.meetricTierRel.Boolean_Metric_Y_N__c=true;
        lstMtrxDetail.add(md1);
        pEc.customer_Satisfaction_Next =lstMtrxDetail;
        pEc.updateEvaluation();

        lstMtrxDetail.clear();
        md1.meetricTierRel.Metric_Max_Value__c=1;
        lstMtrxDetail.add(md1);
        pEc.customer_Satisfaction_Current =lstMtrxDetail ;
        lstMtrxDetail.clear();
        md1.meetricTierRel.Metric_Max_Value__c=1;
        lstMtrxDetail.add(md1);
        pEc.customer_Satisfaction_Next =lstMtrxDetail;
        pEc.updateEvaluation();

        
        lstMtrxDetail.clear();
        md1.meetricTierRel.Metric_Label__c =PerformanceEvalCst.MEET_SIX_MARKET ;
        lstMtrxDetail.add(md1);
        pEc.marketing_Next = lstMtrxDetail ;
        pEc.updateEvaluation();

        lstMtrxDetail.clear();
        md1.meetricTierRel.Metric_Label__c =PerformanceEvalCst.THREE_MARKET_EU ;
        lstMtrxDetail.add(md1);
        pEc.marketing_Next = lstMtrxDetail ;
        pEc.updateEvaluation();

        lstMtrxDetail.clear();
        md1.meetricTierRel.Metric_Label__c =PerformanceEvalCst.FOUR_MARKET_EU ;
        lstMtrxDetail.add(md1);
        pEc.marketing_Next = lstMtrxDetail ;
        pEc.updateEvaluation();

        lstMtrxDetail.clear();
        md1.meetricTierRel.Metric_Label__c =PerformanceEvalCst.SIX_MARKET_EU;
        lstMtrxDetail.add(md1);
        pEc.marketing_Next = lstMtrxDetail ;
        pEc.updateEvaluation();

        lstMtrxDetail.clear();
        md1.meetricTierRel.Metric_Label__c =PerformanceEvalCst.SEVEN_MARKET_EU;
        lstMtrxDetail.add(md1);
        pEc.marketing_Next = lstMtrxDetail ;
        pEc.updateEvaluation();

     }
     
     
     
    
        /***End***/
    

    

}