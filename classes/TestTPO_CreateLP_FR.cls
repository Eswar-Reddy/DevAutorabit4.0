/*** Test Class added in Sunpower TPO Phase 1 -- 20/10/2013, to cover TPO_CreateLP_FR class ***/  
//@isTest(seeAllData = true)
Public Class TestTPO_CreateLP_FR{/*
    //Test Method to cover TPO_CreateLP_FR Class.
    static testMethod void testTPO_CreateLP_FR(){
        
        Account newAccount;
        newAccount = [Select ID from Account Where Name='Test Class DO NOT TOUCH'];
        
        //Create Contact
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        insert con;
        
        //Create Quote
        Quote newQuote;
        Opportunity newOpportunity;
        newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.PrimaryContact__c = con.id;
        insert newQuote;
        
        apexPages.currentPage().getParameters().put('qid',newQuote.id);
        TPO_CreateLP_FR createLP = new TPO_CreateLP_FR();
        createLP.CreateLP();
    }*/
}