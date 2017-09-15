/* Test functionality of Warranty_SearchFDSAdminClass

  @Author         Anjali Khandelwal
  CreatedDate     03/09/2011
*/

@isTest
private class Warranty_SearchFDSAdminClass_Test{

    public static WR_FDS_Product__c salesOrderLnItem1;
    
    private static void createTestData()
    {
               
        List<WR_ORACLE_SalesOrder__c> lstSalesOrder = new List<WR_ORACLE_SalesOrder__c>();
        List<WR_FDS_Product__c> lstProduct = new List<WR_FDS_Product__c>();
       
        //Create SaleOrder
        WR_ORACLE_SalesOrder__c salesOrder1 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder1',CurrencyIsoCode='USD', Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip1',So_Created__c = System.today(),Theater__c = 'testTheater1');
        lstSalesOrder.add(salesOrder1);
        WR_ORACLE_SalesOrder__c salesOrder2 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder2',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip2',So_Created__c = System.today(),Theater__c = 'testTheater2');
        lstSalesOrder.add(salesOrder2);
        insert lstSalesOrder;
        
        //Create instances of WR_FDS_Product__c        
        salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Converted_to_asset__c = false,Product_Type__c='MODULE');
        lstProduct.add(salesOrderLnItem1);
        WR_FDS_Product__c salesOrderLnItem2 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',Serial_Number__c = 'test_serialnum1',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Converted_To_Asset__c = true);
        lstProduct.add(salesOrderLnItem2);
        WR_FDS_Product__c salesOrderLnItem3 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Alternate_Packing_Slip__c='testPackingSlip2',Serial_Number__c = 'test_serialnum2',WR_ORACLE_SalesOrder__c = salesOrder2.Id);
        lstProduct.add(salesOrderLnItem3);
        WR_FDS_Product__c salesOrderLnItem4 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',Serial_Number__c = 'test_serialnum3',WR_ORACLE_SalesOrder__c = salesOrder2.Id);
        lstProduct.add(salesOrderLnItem4);
        //start for case #00063392
        WR_FDS_Product__c salesOrderLnItem5 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip5',Serial_Number__c = 'test_serialnum5',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Product_Name__c = 'Test_Product');
        lstProduct.add(salesOrderLnItem5);
        //end for case #00063392
        insert lstProduct;           
        
        //start for case #00063392
        Warranty_Registration__c wr = new Warranty_Registration__c(Status__c='Draft');
        insert wr;
        WR_Line_Item__c wrline = new WR_Line_Item__c(Warranty_Registration__c = wr.Id, WR_FDS_Product__c = lstProduct.get(1).Id);
        insert wrline;
        //end for case #00063392
    }
    
    private static testMethod void testSearchRecords(){
        
        createTestData();
        
        ApexPages.StandardSetController setCon; 
        ApexPages.StandardController Con = new ApexPages.StandardController(salesOrderLnItem1);       
       
        Warranty_SearchFDSAdminClass wr_Search = new Warranty_SearchFDSAdminClass(Con );
        //When no value in standardSetController
        wr_Search.getFdsRecords();
        
        wr_Search.searchKey = 'w.Serial_Number__c';
        wr_Search.searchValue = 'test_serialnum1';
        
        //Call to searchRecords() with search value -> 'test_serialnum1' and searchKey > 'Serial_Number__c'
        PageReference pg = wr_Search.searchRecords();
        wr_Search.searchValue = 'test_serialnum1 test_serialnum2';
        //Call to searchRecords() with search value(space delimited multiple search ) -> 'test_serialnum1 test_serialnum2' and searchKey > 'Serial_Number__c'        
        pg = wr_Search.searchRecords();
        
        //When there is value in standardSetController
        wr_Search.getFdsRecords();
        
        wr_Search.exportCSV();
        
        wr_Search.getFdsRecords();
        //start for case #00063392
        wr_Search.getProdWarrantyWrapperLst();
        wr_Search.exportCSV();
        //end for case #00063392
        wr_Search.searchKey = 'w.Packing_Slip__c';
        wr_Search.searchValue = 'testPackingSlip2';
        pg = wr_Search.searchRecords();
    }
}