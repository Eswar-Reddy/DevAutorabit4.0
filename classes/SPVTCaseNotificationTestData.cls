@isTest
public class SPVTCaseNotificationTestData {
    public Account account_1, partner_1;
    public Case case_1;
    public Contact contact_1;
    
    public void createTestData_noContactRole() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        insert new List <SPVT_Settings__c>{s_1};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('partner_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id;    
        insert new List <Account>{account_1, partner_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.Id = getFakeId(Case.SObjectType);
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
    }

    public void createTestData_contactRole() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_ContactRole_1', Value__c = 'ContactRole_1');
        insert new List <SPVT_Settings__c>{s_1, s_2};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('partner_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id; 
        partner_1.Status__c = 'Active';   
        insert new List <Account>{account_1, partner_1};
        
        // contacts
        contact_1 = getNewContact(partner_1.Id, 'fn_1', 'ln_1', 'fn_1.ln_1@testsp.com');
        insert new List <Contact>{contact_1};
        
        // account contact roles
        AccountContactRole acr_1 = getNewAccountContactRole(partner_1.Id, contact_1.Id, 'ContactRole_1');
        insert new List <AccountContactRole>{acr_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.Id = getFakeId(Case.SObjectType);
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
    }

    public void createTestData_additionalEmails() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_ContactRole_1', Value__c = 'ContactRole_1');
        SPVT_Settings__c s_3 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_AdditionalEmail_1', Value__c = 'email_1@testsp.com');
        SPVT_Settings__c s_4 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_AdditionalEmail_2', Value__c = 'email_2@testsp.com');
        insert new List <SPVT_Settings__c>{s_1, s_2, s_3, s_4};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('partner_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id;    
        partner_1.Status__c = 'Active';
        insert new List <Account>{account_1, partner_1};
        
        // contacts
        contact_1 = getNewContact(partner_1.Id, 'fn_1', 'ln_1', 'fn_1.ln_1@testsp.com');
        insert new List <Contact>{contact_1};
        
        // account contact roles
        AccountContactRole acr_1 = getNewAccountContactRole(partner_1.Id, contact_1.Id, 'ContactRole_1');
        insert new List <AccountContactRole>{acr_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.Id = getFakeId(Case.SObjectType);
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
    }

    public void createTestData_orgWideEmailAddress() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_ContactRole_1', Value__c = 'ContactRole_1');
        SPVT_Settings__c s_3 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_OrgWideEmailAddressId', Value__c = getFakeId(OrgWideEmailAddress.SObjectType));
        insert new List <SPVT_Settings__c>{s_1, s_2, s_3};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('partner_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id; 
        partner_1.Status__c = 'Active';   
        insert new List <Account>{account_1, partner_1};
        
        // contacts
        contact_1 = getNewContact(partner_1.Id, 'fn_1', 'ln_1', 'fn_1.ln_1@testsp.com');
        insert new List <Contact>{contact_1};
        
        // account contact roles
        AccountContactRole acr_1 = getNewAccountContactRole(partner_1.Id, contact_1.Id, 'ContactRole_1');
        insert new List <AccountContactRole>{acr_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.Id = getFakeId(Case.SObjectType);
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
    }

    public void createTestData_SPD_contactRole() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_ContactRole_1', Value__c = 'ContactRole_1');
        SPVT_Settings__c s_3 = new SPVT_Settings__c(Name = 'SPVT_Fail_SPD_Account_Name', Value__c = 'SPD_1');
        insert new List <SPVT_Settings__c>{s_1, s_2, s_3};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('SPD_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id; 
        partner_1.Status__c = 'Active';   
        insert new List <Account>{account_1, partner_1};
        
        // contacts
        contact_1 = getNewContact(partner_1.Id, 'fn_1', 'ln_1', 'fn_1.ln_1@testsp.com');
        insert new List <Contact>{contact_1};
        
        // account contact roles
        AccountContactRole acr_1 = getNewAccountContactRole(partner_1.Id, contact_1.Id, 'ContactRole_1');
        insert new List <AccountContactRole>{acr_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.Id = getFakeId(Case.SObjectType);
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
    }

    public void createTestData_nonSPD_inactive_contactRole() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_ContactRole_1', Value__c = 'ContactRole_1');
        SPVT_Settings__c s_3 = new SPVT_Settings__c(Name = 'SPVT_Fail_SPD_Account_Name', Value__c = 'SPD_1');
        insert new List <SPVT_Settings__c>{s_1, s_2, s_3};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('partner_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id; 
        partner_1.Status__c = 'Inactive'; 
        insert new List <Account>{account_1, partner_1};
        
        // contacts
        contact_1 = getNewContact(partner_1.Id, 'fn_1', 'ln_1', 'fn_1.ln_1@testsp.com');
        insert new List <Contact>{contact_1};
        
        // account contact roles
        AccountContactRole acr_1 = getNewAccountContactRole(partner_1.Id, contact_1.Id, 'ContactRole_1');
        insert new List <AccountContactRole>{acr_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.Id = getFakeId(Case.SObjectType);
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
    }

    public void createTestData_NotificationFlag_NonSPD() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_ContactRole_1', Value__c = 'ContactRole_1');
        insert new List <SPVT_Settings__c>{s_1, s_2};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('partner_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id; 
        partner_1.Status__c = 'Active';   
        insert new List <Account>{account_1, partner_1};
        
        // contacts
        contact_1 = getNewContact(partner_1.Id, 'fn_1', 'ln_1', 'fn_1.ln_1@testsp.com');
        insert new List <Contact>{contact_1};
        
        // account contact roles
        AccountContactRole acr_1 = getNewAccountContactRole(partner_1.Id, contact_1.Id, 'ContactRole_1');
        insert new List <AccountContactRole>{acr_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.Id = getFakeId(Case.SObjectType);
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
    }

    public void createTestData_NotificationFlag_SPD() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_ContactRole_1', Value__c = 'ContactRole_1');
        SPVT_Settings__c s_3 = new SPVT_Settings__c(Name = 'SPVT_Fail_SPD_Account_Name', Value__c = 'SPD_1');
        insert new List <SPVT_Settings__c>{s_1, s_2, s_3};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('SPD_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id; 
        partner_1.Status__c = 'Active';   
        insert new List <Account>{account_1, partner_1};
        
        // contacts
        contact_1 = getNewContact(partner_1.Id, 'fn_1', 'ln_1', 'fn_1.ln_1@testsp.com');
        insert new List <Contact>{contact_1};
        
        // account contact roles
        AccountContactRole acr_1 = getNewAccountContactRole(partner_1.Id, contact_1.Id, 'ContactRole_1');
        insert new List <AccountContactRole>{acr_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.Id = getFakeId(Case.SObjectType);
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
    }

    public void createTestData_caseTrigger() {
        // custom settings
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_EmailTemplateId', Value__c = getFakeId(EmailTemplate.SObjectType));
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_ContactRole_1', Value__c = 'ContactRole_1');
        insert new List <SPVT_Settings__c>{s_1, s_2};
        
        // accounts
        account_1 = getNewAccount('account_1');    
        partner_1 = getNewAccount('partner_1');
        partner_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1].Id; 
        partner_1.Status__c = 'Active';   
        insert new List <Account>{account_1, partner_1};
        
        // contacts
        contact_1 = getNewContact(partner_1.Id, 'fn_1', 'ln_1', 'fn_1.ln_1@testsp.com');
        insert new List <Contact>{contact_1};
        
        // account contact roles
        AccountContactRole acr_1 = getNewAccountContactRole(partner_1.Id, contact_1.Id, 'ContactRole_1');
        insert new List <AccountContactRole>{acr_1};
        
        // case    
        case_1 = getNewCase('case_1');
        case_1.SPVT_Case__c = true;
        case_1.Partner_Name__c = partner_1.Id;
        insert new List <Case>{case_1};
    }
    
    private static Account getNewAccount(String name) {
        Account a = new Account();
        a.Name = name; 
        a.BillingStreet = '100 XYZ Plaza';
        a.BillingCity = 'Sunnyvale';
        a.BillingState = 'CA';
        a.BillingCountry = 'United States'; 
        a.BillingPostalCode = '94086';     
        return a;    
    }
    
    private static Case getNewCase(String subject) {
        Case c = new Case();
        c.Subject = subject;
        return c;
    }
    
    private static Contact getNewContact(String accountId, String firstName, String lastName, String email) {
        Contact c = new Contact();
        c.AccountId = accountId;
        c.FirstName = firstName;
        c.LastName = lastName;
        c.Email = email;
        return c;
    }
    
    private static AccountContactRole getNewAccountContactRole(String accountId, String contactId, String role) {
        AccountContactRole acr = new AccountContactRole();
        acr.AccountId = accountId;
        acr.ContactId = contactId;
        acr.Role = role;
        return acr;
    }
    
    private static Integer s_num = 1;
    private static String getFakeId(Schema.SObjectType sot) {
        String result = String.valueOf(s_num++);
        return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

}