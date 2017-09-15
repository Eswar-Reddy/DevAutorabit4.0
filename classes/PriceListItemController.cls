/*
	Last Modified By :- Jitendra Appirio
    Purpose:- No changes done. deployed only for updating the last modified by on this class
*/
public class PriceListItemController {
	
	public Price_List_Item__c currentItem{get;set;}
	public PriceListItemController(ApexPages.standardController control){
		currentItem = (Price_List_Item__c)control.getRecord();
		currentItem = [Select Id,Name,Price_List__c,Price_List__r.Name from Price_List_Item__c where Id=:currentItem.ID limit 1];
	}
}