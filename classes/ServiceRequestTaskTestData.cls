@isTest
public class ServiceRequestTaskTestData {
    public WorkOrder wo_1;
    public List <WorkOrder> woList;
    public User user_1, user_2;
    public Group queue_1;
    
    public void createTestData() {
        wo_1 = new WorkOrder();
        insert new List <WorkOrder>{wo_1};
    }
    
    public void createTestData_queue() {
        wo_1 = new WorkOrder();
        insert new List <WorkOrder>{wo_1};

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): QueueSobject, original object: WorkOrder
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
        
    }

    public void createTestDataBulk(Integer batchSize) {
        woList = new List <WorkOrder>();
        for (Integer i=0; i<batchSize; i++) {
            woList.add(new WorkOrder());
        }
        insert woList;
    }
    
    public void createUser(String profileName, String userName) {
        user_1 = getNewUser(profileName, userName);
        insert new List <User>{user_1};    
    }
    
    private static User getNewUser(String profileName, String userName) {
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