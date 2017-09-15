@isTest
public class updatePSRDateTrigger_Test {
    
    static TestMethod void testPSRDateTrigger1() {
        
        //create account
        Account acc = new Account(Name = 'testaccc', CurrencyIsoCode = 'USD', Account_Status__c = 'Active', SPWR_Relationship_Type__c = 'Off-Taker', BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234'); 
        insert acc;
        
        //create Opportunity
        Opportunity opp2 = new Opportunity (Name = 'Tesrt', StageName= 'Budgetary Pricing', Business_Unit__c='UPP Intl', CloseDate=system.today(), AccountId = acc.ID, Country__c ='Italy');
        insert opp2;

        //Create Product
        Product2 prd = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', CurrencyIsoCode='USD', IsActive=true, Product_Type__c='PV Module', ProductCode='123456789');
        insert prd;
        
        //Create PriceBookEntry
        PricebookEntry pbe1=new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2id = prd.id, CURRENCYISOCODE = 'USD', IsActive = true, UseStandardPrice = False, UnitPrice = 0);
        insert pbe1;
        
        //create Quote
        Quote q1 = new Quote();
        q1.Name = 'TestQ';
        q1.Pricebook2Id = Test.getStandardPricebookId();
        q1.Override_30KW_Limit__c = TRUE;
        q1.OpportunityId = opp2.Id;
        insert q1;
        
        // Create Quote Summary
        Quote_Summary__c QS = new Quote_Summary__c();
        QS.Locked_Scenario__c = q1.Id;
        QS.Ammendment__c = 'Product';
        QS.Lease_to_be_Amended__c = 'Hello';
        QS.Override_30KW_Limit__c = FALSE;
        QS.Comments__c = 'Comment';//JAJA SEPT2815
        insert QS;
        
        QS.Override_30KW_Limit__c = TRUE;
        update QS;             
        
        //create Design
        Design__c design = new Design__c();
        design.Quote__c=q1.id;
        design.Opportunity__c=opp2.id;
        insert design;
        
        Single_Line__c singleLine = new Single_Line__c();
        singleLine.Negotiated_Due_Date__c = Date.today().addDays(20);
        insert singleLine;            
        
        Test.startTest();
        
        //create PSR
        PSR__c psr = new PSR__c();
        psr.Design__c=design.id;
        psr.Mounting_System__c=prd.id;
        psr.Opportunity__c=opp2.id;
        psr.Quote__c=q1.id;
        psr.Array_Layout_Due__c = Date.today().addDays(30);
        psr.Electrical_Support_Due__c = Date.today().addDays(45);
        psr.Single_Line__c = singleLine.Id;
        insert psr;
        
        //create Estimate__c
        Estimate__c estimate = new Estimate__c();
        estimate.Quote__c = q1.id;
        estimate.Opportunity__c = opp2.id;
        estimate.Primary_PSR_Estimate__c = true;
        estimate.design__c = design.id;
        estimate.PSR__c = psr.id;
        insert estimate;
        
        psr.Array_Layout_Due__c = Date.today().addDays(45);
        psr.Electrical_Support_Due__c = Date.today().addDays(60);
        update psr;
 
        Test.stopTest();
    }
    
}