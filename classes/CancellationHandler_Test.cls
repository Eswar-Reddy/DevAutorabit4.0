@isTest
public class CancellationHandler_Test {

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

	static testMethod void testCancellationControllerCancel() {

		User u = [SELECT Id FROM User WHERE Username = 'sunpowerorginalusernameaslongasitneedstobe@company.com'];

		AgreementApexSharing__c objAgreementShare = new AgreementApexSharing__c();
        objAgreementShare.RoleName__c = 'Partner Executive';
        objAgreementShare.name = 'AgreementApexSharing';
        insert objAgreementShare;

        TestClassFactory.createAndInsertLeaseAgreementSettings();


		Account a = new Account(Name = 'TestAcct' , OwnerId = u.Id, BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
    	insert a;
    	Opportunity o = new Opportunity(Name = 'TestOppt', AccountId = a.Id, CloseDate = system.today(), StageName = 'Contract Signed');
    	insert o;

    	Quote q = new Quote(Name ='Test Quote', OpportunityId = o.Id);
    	insert q;

    	echosign_dev1__SIGN_Agreement__c aggc = new echosign_dev1__SIGN_Agreement__c();
    	aggc.Name='Test Agg';
    	aggc.Account__c = a.Id;
    	aggc.Opportunity__c = o.Id;
    	aggc.Quote__c = q.Id;
    	aggc.echosign_dev1__Status__c='Waiting for Counter-Signature';
    	aggc.RecordTypeId = AgreementUtility.cancelledRecTypeId;
    	aggc.Change_Order_Type__c = 'Cancellation';
    	insert aggc;

    	echosign_dev1__SIGN_Agreement__c agg = new echosign_dev1__SIGN_Agreement__c();
    	agg.Name='Test Agg';
    	agg.Account__c = a.Id;
    	agg.Opportunity__c = o.Id;
    	agg.Quote__c = q.Id;
    	agg.echosign_dev1__Status__c='Waiting for Counter-Signature';
    	agg.RecordTypeId = AgreementUtility.leaseRecTypeId;
    	insert agg;



		PageReference pageRef = Page.Cancellation;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', agg.Id);

		CancellationHandler cont = new CancellationHandler();
		cont.cancel();
	}

	static testMethod void testCancellationControllerApply() {

		User u = [SELECT Id FROM User WHERE Username = 'sunpowerorginalusernameaslongasitneedstobe@company.com'];

		AgreementApexSharing__c objAgreementShare = new AgreementApexSharing__c();
        objAgreementShare.RoleName__c = 'Partner Executive';
        objAgreementShare.name = 'AgreementApexSharing';
        insert objAgreementShare;

        TestClassFactory.createAndInsertLeaseAgreementSettings();


		Account a = new Account(Name = 'TestAcct' , OwnerId = u.Id, BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
    	insert a;
    	Opportunity o = new Opportunity(Name = 'TestOppt', AccountId = a.Id, CloseDate = system.today(), StageName = 'Contract Signed');
    	insert o;

    	Quote q = new Quote(Name ='Test Quote', OpportunityId = o.Id);
    	insert q;

    	echosign_dev1__SIGN_Agreement__c agg = new echosign_dev1__SIGN_Agreement__c();
    	agg.Name='Test Agg';
    	agg.Account__c = a.Id;
    	agg.Opportunity__c = o.Id;
    	agg.Quote__c = q.Id;
    	agg.echosign_dev1__Status__c='Waiting for Counter-Signature';
    	agg.RecordTypeId = AgreementUtility.leaseRecTypeId;
    	insert agg;


		PageReference pageRef = Page.Cancellation;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', agg.Id);

		CancellationHandler cont = new CancellationHandler();
		cont.applyCancellation();
	}

	static testMethod void testCancellationControllerApplyNOC() {

		User u = [SELECT Id FROM User WHERE Username = 'sunpowerorginalusernameaslongasitneedstobe@company.com'];

		AgreementApexSharing__c objAgreementShare = new AgreementApexSharing__c();
        objAgreementShare.RoleName__c = 'Partner Executive';
        objAgreementShare.name = 'AgreementApexSharing';
        insert objAgreementShare;

        TestClassFactory.createAndInsertLeaseAgreementSettings();


		Account a = new Account(Name = 'TestAcct' , OwnerId = u.Id, BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
    	insert a;
    	Opportunity o = new Opportunity(Name = 'TestOppt', AccountId = a.Id, CloseDate = system.today(), StageName = 'Contract Signed');
    	insert o;

    	Quote q = new Quote(Name ='Test Quote', OpportunityId = o.Id);
    	insert q;

    	echosign_dev1__SIGN_Agreement__c agg = new echosign_dev1__SIGN_Agreement__c();
    	agg.Name='Test Agg';
    	agg.Account__c = a.Id;
    	agg.Opportunity__c = o.Id;
    	agg.Quote__c = q.Id;
    	agg.echosign_dev1__Status__c='Waiting for Counter-Signature';
    	agg.RecordTypeId = AgreementUtility.leaseRecTypeId;
    	insert agg;


		PageReference pageRef = Page.Cancellation;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', agg.Id);

		CancellationHandler cont = new CancellationHandler();
		cont.newAgg.Change_Order_Type__c = 'Notice of Cancellation';
		cont.applyCancellation();
	}
}