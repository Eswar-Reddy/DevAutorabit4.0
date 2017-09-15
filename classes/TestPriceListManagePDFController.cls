/*
	Last Modified By :- Jitendra Appirio
    Purpose:- No changes done. deployed only for updating the last modified by on this class
*/
/* This test class for PriceListManagePDFController */

public with sharing class TestPriceListManagePDFController {
@isTest
    public static void testPriceListManagePDF1(){
        Price_List__c p = createPriceList();
        String dateString = Date.Today().day()+'~'+Date.Today().month()+'~'+Date.Today().year();
        Test.setCurrentPage(Page.PriceListManagePDFPage);
        ApexPages.currentPage().getParameters().put('ID',p.ID);
        ApexPages.currentPage().getParameters().put('date',dateString);
        ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(p);
        PriceListManagePDFController plManagePDFController = new PriceListManagePDFController(stdController);                           
    }

@isTest
    public static void testPriceListManagePDF2(){
        //Price_List__c p = createPriceList();
        Price_List__c p = new Price_List__c();
        //String dateString = Date.Today().day()+'~'+Date.Today().month()+'~'+Date.Today().year();
        //Test.setCurrentPage(Page.PriceListManagePDFPage);
        //ApexPages.currentPage().getParameters().put('ID',p.ID);
        //ApexPages.currentPage().getParameters().put('date',dateString);
        ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(p);
        PriceListManagePDFController plManagePDFController = new PriceListManagePDFController(stdController);                       
    }   
    private static Price_List__c createPriceList(){
        Price_List__c priceList = new Price_List__c();
        try{    
            priceList.Name = 'testpricelist';
            priceList.DSR_PO_Group_Email__c = 'test@test.com';      
            priceList.CurrencyIsoCode = 'USD';
            priceList.Oracle_Operating_Unit__c = 'SPEB OU';
            insert priceList;
        }catch(Exception e){
            for(Price_List__c p : [Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode From Price_List__c p where p.Oracle_Operating_Unit__c like 'SPEB OU' LIMIT 1])
                priceList = p;
        }
        System.debug('***************'+pricelist.ID+'***************');
        Map<String,ID> recTypes = new Map<String,ID>();
        List<Price_List_Item__c> lstSmartPackItems = new List<Price_List_Item__c> ();
        List<Price_List_Item__c> lstAlaCarteItems = new List<Price_List_Item__c> ();
        String recType = 'EU';
        for (RecordType rec : [Select id,name,developerName from RecordType where sObjectType='Price_List_Item__c']){
            recTypes.put(rec.developerName,rec.ID);          
        }
        
        for(integer i = 0;i < 5;i++){
            Item__c testItem = new Item__c();
            testItem.Name = 'OracleItemId'+i;
            testItem.CurrencyIsoCode = 'USD';
            testItem.Description__c = 'test description'+i;
            testItem.Long_Description__c = 'test long description'+i;
            testItem.Item_ID__c = 'test'+i;
            insert testItem;
            
            Price_List_Item__c p = new Price_List_Item__c();        
            p.Price_List__c = priceList.ID;
            //p.Description__c = 'TESTITEM'+i;  
            p.Effective_End_Date__c =Date.Today().addMonths(2);
            p.Effective_Start_Date__c = Date.Today().addMonths(-1);
            p.Name = 'For Testing Purpose';
            p.Item_ID__c = testItem.ID;
            //p.Oracle_Item_ID__c = '100' + i;
            p.Pricing_1__c = 100 + i;
            p.Pricing_2__c = 200 + i;
            p.Pricing_3__c = 300 + i;
            p.RecordTypeID = recTypes.get(recType);
            p.Quantity_1__c = 1 + i;
            p.Quantity_2__c = 5 + i;
            p.Type_1__c = 'Smart Pack';
            p.Type_2__c = 'In-Roof';
            p.Type_3_Criteria__c = 'SMA';           
            lstSmartPackItems.add(p);           
        }
        insert lstSmartPackItems;
        
        for(integer i = 0; i < 5; i++){
            Item__c testItem = new Item__c();
            testItem.Name = 'OracleItemId'+i;
            testItem.CurrencyIsoCode = 'USD';
            testItem.Description__c = 'test description'+i;
            testItem.Long_Description__c = 'test long description'+i;
            testItem.Item_ID__c = 'testing'+i;
            insert testItem;
            Price_List_Item__c p = new Price_List_Item__c();        
            p.Price_List__c = priceList.ID;
            p.Item_ID__c = testItem.ID;
            //p.Description__c = 'TESTITEMALACARTE'+i;  
            p.Effective_End_Date__c =Date.Today().addMonths(2);
            p.Effective_Start_Date__c = Date.Today().addMonths(-1);
            p.Name = 'For Testing Purpose ALACARTE';
            //p.Oracle_Item_ID__c = '200' + i;
            p.Pricing_1__c = 100 + i;           
            p.RecordTypeID = recTypes.get(recType);         
            p.Type_1__c = 'Ala Carte';                      
            lstAlaCarteItems.add(p);            
        }
        insert lstAlaCarteItems;
        
        return priceList;
    }

}