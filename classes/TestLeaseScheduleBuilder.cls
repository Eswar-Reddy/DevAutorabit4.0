@isTest
public class TestLeaseScheduleBuilder
{
	private static List<TG_XmlNode> allNodes;
	private static TG_XmlNode root; 
	private static String SCENARIO_XML;
	private static List<CPRFieldMapping__c> allCustomSettings;
	public static void setupData()
	{
		
		SCENARIO_XML = '<Scenario ScenarioNumber=\"1\">'+
						'<NameValuePair Name=\"System Production: Row0: Annual Production\" Value=\"263\"/>'+
						'<NameValuePair Name=\"System Production: Row0: PeGu Estimate\" Value=\"250-276\"/>'+
						'<NameValuePair Name=\"System Production: Row0: Approximate Price per kWh\" Value=\"10.01\"/>'+
						'<NameValuePair Name=\"System Production: Row1: Annual Production\" Value=\"262\"/>'+
						'<NameValuePair Name=\"System Production: Row1: PeGu Estimate\" Value=\"249-275\"/>'+
						'<NameValuePair Name=\"System Production: Row1: Approximate Price per kWh\" Value=\"10.51\"/></Scenario>';
						
		TG_XmlDom dom = new TG_XmlDom( SCENARIO_XML );
		root = dom.root;
		
		
		CPRFieldMapping__c firstMapping = new CPRFieldMapping__c();
		firstMapping.CPR_FieldName__c = 'System Production-PeGu Estimate';
		firstMapping.sObjectField__c = 'PeGu_Estimate__c';
		firstMapping.sObjectName__c = 'Lease_Schedule__c';
		firstMapping.Type__c = 'String';
		
		
		CPRFieldMapping__c secondMapping = new CPRFieldMapping__c();
		secondMapping.CPR_FieldName__c = 'System Production-Annual Production';
		secondMapping.sObjectField__c = 'Guaranteed_Range_of_Annual_Production__c';
		secondMapping.sObjectName__c = 'Lease_Schedule__c';
		secondMapping.Type__c = 'String';
		
		CPRFieldMapping__c thirdMapping = new CPRFieldMapping__c();
		thirdMapping.CPR_FieldName__c = 'System Production-Approximate Price per kWh';
		thirdMapping.sObjectField__c = 'Approximate_Price_per_kWh__c';
		thirdMapping.sObjectName__c = 'Lease_Schedule__c';
		thirdMapping.Type__c = 'Decimal';
		
		allCustomSettings = new List<CPRFieldMapping__c>{firstMapping , secondMapping , thirdMapping};
	 }
	
	static testMethod void testPopulateRowMap()
	{
		setupData();
		
		LeaseScheduleBuilder leaseBuilder = new LeaseScheduleBuilder(allCustomSettings);
		NodeConsumer cons = leaseBuilder;
		Test.startTest();
			for(TG_XmlNode theNode : root.childNodes)
			{
				cons.consumeNode(theNode);
			}
		Test.stopTest();
		System.assertEquals( 2 , leaseBuilder.rowNameToAllRows.size() , 'Two rows shoulod be returned');
		Set<String> expectedField = new Set<String>{'System Production-PeGu Estimate' , 'System Production-Annual Production' , 'System Production-Approximate Price per kWh' };
		
		for(String rowNum : leaseBuilder.rowNameToAllRows.keySet())
		{
			for(TG_XmlNode theNode : leaseBuilder.rowNameToAllRows.get(rowNum))
			{
				String uniqueName = LeaseScheduleBuilder.getUniqueName(theNode.getAttribute('Name'));
				System.assert(expectedField.contains(uniqueName));
			}
		}
		
	} 
	
	static testMethod void testConstructLeaseSchedules()
	{
		setupData();
		
		
		LeaseScheduleBuilder leaseBuilder = new LeaseScheduleBuilder(allCustomSettings);
		for(TG_XmlNode theNode : root.childNodes)
		{
			leaseBuilder.consumeNode(theNode);
		}
		
		
		Test.startTest();
			Map<String, Lease_Schedule__c> leaseSchedulesToCreate = leaseBuilder.constructLeaseSchedules();
		Test.stopTest();
		
		
		System.assertEquals(2 , leaseSchedulesToCreate.size() , '2 schedules to be created');
		Lease_Schedule__c firstLeaseSchedule = leaseSchedulesToCreate.get('Row0');
		Lease_Schedule__c secondLeaseSchedule = leaseSchedulesToCreate.get('Row1');
		
		System.assertEquals( 10.01 , firstLeaseSchedule.Approximate_Price_per_kWh__c);
		System.assertEquals( '263' , firstLeaseSchedule.Guaranteed_Range_of_Annual_Production__c);
		System.assertEquals( '250-276' , firstLeaseSchedule.PeGu_Estimate__c);
		
		System.assertEquals( 10.51 , secondLeaseSchedule.Approximate_Price_per_kWh__c);
		System.assertEquals( '262' , secondLeaseSchedule.Guaranteed_Range_of_Annual_Production__c);
		System.assertEquals( '249-275' , secondLeaseSchedule.PeGu_Estimate__c);
			
	}
	
}