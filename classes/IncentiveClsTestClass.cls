@isTest
public class IncentiveClsTestClass{
    
    static List<Performance_Metric__c> pmObjx;
    static List<Tier__c> tObjx;
    static
    {
        pmObjx = new List<Performance_Metric__c>();
        tObjx = new List<Tier__c>();
        pmObjx = [Select Id from Performance_Metric__c];
        tObjx = [Select Id from Tier__c];
        
    }
    
    

    public static testMethod void testIncentCls(){
    try{
        List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt4 = date.newinstance(2010,7,4);
        Date dt5 = date.newinstance(2009,12,1);
        Date dt6 = date.newinstance(2010,7,31);
        Date dt7 = date.newinstance(2010,1,4);
        
        if(pmObjx.size()>0){
            //delete pmObjx ;
        }
        
        if(tObjx.size()>0){
            //delete tObjx ;
        }
         
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt6 );
        insert p;
        //list<Performance_Metric__c> pmobj = [select Id from Performance_Metric__c where Country__c = 'USA' and Thea__c = 'North America'];
        Account acc = new Account(name='testResh2',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        
        String accountId1 = acc.Id ;
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier');
        insert t1;  
        //Tier__c tObj = [select Id,Tier_Name__c,Country__c from Tier__c where Tier_Name__c='Premier' and Country__c='USA'];
        Double x=1.75;
        PDF_Limit__c pdflmt = new PDF_Limit__c(Partner__c=x,Performance_Metric__c=p.id,Tier__c=t1.Id);
        insert pdflmt;
        Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        ////1;
        upmtrlist.add(mtr1);
        Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - No. certified for Adv. Design ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        ////2;
        upmtrlist.add(mtr2);
        Metric_Tier_Relation__c mtr31 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Meeting 6 Month Revenue Target ',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        ////31;
        upmtrlist.add(mtr31);
        Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage ',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        ////4;
        upmtrlist.add(mtr4);
        Metric_Tier_Relation__c mtr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Dealer Webpage and Logo Usage ',Category__c='Marketing',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        ////5;
        upmtrlist.add(mtr5);
        
        ApexPages.currentPage().getParameters().put('accId',accountId1 );
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        incentiveCls inc = new incentiveCls();
        incentiveCls inc1 = new incentiveCls(acc.Id);
        Metric_Tier_Relation__c mtr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Customer Complaints ',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////6;
        upmtrlist.add(mtr6);
        Metric_Tier_Relation__c mtr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower installations Registered ',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////7;
        upmtrlist.add(mtr7);
        Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Residential Installation Inspections ',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////8;
        upmtrlist.add(mtr8);
        Metric_Tier_Relation__c mtr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Opportunity Close rate for SunPower Opportunities ',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////9;
        upmtrlist.add(mtr9);
        Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems ',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////10;
        upmtrlist.add(mtr10);
        Metric_Tier_Relation__c mtr11 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Commercial sales include Inverter ',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////11;
        upmtrlist.add(mtr11);
        
        Metric_Tier_Relation__c mtr12 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Must be an Active Dealer ',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////12;
        upmtrlist.add(mtr12);
        Metric_Tier_Relation__c mtr13 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Good Credit ',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////13;
        upmtrlist.add(mtr13);
        Metric_Tier_Relation__c mtr14 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum Premier credit or bank guarantee ',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////14;
        upmtrlist.add(mtr14);
        Metric_Tier_Relation__c mtr15 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='6 months as Authorized ',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////15;
        upmtrlist.add(mtr15);
        Metric_Tier_Relation__c mtr16 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='20 Installs',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////16;
        upmtrlist.add(mtr16);
        Metric_Tier_Relation__c mtr17 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='6 months as Premier',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////17;
        upmtrlist.add(mtr17);
        Metric_Tier_Relation__c mtr18 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='100 Installs',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////18;
        upmtrlist.add(mtr18);
        Metric_Tier_Relation__c mtr19 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum experience (6 months as Authorized)',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////19;
        upmtrlist.add(mtr19);
        Metric_Tier_Relation__c mtr20 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Residential Retrofit Experience',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////20;
        upmtrlist.add(mtr20);
        Metric_Tier_Relation__c mtr21 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='BGSM Scorecard',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////21;
        upmtrlist.add(mtr21);
        Metric_Tier_Relation__c mtr22 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='20 Installs',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////22;
        upmtrlist.add(mtr22);               
        Metric_Tier_Relation__c mtr23 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c = PerformanceEvalCst.MARKET_SHOWROOM_DISPLAY_RVAR,Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////23;
        upmtrlist.add(mtr23);        
        Metric_Tier_Relation__c mtr24 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c = PerformanceEvalCst.MARKET_CO_BRANDED_ALL_VEHICLES_RVAR,Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        ////24;
        upmtrlist.add(mtr24);
        
        
        insert upmtrlist;
        Metric__c mObj1;
        List<Metric__c> lst_mObj1 = new List<Metric__c>();
        for(Metric_Tier_Relation__c mtr :upmtrlist){
            mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD');
            lst_mObj1.add(mObj1);
        }   
        insert lst_mObj1;       
       // incentiveCls incN = new incentiveCls();
        List<Metric_Tier_Relation__c> lst_mtr = new List<Metric_Tier_Relation__c>();        
        for(Metric_Tier_Relation__c mtr :upmtrlist){
            mtr.Metric_Input_Type__c = 'Automated';
            lst_mtr.add(mtr);
           
        }  
        Update lst_mtr;
        //incentiveCls incNew = new incentiveCls();        
      }
      catch(Exception ex){
          
      }  
      
      
    }
    
        public static testMethod void testIncentveCls(){
        try{
        List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt4 = date.newinstance(2010,7,4);
        Date dt5 = date.newinstance(2009,12,1);
        Date dt6 = date.newinstance(2010,7,31);
        Date dt7 = date.newinstance(2010,1,4);
        
        if(pmObjx.size()>0){
            //delete pmObjx ;
        }
        
        if(tObjx.size()>0){
          //  delete tObjx ;
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
        
        Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - percent of Sales People with Adv Training ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //8;
        upmtrlist.add(mtr8); 
        Metric_Tier_Relation__c mtr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Basic training ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //9;
        upmtrlist.add(mtr9);
        Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Fundamental Design and Installation ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //10;
        upmtrlist.add(mtr10);
        Metric_Tier_Relation__c mtr11 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Advanced design and Installation ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //11;
        upmtrlist.add(mtr11);
        
        Metric_Tier_Relation__c mtr12 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Advanced Product Training ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //12;
        upmtrlist.add(mtr12);
        Metric_Tier_Relation__c mtr13 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training: Advanced Sales Certification ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //13;
        upmtrlist.add(mtr13);
        Metric_Tier_Relation__c mtr14 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training: Advanced Installation Certification ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //14;
        upmtrlist.add(mtr14);
        Metric_Tier_Relation__c mtr15 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training: Advanced Design Certification ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //15;
        upmtrlist.add(mtr15);
        Metric_Tier_Relation__c mtr16 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Sales Certification',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //16;
        upmtrlist.add(mtr16);
        Metric_Tier_Relation__c mtr22 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Installation Certification',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //22;
        upmtrlist.add(mtr22);
        Metric_Tier_Relation__c mtr17 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Training:  Associate Design Certification',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //17;
        upmtrlist.add(mtr17);
        
        Metric_Tier_Relation__c mtr18 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Kw agreed target',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //18;
        upmtrlist.add(mtr18);
        Metric_Tier_Relation__c mtr19 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum sales and experience (SRI to Authorized)',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //19;
        upmtrlist.add(mtr19);
        Metric_Tier_Relation__c mtr20 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum quarterly sales',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //20;
        upmtrlist.add(mtr20);
        Metric_Tier_Relation__c mtr21 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum quarterly sales as SRI',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //21;
        upmtrlist.add(mtr21);
        insert upmtrlist;
        
        ApexPages.currentPage().getParameters().put('accId',accountId1 );
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
         Double a= 40,b=40,c=10;
       order_detail_sunrise2__c od = new order_detail_sunrise2__c(QTD_Net_Purchase_Amount__c=a,Quarter_Net_Purchase_Amount__c=b,Account_Name__c=acc.Id,Performance_Period__c ='P1',year__c='2010',Oracle_Customer_No__c='140x',Quarter__c='Q2');
       
    
       insert od;
        incentiveCls incN = new incentiveCls();
        
        Metric__c mObj1;
        List<Metric__c> lst_mObj1 = new List<Metric__c>();
        for(Metric_Tier_Relation__c mtr :upmtrlist){
             mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Goal_Met__c= TRUE);
            lst_mObj1.add(mObj1);
        }      
        insert lst_mObj1;
        
        List<Metric_Tier_Relation__c> lst_mtr = new List<Metric_Tier_Relation__c>();
        for(Metric_Tier_Relation__c mtr :upmtrlist){
            mtr.Metric_Input_Type__c = 'Automated'; 
            lst_mtr.add(mtr);
            
        }
        
        Update lst_mtr;
      
       

       Quarterly_Performance_Evaluation__c qpe = new Quarterly_Performance_Evaluation__c(Total_Incentive_QTD__c=a,Total_Credit_Memo_QTD__c=c,Quarter__c='Q2',Year__c=2010,Performance_Metric__c=p.Id,Account__c=acc.Id);
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
       incNew.getChckRwd();
       incNew.button();
       incNew.getisactive();
       incNew.getTname();
       incNew.gettotBonus();
       Metric_Tier_Relation__c mtr32 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Minimum quarterly sales as SRI',Category__c='Performance to Business Plan',Incentive_Amount__c = a,Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Boolean_Metric_Y_N__c=TRUE);
       //32;
       Metric__c mObj2 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr32.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Boolean_Achievement__c=true,Goal_Met__c=true);
       insert mObj2;
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
       //incNew.updateEvaluation();
       incentiveCls.MtrDetail incMtr = new incentiveCls.MtrDetail();
       
       }
       catch(Exception ex){
       }
        
    }
    
    public static testMethod void testIncentveClass(){
    try{
        List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
        
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt4 = date.newinstance(2010,7,4);
        Date dt5 = date.newinstance(2009,12,1);
        Date dt6 = date.newinstance(2010,7,31);
        Date dt7 = date.newinstance(2010,1,4);
        
        if(pmObjx.size()>0){
           // delete pmObjx ;
        }
        
        if(tObjx.size()>0){
           // delete tObjx ;
        }
        
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt6 );
        insert p;
        //list<Performance_Metric__c> pmobj = [select Id from Performance_Metric__c where Country__c = 'USA' and Thea__c = 'North America'];
        Account acc = new Account(name='testResh1',type = 'Elite-Partner-Combo',CurrencyIsoCode='EUR',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        String accountId1 = acc.Id ;
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Elite');
        insert t1;  
        //Tier__c tObj = [select Id,Tier_Name__c,Country__c from Tier__c where Tier_Name__c='Premier' and Country__c='USA'];
        Double x=1.75;
        PDF_Limit__c pdflmt = new PDF_Limit__c(Partner__c=x,Performance_Metric__c=p.id,Tier__c=t1.Id);
        insert pdflmt;  
        Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='4 Marketing requirements met',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //1;
        upmtrlist.add(mtr1);
        Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SPWR Template on web site',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //2;
        upmtrlist.add(mtr2);
        Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='All 6 of the above',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //3;
        upmtrlist.add(mtr3);
        Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Co-branded Vehicle Wraps',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //4;
        upmtrlist.add(mtr4);
        Metric_Tier_Relation__c mtr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Dealer Webpage and Logo Usage',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //5;
        upmtrlist.add(mtr5);
        Metric_Tier_Relation__c mtr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for In-Home Sales Kit and Proposal Tool',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //6;
        upmtrlist.add(mtr6);
        Metric_Tier_Relation__c mtr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='7 Marketing requirements met',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //7;
        upmtrlist.add(mtr7);
        Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Flags/Stickers',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //8;
        upmtrlist.add(mtr8);
        
        Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Dealer Bonuses for meeting Business Objectives ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //10;
        upmtrlist.add(mtr10);
        Metric_Tier_Relation__c mtr11 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Meeting 6 Month Revenue Target',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //11;
        upmtrlist.add(mtr11);
        Metric_Tier_Relation__c mtr12 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Exceptional Forecast Accuracy',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //12;
        upmtrlist.add(mtr12);
        Metric_Tier_Relation__c mtr13 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Kw agreed target',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //13;
        upmtrlist.add(mtr13);
        
        Metric_Tier_Relation__c mtr14 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='3 Agreed Upon RSM Objectives ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //14;
        upmtrlist.add(mtr14);
        Metric_Tier_Relation__c mtr15 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //15;
        upmtrlist.add(mtr15);
        Metric_Tier_Relation__c mtr16 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='If 6 or more of the above are met',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //16;
        upmtrlist.add(mtr16);
        Metric_Tier_Relation__c mtr17 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //17;
        upmtrlist.add(mtr17);
        
        Metric_Tier_Relation__c mtr21 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
        //21;
        upmtrlist.add(mtr21);
        Metric_Tier_Relation__c mtr22 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //22;
        upmtrlist.add(mtr22);
        
        Metric_Tier_Relation__c mtr18 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='RSM Objective1',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //18;
        upmtrlist.add(mtr18);
        Metric_Tier_Relation__c mtr19 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - No. certified for Adv. Design',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //19;
        upmtrlist.add(mtr19);
        Metric_Tier_Relation__c mtr20 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Alliance Partner Lead',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        //20;
        upmtrlist.add(mtr20);
        Metric__c mObj1;
        List<Metric__c> lst_mObj1 = new List<Metric__c>();
        for(Metric_Tier_Relation__c mtr :upmtrlist){
          mObj1  = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Goal_Met__c= TRUE);
            lst_mObj1.add(mObj1);
        } 
        insert lst_mObj1;
        ApexPages.currentPage().getParameters().put('accId',accountId1 );
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        incentiveCls incN = new incentiveCls(); 
        List<incentiveCls.MtrDetail> inM = new List<incentiveCls.MtrDetail>();
        List<incentiveCls.MetricsDetails> inMd = new List<incentiveCls.MetricsDetails>();
        incentiveCls.MtrDetail mi = new incentiveCls.MtrDetail();
        incentiveCls.MetricsDetails md = new incentiveCls.MetricsDetails();
        md.meetricTierRel = mtr12;
        incentiveCls.MetricsDetails md1 = new incentiveCls.MetricsDetails();
        md1.meetricTierRel = mtr20;
        inMd.add(md1);
        
        mi.mtrP =md;
        mi.mtrC =  inMd;
        incN.getSpwrlFlag();
        incN.getMrklFlag();
        incN.getPbplFlag();
        incN.getTrnlFlag();
        incN.showTrg();
        incN.showPb();
        incN.showMkt();
        incN.showAllsun();
        incN.getcsatFlag();
        incN.gettrnFlag();
        incN.getpbpFlag();
        incN.getmrkFlag();
        incN.getspwrFlag();
        incN.getparamStartDate();
        incN.getparamEndDate();
        incN.getparamExpDate();
        incN.getaccountId();
        incN.getDisableButton();
        incN.getHideHeaderForPartner();
        incN.getShowLink();
        incN.getPartnerExecutive();
        incN.getDisableEditButton();
        incN.getcustomer_Satisfaction_Current();
        incN.getperformance_to_business_Plan_Current();
        incN.gettraining_Current();
        incN.getmarketing_Current();
        incN.getall_spwr_solutions_Current();
        incN.setpartnerDevelopmentFunds('abc');
        incN.settotalIncentive('abc');
        incN.setCreditMemo('abc');
        incN.settotalFunds('String');
        incN.setPDFNumber('abc');
        incN.setcreditMemoNumber('abc');
        incN.getpartnerDevelopmentFunds();
        incN.gettotalIncentive();
        incN.getCreditMemo();
        incN.gettotalFunds();
        incN.getPDFNumber();
        incN.getcreditMemoNumber();
        incN.enableInputFields();
        incN.getpartnerTier();
        incN.getAccountName();
        incN.getPartnerType();
        incN.getValidEvalFromDate();
        incN.getValidEvalToDate();
        incN.getTierStartDate();
        incN.getAccTheatre();
        incN.getisExecutiveManager();
        incN.getCurrencySyb();
        incN.getcomingSoon();
          
        }
              
        catch(Exception ex){
        
        } 
    }
    
     public static testMethod void testIncentveClas(){
        List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt4 = date.newinstance(2010,7,4);
        Date dt5 = date.newinstance(2009,12,1);
        Date dt6 = date.newinstance(2010,7,31);
        Date dt7 = date.newinstance(2010,1,4);
        
        if(pmObjx.size()>0){
            //delete pmObjx ;
        }
        
        if(tObjx.size()>0){
            //delete tObjx ;
        }
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='Italy1-Jan2010_to_Jun2010',Country__c='Italy',Thea__c='Europe',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt6 );
        insert p;
        //list<Performance_Metric__c> pmobj = [select Id from Performance_Metric__c where Country__c = 'USA' and Thea__c = 'North America'];
        Account acc = new Account(name='testResh3',type = 'Residential Installer',CurrencyIsoCode='EUR',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        String accountId1 = acc.Id ;
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='SRI');
        insert t1;  
        ApexPages.currentPage().getParameters().put('accId',accountId1 );
        final String  ACCOUNT_CHANNEL_NAME ='Residential';
        incentiveCls incN = new incentiveCls();     
        
     }
     public static testMethod void testIncentveClasProperties(){
     try{
            List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
            
            Date dt = date.newinstance(2006,1,1);
            Date dt1 = date.newinstance(2006,12,30);
            Date dt4 = date.newinstance(2011,7,4);
            Date dt5 = date.newinstance(2009,12,1);
            Date dt6 = date.newinstance(2010,7,31);
            Date dt7 = date.newinstance(2010,1,4);
            
            if(pmObjx.size()>0){
                //delete pmObjx ; 
            }
            
            if(tObjx.size()>0){
                //delete tObjx ;
            }
            
            Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jul2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt4 );
            insert p;
            //list<Performance_Metric__c> pmobj = [select Id from Performance_Metric__c where Country__c = 'USA' and Thea__c = 'North America'];
            Account acc = new Account(name='testResh1',type = 'Elite-Partner-Combo',CurrencyIsoCode='EUR',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
            insert acc;
            
            order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
            insert ods;
            String accountId1 = acc.Id ;
            Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Elite');
            insert t1;  
            //Tier__c tObj = [select Id,Tier_Name__c,Country__c from Tier__c where Tier_Name__c='Premier' and Country__c='USA'];
            Double x=1.75;
            PDF_Limit__c pdflmt = new PDF_Limit__c(Partner__c=x,Performance_Metric__c=p.id,Tier__c=t1.Id);
            insert pdflmt; 

            
            Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='4 Marketing requirements met',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr1);
            Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SPWR Template on web site',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr2);
            Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='All 6 of the above',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr3);
            Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Co-branded Vehicle Wraps',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr4);
            Metric_Tier_Relation__c mtr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Dealer Webpage and Logo Usage',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
           
            upmtrlist.add(mtr5);
            Metric_Tier_Relation__c mtr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for In-Home Sales Kit and Proposal Tool',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr6);
            Metric_Tier_Relation__c mtr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='7 Marketing requirements met',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr7);
            Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Flags/Stickers',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr8);
            
            Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Dealer Bonuses for meeting Business Objectives ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr10);
            Metric_Tier_Relation__c mtr11 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Meeting 6 Month Revenue Target',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr11);
            Metric_Tier_Relation__c mtr12 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Exceptional Forecast Accuracy',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr12);
            Metric_Tier_Relation__c mtr13 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Kw agreed target',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr13);
            
            Metric_Tier_Relation__c mtr14 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='3 Agreed Upon RSM Objectives ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr14);
            Metric_Tier_Relation__c mtr15 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr15);
            Metric_Tier_Relation__c mtr16 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='If 6 or more of the above are met',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr16);
            Metric_Tier_Relation__c mtr17 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr17);
            
            Metric_Tier_Relation__c mtr21 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr21);
            Metric_Tier_Relation__c mtr22 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr22);
            
            Metric_Tier_Relation__c mtr18 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='RSM Objective1',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr18);
            Metric_Tier_Relation__c mtr19 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - No. certified for Adv. Design',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr19);
            Metric_Tier_Relation__c mtr20 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Alliance Partner Lead',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr20);
            insert upmtrlist;
             /*List<Metric_Tier_Relation__c> MTRList = new List<Metric_Tier_Relation__c>(); 
            Metric_Tier_Relation__c mtr01 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SPWR_DEALER_LOGO_ON_HOMEPAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr01);
            
           Metric_Tier_Relation__c mtr02 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SPWR_DEALER_LOGO_ON_HOMEPAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr02);
            Metric_Tier_Relation__c mtr03 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SPWR_DEALER_LOGO_ON_PRODUCTS_PAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr03);
            Metric_Tier_Relation__c mtr04 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SPWR_DEALER_LOGO_ON_ABOUTUS_PAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr04);
            Metric_Tier_Relation__c mtr05 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MAINTAINS_WEBPAGE_CONSUMER_ADVANTAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr05);
            Metric_Tier_Relation__c mtr06 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_CO_BRANDED_ALL_VEHICLES_RVAR,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr06);
            Metric_Tier_Relation__c mtr07 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_CO_BRANDED_BUSINESS_CARDS_RVAR,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr07);
            Metric_Tier_Relation__c mtr08 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_CO_BRANDED_SALES_INSTALLATION_APPAREL_RVAR,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr08);
            Metric_Tier_Relation__c mtr09 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_CERT ,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr09);
            Metric_Tier_Relation__c mtr010 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_LOCAL_EVENTS_RVAR,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr010);
            Metric_Tier_Relation__c mtr011 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKETADV,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr011);
            Metric_Tier_Relation__c mtr012 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_JOB,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr012);
            Metric_Tier_Relation__c mtr013 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_USA_M3,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr013);
          Metric_Tier_Relation__c mtr014 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.AutomatedCSATMetric,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr014);
            Metric_Tier_Relation__c mtr015 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.updateEvaluation,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr015);*/
            
            ////List;
            //upmtrlist.addAll(MTRList);
            Metric__c mObj1;
            List<Metric__c> lst_mObj1 = new List<Metric__c>();
            for(Metric_Tier_Relation__c mtr :upmtrlist){
                mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Goal_Met__c= TRUE);
                lst_mObj1.add(mObj1);
            } 
            insert lst_mObj1;
            ApexPages.currentPage().getParameters().put('accId',accountId1 );
            final String  ACCOUNT_CHANNEL_NAME ='Residential';
            incentiveCls incN = new incentiveCls(); 
            
            
            incN.getSpwrlFlag();
            incN.getMrklFlag();
            incN.getPbplFlag();
            incN.getTrnlFlag();
            incN.showTrg();
            incN.showPb();
            incN.showMkt();
            incN.showAllsun();
            incN.getcsatFlag();
            incN.gettrnFlag();
            incN.getpbpFlag();
            incN.getmrkFlag();
            incN.getspwrFlag();
            incN.getparamStartDate();
            incN.getparamEndDate();
            incN.getparamExpDate();
            incN.getaccountId();
            incN.getDisableButton();
            incN.getHideHeaderForPartner();
            incN.getShowLink();
            incN.getPartnerExecutive();
            incN.getDisableEditButton();
            incN.getcustomer_Satisfaction_Current();
            incN.getperformance_to_business_Plan_Current();
            incN.gettraining_Current();
            incN.getmarketing_Current();
            incN.getall_spwr_solutions_Current();
            incN.setpartnerDevelopmentFunds('abc');
            incN.settotalIncentive('abc');
            incN.setCreditMemo('abc');
            incN.settotalFunds('String');
            incN.setPDFNumber('abc');
            incN.setcreditMemoNumber('abc');
            incN.getpartnerDevelopmentFunds();
            incN.gettotalIncentive();
            incN.getCreditMemo();
            incN.gettotalFunds();
            incN.getPDFNumber();
            incN.getcreditMemoNumber();
            incN.enableInputFields();
            incN.getpartnerTier();
            incN.getAccountName();
            incN.getPartnerType();
            incN.getValidEvalFromDate();
            incN.getValidEvalToDate();
            incN.getTierStartDate(); 
            incN.getAccTheatre();
            incN.getisExecutiveManager();
            incN.getCurrencySyb();
            incN.getcomingSoon();
            
            
            
            incN.getCurrencySybm();  
            //incN.updateEvaluation(); 
            incN.retriveIncentiveInfo();
            incN.getCSATMetrics();
            incN.getaccountId(); 
            incN.getAccTheatre();
            incN.getAllSunpowerMtr();
            incN.getAllSunpowerMtr();
            incN.getBonus();
            incN.getBussinessPlan();
            incN.getChckRwd();
            incN.getCreditMemo();
            incN.getcreditMemoNumber();
            incN.saveNextData();
            incN.updateEvaluation(); 
                               
         }
         
              
         catch(Exception ex){
         }
         
     }  
     
     
     public static testMethod void testIncentveClasProperties1(){
     try{
            List<Metric_Tier_Relation__c> upmtrlist = new List<Metric_Tier_Relation__c>();
            
            Date dt = date.newinstance(2006,1,1);
            Date dt1 = date.newinstance(2006,12,30);
            Date dt4 = date.newinstance(2011,7,4);
            Date dt5 = date.newinstance(2009,12,1);
            Date dt6 = date.newinstance(2010,7,31);
            Date dt7 = date.newinstance(2010,1,4);
            
            if(pmObjx.size()>0){
                //delete pmObjx ; 
            }
            
            if(tObjx.size()>0){
                //delete tObjx ;
            }
            
            Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jul2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt4 );
            insert p;
            //list<Performance_Metric__c> pmobj = [select Id from Performance_Metric__c where Country__c = 'USA' and Thea__c = 'North America'];
            Account acc = new Account(name='testResh1',type = 'Elite-Partner-Combo',CurrencyIsoCode='EUR',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
            insert acc;
            
            order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
            insert ods;
            String accountId1 = acc.Id ;
            Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Elite');
            insert t1;  
            //Tier__c tObj = [select Id,Tier_Name__c,Country__c from Tier__c where Tier_Name__c='Premier' and Country__c='USA'];
            Double x=1.75;
            PDF_Limit__c pdflmt = new PDF_Limit__c(Partner__c=x,Performance_Metric__c=p.id,Tier__c=t1.Id);
            insert pdflmt; 

            
            Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='4 Marketing requirements met',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr1);
            Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SPWR Template on web site',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr2);
            Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='All 6 of the above',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr3);
            Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Co-branded Vehicle Wraps',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr4);
            Metric_Tier_Relation__c mtr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Dealer Webpage and Logo Usage',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr5);
            Metric_Tier_Relation__c mtr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for In-Home Sales Kit and Proposal Tool',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr6);
            Metric_Tier_Relation__c mtr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='7 Marketing requirements met',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr7);
            Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Flags/Stickers',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr8);
            
            Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Dealer Bonuses for meeting Business Objectives ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr10);
            Metric_Tier_Relation__c mtr11 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Meeting 6 Month Revenue Target',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
           
            upmtrlist.add(mtr11);
            Metric_Tier_Relation__c mtr12 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Exceptional Forecast Accuracy',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
           
            upmtrlist.add(mtr12);
            Metric_Tier_Relation__c mtr13 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Kw agreed target',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr13);
            
            Metric_Tier_Relation__c mtr14 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='3 Agreed Upon RSM Objectives ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr14);
            Metric_Tier_Relation__c mtr15 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr15);
            Metric_Tier_Relation__c mtr16 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='If 6 or more of the above are met',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr16);
            Metric_Tier_Relation__c mtr17 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr17);
            
            Metric_Tier_Relation__c mtr21 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Meet all SPWR Solutions',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE,Incentive_Amount__c=0.5);
            
            upmtrlist.add(mtr21);
            Metric_Tier_Relation__c mtr22 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
           
            upmtrlist.add(mtr22);
            
            Metric_Tier_Relation__c mtr18 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='RSM Objective1',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr18);
            Metric_Tier_Relation__c mtr19 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - No. certified for Adv. Design',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr19);
            Metric_Tier_Relation__c mtr20 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Alliance Partner Lead',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
            
            upmtrlist.add(mtr20);
            insert upmtrlist;
            
            /*List<Metric_Tier_Relation__c> MTRList = new List<Metric_Tier_Relation__c>(); 
            Metric_Tier_Relation__c mtr01 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SPWR_DEALER_LOGO_ON_HOMEPAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr01);
            
            Metric_Tier_Relation__c mtr02 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SPWR_DEALER_LOGO_ON_HOMEPAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr02);
            Metric_Tier_Relation__c mtr03 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SPWR_DEALER_LOGO_ON_PRODUCTS_PAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr03);
            Metric_Tier_Relation__c mtr04 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.SPWR_DEALER_LOGO_ON_ABOUTUS_PAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr04);
            Metric_Tier_Relation__c mtr05 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MAINTAINS_WEBPAGE_CONSUMER_ADVANTAGE,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr05);
            Metric_Tier_Relation__c mtr06 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_CO_BRANDED_ALL_VEHICLES_RVAR,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr06);
            Metric_Tier_Relation__c mtr07 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_CO_BRANDED_BUSINESS_CARDS_RVAR,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr07);
            Metric_Tier_Relation__c mtr08 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_CO_BRANDED_SALES_INSTALLATION_APPAREL_RVAR,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr08);
            Metric_Tier_Relation__c mtr09 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_CERT ,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr09);
            Metric_Tier_Relation__c mtr010 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_LOCAL_EVENTS_RVAR,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr010);
            Metric_Tier_Relation__c mtr011 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKETADV,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr011);
            Metric_Tier_Relation__c mtr012 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_JOB,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr012);
            Metric_Tier_Relation__c mtr013 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c=PerformanceEvalCst.MARKET_USA_M3,Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
            MTRList.add(mtr013);*/
            //Birlasoft : commented as it was not being used
            Metric__c mObj1;
            List<Metric__c> lst_mObj1 = new List<Metric__c>();
            for(Metric_Tier_Relation__c mtr :upmtrlist){
                    mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Goal_Met__c= TRUE);
                lst_mObj1.add(mObj1);
            } 
            insert lst_mObj1;
            ApexPages.currentPage().getParameters().put('accId',accountId1 );
            final String  ACCOUNT_CHANNEL_NAME ='Residential';
            incentiveCls incN = new incentiveCls(); 
                        
            incN.getSpwrlFlag();
            incN.getMrklFlag();
            incN.getPbplFlag();
            incN.getTrnlFlag();
            incN.showTrg();
            incN.showPb();
            incN.showMkt();
            incN.showAllsun();
            incN.getcsatFlag();
            incN.gettrnFlag();
            incN.getpbpFlag();
            incN.getmrkFlag();
            incN.getspwrFlag();
            incN.getparamStartDate();
            incN.getparamEndDate();
            incN.getparamExpDate();
            incN.getaccountId();
            incN.getDisableButton();
            incN.getHideHeaderForPartner();
            incN.getShowLink();
            incN.getPartnerExecutive();
            incN.getDisableEditButton();
            incN.getcustomer_Satisfaction_Current();
            incN.getperformance_to_business_Plan_Current();
            incN.gettraining_Current();
            incN.getmarketing_Current();
            incN.getall_spwr_solutions_Current();
            incN.setpartnerDevelopmentFunds('abc');
            incN.settotalIncentive('abc');
            incN.setCreditMemo('abc');
            incN.settotalFunds('String');
            incN.setPDFNumber('abc');
            incN.setcreditMemoNumber('abc');
            incN.getpartnerDevelopmentFunds();
            incN.gettotalIncentive();
            incN.getCreditMemo();
            incN.gettotalFunds();
            incN.getPDFNumber();
            incN.getcreditMemoNumber();
            incN.enableInputFields();
            incN.getpartnerTier();
            incN.getAccountName();
            incN.getPartnerType();
            incN.getValidEvalFromDate();
            incN.getValidEvalToDate();
            incN.getTierStartDate(); 
            incN.getAccTheatre();
            incN.getisExecutiveManager();
            incN.getCurrencySyb();
            incN.getcomingSoon();
            
            
            
            incN.getCurrencySybm();  
            //incN.updateEvaluation(); 
            incN.retriveIncentiveInfo();
            incN.getCSATMetrics();
            incN.getaccountId(); 
            incN.getAccTheatre();
            incN.getAllSunpowerMtr();
            incN.getAllSunpowerMtr();
            incN.getBonus();
            incN.getBussinessPlan();
            incN.getChckRwd();
            incN.getCreditMemo();
            incN.getcreditMemoNumber();
            incN.saveNextData();            
            incN.goToPreviousIncentivePage();             
            incN.showCSAT();
            incN.getcsatlFlag();
            incN.updateEvaluation();
            
         }
         
         catch(Exception ex){
         }
     } 
  
}