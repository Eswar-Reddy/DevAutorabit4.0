/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to Cover QuoteCloneWithItemsController Class***/
@isTest(seeAllData=true)
private class TestQuoteCloneWithItemsController {/*
 
    static testMethod void testQOCloneController() {
 

 
        // setup a ship to account
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;
 
newAccount = [Select ID,sales_Tax_Rate__c,Income__c,Default_Image__c, 
         (SELECT Id,
                                    Name,
                                    Current_rate_code__c,
                                    Current_Rate__c,
                                    Annual_Usage__c,
                                    Annual_Bill__c,
                                    Monthly_Jan__c,
                                    Monthly_Apr__c,
                                    Monthly_Aug__c,
                                    Monthly_Dec__c,
                                    Monthly_Feb__c,
                                    Monthly_Jul__c,
                                    Monthly_Jun__c,
                                    Monthly_Mar__c,
                                    Monthly_May__c,
                                    Monthly_Nov__c,
                                    Monthly_Oct__c,
                                    Monthly_Sep__c,
                                    usage__c,

                                    Account__c,
                                    Daily_Hr1__c,
                                    Daily_Hr2__c,
                                    Daily_Hr3__c,
                                    Daily_Hr4__c,
                                    Daily_Hr5__c,
                                    Daily_Hr6__c,
                                    Daily_Hr7__c,
                                    Daily_Hr8__c,
                                    Daily_Hr9__c,
                                    Daily_Hr10__c,
                                    Daily_Hr11__c,
                                    Daily_Hr12__c,
                                    month__c,
                                    AMPM__c                                  
                             FROM 
                                    Electric_Rate_Usage_Inputs1__r)  from Account Where Name='Test Class DO NOT TOUCH'];

        // create new Quote record
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        
        newQuote.QuoteType__c = 'Lease';
        newQuote.installDate__c = 'December 2013';
        newQuote.Description__c = 'dec Test';
        newQuote.System_Cost__c =30000;
        newQuote.System_Model__c = '230W (Model SPR-230E-WHT-D)';
        newQuote.Modules_Per_String_Roof1__c = 1;
        newQuote.Modules_Per_String_Roof2__c = 1;
        newQuote.Modules_Per_String_Roof3__c = 1;
        newQuote.Modules_Per_String_Roof4__c  = 1;
        newQuote.Total_Parallel_Strings_Roof1__c = 1;
        newQuote.Total_Parallel_Strings_Roof2__c = 1;
        newQuote.Total_Parallel_Strings_Roof3__c = 1;
        newQuote.Total_Parallel_Strings_Roof4__c = 1;
        newQuote.Inverter_Manufacturer_Roof1__c ='Powerone';
        newQuote.Inverter_Manufacturer_Roof2__c = 'Sunpower';
        newQuote.Inverter_Manufacturer_Roof3__c = 'Powerone';
        newQuote.Inverter_Manufacturer_Roof4__c = 'Sunpower';
        newQuote.General_Derate_Factor__c =5.6;
        newQuote.Inverter_Model__c = '';
        newQuote.Inverter_Model_2__c = '';
        newQuote.Inverter_Model_3__c = '';
        newQuote.Inverter_Model_4__c = '';
        newQuote.Inverter_Quantity__c = 1;
        newQuote.Inverter_Quantity_2__c = 1;
        newQuote.Inverter_Quantity_3__c = 1;
        newQuote.Inverter_Quantity_4__c = 1;
        newQuote.ProposedRate__c ='Residential Service';
        newQuote.Utility_Bill_Annual_Escalation__c = 5.6;
        newQuote.Down_Payment__c = 12546.5;
        newQuote.Full_Prepaid_Lease__c = false;
        newQuote.Partial_Prepayment__c = 0.0;
        newQuote.Optional_Incentives__c = 'Use None'; 
        newQuote.Lease_Annual_Escalation__c = 14.5;
        newQuote.Lease_Sales_Tax_Rate__c = 4.2;
        newQuote.REC_Escalation__c = 4.0;
        newQuote.REC_Life_Years__c = 1;
        newQuote.REC_Value_kWh__c = 1.0;
        newQuote.Buydown_Override__c = false;
        newQuote.PBI_Override__c = false;
        newQuote.PBI_Amount__c = 125.6;
        newQuote.PBI_Years__c = 2013;
        newQuote.Design_Factor__c = 'Automatic';
        newQuote.Buydown_Amount__c = 12545.2;
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
 
        // create a line item for the po
        Quote_Line__c Qli1 = new Quote_Line__c();
        Qli1.Unit_Price__c = 6;
        Qli1.Quote__C = newQuote.id;
        Qli1.Quantity__c = 1;
        Qli1.Roof__c = 'Roof 1';
        insert Qli1;

       // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.tpo_clonequote;
        Test.setCurrentPage(pref);
        System.currentPageReference().getParameters().put('qid', newQuote.ID);
 
        // Construct the standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(newQuote);
 
        // create the controller
        TPO_QuoteCloneWithItemsController ext = new TPO_QuoteCloneWithItemsController(con);
 
        // Switch to test context
        //Test.startTest();
 
        // call the cloneWithItems method
        PageReference ref = ext.cloneWithItems();
        // create the matching page reference
        PageReference redir = new PageReference('/'+ext.newRecordId+'/e?retURL=%2F'+ext.newRecordId);
 
        // make sure the user is sent to the correct url
        System.assertEquals(ref.getUrl(),redir.getUrl());
 
        // check that the new po was created successfully
        Quote newQuote1 = [select id from Quote where id = :ext.newRecordId];
        System.assertNotEquals(newQuote1, null);
        // check that the line item was created
        List<Quote_Line__c> newItems = [Select p.Id From Quote_Line__c p where Quote__c = :newQuote1.id];
        System.assertEquals(newItems.size(),1);
 
        // Switch back to runtime context
        //Test.stopTest();
 
    }
 */
}