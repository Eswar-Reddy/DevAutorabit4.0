@isTest
public class AuroraProjectAPITestData {
    public Site_Information_Form__c site_1;
    
    public void createTestData_getProjectPage() {
        Loan_Callout_Settings__c s_1 = getNewCustomSetting();
        insert new List <Loan_Callout_Settings__c>{s_1};
        
    }

    public void createTestData_createProject() {
        Loan_Callout_Settings__c s_1 = getNewCustomSetting();
        insert new List <Loan_Callout_Settings__c>{s_1};
        
        site_1 = getNewSite();
        insert new List <Site_Information_Form__c>{site_1};
    }

    public void createTestData_createProject_internalProjectId_exists() {
        Loan_Callout_Settings__c s_1 = getNewCustomSetting();
        insert new List <Loan_Callout_Settings__c>{s_1};
        
        site_1 = getNewSite();
        site_1.Internal_Project_Id__c = 'testInternalProjectId';
        insert new List <Site_Information_Form__c>{site_1};
    }
    
    private static Site_Information_Form__c getNewSite() {
        Site_Information_Form__c site = new Site_Information_Form__c();
        return site;
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