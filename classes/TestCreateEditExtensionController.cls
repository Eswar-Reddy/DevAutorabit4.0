@isTest
private class TestCreateEditExtensionController {
    
    @isTest static void test_method_one() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity='testcity';
        acc.BillingCountry='testcountry';
        acc.BillingState='teststate';
        acc.BillingStreet='teststreet';
        acc.BillingPostalCode='95051';
        insert acc;

        Test.setCurrentPageReference(Page.SPCommunityAccountEdit);
        ApexPages.currentPage().getParameters().put('id', acc.Id);

        ApexPages.standardController con = new ApexPages.standardController(acc);

        system.debug('myPage: ' + ApexPages.currentPage().getUrl());
        CreateEditExtensionController constructor = new CreateEditExtensionController(con);

        constructor.getSalutation();
    }
    
    
    @isTest static void test_method_two() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity='testcity';
        acc.BillingCountry='testcountry';
        acc.BillingState='teststate';
        acc.BillingStreet='teststreet';
        acc.BillingPostalCode='95051';
        insert acc;
        
        Set<Id> oppHomeOwnerId = new Set<Id>(); //Set of Opportunity Ids
       Map<String,Id> accRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType); //Get Account RecordTypes
       Map<String,Id> oppRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SObjectType); //Get Opportunity RecordTypes
       Id accountRtId = accRTs.get('Home_Owner'); 
       Id oppRtId = oppRTs.get('Home_Owner');
        
        Opportunity opp = new Opportunity();
        opp.Account = acc;
        opp.Name='testopp';
        opp.StageName = 'New Opportunity';
        opp.CloseDate = system.today();
        //opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
        opp.RecordTypeId = oppRtId;
        insert opp;
       
        Test.setCurrentPageReference(Page.SPCommunityOpportunityEdit);
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        ApexPages.currentPage().getParameters().put('RecordType', opp.RecordTypeId);
        ApexPages.currentPage().getParameters().put('RecordType', opp.RecordTypeId);
        ApexPages.currentPage().getParameters().put('Opportunity__c', opp.Id);
        ApexPages.currentPage().getParameters().put('Account__c', acc.Id);
        
        //Test.setCurrentPageReference(Page.SPCommunityAccountEdit);
        //ApexPages.currentPage().getParameters().put('id', acc.Id);

        ApexPages.standardController con = new ApexPages.standardController(opp);

        system.debug('myPage: ' + ApexPages.currentPage().getUrl());
        CreateEditExtensionController constructor = new CreateEditExtensionController(con);

        constructor.getSalutation();
    }
    
    
    @isTest static void test_method_three() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity='testcity';
        acc.BillingCountry='testcountry';
        acc.BillingState='teststate';
        acc.BillingStreet='teststreet';
        acc.BillingPostalCode='95051';
        insert acc;
        
        Set<Id> oppHomeOwnerId = new Set<Id>(); //Set of Opportunity Ids
       Map<String,Id> accRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType); //Get Account RecordTypes
       Map<String,Id> conRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Contact.SObjectType); //Get Opportunity RecordTypes
       Id accountRtId = accRTs.get('Home_Owner'); 
       Id conRTId = conRTs.get('Customer');
        
        contact cont = new contact();
        cont.Account = acc;
        cont.lastname='testcon';
        cont.RecordTypeId = conRTId;
        insert cont;
       
        Test.setCurrentPageReference(Page.SPCommunityContactEdit);
        ApexPages.currentPage().getParameters().put('id', cont.Id);
        ApexPages.currentPage().getParameters().put('RecordType', cont.RecordTypeId);
        ApexPages.currentPage().getParameters().put('Account__c', acc.Id);
        
        //Test.setCurrentPageReference(Page.SPCommunityAccountEdit);
        //ApexPages.currentPage().getParameters().put('id', acc.Id);

        ApexPages.standardController con = new ApexPages.standardController(cont);

        system.debug('myPage: ' + ApexPages.currentPage().getUrl());
        CreateEditExtensionController constructor = new CreateEditExtensionController(con);

        constructor.getSalutation();
    }
    
    @isTest static void test_method_four() {
        
        Map<String,Id> docRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Document__c.SObjectType); //Get Opportunity RecordTypes
       Id docRtId = docRTs.get('Document'); 
       
        
        Document__c doc = new Document__c();
        doc.Name = 'test';
        doc.RecordTypeId = docRtId;
        insert doc;
       
        Test.setCurrentPageReference(Page.SPCommunityDocumentEdit);
        ApexPages.currentPage().getParameters().put('id', doc.Id);
               
        ApexPages.standardController con = new ApexPages.standardController(doc);

        system.debug('myPage: ' + ApexPages.currentPage().getUrl());
        CreateEditExtensionController constructor = new CreateEditExtensionController(con);

        constructor.getSalutation();
    }
    
    
    
      @isTest static void test_method_five() {
        
        //Map<String,Id> agreementRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(echosign_dev1__SIGN_Agreement__c.SObjectType); //Get Opportunity RecordTypes
       //Id agreementRtId = agreementRTs.get('Cancelled'); 
       
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity='testcity';
        acc.BillingCountry='testcountry';
        acc.BillingState='teststate';
        acc.BillingStreet='teststreet';
        acc.BillingPostalCode='95051';
        insert acc;
        
        Task tsk = new task();
        tsk.WhatId = acc.id;
        tsk.WhoId = acc.Owner.Id;
        tsk.Subject = 'Other';
        tsk.priority= 'Normal';
        tsk.status = 'Not Started';
        tsk.description = 'New  Work';
        insert tsk;
       
        Test.setCurrentPageReference(Page.SPCommunityDocumentEdit);
        ApexPages.currentPage().getParameters().put('id', tsk.Id);
               
        ApexPages.standardController con = new ApexPages.standardController(tsk);

        system.debug('myPage: ' + ApexPages.currentPage().getUrl());
        CreateEditExtensionController constructor = new CreateEditExtensionController(con);

        constructor.getSalutation();
    }
    
    
        @isTest static void test_method_Six() {
        
        //Map<String,Id> agreementRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(echosign_dev1__SIGN_Agreement__c.SObjectType); //Get Opportunity RecordTypes
       //Id agreementRtId = agreementRTs.get('Cancelled'); 
       
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity='testcity';
        acc.BillingCountry='testcountry';
        acc.BillingState='teststate';
        acc.BillingStreet='teststreet';
        acc.BillingPostalCode='95051';
        insert acc;
        
        Event evt = new Event();
        evt.WhatId = acc.id;
        evt.WhoId = acc.Owner.Id;
        evt.Subject = 'Other';
        evt.EndDateTime= datetime.now();
        evt.StartDateTime = datetime.now();
        insert evt;
       
        Test.setCurrentPageReference(Page.SPCommunityDocumentEdit);
        ApexPages.currentPage().getParameters().put('id', evt.Id);
               
        ApexPages.standardController con = new ApexPages.standardController(evt);

        system.debug('myPage: ' + ApexPages.currentPage().getUrl());
        CreateEditExtensionController constructor = new CreateEditExtensionController(con);

        constructor.getSalutation();
    }
    
      @isTest static void test_method_seven() {
        
        //Map<String,Id> agreementRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(echosign_dev1__SIGN_Agreement__c.SObjectType); //Get Opportunity RecordTypes
       //Id agreementRtId = agreementRTs.get('Cancelled'); 
       
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity='testcity';
        acc.BillingCountry='testcountry';
        acc.BillingState='teststate';
        acc.BillingStreet='teststreet';
        acc.BillingPostalCode='95051';
        insert acc;
        
        Residential_Project__c rp = new Residential_Project__c();
        rp.Account__c = acc.Id;
        rp.Name = 'test';
        insert rp;
        
        Project_Task__c pt = new Project_Task__c();
        pt.Name ='test1';
        pt.Residential_Project__c = rp.Id;
        pt.Order__c=2;
        pt.Status__c = 'Not Started';
        pt.Assigned_To__c = rp.OwnerId;
        insert pt;
       
        Test.setCurrentPageReference(Page.SPCommunityDocumentEdit);
        ApexPages.currentPage().getParameters().put('id', pt.Id);
               
        ApexPages.standardController con = new ApexPages.standardController(pt);

        system.debug('myPage: ' + ApexPages.currentPage().getUrl());
        CreateEditExtensionController constructor = new CreateEditExtensionController(con);

        constructor.getSalutation();
    }
    
    
}