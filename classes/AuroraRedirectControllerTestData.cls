@isTest
public class AuroraRedirectControllerTestData {
    public Site_Information_Form__c site_1;
    public Design__c design_1;
    public Roof_Design__c roofDesign_1;
    
    public void createTestData_newInternalProject() {
        Loan_Callout_Settings__c s_1 = getNewCustomSetting();
        insert new List <Loan_Callout_Settings__c>{s_1};
    
        site_1 = createSite(null);
        insert new List <Site_Information_Form__c>{site_1};
    }

    public void createTestData_oldInternalProject() {
        Loan_Callout_Settings__c s_1 = getNewCustomSetting();
        insert new List <Loan_Callout_Settings__c>{s_1};
    
        site_1 = createSite(null);
        site_1.Internal_Project_Id__c = 'testInternalProjectId';
        insert new List <Site_Information_Form__c>{site_1};
    }

    public void createTestData_newDesign_newInternalProject() {
        Loan_Callout_Settings__c s_1 = getNewCustomSetting();
        insert new List <Loan_Callout_Settings__c>{s_1};
    
        site_1 = createSite(null);
        insert new List <Site_Information_Form__c>{site_1};
        
        design_1 = getNewDesign(site_1.Id);
        insert new List <Design__c>{design_1};
    }

    public void createTestData_newDesign_oldInternalProject() {
        Loan_Callout_Settings__c s_1 = getNewCustomSetting();
        insert new List <Loan_Callout_Settings__c>{s_1};
    
        site_1 = createSite(null);
        site_1.Internal_Project_Id__c = 'testInternalProjectId';
        insert new List <Site_Information_Form__c>{site_1};
        
        design_1 = getNewDesign(site_1.Id);
        insert new List <Design__c>{design_1};
    }

    public void createTestData_oldDesign() {
        Loan_Callout_Settings__c s_1 = getNewCustomSetting();
        insert new List <Loan_Callout_Settings__c>{s_1};
    
        site_1 = createSite(null);
        insert new List <Site_Information_Form__c>{site_1};
        
        roofDesign_1 = getNewRoofDesign();
        roofDesign_1.Design_DesignId__c = 'testDesignId';
        insert new List <Roof_Design__c>{roofDesign_1};
        
        design_1 = getNewDesign(site_1.Id);
        design_1.Roof_Design__c = roofDesign_1.Id;
        insert new List <Design__c>{design_1};
    }
    
    private static Site_Information_Form__c createSite(Id opptyId) {
        return TestFactory_Commercial.createBasicSite(opptyId).clone();    
    }
    
    private static Design__c getNewDesign(String siteId) {
        Design__c design = new Design__c();
        design.Site__c = siteId;
        return design;
    }
    
    private static Roof_Design__c getNewRoofDesign() {
        Roof_Design__c roofDesign = new Roof_Design__c();
        return roofDesign;
    }
    
    private static Loan_Callout_Settings__c getNewCustomSetting() {
        Loan_Callout_Settings__c s = new Loan_Callout_Settings__c();
        s.Name = 'Aurora';
        s.AuthURL_Production__c = 'testAuthURLProduction';
        s.AuthURL_Sandbox__c = 'testAuthURLSandbox';
        s.Client_Secret__c = 'testClientSecret';
        s.Endpoint_URL__c = 'testEndpointURL';
        s.Endpoint_URL_Sandbox__c = 'testEndpointURLSandbox';
        s.Redirect_URI_Production__c = 'testRedirectURIProduction';
        s.Redirect_URI_Sandbox__c = 'testRedirectURISandbox';
        s.Tenant_Id__c = 'testTenantId';
        s.UserType_Internal__c = 'testUserTypeInternal';
        s.UserType_Partner__c = 'testUserTypePartner';
        
        return s;
    }
}