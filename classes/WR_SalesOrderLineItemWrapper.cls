/*
* Wrapper class of WR_FDS_Product__c
* @Author Anjali Khandelwal (Appiro offshore)
*/
public with sharing class WR_SalesOrderLineItemWrapper {
    
    public Boolean isSelected{get;set;}
    public Boolean isInSelectedList{get;set;}
    public WR_FDS_Product__c salesOrderProduct{get;set;}
    public String warrantyID{get;set;}
    public Id WR_Line_item_ID{get;set;}
    public Boolean isDrafted{get;set;}
    public String customerName{get;set;}
    public WR_SalesOrderLineItemWrapper(WR_FDS_Product__c salesOrderProduct){
      this.salesOrderProduct= salesOrderProduct;
      this.isSelected = true;
      this.isInSelectedList = true;
      this.isDrafted= false;
    }
}