public class WR_SortHelper {

    /*This method takes 3 arguments, the List of objects to sort, the field to sort, 
    and the order, asc or desc*/
    
    public static void sortProductList(List<WR_SalesOrderLineItemWrapper> items, String sortField, String order){
        List<WR_SalesOrderLineItemWrapper> resultList = new List<WR_SalesOrderLineItemWrapper>();
    
        //Create a map that can be used for sorting 
        Map<object, List<WR_SalesOrderLineItemWrapper>> objectMap = new Map<object, List<WR_SalesOrderLineItemWrapper>>();
			
	   for(WR_SalesOrderLineItemWrapper ob : items){
	   		if(sortField == 'WR_ORACLE_SalesOrder__r.Purchase_Order__c'){ // hard coded for  Lookup Fiel 
 				if(objectMap.get(ob.salesOrderProduct.WR_ORACLE_SalesOrder__r.Purchase_Order__c) == null){ 
                    objectMap.put(ob.salesOrderProduct.WR_ORACLE_SalesOrder__r.Purchase_Order__c, new List<WR_SalesOrderLineItemWrapper>()); 
                }
                objectMap.get(ob.salesOrderProduct.WR_ORACLE_SalesOrder__r.Purchase_Order__c).add(ob);	   			
	   		}else{
                if(objectMap.get(ob.salesOrderProduct.get(sortField)) == null){ 
                    objectMap.put(ob.salesOrderProduct.get(sortField), new List<WR_SalesOrderLineItemWrapper>()); 
                }
                objectMap.get(ob.salesOrderProduct.get(sortField)).add(ob);
	   		}
        }        
        
        
        
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
        
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
        
        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(WR_SalesOrderLineItemWrapper ob : resultList){
                items.add(ob);  
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);   
            }
        }
    }
    
   /*This method takes 3 arguments, the List of objects to sort, the field to sort, 
    and the order, asc or desc*/
    
    public static void sortSalesOrderList(List<WR_SalesOrderWrapper> items, String sortField, String order){
        List<WR_SalesOrderWrapper> resultList = new List<WR_SalesOrderWrapper>();
    
        //Create a map that can be used for sorting 
        Map<object, List<WR_SalesOrderWrapper>> objectMap = new Map<object, List<WR_SalesOrderWrapper>>();
        
	   for(WR_SalesOrderWrapper ob : items){
	   		if(sortField == 'serialNum'){ // hard coded for  Serial Num. 
 				if(objectMap.get(ob.serialNum) == null){ 
                    objectMap.put(ob.serialNum, new List<WR_SalesOrderWrapper>()); 
                }
                objectMap.get(ob.serialNum).add(ob);	   			
	   		}else{
                if(objectMap.get(ob.salesOrder.get(sortField)) == null){ 
                    objectMap.put(ob.salesOrder.get(sortField), new List<WR_SalesOrderWrapper>()); 
                }
                objectMap.get(ob.salesOrder.get(sortField)).add(ob);
	   		}
        }        
        
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
        
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
        
        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(WR_SalesOrderWrapper ob : resultList){
                items.add(ob);  
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);   
            }
        }
    }    
}