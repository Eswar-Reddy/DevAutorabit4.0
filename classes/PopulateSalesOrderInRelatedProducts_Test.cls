/**
 * This class contains unit tests for validating the behavior of PopulateSalesOrderInRelatedProducts trigger
 * @Author Shailendra Singh (Appiro offshore)
 */
@isTest
private class PopulateSalesOrderInRelatedProducts_Test {

    static testMethod void testPopulateSalesOrderInRelatedProducts() {
        
        // create WR_FDS_Product
        
       	List<WR_FDS_Product__c> products = new List<WR_FDS_Product__c>();
       	WR_FDS_Product__c product1 = new WR_FDS_Product__c();
       	product1.Serial_Number__c = 'G20J01297002-test';
       	product1.Dealer_Name__c = 'test dealer name';
       	product1.Packing_Slip__c = 'TEST-5901180';
       	product1.Alternate_Packing_Slip__c = 'TEST-59011801';
       	
       	products.add(product1);
       	
       	WR_FDS_Product__c product2 = new WR_FDS_Product__c();
       	product2.Serial_Number__c = 'G20J01297003-test';
       	product2.Dealer_Name__c = 'test dealer name';
       	product2.Packing_Slip__c = 'TEST-59011801';
       	products.add(product2);
       	
       	insert products; 
       	
       	// create WR_Oracle_SalesOrder
       	
       	WR_ORACLE_SalesOrder__c salesOrder = new WR_ORACLE_SalesOrder__c();
       	salesOrder.Packing_Slip__c = 'TEST-59011801';
       	salesOrder.Dealer_Name__c = 'test dealer name';
       	salesOrder.Oracle_Account_Number__c = '121090_Test';
        insert salesOrder;
        // asset to check if WR_ORACLE_SalesOrder__c is populated and not populated condition 
        System.assertEquals([Select WR_ORACLE_SalesOrder__c from WR_FDS_Product__c where id =:product2.id ].WR_ORACLE_SalesOrder__c,salesOrder.id);
        // Alternat packslip case
        System.assertEquals([Select WR_ORACLE_SalesOrder__c from WR_FDS_Product__c where id =:product1.id ].WR_ORACLE_SalesOrder__c,salesOrder.id);
        System.assertEquals([Select Packing_Slip__c from WR_FDS_Product__c where id =:product1.id ].Packing_Slip__c,salesOrder.Packing_Slip__c);
    }
}