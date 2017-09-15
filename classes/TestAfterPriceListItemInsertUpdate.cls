/*
	Last Modified By :- Jitendra Appirio
    Purpose:- No changes done. deployed only for updating the last modified by on this class
*/
/* Test class for apex trigger AfterPriceListItemInsertUpdate*/
public class TestAfterPriceListItemInsertUpdate {
@isTest
	public static void testAfterPriceListItemInsertUpdate(){
		//insert pricelist 
		Price_List__c priceList = new Price_List__c();
		priceList.CurrencyIsoCode = 'USD';
        priceList.Oracle_Operating_Unit__c = 'SPEB OU';
        priceList.Packaged_System_Item_ID__c = '104268';
        priceList.Expedite_Fee__c = 100;
        priceList.DSR_PO_Group_Email__c = 'test@test.com';
        try{
        	insert priceList;
        }catch(Exception e){
        	System.debug('already exist : '+e.getMessage());
        	for(Price_List__c p : [Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode From Price_List__c p where p.Oracle_Operating_Unit__c like 'SPEB OU' LIMIT 1])
                priceList = p;
        }
        //insert oracle items
        List<Item__c> lstItems = createOracleItems();
        List<Price_List_Item__c> lstPricelistItems = new List<Price_List_Item__c>();
        // record type map
        Map<String,ID> recTypes = new Map<String,ID>();     
        for (RecordType rec : [Select id,name,developerName from RecordType where sObjectType='Price_List_Item__c']){
            recTypes.put(rec.developerName,rec.ID);        
        }
        //insert price list item
        for(integer i=0;i<2;i++){
	        Price_List_Item__c plItem1 = new Price_List_Item__c();
	        plItem1.Price_List__c = priceList.ID;
	        plItem1.Category__c = 'BoS';
	        plItem1.Item_ID__c = lstItems[0].ID;
	        plItem1.Effective_End_Date__c =Date.Today().addMonths(2);
	        plItem1.Effective_Start_Date__c = Date.Today().addMonths(-1);
	        plItem1.CurrencyIsoCode = 'USD';
	        plItem1.Pricing_1__c = 100 ;
	        plItem1.Pricing_2__c = 200 ;
	        plItem1.Pricing_3__c = 300 ;
	        plItem1.RecordTypeID = recTypes.get('EU');
	        plItem1.Quantity_1__c = 1 ;
	        plItem1.Quantity_2__c = 5 ;
	        plItem1.Type_1__c = 'Ala Carte';
	        lstPricelistItems.add(plItem1);
        }
        if(lstPricelistItems.size()>0){
	        try{
	        	insert lstPricelistItems;
	        }catch(Exception e){
	        	System.debug('duplicate item : '+e.getMessage());
	        }	
		}
		
		lstPricelistItems.clear();
		//inserting price list items with effective start date greater than end date
		for(integer i=0;i<2;i++){
	        Price_List_Item__c plItem1 = new Price_List_Item__c();
	        plItem1.Price_List__c = priceList.ID;
	        plItem1.Category__c = 'BoS';
	        plItem1.Item_ID__c = lstItems[0].ID;
	        plItem1.Effective_End_Date__c =Date.Today().addMonths(1);
	        plItem1.Effective_Start_Date__c = Date.Today().addMonths(2);
	        plItem1.CurrencyIsoCode = 'USD';
	        plItem1.Pricing_1__c = 100+i ;
	        plItem1.Pricing_2__c = 200+i ;
	        plItem1.Pricing_3__c = 300 ;
	        plItem1.RecordTypeID = recTypes.get('EU');
	        plItem1.Quantity_1__c = 1 ;
	        plItem1.Quantity_2__c = 5 ;
	        plItem1.Type_1__c = 'Ala Carte';
	        lstPricelistItems.add(plItem1);
        }
        if(lstPricelistItems != null && lstPricelistItems.size()>0){
	        try{
	        	insert lstPricelistItems;
	        }catch(Exception e){
	        	System.debug('Effective End Date can not be before Effective Start Date. : '+e.getMessage());
	        }	
		}
		
		lstPricelistItems.clear();
		//inserting price list items 		
	    Price_List_Item__c plItem1 = new Price_List_Item__c();
        plItem1.Price_List__c = priceList.ID;
        plItem1.Category__c = 'BoS';
        plItem1.Item_ID__c = lstItems[0].ID;
        plItem1.Effective_End_Date__c =Date.Today().addMonths(1);
        plItem1.Effective_Start_Date__c = Date.Today().addMonths(-2);
        plItem1.CurrencyIsoCode = 'USD';
        plItem1.Pricing_1__c = 100 ;
        plItem1.Pricing_2__c = 200;
        plItem1.Pricing_3__c = 300 ;
        plItem1.RecordTypeID = recTypes.get('EU');
        plItem1.Quantity_1__c = 1 ;
        plItem1.Quantity_2__c = 5 ;
        plItem1.Type_1__c = 'Ala Carte';	
        insert  plItem1;  
        
        //trying to insert duplicate price list item
        Price_List_Item__c plItem2 = new Price_List_Item__c();
        plItem2.Price_List__c = priceList.ID;
        plItem2.Category__c = 'BoS';
        plItem2.Item_ID__c = lstItems[0].ID;
        plItem2.Effective_End_Date__c =Date.Today().addMonths(1);
        plItem2.Effective_Start_Date__c = Date.Today().addMonths(2);
        plItem2.CurrencyIsoCode = 'USD';
        plItem2.Pricing_1__c = 100 ;
        plItem2.Pricing_2__c = 200;
        plItem2.Pricing_3__c = 300 ;
        plItem2.RecordTypeID = recTypes.get('EU');
        plItem2.Quantity_1__c = 1 ;
        plItem2.Quantity_2__c = 5 ;
        plItem2.Type_1__c = 'Ala Carte';	
        try{
        	insert  plItem2; 
        }catch(Exception e){
        	System.debug('cant insert : '+e.getMessage());
        }	 
	}
	
	private static List<Item__c> createOracleItems(){
    	List<Item__c> lstItems = new List<Item__c>();
    	for(integer i=0;i<5;i++){
            Item__c testItem = new Item__c();
            testItem.Name = 'OracleItemId'+i;
            testItem.CurrencyIsoCode = 'USD';
            testItem.Description__c = 'test description'+i;
            testItem.Long_Description__c = 'test long description'+i;
            testItem.Item_ID__c = 'testdesignitem'+i;
            testItem.active__c = true;
            lstItems.add(testItem);           
    	}  
    	if(lstItems.size()>0)
            insert lstItems; 
       return lstItems ;   
    }
}