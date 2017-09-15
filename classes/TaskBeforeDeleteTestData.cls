@isTest
public class TaskBeforeDeleteTestData {
    public Task task_1;
    public User user_1, user_2;
    
    public void createTestData_sysAdmin() {
        List <RecordType> rtList = [SELECT Id FROM RecordType 
            WHERE SObjectType = 'Task' AND DeveloperName = 'SPVT_Notification_Task' LIMIT 1];      
        String rtId;
        if (rtList.size() > 0) {
            rtId = rtList[0].Id;
        }
        user_1 =  getNewUser('System Administrator', 'user_1');
        user_1.SOX_Profile_was_approval_received__c = true;
        insert new List <User>{user_1}; 
        
        task_1 = new Task(Subject = 'test', RecordTypeId = rtId, Private__c = true);
        insert new List <Task>{task_1};        
                
    }

    public void createTestData_stdUser() {
        List <RecordType> rtList = [SELECT Id FROM RecordType 
            WHERE SObjectType = 'Task' AND DeveloperName = 'SPVT_Notification_Task' LIMIT 1];      
        String rtId;
        if (rtList.size() > 0) {
            rtId = rtList[0].Id;
        }
        user_2 =  getNewUser('Standard User', 'user_2');
        insert new List <User>{user_2}; 
        
        system.runAs(user_2) {        
            task_1 = new Task(Subject = 'test', RecordTypeId = rtId, Private__c = true);
            insert new List <Task>{task_1}; 
        }
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