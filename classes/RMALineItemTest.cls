@isTest
public class RMALineItemTest {
    private static testMethod void test_setItem() {
        RMALineItemTestData td = new RMALineItemTestData();
        td.createTestData_setItem();
        
        // Item__c lookup is set
        RMA_Line_Item__c li = [SELECT Item__c FROM RMA_Line_Item__c WHERE Id = :td.line_item_1.Id];
        system.assertEquals(td.item_1.Id, li.Item__c);
        
        // change item
        li.Name = 'item_2';
        update li;
        li = [SELECT Item__c FROM RMA_Line_Item__c WHERE Id = :td.line_item_1.Id];
        system.assertEquals(td.item_2.Id, li.Item__c);
        
        // item does not exist
        li.Name = 'item_3';
        update li;
        li = [SELECT Item__c FROM RMA_Line_Item__c WHERE Id = :td.line_item_1.Id];
        system.assertEquals(null, li.Item__c);
        
    }
    
}