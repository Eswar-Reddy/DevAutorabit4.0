/*****************************************************************************
    Class is test class for WR_CSVFileUploader
    
    @Author Anjali Khandelwal (Appiro offshore)
*****************************************************************************/
@isTest
private class WR_CSVFileUploader_Test {

    static testMethod void testWR_CSVFileUploader() {
    	
    	createTestData();
    	Blob data = Blob.valueOf('SN#\ntestSN1,\ntestSN2,\ntestSN3,\ntestSN4,\ntestSN5,\ntestSN6,');
    	WR_CSVFileUploader fileUploader = new WR_CSVFileUploader(data,'test_oracle2');
    	
    	String nonMatchingStr = fileUploader.getNoneMatchedSerialNumstring();
    	System.assert(nonMatchingStr.contains('testSN6'));
        
    }
    
    /*
        This method is for creating test data-- creating salesOrder, SalesOrderLineItem
    */
    private static void createTestData()
    {
        List<WR_ORACLE_SalesOrder__c> lstSalesOrder = new List<WR_ORACLE_SalesOrder__c>();
        List<WR_FDS_Product__c> lstProduct = new List<WR_FDS_Product__c>();
        //lstProduct1 = new List<WR_FDS_Product__c>();
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
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Name__c = 'tstPdct1', Converted_To_Asset__c = true, Serial_Number__c = 'testSN1');
        lstProduct.add(salesOrderLnItem1);
        WR_FDS_Product__c salesOrderLnItem2 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Name__c = 'tstPdct2', Converted_To_Asset__c = true, Serial_Number__c = 'testSN2');
        lstProduct.add(salesOrderLnItem2);
        WR_FDS_Product__c salesOrderLnItem3 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Name__c = 'tstPdct3', Converted_To_Asset__c = false, Serial_Number__c = 'testSN3');
        lstProduct.add(salesOrderLnItem3);
        WR_FDS_Product__c salesOrderLnItem4 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Name__c = 'tstPdct4', Converted_To_Asset__c = false, Serial_Number__c = 'testSN4');
        lstProduct.add(salesOrderLnItem4);
        WR_FDS_Product__c salesOrderLnItem5 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip3',WR_ORACLE_SalesOrder__c = salesOrder3.Id,Product_Name__c = 'tstPdct5', Serial_Number__c = 'testSN5');
        lstProduct.add(salesOrderLnItem5);
        insert lstProduct; 
        /*lstProduct1.add(salesOrderLnItem3);
        lstProduct1.add(salesOrderLnItem4);
        lstProduct1.add(salesOrderLnItem5);     */  
    }
}