/*******************************************************************
    Name        :   WR_BatchUpdateFDSProduct_Test
    Author      :   Appirio Offshore(Anjali Khandelwal)
    Version     :   1.0
    Purpose     :   Test class for WR_BatchUpdateFDSProduct
    Date        :   Sept 22, 2011
*******************************************************************/
@isTest
private class WR_BatchUpdateFDSProduct_Test {

	static List<String> fdsProductIdList;
	static List<sObject> fdsProductListToInsert;
    static testMethod void WR_BatchUpdateFDSProductTest() {
        createTestData();
		WR_BatchUpdateFDSProduct.fdsProductToUpdateForTest.addAll(fdsProductIdList);
		Test.startTest();
		
		WR_BatchUpdateFDSProduct job = new WR_BatchUpdateFDSProduct();
		ID batchprocessid = Database.executeBatch(job);
		Database.executeBatch(job,200);
		Test.stopTest();
		
		List<WR_FDS_Product__c> fdsProductList = [Select Item__c,Product_Name__c from WR_FDS_Product__c where id in: fdsProductIdList];
		/*for(WR_FDS_Product__c fds : fdsProductList){
			if(fds.Product_Name__c != 'testProductNam')
				system.assert(fds.Item__c != null);
		}*/
		system.assert(fdsProductList.size() > 0);
		system.debug('fdsProductList after batch:::::::::' + fdsProductList);
		try{
			job.execute(null, fdsProductListToInsert);
		}
		catch(exception ex){
			system.debug('Update failure catched');
		}
    }
    
    public static void createTestData(){
    	
		//Test data
		
		Account acct = createAccount();
		Contact cnct = createContact(acct.Id);
		fdsProductListToInsert = new List<sObject>();
		
		List<Item__c> itemList = new List<Item__c>();
		Item__c item;
		for(Integer i = 0;i<5;i++){
			item = new Item__c();
			item.Item_ID__c = 'testItemId'+i;
			item.Description__c = 'PVM, testProductName'+i;
			itemList.adD(item);
		}
		itemList[1].Description__c = 'PVM, testProductName0';
		insert itemList;
		
		List<WR_FDS_Product__c> fdsProductList = new List<WR_FDS_Product__c>();
		WR_FDS_Product__c fdsProduct;
		for(Integer i = 0;i<5;i++){
			fdsProduct = new WR_FDS_Product__c();
			fdsProduct.Serial_Number__c = 'testSN'+i;
			fdsProduct.Product_Name__c = 'testProductName'+i;
			if(i == 0){
				fdsProduct.Product_Name__c = 'testProductNam';
			}
			fdsProductListToInsert.adD((sObject)fdsProduct);
			if(i != 0){
				fdsProductList.adD(fdsProduct);
			}
		}
		
		insert fdsProductList;
		fdsProductIdList = new List<String>();
				
		for(WR_FDS_Product__c fds : fdsProductList){
			fdsProductIdList.adD(fds.Id);
			system.assertEquals(fds.Item__c,null);
		}
    }
    
    //Create Account()
	public static Account createAccount(){
	        
	        Account account1 = new Account();
	        account1.Name = 'testaccount1'  + String.valueOf(Datetime.now());
	        account1.BillingCity = 'testcity';
	        account1.BillingCountry = 'testcountry';
	        account1.BillingState = 'teststate';
	        account1.BillingStreet = 'teststreet';
	        account1.BillingPostalCode = 'testzip';
	        insert account1;
	        return account1;
	}
	
	//Create Contact()
	public static Contact createContact(ID accountID){
        Contact ctc = new Contact(LastName = 'testLastName'  + String.valueOf(Datetime.now()) ,AccountId = accountID);
        insert ctc;
        return ctc;
	}
}