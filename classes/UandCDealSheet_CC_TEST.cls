@isTest
private class UandCDealSheet_CC_TEST {
    
    static TestMethod void itShould() {
        
        TestClassFactory.createAndInsertLeaseAgreementSettings();

        List<Product2> productsToInsert = new List<Product2>();
       
        Product2 prd= new Product2(name='SPR-Land',Cost__c=0.0,Quantity__c=1,Family='Mounting Systems - Roof',CurrencyIsoCode='USD',IsActive=true,Product_Type__c='Mounting System',ProductCode='123456789');
        productsToInsert.add(prd);
    
        
        Product2 prd2 = new Product2(name='SPR-Product',Cost__c=0.0,Quantity__c=1,Family='PV Module',CurrencyIsoCode='USD',IsActive=true,Product_Type__c = 'PV Module',ProductCode='9887654');
        productsToInsert.add(prd2);

        insert productsToInsert;

        List<PricebookEntry> pbesToInsert = new List<PricebookEntry>();
        
        PricebookEntry pE1 = new PricebookEntry(Product2Id = prd.Id, Isactive = true ,UnitPrice=100);
        pE1.priceBook2Id = Test.getstandardpricebookid();
        pbesToInsert.add(pE1);
        
        PricebookEntry pE2 = new PricebookEntry(Product2Id = prd2.Id, Isactive = true ,UnitPrice=100);
        pE2.priceBook2Id = Test.getstandardpricebookid();
        pbesToInsert.add(pE2);
        
        insert pbesToInsert;

        Account acc = TestClassFactory.testAccount('TestAcc', TestClassFactory.retrieveRecordTypeId('Account','Commercial Customer'));
        insert acc;

        Contact c = TestClassFactory.testContact('TestCustomer', 'testcustomer@noemail.com', TestClassFactory.retrieveRecordTypeId('Contact', 'Customer'));
        c.Override_Duplicate_Check__c = true;
        insert c;

        Opportunity opp = TestClassFactory.testOpportunity('TestOpp', '12% - Qualified Opportunity', Date.today().addDays(90), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems'));
        opp.Primary_Contact__c = c.Id;
        opp.PriceBook2Id = Test.getstandardpricebookid();
        insert opp;

        List<OpportunityTeamMember> members = new List<OpportunityTeamMember>();
        OpportunityTeamMember m = new OpportunityTeamMember();
        m.OpportunityId = opp.Id;
        m.TeamMemberRole = 'Sales Analyst';
        m.UserId = UserInfo.getUserId();
        members.add(m);

        OpportunityTeamMember m2 = new OpportunityTeamMember();
        m2.OpportunityId = opp.Id;
        m2.TeamMemberRole = 'Project Manager';
        m2.UserId = UserInfo.getUserId();
        members.add(m2);

        OpportunityTeamMember m3 = new OpportunityTeamMember();
        m3.OpportunityId = opp.Id;
        m3.TeamMemberRole = 'Structured Finance';
        m3.UserId = UserInfo.getUserId();
        members.add(m3);

        OpportunityTeamMember m4 = new OpportunityTeamMember();
        m4.OpportunityId = opp.Id;
        m4.TeamMemberRole = 'Designer';
        m4.UserId = UserInfo.getUserId();
        members.add(m4);
        insert members;

        Test.startTest();

        Quote q = TestClassFactory.createTestQuote(acc, opp);
        q.Pricebook2Id = Test.getStandardPricebookId();
        insert q;

        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        QuoteLineItem qli1 = new QuoteLineItem();
        qli1.QuoteId = q.Id;
        qli1.PriceBookEntryId = pE1.Id;
        qli1.Quantity = 1;
        qli1.UnitPrice = 1;
        qlis.add(qli1);

        QuoteLineItem qli2 = new QuoteLineItem();
        qli2.QuoteId = q.Id;
        qli2.PriceBookEntryId = pE2.Id;
        qli2.Quantity = 1;
        qli2.UnitPrice = 1;
        qlis.add(qli2);

        insert qlis;

        UandCDealSheet_CC dealSheet = new UandCDealSheet_CC();
        dealSheet.quoteIdValue = q.Id;
        dealSheet.opportunityIdValue = opp.Id;

        Quote q1 = dealSheet.quoteDetails;
        
        String salesAnalysts = dealSheet.salesAnalystVals;
        String projectManagers = dealSheet.projectManagerVals;
        String financeMembers = dealSheet.structuredFinanceVals;
        String designMemebers = dealSheet.designerVals;

        List<QuoteLineItem> mountingSysList = dealSheet.mountingSysQueryList; 
        List<QuoteLineItem> pvList = dealSheet.pvModuleQueryList;
        String mountingVals = dealSheet.mountingSystemVals;
        String pvModules = dealSheet.pvModuleVals;

        //rerun because the class is built for both
        String salesAnalysts2 = dealSheet.salesAnalystVals;
        String projectManagers2 = dealSheet.projectManagerVals;
        String financeMembers2 = dealSheet.structuredFinanceVals;
        String designMemebers2 = dealSheet.designerVals;            

        Test.stopTest();

    }
}