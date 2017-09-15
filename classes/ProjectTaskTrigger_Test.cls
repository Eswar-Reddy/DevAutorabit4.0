@isTest
public class ProjectTaskTrigger_Test {
    @testSetup
    static void setup() {
        String userEmail                = 'testprojectemail@sunpower.com';
        String userName                 = 'testprojectuser@sunpower.com';
        Integer numOfProjectsToCreate   = 1;
        Integer numOfTasksToCreate      = 5;

        // Create test user for these projects/tasks
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'tpu', Email = userEmail,
                          Emailencodingkey = 'UTF-8', Languagelocalekey = 'en_US', Localesidkey = 'en_US',
                          Timezonesidkey = 'America/Los_Angeles', Division = 'New', Country = 'US', LastName = 'Testing', ProfileId = p.Id,
                          UserName = userName, ByPassValidation__c = TRUE, SOX_Profile_was_approval_received__c = TRUE);
        insert u;

        // Create test accounts
        List<Account> testAccts = new List<Account>();
        for (Integer h = 0; h < numOfProjectsToCreate; h++) {
            testAccts.add(TestFactory_StandardObjects.createResidentialCustomerAccount());
            testAccts[h].OwnerId = u.Id;
        }
        insert testAccts;

        // Create test opportunities
        List<Opportunity> testOpps = new List<Opportunity>();
        for (Integer h = 0; h < numOfProjectsToCreate; h++) {
            testOpps.add(TestFactory_StandardObjects.createHomeOwnerOpportunity(testAccts[h].Id, null));
            testOpps[h].StageName = 'Contract Signed';
        }
        insert testOpps;

        // Add Notes to Opp
        List<Note> testNotes = new List<Note>();
        for (Integer h = 0; h < numOfProjectsToCreate; h++) {
            testNotes.add(new Note(ParentId = testOpps[h].Id, Title = 'Test', Body = 'Test Body' ));
        }
        insert testNotes;

        // Add Documents to Opp
        List<Document__c> testDocs = new List<Document__c>();
        for (Integer h = 0; h < numOfProjectsToCreate; h++) {
            testDocs.add(new Document__c(Opportunity__c = testOpps[h].Id, Name = 'Test Doc', Document_Type__c = 'Test Doc'));
        }
        insert testDocs;

        // Create project template
        Residential_Project__c tempResidentialProject = TestFactory_ResidentialProjMgmt.createProjectTemplate();
        tempResidentialProject.Account__c = testAccts[0].Id;
        tempResidentialProject.Name = 'SPD Template';
        tempResidentialProject.Status__c = 'Active'; //Hold, Cancelled or Completed
        tempResidentialProject.CurrencyIsoCode = 'USD';
        insert tempResidentialProject;

        List<Project_Task__c> testProjectTasks = TestFactory_ResidentialProjMgmt.createTemplateTasks(tempResidentialProject.Id, numOfTasksToCreate);
        for (Integer j = 0; j < numOfTasksToCreate; j++) {
            testProjectTasks[j].Status__c = (Math.mod(j, 2) == 0) ? 'Hold' : 'In Progress'; //In Progress, Pending Approval, Completed and Hold
            testProjectTasks[j].Name = 'TestProjectTask' + j;
            testProjectTasks[j].SLA_Days__c = 1;
            testProjectTasks[j].Role_Assignment__c = (Math.mod(j, 2) == 0) ? 'Project Manager' : 'Project Coordinator'; //Project Manager and Project Coordinator
            testProjectTasks[j].Assigned_To__c = u.Id;
            testProjectTasks[j].Document_Required__c = (Math.mod(j, 2) == 0) ? true : false;
        }
        insert testProjectTasks;

        // Reset limits to avoid Too many SOQL 
        Test.StartTest();

        // Create project team members
        List<Project_Team_Member__c> testProjectTeamMembers = TestFactory_ResidentialProjMgmt.createTemplateTeamMembers(tempResidentialProject.Id, 2);
        insert testProjectTeamMembers;

        // Create documents
        List<Document__c> testDoc = TestFactory_ResidentialProjMgmt.createProjectDocuments(tempResidentialProject.Id, 1);
        insert testDoc;

        // Create test Quote
        Quote testQuote = TestFactory_StandardObjects.createProposalQuote(testOpps[0].Id);
        insert testQuote;

        // Create Active Project
        Residential_Project__c testProject = TestFactory_ResidentialProjMgmt.createSPDProjectWithTemplate(testAccts[0].Id, testOpps[0].Id, testQuote.Id, tempResidentialProject.Id);
        testProject.Status__c = 'Active'; //Hold, Cancelled or Completed
        testProject.Name = 'Test Residential Project';
        testProject.CurrencyIsoCode = 'USD';
        insert testProject;

        Test.StopTest();
    }

    @isTest
    static void testOrderCritChange() {
        Test.StartTest();
        Project_Task__c pt = [SELECT Id, Order__c, Critical_Path__c FROM Project_Task__c WHERE Critical_Path__c = TRUE AND RecordType.Name = 'Task Template' LIMIT 1];
        pt.Critical_Path__c = FALSE;
        update pt;
        Test.stopTest();
    }

    @isTest
    static void testNewTemplateTask() {
        Test.StartTest();
        Residential_Project__c tp = [SELECT Id FROM Residential_Project__c WHERE Name = 'SPD Template'];

        List<Project_Task__c> pt = TestFactory_ResidentialProjMgmt.createTemplateTasks(tp.Id, 1);
        pt[0].Order__c = 6;
        pt[0].Name = 'Close Out Project';
        pt[0].Role_Assignment__c = 'Project Manager';
        insert pt;

        List<Project_Task__c> tasks = [SELECT Id, Name, Task_Type_Name__c, Order__c FROM Project_Task__c WHERE Residential_Project__r.Id = :tp.Id ORDER BY Order__c ASC];

        system.AssertEquals(tasks.size(), 6);
        system.AssertEquals(tasks[5].Name, pt[0].Name);
        system.AssertEquals(tasks[5].Order__c, 6);

        Test.stopTest();
    }

    @isTest
    static void testTemplateTaskChange() {
        Residential_Project__c tp = [SELECT Id FROM Residential_Project__c WHERE Name = 'SPD Template'];

        Test.startTest();
        List<Project_Task__c> pt = TestFactory_ResidentialProjMgmt.createTemplateTasks(tp.Id, 1);
        pt[0].Order__c = 6;
        pt[0].Milestone__c = 'Design';
        pt[0].Description__c = 'Test Description';
        pt[0].Name = 'Close Out Project';
        pt[0].Role_Assignment__c = 'Project Manager';
        pt[0].SLA_Days__c = 2;
        insert pt;

        Residential_Project__c rp = [SELECT Id, (SELECT Id, Role__c , User__c FROM Project_Team_Members__r) FROM Residential_Project__c WHERE Name = 'Test Residential Project'];
        List<Project_Team_Member__c> ptmToUpdate = new List<Project_Team_Member__c>();
        User u = [SELECT Id FROM User WHERE Email = 'testprojectemail@sunpower.com' LIMIT 1];
        for (Project_Team_Member__c ptm : rp.Project_Team_Members__r) {
            if (ptm.Role__c == 'Project Manager') {
                ptm.User__c = UserInfo.getUserId();
            }
            if (ptm.Role__c == 'Project Coordinator') {
                ptm.User__c = u.Id;
            }
            ptmToUpdate.add(ptm);
        }
        update ptmToUpdate;

       
        Test.stopTest();
    }

    @isTest
    static void testProjectTaskNotifications() {
        Residential_Project__c rp = [SELECT Id, (SELECT Id, RecordTypeId, Order__c, Status__c FROM Project_Tasks__r ORDER BY Order__c ASC) FROM Residential_Project__c WHERE Name = 'Test Residential Project'];

        User u = [SELECT Id FROM User WHERE Email = 'testprojectemail@sunpower.com'];

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u2 = new User(Alias = 'tpu2', Email = 'testprojectemail2@sunpower.com',
            Emailencodingkey = 'UTF-8', Languagelocalekey = 'en_US', Localesidkey = 'en_US',
            Timezonesidkey = 'America/Los_Angeles', Division = 'New', Country = 'US', FirstName = 'Test2', LastName = 'Testing2', ProfileId = p.Id,
            UserName = 'testprojectuser2@sunpower.com', ByPassValidation__c = TRUE, SOX_Profile_was_approval_received__c = TRUE);
        insert u2;

        Test.startTest();
        Map<Id, Project_Task__c> ptcMap = new Map<Id, Project_Task__c>();
        Project_Task__c oldPt = new Project_Task__c();
        List<Project_Task__c> newPtList = new List<Project_Task__c>();

        rp.Project_Tasks__r[0].Status__c = 'Not Started';
        rp.Project_Tasks__r[0].Assigned_To__c = u.Id;
        rp.Project_Tasks__r[0].RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Project Task').getRecordTypeId();

        oldPt = rp.Project_Tasks__r[0];
        ptcMap.put(rp.Project_Tasks__r[0].Id, oldPt);

        rp.Project_Tasks__r[1].Assigned_To__c = u2.Id;
        System.runAs(u){
            update rp.Project_Tasks__r[0];
            update rp.Project_Tasks__r[1];
        }

        rp.Project_Tasks__r[0].Start_DateTime__c = datetime.now();
        rp.Project_Tasks__r[0].Status__c = 'In Progress';
        rp.Project_Tasks__r[0].Assigned_To__c = u2.Id;

        // Set record type of next tast to sub task
        rp.Project_Tasks__r[1].RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Sub Task').getRecordTypeId();
        rp.Project_Tasks__r[1].Parent_Task__c = rp.Project_Tasks__r[0].Id;
        rp.Project_Tasks__r[1].Assigned_To__c = u.Id;
        update rp.Project_Tasks__r[1];

        newPtList.add(rp.Project_Tasks__r[0]);
        ProjectTaskUtility.checkForNotifications(newPtList, ptcMap);

        update rp.Project_Tasks__r[0];

        rp = [SELECT Id, (SELECT Id, Order__c, Status__c FROM Project_Tasks__r ORDER BY Order__c ASC) FROM Residential_Project__c WHERE Name = 'Test Residential Project'];
        system.assertEquals(rp.Project_Tasks__r[0].Status__c , 'In Progress');
        Test.stopTest();
    }


    @isTest
    static void testSuccessorTask() {
        Test.StartTest();
        Residential_Project__c rp = [SELECT Id, (SELECT Id, Order__c, Status__c FROM Project_Tasks__r ORDER BY Order__c ASC) FROM Residential_Project__c WHERE Name = 'Test Residential Project'];
        rp.Project_Tasks__r[0].Status__c = 'Completed';
        update rp.Project_Tasks__r[0];
        
        rp = [SELECT Id, (SELECT Id, Order__c, Status__c FROM Project_Tasks__r ORDER BY Order__c ASC) FROM Residential_Project__c WHERE Name = 'Test Residential Project'];
        system.assertEquals(rp.Project_Tasks__r[1].Status__c , 'In Progress');
        Test.stopTest();
    }

    @isTest
    static void testDeleteTemplateTask() {
        Test.StartTest();
        Residential_Project__c rp = [SELECT Id, (SELECT Id, Order__c FROM Project_Tasks__r ORDER BY Order__c ASC) FROM Residential_Project__c WHERE Name = 'SPD Template'];
        delete rp.Project_Tasks__r[1];
        Test.stopTest();
    }

    @isTest
    static void testNewTemplatePTM() {
        Test.StartTest();
        TestFactory_ResidentialProjMgmt.getTeamMember([SELECT Id FROM Residential_Project__c WHERE Name = 'SPD Template' LIMIT 1].Id, 'Design Engineer');

        Residential_Project__c arp = [SELECT Id, (SELECT Role__c FROM Project_Team_Members__r ORDER BY CreatedDate DESC) FROM Residential_Project__c WHERE Name = 'Test Residential Project' LIMIT 1];
        system.AssertEquals(arp.Project_Team_Members__r.size(), 3);
        system.AssertEquals(arp.Project_Team_Members__r[0].Role__c, 'Design Engineer');
        Test.stopTest();
    }

    @isTest
    static void testNewProjectPTM() {
        Test.StartTest();
        TestFactory_ResidentialProjMgmt.getTeamMember([SELECT Id FROM Residential_Project__c WHERE Name = 'Test Residential Project' LIMIT 1].Id, 'Project Manager');
        Test.stopTest();
    }

    @isTest
    static void testMultipleDocsWithNoAttachment() {
        Test.StartTest();
        Boolean expectedExceptionThrown = false;
        Project_Task__c ptc = [select Id, Name, Status__c from Project_Task__c where Name = 'TestProjectTask0' LIMIT 1];

        // Create the documents related to project task
        Document__c doc = new Document__c();
        doc.Name = 'Document 1';
        doc.Project_Task__c = ptc.Id;
        insert doc;

        Document__c doc2 = new Document__c();
        doc2.Name = 'Document 2';
        doc2.Project_Task__c = ptc.Id;
        insert doc2;

        try {
            // Change status to 'Completed' to fire trigger
            ptc.Status__c = 'Completed';
            update ptc;
        } catch (Exception ex) {
            // We could look for 'Document 1' or 'Document 2' here
            expectedExceptionThrown =  ex.getMessage().contains('Document 2') ? true : false;
        }
        // Should be true since all documents don't have attachments and error was thrown
        System.AssertEquals(expectedExceptionThrown, true);
        Test.stopTest();
    }

    @isTest
    static void testIgnoreNotRequiredDocument() {
        Test.StartTest();
        Boolean expectedExceptionThrown = false;
        Project_Task__c ptc = [select Id, Name, Status__c, Status_Type__c from Project_Task__c where Name = 'TestProjectTask0' LIMIT 1];
        ptc.Document_Required__c = false;
        update ptc;

        // Create the documents related to project task
        Document__c doc = new Document__c();
        doc.Name = 'Document 1';
        doc.Project_Task__c = ptc.Id;
        insert doc;

        Document__c doc2 = new Document__c();
        doc2.Name = 'Document 2';
        doc2.Project_Task__c = ptc.Id;
        insert doc2;

        try {
            // Change status to 'Completed' to fire trigger
            ptc.Status__c = 'Completed';
            update ptc;
        } catch (Exception ex) {
            // We could look for 'Document 1' or 'Document 2' here
            expectedExceptionThrown =  ex.getMessage().contains('Document 2') ? true : false;
        }
        // Should be false since no documents are required on this project task
        System.AssertEquals(expectedExceptionThrown, false);
        Test.stopTest();
    }

    @isTest
    static void testDocWithNoAttachment() {
        Test.StartTest();
        Boolean expectedExceptionThrown = false;
        Project_Task__c ptc = [select Id, Name, Status__c from Project_Task__c where Name = 'TestProjectTask0' LIMIT 1];

        // Create the document related to project task
        Document__c doc = new Document__c();
        doc.Name = 'Document 1';
        doc.Project_Task__c = ptc.Id;
        insert doc;

        try {
            // Change status to 'Completed' to fire trigger
            ptc.Status__c = 'Completed';
            update ptc;
        } catch (Exception ex) {
            expectedExceptionThrown =  ex.getMessage().contains('Document 1') ? true : false;
        }
        // Should be true since document 1 doesn't have an attachment and error was thrown
        System.AssertEquals(expectedExceptionThrown, true);
        Test.stopTest();
    }

    @isTest
    static void testDocWithAttachment() {
        Test.StartTest();
        Boolean expectedExceptionThrown = false;
        Project_Task__c ptc = [select Id, Name, Status__c from Project_Task__c where Name = 'TestProjectTask0' LIMIT 1];

        // Create the document related to project task
        Document__c doc = new Document__c();
        doc.Name = 'Document 1';
        doc.Project_Task__c = ptc.Id;
        insert doc;

        // Create attachment related to document created above
        Attachment attachment = new Attachment();
        Blob attachmentBlob = Blob.valueOf('This is a sample attachment');
        attachment.Body = attachmentBlob;
        attachment.Name = 'TestFileAttachment';
        attachment.ParentId = [SELECT Id FROM Document__c WHERE Project_Task__c = : ptc.Id].Id;
        insert attachment;

        try {
            // Change status to 'Completed' to fire trigger
            ptc.Status__c = 'Completed';
            update ptc;
        } catch (Exception ex) {
            expectedExceptionThrown =  ex.getMessage().contains('Missing attachment for document') ? true : false;
        }
        // Should be false since document has attachment and no error thrown
        System.AssertEquals(expectedExceptionThrown, false);
        Test.stopTest();
    }

    @isTest
    static void testMultipleDocsWithAttachment() {
        Test.StartTest();
        Boolean expectedExceptionThrown = false;
        Project_Task__c ptc = [select Id, Name, Status__c from Project_Task__c where Name = 'TestProjectTask0' LIMIT 1];

        // Create the document related to project task
        Document__c doc = new Document__c();
        doc.Name = 'Document 1';
        doc.Project_Task__c = ptc.Id;
        insert doc;

        Document__c doc2 = new Document__c();
        doc2.Name = 'Document 2';
        doc2.Project_Task__c = ptc.Id;
        insert doc2;

        // Create attachment related to document created above
        Attachment attachment = new Attachment();
        Blob attachmentBlob = Blob.valueOf('This is a sample attachment');
        attachment.Body = attachmentBlob;
        attachment.Name = 'TestFileAttachment';
        attachment.ParentId = [SELECT Id FROM Document__c WHERE Name = 'Document 1' AND  Project_Task__c = : ptc.Id].Id;
        insert attachment;

        Attachment attachment2 = new Attachment();
        Blob attachmentBlob2 = Blob.valueOf('This is a sample attachment');
        attachment2.Body = attachmentBlob2;
        attachment2.Name = 'TestFileAttachment2';
        attachment2.ParentId = [SELECT Id FROM Document__c WHERE Name = 'Document 2' AND  Project_Task__c = : ptc.Id].Id;
        insert attachment2;

        try {
            // Change status to 'Completed' to fire trigger
            ptc.Status__c = 'Completed';
            update ptc;
        } catch (Exception ex) {
            expectedExceptionThrown =  ex.getMessage().contains('Missing attachment for document') ? true : false;
        }
        // Should be false since all docs have attachments and no error was thrown
        System.AssertEquals(expectedExceptionThrown, false);
        Test.stopTest();
    }

    @isTest
    static void testMultipleDocsWithAndWithOutAttachment() {
        Test.StartTest();
        Boolean expectedExceptionThrown = false;
        Project_Task__c ptc = [select Id, Name, Status__c from Project_Task__c where Name = 'TestProjectTask0' LIMIT 1];

        // Create the document related to project task
        Document__c doc = new Document__c();
        doc.Name = 'Document 1';
        doc.Project_Task__c = ptc.Id;
        insert doc;

        Document__c doc2 = new Document__c();
        doc2.Name = 'Document 2';
        doc2.Project_Task__c = ptc.Id;
        insert doc2;

        Document__c doc3 = new Document__c();
        doc3.Name = 'Document 3';
        doc3.Project_Task__c = ptc.Id;
        insert doc3;

        // Create attachment related to document created above
        Attachment attachment = new Attachment();
        Blob attachmentBlob = Blob.valueOf('This is a sample attachment');
        attachment.Body = attachmentBlob;
        attachment.Name = 'TestFileAttachment';
        attachment.ParentId = [SELECT Id FROM Document__c WHERE Name = 'Document 1' AND Project_Task__c = : ptc.Id].Id;
        insert attachment;

        Attachment attachment2 = new Attachment();
        Blob attachmentBlob2 = Blob.valueOf('This is a sample attachment');
        attachment2.Body = attachmentBlob2;
        attachment2.Name = 'TestFileAttachment2';
        attachment2.ParentId = [SELECT Id FROM Document__c WHERE Name = 'Document 2' AND Project_Task__c = : ptc.Id].Id;
        insert attachment2;

        try {
            // Change status to 'Completed' to fire trigger
            ptc.Status__c = 'Completed';
            update ptc;
        } catch (Exception ex) {
            // Looking for error message that contains 'Document 3' since
            expectedExceptionThrown =  ex.getMessage().contains('Document 3') ? true : false;
        }
        // Should be true since 'Document 3' does not have an attachment and error should be thrown
        System.AssertEquals(expectedExceptionThrown, true);
        Test.stopTest();
    }

    @isTest
    static void testTaskNameChange() {
        Test.StartTest();

        // Create a Standard User
        Profile p3 = [SELECT Id, Name FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'tpu3', Email = 'testprojectemail3@sunpower.com',
                          Emailencodingkey = 'UTF-8', Languagelocalekey = 'en_US', Localesidkey = 'en_US',
                          Timezonesidkey = 'America/Los_Angeles', Division = 'New', Country = 'US', LastName = 'Testing3', ProfileId = p3.Id,
                          UserName = 'testprojectuser3@sunpower.com', ByPassValidation__c = TRUE, SOX_Profile_was_approval_received__c = TRUE);
        insert u;

        // Add User to the Residential Project
        List<Project_Team_Member__c> ptm = TestFactory_ResidentialProjMgmt.createTemplateTeamMembers([SELECT Id FROM Residential_Project__c WHERE Name = 'Test Residential Project' LIMIT 1].Id, 1);
        ptm[0].User__c = u.Id;
        insert ptm;

        Boolean expectedExceptionThrown = false;

        System.runAs(u) {

            Project_Task__c pt = [SELECT Id, Name FROM Project_Task__c WHERE Name = 'TestProjectTask0' LIMIT 1];

            try {
                // Change Task Name to fire trigger
                pt.Name = 'NameChanged';
                update pt;
            } catch (Exception ex) {
                // Looking for error message that contains 'Project Task Name cannot be updated'
                expectedExceptionThrown =  ex.getMessage().contains('Project Task Name cannot be updated') ? true : false;
            }
            // Should be true since Project Task Name cannot be changed

            System.AssertEquals(expectedExceptionThrown, true);
        }

        Test.stopTest();

    }        
}