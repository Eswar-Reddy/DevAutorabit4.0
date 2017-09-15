/*****************************************************************************
    Class is test Class for WR_InitiateOnlineOrder
    
    @Author Anjali Khandelwal (Appiro offshore)
*****************************************************************************/
@isTest
private class WR_InitiateOnlineOrder_Test {

    static testMethod void testWR_InitiateOnlineOrder() {
        createTestData();
        String testSalesOrderNumStr = 'test_salesorder1,test_salesorder2,test_salesorder3,test_salesorder4';
        WR_InitiateOnlineOrder initiateOnlineOrder = new WR_InitiateOnlineOrder(testSalesOrderNumStr,'test_oracle2');
    	String notMatchedSalesOrder = initiateOnlineOrder.getNoneMatchedSalesOrdersString();
    	system.assertEquals(notMatchedSalesOrder,'test_salesorder4');
    }
    
     /*
        This method is for creating test data-- creating salesOrder, SalesOrderLineItem
    */
    private static void createTestData()
    {
        List<WR_ORACLE_SalesOrder__c> lstSalesOrder = new List<WR_ORACLE_SalesOrder__c>();
        List<WR_FDS_Product__c> lstProduct = new List<WR_FDS_Product__c>();
        Date edt = System.today();
        //Create test data for salesOrder
        WR_ORACLE_SalesOrder__c salesOrder1 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder1',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle2',Packing_Slip__c='testPackingSlip1');
        lstSalesOrder.add(salesOrder1);
        WR_ORACLE_SalesOrder__c salesOrder2 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder2',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle2',Packing_Slip__c='testPackingSlip2');
        lstSalesOrder.add(salesOrder2);
        WR_ORACLE_SalesOrder__c salesOrder3 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder3',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle2',Packing_Slip__c='testPackingSlip3');
        lstSalesOrder.add(salesOrder3);
        insert lstSalesOrder;
        
        //Create test data for salesOrderLineItem
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Name__c = 'tstPdct1', Converted_To_Asset__c = true);
        lstProduct.add(salesOrderLnItem1);
        WR_FDS_Product__c salesOrderLnItem2 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Name__c = 'tstPdct2', Converted_To_Asset__c = true);
        lstProduct.add(salesOrderLnItem2);
        WR_FDS_Product__c salesOrderLnItem3 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Name__c = 'tstPdct3', Converted_To_Asset__c = false);
        lstProduct.add(salesOrderLnItem3);
        WR_FDS_Product__c salesOrderLnItem4 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Name__c = 'tstPdct4', Converted_To_Asset__c = false);
        lstProduct.add(salesOrderLnItem4);
        WR_FDS_Product__c salesOrderLnItem5 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip3',WR_ORACLE_SalesOrder__c = salesOrder3.Id,Product_Name__c = 'tstPdct5');
        lstProduct.add(salesOrderLnItem5);
        insert lstProduct; 
    }
}