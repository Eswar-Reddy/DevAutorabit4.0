@isTest
public class TestQuoteBuilder
{
	private static List<TG_XmlNode> allNodes;
	private static TG_XmlNode root; 
	private static String SCENARIO_XML;
	private static String ITEM_ID_FAKE = '1234123123123x';
	public static List<CPRFieldMapping__c> theSettings;
	
	public static void setupData()
	{
		
		SCENARIO_XML = '<Scenario ScenarioNumber=\"1\">'+
						'<NameValuePair Name=\"Additional Equipment\" Value=\"\"/>'+
						'<NameValuePair Name=\"Full Prepayment of Lease Amount\" Value=\"\"/>'+
						'<NameValuePair Name=\"Description1\" Value=\"Peak Shaver\"/>'+
						'<NameValuePair Name=\"Other Charges: Row0: Name\" Value=\"AdditionalServices1\"/>'+
						'<NameValuePair Name=\"Item Number\" Value=\"' + ITEM_ID_FAKE + '\"/>'+
						'</Scenario>';
						
		TG_XmlDom dom = new TG_XmlDom( SCENARIO_XML );
		root = dom.root;
		
		CPRFieldMapping__c firstMapping = new CPRFieldMapping__c();
		firstMapping.CPR_FieldName__c = 'Full Prepayment of Lease Amount';
		firstMapping.sObjectField__c = 'Full_Prepayment_of_Lease_Amount__c';
		firstMapping.sObjectName__c = 'Quote';
		firstMapping.Type__c = 'Decimal';
		
		
		CPRFieldMapping__c secondMapping = new CPRFieldMapping__c();
		secondMapping.CPR_FieldName__c = 'Additional Equipment';
		secondMapping.sObjectField__c = 'Additional_Equipment__c';
		secondMapping.sObjectName__c = 'Quote';
		secondMapping.Type__c = 'String';
		
		CPRFieldMapping__c thirdMapping = new CPRFieldMapping__c();
		thirdMapping.CPR_FieldName__c = 'Other Charges: Row0: Name';
		thirdMapping.sObjectField__c = 'Other_Charges_Row0_Name__c';
		thirdMapping.sObjectName__c = 'Quote';
		thirdMapping.Type__c = 'String';
		
		theSettings = new  List<CPRFieldMapping__c>{firstMapping , secondMapping , thirdMapping};
		
	 }
	
	static testMethod void testConsumeNodes()
	{
		setupData();
		
		quoteBuilder qb = new quoteBuilder(theSettings);
		NodeConsumer cons = qb;
		
		Test.StartTest();
		for(TG_XmlNode theNode : root.childNodes)
		{
			cons.consumeNode(theNode);
		}
		Test.StopTest();
		
		System.assertEquals('AdditionalServices1' , qb.quoteToBuild.Other_Charges_Row0_Name__c);
		System.assertEquals('' , qb.quoteToBuild.Additional_Equipment__c);
		System.assertEquals(null, qb.quoteToBuild.Full_Prepayment_of_Lease_Amount__c);
			
	}
	
	static testMethod void testDuplicateCprFieldMappings() 
	{
		setupData();
		CPRFieldMapping__c fourthdMapping = new CPRFieldMapping__c();
		fourthdMapping.CPR_FieldName__c = 'Description1';
		fourthdMapping.sObjectField__c = 'Description__c';
		fourthdMapping.sObjectName__c = 'Quote';
		fourthdMapping.Type__c = 'String';

		CPRFieldMapping__c fifthMapping = new CPRFieldMapping__c();
		fifthMapping.CPR_FieldName__c = 'Description1';
		fifthMapping.sObjectField__c = 'Name';
		fifthMapping.sObjectName__c = 'Quote';
		fifthMapping.Type__c = 'String';
		
		theSettings.addAll( new List<CPRFieldMapping__c> { fourthdMapping, fifthMapping } );
		
		quoteBuilder qb = new quoteBuilder(theSettings);
		NodeConsumer cons = qb;
		
		Test.StartTest();
		for(TG_XmlNode theNode : root.childNodes)
		{
			cons.consumeNode(theNode);
		}
		Test.StopTest();
		
		System.assertEquals('Peak Shaver' , qb.quoteToBuild.Name);
	}
	
	static testMethod void testExternalIdCprFieldMappings() 
	{
		setupData();
		
		Item__c moduleItem = new Item__c();
	 	moduleItem.Item_ID__c = ITEM_ID_FAKE;
		
		CPRFieldMapping__c fourthdMapping = new CPRFieldMapping__c();
		fourthdMapping.CPR_FieldName__c = 'Item Number';
		fourthdMapping.sObjectField__c = 'Module_Oracle_Item_Number__r';
		fourthdMapping.sObjectName__c = 'Quote';
		fourthdMapping.Type__c = 'ExternalId';
		
		
		theSettings.addAll( new List<CPRFieldMapping__c> { fourthdMapping } );
		
		quoteBuilder qb = new quoteBuilder(theSettings);
		NodeConsumer cons = qb;
		
		Test.StartTest();
		for(TG_XmlNode theNode : root.childNodes)
		{
			cons.consumeNode(theNode);
		}
		Test.StopTest();
		
		String itemId = ((Item__c)qb.quoteToBuild.getSObject( fourthdMapping.sObjectField__c )).Item_ID__c; 
		
		System.assertNotEquals( null , itemId );
	}
	
}