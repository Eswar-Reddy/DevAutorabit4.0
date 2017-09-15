/*********************************************************

@class		ProjectDashboardControllerTest

@about		Project Dashboard Controller Test Class

@author		Gabriel Baca (Redpoint)

@created	2016-5-16

********************************************************/

@isTest
public class ProjectDashboardControllerTest {
	@testSetup
	static void setup() {
		String userEmail 				= 'testprojectemail@sunpower.com';
		String userName  				= 'testprojectuser@sunpower.com';
		Datetime todaysDateTime 		= Datetime.now();
		Date todaysDate 				= Date.today();
		Integer numOfProjectsToCreate 	= 1;
		Integer numOfTasksToCreate 		= 5;

		// Create test user for these projects/tasks
		Profile p = [SELECT Id FROM Profile WHERE Name = 'SunPower User'];
		User u = new User(Alias = 'tpu', Email = userEmail,
		                  Emailencodingkey = 'UTF-8', Languagelocalekey = 'en_US', Localesidkey = 'en_US',
		                  Timezonesidkey = 'America/Los_Angeles', Division = 'New', Country = 'US', FirstName = 'Tester', LastName = 'Testing', ProfileId = p.Id,
		                  UserName = userName);
		insert u;
		System.debug('This is the current Test User >>>> ' + u.Id);

		// Create test accounts
		List<Account> testAccts = new List<Account>();
		for (Integer h = 0; h < numOfProjectsToCreate; h++) {
			testAccts.add(new Account(Name = 'TestAcct' + h, OwnerId = u.Id, BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345'));
		}
		insert testAccts;

		// Create opportunity
		List<Opportunity> testOpportunity = new List<Opportunity>();
		for (Integer x = 0; x < 2; x++){
			testOpportunity.add(new Opportunity(Name = 'TestOpp' + x, Account = testAccts[0], Partner_Account_Id__c = testAccts[0].Id, CloseDate = todaysDate, StageName = '12% - Qualified Opportunity'));
		}
		insert testOpportunity;

		// Create test residential project
		List<Residential_Project__c> testResidentialProject = new List<Residential_Project__c>();
		for (Integer i = 0; i < numOfProjectsToCreate; i++) {
			Residential_Project__c tempResidentialProject = new Residential_Project__c();

			tempResidentialProject.Account__c = testAccts[i].Id;
			tempResidentialProject.Status__c = 'Active'; //Hold, Cancelled or Completed
			tempResidentialProject.Name = 'TestResidentialProject' + i;
			tempResidentialProject.CurrencyIsoCode = 'USD';
			tempResidentialProject.Opportunity__c = testOpportunity[0].Id;

			testResidentialProject.add(tempResidentialProject);
		}
		insert testResidentialProject;

		// Create test task
		List<Project_Task__c> testProjectTasks = new List<Project_Task__c>();
		for (Integer j = 0; j < numOfTasksToCreate; j++) {
			Project_Task__c tempProjectTask = new Project_Task__c();

			tempProjectTask.Status__c = (Math.mod(j, 2) == 0) ? 'Cancelled' : 'Pending Approval'; //In Progress, Pending Approval, Completed and Hold
			tempProjectTask.Task_Type_Name__c = 'TestProjectTask' + j;
			tempProjectTask.Name = 'TestProjectTask' + j;
			tempProjectTask.SLA_Days__c = 1;
			tempProjectTask.Start_DateTime__c = todaysDateTime.addDays(-4);  // Set 4 days in the past
			tempProjectTask.Role_Assignment__c = (Math.mod(j, 2) == 0) ? 'Project Manager' : 'Project Coordinator'; //Project Manager and Project Coordinator
			tempProjectTask.Residential_Project__c = testResidentialProject[0].Id;
			tempProjectTask.Project_Priority__c = (Math.mod(j, 2) == 0) ? 'Normal' : 'Fast-tracked'; //Normal or Fast-tracked
			tempProjectTask.Order__c = j + 1;
			tempProjectTask.Assigned_To__c = u.Id;
			tempProjectTask.Parent_Task__c = null;
			//tempProjectTask.Critical_Path__c = true;

			testProjectTasks.add(tempProjectTask);
		}
		insert testProjectTasks;

		// Add user to project team member
		Project_Team_Member__c ptm = new Project_Team_Member__c();
		ptm.Residential_Project__c = testResidentialProject[0].Id;
		ptm.Role__c = 'Project Manager';
		ptm.User__c = u.Id;
		ptm.Project_Dashboard_User__c = true;
		insert ptm;
	}

	@isTest
	static void testLoadingMyTasks() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			pdc.loadMyTasks('', true);
			System.Assert(pdc.myTasksList != null, 'My tasks list is not null');
		}
	}

	@isTest
	static void testLoadingMyProjects() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			pdc.loadMyProjects('');

			System.Assert(pdc.myProjectsList != null, 'My projects list is not null');
		}
	}

	@isTest
	static void testDisplayChatter() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			pdc.displayChatter();
			System.Assert(pdc.showChatter == true, 'The showChatter field should be true');
		}
	}

	@isTest
	static void testDisplayProjectFiles() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];
		Residential_Project__c rpc = [select Id from Residential_Project__c where Name = 'TestResidentialProject0'];
		Project_Task__c ptc = [select Id from Project_Task__c where Task_Type_Name__c = 'TestProjectTask0'];

		// Create the document related to residential project
		Document__c doc = new Document__c();
		doc.Residential_Project__c = rpc.Id;
		insert doc;

		// Create attachment
		Attachment attachment = new Attachment();
		Blob attachmentBlob = Blob.valueOf('This is a sample attachment');
		attachment.Body = attachmentBlob;
		attachment.Name = 'TestFileAttachment';
		attachment.ParentId = [SELECT Id FROM Document__c WHERE Residential_Project__c = : rpc.Id].Id;
		insert attachment;

		ContentVersion contentVersionTest = new ContentVersion(
		    Title = 'SolarPanels',
		    PathOnClient = 'SolarPanels.jpg',
		    VersionData = Blob.valueOf('SolarPanels Test Content'),
		    IsMajorVersion = true
		);
		insert contentVersionTest;

		ContentDocumentLink link = new ContentDocumentLink();
		link.LinkedEntityId = rpc.Id;
		link.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = : contentVersionTest.Id LIMIT 1].ContentDocumentId;
		link.ShareType = 'V';
		link.Visibility = 'AllUsers';
		insert link;

		link = new ContentDocumentLink();
		link.LinkedEntityId = ptc.Id;
		link.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = : contentVersionTest.Id LIMIT 1].ContentDocumentId;
		link.ShareType = 'V';
		link.Visibility = 'AllUsers';
		insert link;

		// Insert document with no attachment to test unsubmitted list
		Document__c docUnsubmitted = new Document__c();
		docUnsubmitted.Residential_Project__c = rpc.Id;
		insert docUnsubmitted;

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			pdc.projectId = rpc.Id;
			pdc.displayProjectFiles();
			System.debug('pdc.files >>>> ' + pdc.files);
			System.Assert(!pdc.chatterDocObject.projectFiles.isEmpty(), 'Project should have attachments');
		}
	}

	@isTest
	static void testDisplayNoProjectFiles() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];
		Residential_Project__c rpc = [select Id from Residential_Project__c where Name = 'TestResidentialProject0'];

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			pdc.projectId = rpc.Id;
			pdc.displayProjectFiles();

			System.Assert(pdc.chatterDocObject.projectFiles.isEmpty(), 'Project should not have any files');
		}
	}

	@isTest
	static void testDisplayTaskFiles() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];
		Project_Task__c ptc = [select Id from Project_Task__c where Task_Type_Name__c = 'TestProjectTask0'];

		ContentVersion contentVersionTest = new ContentVersion(
		    Title = 'SolarPanels',
		    PathOnClient = 'SolarPanels.jpg',
		    VersionData = Blob.valueOf('SolarPanels Test Content'),
		    IsMajorVersion = true
		);
		insert contentVersionTest;

		ContentDocumentLink link = new ContentDocumentLink();
		link.LinkedEntityId = ptc.Id;
		link.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = : contentVersionTest.Id LIMIT 1].ContentDocumentId;
		link.ShareType = 'V';
		link.Visibility = 'AllUsers';
		insert link;

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			pdc.taskId = ptc.Id;
			pdc.displayTaskFiles();

			System.Assert(!pdc.chatterDocObject.taskFiles.isEmpty(), 'Project Task should have files');
		}
	}

	@isTest
	static void testDisplayNoTaskFiles() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];
		Project_Task__c ptc = [select Id from Project_Task__c where Task_Type_Name__c = 'TestProjectTask0'];

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			pdc.taskId = ptc.Id;
			pdc.displayTaskFiles();

			System.Assert(pdc.chatterDocObject.taskFiles.isEmpty(), 'Project Task should not have files');
		}
	}

	@isTest
	static void testApproveTask() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];
		Project_Task__c ptc = [select Id from Project_Task__c where Task_Type_Name__c = 'TestProjectTask0'];

		//System.runAs(u) {
		ProjectDashboardController pdc = new ProjectDashboardController();
		pdc.taskId = ptc.Id;
		pdc.approveTask();
		Project_Task__c ptc_approved = [select Id, Status__c from Project_Task__c where Id = : ptc.Id];
		System.assert(ptc_approved.Status__c == 'Approved', 'Project Task status should be set to Approved');
		//}
	}

	@isTest
	static void testCreateTaskObject() {
		Project_Task__c ptcRecord = [select Id, Overdue__c, Status__c, Name, Task_Type_Name__c, Residential_Project__c, Residential_Project__r.Community__c, Residential_Project__r.Community__r.Name, Residential_Project__r.Name, Project_Priority__c, Parent_Task__c, SLA_Days__c, SLA_Days_Aging__c from Project_Task__c where Name = 'TestProjectTask0'];
		ProjectDashboardController.TaskObject to = new ProjectDashboardController.TaskObject(ptcRecord);

		System.assert(to != null, 'Task object should not be null');
		System.assert(to.taskName == 'TestProjectTask0', 'Task name should be TestProjectTask0');
	}

	@isTest
	static void testCreateProjectObject() {
		List<Residential_Project__c> rpcRecords = new List<Residential_Project__c>();
		rpcRecords = [SELECT Id, Name, Status__c, Project_Days_Aging__c, Priority__c, Project_Number__c, Installation_Partner__c, Installation_Partner__r.Name, Community__c, Community__r.Name, Customer_State__c, Customer_City__c, (SELECT Id, Status__c, Active_Critical__c, Critical_Path__c, Name, Milestone__c, Task_Type_Name__c, Start_DateTime__c, SLA_Flag__c, SLA_Days_Aging__c, SLA_Days__c, Overdue__c, Assigned_to__c, Assigned_to__r.FirstName, Assigned_to__r.LastName FROM Project_Tasks__r ORDER BY Active_Critical__c DESC, Order__c ASC ) FROM Residential_Project__c];

		for (Residential_Project__c rpc : rpcRecords) {
			ProjectDashboardController.ProjectObject po = new ProjectDashboardController.ProjectObject(rpc);
			System.assert(po != null, 'Project object should not be null');
			System.assert(po.rpName == rpc.Name, 'Project object name should be equal to residential project name');
		}
	}

	@isTest
	static void testCreateFile() {
		Residential_Project__c rpc = [select Id from Residential_Project__c where Name = 'TestResidentialProject0'];

		// Create the document related to residential project
		Document__c doc = new Document__c();
		doc.Residential_Project__c = rpc.Id;
		insert doc;

		// Create attachment
		Attachment attachment = new Attachment();
		Blob attachmentBlob = Blob.valueOf('This is a sample attachment');
		attachment.Body = attachmentBlob;
		attachment.Name = 'TestFileAttachment';
		attachment.ParentId = [SELECT Id FROM Document__c WHERE Residential_Project__c = : rpc.Id].Id;
		insert attachment;

		ProjectDashboardController.File file = new ProjectDashboardController.File(attachment.Name, attachment.Id);

		System.assert(file != null, 'File object should not be null');
		System.assert(file.fileName == attachment.Name, 'File Name should be TestFileAttachment');
		System.assert(file.fileId == attachment.Id, 'File Id should match attacment Id');
	}

	@isTest
	static void testSearchForUser() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];
		String uFirstName = [select Id, FirstName from User where Username = 'testprojectuser@sunpower.com'].FirstName;

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			List<User> users = new List<User>();
			users = ProjectDashboardController.searchForUser(uFirstName);
			System.Assert(pdc.myTasksList != null, 'My list of users should not be null');
			System.Assert(users.size() > 0, 'My list of users should not be empty');
			System.Assert(ProjectDashboardController.searchForUser('').size() < 1, 'My list of users should be empty');
		}
	}

	@isTest
	static void testPassingInUserIdParam() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];
		String uId = [select Id from User where Username = 'testprojectuser@sunpower.com'].Id;

		System.runAs(u) {
			System.currentPagereference().getParameters().put('userId', uId);
			ProjectDashboardController pdc = new ProjectDashboardController();
			String userIdParam = System.currentPagereference().getParameters().get('userId');
			System.Assert(userIdParam != null, 'User Id parameter should not be null');
		}
	}

	@isTest
	static void testSearchForPartnerAccount() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];
		
		String partnerAccountSearchTerm = [SELECT Name, Partner_Account_text__c FROM Opportunity WHERE Name = 'TestOpp0' LIMIT 1].Partner_Account_text__c;

		System.runAs(u) {
			ProjectDashboardController pdc = new ProjectDashboardController();
			List<Opportunity> partnerAccounts = new List<Opportunity>();
			partnerAccounts = ProjectDashboardController.searchForPartnerAccount(partnerAccountSearchTerm);
			System.Assert(pdc.myProjectsList != null, 'My list of partner accounts should not be null');
			System.Assert(partnerAccounts.size() > 0, 'My list of partner accounts should not be empty');
			System.Assert(ProjectDashboardController.searchForPartnerAccount('').size() < 1, 'My list of partner accounts should be empty');
		}
	}

	@isTest
	static void testPassingInPartnerAccountIdParam() {
		User u = [select Id from User where Username = 'testprojectuser@sunpower.com'];

		Opportunity opp = [SELECT Name, Partner_Account_text__c FROM Opportunity WHERE Name = 'TestOpp0' LIMIT 1];

		System.runAs(u) {
			System.currentPagereference().getParameters().put('partnerId', opp.Partner_Account_text__c);
			ProjectDashboardController pdc = new ProjectDashboardController();
			String userIdParam = System.currentPagereference().getParameters().get('partnerId');
			System.Assert(userIdParam != null, 'Partner Id parameter should not be null');
		}
	}

}