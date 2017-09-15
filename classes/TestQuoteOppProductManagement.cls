/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller OpportunityValuesController 
*****************************************************/

public class TestQuoteOppProductManagement{
  @isTest
  public static void testQuoteOppProductManagement(){
            
    Account acct = new Account();
    acct.Name = 'TestDuplicate';
    acct.Type ='Commercial'; 
    acct.billingCity = 'TestCity';
    acct.BillingCountry = 'TestCountry';
    acct.BillingPostalCode = '12345';
    acct.BillingState = 'TestState';
    acct.BillingStreet = 'TestStreet';   
    insert acct;
     
    Opportunity opp = new Opportunity();
    opp.AccountId = acct.Id;
    opp.Name = 'testOpp';
    opp.CloseDate = System.today().addDays(14);
    opp.Sales_Steps__c = 'Shortlisted';
    opp.Contract_Type__c = 'Design';
    opp.Financing__c = 'PPA';
    opp.Business_Unit__c = 'Utility';
    opp.Region__c = 'New York';
    opp.StageName = 'Open';
    opp.Probability = 5;
    opp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
    insert opp;
    
    Quote qt = new Quote();
    qt.Name = 'test';
    
    qt.OpportunityId = opp.ID;
    insert qt;
             
    QuoteOppProductManagement.syncProduct(qt.ID);
  }
}