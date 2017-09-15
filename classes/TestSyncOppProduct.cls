@isTest
private class TestSyncOppProduct
 {
    @isTest
    static void tst001()
    {
        SyncOppProduct sop= new SyncOppProduct();
        List <Opportunity> oppList= new List<Opportunity>();
        System.debug('Inserting Sample OPP');
        Date dt = date.newinstance(2010,6,3);
        Pricebook2 stdPb = new Pricebook2();
              
        List<Pricebook2> stdPblst = new List<Pricebook2>([select Id from Pricebook2 where isStandard=true and isActive=true limit 1]);
        if(stdPblst.size()>0){
            stdPb = stdPblst[0];                
        }
        else{
            return;
        }
        Opportunity opp2= new Opportunity (name='test2',StageName='Unidentified',CloseDate=dt,Pricebook2Id=stdPb.id);
        opp2.StageName = '02 – Budgetary Pricing';
        opp2.PV_Cost_Pricing__c = 1.77;
        opp2.Serengeti_Cost_Pricing__c = 2.54;
        insert opp2;
        List<Opportunity> opp= [Select StageName,CloseDate,Business_Unit__c,SyncedQuoteId,Pricebook2Id from Opportunity where name='test2'];
        Quote q1= new Quote(name='Test',Opportunity=opp2,OpportunityId=opp2.id,Pricebook2Id=stdPb.id);
        q1.Status = 'Presented';
        insert q1;
                  
       /*
        Pricebook2 pb2=new Pricebook2(name='Test_entry',IsActive=true);
        insert pb2;
        Product2 prd= new Product2(name='Advanced Monitoring',Cost__c=0.0,Quantity__c=1,Family='O&M',CurrencyIsoCode='EUR',IsActive=true,Product_Type__c='Balance of System',ProductCode='123456789');
        Product2 prd= new Product2(name='Land',Cost__c=0.0,Quantity__c=1,Family='Development',CurrencyIsoCode='USD',IsActive=true,Product_Type__c='Development',ProductCode='123456789');
      
        PricebookEntry pbe=new PricebookEntry(Pricebook2Id=pb2.id,Product2id=prd.id,CURRENCYISOCODE='USD',UnitPrice=0.0,IsActive=true,UseStandardPrice=false);
        OpportunityLineItem opli=new OpportunityLineItem(OpportunityId=opp2.id,PricebookEntryId='01uQ0000001vfO2IAI',UnitPrice=0.0,Quantity=1,Cost__c=0.0);
       */
       
       Product2 prd= new Product2(name='SPR-Land',Cost__c=0.0,Quantity__c=1,Family='Development',CurrencyIsoCode='USD',IsActive=true,Product_Type__c='PV Module',ProductCode='123456789');
       insert prd;
    
       PricebookEntry pbe=new PricebookEntry(Pricebook2Id=opp2.Pricebook2Id,Product2id=prd.id,CURRENCYISOCODE='USD',UnitPrice=0.0,IsActive=true,UseStandardPrice=false);
       insert pbe;
       QuoteLineItem qli=new QuoteLineItem (QuoteId=q1.id,Quantity=1,PricebookEntryId=pbe.id,UnitPrice=0.0);
       insert qli;
        
       
       Test.startTest(); 
       OpportunityLineItem opli=new OpportunityLineItem(OpportunityId=opp2.id,PricebookEntryId=pbe.id,UnitPrice=0.0,Quantity=1,Cost__c=0.0);
       Insert opli;
             
       
       opp2.SyncedQuoteID = q1.Id;
       opp2.PV_Cost_Pricing__c = 2.77;
       opp2.Serengeti_Cost_Pricing__c = 1.54;
       update opp2;
      
       SyncOppProduct.syncOppsProductFromQuote(opp,null);
       Test.stopTest();
         
    }
    
    @isTest
    static void testSyncOppProduct(){
       Account acct = new Account();
       /*  acct.Name = 'TestDuplicate';
        acct.Type ='Commercial'; 
        acct.billingCity = 'TestCity';
        acct.BillingCountry = 'TestCountry';
        acct.BillingPostalCode = '12345';
        acct.BillingState = 'TestState';
        acct.BillingStreet = 'TestStreet';   
        insert acct;*/
        acct =[Select ID from Account Where Name='Test Class DO NOT TOUCH'];
        Id priceBookId;
        for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
            priceBookId = priceBook.id;
        }
        
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
        opp.StageName = '02 – Budgetary Pricing';
        opp.PV_Cost_Pricing__c = 1.77;
        opp.Serengeti_Cost_Pricing__c = 2.54;
        opp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
        opp.priceBook2Id  = priceBookId;
        insert opp;
       
       List<Product2> productsToInsert = new List<Product2>();
       
        Product2 prd= new Product2(name='SPR-Land',Cost__c=0.0,Quantity__c=1,Family='Development',CurrencyIsoCode='USD',IsActive=true,Product_Type__c='PV Module',ProductCode='123456789');
        productsToInsert.add(prd);
    
        
        Product2 prdObj = new Product2(name='SER-tproduct',family='Development');
        prdObj.Product_Type__c = 'PV Module';
        productsToInsert.add(prdObj);
        
        insert productsToInsert;
        
        
        Quote qt = new Quote();
        qt.Name = 'test';           
        qt.OpportunityId = opp.ID;
        qt.Status = 'Presented';
        qt.pricebook2Id = priceBookId;
        insert qt;
        
        List<PricebookEntry> pbesToInsert = new List<PricebookEntry>();
        
        PricebookEntry pE1 = new PricebookEntry(Product2Id =prdObj.Id ,Isactive=true ,UnitPrice=100);
        if(priceBookId != null){
            pE1.priceBook2Id = priceBookId ;
            pbesToInsert.add(pE1);
        }
        
        PricebookEntry pE2 = new PricebookEntry(Product2Id =prd.Id ,Isactive=true ,UnitPrice=100);
        if(priceBookId != null){
            pE2.priceBook2Id = priceBookId ;
            pbesToInsert.add(pE2);
        }
        
        insert pbesToInsert;
                
        
        List<OpportunityLineItem> oppsLinesToInsert = new List<OpportunityLineItem>();
        
        OpportunityLineItem opp_product = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
        oppsLinesToInsert.add(opp_product);
   
        OpportunityLineItem opp_product2 = new OpportunityLineItem(OpportunityId = opp.id, UnitPrice=0.0, Quantity = 1, Cost__c=0.0 , priceBookEntryId = pE2.Id);        
        oppsLinesToInsert.add(opp_product2);
         Test.startTest();
        insert oppsLinesToInsert;
        
        
        //qt.priceBook2Id  = priceBookId ; 
        //update qt;
        
        List<Opportunity> oppTrigger = new List<Opportunity> ();
        oppTrigger.Add(opp);
        
        
        
                
       
        
        
        
        opp.SyncedQuoteId = qt.ID;
        opp.PV_Cost_Pricing__c = 3.77;
        opp.Serengeti_Cost_Pricing__c = 5.54;
        
        
        
       
       
        //SyncOppProduct.syncOppsProductFromQuote(oppTrigger,null);
        update opp;
        
        Test.stopTest();
        
     }
     
     
    
    
 }