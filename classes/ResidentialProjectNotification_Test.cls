@isTest
public class ResidentialProjectNotification_Test {
	
    static testMethod void testCancelChatterNotification(){

        Account partner = TestFactory_StandardObjects.createPartnerAccount();
        insert partner;

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProject(NULL,NULL,NULL);
        project.Installation_Partner__c = partner.Id;
        insert project; 

        Project_Team_Member__c ptm = TestFactory_ResidentialProjMgmt.getTeamMember(project.Id, 'Project Manager');

        Test.startTest();
        project.Status__c = 'Cancelled';
        project.Cancellation_Justification__c = 'Change of Dealer';
        update project;

        Test.stopTest();
    }
    
}