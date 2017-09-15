/*
* RackingCalculationUtility - utility class for racking calculation. Supports Invisimount and Solarmount
* SFDC Release - 
*
* Pivotal Tracker Updates:
* ID #131120221 - Racking calculation utility class
*/

public class RackingCalculationUtility{
  
    public Map<String, Integer> returnItemMap = new Map<String, Integer>();
    public Map<Integer, List<Racking_Item_Junction__c>> kitsWithQty = new Map<Integer, List<Racking_Item_Junction__c>>();
        
    //When creating a new utility, it should receive a list of applicable Racking Configuration objects from the calling class
    public RackingCalculationUtility(){ 
        return;
    }
    //Construct a list of kits and quantities following a minimal quantity logic (i.e. use the biggest kits possible that are still less than or equal to the panel count)
    //Loop through the list of kits to sum up the individual components in each kit by looking at the Racking Item Junction records associated with the racking config
    //return a map of item # and quantity corresponding to the racking BoM.    
    public Map<String, Integer> calculateInvisimount(Map<Id, Racking_Item_Junction__c> rackingConfigs, Decimal panelCount){
        if(!rackingConfigs.isEmpty()){       
            List<Integer> kitSizeList = new List<Integer>();    
            List<OrderAppUtility.DescSorter> sortingList = new List<OrderAppUtility.DescSorter>();
            for(Id i : rackingConfigs.keySet()) {
                if(rackingConfigs.get(i).Racking_Configuration__r.Kit_Size__c != null && rackingConfigs.get(i).Racking_Configuration__r.Kit_Size__c > 0) {
                    OrderAppUtility.DescSorter s = new OrderAppUtility.DescSorter();
                    s.identifier = i;
                    s.sortingValue = rackingConfigs.get(i).Racking_Configuration__r.Kit_Size__c.intValue();
                    sortingList.add(s);
                    //updateKit(s.sortingValue, rackingConfigs.get(i));
                }
            }
            OrderAppUtility.SORT_DIR = OrderAppUtility.SortDirection.DESCENDING;
            sortingList.sort();
            for(OrderAppUtility.DescSorter s : sortingList){
                updateKit(s.sortingValue, rackingConfigs.get(s.identifier));
            }
            Integer panelsRemaining = Integer.valueOf(panelCount);
            Integer roundedPanelsRemaining = round(panelsRemaining);
            for(Integer kit : kitsWithQty.keySet()) {  
                while(roundedPanelsRemaining >= kit){         
                    panelsRemaining -= kit;
                    roundedPanelsRemaining = round(panelsRemaining);
                    try {
                        List<Racking_Item_Junction__c> fullKit = kitsWithQty.get(kit);
                        for(Racking_Item_Junction__c kitItem : fullKit){
                            updateItemMap(kitItem.Item__r.Item_ID__c, Integer.valueOf(kitItem.Quantity__c));    
                        }                
                    } catch(Exception e) {
                        System.debug('Exception while Calculating Invisimount Racking: '+e.getMessage());
                    }     
                }                  
            }
            if(panelsRemaining > 0){
                OrderAppUtility.DescSorter s = sortingList.get(sortingList.size()-1);
                List<Racking_Item_Junction__c> fullKit = kitsWithQty.get(s.sortingValue);
                for(Racking_Item_Junction__c kitItem : fullKit){
                    updateItemMap(kitItem.Item__r.Item_ID__c, Integer.valueOf(kitItem.Quantity__c));    
                }      
            }
            return returnItemMap;
        }
        return null;
    }
    public Purchase_Order_Line__c calculateSolarmount(Racking_Item_Junction__c rackingConfig, Decimal panelCount, Decimal moduleWidth){
        //ModuleCount *Module Width/132
        Purchase_Order_Line__c rackingOrderLine = new Purchase_Order_line__c();
        if(rackingConfig != null) {
    
            Racking_Item_Junction__c selectedRacking = rackingConfig;
            rackingOrderLine.Item_ID__c = selectedRacking.Item__r.Item_ID__c;
            rackingOrderLine.Item_Number__c = selectedRacking.Item__r.Item_ID__c;
			rackingOrderLine.Oracle_Item_ID__c = selectedRacking.Item__c;
            //Decimal moduleWidth = moduleConfig;
            Decimal temp = (panelCount * moduleWidth)/132;
            temp = temp.round(System.RoundingMode.CEILING);
            Integer calculatedQty = Integer.valueOf(temp);
            rackingOrderLine.Quantity__c = calculatedQty;
            rackingOrderLine.Item_Description__c = selectedRacking.Item__r.Description__c;
            return rackingOrderLine;
        }
        return null;    
    }     
    //Helper class to handle the Item Map, takes in an item number and quantity from a Racking_Item_Junction__c object
    public void updateItemMap(String itemNumber, Integer quantity){
        
        Integer curMapQuantity;
        if(returnItemMap.containsKey(itemNumber)){
            curMapQuantity = returnItemMap.get(itemNumber);
            curMapQuantity += quantity;
            returnItemMap.put(itemNumber, curMapQuantity);
        }
        else
            returnItemMap.put(itemNumber, quantity);
    }
    //Helper class to handle the Items in a 'kit'
    public void updateKit(Integer kitSize, Racking_Item_Junction__c junction){
        if(kitsWithQty.containsKey(kitSize)){
            List<Racking_Item_Junction__c> kit = kitsWithQty.get(kitSize);
            kit.add(junction);
            kitsWithQty.put(kitSize, kit);
        }
        else{
            List<Racking_Item_Junction__c> newKit = new List<Racking_Item_Junction__c>();
            newKit.add(junction);
            kitsWithQty.put(kitSize, newKit);
        }
            
    }
    //Round to the nearest multiple of three
    public integer round(integer n){
        return (n + 2) / 3 * 3;
    }
}