@isTest
public class RoofDesignInverterTest {

    private static testMethod void test_designItems() {
        RoofDesignInverterTestData td = new RoofDesignInverterTestData();
        td.createTestData();
        
        td.roofDesign_1.Integration_Message__c = 'Update-Aurora Design imported successfully';
        update td.roofDesign_1;
        
        // verify design item count
        List <SunPower_Design_Item__c> diList = [SELECT Id, Design__c, Oracle_Item_ID__c, Quantity__c
            FROM SunPower_Design_Item__c]; 
        //system.assertEquals(2, diList.size());
        
        // verify quantity
        Map <String, SunPower_Design_Item__c> itemId_di_map = new Map <String, SunPower_Design_Item__c>();
        for (SunPower_Design_Item__c di : diList) {
            itemId_di_map.put(di.Oracle_Item_ID__c, di);
            // verify old design item is deleted
            //system.assertNotEquals(td.designItem_1.Id, di.Id);
        }
        //system.assertEquals(2, itemId_di_map.get(td.item_1.Id).Quantity__c);
        //system.assertEquals(1, itemId_di_map.get(td.item_2.Id).Quantity__c);
    }
    
}