@IsTest
public with sharing class TestPerformanceAchievePrevious {
    

     /**** testMethod for PerformanceAchievePrevious***/
     public static testMethod void testPerfAch3(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner' and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
         Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
        Double d3 = PerformanceAchievePrevious.computeCREDITLIMIT(acx);
        Boolean bl2 = PerformanceAchievePrevious.computeSIXMONTHSASAUTHWITHTWENTYINSTALL(acx);
        Boolean bl3 = PerformanceAchievePrevious.computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS(acx);
        Boolean bl4 = PerformanceAchievePrevious.computeMINSALESAUTHZEU(acx);
        Boolean bl5 = PerformanceAchievePrevious.computeACTIVEDEALER(acx,dt,dt1);
        Boolean bl6 = PerformanceAchievePrevious.computeMINQUATSALESEUCLONE(acx,dt,dt1);
        Boolean bl7 = PerformanceAchievePrevious.computeMINQUATSALESEU(acx,dt,dt1);
        Boolean bl8 = PerformanceAchievePrevious.computeMINQUATSALESEU(acx,dt,dt1);
        Double b20 = PerformanceAchievePrevious.computeSEVENTYSALESKITS(acx,dt,dt1);
        Double b21 = PerformanceAchievePrevious.computeSEVENTYRESKITSEU(acx,dt,dt1);
        Double b22 = PerformanceAchievePrevious.computeSEVENTYCOMINVTREU(acx,dt,dt1);
        System.assertEquals(true,bl3);
        
        
        PerformanceAchievePrevious.computeKWTARGETEU(acx,dt,dt1);
        PerformanceAchievePrevious.computeSIXMONTHSTARGET(acx,dt,dt1);
        PerformanceAchievePrevious.computeOPPCLOSERATE(acx);
        PerformanceAchievePrevious.computeADVANCE_TRAINING_EU(acx);
     }
    public static testMethod void testPerfAch(){ 
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner' and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
         Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
        Double b1 =PerformanceAchievePrevious.coumputeSITEINSPECTIONNONCOMP(acx, dt,dt1);
        System.assertEquals(0.0,b1);
        PerformanceAchievePrevious.coumputeSITEINSPECTIONEUSTAY(acx,dt,dt1);
        Double b2 = PerformanceAchievePrevious.coumputeSITEINSPECTION(acx, dt,dt1);
        Double b32 = PerformanceAchievePrevious.coumputeSITEINSPECTIONEU(acx, dt,dt1,t1.Id);
        Double b3 = PerformanceAchievePrevious.computePERCENTINSTALLCRM(acx,dt,dt1);
        Boolean bl = PerformanceAchievePrevious.computeTRAININGEXTRABONUS(acx);
        Double a1= PerformanceAchievePrevious.computeTRAININGASSSALES(acx);
        Double dl = PerformanceAchievePrevious.computeADVANCEPRODTRAINING(acx);
    }
   
    public static testMethod void testPerfAch5(){ 
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner' and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
         Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
        Double d2 = PerformanceAchievePrevious.computeBASICTRAININGEU(acx);
        PerformanceAchievePrevious.computeBASICTRAINING(acx);
         }
   
    public static testMethod void testPerfAch_1(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner' and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
         Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
        
        PerformanceAchievePrevious.computeTWENTYINSTALLSASAUTH(acx);
        PerformanceAchievePrevious.computeHUNDREDINSTALLSASPREM(acx);
        PerformanceAchievePrevious.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(acx);
        PerformanceAchievePrevious.getQuartesBetweenDates(dt4,dt5);

  
        Double dd=5.0;
        Date sd= date.newinstance(2010,1,4);
        Date ed= date.newinstance(2010,7,4);
        Date ecd= date.newinstance(2010,7,31);
        Date mCd= date.newinstance(2009,12,1);  
        
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= sd,Performance_period_End_date__c =ed ,Metric_Setup_Cut_off_Date__c =mCd,Performance_Evaluation_Cut_off_Date__c =ecd );
        insert p;
       
        Metric_Tier_Relation__c mtrNxt = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Enter_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated');
        insert mtrNxt;
    
        Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtrNxt.Id,Achievement_Value__c=0,Performance_Metric__c=p.Id,CurrencyIsoCode = 'USD');
        insert mobj;
        //Partner_Application__c Pa = new Partner_Application__c(Company_Name__c='abc',Account__c=acc.Id);
        //insert pa;
        PerformanceAchievePrevious.automatedBooleanGoalCheck(mobj,mtrNxt,true);
        PerformanceAchievePrevious.automatedDoubleGoalCheck(mobj,mtrNxt,dd); 
        PerformanceAchievePrevious.automatedDoubleGoalCheckKW(mobj,mtrNxt,dd);
        PerformanceAchievePrevious.getCurrentPerformancePeriod('Q3');
        PerformanceAchievePrevious.computeBGSMScore(acx);
        PerformanceAchievePrevious.getQuartesBetweenDates(sd,ed);
        PerformanceAchievePrevious.getQuartesBetweenDates(ed,sd);
    }
    
    public static testMethod void testPerfAch1(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner'and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
         Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
       /* Double b1 =PerformanceAchievePrevious.coumputeSITEINSPECTIONNONCOMP(acx, dt,dt1);
        System.assertEquals(0.0,b1);
        PerformanceAchievePrevious.coumputeSITEINSPECTIONEUSTAY(acx,dt,dt1);
        Double b2 = PerformanceAchievePrevious.coumputeSITEINSPECTION(acx, dt,dt1);
        Double b32 = PerformanceAchievePrevious.coumputeSITEINSPECTIONEU(acx, dt,dt1,t1.Id);
        Double b3 = PerformanceAchievePrevious.computePERCENTINSTALLCRM(acx,dt,dt1);
        Boolean bl = PerformanceAchievePrevious.computeTRAININGEXTRABONUS(acx);
        Double a1= PerformanceAchievePrevious.computeTRAININGASSSALES(acx);
        Double dl = PerformanceAchievePrevious.computeADVANCEPRODTRAINING(acx);
        Double d2 = PerformanceAchievePrevious.computeBASICTRAININGEU(acx);
        PerformanceAchievePrevious.computeBASICTRAINING(acx);
        Double d3 = PerformanceAchievePrevious.computeCREDITLIMIT(acx);
        Boolean bl2 = PerformanceAchievePrevious.computeSIXMONTHSASAUTHWITHTWENTYINSTALL(acx);*/
        //System.assertEquals(1.0,b2);
       // System.assertEquals(1.0,b32);
      /*  System.assertEquals(0.0,b3);
        System.assertEquals(false,bl);
        System.assertEquals(1.0,dl);
        System.assertEquals(0.0,d2);
        System.assertEquals(1000.0,d3);
        System.assertEquals(true,bl2);
        System.assertEquals(0.0,b1);*/
       
        Boolean bl3 = PerformanceAchievePrevious.computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS(acx);
        Boolean bl4 = PerformanceAchievePrevious.computeMINSALESAUTHZEU(acx);
        Boolean bl5 = PerformanceAchievePrevious.computeACTIVEDEALER(acx,dt,dt1);
        Boolean bl6 = PerformanceAchievePrevious.computeMINQUATSALESEUCLONE(acx,dt,dt1);
        Boolean bl7 = PerformanceAchievePrevious.computeMINQUATSALESEU(acx,dt,dt1);
        Boolean bl8 = PerformanceAchievePrevious.computeMINQUATSALESEU(acx,dt,dt1);
        Double b20 = PerformanceAchievePrevious.computeSEVENTYSALESKITS(acx,dt,dt1);
        Double b21 = PerformanceAchievePrevious.computeSEVENTYRESKITSEU(acx,dt,dt1);
        Double b22 = PerformanceAchievePrevious.computeSEVENTYCOMINVTREU(acx,dt,dt1);
        System.assertEquals(true,bl3);
        //System.assertEquals(false,bl4);
        //System.assertEquals(false,bl5);
        /*System.assertEquals(false,bl6);
        System.assertEquals(true,bl7);
        System.assertEquals(true,bl8);*/
        
        //System.assertEquals(0.0,b20);
        //System.assertEquals(false,b21);
        //System.assertEquals(false,b22);
        
        PerformanceAchievePrevious.computeKWTARGETEU(acx,dt,dt1);
        PerformanceAchievePrevious.computeSIXMONTHSTARGET(acx,dt,dt1);
        PerformanceAchievePrevious.computeOPPCLOSERATE(acx);
        PerformanceAchievePrevious.computeADVANCE_TRAINING_EU(acx);
        PerformanceAchievePrevious.computeTWENTYINSTALLSASAUTH(acx);
        PerformanceAchievePrevious.computeHUNDREDINSTALLSASPREM(acx);
        PerformanceAchievePrevious.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(acx);
        PerformanceAchievePrevious.getQuartesBetweenDates(dt4,dt5);

    }
    public static testMethod void testPerfAch6(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner'and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
         Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
        Double dd=5.0;
        PerformanceAchievePrevious.computeCSATSCORE(acc.Id,dt,dt1);
        PerformanceAchievePrevious.checkCSATCount(acc.Id,dt,dt1,dd);

        
    }
    
     public static testMethod void testPerfAch4(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner'and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
         Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
        PerformanceAchievePrevious.computeCSATSURVEYREQ(acc.Id,dt,dt1);
    PerformanceAchievePrevious.coumputeCUSTOMERCOMPLAINTS(acc.Id,dt,dt1);
    PerformanceAchievePrevious.computeWARRANTYCARDSNA(acc.Id,dt,dt1);
    PerformanceAchievePrevious.computeWARRANTYCARDSEU(acc.Id,dt,dt1);
    PerformanceAchievePrevious.computeTRAININGASSDESIGN(acc.Id);
    PerformanceAchievePrevious.computeEXTRABONUSI(acc.Id);
    PerformanceAchievePrevious.computeEXTRABONUSII(acc.Id);
    PerformanceAchievePrevious.computeCREDITLIMITEU(acc.Id);
    PerformanceAchievePrevious.computeCREDITLIMITSRI(acc.Id);
    PerformanceAchievePrevious.computeSIXMONTHSASAUTH(acc.Id);
    PerformanceAchievePrevious.computeSIXMONTHSASPREM(acc.Id);
    PerformanceAchievePrevious.computeRETROFITSOLARSYS(acc.Id);
    PerformanceAchievePrevious.computeTRAININGASSINSTALL(acc.Id);

    Date sd= date.newinstance(2010,1,4);
    Date ed= date.newinstance(2010,7,4);
    Date ecd= date.newinstance(2010,7,31);
    Date mCd= date.newinstance(2009,12,1);  
    
    Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= sd,Performance_period_End_date__c =ed ,Metric_Setup_Cut_off_Date__c =mCd,Performance_Evaluation_Cut_off_Date__c =ecd );
    insert p;
   
    Metric_Tier_Relation__c mtrNxt = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Enter_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated');
    insert mtrNxt;

    Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtrNxt.Id,Achievement_Value__c=0,Performance_Metric__c=p.Id,CurrencyIsoCode = 'USD');
    insert mobj;
    Double dd=5.0;
    PerformanceAchievePrevious.automatedBooleanGoalCheck(mobj,mtrNxt,true);
    PerformanceAchievePrevious.automatedDoubleGoalCheck(mobj,mtrNxt,dd); 
    PerformanceAchievePrevious.automatedDoubleGoalCheckKW(mobj,mtrNxt,dd);
    PerformanceAchievePrevious.getCurrentPerformancePeriod('Q3');
    PerformanceAchievePrevious.getCurrentPerformancePeriod('Q');
    PerformanceAchievePrevious.computeBGSMScore(acx);
    PerformanceAchievePrevious.getQuartesBetweenDates(sd,ed);
    PerformanceAchievePrevious.getQuartesBetweenDates(ed,sd);
    PerformanceAchievePrevious.getQuartesBetweenDates(date.newinstance(2010,2,4),date.newinstance(2010,3,4));
    PerformanceAchievePrevious.getQuartesBetweenDates(date.newinstance(2010,4,4),date.newinstance(2010,5,4));
    PerformanceAchievePrevious.getQuartesBetweenDates(date.newinstance(2010,6,4),date.newinstance(2010,8,4));
    PerformanceAchievePrevious.getQuartesBetweenDates(date.newinstance(2010,9,4),date.newinstance(2010,10,4));
    PerformanceAchievePrevious.getQuartesBetweenDates(date.newinstance(2010,11,4),date.newinstance(2010,12,4));
    PerformanceAchievePrevious.getQuartesBetweenDates(date.newinstance(2010,7,5),date.newinstance(2010,4,5));
    PerformanceAchievePrevious.getQuartesBetweenDates(date.newinstance(2010,10,1),date.newinstance(2010,4,5));
     }
     public static testMethod void testPerfAch2(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner'and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
        Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
        
        Date sd= date.newinstance(2010,1,4);
        Date ed= date.newinstance(2010,7,4);
        Date ecd= date.newinstance(2010,7,31);
        Date mCd= date.newinstance(2009,12,1);  
        
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= sd,Performance_period_End_date__c =ed ,Metric_Setup_Cut_off_Date__c =mCd,Performance_Evaluation_Cut_off_Date__c =ecd );
        insert p;
       
        Metric_Tier_Relation__c mtrNxt = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Enter_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated');
        insert mtrNxt;
    
        Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtrNxt.Id,Achievement_Value__c=0,Performance_Metric__c=p.Id,CurrencyIsoCode = 'USD');
        insert mobj;
        
        acc.Credit_Limit__c = null;
        update acc;
        PerformanceAchievePrevious.computeCREDITLIMIT(acc.Id);
        acc.Credit_Limit__c = 50000;
        update acc; 
        PerformanceAchievePrevious.computeCREDITLIMITEU(acc.Id);
        PerformanceAchievePrevious.computeCREDITLIMITSRI(acc.Id);
        
     } 
   public static testMethod void testPerfAch7(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievePrevious perAObj = new PerformanceAchievePrevious();
        
        System.assertEquals(true,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        System.assertEquals(false,PerformanceAchievePrevious.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        RecordType r = [select Id from RecordType where name= 'Partner'and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        Id acx = acc.Id;
        
       
     
        String dy= ''+ date.today().year();
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P1',Quarter__c='Q1',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x');
        insert ods;
        Certification__c certObj = new Certification__c (Curriculum_Role__c='sales',Curriculum_Level__c='Advanced',Account__c=acc.Id,Attended_ILC__c=true);
        insert certObj;
        Certification__c certObj1 = new Certification__c (Curriculum_Role__c='Install',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj1;
        Certification__c certObj2 = new Certification__c (Curriculum_Role__c='Design',Curriculum_Level__c='Associate',Account__c=acc.Id);
        insert certObj2;
        Customer_Survey_Result__c sryObj = new Customer_Survey_Result__c(Partner_Account__c = acc.Id,Survey_Response_Date__c= dt2);
        insert sryObj;
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dt,OwnerId=test_user.Id);
        insert opp;
        Case cse = new Case(type ='Inspection',Origin='Phone',Status='new',Partner_Account__c=acx,AccountId =acx);
        insert cse;        
        Inspection__c insp = new Inspection__c(score__c = 10,Score_Details__c='YES',Case__c=cse.Id,Inspection_Date__c= dt2);
        insert insp;
        
        Date sd= date.newinstance(2010,1,4);
        Date ed= date.newinstance(2010,7,4);
        Date ecd= date.newinstance(2010,7,31);
        Date mCd= date.newinstance(2009,12,1);  
        
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= sd,Performance_period_End_date__c =ed ,Metric_Setup_Cut_off_Date__c =mCd,Performance_Evaluation_Cut_off_Date__c =ecd );
        insert p;
       
        Metric_Tier_Relation__c mtrNxt = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Enter_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated');
        insert mtrNxt;
    
        Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtrNxt.Id,Achievement_Value__c=0,Performance_Metric__c=p.Id,CurrencyIsoCode = 'USD');
        insert mobj;
        
        acc.Credit_Limit__c = 50000;
        update acc;
        PerformanceAchievePrevious.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(acc.Id);
        PerformanceAchievePrevious.computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS(acc.Id);
     }
}