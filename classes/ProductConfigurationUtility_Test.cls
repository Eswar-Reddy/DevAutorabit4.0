@isTest
private class ProductConfigurationUtility_Test {

	@TestSetup
	public static void testDataSetup() {
		Price_List__c priceList = TestClassFactory.createPriceList();
		ProductConfigurationUtility util = new ProductConfigurationUtility();
	}
	
	static TestMethod void TestOverload1() {
		Test.startTest();
		
		Set<Id> masterIds = ProductConfigurationUtility.fetchMasterIds('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', 'Indirect', null);
		System.assertNotEquals(masterIds, null);		
		
		Test.stopTest();
	}
	
	static TestMethod void TestEquinoxOverload() {
		Test.startTest();
		
		Set<Id> masterIds = ProductConfigurationUtility.fetchEquinoxMasterIDs('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', 'Indirect', null);
		System.assertNotEquals(masterIds, null);		
		
		Test.stopTest();
	}

	static TestMethod void TestOverloadNegatives() {
		Test.startTest();
		
		Set<Id> masterIds1 = ProductConfigurationUtility.fetchMasterIds('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', null, null);
		System.assert(masterIds1.isEmpty());

		Set<Id> masterIds3 = ProductConfigurationUtility.fetchEquinoxMasterIDs('CO', 'SPNA OU', 'Cash', 'Order', null, 'Indirect', null);
		System.assert(masterIds3.isEmpty());

		Test.stopTest();		
	}

	static TestMethod void TestModuleRetrieval() {
		Test.startTest();
		
		Set<Id> masterIds = ProductConfigurationUtility.fetchMasterIds('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', 'Indirect', null);
		System.assertNotEquals(masterIds, null);

		Map<Id, Module_Configuration__c> moduleMap = ProductConfigurationUtility.fetchModules(masterIds);
		System.assertNotEquals(moduleMap, null);
		
		Test.stopTest();
	}

	static TestMethod void TestModuleNegative() {
		Test.startTest();
		
		Map<Id, Module_Configuration__c> moduleMap = ProductConfigurationUtility.fetchModules(null);
		System.assert(moduleMap.isEmpty());
		
		Test.stopTest();
	}

	static TestMethod void TestFetchAllInverters() {
		Test.startTest();
		
		Set<Id> masterIds = ProductConfigurationUtility.fetchMasterIds('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', 'Indirect', null);
		System.assertNotEquals(masterIds, null);

		Map<Id, Inverter_Configuration__c> inverterMap = ProductConfigurationUtility.fetchAllInverters(masterIds);
		System.assertNotEquals(null, inverterMap);
		
		Test.stopTest();
	}

	static TestMethod void TestInverterByModule() {
		Test.startTest();
		
		Set<Id> masterIds = ProductConfigurationUtility.fetchMasterIds('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', 'Indirect', null);
		System.assertNotEquals(masterIds, null);

		Module_Configuration__c module = [SELECT Id FROM Module_Configuration__c LIMIT 1];

		Map<Id, Inverter_Configuration__c> inverterMap = ProductConfigurationUtility.fetchInvertersByModule(module.Id, masterIds);
		System.assertNotEquals(inverterMap, null);
		
		Test.stopTest();
	}

	static TestMethod void TestFetchInvertsGrouped() {
		Test.startTest();
		
		Set<Id> masterIds = ProductConfigurationUtility.fetchMasterIds('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', 'Indirect', null);
		System.assertNotEquals(masterIds, null);

		Set<Id> moduleIds = new Set<Id>();
		for(Module_Configuration__c mod : [SELECT Id FROM Module_Configuration__c]) {
			moduleIds.add(mod.Id);
		}
		System.assert(!moduleIds.isEmpty());

		Map<Id, Map<Id, Inverter_Configuration__c>> modInverterMap = ProductConfigurationUtility.fetchInvertersGroupedByModule(moduleIds, masterIds);
		System.assertNotEquals(modInverterMap, null);

		Test.stopTest();
	}

	static TestMethod void TestInvertersNegative() {
		Test.startTest();
		
		Map<Id, Inverter_Configuration__c> invMap1 = ProductConfigurationUtility.fetchAllInverters(null);
		System.assert(invMap1.isEmpty());

		Map<Id, Inverter_Configuration__c> invMap2 = ProductConfigurationUtility.fetchInvertersByModule(null, new Set<Id>());
		System.assert(invMap2.isEmpty());

		Map<Id, Map<Id, Inverter_Configuration__c>> invMap3 = ProductConfigurationUtility.fetchInvertersGroupedByModule(null, new Set<Id>());
		System.assert(invMap3.isEmpty());
	}

	static TestMethod void TestGetMonitoringSingle() {
		Test.startTest();

		Inverter_Configuration__c inv = [SELECT Id, Monitoring__c FROM Inverter_Configuration__c WHERE Monitoring__c != null LIMIT 1];
		System.assertNotEquals(inv, null);

		Map<Id, Monitoring_Configuration__c> monMap = ProductConfigurationUtility.fetchMonitoringByInverter(inv.Monitoring__c);
		System.assertNotEquals(monMap, null);

		Test.stopTest();
	}

	static TestMethod void TestGetMonitoringMultiple() {
		Test.startTest();

		Set<Id> monitoringIds = new Set<Id>();
		for(Inverter_Configuration__c inv : [SELECT Monitoring__c FROM Inverter_Configuration__c]) {
			monitoringIds.add(inv.Monitoring__c);
		}
		System.assert(!monitoringIds.isEmpty());

		Map<Id, Monitoring_Configuration__c> monMap = ProductConfigurationUtility.fetchMonitoringByInverterList(monitoringIds);
		System.assertNotEquals(monMap, null);

		Test.stopTest();
	}

	static TestMethod void TestMonitoringNegatives() {
		Test.startTest();

		Map<Id, Monitoring_Configuration__c> monMap1 = ProductConfigurationUtility.fetchMonitoringByInverter(null);
		System.assert(monMap1.isEmpty());

		Map<Id, Monitoring_Configuration__c> monMap2 = ProductConfigurationUtility.fetchMonitoringByInverterList(new Set<Id>());
		System.assert(monMap2.isEmpty());

		Test.stopTest();
	}

	static TestMethod void TestFetchRacking() {
		Test.startTest();

		Module_Configuration__c mod = [SELECT Id FROM Module_Configuration__c LIMIT 1];
		System.assertNotEquals(mod, null);

		Set<Id> masterIds = ProductConfigurationUtility.fetchMasterIds('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', 'Indirect', null);
		System.assertNotEquals(masterIds, null);

		Map<Id, Racking_Item_Junction__c> rackingMap = ProductConfigurationUtility.fetchRackingByModule(mod.Id, masterIds);
		System.assertNotEquals(rackingMap, null);

		Test.stopTest();
	}

	static TestMethod void TestRackingNegatives() {
		Test.startTest();

		Map<Id, Racking_Item_Junction__c> rackingMap1 = ProductConfigurationUtility.fetchRackingByModule(null, new Set<Id>());
		System.assert(rackingMap1.isEmpty());

		delete [SELECT Id FROM MasterModuleRacking_Junction__c];
		delete [SELECT Id FROM ModuleRackingJunction__c];

		Module_Configuration__c mod = [SELECT Id FROM Module_Configuration__c LIMIT 1];
		System.assertNotEquals(mod, null);

		Set<Id> masterIds = ProductConfigurationUtility.fetchMasterIds('CO', 'SPNA OU', 'Cash', 'Order', 'Residential', 'Indirect', null);
		System.assertNotEquals(masterIds, null);

		Map<Id, Racking_Item_Junction__c> rackingMap = ProductConfigurationUtility.fetchRackingByModule(mod.Id, masterIds);
		System.assert(rackingMap.isEmpty());

		Test.stopTest();
	}

	static TestMethod void TestFetchByMasterName() {

		Test.startTest();

		//negative
		Map<String, List<ModuleInverterJunction__c>> resultMap1 = ProductConfigurationUtility.fetchModulesInvertersByConfigurationModel(new Set<String>());
		System.assertEquals(true, resultMap1.isEmpty());

		//positive
		Map<String, List<ModuleInverterJunction__c>> resultMap2 = ProductConfigurationUtility.fetchModulesInvertersByConfigurationModel(MetadataRetrievalUtil.getFieldDependencies('Design__c','HelixDesignType__c','ModuleTypeAndWattage__c').keySet());
		System.assertNotEquals(resultMap2, null);
		
		Test.stopTest();
	}

}