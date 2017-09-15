@isTest
public class ResidentialProjectTPSUtility_Test {
	
	// When Installation Model is assigned, make sure Alliance Partners are created for all Roles of IM
	static testMethod void testCreateAlliancePartnersCreate() {
		Installation_Model__c iModel = TestFactory_ResidentialProjMgmt.getInstallationModelIPDRIP();
		
		Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProject(NULL, NULL, NULL);
		project.Installation_Model__c = iModel.Id;
		insert project;

		List<Alliance_Partner__c> partners = [SELECT Id, Role__c, RecordType.Name FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id AND ROLE__C != 'TPS' ORDER BY Role__c];
		system.assertEquals(partners.size(), 2);
		system.assertEquals(partners[0].Role__c, 'DRIP');
		system.assertEquals(partners[1].Role__c, 'IP');
		system.assertEquals(partners[0].RecordType.Name, 'Project Alliance Partner');

	}

	// When Installation Model is assigned, make sure Alliance Partners are created for all Roles of IM
	static testMethod void testCreateAlliancePartnersUpdate() {
		Installation_Model__c iModel = TestFactory_ResidentialProjMgmt.getInstallationModelIPDRIP();
		
		Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProject(NULL, NULL, NULL);
		insert project;

		project.Installation_Model__c = iModel.Id;
		update project;

		List<Alliance_Partner__c> partners = [SELECT Id, Role__c, RecordType.Name FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id AND ROLE__C != 'TPS' ORDER BY Role__c];
		system.assertEquals(partners.size(), 2);
		system.assertEquals(partners[0].Role__c, 'DRIP');
		system.assertEquals(partners[1].Role__c, 'IP');
		system.assertEquals(partners[0].RecordType.Name, 'Project Alliance Partner');

	}

	// If Installation Model is changed, make sure Alliance Partners correctly reflect the Roles on the current Installation Model
	static testMethod void testChangeAlliancePartnersAdd() {
		List<Installation_Model__c> iModelInsert = new List<Installation_Model__c>();
		
		Installation_Model__c iModel = TestFactory_ResidentialProjMgmt.createInstallationModelIPDRIP();
		iModelInsert.add(iModel);
		Installation_Model__c iModel2 = TestFactory_ResidentialProjMgmt.createInstallationModelIP();
		iModelInsert.add(iModel2);

		insert iModelInsert;
		
		Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProject(NULL, NULL, NULL);
		project.Installation_Model__c = iModel2.Id;
		insert project;

		// Only Project Managers can update the Installation Model
		Project_Team_Member__c ptm = new Project_Team_Member__c();
		ptm.Role__c = 'Project Manager';
		ptm.User__c = UserInfo.getUserId();
		ptm.Residential_Project__c = project.Id;
		insert ptm;

		List<Alliance_Partner__c> partners = [SELECT Id, Role__c, RecordType.Name FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id AND ROLE__C != 'TPS' ORDER BY Role__c];
		system.assertEquals(partners.size(), 1);
		system.assertEquals(partners[0].Role__c, 'IP');

		project.Installation_Model__c = iModel.Id;
		update project;

		partners = [SELECT Id, Role__c, RecordType.Name FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id AND ROLE__C != 'TPS' ORDER BY Role__c];
		system.assertEquals(partners.size(), 2);
		system.assertEquals(partners[0].Role__c, 'DRIP');
		system.assertEquals(partners[1].Role__c, 'IP');
		system.assertEquals(partners[0].RecordType.Name, 'Project Alliance Partner');
		

	}

	// If Installation Model is changed, make sure Alliance Partners correctly reflect the Roles on the current Installation Model
	static testMethod void testChangeAlliancePartnersDelete() {
		List<Installation_Model__c> iModelInsert = new List<Installation_Model__c>();
		
		Installation_Model__c iModel = TestFactory_ResidentialProjMgmt.createInstallationModelIPDRIP();
		iModelInsert.add(iModel);
		Installation_Model__c iModel2 = TestFactory_ResidentialProjMgmt.createInstallationModelIP();
		iModelInsert.add(iModel2);

		insert iModelInsert;
		
		Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProject(NULL, NULL, NULL);
		project.Installation_Model__c = iModel.Id;
		insert project;

		// Only Project Managers can update the Installation Model
		Project_Team_Member__c ptm = new Project_Team_Member__c();
		ptm.Role__c = 'Project Manager';
		ptm.User__c = UserInfo.getUserId();
		ptm.Residential_Project__c = project.Id;
		insert ptm;

		List<Alliance_Partner__c> partners = [SELECT Id, Role__c, RecordType.Name FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id AND ROLE__C != 'TPS' ORDER BY Role__c];
		system.assertEquals(partners.size(), 2);
		system.assertEquals(partners[0].Role__c, 'DRIP');
		system.assertEquals(partners[1].Role__c, 'IP');
		system.assertEquals(partners[0].RecordType.Name, 'Project Alliance Partner');

		project.Installation_Model__c = iModel2.Id;
		update project;

		partners = [SELECT Id, Role__c, RecordType.Name FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id AND ROLE__C != 'TPS' ORDER BY Role__c];
		system.assertEquals(partners.size(), 1);
		system.assertEquals(partners[0].Role__c, 'IP');

	}


	// On Project Creation, a TPS Alliance Partner should be created for the Partner Account on the associated Opportunity
	static testMethod void testTPSAlliancePartnerCreation(){
		
		Account partner = TestFactory_StandardObjects.createPartnerAccount();
		partner.Name = 'TPS Partner Test';
		insert partner;
		
		Opportunity opp = TestFactory_StandardObjects.createHomeOwnerOpportunity(NULL, partner.Id);
		insert opp;

		Quote q = TestFactory_StandardObjects.createProposalQuote(opp.Id);
		insert q;
		
		Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProject(NULL, opp.Id, q.Id);
		insert project;

		List<Alliance_Partner__c> aPartners = [SELECT Id, Role__c, RecordType.Name, Partner_Account__c FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id];
		system.assertEquals(aPartners.size(), 1);
		system.assertEquals(aPartners[0].Role__c, 'TPS');
		system.assertEquals(aPartners[0].Partner_Account__c, partner.Id);
		system.assertEquals(aPartners[0].RecordType.Name, 'Project Alliance Partner');

	}

	// TPS Templates are assigned by state unless zip code falls in a SPRI region
	static testMethod void testFindTPSTemplate(){

		Residential_Project__c template = TestFactory_ResidentialProjMgmt.createProjectTemplate();
		template.Name = 'TPS CA Template';
		insert template;

		Account customer = TestFactory_StandardObjects.createResidentialCustomerAccount();
		customer.BillingState = 'CA';
		insert customer;
		
		Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProject(customer.Id, NULL, NULL);
		insert project;

		Residential_Project__c p = [SELECT Id, Project_Template__c FROM Residential_Project__c WHERE Id =: project.Id];
		system.assertEquals(p.Project_Template__c, template.Id);
		system.assert(p.Project_Template__c != NULL);
	}

	// Team Members are assigned based on the Project Installation Settings that match IM, Partner Account, State and Role
	static testMethod void testIMUserAssignment(){
		User u = [SELECT Id FROM User WHERE contactId = NULL AND isActive = TRUE LIMIT 1];

		Installation_Model__c iModel = TestFactory_ResidentialProjMgmt.createInstallationModelIP();
		insert iModel;

		/* Create Accounts */
		List<Account> accs = new List<Account>();
		Account partner = TestFactory_StandardObjects.createPartnerAccount();
		partner.Name = 'TPS Partner Test';
		accs.add(partner);

		Account customer = TestFactory_StandardObjects.createResidentialCustomerAccount();
		customer.BillingState = 'CA';
		accs.add(customer);
		insert accs;

		Test.startTest();

		/* Create PIS */
		List<Project_Installation_Setting__c> pisToInsert = new List<Project_Installation_Setting__c>();
		Project_Installation_Setting__c pis = TestFactory_ResidentialProjMgmt.createPISettingIMUserAssignment(partner.Id, UserInfo.getUserId(), iModel.Id);
		pis.User__c = u.Id;
		pis.Role__c = 'Project Manager';
		pis.Partner_Role__c = 'IP';
		pis.State__c = 'CA';
		pisToInsert.add(pis);

		Project_Installation_Setting__c pis2 = TestFactory_ResidentialProjMgmt.createPISettingIMUserAssignment(partner.Id, UserInfo.getUserId(), iModel.Id);
		pis2.User__c = UserInfo.getUserId();
		pis2.Role__c = 'Project Coordinator';
		pis2.Partner_Role__c = 'IP';
		pis2.State__c = 'MA';
		pisToInsert.add(pis2);

		Project_Installation_Setting__c pis3 = TestFactory_ResidentialProjMgmt.createPISettingIMUserAssignment(partner.Id, UserInfo.getUserId(), iModel.Id);
		pis3.User__c = UserInfo.getUserId();
		pis3.Role__c = 'Regional Operations Manager';
		pis3.Partner_Role__c = 'IP';
		pis3.State__c = 'CA';
		pisToInsert.add(pis3);

		insert pisToInsert;
		
		Residential_Project__c project = TestFactory_ResidentialProjMgmt.createTPSProjectWithTemplate(customer.Id, NULL, NULL, NULL);
		project.Installation_Model__c = iModel.Id;
		insert project;

		Test.stopTest();

		// Turn off this method 
		AlliancePartnerUtility.runFindOppTeamMember = FALSE;

		Alliance_Partner__c ap = [SELECT Id, Partner_Account__c FROM Alliance_Partner__c WHERE Residential_Project__c =: project.Id LIMIT 1];
		ap.Partner_Account__c = partner.Id;
		update ap;

		List<Project_Team_Member__c> members = [SELECT Id, Role__c, User__c FROM Project_Team_Member__c WHERE Residential_Project__c =: project.Id];
		Boolean pmCheck = FALSE;
		Boolean pcCheck = FALSE;
		Boolean romCheck = FALSE;
		for(Project_Team_Member__c ptm : members){
			if(ptm.Role__c == 'Project Manager'){
				pmCheck = TRUE;
				system.assertEquals(ptm.User__c, u.Id);
			}
			if(ptm.Role__c == 'Project Coordinator'){
				pcCheck = TRUE;
				system.assertEquals(ptm.User__c, NULL);
			}
			if(ptm.Role__c == 'Regional Operations Manager'){
				romCheck = TRUE;
				system.assertEquals(ptm.User__c, UserInfo.getUserId());
			}
		}
		system.assertEquals(pmCheck, TRUE);
		system.assertEquals(pcCheck, TRUE);
		system.assertEquals(romCheck, TRUE);
	}
}