@isTest
private class TestPrevLinksIntermediateController {
     
    public static testMethod void testPrevLinks1(){
       Account testAcc;
        List<Account> accList = [Select Id from account where Theater__c='North America' and Country_Domain__c != null and (country_domain__c='cvar-us' or country_domain__c='combo-us')  limit 10];
        if(accList.size() > 0){
            testAcc = accList.get(0);
        }else{
            RecordType r = [select Id from RecordType where name= 'Partner' and SobjectType ='Account' limit 1];
            testAcc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Partner-Commerical',CurrencyIsoCode='USD',Country_Domain__c ='cvar-us',Theater__c='North America',Num_Open_Opportunities__c=10,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        }
        Test.setCurrentPage(Page.EvalPrevLinksIntermediate);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accId', testAcc.Id);
        ApexPages.currentPage().getParameters().put('period', '2');
        ApexPages.currentPage().getParameters().put('year', '2010');
        ApexPages.currentPage().getParameters().put('pageType', 'Evaluation');
        PrevLinksIntermediateController controller = new PrevLinksIntermediateController();
        controller.redirectAction();
        Test.stopTest();
        
    }
    
    public static testMethod void testPrevLinks2(){
       
        Account testAcc;
        List<Account> accList = [Select Id from account where Theater__c='North America'  and Country_Domain__c != null and (country_domain__c='cvar-us' or country_domain__c='combo-us') limit 10];
        if(accList.size() > 0){
            testAcc = accList.get(0);
        }else{
            RecordType r = [select Id from RecordType where name= 'Partner' and SobjectType ='Account' limit 1];
            testAcc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Partner-Commerical',CurrencyIsoCode='USD',Country_Domain__c ='cvar-us',Theater__c='North America',Num_Open_Opportunities__c=10,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        }
        Test.setCurrentPage(Page.EvalPrevLinksIntermediate);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accId', testAcc.Id);
        ApexPages.currentPage().getParameters().put('period', '2');
        ApexPages.currentPage().getParameters().put('year', '2010');
        ApexPages.currentPage().getParameters().put('pageType', 'Incentive');
        PrevLinksIntermediateController controller = new PrevLinksIntermediateController();
        controller.redirectAction();
        Test.stopTest();
        
    }
    
    public static testMethod void testPrevLinks3(){
        Account testAcc;
        List<Account> accList = [Select Id from account where Theater__c='Europe'  and Country_Domain__c != null and (country_domain__c='rvar-de' or country_domain__c='rvar-it' or country_domain__c='combo-it') limit 10];
        if(accList.size() > 0){
            testAcc = accList.get(0);
        }else{
            RecordType r = [select Id from RecordType where name= 'Partner' and SobjectType ='Account' limit 1];
            testAcc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Num_Open_Opportunities__c=10,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        }
        Test.setCurrentPage(Page.EvalPrevLinksIntermediate);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accId', testAcc.Id);
        ApexPages.currentPage().getParameters().put('period', '2');
        ApexPages.currentPage().getParameters().put('year', '2010');
        ApexPages.currentPage().getParameters().put('pageType', 'Incentive');
        PrevLinksIntermediateController controller = new PrevLinksIntermediateController();
        controller.redirectAction();
        Test.stopTest();
    }
    
    public static testMethod void testPrevLinks4(){
        Account testAcc;
        List<Account> accList = [Select Id from account where type='Authorized-Partner-Combo'limit 10];
        if(accList.size() > 0){
            testAcc = accList.get(0);
        }else{
            RecordType r = [select Id from RecordType where name= 'Partner' and SobjectType ='Account' limit 1];
            testAcc = new Account(name='testSun1',recordTypeId = r.Id,Credit_Limit__c=1000,type = 'Authorized-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='cvar-combo',Theater__c='Europe',Num_Open_Opportunities__c=10,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        }
        Test.setCurrentPage(Page.EvalPrevLinksIntermediate);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accId', testAcc.Id);
        ApexPages.currentPage().getParameters().put('period', '2');
        ApexPages.currentPage().getParameters().put('year', '2010');
        ApexPages.currentPage().getParameters().put('pageType', 'Incentive');
        PrevLinksIntermediateController controller = new PrevLinksIntermediateController();
        controller.redirectAction();
        Test.stopTest();
    }
}