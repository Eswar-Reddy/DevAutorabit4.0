@isTest
private with sharing class TestInvoiceDocumentRedirectController {

	static User partnerUser;
	static User internalUser;
	static LeasePayment__c leasePayment;
	static Invoice_Documents__c invoiceDoc;
	static final String STATE = 'CA';
	static final String INVOICE_TYPE = 'Install';
	static InvoiceDocumentRedirectController redirectController;

	static void setupUsers()
	{
		partnerUser = TestUtils.createLeasePartnerInfo();
		internalUser = TestUtils.createUser(TestUtils.TEST_INTERNAL_PROFILE, false);
	}

	private static void setup()
	{
		System.runAs(partnerUser)
		{
			Account partnerAccount = TestUtils.createAccount('Test Partner account', TestUtils.getPartnerRecordTypeId(), true);
			leasePayment = TestUtils.createLeasePayment('TestLeasePayment', partnerAccount.Id, false);
			leasePayment.Site_State_Prov_old__c = STATE;
			insert leasePayment;
			List<Invoice_Documents__c> invoiceDocuments = TestUtils.createInvoiceDocuments(1, leasePayment.Id, INVOICE_TYPE, true);
			invoiceDoc = invoiceDocuments[0];
		}

	}

	private static void setupCustomSettings()
	{
		RedirectProfiles__c newSetting = new RedirectProfiles__c();
		newSetting.SetupOwnerId = partnerUser.ProfileId;
		System.runAs( TestUtils.ADMIN_USER )
		{
			insert newSetting;
		}
	}

	private static void instantiateController()
	{
		Test.setCurrentPageReference(Page.InvoiceDocumentRedirect);
		ApexPages.StandardController stc = new ApexPages.StandardController(invoiceDoc);
		redirectController = new InvoiceDocumentRedirectController(stc);
	}

	private static testMethod void testRedirect_PartnerUser()
	{
		setupUsers();
		setup();
		setupCustomSettings();

		PageReference actualPageRef;

		System.runAs(partnerUser)
		{
			Test.startTest();
				instantiateController();
				actualPageRef = redirectController.redirect();
			Test.stopTest();
		}

		PageReference expectedPageRef = Page.InvoiceDocumentUpload;
		expectedPageRef.getParameters().put('id', leasePayment.Id);
		expectedPageRef.getParameters().put('type', INVOICE_TYPE);

		System.assertEquals(expectedPageRef.getUrl(), actualPageRef.getUrl(), 'The partner user should be redirected to the document upload page');
	}

	private static testMethod void testRedirect_InternalUser()
	{
		setupUsers();
		setup();
		setupCustomSettings();

		PageReference actualPageRef;

		System.runAs(internalUser)
		{
			Test.startTest();
				instantiateController();
				actualPageRef = redirectController.redirect();
			Test.stopTest();
		}

		PageReference expectedPageRef = new PageReference('/'+invoiceDoc.Id);
		expectedPageRef.getParameters().put('nooverride', '1');

		System.assertEquals(expectedPageRef.getUrl(), actualPageRef.getUrl(), 'The partner user should be redirected to the document upload page');
	}
}