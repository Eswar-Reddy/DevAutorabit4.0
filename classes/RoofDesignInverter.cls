public class RoofDesignInverter {

    public static void createDesignInverters(Map<Integer, Roof_Design__c> qualifyMap) {
        Set <String> rdIdSet = new Set <String>();    
        if (qualifyMap != null) {
            for (Roof_Design__c rd : qualifyMap.values()) {
                if (rd != null && rd.Id != null) {
                    rdIdSet.add(rd.Id);
                }
            }
        }
        if (rdIdSet.size() == 0) {
            return;
        }
        
        // group by item
        Map <String, Map <String, List<Item__c>>> rd_itemsMap_map = new Map <String, Map <String, List<Item__c>>>();
        for (InverterList__c invLst : [SELECT Id, RoofDesign__c, 
                InverterConfiguration__c, 
                InverterConfiguration__r.Item__c, InverterConfiguration__r.Item__r.Id, InverterConfiguration__r.Item__r.Name 
            FROM InverterList__c
            WHERE RoofDesign__c IN :rdIdSet AND InverterConfiguration__r.Item__c != null]) {
        
            Map <String, List<Item__c>> itemsMap = new Map <String, List<Item__c>>();
            List <Item__c> items = new List<Item__c>();
            if (rd_itemsMap_map.containsKey(invLst.RoofDesign__c)) {
                itemsMap = rd_itemsMap_map.get(invLst.RoofDesign__c);
            }
            if (itemsMap.containsKey(invLst.InverterConfiguration__r.Item__c)) {
                items = itemsMap.get(invLst.InverterConfiguration__r.Item__c);
            } 
            items.add(invLst.InverterConfiguration__r.Item__r); 
            itemsMap.put(invLst.InverterConfiguration__r.Item__c, items);
            rd_itemsMap_map.put(invLst.RoofDesign__c, itemsMap);  
        }
        
        // delete/create SunPower_Design_Item__c records
        List <SunPower_Design_Item__c> sdiDeleteList = new List <SunPower_Design_Item__c>();        
        List <SunPower_Design_Item__c> sdiInsertList = new List <SunPower_Design_Item__c>();
        for (Design__c d : [SELECT Id, Roof_Design__c, (SELECT Id FROM SunPower_Design_Items__r) 
                FROM Design__c WHERE Roof_Design__c IN :rdIdSet]) {
            
            // add to delete list
            sdiDeleteList.addAll(d.SunPower_Design_Items__r);
            
            // add to insert list
            if (rd_itemsMap_map.containsKey(d.Roof_Design__c)) {
                Map <String, List<Item__c>> itemsMap = rd_itemsMap_map.get(d.Roof_Design__c);
                for (String itemId : itemsMap.keySet()) {
                    if (itemsMap.get(itemId).size() > 0) {
                        SunPower_Design_Item__c sdi = new SunPower_Design_Item__c();
                        sdi.Name = itemsMap.get(itemId)[0].Name;
                        sdi.Design__c = d.Id;
                        sdi.Oracle_Item_ID__c = itemId;
                        sdi.Quantity__c = itemsMap.get(itemId).size();
                        sdi.Component_Type__c = 'Inverter';
                        sdiInsertList.add(sdi);
                    }
                } 
            }
        }
        
        if (sdiDeleteList.size() > 0) {
            delete sdiDeleteList;
        }
        if (sdiInsertList.size() > 0) {
            insert sdiInsertList;
        }
    }

}