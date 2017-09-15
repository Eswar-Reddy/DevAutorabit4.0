@isTest(SeeAllData=true)
global class RackingCalculationUtility_Test{
   
    public static testMethod void testInvisimount(){
        RackingCalculationUtility rcuTest = new RackingCalculationUtility();
        Map<Id, Racking_Item_Junction__c> rackingMap = new Map<Id, Racking_Item_Junction__c>(); 
        for(Racking_Item_Junction__c item : [SELECT Id, Quantity__c, Item__c, Item__r.Item_Id__c, Item__r.Description__c,
                                                         Racking_Configuration__r.Kit_Size__c, Racking_Configuration__r.Type__c,
                                                         Racking_Configuration__r.Name, Racking_Configuration__c                                                     
                                            FROM Racking_Item_Junction__c
                                            WHERE Racking_Configuration__r.Name LIKE '%Panel AC%']) {
          rackingMap.put(item.Id, item);          
        }                
        rcuTest.calculateInvisimount(rackingMap, 31);
    }
}