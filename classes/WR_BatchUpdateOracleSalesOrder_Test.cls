/**************************************************************************************************************************
    Class is test class used for WR_BatchUpdateOracleSalesOrder
    
    @Author Anjali Khandelwal (Appiro offshore)
***************************************************************************************************************************/
@isTest
private class WR_BatchUpdateOracleSalesOrder_Test {

	static List<String> salesOrderIdList;
	static List<sObject> salesOrderListToInsert;
    static testMethod void WR_BatchUpdateOracleSalesOrderTest() {
    	createAccount();
        createTestData();
        
        WR_BatchUpdateOracleSalesOrder.salesOrderToUpdateForTest = salesOrderIdList;
		Test.startTest();
		WR_BatchUpdateOracleSalesOrder job = new WR_BatchUpdateOracleSalesOrder();
		ID batchprocessid = Database.executeBatch(job);
		Database.executeBatch(job,200);
		Test.stopTest();
		
		List<WR_ORACLE_SalesOrder__c> salesOrderList = [Select Partner_Account__c from WR_ORACLE_SalesOrder__c where id in: salesOrderIdList];
		for(WR_ORACLE_SalesOrder__c salesOrder : salesOrderList){
			system.assert(salesOrder.Partner_Account__c != null);
		}
		system.debug('salesOrderList after batch:::::::::' + salesOrderList);
		
		job.execute(null, salesOrderListToInsert);
		
    }
    
    //Create Account()
	public static void createAccount(){
	        
	        List<Account> accList = new List<Account>();
	    	Account account;
	    	for(Integer i = 0; i<5;i++){
	    		account = new Account();
		        account.Name = 'testaccount' +i + String.valueOf(Datetime.now());
		        account.BillingCity = 'testcity' + i;
		        account.BillingCountry = 'testcountry' + i;
		        account.BillingState = 'teststate'+i;
		        account.BillingStreet = 'teststreet' + i;
		        account.BillingPostalCode = 'testzip'+i;
	        
	        	account.Theater__c = 'Europe';
	    		account.Oracle_Account_Number__c = 'testOracleNum' + i;
	       		accList.add(account);
	    	}
	        
        	insert accList;
	       
	}
	
	//create test data
	public static void createTestData(){
		salesOrderListToInsert = new List<sObject>();
		salesOrderIdList = new List<String>();
		List<WR_ORACLE_SalesOrder__c> listOracleSalesOrder = new List<WR_ORACLE_SalesOrder__c>();
		WR_ORACLE_SalesOrder__c salesOrder;
		for(Integer i = 0; i<5;i++){
    		salesOrder = new WR_ORACLE_SalesOrder__c(Oracle_Account_Number__c = 'testOracleNum' + i,Packing_Slip__c = 'PL-test-'+i);
			listOracleSalesOrder.adD(salesOrder);
			salesOrderListToInsert.adD(salesOrder);
    	}
		insert listOracleSalesOrder;
		
		for(WR_ORACLE_SalesOrder__c so : listOracleSalesOrder){
			system.assert(so.Partner_Account__c == null);
			salesOrderIdList.add(so.Id);
		}
	}
}