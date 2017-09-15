@isTest
private class InvoiceComplianceDocSharingUtility_Test {

	@testSetup static void testDataSetup(){
		// add custom setting
		TestFactory_Custom_Settings.getLoanCallOutSettings();

		List<Account> accs = new List<Account>();
		Account a = TestFactory_StandardObjects.createPartnerAccount();
		a.Name = 'Test Partner 1';
		accs.add(a);

		Account a2 = TestFactory_StandardObjects.createPartnerAccount();
		a2.Name = 'Test Partner 2';
		accs.add(a2);

		Account a3 = TestFactory_StandardObjects.createPartnerAccount();
		a3.Name = 'Test Partner 3';
		accs.add(a3);

		insert accs;

		List<Contact> cons = new List<Contact>();
		Contact c = TestFactory_StandardObjects.createPartnerContact(a.Id);
		c.LastName = 'Jones';
		cons.add(c);

		Contact c2 = TestFactory_StandardObjects.createPartnerContact(a.Id);
		c2.LastName = 'Testla';
		cons.add(c2);

		Contact c3 = TestFactory_StandardObjects.createPartnerContact(a2.Id);
		c3.LastName = 'Sanchez';
		cons.add(c3);

		Contact c4 = TestFactory_StandardObjects.createPartnerContact(a2.Id);
		c4.LastName = 'Smith';
		cons.add(c4);

		Contact c5 = TestFactory_StandardObjects.createPartnerContact(a3.Id);
		c5.LastName = 'Reeves';
		cons.add(c5);

		Contact c6 = TestFactory_StandardObjects.createPartnerContact(a3.Id);
		c6.LastName = 'Boss';
		cons.add(c6);

		Contact c7 = TestFactory_StandardObjects.createPartnerContact(a3.Id);
		c7.LastName = 'Anderson';
		cons.add(c7);

		insert cons;

		Id partnerOpId = [SELECT Id FROM Profile WHERE Name = 'Partner Operations' LIMIT 1].Id;

		List<User> users = new List<User>();
		User u = TestFactory_StandardObjects.createPartnerUser(c.Id, NULL);
		u.isActive = true;
		u.PortalRole = 'Executive';
		users.add(u);

		User u2 = TestFactory_StandardObjects.createPartnerUser(c2.Id, NULL);
		u2.isActive = true;
		users.add(u2);

		User u3 = TestFactory_StandardObjects.createPartnerUser(c3.Id, NULL);
		u3.isActive = true;
		users.add(u3);

		User u4 = TestFactory_StandardObjects.createPartnerUser(c4.Id, NULL);
		u4.isActive = true;
		u4.PortalRole = 'Executive';
		users.add(u4);

		User u5 = TestFactory_StandardObjects.createPartnerUser(c5.Id, NULL);
		u5.isActive = true;
		u5.PortalRole = 'Executive';
		users.add(u5);

		User u6 = TestFactory_StandardObjects.createPartnerUser(c6.Id, NULL);
		u6.isActive = true;
		u6.PortalRole = 'Executive';
		users.add(u6);

		User u7 = TestFactory_StandardObjects.createPartnerUser(c7.Id, partnerOpId);
		u7.isActive = true;
		users.add(u7);

		UserManagement.IS_TEST = true;
		insert users;
	}

	@isTest static void testDocumentOwnerSharing() {
		Test.startTest();
			Map<String, Id> accMap = new Map<String, Id>();

			for(Account a : [SELECT Id, Name FROM Account]){
				accMap.put(a.Name, a.Id);
			}

			Map<String, Id> userMap = new Map<String, Id>();
			for(User u : [SELECT Id, Contact.LastName FROM User]){
				userMap.put(u.Contact.LastName, u.Id);
			}

			Residential_Project__c proj = TestFactory_ResidentialProjMgmt.createSPDProject(NULL, NULL,NULL);
			insert proj;

			List<Project_Team_Member__c> ptms = new List<Project_Team_Member__c>();
			Project_Team_Member__c ptm = TestFactory_ResidentialProjMgmt.createTeamMember(proj.Id, 'Project Manager', userMap.get('Jones'));
			ptms.add(ptm);

			Project_Team_Member__c ptm2 = TestFactory_ResidentialProjMgmt.createTeamMember(proj.Id, 'Project Coordinator', userMap.get('Sanchez'));
			ptms.add(ptm2);
			insert ptms;

			List<Alliance_Partner__c> aps = new List<Alliance_Partner__c>();
			Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(proj.Id, accMap.get('Test Partner 1'));
			ap.Role__c = 'IP';
			aps.add(ap);

			Alliance_Partner__c ap2 = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(proj.Id, accMap.get('Test Partner 2'));
			ap2.Role__c = 'DRIP';
			aps.add(ap2);
			insert aps;

			Invoice_Compliance_Document__c icd = TestFactory_Invoices.createInvoiceComplianceDoc();
			icd.Residential_Project__c = proj.Id;
			icd.Document_Owner__c = 'IP';
			icd.Shared_With__c = NULL;
			icd.Responsible_Partner__c = accMap.get('Test Partner 1');
			insert icd;
		Test.stopTest();

		List<Invoice_Compliance_Document__Share> shares = [SELECT Id, UserorGroupId, RowCause, AccessLevel FROM Invoice_Compliance_Document__Share WHERE ParentId =: icd.Id AND RowCause =: Schema.Invoice_Compliance_Document__Share.RowCause.Document_Owner_Partner__c];

		system.assertEquals(1, shares.size());
		system.assertEquals(userMap.get('Jones'), shares[0].UserorGroupId);
		system.assertEquals('Edit', shares[0].AccessLevel);
	}

	@isTest static void testDocumentSharing() {
		Test.startTest();
			Map<String, Id> accMap = new Map<String, Id>();

			for(Account a : [SELECT Id, Name FROM Account]){
				accMap.put(a.Name, a.Id);
			}

			Map<String, Id> userMap = new Map<String, Id>();
			for(User u : [SELECT Id, Contact.LastName FROM User]){
				userMap.put(u.Contact.LastName, u.Id);
			}

			Residential_Project__c proj = TestFactory_ResidentialProjMgmt.createSPDProject(NULL, NULL,NULL);
			insert proj;

			List<Project_Team_Member__c> ptms = new List<Project_Team_Member__c>();
			Project_Team_Member__c ptm = TestFactory_ResidentialProjMgmt.createTeamMember(proj.Id, 'Project Manager', userMap.get('Jones'));
			ptms.add(ptm);

			Project_Team_Member__c ptm2 = TestFactory_ResidentialProjMgmt.createTeamMember(proj.Id, 'Project Coordinator', userMap.get('Sanchez'));
			ptms.add(ptm2);
			insert ptms;

			List<Alliance_Partner__c> aps = new List<Alliance_Partner__c>();
			Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(proj.Id, accMap.get('Test Partner 1'));
			ap.Role__c = 'IP';
			aps.add(ap);

			Alliance_Partner__c ap2 = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(proj.Id, accMap.get('Test Partner 2'));
			ap2.Role__c = 'DRIP';
			aps.add(ap2);
			insert aps;

			Invoice_Compliance_Document__c icd = TestFactory_Invoices.createInvoiceComplianceDoc();
			icd.Residential_Project__c = proj.Id;
			icd.Document_Owner__c = 'IP';
			icd.Shared_With__c = 'DRIP;TPS';
			icd.Responsible_Partner__c = accMap.get('Test Partner 1');
			insert icd;
		Test.stopTest();

		List<Invoice_Compliance_Document__Share> shares = [SELECT Id, UserorGroupId, RowCause, AccessLevel FROM Invoice_Compliance_Document__Share WHERE ParentId =: icd.Id AND RowCause =: Schema.Invoice_Compliance_Document__Share.RowCause.Shared_With_Partner__c];

		system.assertEquals(1, shares.size());
		system.assertEquals(userMap.get('Sanchez'), shares[0].UserorGroupId);
		system.assertEquals('Read', shares[0].AccessLevel);
	}

	@isTest static void testDocumentUpdate() {
		Test.startTest();
			Map<String, Id> accMap = new Map<String, Id>();

			for(Account a : [SELECT Id, Name FROM Account]){
				accMap.put(a.Name, a.Id);
			}

			Map<String, Id> userMap = new Map<String, Id>();
			for(User u : [SELECT Id, Contact.LastName FROM User]){
				userMap.put(u.Contact.LastName, u.Id);
			}

			Residential_Project__c proj = TestFactory_ResidentialProjMgmt.createSPDProject(NULL, NULL,NULL);
			insert proj;

			List<Project_Team_Member__c> ptms = new List<Project_Team_Member__c>();
			Project_Team_Member__c ptm = TestFactory_ResidentialProjMgmt.createTeamMember(proj.Id, 'Project Manager', userMap.get('Jones'));
			ptms.add(ptm);

			Project_Team_Member__c ptm2 = TestFactory_ResidentialProjMgmt.createTeamMember(proj.Id, 'Project Coordinator', userMap.get('Sanchez'));
			ptms.add(ptm2);
			insert ptms;

			List<Alliance_Partner__c> aps = new List<Alliance_Partner__c>();
			Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(proj.Id, accMap.get('Test Partner 1'));
			ap.Role__c = 'IP';
			aps.add(ap);

			Alliance_Partner__c ap2 = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(proj.Id, accMap.get('Test Partner 2'));
			ap2.Role__c = 'DRIP';
			aps.add(ap2);
			insert aps;

			Invoice_Compliance_Document__c icd = TestFactory_Invoices.createInvoiceComplianceDoc();
			icd.Residential_Project__c = proj.Id;
			icd.Document_Owner__c = 'IP';
			icd.Shared_With__c = 'DRIP;TPS';
			icd.Responsible_Partner__c = accMap.get('Test Partner 1');
			insert icd;

			icd.Shared_With__c = null;
			update icd;
		Test.stopTest();

		List<Invoice_Compliance_Document__Share> shares = [SELECT Id, UserorGroupId, RowCause, AccessLevel FROM Invoice_Compliance_Document__Share WHERE ParentId =: icd.Id AND RowCause =: Schema.Invoice_Compliance_Document__Share.RowCause.Shared_With_Partner__c];

		system.assertEquals(0, shares.size());
	}

	@isTest static void testExec2ExecSharing() {
		Test.startTest();
			Map<String, Id> accMap = new Map<String, Id>();

			for(Account a : [SELECT Id, Name FROM Account]){
				accMap.put(a.Name, a.Id);
			}

			Map<String, Id> userMap = new Map<String, Id>();
			for(User u : [SELECT Id, Contact.LastName FROM User]){
				userMap.put(u.Contact.LastName, u.Id);
			}

			Residential_Project__c proj = TestFactory_ResidentialProjMgmt.createSPDProject(NULL, NULL,NULL);
			insert proj;

			Project_Team_Member__c ptm = TestFactory_ResidentialProjMgmt.createTeamMember(proj.Id, 'Project Manager', userMap.get('Reeves'));
			insert ptm;

			List<Alliance_Partner__c> aps = new List<Alliance_Partner__c>();
			Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(proj.Id, accMap.get('Test Partner 3'));
			ap.Role__c = 'IP';
			aps.add(ap);
			insert aps;

			Invoice_Compliance_Document__c icd = TestFactory_Invoices.createInvoiceComplianceDoc();
			icd.Residential_Project__c = proj.Id;
			icd.Document_Owner__c = 'IP';
			icd.Shared_With__c = NULL;
			icd.Responsible_Partner__c = accMap.get('Test Partner 3');
			insert icd;
		Test.stopTest();

		List<Invoice_Compliance_Document__Share> shares = [SELECT Id, UserorGroupId, RowCause, AccessLevel FROM Invoice_Compliance_Document__Share WHERE ParentId =: icd.Id AND RowCause =: Schema.Invoice_Compliance_Document__Share.RowCause.Document_Owner_Partner__c];
		system.assertEquals(2, shares.size());
		system.assertEquals('Edit', shares[0].AccessLevel);
	}
}