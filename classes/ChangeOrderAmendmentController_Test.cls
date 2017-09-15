@isTest
public class ChangeOrderAmendmentController_Test {
	@testSetup
	static void setup() {
			User mike = new User();
		mike.Username= 'sunpowerorginalusernameaslongasitneedstobe@company.com';
		mike.Email = 'mike.white@company.com';
		mike.Lastname = 'mike';
		mike.Firstname = 'white';
		mike.Alias = 'mwhite';
		mike.UserRoleId = [ select id from userrole where developername = 'CTI' limit 1].Id;
		mike.ProfileId = [ select id from profile where name = 'Standard User' limit 1].Id;
		mike.Division = 'IT';
		mike.Country = 'USA';

		mike.CurrencyIsoCode = 'USD';
		mike.TimeZoneSidKey = 'GMT';
		mike.LocaleSidKey = 'en_US';
		mike.EmailEncodingKey = 'ISO-8859-1';
		mike.LanguageLocaleKey = 'en_US';
		mike.UserPermissionsMobileUser = false;
		insert mike;
		
	}

	static testMethod void testChangeAuditApplication() {

		User u = [SELECT Id FROM User WHERE Username = 'sunpowerorginalusernameaslongasitneedstobe@company.com'];

		AgreementApexSharing__c objAgreementShare = new AgreementApexSharing__c();
        objAgreementShare.RoleName__c = 'Partner Executive';
        objAgreementShare.name = 'AgreementApexSharing';
        insert objAgreementShare;

        TestClassFactory.createAndInsertLeaseAgreementSettings();

		Account a = new Account(Name = 'TestAcct' , OwnerId = u.Id, BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
    	insert a;

    	Contact c = new Contact(FirstName = 'Nik', LastName = 'Testla', Email='nik@testla.com', Primary__c = TRUE, Include_in_lease_doc__c = TRUE);
    	insert c;

    	Test.startTest();
    	echosign_dev1__SIGN_Agreement__c agg = new echosign_dev1__SIGN_Agreement__c();
    	agg.Name='Test Agg';
    	agg.Account__c = a.Id;
    	agg.echosign_dev1__Status__c='Waiting for Counter-Signature';
    	agg.RecordTypeId = AgreementUtility.amendmentRecTypeId;
    	insert agg;

    	List<Change_Audit__c> audits = new List<Change_Audit__c>();
    	Change_Audit__c ca = new Change_Audit__c();
    	ca.Agreement__c = agg.Id;
    	ca.Account__c = a.Id;
    	ca.Object_Type__c = 'Account';
    	ca.Object_Id__c = a.Id;
    	ca.Old_Value__c = 'San Jose';
    	ca.Field_API_Name__c = 'BillingCity';
    	ca.New_Value__c = 'San Francisco';
    	audits.add(ca);

    	Change_Audit__c ca2 = new Change_Audit__c();
    	ca2.Agreement__c = agg.Id;
    	ca2.Account__c = a.Id;
    	ca2.Object_Type__c = 'Contact';
    	ca2.Object_Id__c = c.Id;
    	ca2.Old_Value__c = 'Nik';
    	ca2.Field_API_Name__c = 'FirstName';
    	ca2.New_Value__c = 'Nikola';
    	audits.add(ca2);

    	Change_Audit__c ca3 = new Change_Audit__c();
    	ca3.Agreement__c = agg.Id;
    	ca3.Account__c = a.Id;
    	ca3.Object_Type__c = 'Contact';
    	ca3.Object_Id__c = c.Id;
    	ca3.Old_Value__c = 'TRUE';
    	ca3.Field_API_Name__c = 'Primary__c';
    	ca3.New_Value__c = 'FALSE';
    	audits.add(ca3);

    	Change_Audit__c ca4 = new Change_Audit__c();
    	ca4.Agreement__c = agg.Id;
    	ca4.Account__c = a.Id;
    	ca4.Object_Type__c = 'Contact';
    	ca4.Object_Id__c = c.Id;
    	ca4.Old_Value__c = 'nik@testla.com';
    	ca4.Field_API_Name__c = 'Email';
    	ca4.New_Value__c = 'nikola@testla.com';
    	audits.add(ca4);

    	insert audits;

    	Test.stopTest();

    	agg.echosign_dev1__Status__c = 'Signed';
    	update agg;

    	Account aa = [SELECT BillingCity, Name, BillingState FROM Account WHERE Id =: a.Id];
    	system.assertEquals(aa.BillingCity, 'San Francisco');
    	system.assertEquals(aa.Name, 'TestAcct');
    	system.assertEquals(aa.BillingState, 'CA');

    	Contact cc = [SELECT FirstName, Email, Primary__c FROM Contact WHERE Id =: c.Id];
    	system.assertEquals(cc.FirstName, 'Nikola');
    	system.assertEquals(cc.Email, 'nikola@testla.com');
    	system.assertEquals(cc.Primary__c, FALSE);

    	Change_Audit__c aaudit = [SELECT Id, Date_of_Change__c FROM Change_Audit__c LIMIT 1];
    	system.assertEquals(aaudit.Date_of_Change__c, system.today());

	}

	static testMethod void testError(){
		PageReference pageRef = Page.ChangeOrderAmendment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('aid', 'xxx1234');
		ChangeOrderAmendmentController cont = new ChangeOrderAmendmentController();
		
	}

	static testMethod void testCosignees() {

		User u = [SELECT Id FROM User WHERE Username = 'sunpowerorginalusernameaslongasitneedstobe@company.com'];

		AgreementApexSharing__c objAgreementShare = new AgreementApexSharing__c();
        objAgreementShare.RoleName__c = 'Partner Executive';
        objAgreementShare.name = 'AgreementApexSharing';
        insert objAgreementShare;

        TestClassFactory.createAndInsertLeaseAgreementSettings();


		Account a = new Account(Name = 'TestAcct' , OwnerId = u.Id, BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
    	insert a;

    	Contact c = new Contact(FirstName = 'Nik', AccountId = a.Id, LastName = 'Testla', Email='nik@testla.com', Primary__c = TRUE, Include_in_lease_doc__c = TRUE);
    	insert c;

    	Test.startTest();
    	echosign_dev1__SIGN_Agreement__c agg = new echosign_dev1__SIGN_Agreement__c();
    	agg.Name='Test Agg';
    	agg.Account__c = a.Id;
    	agg.echosign_dev1__Status__c='Waiting for Counter-Signature';
    	agg.RecordTypeId = AgreementUtility.amendmentRecTypeId;
    	insert agg;


    	Test.stopTest();


    	PageReference pageRef = Page.ChangeOrderAmendment;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('aid', agg.Id);

		ChangeOrderAmendmentController cont = new ChangeOrderAmendmentController();
		cont.addCosignee();
		cont.cIdentifier = 0;
		cont.removeCosignee();
		cont.proceed();
		cont.back();
		cont.ownerBack();
		cont.ownershipChange();
		cont.saveOwnerChange();
		cont.cancel();
	}

	static testMethod void testACChanges() {

		User u = [SELECT Id FROM User WHERE Username = 'sunpowerorginalusernameaslongasitneedstobe@company.com'];

		AgreementApexSharing__c objAgreementShare = new AgreementApexSharing__c();
        objAgreementShare.RoleName__c = 'Partner Executive';
        objAgreementShare.name = 'AgreementApexSharing';
        insert objAgreementShare;

        TestClassFactory.createAndInsertLeaseAgreementSettings();


		Account a = new Account(Name = 'TestAcct' , OwnerId = u.Id, BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
    	insert a;

    	Contact c = new Contact(FirstName = 'Nik', LastName = 'Testla', AccountId = a.Id, Email='nik@testla.com', Primary__c = TRUE, Include_in_lease_doc__c = TRUE);
    	insert c;

    	Test.startTest();
    	echosign_dev1__SIGN_Agreement__c agg = new echosign_dev1__SIGN_Agreement__c();
    	agg.Name='Test Agg';
    	agg.Account__c = a.Id;
    	agg.echosign_dev1__Status__c='Waiting for Counter-Signature';
    	agg.RecordTypeId = AgreementUtility.amendmentRecTypeId;
    	insert agg;


    	Test.stopTest();


    	PageReference pageRef = Page.ChangeOrderAmendment;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('aid', agg.Id);

		ChangeOrderAmendmentController cont = new ChangeOrderAmendmentController();
		system.debug('what is the error? '+cont.miscErrorMsg);
		Account afa = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,(SELECT FirstName, LastName FROM Contacts WHERE Primary__c = TRUE) FROM Account WHERE Id =: a.Id];
		cont.acc.aStreet = 'New Street';
		cont.acc.aCity = 'Olympia';
		cont.acc.aZip = '98989';
		cont.cos[0].coFirstName = 'Jim';
		cont.cos[0].coLastName = 'Bob';
		cont.cos[0].coEmail = 'jim.bob@test.com';
		cont.cos[0].coPhone = '5051234567';
		cont.cos[0].isPrimary = FALSE;
		cont.cos[0].onContract = FALSE;
		cont.submit();
	}
}