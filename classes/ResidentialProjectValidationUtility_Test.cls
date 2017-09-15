@isTest
public with sharing class ResidentialProjectValidationUtility_Test {
	static testMethod void testSPDProjectUpdateValidation(){
        Boolean isError = false;

        Account partner = TestFactory_StandardObjects.getPartnerAccount();

        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL);
        project.Homeowner_Scheduled_Installation_Date__c = system.today().addDays(-10);
        project.Main_Service_Panel_Location__c = 'Exterior Wall';
        insert project;

        try {
            project.Homeowner_Scheduled_Installation_Date__c = system.today();
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        try {
            project.Priority__c = 'Fast-tracked';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        try {
            project.Sales_Order_Number__c = '1234';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        try {
            project.Status__c = 'Hold';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        Test.stopTest();
    }

    static testMethod void testSPDProjectUpdateROM(){
        Boolean isError = false;

        Account partner = TestFactory_StandardObjects.getPartnerAccount();

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL);
        insert project;

       TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Regional Operations Manager');

        Test.startTest();
        try {
            project.Homeowner_Scheduled_Installation_Date__c = system.today();
            project.Priority__c = 'Fast-tracked';
            project.Status__c = 'Hold';
            project.Installation_Partner__c = partner.Id;
            project.Hold_Justification__c = 'Financing';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, false);
        Test.stopTest();
    }

    static testMethod void testSPDProjectUpdateTSPM(){
        Boolean isError = false;

        Account partner = TestFactory_StandardObjects.getPartnerAccount();

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL);
        insert project;

        TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Technical Sales Project Manager');

        Test.startTest();
        try {
            project.Sales_Order_Number__c = '1234';
            project.Installation_Partner__c = partner.Id;
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, false);
        Test.stopTest();
    }

    static testMethod void testTPSProjectUpdateValidation(){
        Boolean isError = false;

        Installation_Model__c im = TestFactory_ResidentialProjMgmt.getInstallationModelIP();

        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL);
        insert project;

        try {
            project.Priority__c = 'Fast-tracked';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        try {
            project.Sales_Order_Number__c = '1234';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        try {
            project.Status__c = 'Hold';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        try {
            project.Installation_Model__c = im.Id;
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        Test.stopTest();
    }

    static testMethod void testTPSProjectUpdatePM(){
        Boolean isError = false;

        Installation_Model__c im = TestFactory_ResidentialProjMgmt.getInstallationModelIP();

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL);
        insert project;

        TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Project Manager');

        Test.startTest();
        try {
            project.Priority__c = 'Fast-tracked';
            project.Status__c = 'Hold';
            project.Hold_Justification__c = 'Financing';
            project.Installation_Model__c = im.Id;
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, false);
        Test.stopTest();
    }

    static testMethod void testTPSProjectUpdatePSR(){
        Boolean isError = false;

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL);
        insert project;

        TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Partner Support Representative');

        Test.startTest();
        try {
            project.Sales_Order_Number__c = '1234';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, false);
        Test.stopTest();
    }

    static testMethod void testTPSProjectUpdateTSPM(){
        Boolean isError = false;

        Installation_Model__c im = TestFactory_ResidentialProjMgmt.getInstallationModelIP();

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL);
        insert project;

        TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Technical Sales Project Manager');

        Test.startTest();
        try {
            project.Installation_Model__c = im.Id;
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, false);
        Test.stopTest();
    }

    static testMethod void testNewHomeProjectUpdateValidation(){
        Boolean isError = false;

        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL,NULL);
        insert project;

        Purchase_Order__c po = TestFactory_Ordering.createPurchaseOrder();

        try {
            project.Priority__c = 'Fast-tracked';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        isError = FALSE;

        try {
            project.Status__c = 'Hold';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        try {
            project.Purchase_Order__c = po.Id;
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        try {
            project.Sales_Order_Number__c = '1234';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, true);

        Test.stopTest();
    }

    static testMethod void testNewHomeProjectUpdatePM(){
        Boolean isError = false;

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL,NULL);
        insert project;

        TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Project Manager');

        Test.startTest();
        try {
            project.Priority__c = 'Fast-tracked';
            project.Status__c = 'Hold';
            project.Hold_Justification__c = 'Financing';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, false);
        Test.stopTest();
    }

    static testMethod void testNewHomeProjectUpdatePSR(){
        Boolean isError = false;

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL,NULL);
        insert project;

        TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Partner Support Representative');
        //Purchase_Order__c po = TestFactory_Ordering.createPurchaseOrder(); // beforePOInsertUpdate has some issues
        //insert po;

        Test.startTest();
        try {
            //project.Purchase_Order__c = po.Id;
            project.Sales_Order_Number__c = '1234';
            update project;
        } catch (Exception ex) {
            isError =  true;
        }
        System.AssertEquals(isError, false);
        Test.stopTest();
    }

    static testMethod void testcanCreate(){

        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProjectWithTemplateTaskOnly(NULL,NULL,NULL,NULL,NULL);
        insert project;

        TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Partner Support Representative');

        System.AssertEquals(ResidentialProjectValidationUtility.canCreate(project.Id, 'StandardLineItem__c'), true);
        Test.stopTest();
    }
}