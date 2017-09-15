@isTest
public class testOpportunityBuilder 
{
	private static List<TG_XmlNode> allNodes;
	private static TG_XmlNode root; 
	private static String SCENARIO_XML;
	
	private static User testUser;
	private static Contact testContact;
	private static list<CPRFieldMapping__c> allMappings;
	private static opportunityBuilder testBuilder;
	
	private static Account testAcc;
	private static Opportunity testOpp;
	
	
	public static void setupData()
	{
		testUser = testUtils.createUser('Standard User', false);
		testUser.FirstName = 'testUser';
		testUser.LastName = 'testUser';
		testUser.CPR_Salesperson_ID__c = 'testUser testUser';
		
		system.runAs(testUtils.ADMIN_USER)
		{
			insert testUser;
		}
		
		testContact = testUtils.createContact('', null, false);
		testContact.FirstName = 'testContact';
		testContact.LastName = 'testContact';
		testContact.CPR_ID__c = '00998989898';
		
		insert testContact;
		
		CPRFieldMapping__c firstMapping = new CPRFieldMapping__c();
		firstMapping.CPR_FieldName__c = 'Lessee';
		firstMapping.sObjectField__c = 'Contact';
		firstMapping.sObjectName__c = 'Opportunity';
		firstMapping.Type__c = 'String';
		
		
		CPRFieldMapping__c secondMapping = new CPRFieldMapping__c();
		secondMapping.CPR_FieldName__c = 'SalespersonId';
		secondMapping.sObjectField__c = 'Owner';
		secondMapping.sObjectName__c = 'Opportunity';
		secondMapping.Type__c = 'String';

		CPRFieldMapping__c thirdMapping = new CPRFieldMapping__c();
		thirdMapping.CPR_FieldName__c = 'CustomerID';
		thirdMapping.sObjectField__c = 'CPR_ID__c';
		thirdMapping.sObjectName__c = 'Opportunity';
		thirdMapping.Type__c = 'String';
		
		CPRFieldMapping__c fourthMapping = new CPRFieldMapping__c();
		fourthMapping.CPR_FieldName__c = 'OpportunityID';
		fourthMapping.sObjectField__c = 'id';
		fourthMapping.sObjectName__c = 'Opportunity';
		fourthMapping.Type__c = 'String';
		
		//RecordType StandardAccType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Standard' LIMIT 1];
		//testAcc = testutils.createAccount('testAccount', StandardAccType.id, true);
		
		testOpp = new Opportunity();
		//testOpp.AccountId = testAcc.Id;
		testOpp.CloseDate =  Date.today();
		testOpp.Name = 'testOpp';
		testOpp.StageName = 'New';
		insert testOpp;
		
		
		allMappings = new List<CPRFieldMapping__c>{thirdMapping,secondMapping,firstMapping, fourthMapping};
		testBuilder = new opportunityBuilder(allMappings);
		
		SCENARIO_XML = '<Scenario ScenarioNumber=\"1\">'+
						'<NameValuePair Name=\"Lessee\" Value=\"testContact testContact\"/>'+
						'<NameValuePair Name=\"CustomerID\" Value=\"00998989898\"/>'+
						'<NameValuePair Name=\"OpportunityID\" Value=\"'+ testOpp.id +'"/>'+
						'<NameValuePair Name=\"SalespersonId\" Value=\"testUser testUser\"/>'+
						'<NameValuePair Name=\"not here\" Value=\"who cares\"/></Scenario>';
						
		TG_XmlDom dom = new TG_XmlDom( SCENARIO_XML );
		root = dom.root;
	 }
	 
	private static testMethod void testConsumeNode()
	{
		setupData();
		
		NodeConsumer cons = testBuilder;
		
	 	Test.startTest();
		 	for(TG_XmlNode theNode : root.childNodes)
			{
				cons.consumeNode(theNode);
			}
	 	Test.stopTest();
	 	
	 	System.debug( testBuilder.nodesToStore );
	 	
	 	system.assertEquals( testOpp.id, testBuilder.nodesToStore.get('OpportunityID'), 'the nodes should all be stored');
	 	system.assertEquals('testContact testContact',testBuilder.nodesToStore.get('Lessee'),'the nodes should all be stored');
	 	system.assertEquals('testUser testUser',testBuilder.nodesToStore.get('SalespersonId'),'the nodes should all be stored');
	 	//should exists because there is no mapping for this field
	 	system.assertEquals(null,testBuilder.nodesToStore.get('not here'),'the nodes should all be stored');
			
	}
	
	private static testMethod void testConstructOpportunity()
	{
		setupData();
		
		for(TG_XmlNode theNode : root.childNodes)
		{
			testBuilder.consumeNode(theNode);
		}
		
		Test.startTest();
			Opportunity opptoupdate = testBuilder.constructOpportunity();
	 	Test.stopTest();
	 	
	 	system.assertEquals(testContact.CPR_ID__c,opptoupdate.Primary_Contact__r.CPR_ID__c,'the contact should have been retrieved ');
	 	system.assertEquals(testUser.CPR_Salesperson_ID__c,opptoupdate.Owner.CPR_Salesperson_ID__c,'the owner should have been retrieved');
	 	system.assertEquals(testOpp.id,opptoupdate.Id,'the nodes should all be stored');
	}
}