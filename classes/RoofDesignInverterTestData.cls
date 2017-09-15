@isTest
public class RoofDesignInverterTestData {
    public Item__c item_1, item_2;
    public Roof_Design__c roofDesign_1;
    public SunPower_Design_Item__c designItem_1;
    
    public void createTestData() {
        item_1 = getNewItem('item_1');
        item_2 = getNewItem('item_2');
        insert new List <Item__c> {item_1, item_2};
        
        roofDesign_1 = getNewRoofDesign();
        insert new List <Roof_Design__c> {roofDesign_1};
        
        Inverter_Configuration__c ic_1 = getNewInverterConfiguration('ic_1', item_1.Id);
        Inverter_Configuration__c ic_2 = getNewInverterConfiguration('ic_2', item_2.Id);
        insert new List <Inverter_Configuration__c> {ic_1, ic_2};
        
        InverterList__c il_1 = getNewInverterList(roofDesign_1.Id, ic_1.Id);
        InverterList__c il_2 = getNewInverterList(roofDesign_1.Id, ic_1.Id);
        InverterList__c il_3 = getNewInverterList(roofDesign_1.Id, ic_2.Id);
        insert new List <InverterList__c> {il_1, il_2, il_3};
        
        Design__c d_1 = getNewDesign(roofDesign_1.Id);
        insert new List <Design__c> {d_1};
        
        designItem_1 = getNewDesignItem('di_1', d_1.Id);
        insert new List <SunPower_Design_Item__c> {designItem_1};
    }
    
    private static Design__c getNewDesign(String roofDesignId) {
        Design__c d = new Design__c();
        d.Roof_Design__c = roofDesignId;
        return d;
    }
    private static Roof_Design__c getNewRoofDesign() {
        Roof_Design__c rd = new Roof_Design__c();
        return rd;
    }
    private static InverterList__c getNewInverterList(String roofDesignId, String inverterConfigId) {
        InverterList__c il = new InverterList__c();
        il.RoofDesign__c = roofDesignId;
        il.InverterConfiguration__c = inverterConfigId;
        return il;
    }
    private static Inverter_Configuration__c getNewInverterConfiguration(String name, String itemId) {
        Inverter_Configuration__c ic = new Inverter_Configuration__c();
        ic.Name = name;
        ic.Item__c = itemId;
        return ic;
    }
    private static Item__c getNewItem(String name) {
        Item__c i = new Item__c();
        i.Name = name;
        i.Item_ID__c = name;    // required
        return i;
    }
    private static SunPower_Design_Item__c getNewDesignItem(String name, String designId) {
        SunPower_Design_Item__c di = new SunPower_Design_Item__c();
        di.Name = name;
        di.Design__c = designId;
        return di;
    }
    
}