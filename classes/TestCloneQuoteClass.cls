@isTest
private class TestCloneQuoteClass {

    @TestSetup
    static void testDataSetup() {
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        
        Lease_2_1_PO_Creation__c record1 = new Lease_2_1_PO_Creation__c(name = 'Settings');
        record1.Price_List_Name__c = 'Inverter Model Price List';
        record1.Lease_Installation_Percentage__c = .6;
        record1.Lease_InterConnect_Percentage__c = .2;
        record1.Safe_Harbour_Calculation__c = .055;
        insert record1;

        Price_List__c pl = new Price_List__c(name = 'Inverter Model Price List', DSR_Po_Group_Email__c = UserInfo.getUserEmail()); 
            pl.Shipping_Codes__c = 'McCollister-Truck-DTH SunPack'; 
            pl.Expedite_Fee__c = 0.0; 
            pl.RecordTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Price_List__c.sObjectType).get('NA');
        insert pl;
    }
    
    static TestMethod void testCloneQuote() {

        

        //create account
        Account acc = new Account(Name = 'testaccc1111', CurrencyIsoCode = 'USD', Account_Status__c = 'Active', SPWR_Relationship_Type__c = 'Off-Taker', 
                                BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234'); 
        insert acc;
        
        //create Opportunity
        Opportunity oppty = new Opportunity (Name = 'Tesrt111', AccountId = acc.ID, StageName= 'Budgetary Pricing', Business_Unit__c='UPP Intl', CloseDate=system.today(), Country__c ='Italy');
        insert oppty;
        
        //Select Pricebook
        Id pricebookId = Test.getStandardPricebookId();
 
        
        //Create Product
        Product2 PROD = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', CurrencyIsoCode='USD', IsActive=true, Product_Type__c='PV Module', ProductCode='123456789');
        insert PROD;
        
        //Create PriceBookEntry
        PricebookEntry PBE = new PricebookEntry(Pricebook2Id=pricebookId, Product2id=PROD.id, CurrencyIsoCode ='USD', IsActive=true, UseStandardPrice=False, UnitPrice=0);
        insert PBE;  
        
        Item__c itm = new Item__c();
            itm.Name = 'Hello';
            itm.Item_ID__c = 'asdf';
            insert itm;
        
        //create Quote
        Quote QT = new Quote();
            QT.Name = 'TestQ';
            QT.Account__c = acc.Id;
            QT.Pricebook2Id= pricebookId;
            QT.OpportunityId = oppty.Id;
            QT.Is_Locked__c = FALSE;       
            QT.Lease_Doc_Signed__c = TRUE;     
            insert QT; 
            
            test.startTest();
        Quote QT1 = new Quote(); 
            QT1.Name = 'TestQ1111';  
            QT1.Account__c = acc.Id;
            QT1.Amendment_Type__c = 'Product';                             
            QT1.Lease_Doc_Signed__c = TRUE; 
            QT1.OpportunityId = oppty.Id;
            QT1.Amended_Lease__c = QT.Id;
            QT1.Is_Locked__c = TRUE; 
            insert QT1;
            
        Quote_Line__c QL = new Quote_Line__c();
            QL.Quote__c = QT1.Id;
            QL.Quantity__c = 55;
            QL.Unit_Price__c = 55.25; 
            QL.Item__c = itm.Id;
            QL.CurrencyIsoCode = 'USD';
            insert QL; 
            
            QT1.Name = 'TestQ2222';   
            QT1.Is_Locked__c = TRUE; 
            QT1.Lease_Doc_Signed__c = FALSE;
            QT1.Amendment_Type__c = 'Product';
            update QT1; 

        CloneQuote cq = new CloneQuote();
        cq.quoteUpdate(new Quote[] {qt1});
            
            test.stopTest();
    }

     static testMethod void TestCloneQTLessee() {
        //create account
        Account acc = new Account(Name = 'testaccc1111', CurrencyIsoCode = 'USD', Account_Status__c = 'Active', SPWR_Relationship_Type__c = 'Off-Taker', 
                                BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234'); 
        insert acc;
        
        //create Opportunity
        Opportunity oppty = new Opportunity (Name = 'Tesrt111', AccountId = acc.ID, StageName= 'Budgetary Pricing', Business_Unit__c='UPP Intl', CloseDate=system.today(), Country__c ='Italy');
        insert oppty;
        
        //Select Pricebook
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create Product
        Product2 PROD = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', CurrencyIsoCode='USD', IsActive=true, Product_Type__c='PV Module', ProductCode='123456789');
        insert PROD;
        
        //Create PriceBookEntry
        PricebookEntry PBE = new PricebookEntry(Pricebook2Id=pricebookId, Product2id=PROD.id, CurrencyIsoCode ='USD', IsActive=true, UseStandardPrice=False, UnitPrice=0);
        insert PBE;  
        
        
        //create Quote
        Quote QT = new Quote();
            QT.Name = 'TestQ';
            QT.Account__c = acc.Id;
            QT.Pricebook2Id= pricebookId;
            QT.OpportunityId = oppty.Id;
            QT.Is_Locked__c = FALSE;       
            QT.Lease_Doc_Signed__c = TRUE;     
            insert QT; 
            
            test.startTest();
        Quote QT1 = new Quote(); 
            QT1.Name = 'TestQ1111';  
            QT1.Account__c = acc.Id;
            QT1.Amendment_Type__c = 'Lessee';                             
            QT1.Lease_Doc_Signed__c = TRUE; 
            QT1.OpportunityId = oppty.Id;
            QT1.Amended_Lease__c = QT.Id;
            QT1.Is_Locked__c = TRUE; 
            insert QT1;
            
            QT1.Name = 'TestQ2222';   
            QT1.Is_Locked__c = TRUE; 
            QT1.Lease_Doc_Signed__c = FALSE;
            QT1.Amendment_Type__c = 'Lessee';
            update QT1; 
            
        CloneQuote cq = new CloneQuote();
        cq.quoteUpdate(new Quote[] {qt1});
            
            test.stopTest();
    }
    
    /*  Test Case for Production    */
    static testMethod void TestCloneQTProduction() {
        //create account
        Account acc = new Account(Name = 'testaccc1111', CurrencyIsoCode = 'USD', Account_Status__c = 'Active', SPWR_Relationship_Type__c = 'Off-Taker', 
                                BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234'); 
        insert acc;
        
        //create Opportunity
        Opportunity oppty = new Opportunity (Name = 'Tesrt111', AccountId = acc.ID, StageName= 'Budgetary Pricing', Business_Unit__c='UPP Intl', CloseDate=system.today(), Country__c ='Italy');
        insert oppty;
        
        //Select Pricebook
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create Product
        Product2 PROD = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', CurrencyIsoCode='USD', IsActive=true, Product_Type__c='PV Module', ProductCode='123456789');
        insert PROD;
        
        //Create PriceBookEntry
        PricebookEntry PBE = new PricebookEntry(Pricebook2Id=pricebookId, Product2id=PROD.id, CurrencyIsoCode ='USD', IsActive=true, UseStandardPrice=False, UnitPrice=0);
        insert PBE;  
        
        
        //create Quote
        Quote QT = new Quote();
            QT.Name = 'TestQ';
            QT.Account__c = acc.Id;
            QT.Pricebook2Id= pricebookId;
            QT.OpportunityId = oppty.Id;
            QT.Is_Locked__c = FALSE;       
            QT.Lease_Doc_Signed__c = TRUE;     
            insert QT; 
            
            test.startTest();
        Quote QT1 = new Quote(); 
            QT1.Name = 'TestQ1111'; 
            QT1.Account__c = acc.Id; 
            QT1.Amendment_Type__c = 'Production';                             
            QT1.Lease_Doc_Signed__c = TRUE; 
            QT1.OpportunityId = oppty.Id;
            QT1.Amended_Lease__c = QT.Id;
            QT1.Is_Locked__c = TRUE; 
            insert QT1;
            
            QT1.Name = 'TestQ2222';   
            QT1.Is_Locked__c = TRUE; 
            QT1.Lease_Doc_Signed__c = FALSE;
            QT1.Amendment_Type__c = 'Production';
            update QT1; 
        CloneQuote cq = new CloneQuote();
            cq.quoteUpdate(new Quote[] {qt1});
            
            test.stopTest();

    }

    
}