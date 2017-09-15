/* This test class for PriceListManageController */

public class TestPriceListManageController {

@isTest
    public static void testPriceListManage1(){  
        Price_List__c p = createPriceList();
        Test.setCurrentPage(Page.PriceListManagePage);
        ApexPages.currentPage().getParameters().put('ID',p.ID);
        ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(p);
        PriceListManageController plManageController = new PriceListManageController(stdController);            
        plManageController.filterItemsByDate();
    }

@isTest
    public static void testPriceListManage2(){  
        //Price_List__c p = createPriceList();
        Price_List__c p = new Price_List__c();
        Test.setCurrentPage(Page.PriceListManagePage);
        ApexPages.currentPage().getParameters().put('ID',p.ID);
        ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(p);
        PriceListManageController plManageController = new PriceListManageController(stdController);            
        //plManageController.filterItemsByDate();
    }   
    
@isTest
    public static void testPriceListItemController(){          
        Price_List__c p = createPriceList();  
        Price_List_Item__c pI = new Price_List_Item__c(price_list__c=p.ID);      
        insert pI;
        ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(pI);
        PriceListItemController plItem = new PriceListItemController(stdController);                    
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