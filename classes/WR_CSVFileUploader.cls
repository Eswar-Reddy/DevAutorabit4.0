/*
    @author Shailendra Singh (Appirio Offshore)
    Purpose : Parsing csv file which contains serial numbers.

*/ 
public without sharing class WR_CSVFileUploader {

    public Set<String> serialNums{get;set;}
    
    public List<WR_FDS_Product__c> products{get;set;}
    
    private String noneMatchedserialNumStr;
    
    public Integer totalValidSN{get;set;}
    
    public Integer totalInvalidSN{get;set;}  
    
    public boolean isTotalSNExceeded{get;set;}//for Case# 00091077
    
    public WR_CSVFileUploader(Blob file,String oracleNum){ 
        String serialNumStr = file.toString();
        serialNums = new Set<String>();
        Integer i = 0;
        String serialNumVal;
        //Start for Case# 00091077
        isTotalSNExceeded = false;
        List<String> sNumList = serialNumStr.split('\n');
        if(sNumList.size() > 15000){
             isTotalSNExceeded = true;
             return;
        }
        System.debug('sNumList# ----- '+sNumList);
        //End for Case# 00091077
        for(String str : sNumList){
            i++;
            if(i == 1)
                continue; // First row has Header of Serial Number 
            if(str.trim() != '' && str.trim() != '\n'){
                serialNumVal =  str.trim().split(',')[0];// First column of Row.
                if(serialNumVal.startsWith('"') && serialNumVal.endsWith('"') )
                    serialNumVal = serialNumVal.replaceAll('"','');
                serialNums.add(serialNumVal); 
            }     
        } 
        noneMatchedserialNumStr = '';
        products = new List<WR_FDS_Product__c>();
        //cdevarapalli-----Query change to fetch also the Serial Numbers that are not associated with a Sales Order
        for(WR_FDS_Product__c product : [select w.Product_Name__c,w.WR_ORACLE_SalesOrder__c, w.Serial_Number__c, w.Product_Type__c, w.Packing_Slip__c,w.Alternate_Packing_Slip__c, w.Id, w.Converted_To_Asset__c,WR_ORACLE_SalesOrder__r.Purchase_Order__c From WR_FDS_Product__c w Where w.Serial_Number__c IN :serialNums  AND (w.WR_ORACLE_SalesOrder__r.Oracle_Account_Number__c =:oracleNum OR w.WR_ORACLE_SalesOrder__c=null) limit 10000]){
        //for(WR_FDS_Product__c product : [select w.Product_Name__c,w.WR_ORACLE_SalesOrder__c, w.Serial_Number__c, w.Product_Type__c, w.Packing_Slip__c,w.Alternate_Packing_Slip__c, w.Id, w.Converted_To_Asset__c,WR_ORACLE_SalesOrder__r.Purchase_Order__c From WR_FDS_Product__c w Where w.Serial_Number__c IN :serialNums /*AND w.WR_ORACLE_SalesOrder__r.Oracle_Account_Number__c =:oracleNum*/ limit 10000]){
            products.add(product);
            if(serialNums.contains(product.Serial_Number__c)){
                serialNums.remove(product.Serial_Number__c);
            }   
        }  
        for(String str :serialNums){
            noneMatchedserialNumStr = ', '+ str+noneMatchedserialNumStr ;
            
        }
        noneMatchedserialNumStr = noneMatchedserialNumStr.replaceFirst(',','');   
        totalValidSN = products.size();
        totalInvalidSN = serialNums.size();
    }
     
    public String getNoneMatchedSerialNumstring(){  
            return noneMatchedserialNumStr;
    }
}