/*
	Last Modified By :- Jitendra Appirio
    Purpose:- No changes done. deployed only for updating the last modified by on this class
*/
/* Test Class for trigger BeforePriceListInsertUpdate */
public class TestBeforePriceListInsertUpdate {
@isTest
	public static void testBeforePriceListInsertUpdate(){
		//insert pricelist 1
		Price_List__c priceList1 = new Price_List__c();
		priceList1.CurrencyIsoCode = 'USD';
        priceList1.Oracle_Operating_Unit__c = 'SPEB OU';
        priceList1.Packaged_System_Item_ID__c = '104268';
        priceList1.Expedite_Fee__c = 100;
        priceList1.DSR_PO_Group_Email__c = 'test@test.com';
        try{
        	insert priceList1;
        }catch(Exception e){
        	System.debug('already exist : '+e.getMessage());
        	for(Price_List__c p : [Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode From Price_List__c p where p.Oracle_Operating_Unit__c like 'SPEB OU' LIMIT 1])
                priceList1 = p;
        }
        
        //insert pricelist 2
		Price_List__c priceList2 = new Price_List__c();
		priceList2.CurrencyIsoCode = 'USD';
        priceList2.Oracle_Operating_Unit__c = 'SPEB OU';
        priceList2.Packaged_System_Item_ID__c = '104268';
        priceList2.Expedite_Fee__c = 100;
        priceList2.DSR_PO_Group_Email__c = 'test@test.com';
        try{
        	insert priceList2;
        }catch(Exception e){
        	System.debug('already exist : '+e.getMessage());
        	for(Price_List__c p : [Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode From Price_List__c p where p.Oracle_Operating_Unit__c like 'SPEB OU' LIMIT 1])
                priceList2 = p;
        }
        
        //updating price list 1      
        priceList1.Shipping_Codes__c = 'other';
        try{
        	update priceList1;
        }catch(Exception e){
        	System.debug('cant update price list.'+e.getMessage());
        }
        
        //updating price list 2     
        priceList2.Shipping_Codes__c = 'test';
        priceList2.Oracle_Operating_Unit__c = 'SPCN OU';
        try{
        	update priceList2;
        }catch(Exception e){
        	System.debug('cant update price list.'+e.getMessage());
        }
        
	}
}