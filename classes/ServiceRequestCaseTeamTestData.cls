@isTest
public class ServiceRequestCaseTeamTestData {
    public Case case_1;
    public WorkOrder workOrder_1;
    public User user_1, user_2;
    public Group queue_1;
    
    public void createTestData_ownerUser() {
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_AddSROwner', Default_Value__c = 'true'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_Role', Default_Value__c = 'Service Request Owner'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        case_1 = new Case();    
        insert new List <Case>{case_1};    
        workOrder_1 = new WorkOrder(CaseId = case_1.Id); 
        insert new List <WorkOrder>{workOrder_1};
        
        user_1 =  getNewUser('Standard User', 'user_1');
        insert new List <User>{user_1};  
    }

    public void createTestData_ownerQueue() {
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_AddSROwner', Default_Value__c = 'true'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_Role', Default_Value__c = 'Service Request Owner'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): QueueSobject, original object: Service_Request_Settings__c
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
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
        }
        
        case_1 = new Case();    
        insert new List <Case>{case_1};    
        workOrder_1 = new WorkOrder(CaseId = case_1.Id); 
        insert new List <WorkOrder>{workOrder_1};
        
    }

    public void createTestData_existingTeam() {
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_AddSROwner', Default_Value__c = 'true'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_Role', Default_Value__c = 'Service Request Owner'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        case_1 = new Case();    
        insert new List <Case>{case_1};    
        workOrder_1 = new WorkOrder(CaseId = case_1.Id); 
        insert new List <WorkOrder>{workOrder_1};
        
        user_1 =  getNewUser('Standard User', 'user_1');
        insert new List <User>{user_1}; 
        
        CaseTeamMember ctm = new CaseTeamMember();
        ctm.ParentId = case_1.Id;    
        ctm.MemberId = user_1.Id;

        // looks like there is a bug after sandbox refresh. this is not fetching in SIT but works in production
        //ctm.TeamRoleId =  [SELECT Id FROM CaseTeamRole WHERE Name = 'Service Request Owner'].Id;
        for (CaseTeamRole ctr : [SELECT Id, Name FROM CaseTeamRole]) {
            if (ctr.Name == 'Service Request Owner') {
                ctm.TeamRoleId = ctr.Id;
            }
        }
        insert ctm;     
    }

    public void createTestData_flagOff() {
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_AddSROwner', Default_Value__c = 'false'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_Role', Default_Value__c = 'Service Request Owner'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        case_1 = new Case();    
        insert new List <Case>{case_1};    
        workOrder_1 = new WorkOrder(CaseId = case_1.Id); 
        insert new List <WorkOrder>{workOrder_1};
        
        user_1 =  getNewUser('Standard User', 'user_1');
        insert new List <User>{user_1};  
    }

    public void createTestData_roleNotFound() {
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_AddSROwner', Default_Value__c = 'true'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_Role', Default_Value__c = 'XXXYYYZZZ'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        case_1 = new Case();    
        insert new List <Case>{case_1};    
        workOrder_1 = new WorkOrder(CaseId = case_1.Id); 
        insert new List <WorkOrder>{workOrder_1};
        
        user_1 =  getNewUser('Standard User', 'user_1');
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
    
}