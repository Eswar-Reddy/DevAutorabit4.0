/**************************************************************************************************************************
    Class is batch class used for populating "Partner_Account(Account lookup)" field of 
    WR_Oracle_SalesOrder according to match of Oracle_Account_Number__c field of WR_Oracle_SalesOrder with Oracle_Account_Number__c
    field of Account object. (For existing records)
    
    @Author Anjali Khandelwal (Appiro offshore)
***************************************************************************************************************************/
global with sharing class WR_BatchUpdateOracleSalesOrder implements Database.Batchable<SObject>,Database.Stateful{
	
	public static List<String> salesOrderToUpdateForTest = new List<String>();
    
    //----------------------------------------------------------------------------------------//
    // Global method - start
    //----------------------------------------------------------------------------------------//
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,Oracle_Account_Number__c FROM WR_ORACLE_SalesOrder__c WHERE Partner_Account__c = null ';
        if(Test.isRunningTest() && salesOrderToUpdateForTest.size() > 0){
        	query += ' and Id in: salesOrderToUpdateForTest';
        }
        return Database.getQueryLocator(query); 
    }
    
    //----------------------------------------------------------------------------------------//
    // Global method - execute
    //----------------------------------------------------------------------------------------//
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Map<String, Account> accountMap = new Map<String, Account>();
        // To hold WR_ORACLE_SalesOrder__c which needs to be update 
        List<WR_ORACLE_SalesOrder__c> listOracleSalesOrder = new List<WR_ORACLE_SalesOrder__c>();
        Set<String> oracleAccNumSet = new Set<String>();
        
        for(SObject sObj : scope){
            WR_ORACLE_SalesOrder__c salesOrder = (WR_ORACLE_SalesOrder__c)sObj;
        	if(salesOrder.Oracle_Account_Number__c != null)
        		oracleAccNumSet.add(salesOrder.Oracle_Account_Number__c);
        }
        List<Account> accountList = [SELECT Id,Oracle_Account_Number__c,Theater__c from Account WHERE Oracle_Account_Number__c in: oracleAccNumSet and Theater__c != null];
	    for(Account acc : accountList){
	      	accountMap.put(acc.Oracle_Account_Number__c, acc);
	    }
        // Iterate scope to update field
        for(SObject sObj : scope){
            WR_ORACLE_SalesOrder__c salesOrder = (WR_ORACLE_SalesOrder__c)sObj;
            if(accountMap.get(salesOrder.Oracle_Account_Number__c) != null && accountMap.get(salesOrder.Oracle_Account_Number__c).Theater__c != null){
            	salesOrder.Partner_Account__c = accountMap.get(salesOrder.Oracle_Account_Number__c).Id;
           		listOracleSalesOrder.add(salesOrder);
            }
        }
        
        // Update WR_ORACLE_SalesOrder__c
        if(listOracleSalesOrder.size() > 0){
            update listOracleSalesOrder;
        }
    }
    
    //----------------------------------------------------------------------------------------//
    // Global method - finish
    //----------------------------------------------------------------------------------------//
    global void finish(Database.BatchableContext BC){
        
    }

}