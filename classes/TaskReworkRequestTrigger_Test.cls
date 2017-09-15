@isTest
public with sharing class TaskReworkRequestTrigger_Test {
    @testSetup
    static void setup() {
        String userEmail                = 'testprojectemail@sunpower.com';
        String userName                 = 'testprojectuser@sunpower.com';
        Datetime todaysDateTime         = Datetime.now();
        Integer numOfProjectsToCreate   = 1;
        Integer numOfTasksToCreate      = 5;

        Id ttId     = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId();
        Id ptId     = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Project Task').getRecordTypeId();
        Id rpspdId  = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('SPD').getRecordTypeId();
        Id rptId    = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('Project Template').getRecordTypeId();

        // Create test user for these projects/tasks
        Profile p = [SELECT Id FROM Profile WHERE Name = 'SunPower User'];
        User u = new User(Alias = 'tpu', Email = userEmail,
                          Emailencodingkey = 'UTF-8', Languagelocalekey = 'en_US', Localesidkey = 'en_US',
                          Timezonesidkey = 'America/Los_Angeles', Division = 'New', Country = 'US', LastName = 'Testing', ProfileId = p.Id,
                          UserName = userName);
        insert u;

        User u2 = new User(Alias = 'tpu2', Email = 'testprojectemail2@sunpower.com',
                           Emailencodingkey = 'UTF-8', Languagelocalekey = 'en_US', Localesidkey = 'en_US',
                           Timezonesidkey = 'America/Los_Angeles', Division = 'New', Country = 'US', FirstName = 'Test2', LastName = 'Testing2', ProfileId = p.Id,
                           UserName = 'testprojectuser2@sunpower.com');
        insert u2;

        // Create test accounts
        List<Account> testAccts = new List<Account>();
        for (Integer h = 0; h < numOfProjectsToCreate; h++) {
            testAccts.add(new Account(Name = 'TestAcct' + h, OwnerId = u.Id, BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345'));
        }
        insert testAccts;

        // Create test opportunities
        List<Opportunity> testOpps = new List<Opportunity>();
        for (Integer h = 0; h < numOfProjectsToCreate; h++) {
            testOpps.add(new Opportunity(Name = 'TestOppt', AccountId = testAccts[h].Id, CloseDate = system.today(), StageName = 'Contract Signed'));
        }
        insert testOpps;

        // Create project template
        Residential_Project__c tempResidentialProject = new Residential_Project__c();
        tempResidentialProject.RecordTypeId = rptId;
        tempResidentialProject.Account__c = testAccts[0].Id;
        tempResidentialProject.Status__c = 'Active'; //Hold, Cancelled or Completed
        tempResidentialProject.Name = 'SPD Template';
        tempResidentialProject.CurrencyIsoCode = 'USD';
        insert tempResidentialProject;

        // Create task template
        List<Project_Task__c> testProjectTasks = new List<Project_Task__c>();
        for (Integer j = 0; j < numOfTasksToCreate; j++) {
            Project_Task__c tempProjectTask = new Project_Task__c();
            tempProjectTask.Status__c = (Math.mod(j, 2) == 0) ? 'Hold' : 'In Progress'; //In Progress, Pending Approval, Completed and Hold
            tempProjectTask.RecordTypeId = ttId;
            tempProjectTask.Name = 'TestProjectTask' + j;
            tempProjectTask.SLA_Days__c = 1;
            tempProjectTask.Role_Assignment__c = (Math.mod(j, 2) == 0) ? 'Project Manager' : 'Project Coordinator'; //Project Manager and Project Coordinator
            tempProjectTask.Residential_Project__c = tempResidentialProject.Id;
            tempProjectTask.Order__c = j + 1;
            tempProjectTask.Critical_Path__c = true;
            tempProjectTask.Assigned_To__c = u.Id;
            tempProjectTask.Document_Required__c = (Math.mod(j, 2) == 0) ? true : false;
            testProjectTasks.add(tempProjectTask);
        }
        insert testProjectTasks;

        // Create project team members
        List<Project_Team_Member__c> testProjectTeamMembers = new List<Project_Team_Member__c>();
        testProjectTeamMembers.add(new Project_Team_Member__c(Residential_Project__c = tempResidentialProject.Id, Role__c = 'Project Manager'));
        testProjectTeamMembers.add(new Project_Team_Member__c(Residential_Project__c = tempResidentialProject.Id, Role__c = 'Project Coordinator'));
        insert testProjectTeamMembers;


        // Create Active Project
        Residential_Project__c testProject = new Residential_Project__c();
        testProject.RecordTypeId = rpspdId;
        testProject.Account__c = testAccts[0].Id;
        testProject.Opportunity__c = testOpps[0].Id;
        testProject.Status__c = 'Active'; //Hold, Cancelled or Completed
        testProject.Name = 'Test Residential Project';
        testProject.Project_Template__c = tempResidentialProject.Id;
        testProject.CurrencyIsoCode = 'USD';
        insert testProject;
    }

    @isTest
    static void createTaskRework(){
        Test.startTest();
        List<Project_Task__c> tasks = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__r.Name = 'Test Residential Project' ORDER BY Order__c ASC];

        tasks[0].Status__c = 'Completed';

        update tasks[0];

        Task_Rework_Request__c trr = new Task_Rework_Request__c();
        trr.Initiating_Task__c = tasks[1].Id;
        trr.Rework_Category__c = 'Resurvey';
        trr.Rework_Task__c = tasks[0].Id;
        trr.Explanation__c = 'Try again';
        insert trr;

        List<Project_Task__c> tasks2 = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__r.Name = 'Test Residential Project' ORDER BY Order__c ASC];
        system.assertEquals(tasks2[0].Status__c, 'Needs Rework');
        system.assertEquals(tasks2[1].Status__c, 'Pending Rework');
        Test.stopTest();
    }


    @isTest
    static void cancelTaskRework(){
        Test.startTest();
        List<Project_Task__c> tasks = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__r.Name = 'Test Residential Project' ORDER BY Order__c ASC];

        tasks[0].Status__c = 'Completed';

        update tasks[0];

        Task_Rework_Request__c trr = new Task_Rework_Request__c();
        trr.Initiating_Task__c = tasks[1].Id;
        trr.Rework_Category__c = 'Resurvey';
        trr.Rework_Task__c = tasks[0].Id;
        trr.Explanation__c = 'Try again';
        insert trr;

        trr.Status__c = 'Cancelled';
        update trr;

        List<Project_Task__c> tasks2 = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__r.Name = 'Test Residential Project' ORDER BY Order__c ASC];
        system.assertEquals(tasks2[0].Status__c, 'Completed');
        system.assertEquals(tasks2[1].Status__c, 'In Progress');

        Test.stopTest();
    }

    @isTest
    static void completeTaskRework(){
        Test.startTest();
        List<Project_Task__c> tasks = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__r.Name = 'Test Residential Project' ORDER BY Order__c ASC];

        tasks[0].Status__c = 'Completed';

        update tasks[0];
        
        Task_Rework_Request__c trr = new Task_Rework_Request__c();
        trr.Initiating_Task__c = tasks[1].Id;
        trr.Rework_Category__c = 'Resurvey';
        trr.Rework_Task__c = tasks[0].Id;
        trr.Explanation__c = 'Try again';
        insert trr;

        tasks[0].Status__c = 'Completed';
        update tasks[0];        

        List<Project_Task__c> tasks2 = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__r.Name = 'Test Residential Project' ORDER BY Order__c ASC];
        system.assertEquals(tasks2[0].Status__c, 'Completed');
        system.assertEquals(tasks2[1].Status__c, 'In Progress');
        Test.stopTest();
    }
}