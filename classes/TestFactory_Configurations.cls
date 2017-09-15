@isTest
public class TestFactory_Configurations {

	//---------------------------- Master Configurator --------------------------------

	private static Master_Configurator__c masterConfig;
	private static Master_Configurator__c masterConfigStacked;

	public static Master_Configurator__c getMasterConfigStacked(){
		if(masterConfigStacked == NULL){
			Master_Configurator__c mcf = createMasterConfig();
			insert mcf;
			masterConfigStacked = mcf;

			insert createSalesConfiguration(mcf.Id);
		}
		return masterConfigStacked;
	}

	public static Master_Configurator__c getMasterConfig(){
		if(masterConfig == NULL){
			Master_Configurator__c mcf = createMasterConfig();
			insert mcf;
			masterConfig = mcf;
		}
		return masterConfig;
	}

	public static Master_Configurator__c createMasterConfig(){
		Master_Configurator__c mc = (Master_Configurator__c)SmartFactory.createSObject('Master_Configurator__c',false);
		return mc;
	}

	//---------------------------- Sales Configurations --------------------------------

	public static SalesConfiguration__c createSalesConfiguration(Id masterConfigId){
		if(masterConfigId == NULL) masterConfigId = getMasterConfig().Id;

		SalesConfiguration__c sc = (SalesConfiguration__c)SmartFactory.createSObject('SalesConfiguration__c',false);
		sc.Configurator__c = masterConfigId;
		return sc;
	}

	//---------------------------- Module Configurations --------------------------------

	public static Module_Configuration__c createModuleConfiguration() {
		Module_Configuration__c mc = (Module_Configuration__c)SmartFactory.createSObject('Module_Configuration__c');
		mc.Item__c = getItem().Id;
		return mc;
	}

	//---------------------------- Inverter Configurations --------------------------------

	public static Inverter_Configuration__c createInverterConfiguration() {
		Inverter_Configuration__c ic = (Inverter_Configuration__c)SmartFactory.createSObject('Inverter_Configuration__c');
		ic.Item__c = getItem().Id;
		ic.Monitoring__c = getMonitoringConfiguration().Id;
		return ic;
	}

	//---------------------------- Monitoring Configurations --------------------------------

	public static Monitoring_Configuration__c getMonitoringConfiguration() {
		Monitoring_Configuration__c mc = (Monitoring_Configuration__c)SmartFactory.createSObject('Monitoring_Configuration__c');
		insert mc;
		Monitoring_Item_junction__c mij = (Monitoring_Item_junction__c)SmartFactory.createSObject('Monitoring_Item_junction__c');
		mij.Item__c = getItem().Id;
		mij.Monitoring_Configuration__c = mc.Id;
		insert mij;
		return mc;
	}

	//---------------------------- Racking Configurations --------------------------------

	public static Racking_Configuration__c createRackingConfiguration() {
		return (Racking_Configuration__c)SmartFactory.createSObject('Racking_Configuration__c');
	}

	//---------------------------- Storage Configurations --------------------------------

	public static Storage_Configuration__c createStorageConfiguration() {
		Storage_Configuration__c sc = (Storage_Configuration__c)SmartFactory.createSObject('Storage_Configuration__c');
		sc.Item__c = getItem().Id;
		return sc;
	}

	//---------------------------- Item for Configurations --------------------------------

	public static Item__c getItem() {
		Item__c i = (Item__c)SmartFactory.createSObject('Item__c');
		i.Item_ID__c = OracleOrderUtility.generateGUID().left(40);
		insert i;
		return i;
	}
}