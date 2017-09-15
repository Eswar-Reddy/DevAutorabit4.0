@isTest
private class Opportunity_RoleAfterTriggers_Test {

    @TestSetup
    public static void setupDocData() {

        List<Document_Data_Matrix__c> matrixList = new List<Document_Data_Matrix__c>();
        Document_Data_Matrix__c d = new Document_Data_Matrix__c();
        d.Name = 'Test';
        d.Contract_Type__c = 'PPA';
        d.Deal_Type__c = 'PPA (including EPC)';
        d.Document_Type__c = 'Firm Offer Approval';
        d.Effective_End_Date__c = Date.today().addDays(30);
        d.Effective_Start_Date__c = Date.today().addDays(-1);
        d.Required_for_Approval__c = true;
        d.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Document_Data_Matrix__c', 'Opportunity Role');
        matrixList.add(d);

        Document_Data_Matrix__c d2 = new Document_Data_Matrix__c();
        d2.Name = 'Test2';
        d2.Contract_Type__c = 'PPA';
        d2.Deal_Type__c = 'PPA (including EPC)';
        d2.Document_Type__c = 'Firm Offer Approval';
        d2.Effective_End_Date__c = Date.today().addDays(30);
        d2.Effective_Start_Date__c = Date.today().addDays(-1);
        d2.Required_for_Approval__c = true;
        d2.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Document_Data_Matrix__c', 'Opportunity Role');
        matrixList.add(d2);

        Document_Data_Matrix__c d3 = new Document_Data_Matrix__c();
        d3.Name = 'PR2 Test';
        d3.Contract_Type__c = 'PPA';
        d3.Deal_Type__c = 'PPA (including EPC)';
        d3.Document_Type__c = 'Customer Deal Approval';
        d3.Effective_End_Date__c = Date.today().addDays(30);
        d3.Effective_Start_Date__c = Date.today().addDays(-1);
        d3.Required_for_Approval__c = true;
        d3.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Document_Data_Matrix__c', 'Opportunity Role');
        matrixList.add(d3);

        Document_Data_Matrix__c d4 = new Document_Data_Matrix__c();
        d4.Name = 'PR2 Test2';
        d4.Contract_Type__c = 'PPA';
        d4.Deal_Type__c = 'PPA (including EPC)';
        d4.Document_Type__c = 'Customer Deal Approval';
        d4.Effective_End_Date__c = Date.today().addDays(30);
        d4.Effective_Start_Date__c = Date.today().addDays(-1);
        d4.Required_for_Approval__c = true;
        d4.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Document_Data_Matrix__c', 'Opportunity Role');
        matrixList.add(d4);

        Document_Data_Matrix__c d5 = new Document_Data_Matrix__c();
        d5.Name = 'Standard Contract Test1';
        d5.Contract_Type__c = 'PPA';
        d5.Deal_Type__c = 'PPA (including EPC)';
        d5.Document_Type__c = 'Standard Contract';
        d5.Effective_End_Date__c = Date.today().addDays(30);
        d5.Effective_Start_Date__c = Date.today().addDays(-1);
        d5.Required_for_Approval__c = true;
        d5.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Document_Data_Matrix__c', 'Opportunity Role');
        matrixList.add(d5);

        insert matrixList;

    }
    
    @isTest static void testAfterInsert() {
        
        Account a = TestClassFactory.testAccount('TestAcct', TestClassFactory.retrieveRecordTypeId('Account', 'Standard'));
        insert a;

        Opportunity o = TestClassFactory.testOpportunity('Commercial Opp1', '01 - Build Single Sales Objective', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems'));
        o.Contract_Type__c = 'PPA (including EPC)';
        o.Business_Unit__c = 'NA Commercial';
        o.Region1__c = 'Americas';
        o.Sub_Region__c = 'California - North';

        insert o;

        Test.startTest();
        Opportunity_Role__c role = new Opportunity_Role__c();
        role.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Opportunity_Role__c', 'Energy Off Taker (PPA)');
        role.Contract_Type__c = 'PPA';
        role.Account__c = a.Id;
        role.Opp_Name__c = o.Id;
        insert role;

        Integer pr1Records = [SELECT Count() From UC_Document__c WHERE Opportunity_Role__c =: role.Id AND Document_Type__c = 'Firm Offer Approval'];
        System.assertEquals(pr1Records, 2);

        Test.stopTest();
    }

    @isTest static void testEPCPath1() {
        
        Account a = TestClassFactory.testAccount('TestAcct', TestClassFactory.retrieveRecordTypeId('Account', 'Standard'));
        insert a;

        Opportunity o = TestClassFactory.testOpportunity('Commercial Opp1', '01 - Build Single Sales Objective', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems'));
        o.Contract_Type__c = 'EPC';
        o.Business_Unit__c = 'NA Commercial';
        o.Region1__c = 'Americas';
        o.Sub_Region__c = 'California - North';

        insert o;

        List<Document_Data_Matrix__c> epcDocs = new List<Document_Data_Matrix__c>();
        for(Document_Data_Matrix__c doc : [Select Id, Contract_Type__c, Deal_Type__c FROM Document_Data_Matrix__c]) {
            doc.Contract_Type__c = 'EPC';
            doc.Deal_Type__c = 'EPC';
            epcDocs.add(doc);
        }
        update epcDocs;

        Test.startTest();

        Opportunity_Role__c role = new Opportunity_Role__c();
        role.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Opportunity_Role__c', 'EPC Customer');
        role.Contract_Type__c = 'EPC';
        role.Account__c = a.Id;
        role.Opp_Name__c = o.Id;
        insert role;

        Integer pr1Records = [SELECT Count() From UC_Document__c WHERE Opportunity_Role__c =: role.Id AND Document_Type__c = 'Firm Offer Approval'];
        System.assertEquals(pr1Records, 2);

        Test.stopTest();
    }

    
    @isTest static void testAfterUpdate1() {
        Account a = TestClassFactory.testAccount('TestAcct', TestClassFactory.retrieveRecordTypeId('Account', 'Standard'));
        insert a;

        Opportunity o = TestClassFactory.testOpportunity('Commercial Opp1', '01 - Build Single Sales Objective', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems'));
        o.Contract_Type__c = 'PPA (including EPC)';
        o.Business_Unit__c = 'NA Commercial';
        o.Region1__c = 'Americas';
        o.Sub_Region__c = 'California - North';

        insert o;

        Test.startTest();
        Opportunity_Role__c role = new Opportunity_Role__c();
        role.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Opportunity_Role__c', 'Energy Off Taker (PPA)');
        role.Contract_Type__c = 'PPA';
        role.Account__c = a.Id;
        role.Opp_Name__c = o.Id;
        role.Status__c = 'Not Selected';
        insert role;
    
        Integer pr1Records = [SELECT Count() From UC_Document__c WHERE Opportunity_Role__c =: role.Id AND Document_Type__c = 'Firm Offer Approval'];
        System.assertEquals(pr1Records, 2);

        role.Status__c = 'Approved (PR1)';
        update role;        

        Integer pr2Records = [SELECT Count() From UC_Document__c WHERE Opportunity_Role__c =: role.Id AND Document_Type__c = 'Customer Deal Approval'];
        System.assertEquals(pr2Records, 2);
        
        Test.stopTest();
    }

    @isTest static void testAfterUpdate2() {
        Account a = TestClassFactory.testAccount('TestAcct', TestClassFactory.retrieveRecordTypeId('Account', 'Standard'));
        insert a;

        Opportunity o = TestClassFactory.testOpportunity('Commercial Opp1', '01 - Build Single Sales Objective', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems'));
        o.Contract_Type__c = 'PPA (including EPC)';
        o.Business_Unit__c = 'NA Commercial';
        o.Region1__c = 'Americas';
        o.Sub_Region__c = 'California - North';

        insert o;

        Test.startTest();
        Opportunity_Role__c role = new Opportunity_Role__c();
        role.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Opportunity_Role__c', 'Energy Off Taker (PPA)');
        role.Contract_Type__c = 'PPA';
        role.Account__c = a.Id;
        role.Opp_Name__c = o.Id;
        role.Status__c = 'Not Selected';
        insert role;
        
        role.Status__c = 'Approved (PR2)';
        update role;
        
        Test.stopTest();
        
        Integer contractRecords = [SELECT Count() From UC_Document__c WHERE Opportunity_Role__c =: role.Id AND Document_Type__c = 'Standard Contract'];
        System.assertEquals(contractRecords, 1);

        role.Contract_Status__c = 'Rejected';
        update role;

        role.Contract_Status__c = 'Approved';
        update role;
    }

    @isTest static void testAfterUpdate3() {
        Account a = TestClassFactory.testAccount('TestAcct', TestClassFactory.retrieveRecordTypeId('Account', 'Standard'));
        insert a;

        Opportunity o = TestClassFactory.testOpportunity('Commercial Opp1', '01 - Build Single Sales Objective', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems'));
        o.Contract_Type__c = 'PPA (including EPC)';
        o.Business_Unit__c = 'NA Commercial';
        o.Region1__c = 'Americas';
        o.Sub_Region__c = 'California - North';

        insert o;

        Test.startTest();
        Opportunity_Role__c role = new Opportunity_Role__c();
        role.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Opportunity_Role__c', 'Energy Off Taker (PPA)');
        role.Contract_Type__c = 'PPA';
        role.Account__c = a.Id;
        role.Opp_Name__c = o.Id;
        role.Status__c = 'Not Selected';
        insert role;
    
        Integer pr1Records = [SELECT Count() From UC_Document__c WHERE Opportunity_Role__c =: role.Id AND Document_Type__c = 'Firm Offer Approval'];
        System.assertEquals(pr1Records, 2);

        role.Status__c = 'Rejected (PR1)';
        update role;
        
        List<UC_Document__c> pr1Rejected = [SELECT Id, Document_Status__c From UC_Document__c WHERE Opportunity_Role__c =: role.Id AND Document_Type__c = 'Firm Offer Approval' And Document_Status__c = 'Rejected'];
        System.assertEquals(pr1Rejected.size(), 2, 'list: ' + pr1Rejected);
        Test.stopTest();
    }

    @isTest static void testNegatives() {
        Set<Id> emptySet = new Set<Id>();

        OpportunityRolesUtility util = new OpportunityRolesUtility();

        OpportunityRolesUtility.processOppRoleDocumentCreation(emptySet);

        Account a = TestClassFactory.testAccount('TestAcct', TestClassFactory.retrieveRecordTypeId('Account', 'Standard'));
        insert a;

        Opportunity o = TestClassFactory.testOpportunity('Commercial Opp1', '01 - Build Single Sales Objective', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems'));
        o.Contract_Type__c = 'PPA (including EPC)';
        o.Business_Unit__c = 'NA Commercial';
        o.Region1__c = 'Americas';
        o.Sub_Region__c = 'California - North';

        insert o;

        delete [SELECT Id FROM Document_Data_Matrix__c];

        Test.startTest();
        Opportunity_Role__c role = new Opportunity_Role__c();
        role.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Opportunity_Role__c', 'Energy Off Taker (PPA)');
        role.Contract_Type__c = 'PPA';
        role.Account__c = a.Id;
        role.Opp_Name__c = o.Id;
        insert role;

        Test.stopTest();
    }   
}