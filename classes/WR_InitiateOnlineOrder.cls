/*
	@author Shailendra Singh (Appirio Offshore)
	Purpose : Parse List of Salesorder that are in the form of String (comma seperated).
	Date Created : 09/09/2011

*/
public without sharing class WR_InitiateOnlineOrder {

	private Set<String> salesOrderSet;
	
	public List<WR_ORACLE_SalesOrder__c> salesOrders{get;set;}
	
	private String noneMatchedSalesOrdersStr; 
	
	public WR_InitiateOnlineOrder(String salesOrderNumStr,String oracleNum){
		salesOrderSet = new Set<String>();
		System.debug('Sales Orders ->'+salesOrderNumStr);
		for(String str : salesOrderNumStr.split(',')){
			if(str.trim() != '' && str.trim() != '\n')
				salesOrderSet.add(str.trim());	  
		} 
		salesOrders = [Select ID,Sales_Order__c,Purchase_Order__c,So_Created__c,Packing_Slip__c FROM WR_ORACLE_SalesOrder__c Where 
														Sales_Order__c IN :salesOrderSet  AND Oracle_Account_Number__c =:oracleNum 
														ORDER BY Purchase_Order__c ASC,Sales_Order__c ASC,Packing_Slip__c,So_Created__c DESC];
		System.debug('sales Orders'+salesOrders);
		if(salesOrderSet.size() > salesOrders.size()){
			noneMatchedSalesOrdersStr = '';
			for(WR_ORACLE_SalesOrder__c order : salesOrders){ // If sales order is existing than remove from salesorders set and put into Salesorder List
				if(salesOrderSet.contains(order.Sales_Order__c)){
					salesOrderSet.remove(order.Sales_Order__c);
				}	
			}	
			for(String str :salesOrderSet){
				noneMatchedSalesOrdersStr = ','+ str+noneMatchedSalesOrdersStr ;
			}
			noneMatchedSalesOrdersStr = noneMatchedSalesOrdersStr.replaceFirst(',','');			
		}
	}
	
	public String getNoneMatchedSalesOrdersString(){  
	    return noneMatchedSalesOrdersStr;
	}
}