/*
* Wrapper class of WR_ORACLE_SalesOrder__c
* @Author Anjali Khandelwal (Appiro offshore)
*/
public with sharing class WR_SalesOrderWrapper {
	
	public Boolean isSelected{get;set;}
    public WR_ORACLE_SalesOrder__c salesOrder{get;set;}
    public String serialNum{get;set;}
    public String packingSlip{get;set;}
    public WR_SalesOrderWrapper(WR_ORACLE_SalesOrder__c salesOrder){
      this.salesOrder= salesOrder;
      this.isSelected = false;
    }
    
}