public class RMALineItem {
    
    public static void setItem(Map <Integer, RMA_Line_Item__c> qualifyMap) {
        Set <String> partNameSet = new Set <String>();
        for (RMA_Line_Item__c part : qualifyMap.values()) {
            if (part.Name != null) {
                partNameSet.add(part.Name);
            }
        }
        if (partNameSet.size() > 0) {
            Map <String, Item__c> itemMap = new Map <String, Item__c>();        
            for (Item__c item : [SELECT Id, Name FROM Item__c WHERE Name IN :partNameSet]) {       
                itemMap.put(item.Name.toLowerCase(), item);
            }
            for (RMA_Line_Item__c part : qualifyMap.values()) {
                if (part.Name != null && itemMap.containsKey(part.Name.toLowerCase())) {
                    part.Item__c = itemMap.get(part.Name.toLowerCase()).Id;
                } else {
                    part.Item__c = null;
                }
            }
    
        }
    }
    
}