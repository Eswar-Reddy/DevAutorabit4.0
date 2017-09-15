/* **************************************************************************************
* Class Name     : CreateCashNTS_Test
* Version        : 1.0
* Created Date   : Feb 18 2017
* Function       : Test Class for CreateCashNTS

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                       Feb 18 2017         Original Version
*************************************************************************************/
@isTest(SeeAllData = false)
private class CreateCashNTS_Test {

     @testSetup
     static void setupData (){
           Id accRecordTypeId = TestClassFactory.retrieveRecordTypeID('Account','Residential Customer');
           Account acc = TestClassFactory.testAccount('Test Cash NTS',accRecordTypeId);
           insert acc;
           

           Id conRecordTypeId = TestClassFactory.retrieveRecordTypeID('Contact','Customer');
           Contact con = TestClassFactory.testContact('Test Cash NTS Contact', 'nts@cash.com', conRecordTypeId);
           con.AccountId = acc.Id;
           con.Include_in_Lease_Doc__c = true;
           Insert con;
           
           Account installer = TestClassFactory.CreateDealer('Dealer Test', 'North America');
           NH_Community__c community = TestClassFactory.testNHCommunity(installer.Id);
           community.Builder__c = installer.Id;
           insert community;
           
           Campaign TestCampaign = TestClassFactory.testCampaign('TestCampaign');
           TestCampaign.NH_Community__c = community.ID;
           insert TestCampaign;

           Id oppRecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner');
           Opportunity opp = TestClassFactory.testOpportunity('Cash NTS Opp', 'Closed/Won', system.today(),oppRecordTypeId);
           Opp.AccountId = acc.Id;
           opp.Plan_Type__c = 'Test Plan';
           opp.CampaignId = TestCampaign.Id;
           opp.Lot_Number__c = '100';
           Insert Opp;

           item__c item = new item__c ();
           item.Name = 'test';
           item.CurrencyIsoCode = 'USD';
           item.Description__c = 'test description';
           item.Long_Description__c = 'test long description';
           item.Item_ID__c = 'testdesignitem';
           item.active__c = true;
           item.Item_Category_3__c = '327';
           insert item;
         
           Quote Qt = TestClassFactory.createTestQuote(acc, opp);
           Qt.Sector__c = 'New Homes';
           Qt.QuoteType__c = 'Cash';
           Qt.Module_Oracle_Item_Number__c = item.Id;
           Qt.Is_Locked__c = true;
           Insert Qt;
           
           
           DocGen_Callout_Settings__c oDocGenCalloutSettings = new DocGen_Callout_Settings__c();
           oDocGenCalloutSettings.Name = 'DocGen';
           oDocGenCalloutSettings.EndPoint_Contract__c = 'https://dev-spec3.dev.sunpower.com/ws/docgen/proposal/proposal';
           oDocGenCalloutSettings.apiKey__c = 'DC97-20AF-567E';
           insert oDocGenCalloutSettings;
            
           TestClassFactory.createAndInsertLeaseAgreementSettings();
     }

    public static testmethod void CreateCashNTSTest(){
           Account acc = [select Id,Name,(select id,is_Locked__c from Quotes__r) from Account where Name = 'Test Cash NTS']; 
           Test.setCurrentPageReference(new PageReference('Page.CreateCashNTS'));
           system.currentPageReference().getParameters().put('Id',acc.Quotes__r[0].Id);  
           System.currentPageReference().getParameters().put('accId', acc.Id);
          
           CreateCashNTS CashNTS = new CreateCashNTS();
           CreateCashNTS.sendNTSRequestToDocgen();
        }
}