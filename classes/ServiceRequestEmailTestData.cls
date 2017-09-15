@isTest
public class ServiceRequestEmailTestData {

    public Case case_1;
    public Group queue_1;
    public User User_1, User_2;

    public void createTestData_email_username() {
        EmailTemplate et_1 = getNewEmailTemplate('et_1');
        insert new List <EmailTemplate>{et_1};
        
        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): Service_Request_Settings__c, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_EmailPref_UserLogin_01', Default_Value__c = 'user_1@testsp.com'); 
            Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_EmailTemplateId_NewSR', Default_Value__c = et_1.Id); 
            insert new List <Service_Request_Settings__c>{s_1, s_2};   

            case_1 = new Case();    
            insert new List <Case>{case_1};    
        }
        
        user_1 = getNewUser('Standard User', 'user_1');
        insert new List <User>{user_1};
        
    }

    public void createTestData_email_profile() {
        EmailTemplate et_1 = getNewEmailTemplate('et_1');
        insert new List <EmailTemplate>{et_1};
        
        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): Service_Request_Settings__c, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_EmailPref_UserProfile_01', Default_Value__c = 'Standard User'); 
            Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_EmailTemplateId_NewSR', Default_Value__c = et_1.Id); 
            insert new List <Service_Request_Settings__c>{s_1, s_2};   

            case_1 = new Case();    
            insert new List <Case>{case_1};    
        }
        
        user_1 = getNewUser('Standard User', 'user_1');
        insert new List <User>{user_1};
        
    }

    public void createTestData_email_userRole() {
        EmailTemplate et_1 = getNewEmailTemplate('et_1');
        insert new List <EmailTemplate>{et_1};
        
        UserRole ur_1 = new UserRole(Name = 'ur_1');
        insert new List <UserRole>{ur_1};
        
        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): Service_Request_Settings__c, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_EmailPref_UserRole_01', Default_Value__c = 'ur_1'); 
            Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_EmailTemplateId_NewSR', Default_Value__c = et_1.Id); 
            insert new List <Service_Request_Settings__c>{s_1, s_2};   

            case_1 = new Case();    
            insert new List <Case>{case_1};    
        }
        
        user_1 = getNewUser('Standard User', 'user_1');
        user_1.UserRoleId = ur_1.Id;
        insert new List <User>{user_1};
        
    }

    public void createTestData_email_profile_queue() {
        EmailTemplate et_1 = getNewEmailTemplate('et_1');
        insert new List <EmailTemplate>{et_1};

        // create queue and queue users
        queue_1 = new Group(Name='Test_SP_SR_Group', type='Queue');
        insert new List <Group>{queue_1};
        QueuesObject qo_1 = new QueueSObject(QueueID = queue_1.id, SobjectType = 'WorkOrder');
        insert new List <QueuesObject>{qo_1};
        user_1 = getNewUser('Standard User', 'user_1');
        user_2 = getNewUser('Standard User', 'user_2');
        insert new List <User>{user_1, user_2};
        GroupMember gm_1 = new GroupMember(GroupId = queue_1.Id, UserOrGroupId = user_1.Id);
        GroupMember gm_2 = new GroupMember(GroupId = queue_1.Id, UserOrGroupId = user_2.Id);
        insert new List <GroupMember>{gm_1, gm_2};

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): Service_Request_Settings__c, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_EmailPref_UserProfile_01', Default_Value__c = 'Standard User'); 
            Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_EmailTemplateId_NewSR', Default_Value__c = et_1.Id); 
            insert new List <Service_Request_Settings__c>{s_1, s_2};   

            case_1 = new Case();    
            insert new List <Case>{case_1};    
        }
        
    }

    public void createTestData_email_queue_noMembers() {
        // create queue and queue users
        queue_1 = new Group(Name='Test_SP_SR_Group', type='Queue', Email='testQueue@testsp.com');
        insert new List <Group>{queue_1};
        QueuesObject qo_1 = new QueueSObject(QueueID = queue_1.id, SobjectType = 'WorkOrder');
        insert new List <QueuesObject>{qo_1};

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): Service_Request_Settings__c, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_EmailPref_QueueName_01', Default_Value__c = 'Test_SP_SR_Group'); 
            insert new List <Service_Request_Settings__c>{s_1};   

            case_1 = new Case();    
            insert new List <Case>{case_1};    
        }
        
    }

    public void createTestData_email_ownerChange() {
        EmailTemplate et_1 = getNewEmailTemplate('et_1');
        insert new List <EmailTemplate>{et_1};
        
        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): Service_Request_Settings__c, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_EmailPref_UserLogin_01', Default_Value__c = 'user_1@testsp.com'); 
            Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_EmailPref_UserLogin_02', Default_Value__c = 'user_2@testsp.com'); 
            Service_Request_Settings__c s_3 = new Service_Request_Settings__c(Name = 'SR_EmailTemplateId_NewSR', Default_Value__c = et_1.Id); 
            insert new List <Service_Request_Settings__c>{s_1, s_2, s_3};   

            case_1 = new Case();    
            insert new List <Case>{case_1};    
        }
        
        user_1 = getNewUser('Standard User', 'user_1');
        user_2 = getNewUser('Standard User', 'user_2');
        insert new List <User>{user_1, user_2};
        
    }

    public void createTestData_email_profile_noTemplate() {
        EmailTemplate et_1 = getNewEmailTemplate('et_1');
        insert new List <EmailTemplate>{et_1};
        
        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): Service_Request_Settings__c, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_EmailPref_UserProfile_01', Default_Value__c = 'Standard User'); 
            Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_InputField_1', Default_Value__c = 'OwnerId~Service Request Owner'); 
            insert new List <Service_Request_Settings__c>{s_1, s_2};   

            case_1 = new Case();    
            insert new List <Case>{case_1};    
        }
        
        user_1 = getNewUser('Standard User', 'user_1');
        insert new List <User>{user_1};
        
    }

    public static User getNewUser(String profileName, String userName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User u = new User(
            Alias = userName, 
            Email = userName + '@testsp.com',
            EmailEncodingKey = 'UTF-8', 
            LastName = userName + 'LN', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', 
            UserName = userName + '@testsp.com',
            Country = 'United States',
            Division = 'IT');    
        
        return u;    
    }

    private static EmailTemplate getNewEmailTemplate(String developerName) {
        EmailTemplate et = new EmailTemplate();  
        et.Name = developerName;  
        et.DeveloperName = developerName;    
        et.TemplateType = 'visualforce';
        et.MarkUp = '<messaging:emailTemplate subject="test"><messaging:htmlEmailBody></messaging:htmlEmailBody></messaging:emailTemplate>';
        et.FolderId = UserInfo.getUserId();
        et.isActive = true;
        return et;    
    }

}