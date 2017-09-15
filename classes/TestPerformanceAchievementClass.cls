@IsTest
public class TestPerformanceAchievementClass{
    public static testMethod void testPerfAch9(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0;
        Date dt = date.newinstance(2006,1,1); 
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        Tier__c Tiert1 = new Tier__c(Country__c='Italy',Tier_Name__c='Authorized' );
        insert Tiert1;
        Tier__c Tiert2 = new Tier__c(Country__c='Italy',Tier_Name__c='SRI' );
        insert Tiert2;
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
        Double b32 = PerformanceAchievementClass.coumputeSITEINSPECTIONEU(acx, dt,dt1,t1.Id);
        Double b312 = PerformanceAchievementClass.coumputeSITEINSPECTIONEU(acx, dt,dt1,Tiert1.Id);
        Double b322 = PerformanceAchievementClass.coumputeSITEINSPECTIONEU(acx, dt,dt1,Tiert2.Id);        
    }
    
     /**** testMethod for PerformanceAchievementClass***/
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
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        Tier__c Tiert1 = new Tier__c(Country__c='Italy',Tier_Name__c='Authorized' );
        insert Tiert1;
        Tier__c Tiert2 = new Tier__c(Country__c='Italy',Tier_Name__c='SRI' );
        insert Tiert2;
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
        Double b1 =PerformanceAchievementClass.coumputeSITEINSPECTIONNONCOMP(acx, dt,dt1);
        ///System.assertEquals(0.0,b1);
        PerformanceAchievementClass.coumputeSITEINSPECTIONEUSTAY(acx,dt,dt1);
        
        //Double b2 = PerformanceAchievementClass.coumputeSITEINSPECTION(acx, dt,dt1);
        Boolean b2 = PerformanceAchievementClass.coumputeSITEINSPECTION(acx, dt,dt1);
        System.debug('=======================b2==================' + b2);
        
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
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        Tier__c Tiert1 = new Tier__c(Country__c='Italy',Tier_Name__c='Authorized' );
        insert Tiert1;
        Tier__c Tiert2 = new Tier__c(Country__c='Italy',Tier_Name__c='SRI' );
        insert Tiert2;
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
        Double b3 = PerformanceAchievementClass.computePERCENTINSTALLCRM(acx,dt,dt1);
        Boolean bl = PerformanceAchievementClass.computeTRAININGEXTRABONUS(acx);
        Double a1= PerformanceAchievementClass.computeTRAININGASSSALES(acx);
        Double dl = PerformanceAchievementClass.computeADVANCEPRODTRAINING(acx);
        Double d2 = PerformanceAchievementClass.computeBASICTRAININGEU(acx);
        PerformanceAchievementClass.computeBASICTRAINING(acx);
        Double d3 = PerformanceAchievementClass.computeCREDITLIMIT(acx);
        Boolean bl2 = PerformanceAchievementClass.computeSIXMONTHSASAUTHWITHTWENTYINSTALL(acx);
        Boolean bl3 = PerformanceAchievementClass.computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS(acx);
        Boolean bl4 = PerformanceAchievementClass.computeMINSALESAUTHZEU(acx);
        Boolean bl5 = PerformanceAchievementClass.computeACTIVEDEALER(acx,dt,dt1);
        Boolean bl6 = PerformanceAchievementClass.computeMINQUATSALESEUCLONE(acx,dt,dt1);
        
        
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
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        Tier__c Tiert1 = new Tier__c(Country__c='Italy',Tier_Name__c='Authorized' );
        insert Tiert1;
        Tier__c Tiert2 = new Tier__c(Country__c='Italy',Tier_Name__c='SRI' );
        insert Tiert2;
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

        PerformanceAchievementClass.computeKWTARGETEU(acx,dt,dt1);
        PerformanceAchievementClass.computeSIXMONTHSTARGET(acx,dt,dt1);
        PerformanceAchievementClass.computeOPPCLOSERATE(acx);
        
        Boolean bl7 = PerformanceAchievementClass.computeMINQUATSALESEU(acx,dt,dt1);
        Boolean bl8 = PerformanceAchievementClass.computeMINQUATSALESEU(acx,dt,dt1);
        Double b20 = PerformanceAchievementClass.computeSEVENTYSALESKITS(acx,dt,dt1);
        
        //Double b21 = PerformanceAchievementClass.computeSEVENTYRESKITSEU(acx,dt,dt1);
        //String Country, Decimal rackingPrice
        Double b21 = PerformanceAchievementClass.computeSEVENTYRESKITSEU(acx,dt,dt1,'Germany',10);
        Double b22 = PerformanceAchievementClass.computeSEVENTYCOMINVTREU(acx,dt,dt1);        
    }
    public static testMethod void testPerfAch8(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0; 
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
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
    //start for case # 00052350
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
    //PerformanceAchievementClass.computeCREDITLIMITEU(acc.Id);
    PerformanceAchievementClass.computeCREDITLIMITSRI(acc.Id);
    PerformanceAchievementClass.computeSIXMONTHSASAUTH(acc.Id);
    PerformanceAchievementClass.computeSIXMONTHSASPREM(acc.Id);
    PerformanceAchievementClass.computeRETROFITSOLARSYS(acc.Id);
    PerformanceAchievementClass.computeTRAININGASSINSTALL(acc.Id);
    PerformanceAchievementClass.automatedBooleanGoalCheck(mobj,mtrNxt,true);
    PerformanceAchievementClass.automatedDoubleGoalCheck(mobj,mtrNxt,dd); 
    PerformanceAchievementClass.automatedDoubleGoalCheckKW(mobj,mtrNxt,dd);
    PerformanceAchievementClass.getCurrentPerformancePeriod('Q3');
    PerformanceAchievementClass.getCurrentPerformancePeriod('Q');
    PerformanceAchievementClass.computeBGSMScore(acx);
    PerformanceAchievementClass.getQuartesBetweenDates(sd,ed);
    PerformanceAchievementClass.getQuartesBetweenDates(ed,sd);
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,2,4),date.newinstance(2010,3,4));
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,4,4),date.newinstance(2010,5,4));
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,6,4),date.newinstance(2010,8,4));
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,9,4),date.newinstance(2010,10,4));
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,11,4),date.newinstance(2010,12,4));
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
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
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
    //start for case # 00052350
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
    //PerformanceAchievementClass.computeCSATSCORE(acc.Id,dt,dt1);
    PerformanceAchievementClass.computeCSATSCORE(acc.Id,dt,dt1, p);
    //end for case # 00052350
    PerformanceAchievementClass.checkCSATCount(acc.Id,dt,dt1,dd);
    //start for case # 00052350
    //PerformanceAchievementClass.computeCSATSURVEYREQ(acc.Id,dt,dt1);
    PerformanceAchievementClass.computeCSATSURVEYREQ(acc.Id,dt,dt1, p);
    //end for case # 00052350
    PerformanceAchievementClass.coumputeCUSTOMERCOMPLAINTS(acc.Id,dt,dt1);
    PerformanceAchievementClass.computeWARRANTYCARDSNA(acc.Id,dt,dt1);
    // Done for case # 00064909
    // PerformanceAchievementClass.computeWARRANTYCARDSEU(acc.Id,dt,dt1);
    PerformanceAchievementClass.computeWARRANTYCARDSEU(acc.Id,dt,dt1,p);
    PerformanceAchievementClass.computeTRAININGASSDESIGN(acc.Id);
    PerformanceAchievementClass.computeEXTRABONUSI(acc.Id);
    PerformanceAchievementClass.computeEXTRABONUSII(acc.Id);
    
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
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
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
       /* Double b1 =PerformanceAchievementClass.coumputeSITEINSPECTIONNONCOMP(acx, dt,dt1);
        System.assertEquals(0.0,b1);
        PerformanceAchievementClass.coumputeSITEINSPECTIONEUSTAY(acx,dt,dt1);
        Double b2 = PerformanceAchievementClass.coumputeSITEINSPECTION(acx, dt,dt1);
        Double b32 = PerformanceAchievementClass.coumputeSITEINSPECTIONEU(acx, dt,dt1,t1.Id);
        Double b3 = PerformanceAchievementClass.computePERCENTINSTALLCRM(acx,dt,dt1);
        Boolean bl = PerformanceAchievementClass.computeTRAININGEXTRABONUS(acx);
        Double a1= PerformanceAchievementClass.computeTRAININGASSSALES(acx);
        Double dl = PerformanceAchievementClass.computeADVANCEPRODTRAINING(acx);
        Double d2 = PerformanceAchievementClass.computeBASICTRAININGEU(acx);
        PerformanceAchievementClass.computeBASICTRAINING(acx);
        Double d3 = PerformanceAchievementClass.computeCREDITLIMIT(acx);
        Boolean bl2 = PerformanceAchievementClass.computeSIXMONTHSASAUTHWITHTWENTYINSTALL(acx);*/
        //System.assertEquals(1.0,b2);
       // System.assertEquals(1.0,b32);
      /*  System.assertEquals(0.0,b3);
        System.assertEquals(false,bl);
        System.assertEquals(1.0,dl);
        System.assertEquals(0.0,d2);
        System.assertEquals(1000.0,d3);
        System.assertEquals(true,bl2);
        System.assertEquals(0.0,b1);*/
       
        Boolean bl3 = PerformanceAchievementClass.computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS(acx);
        Boolean bl4 = PerformanceAchievementClass.computeMINSALESAUTHZEU(acx);
        Boolean bl5 = PerformanceAchievementClass.computeACTIVEDEALER(acx,dt,dt1);
        Boolean bl6 = PerformanceAchievementClass.computeMINQUATSALESEUCLONE(acx,dt,dt1);
        Boolean bl7 = PerformanceAchievementClass.computeMINQUATSALESEU(acx,dt,dt1);
        Boolean bl8 = PerformanceAchievementClass.computeMINQUATSALESEU(acx,dt,dt1);
        Double b20 = PerformanceAchievementClass.computeSEVENTYSALESKITS(acx,dt,dt1);
        //Double b21 = PerformanceAchievementClass.computeSEVENTYRESKITSEU(acx,dt,dt1);
        //Added by Neeraj
        Double b21 = PerformanceAchievementClass.computeSEVENTYRESKITSEU(acx,dt,dt1,'Italy',10);
        Double b22 = PerformanceAchievementClass.computeSEVENTYCOMINVTREU(acx,dt,dt1);
        ///System.assertEquals(true,bl3);
        //System.assertEquals(false,bl4);
        //System.assertEquals(false,bl5);
        /*System.assertEquals(false,bl6);
        System.assertEquals(true,bl7);
        System.assertEquals(true,bl8);*/
        
        //System.assertEquals(0.0,b20);
        //System.assertEquals(false,b21);
        //System.assertEquals(false,b22);
        
        PerformanceAchievementClass.computeKWTARGETEU(acx,dt,dt1);
        PerformanceAchievementClass.computeSIXMONTHSTARGET(acx,dt,dt1);
        PerformanceAchievementClass.computeOPPCLOSERATE(acx);
        PerformanceAchievementClass.computeADVANCE_TRAINING_EU(acx);
        PerformanceAchievementClass.computeTWENTYINSTALLSASAUTH(acx);
        PerformanceAchievementClass.computeHUNDREDINSTALLSASPREM(acx);
        PerformanceAchievementClass.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(acx);
        PerformanceAchievementClass.getQuartesBetweenDates(dt4,dt5);

    /*Double dd=5.0;
    //start for case # 00052350
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
    //PerformanceAchievementClass.computeCSATSCORE(acc.Id,dt,dt1);
    PerformanceAchievementClass.computeCSATSCORE(acc.Id,dt,dt1, p);
    //end for case # 00052350
    PerformanceAchievementClass.checkCSATCount(acc.Id,dt,dt1,dd);
    //start for case # 00052350
    //PerformanceAchievementClass.computeCSATSURVEYREQ(acc.Id,dt,dt1);
    PerformanceAchievementClass.computeCSATSURVEYREQ(acc.Id,dt,dt1, p);
    //end for case # 00052350
    PerformanceAchievementClass.coumputeCUSTOMERCOMPLAINTS(acc.Id,dt,dt1);
    PerformanceAchievementClass.computeWARRANTYCARDSNA(acc.Id,dt,dt1);
    // Done for case # 00064909
    // PerformanceAchievementClass.computeWARRANTYCARDSEU(acc.Id,dt,dt1);
    PerformanceAchievementClass.computeWARRANTYCARDSEU(acc.Id,dt,dt1,p);
    PerformanceAchievementClass.computeTRAININGASSDESIGN(acc.Id);
    PerformanceAchievementClass.computeEXTRABONUSI(acc.Id);
    PerformanceAchievementClass.computeEXTRABONUSII(acc.Id);
    //PerformanceAchievementClass.computeCREDITLIMITEU(acc.Id);
    PerformanceAchievementClass.computeCREDITLIMITSRI(acc.Id);
    PerformanceAchievementClass.computeSIXMONTHSASAUTH(acc.Id);
    PerformanceAchievementClass.computeSIXMONTHSASPREM(acc.Id);
    PerformanceAchievementClass.computeRETROFITSOLARSYS(acc.Id);
    PerformanceAchievementClass.computeTRAININGASSINSTALL(acc.Id);*/
     
    //for case # 00052350
    /*Date sd= date.newinstance(2010,1,4);
    Date ed= date.newinstance(2010,7,4);
    Date ecd= date.newinstance(2010,7,31);
    Date mCd= date.newinstance(2009,12,1);
    Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= sd,Performance_period_End_date__c =ed ,Metric_Setup_Cut_off_Date__c =mCd,Performance_Evaluation_Cut_off_Date__c =ecd );
    insert p;
   
    Metric_Tier_Relation__c mtrNxt = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Enter_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated');
    insert mtrNxt;

    Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtrNxt.Id,Achievement_Value__c=0,Performance_Metric__c=p.Id,CurrencyIsoCode = 'USD');
    insert mobj;*/
    //for case # 00052350
    //Partner_Application__c Pa = new Partner_Application__c(Company_Name__c='abc',Account__c=acc.Id);
    //insert pa;
    /*PerformanceAchievementClass.automatedBooleanGoalCheck(mobj,mtrNxt,true);
    PerformanceAchievementClass.automatedDoubleGoalCheck(mobj,mtrNxt,dd); 
    PerformanceAchievementClass.automatedDoubleGoalCheckKW(mobj,mtrNxt,dd);
    PerformanceAchievementClass.getCurrentPerformancePeriod('Q3');
    PerformanceAchievementClass.getCurrentPerformancePeriod('Q');
    PerformanceAchievementClass.computeBGSMScore(acx);
    PerformanceAchievementClass.getQuartesBetweenDates(sd,ed);
    PerformanceAchievementClass.getQuartesBetweenDates(ed,sd);
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,2,4),date.newinstance(2010,3,4));
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,4,4),date.newinstance(2010,5,4));
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,6,4),date.newinstance(2010,8,4));
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,9,4),date.newinstance(2010,10,4));
    PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,11,4),date.newinstance(2010,12,4));  */  
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
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
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
        //start for case # 00052350
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
        
        PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,7,5),date.newinstance(2010,4,5));
        PerformanceAchievementClass.getQuartesBetweenDates(date.newinstance(2010,10,1),date.newinstance(2010,4,5));
        acc.Credit_Limit__c = null;
        update acc;
        PerformanceAchievementClass.computeCREDITLIMIT(acc.Id);
        acc.Credit_Limit__c = 50000;
        update acc; 
        PerformanceAchievementClass.computeCREDITLIMITEU(acc.Id);
        PerformanceAchievementClass.computeCREDITLIMITSRI(acc.Id);
        ods.Cumulative_No_of_Commercial_PV_orders__c = null;
        ods.Cumulative_No_of_Residential_PV_orders__c = null; 
    }
    
    public static testMethod void testPerfAch10(){
        Double a  = 1.0;
        Double b = 5.0;
        Double c = 3.0; 
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2006,12,30);
        Date dt2 = date.newinstance(2006,4,1);
        Date dt3 = date.newinstance(2006,6,30);
        Date dt4 = date.newinstance(2010,1,1);
        Date dt5 = date.newinstance(2010,12,30);
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
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
        //start for case # 00052350
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
        ods.Cumulative_No_of_Commercial_PV_orders__c = null;
        ods.Cumulative_No_of_Residential_PV_orders__c = null; 
        PerformanceAchievementClass.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(acc.Id);
        PerformanceAchievementClass.computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS(acc.Id);
    }

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
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        a=2.0;b=5.0;c=1.0;
        a=1.0;b=5.0;c=6.0;
        
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
        //start for case # 00052350
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
        PerformanceAchievementClass.computeCREDITLIMIT(acc.Id);
        acc.Credit_Limit__c = 50000;
        //update acc; 
        PerformanceAchievementClass.computeCREDITLIMITEU(acc.Id);
        PerformanceAchievementClass.computeCREDITLIMITSRI(acc.Id);
        ods.Cumulative_No_of_Commercial_PV_orders__c = null;
        ods.Cumulative_No_of_Residential_PV_orders__c = null;
   
 }

    
 public static testMethod void testOtherFunction(){

        Date dtAuthPartDate = date.newinstance(2006,1,1);
        Date dtPromotedPrmrDate = date.newinstance(2006,12,30);
        Date dtResInstlrDate = date.newinstance(2006,4,1);        
        Date dtValidFrom = date.newinstance(2006,1,1);
        Date dtValidTo = date.newinstance(2006,12,30);
        RecordType recordType = [select Id from RecordType where name= 'Partner'and SobjectType ='Account' limit 1];
        Account acc = new Account(name='testSun1',recordTypeId = recordType.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dtAuthPartDate ,Promoted_Premier_Date__c=dtPromotedPrmrDate ,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dtResInstlrDate ,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        order_detail_sunrise2__c ods = new order_detail_sunrise2__c(Performance_Period__c='P2',Quarter__c='Q4',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x',Total_Watts_Invoiced_CVAR__c=20.12,Sum_of_Watts_Invoiced_Smart_Pack__c=10,Racking_lines_inv_amt_Non_Smart_pack__c=10,Total_Watts_Invoiced_RVAR__c=0);
        insert ods;
        //order_detail_sunrise2__c ods1 = new order_detail_sunrise2__c(Performance_Period__c='P2',Quarter__c='Q4',year__c ='2010',Number_of_QTD_Residential_PV_Order__c =10,Cumulative_No_of_Commercial_PV_orders__c = 20,Account_Name__c =acc.Id,QTD_of_Commercial_orders_with_Inverter__c=10,QTD_of_Residential_SmartPack_orders__c=10,Cumulative_No_of_Residential_PV_orders__c=5,Number_of_QTD_Commercial_PV_Order__c=10,QTD_kW_for_Commercial_Orders__c=10,QTD_kW_for_Residential_Orders__c=5,Cumulative_kW_for_Commercial_Orders__c=10,Cumulative_kW_for_Residential_Orders__c=5,QTD_Net_Purchase_Amount__c=100,Oracle_Customer_No__c='140x',Total_Watts_Invoiced_CVAR__c=20.12,Sum_of_Watts_Invoiced_Smart_Pack__c=10,Racking_lines_inv_amt_Non_Smart_pack__c=10,Total_Watts_Invoiced_RVAR__c=10);
        //insert ods; 
        PerformanceAchievementClass.computeACTIVEDEALER_AUTHO(acc.Id,dtValidFrom ,dtValidTo );
        double result=PerformanceAchievementClass.computeWARRANTYCARDSEU_Exception2010(acc.Id,dtValidFrom ,dtValidTo );
        system.debug(result);
        
        result=PerformanceAchievementClass.computeBonusForOnlineOrdering(acc.Id,dtValidFrom ,dtValidTo );
        system.debug(result);   
        
        Boolean blnResult=PerformanceAchievementClass.isUpToDateWithPaymentEU(acc.Id);
        system.debug(blnResult);
         
        blnResult=PerformanceAchievementClass.IsSunpowerResidentialLoanProgramSignedEU(acc.Id);
        system.debug(blnResult);
       
        Date strtdt= date.newinstance(2010,1,4);
        Date enddt= date.newinstance(2010,7,4);
        Date ecd= date.newinstance(2010,7,31); 
        Date mCd= date.newinstance(2009,12,1);  
        
        Tier__c tier = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert tier;
        
        Performance_Metric__c perfMetricObj = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= strtdt,Performance_period_End_date__c =enddt ,Metric_Setup_Cut_off_Date__c =mCd,Performance_Evaluation_Cut_off_Date__c =ecd );
        insert perfMetricObj;
   
        Metric_Tier_Relation__c mtrTierRelnObj = new Metric_Tier_Relation__c(Performance_Metric__c =perfMetricObj.Id,Tier__c =tier.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Enter_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated');
        insert mtrTierRelnObj;

        Metric__c mObj = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtrTierRelnObj.Id,Achievement_Value__c=0,Performance_Metric__c=perfMetricObj.Id,CurrencyIsoCode = 'USD');
        insert mobj;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        User test_user =TestClassUtilities.getEUPartnerPortalUser(acc);
        System.runAs(test_user){ 
            //Start new context        
            Test.startTest();
            Test.stopTest();
        }
        Opportunity opp = new Opportunity(name='opp', StageName= '100% - Won',AccountId = acc.Id,business_Unit__c='UPP Intl',closedate=dtValidTo,OwnerId=test_user.Id);
        insert opp;
        
        Asset asObj = new Asset(Name='SPR-210-BLK',AccountId=acc.Id,quantity=1);
        insert asObj;
                
        Double archive=47.455;
        PerformanceAchievementClass.automatedBonusGoalCheck(mObj,mtrTierRelnObj,archive);
                
        String [] sValues=new String[]{'1','0','2','3'};
        PerformanceAchievementClass.inverterValue(sValues);                
              
        Decimal thershold=10.12; 
        PerformanceAchievementClass.isMoveToPremier(acc.Id,thershold);
       
        Double b21 = PerformanceAchievementClass.computeSEVENTYRESKITSEU(acc.id,dtValidFrom,dtValidTo,'Germany',10); 
        PerformanceAchievementClass.computeSEVENTYCOMINVTREU(acc.id,dtValidFrom,dtValidTo);
        PerformanceAchievementClass.computeRETROFITSOLARSYS(acc.Id);  
        
        PerformanceAchievementClass.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(acc.id);
        PerformanceAchievementClass.computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS(acc.id);
        PerformanceAchievementClass.Min_Sales_Experience_Autho_EU(acc.id);
        PerformanceAchievementClass.computeBonusForMINSALESAUTHZEU(acc.id);
        PerformanceAchievementClass.computeACTIVEDEALER(acc.id,dtValidFrom,dtValidTo);
        PerformanceAchievementClass.computeMINQUATSALESEUCLONE(acc.id,dtValidFrom,dtValidTo);
        PerformanceAchievementClass.computeMINQUATSALESEU(acc.id,dtValidFrom,dtValidTo);
        PerformanceAchievementClass.computeSEVENTYSALESKITS(acc.id,dtValidFrom,dtValidTo);
        PerformanceAchievementClass.computeSIXMONTHSASAUTHWITHTWENTYINSTALL(acc.id);
        PerformanceAchievementClass.computeWARRANTYCARDSEU_Exception2010(acc.id,dtValidFrom,dtValidTo);
        PerformanceAchievementClass.computeMINQUATSALESEU(acc.id,dtValidFrom,dtValidTo);
       
       /* 
        //Modified by Neeraj
        PerformanceAchievementClass.computeRETROFITSOLAR_NA(acc.id);
        PerformanceAchievementClass.smarterSelling_EU(acc.id,'Italy');
        PerformanceAchievementClass.fundamentalDesignSPFRTraining_EU(acc.id);
        PerformanceAchievementClass.fundamentalSALCORETraining_EU(acc.id);
        PerformanceAchievementClass.inspectionSRI_EU(acc.id, dtvalidFrom, dtvalidTo,perfMetricObj);
        PerformanceAchievementClass.inspectionAuthorised_EU(acc.id,dtvalidFrom,dtvalidTo, 'Premier','Italy',perfMetricObj);
        PerformanceAchievementClass.inspectionPremier_EU(acc.id, dtvalidFrom, dtvalidTo,  'Premier','Italy',perfMetricObj); 
        */
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
        PerformanceAchievementClass perAObj = new PerformanceAchievementClass();
        
        ///System.assertEquals(true,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=2.0;b=5.0;c=1.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        a=1.0;b=5.0;c=6.0;
        ///System.assertEquals(false,PerformanceAchievementClass.checkGoalMet(a,b,c));
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
        insert t1;
        Tier__c Tiert1 = new Tier__c(Country__c='Italy',Tier_Name__c='Authorized' );
        insert Tiert1;
        Tier__c Tiert2 = new Tier__c(Country__c='Italy',Tier_Name__c='SRI' );
        insert Tiert2;
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
        
        PerformanceAchievementClass.computeADVANCE_TRAINING_EU(acx);
        PerformanceAchievementClass.computeTWENTYINSTALLSASAUTH(acx);
        PerformanceAchievementClass.computeHUNDREDINSTALLSASPREM(acx);
        PerformanceAchievementClass.computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS(acx);
        PerformanceAchievementClass.getQuartesBetweenDates(dt4,dt5);

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
        PerformanceAchievementClass.automatedBooleanGoalCheck(mobj,mtrNxt,true);
        PerformanceAchievementClass.automatedDoubleGoalCheck(mobj,mtrNxt,dd); 
        PerformanceAchievementClass.automatedDoubleGoalCheckKW(mobj,mtrNxt,dd);
        PerformanceAchievementClass.getCurrentPerformancePeriod('Q3');
        //PerformanceAchievementClass.computeBGSMScore(acx);
        PerformanceAchievementClass.getQuartesBetweenDates(sd,ed);
        PerformanceAchievementClass.getQuartesBetweenDates(ed,sd);
    }
        
}