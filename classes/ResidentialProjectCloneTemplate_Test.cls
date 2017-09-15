@isTest
public with sharing class ResidentialProjectCloneTemplate_Test {
	static testMethod void testCloneTemplate(){
        Residential_Project__c template = TestFactory_ResidentialProjMgmt.createProjectTemplate();
        template.Name = 'Test Template';
        insert template;

        List<Project_Task__c> tasks = TestFactory_ResidentialProjMgmt.createTemplateTasks(template.Id, 4);
        tasks[0].Name = 'Project Task with Document';
        insert tasks;

        List<Document__c> docs = TestFactory_ResidentialProjMgmt.createProjectDocuments(template.Id, 4);
        docs[0].Name = 'Project Task Document';
        docs[0].Project_Task__c = tasks[0].Id;
        insert docs;

        List<Project_Team_Member__c> members = TestFactory_ResidentialProjMgmt.createTemplateTeamMembers(template.Id, 4);
        insert members;

        Test.startTest();
        Id cloneId = ResidentialProjectCloneTemplate.cloneTemplate(template.Id, template.Name);

        Residential_Project__c clone = [SELECT Id, Name, (SELECT Id FROM Project_Team_Members__r),(SELECT Id FROM Project_Tasks__r), (SELECT Id, Project_Task__r.Name , Name FROM Documents__r ORDER BY Project_Task__c) FROM Residential_Project__c WHERE Id =: cloneId];
        system.assertEquals(clone.Name, 'Test Template Clone');
        system.assertEquals(clone.Project_Team_Members__r.size(), 4);
        system.assertEquals(clone.Project_Tasks__r.size(), 4);
        system.assertEquals(clone.Documents__r.size(), 4);
        Boolean foundDocTask = FALSE;
        for(Document__c d : clone.Documents__r){
            if(d.Name == 'Project Task Document') {
                system.assertEquals(d.Project_Task__r.Name, 'Project Task with Document');
                foundDocTask = TRUE;
            }
        }
        system.assertEquals(foundDocTask, TRUE);
        Test.stopTest();
    }
}