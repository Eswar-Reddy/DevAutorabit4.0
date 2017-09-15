/**************************************************************************************************************************
    Class is batch class used for populating "Item__c(Item lookup)" field of 
    Asset according to match of SerialNumber field of Asset with Serial_Number__c
    field of WR_FDS_Product__c object. (For existing records)
    
    @Author Anjali Khandelwal (Appiro offshore)
***************************************************************************************************************************/
global with sharing class WR_BatchUpdateAsset implements Database.Batchable<SObject>,Database.Stateful{
	   
	   
    public static List<String> assetToUpdateForTest = new List<String>();
    //----------------------------------------------------------------------------------------//
    // Global method - start
    //----------------------------------------------------------------------------------------//
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,Item__c,SerialNumber FROM Asset WHERE Item__c = null ';
       
        if(Test.isRunningTest() && assetToUpdateForTest!=null)
            query += ' AND Id in: assetToUpdateForTest';
        return Database.getQueryLocator(query); 
    }
    
    //----------------------------------------------------------------------------------------//
    // Global method - execute
    //----------------------------------------------------------------------------------------//
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Map<String, WR_FDS_Product__c> fdsProductMap = new Map<String, WR_FDS_Product__c>();
        // To hold Asset which needs to be update 
        List<Asset> listAsset = new List<Asset>();
        Set<String> serialNumbersSet = new Set<String>();
        // Iterate scope to update field
        for(SObject sObj : scope){ 
            Asset asset = (Asset)sObj;
            if(asset.SerialNumber != null)
        		serialNumbersSet.add(asset.SerialNumber);
        }
        
        List<WR_FDS_Product__c> fdsProductList = [SELECT Id,Item__c,Serial_Number__c from WR_FDS_Product__c WHERE Item__c != null and Serial_Number__c in: serialNumbersSet];
	    for(WR_FDS_Product__c product : fdsProductList){
	      	fdsProductMap.put(product.Serial_Number__c, product);
	    }
      
        // Iterate scope to update field
        for(SObject sObj : scope){
            Asset asset = (Asset)sObj;
            if(fdsProductMap.get(asset.SerialNumber) != null && fdsProductMap.get(asset.SerialNumber).Item__c != null){
            	asset.Item__c = fdsProductMap.get(asset.SerialNumber).Item__c;
            	listAsset.add(asset);
            }
        }
        
        // Update Asset
        if(listAsset.size() > 0){
            update listAsset;
        }
    }
    
    //----------------------------------------------------------------------------------------//
    // Global method - finish
    //----------------------------------------------------------------------------------------//
    global void finish(Database.BatchableContext BC){
        
    }
}