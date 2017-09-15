@isTest(seeAllData = true)
public class Test_CloneQuote {

    /*  Test Case for Product   */
    static testMethod void TestCloneQTProduct() {
    
        //create account
        Account acc = new Account(Name = 'testaccc1111', CurrencyIsoCode = 'USD', Account_Status__c = 'Active', SPWR_Relationship_Type__c = 'Off-Taker', 
                                BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234'); 
        insert acc;
        
        //create Opportunity
        Opportunity oppty = new Opportunity (Name = 'Tesrt111', AccountId = acc.ID, StageName= 'Budgetary Pricing', Business_Unit__c='UPP Intl', CloseDate=system.today(), Country__c ='Italy');
        insert oppty;
        
        //Select Pricebook
        Pricebook2 PB = [select Id from Pricebook2 where Name='Standard Price Book' and IsStandard = true];
        
        //Create Product
        Product2 PROD = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', CurrencyIsoCode='USD', IsActive=true, Product_Type__c='PV Module', ProductCode='123456789');
        insert PROD;
        
        //Create PriceBookEntry
        PricebookEntry PBE = new PricebookEntry(Pricebook2Id=PB.id, Product2id=PROD.id, CurrencyIsoCode ='USD', IsActive=true, UseStandardPrice=False, UnitPrice=0);
        insert PBE;  
        
        Item__c itm = new Item__c();
            itm.Name = 'Hello';
            itm.Item_ID__c = 'asdf';
            insert itm;
        
        //create Quote
        Quote QT = new Quote();
            QT.Name = 'TestQ';
            QT.Account__c = acc.Id;
            QT.Pricebook2Id= PB.Id;
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
            
            test.stopTest();
    }


    /*  Test Case for Lessee    */
    static testMethod void TestCloneQTLessee() {
        //create account
        Account acc = new Account(Name = 'testaccc1111', CurrencyIsoCode = 'USD', Account_Status__c = 'Active', SPWR_Relationship_Type__c = 'Off-Taker', 
                                BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234'); 
        insert acc;
        
        //create Opportunity
        Opportunity oppty = new Opportunity (Name = 'Tesrt111', AccountId = acc.ID, StageName= 'Budgetary Pricing', Business_Unit__c='UPP Intl', CloseDate=system.today(), Country__c ='Italy');
        insert oppty;
        
        //Select Pricebook
        Pricebook2 PB = [select Id from Pricebook2 where Name='Standard Price Book' and IsStandard = true];
        
        //Create Product
        Product2 PROD = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', CurrencyIsoCode='USD', IsActive=true, Product_Type__c='PV Module', ProductCode='123456789');
        insert PROD;
        
        //Create PriceBookEntry
        PricebookEntry PBE = new PricebookEntry(Pricebook2Id=PB.id, Product2id=PROD.id, CurrencyIsoCode ='USD', IsActive=true, UseStandardPrice=False, UnitPrice=0);
        insert PBE;  
        
        
        //create Quote
        Quote QT = new Quote();
            QT.Name = 'TestQ';
            QT.Account__c = acc.Id;
            QT.Pricebook2Id= PB.Id;
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
        Pricebook2 PB = [select Id from Pricebook2 where Name='Standard Price Book' and IsStandard = true];
        
        //Create Product
        Product2 PROD = new Product2(name='SPR-1000', Cost__c=0.0, Quantity__c=1, Family='PV Module', CurrencyIsoCode='USD', IsActive=true, Product_Type__c='PV Module', ProductCode='123456789');
        insert PROD;
        
        //Create PriceBookEntry
        PricebookEntry PBE = new PricebookEntry(Pricebook2Id=PB.id, Product2id=PROD.id, CurrencyIsoCode ='USD', IsActive=true, UseStandardPrice=False, UnitPrice=0);
        insert PBE;  
        
        
        //create Quote
        Quote QT = new Quote();
            QT.Name = 'TestQ';
            QT.Account__c = acc.Id;
            QT.Pricebook2Id= PB.Id;
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
            test.stopTest();
    }  
    
}