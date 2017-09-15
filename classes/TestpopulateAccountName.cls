@IsTest
public class TestpopulateAccountName{
    
   @isTest(seeAllData=true) static void tst001(){
    Date dt  = date.newinstance(2010,1,4);
    Date dt1  = date.newinstance(2010,7,4);
    Date dt3  = date.newinstance(2010,12,4);
            Account acc = new Account(name='SunriseAcc',Credit_Limit__c=1000,type = 'Residential Installer',CurrencyIsoCode='USD',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,Num_Open_Opportunities__c=10,Residential_Installer_Date__c=dt3,BillingCity='New York',BillingCountry ='abc',BillingStreet='abc',BillingPostalCode='908',Oracle_Account_Number__c='123');
            insert acc;
            order_detail_sunrise2__c od = new order_detail_sunrise2__c(Oracle_Customer_No__c='123');    
            insert od;
    }
}