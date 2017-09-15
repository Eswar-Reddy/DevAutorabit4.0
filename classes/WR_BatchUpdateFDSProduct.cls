/**************************************************************************************************************************
    Class is batch class used for populating "Item__c" field of 
    WR_FDS_Product__c according to match of PVM, prefix with Product_Name__c field of WR_FDS_Product__c with description
    field of Item object. (For existing records)
    
    @Author Anjali Khandelwal (Appiro offshore)
***************************************************************************************************************************/
global with sharing class WR_BatchUpdateFDSProduct implements Database.Batchable<SObject>,Database.Stateful{
    
    //----------------------------------------------------------------------------------------//
    // static variables
    //----------------------------------------------------------------------------------------//
    
    static final String MATCH_NOT_FOUND = 'Match Not Found';
    static final String DUPLICATE_MATCH = 'Duplicate Match Found';
    static final String PVM_PREFIX = 'PVM, ';
    public static List<String> fdsProductToUpdateForTest = new List<String>();
     
    //----------------------------------------------------------------------------------------//
    // Global method - start
    //----------------------------------------------------------------------------------------//
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,Item__c,Product_Name__c FROM WR_FDS_Product__c WHERE Item__c = null and Product_Name__c != null';
        
        if(Test.isRunningTest() && fdsProductToUpdateForTest!=null){
            query += ' AND id in: fdsProductToUpdateForTest';
        }
        return Database.getQueryLocator(query); 
    }
    
    //----------------------------------------------------------------------------------------//
    // Global method - execute 
    //----------------------------------------------------------------------------------------//
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Map<String, WR_FDS_Product__c> fdsProductMap = new Map<String, WR_FDS_Product__c>();
        // To hold FDS Product which needs to be update 
        List<WR_FDS_Product__c> listFDSProduct = new List<WR_FDS_Product__c>();
        Set<String> productNameSet = new Set<String>();
        Set<String> PVM_PrefixPdctName = new Set<String>();
        // Iterate scope to update field
        for(SObject sObj : scope){ 
            WR_FDS_Product__c product = (WR_FDS_Product__c)sObj;
            if(product.Product_Name__c != null)
                productNameSet.add(product.Product_Name__c);
        }
        
        for(String product : productNameSet){
            PVM_PrefixPdctName.add(PVM_PREFIX+product);
            //productIdAndDescriptionMap.put(product.Id,'PVM, '+product.Product_Name__c);
        }
        
        Map<String,Set<Id>> itemDescMap = new Map<String,Set<Id>>();   
        for(Item__c item : [Select Id, Description__c from Item__c where Description__c in: PVM_PrefixPdctName]){
        if(item.Description__c != null)
            if(itemDescMap.get(item.Description__c) == null)
                itemDescMap.put(item.Description__c,new Set<ID>());
            itemDescMap.get(item.Description__c).add(item.Id);
        }
      
        // Iterate scope to update field
        for(SObject sObj : scope){
            WR_FDS_Product__c product = (WR_FDS_Product__c)sObj;
            if(itemDescMap.get(PVM_PREFIX+product.Product_Name__c) == null){
                product.Exception_on_ItemID_Populate__c = MATCH_NOT_FOUND;
                listFDSProduct.add(product);
            }else if(itemDescMap.get(PVM_PREFIX+product.Product_Name__c).size() ==1 ){
                for(ID idITem:itemDescMap.get(PVM_PREFIX+product.Product_Name__c)){
                    product.Item__c = idItem;
                    listFDSProduct.add(product);
                }
            }else if(itemDescMap.get(PVM_PREFIX+product.Product_Name__c).size() > 1 ){
                product.Exception_on_ItemID_Populate__c = DUPLICATE_MATCH; 
                listFDSProduct.add(product);
            }
        }
        
        // Update FDS Product
        if(listFDSProduct.size() > 0){
            update listFDSProduct;
        }
    }
    
    //----------------------------------------------------------------------------------------//
    // Global method - finish
    //----------------------------------------------------------------------------------------//
    global void finish(Database.BatchableContext BC){
        
    }
}