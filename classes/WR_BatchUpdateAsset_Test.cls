/*******************************************************************
    Name        :   WR_BatchUpdateAsset_Test
    Author      :   Appirio Offshore(Anjali Khandelwal)
    Version     :   1.0
    Purpose     :   Test class for WR_BatchUpdateAsset
    Date        :   Sept 21, 2011
*******************************************************************/
@isTest
private class WR_BatchUpdateAsset_Test {

	static List<String> assetIdList;
	
	//Test Method to run batch class for test data
    static testMethod void WR_BatchUpdateAsset_Test() {
        createTestData();
		WR_BatchUpdateAsset.assetToUpdateForTest = assetIdList;
		Test.startTest();
		WR_BatchUpdateAsset job = new WR_BatchUpdateAsset();
		ID batchprocessid = Database.executeBatch(job);
		Database.executeBatch(job,200);
		Test.stopTest();
		
		List<Asset> assetList = [Select Item__c from Asset where id in: assetIdList];
		for(Asset asset1 : assetList){
			system.assert(asset1.Item__c != null);
		}
		system.debug('assetList after batch:::::::::' + assetList);
    }
    
    public static void createTestData(){
    	List<Asset> assetList = new List<Asset>();	
        assetIdList = new List<String>();	
		//Test data
		
		Account acct = createAccount();
		Contact cnct = createContact(acct.Id);
		Asset asset;
		for(Integer i = 0;i<5;i++){
			asset = new Asset(SerialNumber = 'testSN'+i,Name = 'testItemName'+i, AccountId = acct.Id, contactId = cnct.Id);
			assetList.add(asset);
		}
		insert assetList;
		for(Asset asset1 : assetList){
			assetIdList.adD(asset1.Id);
			system.assertEquals(asset1.Item__c,null);
		}
		
		List<Item__c> itemList = new List<Item__c>();
		Item__c item;
		for(Integer i = 0;i<5;i++){
			item = new Item__c();
			item.Item_ID__c = 'testItemId'+i;
			itemList.adD(item);
		}
		insert itemList;
		
		List<WR_FDS_Product__c> fdsProductList = new List<WR_FDS_Product__c>();
		WR_FDS_Product__c fdsProduct;
		for(Integer i = 0;i<5;i++){
			fdsProduct = new WR_FDS_Product__c();
			fdsProduct.Serial_Number__c = 'testSN'+i;
			fdsProduct.Item__c = itemList[i].Id;
			fdsProductList.adD(fdsProduct);
		}
		insert fdsProductList;
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