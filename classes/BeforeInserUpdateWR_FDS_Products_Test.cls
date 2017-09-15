/**
 * Test functionality of BeforeInserUpdateWR_FDS_Products_Test Trigger
 * Which do following task
 * 1. Set WR_FDS_Product__c.Converted_To_Asset__c true if Asset record is exists having serial number of inserted product
 * 2. WR_FDS_Product__c.WR_ORACLE_SalesOrder__c if there is WR_ORACLE_SalesOrder__c with matching Packing_Slip__c
 * 3. If packslip is 2 values seperated by comma then split it and save first value in packslip filed and second in alternate packslip
 * 4. If Alternate packslip have matched Salesorder instead of Packslip then swap them.
 * @Author Shailendra Singh (Appiro offshore)
 */
@isTest
private class BeforeInserUpdateWR_FDS_Products_Test {

    static testMethod void TestBeforeInserUpdateWR_FDS_Products() {
		 // creating Customer Account 
		Account customer = new Account(); 
		customer.Name = 'testCustomer';
		customer.BillingCity = 'jaipur';
		customer.BillingState = 'Rajasthan';
		customer.BillingPostalCode = '302021';
		customer.BillingCountry = 'India';
		customer.BillingStreet = 'test streat1';
        customer.Status__c = 'Active';
        customer.Type = 'Home Owner';
        insert customer; 
      
       // create Asset
       	Asset asset =  new Asset();
       	asset.AccountId = customer.id;
       	asset.SerialNumber = 'G20J01297002-test'; 
       	asset.Name = 'SPR-225-WHT-I N';
        insert asset;
        
        // create Item
       	Item__c item =  new Item__c();
       	item.Description__c = 'PVM, testDesc';
       	item.Item_ID__c = 'testItem_ID';
        insert item;
       	
       	// sales order
       	
       	WR_ORACLE_SalesOrder__c salesOrder = new WR_ORACLE_SalesOrder__c();
       	salesOrder.Packing_Slip__c = 'TEST-59011801';
       	salesOrder.Dealer_Name__c = 'test dealer name';
       	salesOrder.Oracle_Account_Number__c = '121090_Test';
        insert salesOrder;
       	
       	// WR_FDS_Products
       	
       	List<WR_FDS_Product__c> products = new List<WR_FDS_Product__c>();
       	WR_FDS_Product__c product1 = new WR_FDS_Product__c();
       	product1.Serial_Number__c = 'G20J01297002-test';
       	product1.Dealer_Name__c = 'test dealer name';
       	product1.Packing_Slip__c = 'TEST-59011801';
       	product1.Product_Name__c = 'testDesc';
       	products.add(product1);
       	
       	WR_FDS_Product__c product2 = new WR_FDS_Product__c();
       	product2.Serial_Number__c = 'G20J01297003-test';// Not converted outside warranty
       	product2.Dealer_Name__c = 'test dealer name';
       	product2.Packing_Slip__c = 'Alt-59011801,TEST-59011801';
       	product2.PickUpDate__c = System.today().addDays(2);
       	product2.Product_Name__c = 'testDesc';
       	products.add(product2);
       	
       	insert products; 
       	
       	products = [select Converted_To_Asset__c, Item__c From WR_FDS_Product__c where id in: products ];
       		
       
       	System.assertEquals(true,products[0].Converted_To_Asset__c);
       	System.assertEquals(false,products[1].Converted_To_Asset__c);
       	System.assertEquals(item.Id,products[0].Item__c);
       	System.assertEquals(item.Id,products[1].Item__c);
       	
       	// Salesorder lineitem lookup to salesorder is not set 
       	System.assertEquals(salesOrder.id,[select WR_ORACLE_SalesOrder__c From WR_FDS_Product__c where id =:product2.id limit 1].WR_ORACLE_SalesOrder__c);
       	
       	System.assertEquals(salesOrder.id,[select WR_ORACLE_SalesOrder__c From WR_FDS_Product__c where id =:product1.id limit 1].WR_ORACLE_SalesOrder__c);
       	
       	// Oracle Packslip is now primary packslip. Packslip is swaped with Alternat packslip
       	
       	System.assertEquals(salesOrder.Packing_Slip__c,[select Packing_Slip__c From WR_FDS_Product__c where id =:product2.id limit 1].Packing_Slip__c);
       	
       	
       	// Update Product, pickup date can not be less than existing.
       	try{
       		product2.PickUpDate__c = System.today();
       		update product2;
       	}catch(DmlException ex ){
       		System.debug(ex.getMessage());
       	}
       	product2.PickUpDate__c = System.today().addDays(3);
        update product2;
    }
}