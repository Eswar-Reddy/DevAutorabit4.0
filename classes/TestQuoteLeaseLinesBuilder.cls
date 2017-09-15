@isTest(SeeAllData=true)
public class TestQuoteLeaseLinesBuilder
{
	private static List<TG_XmlNode> allNodes;
	private static TG_XmlNode root; 
	private static String SCENARIO_XML;
	private static String ITEM_ID1 = '111178xxasdfasdf';
	private static String ITEM_ID2 = '1108asdf12305';
	static QuoteLeaseLinesBuilder qllBuilder;
	
	
	public static void setupData()
	{
		
		SCENARIO_XML = '<Scenario ScenarioNumber=\"1\">'+
						'<NameValuePair Name=\"Module\" Value=\"SPR-230E-WHT-D\"/>'+
						'<NameValuePair Name=\"Module Quantity\" Value=\"1\"/>'+
						'<NameValuePair Name=\"Module Oracle Item Number\" Value=\"' + ITEM_ID1 + '\"/>'+
						'<NameValuePair Name=\"Inverter Model Roof 1\" Value=\"SPR-3300f-240\"/>'+
						'<NameValuePair Name=\"Inverter Quantity Roof 1\" Value=\"5\"/>'+
						'<NameValuePair Name=\"Inverter Oracle Item Number Roof 1\" Value=\"' + ITEM_ID2 + '\"/>'+
						'<NameValuePair Name=\"Racking Kit Model Numbers\" Value=\"MON SP-ACC-STD Kit\"/>'+
    					'<NameValuePair Name=\"Racking Quantity\" Value=\"6\"/>'+
    					'<NameValuePair Name=\"Racking Kit Oracle Item Numbers\" Value=\"135780\"/>'+
					    '<NameValuePair Name=\"Monitoring System Model\" Value=\"MON SP-ACC-STD Kit,MON SP-ACC-SPRf\"/>'+
					    '<NameValuePair Name=\"Monitoring System Quantity\" Value=\"1;1\"/>'+
					    '<NameValuePair Name=\"Monitoring System Oracle Item Numbers\" Value=\"126548;126443\"/>'+
						'</Scenario>';
						
		TG_XmlDom dom = new TG_XmlDom( SCENARIO_XML );
		root = dom.root;
		
		CPRFieldMapping__c moduleMapping1 = new CPRFieldMapping__c();
		moduleMapping1.CPR_FieldName__c = 'Module Oracle Item Number';
		moduleMapping1.sObjectField__c = 'Item__c';
		moduleMapping1.sObjectName__c = 'Quote_Line__c';
		moduleMapping1.Type__c = 'ExternalId';
		CPRFieldMapping__c moduleMapping2 = new CPRFieldMapping__c();
		moduleMapping2.CPR_FieldName__c = 'Module Quantity';
		moduleMapping2.sObjectField__c = 'Quantity__c';
		moduleMapping2.sObjectName__c = 'Quote_Line__c';
		moduleMapping2.Type__c = 'Number';
		
		CPRFieldMapping__c invMapping1 = new CPRFieldMapping__c();
		invMapping1.CPR_FieldName__c = 'Inverter Oracle Item Number Roof 1';
		invMapping1.sObjectField__c = 'Item__c';
		invMapping1.sObjectName__c = 'Quote_Line__c';
		invMapping1.Type__c = 'ExternalId';
		CPRFieldMapping__c invMapping2 = new CPRFieldMapping__c();
		invMapping2.CPR_FieldName__c = 'Inverter Quantity Roof 1';
		invMapping2.sObjectField__c = 'Quantity__c';
		invMapping2.sObjectName__c = 'Quote_Line__c';
		invMapping2.Type__c = 'Number';
		
		CPRFieldMapping__c rackMapping1 = new CPRFieldMapping__c();
		rackMapping1.CPR_FieldName__c = 'Racking Kit Oracle Item Numbers';
		rackMapping1.sObjectField__c = 'Item__c';
		rackMapping1.sObjectName__c = 'Quote_Line__c';
		rackMapping1.Type__c = 'ExternalId';
		CPRFieldMapping__c rackMapping2 = new CPRFieldMapping__c();
		rackMapping2.CPR_FieldName__c = 'Racking Quantity';
		rackMapping2.sObjectField__c = 'Quantity__c';
		rackMapping2.sObjectName__c = 'Quote_Line__c';
		rackMapping2.Type__c = 'Number';
		
		CPRFieldMapping__c monMapping1 = new CPRFieldMapping__c();
		monMapping1.CPR_FieldName__c = 'Monitoring System Oracle Item Numbers';
		monMapping1.sObjectField__c = 'Item__c';
		monMapping1.sObjectName__c = 'Quote_Line__c';
		monMapping1.Type__c = 'ExternalId';
		CPRFieldMapping__c monMapping2 = new CPRFieldMapping__c();
		monMapping2.CPR_FieldName__c = 'Monitoring System Quantity';
		monMapping2.sObjectField__c = 'Quantity__c';
		monMapping2.sObjectName__c = 'Quote_Line__c';
		monMapping2.Type__c = 'Number';
		
		
		
		qllBuilder = new QuoteLeaseLinesBuilder(new List<CPRFieldMapping__c>{moduleMapping1 , moduleMapping2 , invMapping1 , invMapping2, rackMapping1, rackMapping2, monMapping1, monMapping2 });
	 }
	 
	 
	 static testMethod void testConsumeNode()
	 {
	 	setupData();
	 	Item__c moduleItem = new Item__c();
	 	moduleItem.Item_ID__c = ITEM_ID1;
	 	
	 	Item__c inverterItem = new Item__c();
	 	inverterItem.Item_ID__c = ITEM_ID2;
	 	
	 	insert new List<Item__c>{moduleItem , inverterItem};
	 	
	 	NodeConsumer cons = qllBuilder;
	 	
	 	Test.startTest();
		 	for(TG_XmlNode theNode : root.childNodes)
			{
				cons.consumeNode(theNode);
			}
			
	 	Test.stopTest();
	 	
	 	Quote_Line__c moduleLineItem = qllBuilder.theLeaseLines.get('Module');
	 	Quote_Line__c inverterLineItem = qllBuilder.theLeaseLines.get('Inverter');
	 	
	 	
	 	System.assertEquals(moduleItem.Item_ID__c , moduleLineItem.Item__r.Item_ID__c);
	 	System.assertEquals(1 , moduleLineItem.Quantity__c);
	 	
	 	System.assertEquals(inverterItem.Item_ID__c , inverterLineItem.Item__r.Item_ID__c);
	 	System.assertEquals(5 , inverterLineItem.Quantity__c);
	 	
	 }
	 static testMethod void testConsumeNodeRacking()
	 {
	 	setupData();
	 	Item__c moduleItem = new Item__c();
	 	moduleItem.Item_ID__c = ITEM_ID1;
	 	
	 	Item__c inverterItem = new Item__c();
	 	inverterItem.Item_ID__c = ITEM_ID2;
	 	
	 	insert new List<Item__c>{moduleItem , inverterItem};
	 	
	 	NodeConsumer cons = qllBuilder;
	 	
	 	Test.startTest();
		 	for(TG_XmlNode theNode : root.childNodes)
			{
				cons.consumeNode(theNode);
			}
			
	 	Test.stopTest();
	 	
	 	Quote_Line__c moduleLineItem = qllBuilder.theLeaseLines.get('Module');
	 	Quote_Line__c inverterLineItem = qllBuilder.theLeaseLines.get('Inverter');
	 	
	 	System.assertEquals(8 , qllBuilder.theLeaseLines.size() );
	 	
	 	
	 	System.assertEquals(moduleItem.Item_ID__c , moduleLineItem.Item__r.Item_ID__c);
	 	System.assertEquals(1 , moduleLineItem.Quantity__c);
	 	
	 	System.assertEquals(inverterItem.Item_ID__c , inverterLineItem.Item__r.Item_ID__c);
	 	System.assertEquals(5 , inverterLineItem.Quantity__c);
	 	
	 }
	 
	 
	 static testMethod void testExternalId()
	 {
	 	
	 	Quote testQuote = new Quote();
	 	Opportunity testOpp = new Opportunity();
		//testOpp.AccountId = testAcc.Id;
		testOpp.CloseDate =  Date.today();
		testOpp.Name = 'testOpp';
		testOpp.StageName = 'New';
		insert testOpp;
	 	
	 	testQuote.OpportunityId = testOpp.Id;
	 	testQuote.Name = 'testQuote';
	 	insert testQuote;
	 	
	 	Item__c moduleItem = new Item__c();
	 	moduleItem.Item_ID__c = ITEM_ID1;
	 	
	 	insert new List<Item__c>{moduleItem};
	 	
	 	Test.startTest();
			Quote_Line__c qli = new Quote_Line__c();
			Item__c testItem = new Item__c(Item_ID__c = moduleItem.Item_ID__c);
			qli.Item__r = testItem;
			qli.Quote__c = testQuote.Id;
			insert qli;		
	 	Test.stopTest();

		List<Quote_Line__c> qlis = [SELECT Id, Item__c FROM Quote_Line__c WHERE Id = : qli.Id];	 	
	 	System.assertEquals(1 , qlis.size());
	 	System.assertEquals(moduleItem.Id , qlis[0].Item__c);
	 }
	 
}