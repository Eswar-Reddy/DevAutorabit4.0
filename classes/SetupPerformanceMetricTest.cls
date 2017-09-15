@IsTest
public class SetupPerformanceMetricTest{
   @isTest(seeAllData=true)   
   static void test001(){
       Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c();
       Performance_Metric__c pm= new Performance_Metric__c();
       Performance_Metric__c p = new Performance_Metric__c(Peformance_Metric_Name__c='Italy1-Jan2010_to_Jun2010');
       insert p;
       Performance_Metric__c p1 = new Performance_Metric__c(Peformance_Metric_Name__c='Germany1-Jan2010_to_Jun2010');
       insert p1;
       Performance_Metric__c p2 = new Performance_Metric__c(Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010');
       insert p2;
       List<Performance_Metric__c>  pmList = [Select Id from Performance_Metric__c limit 200];
       system.debug('asc'+pmList.get(0).id);
       ApexPages.currentPage().getParameters().put('id','a0F80000004TH1TEAW'); //  pmList.get(0).id
       ApexPages.StandardController aps = new ApexPages.StandardController(pm);
       SetupPerformanceMetrics SetupPerformMetricObj = new SetupPerformanceMetrics(aps);
      
       SetupPerformMetricObj.copyMetricTierRecords(SetupPerformMetricObj.getCountry(),SetupPerformMetricObj.getPerformanceMetric().Channel__c,String.valueof(pmList.get(0).id)); 
       system.debug(SetupPerformMetricObj.getValidFrom());
       system.debug(SetupPerformMetricObj.getValidTo());
       system.debug(SetupPerformMetricObj.getCutOffDate());
       system.debug(SetupPerformMetricObj.getTheater());
       system.debug(SetupPerformMetricObj.getCountry());
      
       system.debug(SetupPerformMetricObj.getFreezeMetric());
       system.debug(SetupPerformMetricObj.getMarketAddRow());
       system.debug(SetupPerformMetricObj.getFreezeRSMMetric());
       system.debug(SetupPerformMetricObj.getShowAccountView());
       PageReference saveObj1Page = SetupPerformMetricObj.saveObj();
      
      
       SetupPerformMetricObj.selectedTier = 'Premier';
       Tier__c t = new Tier__c(Country__c='USA',Tier_Name__c='Premier' );
       insert t;
       Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Premier' );
       insert t1;
       Tier__c t2 = new Tier__c(Country__c='Germany',Tier_Name__c='Premier' );
       insert t2;
       List<Tier__c> currentTierObj = [select Tier_Name__c from Tier__c where Tier_Name__c =:SetupPerformMetricObj.selectedTier limit 200 ];
       String accid = SetupPerformMetricObj.accountId;
       String tierId = currentTierObj.get(0).Id;
       SetupPerformMetricObj.addRowNewRSMRows2(accid,tierId);
       SetupPerformMetricObj.filterTierDropDown();
     
     
       PageReference saveRMSRowpage = SetupPerformMetricObj.saveRSMRows();
       SetupPerformMetricObj.updateRSMRows();
       
        List<Metric_Tier_Relation__c> lstCustSatisfTier1 = SetupPerformMetricObj.getCustomerSatisfactionTier1List();
        List<Metric_Tier_Relation__c> lstCustSatisfTier2 = SetupPerformMetricObj.getCustomerSatisfactionTier2List();
        List<Metric_Tier_Relation__c> lstCustSatisfTier3 = SetupPerformMetricObj.getCustomerSatisfactionTier3List();
        List<Tier__c>  tierLst = SetupPerformMetricObj.getTierList();
        Double pdfTier1 = SetupPerformMetricObj.getPdfTier1();
        
        Date dt1 = date.newinstance(2006,12,30);
        system.debug(SetupPerformMetricObj.getDateFormat(dt1));
        
        ApexPages.currentPage().getParameters().put('marketing1rows','4');
        ApexPages.currentPage().getParameters().put('row1Label4','metricLabel1');
        ApexPages.currentPage().getParameters().put('boolean1Metric4','on');
        ApexPages.currentPage().getParameters().put('stayTier14','on');
        ApexPages.currentPage().getParameters().put('enterTier14','on');
        ApexPages.currentPage().getParameters().put('benefitTier14','on');
        ApexPages.currentPage().getParameters().put('allowPartner14','on');
        ApexPages.currentPage().getParameters().put('incentive14','20');
        ApexPages.currentPage().getParameters().put('marketing2rows','12');
        ApexPages.currentPage().getParameters().put('row2Label12','metricLabel2');
        ApexPages.currentPage().getParameters().put('boolean2Metric12','on');
        ApexPages.currentPage().getParameters().put('stayTier212','on');
        ApexPages.currentPage().getParameters().put('enterTier212','on');
        ApexPages.currentPage().getParameters().put('benefitTier212','on');
        ApexPages.currentPage().getParameters().put('allowPartner212','on');
        ApexPages.currentPage().getParameters().put('incentive212','30');
        ApexPages.currentPage().getParameters().put('marketing3rows','20');
        ApexPages.currentPage().getParameters().put('row3Label20','metricLabel3');
        ApexPages.currentPage().getParameters().put('boolean3Metric20','on');
        ApexPages.currentPage().getParameters().put('stayTier320','on');
        ApexPages.currentPage().getParameters().put('enterTier320','on');
        ApexPages.currentPage().getParameters().put('benefitTier320','on');
        ApexPages.currentPage().getParameters().put('allowPartner320','on');
        ApexPages.currentPage().getParameters().put('incentive320','40');
        PageReference saveMktObjPage = SetupPerformMetricObj.saveMarketingObj(); 
        SetupPerformMetricObj.updateRSMRows();
        
        Date dt5 = date.newinstance(2006,12,30);
        SetupPerformMetricObj.periodEndDate = dt5;
        SetupPerformMetricObj.getFreezeRSMMetric();

        
    }
    
    @isTest(seeAllData=true)   
    static void test002(){
        User usr = [Select id from User where Country_Domain__c = 'rvar-it' and isActive = true limit 1 ];
        system.RunAs(usr){
            Performance_Metric__c pm= new Performance_Metric__c();
            Performance_Metric__c p = new Performance_Metric__c(Peformance_Metric_Name__c='Italy1-Jan2010_to_Jun2010');
       insert p;
            List<Performance_Metric__c>  pmList = [Select Id from Performance_Metric__c where Country__c ='Italy' ];
            ApexPages.currentPage().getParameters().put('id',pmList.get(0).id);
            ApexPages.StandardController aps = new ApexPages.StandardController(p);
            Date dt = date.newinstance(2006,1,1);
            Date dt1 = date.newinstance(2006,12,30);
            Account acc = new Account(name='testSun1',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908');
            insert acc;
            String accId = acc.Id;
            Tier__c tObj = [select Id,Tier_Name__c,Country__c from Tier__c where Tier_Name__c='Premier' and Country__c='Italy'];
            String TId = tObj.Id;
            SetupPerformanceMetrics SetupPerformMetricObj = new SetupPerformanceMetrics(aps);
            ApexPages.currentPage().getParameters().put('rsmrows','2');
            ApexPages.currentPage().getParameters().put('row1Labelrsm2','Warranty cards receivedWarranty cards received');
            ApexPages.currentPage().getParameters().put('stayTier1rsm2','True');
            ApexPages.currentPage().getParameters().put('enterTier1rsm2','False');
            ApexPages.currentPage().getParameters().put('benefitTier1rsm2','True');
            ApexPages.currentPage().getParameters().put('incentive1rsm2','10');
            SetupPerformMetricObj.performanceMetricId = pmList.get(0).id;
            SetupPerformMetricObj.addRowNewRSMRows(accId,TId);
           
            Double a = 1.0,b=2.0,c= 3.0;
            SetupPerformMetricObj.setPdfTier1(a);
            system.debug('PdfT2'+SetupPerformMetricObj.getPdfTier2());
            SetupPerformMetricObj.setPdfTier2(b);
            system.debug('PdfT3'+SetupPerformMetricObj.getPdfTier3());
            SetupPerformMetricObj.setPdfTier3(c);
            SetupPerformanceMetrics.MetricsDetails md = new SetupPerformanceMetrics.MetricsDetails();
            system.debug(SetupPerformMetricObj.getTier1Label());
            system.debug(SetupPerformMetricObj.getTier2Label());
            system.debug(SetupPerformMetricObj.getTier3Label());
            system.debug(SetupPerformMetricObj.getTrainingTier1List());
            system.debug(SetupPerformMetricObj.getTrainingTier2List());
            system.debug(SetupPerformMetricObj.getTrainingTier3List());
            system.debug(SetupPerformMetricObj.getPerformanceToBPTier1List());
            system.debug(SetupPerformMetricObj.getPerformanceToBPTier2List());
            system.debug(SetupPerformMetricObj.getPerformanceToBPTier3List());
            system.debug(SetupPerformMetricObj.getSpwrSolutionTier1List());
            system.debug(SetupPerformMetricObj.getSpwrSolutionTier2List());
            system.debug(SetupPerformMetricObj.getSpwrSolutionTier3List());
            system.debug(SetupPerformMetricObj.getMarketingTier1List());
            system.debug(SetupPerformMetricObj.getMarketingTier2List());
            system.debug(SetupPerformMetricObj.getMarketingTier3List());
            list<SetupPerformanceMetrics.MetricsDetails> mdlis = new list<SetupPerformanceMetrics.MetricsDetails>();
            system.debug(SetupPerformMetricObj.getAccOptionList());
            system.debug(SetupPerformMetricObj.getAccountList());
            system.debug(SetupPerformMetricObj.getRsmList());
            system.debug(SetupPerformMetricObj.getAccountId());
            system.debug(SetupPerformMetricObj.getSelectedTier());
            system.debug(SetupPerformMetricObj.getTiers());
            SetupPerformMetricObj.setSelectedTier('Premier');
            SetupPerformMetricObj.setAccountId(accId);
            SetupPerformMetricObj.setRsmList(mdlis);
            SetupPerformMetricObj.setValidFrom('01/02/2010');
            SetupPerformMetricObj.setValidTo('02/03/2010');
            SetupPerformMetricObj.setCutOffDate('01/01/2010');
            SetupPerformMetricObj.setAccountList('abc');
            Metric_Tier_Relation__c mt = new Metric_Tier_Relation__c();
            Metric__c m = new Metric__c();
            md.setMetric(m);
            md.setmeetricTierRel(mt);
            system.debug(md.getMetric());
            system.debug(md.getmeetricTierRel());
            PageReference gtperf = SetupPerformMetricObj.goToperformanceEvalPage();
            //SetupPerformMetricObj.rsmList.size()=3;
            
            List<Metric__c> list1 = [Select Id from Metric__c limit 1];
            list1.get(0).Metric_Min_Value__c = 0;
            list1.get(0).Metric_Max_Value__c = 0;
            list1.get(0).Incentive_Amount__c = 0;
            SetupPerformMetricObj.removeEmptyMetricFields(list1);
            
            PDF_Limit__c  pdfLmt = SetupPerformMetricObj.newPDFObj(pmList.get(0).id,TId,a);
            SetupPerformMetricObj.setPdfTier1(null);
            SetupPerformMetricObj.setPdfTier2(null);
            SetupPerformMetricObj.setPdfTier3(null);
            SetupPerformMetricObj.saveOrUpdatePDF();
             SetupPerformMetricObj.selectedTier = 'SRI';
             //SetupPerformMetricObj.filterTierDropDown();
            
                        
        }
    } 
    
    @isTest(seeAllData=true)   
    static void test003(){
       // UserRole userr = [select Id, name from UserRole where name='Regional Sales Manager'];

        List<User> usr = [Select id from User where IsActive = true AND Profile.Name = 'SunPower User' AND Country_Domain__c = 'rvar-de' AND Userrole.Name like 'Regional Sales Manager%' limit 1 ]; //Country_Domain__c = 'rvar-de' and userroleId =:userr.Id li //for production use Id 00580000002hyEO sandbox 00580000001mkth
        if(!usr.isEmpty()){
            system.RunAs(usr.get(0)){
                Performance_Metric__c pm= new Performance_Metric__c();
                Performance_Metric__c p1 = new Performance_Metric__c(Peformance_Metric_Name__c='Germany1-Jan2010_to_Jun2010');
                insert p1;
                List<Performance_Metric__c>  pmList = [Select Id from Performance_Metric__c where Country__c ='Germany' ];
                ApexPages.currentPage().getParameters().put('id',pmList.get(0).id);
                ApexPages.StandardController aps = new ApexPages.StandardController(p1);
                SetupPerformanceMetrics SetupPerformMetricObj = new SetupPerformanceMetrics(aps);
                List<SelectOption> selOp = SetupPerformMetricObj.checkAccountList('Residential Installer');
            }
        }
        
        
        List<User> usr1 = [Select id from User where IsActive = true AND Profile.Name = 'SunPower Sales User' AND Country_Domain__c = 'rvar-us' AND Userrole.Name like '%Regional Sales Manager%' limit 1  ]; //Country_Domain__c = 'rvar-us' and userroleId =:userr.Id
        if(!usr1.isEmpty()){
            system.RunAs(usr1.get(0)){
                Performance_Metric__c pm1= new Performance_Metric__c();
                Performance_Metric__c p2 = new Performance_Metric__c(Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010');
                insert p2;
                List<Performance_Metric__c>  pmList1 = [Select Id from Performance_Metric__c where Country__c ='USA' ];
                ApexPages.currentPage().getParameters().put('id',pmList1.get(0).id);
                ApexPages.StandardController aps1 = new ApexPages.StandardController(p2);
                SetupPerformanceMetrics SetupPerformMetricObj1 = new SetupPerformanceMetrics(aps1);
                SetupPerformMetricObj1.saveOrUpdatePDF();
            }
        }
       /* Profile p = [select id from profile where name='EU Partner Delegated Administrator'];
        usr.profileid = p.id;
        Update usr;
        //User usr2 = [select Id from User where profileid =:p.id and isactive = true limit 1];
        system.RunAs(usr){
            Performance_Metric__c pm1= new Performance_Metric__c();
            List<Performance_Metric__c>  pmList1 = [Select Id from Performance_Metric__c where Country__c ='USA' ];
            ApexPages.currentPage().getParameters().put('id',pmList1.get(0).id);
            ApexPages.StandardController aps1 = new ApexPages.StandardController(pm1);
            SetupPerformanceMetrics SetupPerformMetricObj1 = new SetupPerformanceMetrics(aps1);
            SetupPerformMetricObj1.saveOrUpdatePDF();
            system.debug(SetupPerformMetricObj1.getMarketAddRow());
            system.debug(SetupPerformMetricObj1.getShowAccountView());
            system.debug(SetupPerformMetricObj1.getFreezeMetric());
            List<SelectOption> selOp = SetupPerformMetricObj1.checkAccountList('Residential Installer');
        }*/
    }
 
 }