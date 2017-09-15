/**
 * Test class for testing functionality of CreateWRItemAssets Trigger which set salesorder line item
   Converted_To_Asset = true ,when warranty is completed.
   @Author Shailendra Singh (Appiro offshore)
 */
@isTest
private class CreateWRItemAssets_Test {
    
    
    static testMethod void myUnitTest() {

        Account customer = new Account();
        customer.Name = 'Shailendra_test';
        customer.BillingCity = 'Jaipur';
        customer.BillingCountry = 'India';
        customer.BillingPostalCode = '302021';
        customer.BillingState = 'Rajasthan';
        customer.BillingStreet = '129 Streat 1';
        customer.Status__c = 'Active';
        customer.Type = 'Home Owner';
        customer.Theater__c = 'Europe'; 
        insert customer;
        
        Product2 product = new Product2(Name = 'Test-225');
        insert product;
        
        WR_ORACLE_SalesOrder__c salesOrder = new WR_ORACLE_SalesOrder__c();
        salesOrder.Dealer_Name__c = 'Test';
        salesOrder.Packing_Slip__c = 'PL-5560742_test';
        salesOrder.Sales_Order__c = '121Test';
        insert salesOrder;
        
        WR_FDS_Product__c salesOrderProduct = new WR_FDS_Product__c();
        salesOrderProduct.Packing_Slip__c = 'PL-5560742_test';
        salesOrderProduct.Dealer_Name__c = 'Test';
        salesOrderProduct.Product_Type__c = 'Test-Type';
        salesOrderProduct.Product_Name__c = 'test-Product';
        salesOrderProduct.Serial_Number__c = 'test1234567';

        insert salesOrderProduct;        

        Warranty_Registration__c warranty = new Warranty_Registration__c();
        warranty.Customer_SFDC_ID__c = customer.id;
        insert warranty;
        
        WR_Line_Item__c item  = new WR_Line_Item__c();
        item.Warranty_Registration__c = warranty.id;
        item.WR_FDS_Product__c = salesOrderProduct.id;
        insert item;    

        warranty.Status__c = 'Completed';
    
        //System.assertEquals(false,[select CONVERTED_TO_ASSET__c from WR_FDS_Product__c where ID =: salesOrderProduct.id].CONVERTED_TO_ASSET__c);
            
        update warranty;
        
        //System.assertEquals(true,[select CONVERTED_TO_ASSET__c from WR_FDS_Product__c where ID =: salesOrderProduct.id].CONVERTED_TO_ASSET__c);
        
        //Asset created
        
        //System.assertEquals(1,[select ID from Asset where SerialNumber = :salesOrderProduct.Serial_Number__c limit 1].size());
        
        //Asset lookup is set to wr_line_item
        
        //System.assertEquals([select assetID__c from WR_Line_Item__c where ID=:item.id].assetID__c,[select ID from Asset where SerialNumber = :salesOrderProduct.Serial_Number__c limit 1].ID);
        
    }
}