/*******************************************
**Created by - Sreekanth
**Created On - July 07 2010
**Last Modified On- 
**Last Modifiled by- 
**Description- Test Class for ForecastCategoryExtension
********************************************/
@IsTest
public class TestForecastCategoryExtension{
    static testMethod void testforecast(){
    Date dt =Date.newinstance(2010,03,03);
    Account acc = new Account(Name = 'testaccc',CurrencyIsoCode = 'USD', Account_Status__c = 'Active',SPWR_Relationship_Type__c = 'Off-Taker',BillingStreet = 'West Mare',BillingCity = 'SanFrancisco',BillingPostalCode = '2345', BillingCountry = 'United States of America',Phone = '1234');
    insert acc;
    Opportunity o = new Opportunity(Name = 'TestOpp',StageName= 'Budgetary Pricing',Business_Unit__c='RLC',CloseDate=dt,AccountId = acc.ID);
    Insert o;
    
    
      ApexPages.StandardController aps = new ApexPages.StandardController(o);
       ForecastCategoryExtension fc = new ForecastCategoryExtension(aps);

         }
}