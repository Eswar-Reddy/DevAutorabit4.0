public class TestEstimateQuoteController {
    static testMethod void EstimateQuoteController(){ 
        Date dt =Date.newinstance(2010,03,03);
        Account acc = new Account(Name = 'testaccc',CurrencyIsoCode = 'USD', Account_Status__c = 'Active',SPWR_Relationship_Type__c = 'Off-Taker',BillingStreet = 'West Mare',BillingCity = 'SanFrancisco',BillingPostalCode = '2345', BillingCountry = 'United States of America',Phone = '1234');
        insert acc;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        Opportunity o = new Opportunity(Name = 'Tesrt',StageName= 'Budgetary Pricing',Business_Unit__c='UPP Intl',CloseDate=dt,AccountId = acc.ID);
        Insert o;
        Pricebook2 pb = [select Id from Pricebook2 where IsStandard = true and Name='Standard Price Book'];
        Product2 prd  = new Product2(Name='testp',Product_Type__c='PV Module',Family='O&M',ProductCode='1111');
        insert prd;
        PricebookEntry pE = new PricebookEntry(UnitPrice=0,Product2Id=prd.Id,Pricebook2Id=pb.Id,UseStandardPrice=false,IsActive=true);
        insert pE;
        Estimate__c estimate = new Estimate__c(Opportunity__c=o.Id,Price_Book__c=pb.Id);
        insert estimate;
        Product2 p = [select Family from Product2 where Id=:prd.ID ];
        ApexPages.currentPage().getparameters().put('id',estimate.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);
        EstimateQuoteController dqn = new EstimateQuoteController();
        QuoteLineItem qli = new QuoteLineItem();
        String family=dqn.getSelectedFamily();
        PricebookEntry pbe = new PricebookEntry();
        dqn.setSelectedFamily('fan'); 
        dqn.init();
        dqn.updateFamily();
        dqn.getSize1();
        dqn.getFamily();    
    }
    static testMethod void EstimateQuoteController1(){ 
        Date dt =Date.newinstance(2010,03,03);
        Account acc = new Account(Name = 'testaccc',CurrencyIsoCode = 'USD', Account_Status__c = 'Active',SPWR_Relationship_Type__c = 'Off-Taker',BillingStreet = 'West Mare',BillingCity = 'SanFrancisco',BillingPostalCode = '2345', BillingCountry = 'United States of America',Phone = '1234');
        insert acc;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        Opportunity o = new Opportunity(Name = 'Tesrt',StageName= 'Budgetary Pricing',Business_Unit__c='UPP Intl',CloseDate=dt,AccountId = acc.ID);
        Insert o;
        Pricebook2 pb = [select Id from Pricebook2 where IsStandard = true and Name='Standard Price Book'];
        Product2 prd  = new Product2(Name='testp',Product_Type__c='PV Module',Family='O&M',ProductCode='1111');
        insert prd;
        PricebookEntry pE = new PricebookEntry(UnitPrice=0,Product2Id=prd.Id,Pricebook2Id=pb.Id,UseStandardPrice=false,IsActive=true);
        insert pE;
        Product2 prd1 = [select Id,family from Product2 limit 1];
        Estimate__c estimate = new Estimate__c(Opportunity__c=o.Id);
        insert estimate;
        Product2 p = [select Family from Product2 where Id=:prd.ID ];
        ApexPages.currentPage().getparameters().put('id',estimate.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);
        ApexPages.currentPage().getparameters().put('TestCall','abc');
        EstimateQuoteController dqn = new EstimateQuoteController();
        dqn.init();
        dqn.updateFamily();
        dqn.getSize1();
        dqn.getFamily();       
     }
     static testMethod void EstimateQuoteController2(){ 
        Date dt =Date.newinstance(2010,03,03);
        Account acc = new Account(Name = 'testaccc',CurrencyIsoCode = 'USD', Account_Status__c = 'Active',SPWR_Relationship_Type__c = 'Off-Taker',BillingStreet = 'West Mare',BillingCity = 'SanFrancisco',BillingPostalCode = '2345', BillingCountry = 'United States of America',Phone = '1234');
        insert acc;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        Opportunity o = new Opportunity(Name = 'Tesrt',StageName= 'Budgetary Pricing',Business_Unit__c='UPP Intl',CloseDate=dt,AccountId = acc.ID);
        Insert o;
        Pricebook2 pb = [select Id from Pricebook2 where IsStandard = true and Name='Standard Price Book'];
        Product2 prd  = new Product2(Name='testp',Product_Type__c='PV Module',Family='O&M',ProductCode='1111');
        insert prd;
        PricebookEntry pE = new PricebookEntry(UnitPrice=0,Product2Id=prd.Id,Pricebook2Id=pb.Id,UseStandardPrice=false,IsActive=true);
        insert pE;
        Estimate__c estimate = new Estimate__c(Opportunity__c=o.Id,Price_Book__c=pb.Id);
        insert estimate;
        Product2 p = [select Family from Product2 where Id=:prd.ID ];
        ApexPages.currentPage().getparameters().put('id',estimate.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);
        ApexPages.currentPage().getparameters().put('TestCall','abc');
        EstimateQuoteController dqn = new EstimateQuoteController();
        dqn.init();
        dqn.cancel();
        Quote q = new Quote(Name='qtest',OpportunityId=o.Id,Pricebook2Id=pb.Id);
        insert q;
       // Quote q = [select Id from Quote where Name='DummyQuote'];//prd1.Id
        QuoteLineItem qli = new QuoteLineItem(Product__c=pE.Product2Id ,Quantity=1,UnitPrice=0,Estimate__c=estimate.Id,QuoteId=q.Id,PricebookEntryId=pE.Id,isActive__c=true);
        insert qli;
        list<QuoteLineItem > qlis = new list<QuoteLineItem >();
        qlis.add(qli);
        system.debug('padma'+qli);
        dqn.getProductLists();
        dqn.setProductLists(qlis);
        dqn.save1();
                    
       }
}