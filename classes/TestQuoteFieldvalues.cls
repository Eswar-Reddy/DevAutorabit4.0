// Test class for Class QuoteFieldvalues
// Test class for Trigger Override_30KW_Limit

public class TestQuoteFieldvalues {

   //  @isTest
    public static testMethod void afterInsertUpdate() {
        
        QuoteFieldvalues qf = new QuoteFieldvalues();
        
        Date dt = date.newinstance(2010,1,4);
        List<QuoteLineItem> list1 = new List<QuoteLineItem>();
        List<QuoteLineItem> list2;
        
        Account acc = new Account(Name = 'testaccc', CurrencyIsoCode = 'USD', Account_Status__c = 'Active',
                                  SPWR_Relationship_Type__c = 'Off-Taker', Phone = '1234', BillingStreet = 'West Mare', 
                                  BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'USA'); 
        insert acc;
        
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        Opportunity opp2 = new Opportunity (Name = 'Tesrt', StageName= 'Budgetary Pricing', Business_Unit__c='UPP Intl', CloseDate=dt, AccountId = acc.ID);
            opp2.Country__c = 'United States';//Test class fix
            insert opp2;
        
        Pricebook2 pb = [select Id from Pricebook2 where Name='Standard Price Book'];
        
        Product2 prd = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', IsActive=true, CurrencyIsoCode='USD', Product_Type__c='PV Module', ProductCode='123456789');
        insert prd;
        
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pb.id, Product2id=prd.id, CURRENCYISOCODE='USD', IsActive=true, UseStandardPrice=False, UnitPrice=0);
        insert pbe1;
        
        Quote q1= new Quote(name='Test', OpportunityId=opp2.id, Pricebook2Id= pb.Id);
        insert q1;
        
        QuoteLineItem qli=new QuoteLineItem (QuoteId=q1.id,Quantity=1,UnitPrice=0.0,Product__c=prd.Id,PricebookEntryId=pbe1.Id);
        //insert qli;
        //delete qli;
        
    }
    
    
    
    public static testMethod void afterInsertUpdate1() {
        
        //create account
        Account acc = new Account(Name = 'testaccc', CurrencyIsoCode = 'USD', Account_Status__c = 'Active', SPWR_Relationship_Type__c = 'Off-Taker', BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234'); 
        insert acc;
        
        //create Opportunity
        Opportunity opp2 = new Opportunity (Name = 'Tesrt', StageName= 'Budgetary Pricing', Business_Unit__c='UPP Intl', CloseDate=system.today(), AccountId = acc.ID, Country__c ='Italy');
        insert opp2;
        
        //Select Pricebook
        Pricebook2 pb = [select Id from Pricebook2 where Name='Standard Price Book' and IsStandard = true];
        
        //Create Product
        Product2 prd = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', CurrencyIsoCode='USD', IsActive=true, Product_Type__c='PV Module', ProductCode='123456789');
        insert prd;
        
        //Create PriceBookEntry
        PricebookEntry pbe1=new PricebookEntry(Pricebook2Id=pb.id, Product2id=prd.id, CURRENCYISOCODE='USD', IsActive=true, UseStandardPrice=False, UnitPrice=0);
        insert pbe1;
        
       
/*    START Modified Reetan 14th Sept    */
        
        //create Quote
        Quote q1 = new Quote();
            q1.Name = 'TestQ';
            q1.Pricebook2Id= pb.Id;
            q1.Override_30KW_Limit__c = TRUE;
            q1.OpportunityId = opp2.Id;
            //  q1.Lease_Doc_Signed__c = TRUE;
            //  q1.Account__c = q2.Account__c;
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
           // QS.Ammendment__c = 'Product';
            update QS;      
        
/*    END Modified Reetan 14th Sept    */        
          
        //create Design
        Design__c design = new Design__c();
            design.Quote__c=q1.id;
            design.Opportunity__c=opp2.id;
            insert design;
            
            Set<Id> designSet = new Set<Id>();
            designSet.add(design.id);
        
        
        //create PSR
        PSR__c psr = new PSR__c();
            psr.Design__c=design.id;
            psr.Mounting_System__c=prd.id;
            psr.Opportunity__c=opp2.id;
            psr.Quote__c=q1.id;
            insert psr;
        
        PSR__c psr1 = [select id from psr__c where id=:psr.id];
        
        //create Estimate__c
        Estimate__c estimate = new Estimate__c();
            estimate.Quote__c=q1.id;
            estimate.Opportunity__c = opp2.id;
            estimate.Primary_PSR_Estimate__c=true;
            estimate.design__c=design.id;
            estimate.PSR__c=psr1.id;
            insert estimate;
        
        //create QuoteLineItem
        
        QuoteLineItem qli = new QuoteLineItem ();
            qli.QuoteId=q1.id;
            qli.Quantity=1;
            qli.UnitPrice=0.0;
            qli.Product__c=prd.Id;
            qli.PricebookEntryId=pbe1.Id;
            qli.design__c=design.id;
            qli.kWp_Components__c=123;
            insert qli;
        
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
            qliList.add(qli);
        
        QuoteFieldvalues.UpdateQuoteInfo(qliList);
        QuoteFieldvalues.UpdateDesignInfo(designSet);
     
        }
    
}