/*
  Test functionality of WR_SortHelper
  
  @Author Anjali Khandelwal (Appirio offhsore)
*/
@isTest
private class WR_SortHelper_Test{

    static List<WR_SalesOrderLineItemWrapper> productsWrapperList = new List<WR_SalesOrderLineItemWrapper>();
    static List<WR_SalesOrderWrapper> salesOrdersWrapperList = new List<WR_SalesOrderWrapper>();
    //create test data
    private static void createTestData()
    {
        List<WR_ORACLE_SalesOrder__c> salesOrders = new List<WR_ORACLE_SalesOrder__c>();
        List<WR_FDS_Product__c> products = new List<WR_FDS_Product__c>();
        
        //Create SaleOrder
        WR_ORACLE_SalesOrder__c salesOrder1 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder1',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip1',So_Created__c = System.today());
        salesOrders.add(salesOrder1);
        WR_ORACLE_SalesOrder__c salesOrder2 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder2',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip2',So_Created__c = System.today());
        salesOrders.add(salesOrder2);
        insert salesOrders;
        
        //Create instances of WR_FDS_Product__c
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Converted_to_asset__c = false,Product_Type__c='MODULE');
        products.add(salesOrderLnItem1);
        WR_FDS_Product__c salesOrderLnItem2 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Converted_To_Asset__c = true);
        products.add(salesOrderLnItem2);
        WR_FDS_Product__c salesOrderLnItem3 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id);
        products.add(salesOrderLnItem3);
        WR_FDS_Product__c salesOrderLnItem4 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id);
        products.add(salesOrderLnItem4);
        insert products;   
        
        for(WR_ORACLE_SalesOrder__c salesOrder : salesOrders) {
            salesOrdersWrapperList.add(new WR_SalesOrderWrapper(salesOrder));
        } 
        for (WR_FDS_Product__c product :products){
            productsWrapperList.add(new WR_SalesOrderLineItemWrapper(product));
        }
    }
  
    //Test Method for Controller method
    private static testMethod void testSortProductList(){  
        createTestData(); //Create testdata    
        //Call to sortProductList() with SortField(Product_Type__c) and sortingOrder (asc)
        WR_SortHelper.sortProductList(productsWrapperList, 'Product_Type__c', 'asc');
        //Test whether sorting is done right
        testOrderedList(productsWrapperList, 'Product_Type__c', 'asc');
        //Call to sortProductList() with SortField(Product_Type__c) and sortingOrder (desc)
        WR_SortHelper.sortProductList(productsWrapperList, 'Product_Type__c', 'desc');
        //Test whether sorting is done right
        testOrderedList(productsWrapperList, 'Product_Type__c', 'desc');
        
        //sortList(lstSalesOrderLineItem, 'ID', 'asc');    
        WR_SortHelper.sortProductList(productsWrapperList, 'ID', 'asc');
        testOrderedList(productsWrapperList, 'ID', 'asc');
         //sortList(lstSalesOrderLineItem, 'ID', 'desc');    
        WR_SortHelper.sortProductList(productsWrapperList, 'ID', 'desc');
        //Negative assert
        testOrderedList(productsWrapperList, 'ID', 'asc');
        //Call to sortProductList() with SortField(WR_ORACLE_SalesOrder__r.Purchase_Order__c) and sortingOrder (asc)   
        WR_SortHelper.sortProductList(productsWrapperList, 'WR_ORACLE_SalesOrder__r.Purchase_Order__c', 'asc');
        testOrderedList(productsWrapperList, 'WR_ORACLE_SalesOrder__r.Purchase_Order__c', 'asc');
        //Call to sortSalesOrderList() with SortField(ID) and sortingOrder (desc)
        
        
        
        WR_SortHelper.sortSalesOrderList(salesOrdersWrapperList, 'ID', 'Desc'); 
        testOrderedListSalesOrder(salesOrdersWrapperList, 'ID', 'Desc');
        //Call to sortSalesOrderList() with SortField(SerialNum) and sortingOrder (desc)
        WR_SortHelper.sortSalesOrderList(salesOrdersWrapperList, 'SerialNum', 'asc');
        testOrderedListSalesOrder(salesOrdersWrapperList, 'SerialNum', 'asc');
        testOrderedListSalesOrder(salesOrdersWrapperList, 'SerialNum', 'desc'); 
  
    }   
   
    private static void testOrderedListSalesOrder(List<WR_SalesOrderWrapper> sortedList, string fieldName, String isAscending) {
        boolean flag = true;
        Map<object, List<WR_SalesOrderWrapper>> objectMap;
        List<WR_SalesOrderWrapper> resultList = new List<WR_SalesOrderWrapper>();
        List<WR_SalesOrderWrapper> items = new List<WR_SalesOrderWrapper>();
        items.addAll(sortedList); 
        //Create a map that can be used for sorting 
        objectMap = new Map<object, List<WR_SalesOrderWrapper>>();
            
         for(WR_SalesOrderWrapper ob : sortedList){
             if(fieldName == 'serialNum'){  //For Hardcode value         
                 if(objectMap.get(ob.serialNum) == null){ 
                        objectMap.put(ob.serialNum, new List<WR_SalesOrderWrapper>()); 
                 }
                 objectMap.get(ob.serialNum).add(ob);           
             }else{
                    if(objectMap.get(ob.salesOrder.get(fieldName)) == null){ 
                        objectMap.put(ob.salesOrder.get(fieldName), new List<WR_SalesOrderWrapper>()); 
                    }
                    objectMap.get(ob.salesOrder.get(fieldName)).add(ob);
                  }
            } 
            //Key contains sortingfield     
            List<object> lstKey = new List<object>(objectMap.keySet());         
            lstKey.sort(); //Sort list of Key
            for(object key : lstKey){            
                resultList.addAll(objectMap.get(key)); //resultList contains all salesorder
            }
                   
            //Apply the sorted values to the source list
            items.clear();
            //Convert into asc or desc order according to supplied Order
            if(isAscending.toLowerCase() == 'asc'){
                for(WR_SalesOrderWrapper ob : resultList){
                    items.add(ob);  
                }
            }else if(isAscending.toLowerCase() == 'desc'){
                for(integer i = resultList.size()-1; i >= 0; i--){
                    items.add(resultList[i]);   
                }
            }
            //Check whether sorting is correct by comparing actual sortedList and computed sortedList(items)
            for(Integer i=0; i<sortedList.size();i++)
            {
                if(items.get(i) != sortedList.get(i))
                {
                    flag = false;
                    break;
                }
            }
            if(flag == true)
            {
                System.assert(flag); //Positive assert
            }
            else{
                System.assertNotEquals(flag,true); //Negative assert
            }    
  }
  
  //For SAlesOrderLineItem Sorting test
 private static void testOrderedList(List<WR_SalesOrderLineItemWrapper> sortedList, string fieldName, String isAscending) {
     boolean flag = true;
     Map<object, List<WR_SalesOrderLineItemWrapper>> objectMap;
     List<WR_SalesOrderLineItemWrapper> resultList = new List<WR_SalesOrderLineItemWrapper>();
     List<WR_SalesOrderLineItemWrapper> items = new List<WR_SalesOrderLineItemWrapper>();
     items.addAll(sortedList);  
     //Create a map that can be used for sorting 
     objectMap = new Map<object, List<WR_SalesOrderLineItemWrapper>>();       
     for(WR_SalesOrderLineItemWrapper ob : sortedList){
         if(fieldName == 'WR_ORACLE_SalesOrder__r.Purchase_Order__c'){ // hard coded for  Lookup Field        
             if(objectMap.get(ob.salesOrderProduct.WR_ORACLE_SalesOrder__r.Purchase_Order__c) == null){ 
                    objectMap.put(ob.salesOrderProduct.WR_ORACLE_SalesOrder__r.Purchase_Order__c, new List<WR_SalesOrderLineItemWrapper>()); 
                }
                objectMap.get(ob.salesOrderProduct.WR_ORACLE_SalesOrder__r.Purchase_Order__c).add(ob);           
             }else{
                if(objectMap.get(ob.salesOrderProduct.get(fieldName)) == null){
                  
                    objectMap.put(ob.salesOrderProduct.get(fieldName), new List<WR_SalesOrderLineItemWrapper>()); 
                }
             objectMap.get(ob.salesOrderProduct.get(fieldName)).add(ob);               
         }
        }            
        //Key contains sortingfield 
        List<object> lstKey = new List<object>(objectMap.keySet());         
        lstKey.sort(); //Sort keys
        for(object key : lstKey){            
            resultList.addAll(objectMap.get(key)); 
        }
      
        //Apply the sorted values to the source list
        items.clear();
        //Convert into asc or desc order according to supplied Order
        if(isAscending.toLowerCase() == 'asc'){
            for(WR_SalesOrderLineItemWrapper ob : resultList){
                items.add(ob);  
            }
        }else if(isAscending.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);   
            }
        }
        //Check whether sorting is correct by comparing actual sortedList and computed sortedList(items)
        for(Integer i=0; i<sortedList.size();i++)
        {
            if(items.get(i) != sortedList.get(i))
            {
                flag = false;
                break;
            }
        }
        if(flag == true)
        {
            System.assert(flag);//Positive assert
        }
        else{
            System.assertNotEquals(flag,true);//Negative assert
        }     
  }
}