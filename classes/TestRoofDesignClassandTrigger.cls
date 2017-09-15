@isTest
public class TestRoofDesignClassandTrigger {
    
    public static Account customerAccount;
    public static Id rdMaxFitRecordTypeId;
    public static CreateRoofDesignController crdCtrl;
    
    static{
        UserManagement.IS_TEST = true;
        Loan_Callout_Settings__c  acs = new Loan_Callout_Settings__c(Name='Aurora', Endpoint_URL__c ='http://www.aurora.com', Endpoint_URL_Sandbox__c='http://www.aurora.com',Key__c ='key',Tenant_Id__c='tenantId',Client_Secret__c='clientSecret',Redirect_URI_Sandbox__c='https%3A%2F%2Fsandbox.aurorasolar.com%2F', Redirect_URI_Production__c='https%3A%2F%2Fsandbox.aurorasolar.com%2F');
        insert acs;

        CustomerAccount = TestUtils.createAccount( 'TestCPRDCustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'CA';
        CustomerAccount.BillingCountry= 'United States';
        CustomerAccount.Design_ProjectId__c = String.valueOf(System.now())+'tRDCandT';
        insert CustomerAccount;
        
        rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential MaxFit Designs').getRecordTypeId();
    }
    
    public static testMethod void testCreateRoofDesign(){
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccount);
        Test.setCurrentPageReference(Page.CreateRoofDesign);
        ApexPages.currentPage().getParameters().put('action', 'CreateDesign');
        crdCtrl = new CreateRoofDesignController(sc);
        crdCtrl.actionRedirect();

        crdCtrl.roofDesign = new Roof_Design__c(Notes_for_Design_Team__c = 'Notes', Expedited_Design_Request__c = false);

        crdCtrl.createRoofDesign();
        //CreateRoofDesign.checkandCreateRD(CustomerAccount.Id,'CreateDesign', testRD);
        
        Roof_Design__c rd = new Roof_Design__c(Account_Name__c=CustomerAccount.Id, Active__c=true, Status__c='Pending',RecordTypeId=rdMaxFitRecordTypeId,Origin__c='Self Service',Notes_for_Design_Team__c='notes');
        insert rd;
        //crdCtrl.actionredirect();
        //CreateRoofDesign.checkandCreateRD(CustomerAccount.Id,'CreateDesign', testRD);
        crdCtrl.createRoofDesign();
        
        rd.Status__c='Completed';
        update rd;

        //crdCtrl.actionredirect();

        crdCtrl.createRoofDesign();
        //CreateRoofDesign.checkandCreateRD(CustomerAccount.Id,'CreateDesign', testRD);
        
        test.stopTest();
    }

    public static testMethod void testRequestRoofDesign() {
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccount);
        Test.setCurrentPageReference(Page.CreateRoofDesign);
        ApexPages.currentPage().getParameters().put('action', 'RequestDesign');
        crdCtrl = new CreateRoofDesignController(sc);
        crdCtrl.actionRedirect();
        crdCtrl.roofDesign = new Roof_Design__c(Notes_for_Design_Team__c = 'Notes', Expedited_Design_Request__c = true);
        crdCtrl.requestRoofDesign();

        Roof_Design__c rd = new Roof_Design__c(Account_Name__c=CustomerAccount.Id, Active__c=true, Status__c='Pending',RecordTypeId=rdMaxFitRecordTypeId,Origin__c='Self Service',Notes_for_Design_Team__c='notes');
        insert rd;

        crdCtrl.requestRoofDesign();

        rd.Status__c = 'Completed';
        update rd;

        crdCtrl.requestRoofDesign();

        test.stopTest();
    }

    public static testMethod void testCreateRoofDesignNoBF() {
        User usr = [SELECT Id, Business_Function__c from User where Id = :Userinfo.getUserId()];
        usr.Business_Function__c = 'Create Cash Quote';
        update usr;

        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccount);
        Test.setCurrentPageReference(Page.CreateRoofDesign);
        ApexPages.currentPage().getParameters().put('action', 'CreateDesign');
        crdCtrl = new CreateRoofDesignController(sc);
        crdCtrl.actionRedirect();

        crdCtrl.roofDesign = new Roof_Design__c(Notes_for_Design_Team__c = 'Notes', Expedited_Design_Request__c = false);

        crdCtrl.createRoofDesign();
        test.stopTest();
    }
    
    public static testMethod void testRequestRoofDesignNoBF() {
        User usr = [SELECT Id, Business_Function__c from User where Id = :Userinfo.getUserId()];
        usr.Business_Function__c = 'Create Cash Quote';
        update usr;

        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccount);
        Test.setCurrentPageReference(Page.CreateRoofDesign);
        ApexPages.currentPage().getParameters().put('action', 'RequestDesign');
        crdCtrl = new CreateRoofDesignController(sc);
        crdCtrl.actionRedirect();
        crdCtrl.roofDesign = new Roof_Design__c(Notes_for_Design_Team__c = 'Notes', Expedited_Design_Request__c = true);
        crdCtrl.requestRoofDesign();
        test.stopTest();
    }

    public static testMethod void testCheckPairedRoofDesignTrigger(){
        
        test.startTest();
        Roof_Design__c rd1 = new Roof_Design__c(RecordTypeId=rdMaxFitRecordTypeId,Status__c='Pending',Active__c=true,Account_Name__c=CustomerAccount.Id);
        insert rd1;
        
        rd1.Status__c = 'Completed';
        update rd1;
        
        delete rd1;
        test.stopTest();
    }

}