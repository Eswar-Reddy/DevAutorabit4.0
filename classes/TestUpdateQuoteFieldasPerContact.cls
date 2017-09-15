@isTest(seeAllData = true)
public class TestUpdateQuoteFieldasPerContact{
    //Test Method to cover UpdateQuoteFieldasPerContact Trigger.
    static testMethod void testUpdateQuoteFieldasPerContact(){
    	//Create account
        List<RecordType> LstRec = [SELECT Name, SobjectType,IsPersonType FROM RecordType WHERE SobjectType='Residential Customer'];
        
        Account newAccount = new Account();
        newAccount.Name = 'Test AccountQuote1';
        newAccount.Type ='Home Owner';
        newAccount.BillingCity = 'Cassis';
        newAccount.BillingStreet = 'Cassis';
        newAccount.BillingPostalCode ='13260';
        newAccount.BillingCountry = 'France'; 
        newAccount.Country_Domain__c = 'rvar-fr';
       // newAccount.RecordType.ID = LstRec[0].ID;
        insert newAccount;
        
        //Create Contact
        List<contact> conlist = new List<contact>();
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        con.Include_in_Lease_Doc__c = true;
        insert con;
        
                
        Contact con2;
        con2 = TestUtils.createContact( 'testcon2', newAccount.id, false);
        con2.Phone = '22 33 44 55 33';
        con2.Include_in_Lease_Doc__c = true;
        insert con2;
        
         //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, newAccount.id, con.id, false).get(0);
        insert newOpportunity;
        
        //Create Quote
        List<Quote> quotelst = new List<quote>();
        Quote newQuote;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test', newOpportunity.Id, false).get(0);
        newQuote.Account__c  = newAccount.Id;
        newQuote.PrimaryContact__c = con.Id;
        newQuote.Quote_Steps__c = 'Binding Offer' ;
        newQuote.Status = 'Approved' ;
        //insert newQuote;
        quotelst.add(newQuote);
        
        Quote newQuote2;
        newQuote2 = TestUtils.createQuotes( 1, 'Quick Quote Test2', newOpportunity.Id, false).get(0);
        newQuote2.Account__c  = newAccount.Id;
        newQuote2.PrimaryContact__c = null;
        newQuote2.Quote_Steps__c = 'Binding Offer' ;
        newQuote.primarycontact__c = null ;
        newQuote2.Status ='Approved' ;
        
        //insert newQuote2;
        quotelst.add(newQuote2);
        insert quotelst;
        
        con.FirstName = 'test222';
        con.LastName = 'con1222';
        con.Primary__c = true;
        conlist.add(con);
        
     /*   con2.FirstName = 'test22233';
        con2.LastName = 'con122233';
        con2.Primary__c = true;
        conlist.add(con2);*/
        
        upsert conlist;
        
        
       
    }
    
    static testMethod void testUpdateQuoteFieldasPerContact4(){
    	//Create account
        
        Account newAccount = new Account();
        newAccount.Name = 'Test AccountQuote1';
        newAccount.Type ='Home Owner';
        newAccount.BillingCity = 'Cassis';
        newAccount.BillingStreet = 'Cassis';
        newAccount.BillingPostalCode ='13260';
        newAccount.BillingCountry = 'France'; 
        newAccount.Country_Domain__c = 'rvar-fr';
       // newAccount.RecordType.ID = LstRec[0].ID;
        insert newAccount;
        
        //Create Contact
        List<contact> conlist = new List<contact>();
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
        List<Quote> quotelst = new List<quote>();
        Quote newQuote;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test', newOpportunity.Id, false).get(0);
        newQuote.Account__c  = newAccount.Id;
        newQuote.PrimaryContact__c = null;
        newQuote.Quote_Steps__c = 'Binding Offer' ;
        newQuote.Status = 'Approved' ;
        //insert newQuote;
        quotelst.add(newQuote);
        
        insert quotelst;
        
        con.FirstName = 'test222';
        con.LastName = 'con1222';
        con.Primary__c = true;
        conlist.add(con);
        
     /*   con2.FirstName = 'test22233';
        con2.LastName = 'con122233';
        con2.Primary__c = true;
        conlist.add(con2);*/
        
        upsert conlist;
        
        
       
    }
    
    
    static testMethod void testUpdateQuoteFieldasPerContact2(){
    	//Create account
        
        Account newAccount = new Account();
        newAccount.Name = 'Test AccountQuote1';
        newAccount.Type ='Home Owner';
        newAccount.BillingCity = 'Cassis';
        newAccount.BillingStreet = 'Cassis';
        newAccount.BillingPostalCode ='13260';
        newAccount.BillingCountry = 'France'; 
        newAccount.Country_Domain__c = 'rvar-fr';
       // newAccount.RecordType.ID = LstRec[0].ID;
        insert newAccount;
        
        //Create Contact
        List<contact> conlist = new List<contact>();
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        con.Include_in_Lease_Doc__c = true;
        insert con;
        
                
        Contact con2;
        con2 = TestUtils.createContact( 'testcon2', newAccount.id, false);
        con2.Phone = '22 33 44 55 33';
        con2.Include_in_Lease_Doc__c = true;
        insert con2;
        
         //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, newAccount.id, con.id, false).get(0);
        insert newOpportunity;
        
        //Create Quote
        List<Quote> quotelst = new List<quote>();
        Quote newQuote;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test', newOpportunity.Id, false).get(0);
        newQuote.Account__c  = newAccount.Id;
        newQuote.PrimaryContact__c = con.Id;
        newQuote.Quote_Steps__c = 'Binding Offer' ;
        newQuote.Status = 'Approved' ;
        newQuote.primarycontact__c = null ;
        //insert newQuote;
        quotelst.add(newQuote);
        
        Quote newQuote2;
        newQuote2 = TestUtils.createQuotes( 1, 'Quick Quote Test2', newOpportunity.Id, false).get(0);
        newQuote2.Account__c  = newAccount.Id;
        newQuote2.PrimaryContact__c = con.Id;
        newQuote2.Quote_Steps__c = 'Binding Offer' ;
        newQuote2.Status ='Approved' ;
        
        //insert newQuote2;
        quotelst.add(newQuote2);
        insert quotelst;
        
        con.FirstName = 'test222';
        con.LastName = 'con1222';
        con.Primary__c = true;
        conlist.add(con);
        
        con2.FirstName = 'test22233';
        con2.LastName = 'con122233';
        con2.Primary__c = true;
        conlist.add(con2);
        
        upsert conlist;
        
        
       
    }
    static testMethod void testUpdateQuoteFieldasPerContact3(){
    	//Create account
        
        Account newAccount = new Account();
        newAccount.Name = 'Test AccountQuote1';
        newAccount.Type ='Home Owner';
        newAccount.BillingCity = 'Cassis';
        newAccount.BillingStreet = 'Cassis';
        newAccount.BillingPostalCode ='13260';
        newAccount.BillingCountry = 'US'; 
        newAccount.Country_Domain__c = 'rvar-fr';
       // newAccount.RecordType.ID = LstRec[0].ID;
        insert newAccount;
        
        //Create Contact
        List<contact> conlist = new List<contact>();
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        con.Include_in_Lease_Doc__c = true;
        insert con;
        
                
        Contact con2;
        con2 = TestUtils.createContact( 'testcon2', newAccount.id, false);
        con2.Phone = '22 33 44 55 33';
        con2.Include_in_Lease_Doc__c = true;
        insert con2;
        
         //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, newAccount.id, con.id, false).get(0);
        insert newOpportunity;
        
        //Create Quote
        List<Quote> quotelst = new List<quote>();
        Quote newQuote;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test', newOpportunity.Id, false).get(0);
        newQuote.Account__c  = newAccount.Id;
        newQuote.PrimaryContact__c = con.Id;
        newQuote.Quote_Steps__c = 'Binding Offer' ;
        newQuote.Status = 'Approved' ;
        newQuote.primarycontact__c = null ;
        //insert newQuote;
        quotelst.add(newQuote);
        
        Quote newQuote2;
        newQuote2 = TestUtils.createQuotes( 1, 'Quick Quote Test2', newOpportunity.Id, false).get(0);
        newQuote2.Account__c  = newAccount.Id;
        newQuote2.PrimaryContact__c = con.Id;
        newQuote2.Quote_Steps__c = 'Binding Offer' ;
        newQuote2.Status ='Approved' ;
        
        //insert newQuote2;
        quotelst.add(newQuote2);
        insert quotelst;
        
        con.FirstName = 'test222';
        con.LastName = 'con1222';
        con.Primary__c = true;
        conlist.add(con);
        
        con2.FirstName = 'test22233';
        con2.LastName = 'con122233';
        con2.Primary__c = true;
        conlist.add(con2);
        
        upsert conlist;
        
        
       
    }
}