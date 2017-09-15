@isTest
public class TestQuoteSummaryBuilder
{
	private static List<TG_XmlNode> allNodes;
	private static TG_XmlNode root; 
	private static String SCENARIO_XML;
	static List<CPRFieldMapping__c> theSettings;
	public static void setupData()
	{
		
		SCENARIO_XML = '<Scenario ScenarioNumber=\"1\">'+
						'<NameValuePair Name=\"Date\" Value=\"3/13/2012\"/>'+
						'<NameValuePair Name=\"DateCreated\" Value=\"3/9/2011\"/>'+
						'<NameValuePair Name=\"DateUpdated\" Value=\"3/13/2012\"/>'+
						'<NameValuePair Name=\"QuoteId\" Value=\"NK2VN3JV\"/>'+
						'<NameValuePair Name=\"SalespersonId\" Value=\"4PZ4DY5D\"/>'+
						'<NameValuePair Name=\"CompanyId\" Value=\"4XV8GZ0J\"/>'+
						'<NameValuePair Name=\"LicenseId\" Value=\"84GR1UY3\"/>'+
						'<NameValuePair Name=\"ScenarioIndex\" Value=\"1\"/>'+
						'<NameValuePair Name=\"Description\" Value=\"Awesome\"/>'+
						'<NameValuePair Name=\"IsSelectedScenario\" Value=\"FALSE\"/>'+
						'<NameValuePair Name=\"IsLocked\" Value=\"FALSE\"/>'+
						'<NameValuePair Name=\"Lessee\" Value=\"Joe Customer\"/>'+
						'<NameValuePair Name=\"Dealer/Installer\" Value=\"Ben Awesome\"/>'+
						'<NameValuePair Name=\"Install Date\" Value=\"3/9/2011\"/></Scenario>';
						
		TG_XmlDom dom = new TG_XmlDom( SCENARIO_XML );
		root = dom.root;
		
		
		CPRFieldMapping__c firstMapping = new CPRFieldMapping__c();
		firstMapping.CPR_FieldName__c = 'Description';
		firstMapping.sObjectField__c = 'Description__c';
		firstMapping.sObjectName__c = 'Quote_Summary__c';
		firstMapping.Type__c = 'String';
		
		
		CPRFieldMapping__c secondMapping = new CPRFieldMapping__c();
		secondMapping.CPR_FieldName__c = 'CompanyId';
		secondMapping.sObjectField__c = 'CPR_Company_ID__c';
		secondMapping.sObjectName__c = 'Quote_Summary__c';
		secondMapping.Type__c = 'String';
		
		CPRFieldMapping__c thirdMapping = new CPRFieldMapping__c();
		thirdMapping.CPR_FieldName__c = 'Install Date';
		thirdMapping.sObjectField__c = 'Install_Date__c';
		thirdMapping.sObjectName__c = 'Quote_Summary__c';
		thirdMapping.Type__c = 'Date';
		
		theSettings = new  List<CPRFieldMapping__c>{firstMapping , secondMapping , thirdMapping};
		
	 }
	 
	 static testMethod void testFilterQuoteSummaryNodes()
	 {
	 	setupData();
		
		QuoteSummaryBuilder summaryBuilder = new QuoteSummaryBuilder(theSettings);
		NodeConsumer cons = summaryBuilder;
		Test.startTest();
			for(TG_XmlNode theNode : root.childNodes)
			{
				cons.consumeNode(theNode);
			}	
		Test.stopTest();
		Date expectedInstallDate = Date.parse('3/9/2011');
		System.assertEquals(expectedInstallDate , summaryBuilder.quoteSummary.Install_Date__c);
		System.assertEquals('Awesome' , summaryBuilder.quoteSummary.Description__c);
		System.assertEquals('4XV8GZ0J' , summaryBuilder.quoteSummary.CPR_Company_ID__c);
		
		
		
	 }
	 
	 static /*testMethod*/ void testConstructQuoteSummary()
	 {
	 	setupData();
	 	User testUser = testUtils.createUser('Standard User', false);
		testUser.FirstName = 'testUser';
		testUser.LastName = 'testUser';
		
		system.runAs(testUtils.ADMIN_USER)
		{
			insert testUser;
		}
		
		Contact testContact = testUtils.createContact('', null, false);
		testContact.FirstName = 'testContact';
		testContact.LastName = 'testContact';
		
		insert testContact;
		
		QuoteSummaryBuilder summaryBuilder = new QuoteSummaryBuilder(theSettings);
		
		Test.startTest();
			//Quote_Summary__c quoteSummary = summaryBuilder.constructQuoteSummary(testContact.Id , testUser.Id); 
		Test.stopTest();
		
		/*System.assertEquals(testContact.Id , quoteSummary.Lessee__c);
		System.assertEquals(testUser.Id , quoteSummary.Dealer_Installer__c);*/
		
			
	 }
	 
	 
	 
	 
}