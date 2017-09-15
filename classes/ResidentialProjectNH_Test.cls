@isTest
public class ResidentialProjectNH_Test {
    
    static testMethod void communityAlliance() {

        Account installationPartner = TestFactory_StandardObjects.createPartnerAccount();
        insert installationPartner;
        
        NH_Community__c nhCommunity = TestFactory_ResidentialProjMgmt.createNHCommunity(NULL, NULL);
        insert nhCommunity;

        Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createCommunityAlliancePartner(nhCommunity.Id, installationPartner.Id);
        ap.Role__c = 'IP';
        insert ap;

        Test.startTest();

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProjectWithTemplateTaskOnly(NULL, NULL, NULL, nhCommunity.Id, NULL);
        insert project; 

               

        List<Alliance_Partner__c> aps = [SELECT Role__c, Partner_Account__c FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id];
        system.assertEquals(aps.size(), 1);
        system.assertEquals(aps[0].Role__c, 'IP');
        system.assertEquals(aps[0].Partner_Account__c, installationPartner.Id);

        Account a = TestFactory_StandardObjects.getPartnerAccount();

        Alliance_Partner__c ap2 = TestFactory_ResidentialProjMgmt.createCommunityAlliancePartner(nhCommunity.Id, a.Id);
        ap2.Role__c = 'Inspection Partner';
        insert ap2;

        List<Alliance_Partner__c> aps2 = [SELECT Role__c, Partner_Account__c FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id];
        system.assertEquals(aps2.size(), 2);
        
        ap.Role__c = 'Design';
        update ap;

        List<Alliance_Partner__c> aps4 = [SELECT Role__c, Partner_Account__c FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id AND Partner_Account__c =: installationPartner.Id];
        system.assertEquals(aps4[0].Role__c, 'Design');

        Test.stopTest();

    }

    static testMethod void communityAllianceDelete(){
        Account installationPartner = TestFactory_StandardObjects.createPartnerAccount();
        insert installationPartner;
        
        NH_Community__c nhCommunity = TestFactory_ResidentialProjMgmt.createNHCommunity(NULL, NULL);
        insert nhCommunity;

        Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createCommunityAlliancePartner(nhCommunity.Id, installationPartner.Id);
        ap.Role__c = 'IP';
        insert ap;

        Test.startTest();

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProjectWithTemplateTaskOnly(NULL, NULL, NULL, nhCommunity.Id, NULL);
        insert project; 

        delete ap;

        List<Alliance_Partner__c> aps = [SELECT Role__c, Partner_Account__c FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id];
        system.assertEquals(aps.size(), 0);
        Test.stopTest();

    }

    static testMethod void taskValidation() {

        Residential_Project__c template = TestFactory_ResidentialProjMgmt.createProjectTemplate();
        insert template;

        List<Project_Task__c> templateTasks = TestFactory_ResidentialProjMgmt.createTemplateTasks(template.Id, 5);

        templateTasks[0].Required_Project_Fields__c = 'Battery Storage;Smart Thermostat';
        insert templateTasks;

        
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProjectWithTemplate(NULL, NULL, NULL, NULL, template.Id);
        insert project;

        Test.startTest();

        Project_Task__c t = [SELECT Id, Status__c FROM Project_Task__c WHERE Template_Task__c =: templateTasks[0].Id LIMIT 1] ;
        t.Status__c = 'Completed';
        Boolean isError = FALSE;

        try{
            update t;
        }catch(Exception e){
            isError = TRUE;
        }
        
        system.assertEquals(isError, TRUE);

        project.Battery_Storage__c = 'No';
        project.Smart_Thermostat__c = 'No';
        update project;

        update t;

        Test.stopTest();
    }

}