@isTest
public class CreatePartnerApplicationTest {

    private static testMethod void test_AsiaPacific() {
        CreatePartnerApplicationTestData td = new CreatePartnerApplicationTestData();
        td.createTestData();
        
        // lead
        td.lead_1.Theater__c = 'Asia Pacific';
        insert new List <Lead>{td.lead_1};
    
        PageReference pr = Page.CreatePartnerApplication;
        pr.getParameters().put('LId', td.lead_1.Id);
        Test.setCurrentPageReference(pr);
        
        CreatePartnerApplication controller = new CreatePartnerApplication();
        
        String recordTypeId = Schema.SObjectType.Partner_Application__c.getRecordTypeInfosByName().get('JP Partner Application').getRecordTypeId();
        system.assertEquals(recordTypeId, controller.partnerApplication.RecordTypeId);
    }

    private static testMethod void test_Australia() {
        CreatePartnerApplicationTestData td = new CreatePartnerApplicationTestData();
        td.createTestData();
        
        // lead
        td.lead_1.Theater__c = 'Australia';
        insert new List <Lead>{td.lead_1};
    
        PageReference pr = Page.CreatePartnerApplication;
        pr.getParameters().put('LId', td.lead_1.Id);
        Test.setCurrentPageReference(pr);
        
        CreatePartnerApplication controller = new CreatePartnerApplication();
        
        String recordTypeId = Schema.SObjectType.Partner_Application__c.getRecordTypeInfosByName().get('AUS Partner Application').getRecordTypeId();
        system.assertEquals(recordTypeId, controller.partnerApplication.RecordTypeId);
    }

    private static testMethod void test_Europe() {
        CreatePartnerApplicationTestData td = new CreatePartnerApplicationTestData();
        td.createTestData();
        
        // lead
        td.lead_1.Theater__c = 'Europe';
        insert new List <Lead>{td.lead_1};
    
        PageReference pr = Page.CreatePartnerApplication;
        pr.getParameters().put('LId', td.lead_1.Id);
        Test.setCurrentPageReference(pr);
        
        CreatePartnerApplication controller = new CreatePartnerApplication();
        
        String recordTypeId = Schema.SObjectType.Partner_Application__c.getRecordTypeInfosByName().get('EU Partner Application').getRecordTypeId();
        system.assertEquals(recordTypeId, controller.partnerApplication.RecordTypeId);
    }

    private static testMethod void test_NorthAmerica_Residential() {
        CreatePartnerApplicationTestData td = new CreatePartnerApplicationTestData();
        td.createTestData();
        
        // lead
        td.lead_1.Theater__c = 'North America';
        td.lead_1.Partner_Type__c = 'Residential';
        insert new List <Lead>{td.lead_1};
    
        PageReference pr = Page.CreatePartnerApplication;
        pr.getParameters().put('LId', td.lead_1.Id);
        Test.setCurrentPageReference(pr);
        
        CreatePartnerApplication controller = new CreatePartnerApplication();
        
        String recordTypeId = Schema.SObjectType.Partner_Application__c.getRecordTypeInfosByName().get('NA Partner Application').getRecordTypeId();
        system.assertEquals(recordTypeId, controller.partnerApplication.RecordTypeId);
    }

    private static testMethod void test_NorthAmerica_Commercial() {
        CreatePartnerApplicationTestData td = new CreatePartnerApplicationTestData();
        td.createTestData();
        
        // lead
        td.lead_1.Theater__c = 'North America';
        td.lead_1.Partner_Type__c = 'Commercial';
        insert new List <Lead>{td.lead_1};
    
        PageReference pr = Page.CreatePartnerApplication;
        pr.getParameters().put('LId', td.lead_1.Id);
        Test.setCurrentPageReference(pr);
        
        CreatePartnerApplication controller = new CreatePartnerApplication();
        
        String recordTypeId = Schema.SObjectType.Partner_Application__c.getRecordTypeInfosByName().get('NA Commercial Partner Application').getRecordTypeId();
        system.assertEquals(recordTypeId, controller.partnerApplication.RecordTypeId);
    }

    private static testMethod void test_Language() {
        CreatePartnerApplicationTestData td = new CreatePartnerApplicationTestData();
        td.createTestData();
        
        // lead
        insert new List <Lead>{td.lead_1};
        
        PageReference pr = Page.CreatePartnerApplication;
        pr.getParameters().put('LId', td.lead_1.Id);
        pr.getParameters().put('Lang', 'English');
        Test.setCurrentPageReference(pr);
        
        CreatePartnerApplication controller = new CreatePartnerApplication();
        
        system.assertEquals('English', controller.partnerApplication.language__c);
    }

    private static testMethod void test_Type() {
        CreatePartnerApplicationTestData td = new CreatePartnerApplicationTestData();
        td.createTestData();
        
        // lead
        insert new List <Lead>{td.lead_1};
        
        PageReference pr = Page.CreatePartnerApplication;
        pr.getParameters().put('LId', td.lead_1.Id);
        pr.getParameters().put('Type', 'Commercial');
        Test.setCurrentPageReference(pr);
        
        CreatePartnerApplication controller = new CreatePartnerApplication();
        
        system.assertEquals('Commercial', controller.partnerApplication.partner_application_type__c);
    }

    private static testMethod void test_saveAndMove() {
        CreatePartnerApplicationTestData td = new CreatePartnerApplicationTestData();
        td.createTestData();
        
        // lead
        td.lead_1.Theater__c = 'Asia Pacific';
        td.lead_1.Company = 'company_1';    // Company_Name__c required in partner application
        insert new List <Lead>{td.lead_1};
    
        PageReference pr = Page.CreatePartnerApplication;
        pr.getParameters().put('LId', td.lead_1.Id);
        Test.setCurrentPageReference(pr);
        
        CreatePartnerApplication controller = new CreatePartnerApplication();
        controller.saveAndMove();
        system.assertEquals(null, controller.errorMessage);
        
        Partner_Application__c pa = [SELECT Id FROM Partner_Application__c];
        Lead l = [SELECT Id, Partner_Application__c FROM Lead WHERE Id = :td.lead_1.Id];
        
        system.assertEquals(pa.Id, l.Partner_Application__c);
    }
    
}