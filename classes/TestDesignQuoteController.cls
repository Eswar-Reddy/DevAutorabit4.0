@isTest
public class TestDesignQuoteController {
    static testMethod void DesignQuoteController(){ 
        
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
        Design__c design = new Design__c(Opportunity__c=o.Id,Price_Book__c=pb.Id);
        insert design;
        Product2 p = [select Family from Product2 where Id=:prd.ID ];
        Test.startTest();
        ApexPages.currentPage().getparameters().put('id',design.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);
        DesignQuoteController dqn = new DesignQuoteController();
       // QuoteLineItem qli = new QuoteLineItem(); ---
        Quote q = new Quote(Name='qtest',OpportunityId=o.Id,Pricebook2Id=pb.Id);
        insert q;
        QuoteLineItem qli = new QuoteLineItem(Product__c=pE.Product2Id ,Quantity=1,UnitPrice=0,design__c=design.Id,QuoteId=q.Id,PricebookEntryId=pE.Id,isActive__c=true);
        insert qli;
        list<QuoteLineItem > qlis = new list<QuoteLineItem >();
        qlis.add(qli);
        qlis.size();
        //------
        String family=dqn.getSelectedFamily();
        PricebookEntry pbe = new PricebookEntry();
        dqn.setSelectedFamily('fan'); 
        dqn.init();
        dqn.updateFamily();
        dqn.getSize1();
        dqn.getFamily();  
  
    }
    static testMethod void DesignQuoteController1(){ 
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
        Design__c design = new Design__c(Opportunity__c=o.Id);
        insert design;
        Product2 p = [select Family from Product2 where Id=:prd.ID ];
        ApexPages.currentPage().getparameters().put('id',design.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);
        ApexPages.currentPage().getparameters().put('TestCall','abc');
        DesignQuoteController dqn = new DesignQuoteController();
        dqn.init();
        dqn.updateFamily();
        dqn.getSize1();
        dqn.getFamily();       
     }
     static testMethod void DesignQuoteController2(){ 
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
        
        Design__c design = new Design__c(Opportunity__c=o.Id,Price_Book__c=pb.Id);
        insert design;
        Product2 p = [select Family from Product2 where Id=:prd.ID ];
        Test.startTest();
        ApexPages.currentPage().getparameters().put('id',design.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);
        ApexPages.currentPage().getparameters().put('TestCall','abc');
        DesignQuoteController dqn = new DesignQuoteController();
        dqn.init();
        dqn.cancel();
        Quote q = new Quote(Name='qtest',OpportunityId=o.Id,Pricebook2Id=pb.Id);
        insert q;
        RecordType rtypeId = [Select Id from RecordType where developerName='Proposal_Quote' and SObjectType='Quote'];
       // Quote q = [select Id from Quote where Name='DummyQuote'];//prd1.Id
       
        QuoteLineItem qli = new QuoteLineItem(Product__c=pE.Product2Id ,Quantity=1,UnitPrice=0,design__c=design.Id,QuoteId=q.Id,PricebookEntryId=pE.Id,isActive__c=true);
        insert qli;
        list<QuoteLineItem > qlis = new list<QuoteLineItem >();

        qlis.add(qli);
        dqn.getSize1();     
        dqn.getProductLists();
        dqn.setProductLists(qlis);
        qlis.size();
        dqn.save1();
        
        Test.stopTest();
              
       }
       
        static testMethod void DesignQuoteController3(){ 
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
        
        Design__c design = new Design__c(Opportunity__c=o.Id,Price_Book__c=pb.Id);
        insert design;
        Product2 p = [select Family from Product2 where Id=:prd.ID ];
        Test.startTest();
        ApexPages.currentPage().getparameters().put('id',design.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);
        ApexPages.currentPage().getparameters().put('TestCall','abc');
        DesignQuoteController dqn = new DesignQuoteController();
        dqn.init();
        dqn.cancel();
        Quote q = new Quote(Name='qtest',OpportunityId=o.Id,Pricebook2Id=pb.Id);
        insert q;
        RecordType rtypeId = [Select Id from RecordType where developerName='Proposal_Quote' and SObjectType='Quote'];
       // Quote q = [select Id from Quote where Name='DummyQuote'];//prd1.Id
       
        QuoteLineItem qli = new QuoteLineItem(Product__c=pE.Product2Id ,Quantity=1,UnitPrice=0,design__c=design.Id,QuoteId=q.Id,PricebookEntryId=pE.Id,isActive__c=true);
        insert qli;
        list<QuoteLineItem > qlis = new list<QuoteLineItem >();

        if(pE!=null){
            dqn.getProductLists();
        }else{
            dqn.getProductLists();
        }
        
        qlis.add(qli);
        dqn.getSize1();     
        dqn.setProductLists(qlis);
        qlis.size();
        dqn.save1();
        dqn.cancel();
        Test.stopTest();
              
       }
       
}