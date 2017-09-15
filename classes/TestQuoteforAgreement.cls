@isTest(seeAllData = true)
public class TestQuoteforAgreement{
 	//Test Method to cover QuoteforAgreement Trigger.
    static testMethod void testQuoteforAgreement(){
    	//create account
        Account newAccount = new Account();
        newAccount.Name = 'Test AccountQuote';
        newAccount.Type ='Home Owner';
        newAccount.BillingCity = 'Cassis';
        newAccount.BillingStreet = 'Cassis';
        newAccount.BillingPostalCode ='13260';
        newAccount.BillingCountry = 'France'; 
        newAccount.Country_Domain__c = 'rvar-fr';
        insert newAccount;
        
        //Create Contact
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        con.Include_in_Lease_Doc__c = true;
        insert con;
        
        //Create Contact
        Contact con1;
        con1 = TestUtils.createContact( 'testcon1', newAccount.id, false);
        con1.Phone = '22 33 44 55 66';
        con1.Include_in_Lease_Doc__c = true;
        insert con1;
       	
        
        //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, newAccount.id, con.id, false).get(0);
        insert newOpportunity;
        
        //Create Quote
        Quote newQuote;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        insert newQuote;
    }
    
    static testMethod void testQuoteforAgreement1(){
    	//create account
        Account newAccount = new Account();
        newAccount.Name = 'Test AccountQuote1';
        newAccount.Type ='Home Owner';
        newAccount.BillingCity = 'Cassis';
        newAccount.BillingStreet = 'Cassis';
        newAccount.BillingPostalCode ='13260';
        newAccount.BillingCountry = 'France'; 
        newAccount.Country_Domain__c = 'rvar-fr';
        insert newAccount;
        
        //create Contact
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        con.Include_in_Lease_Doc__c = true;
        insert con;
        
        //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, newAccount.id, con.id, false).get(0);
        insert newOpportunity;
        
        //Create Quote
        Quote newQuote;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        insert newQuote;
    }
    
    static testMethod void testQuoteforAgreement2(){
    	
        //Create Account
        Account acc = new Account(Name = 'tesee', Account_Status__c = 'Active', 
                            BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234');
        insert acc;
        
        //Create Contact
        Contact con;
        con = TestUtils.createContact( 'testconAgg', acc.id, false);
        con.Phone = '22 33 44 55 77';
        con.Include_in_Lease_Doc__c = true;
        insert con;
        
        Contact con1;
        con1 = TestUtils.createContact( 'testconAgg1', acc.id, false);
        con1.Phone = '22 33 44 55 77';
        con1.Include_in_Lease_Doc__c = true;
        insert con1;
        
         //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, acc.id, con.id, false).get(0);
        insert newOpportunity;
        
        //Create Quote
        Quote newQuote;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        insert newQuote;
    }
    
     static testMethod void testQuoteforAgreement3(){
    	
        //Create Account
        Account acc = new Account(Name = 'testee', Account_Status__c = 'Active', 
                            BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234');
        insert acc;
        
        //Create Contact
        Contact con;
        con = TestUtils.createContact( 'testconAgr', acc.id, false);
        con.Phone = '22 33 44 55 77';
        con.Include_in_Lease_Doc__c = true;
        insert con;
        
         //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, acc.id, con.id, false).get(0);
        insert newOpportunity;
        
        //Create Quote
        Quote newQuote;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        insert newQuote;
    }
}