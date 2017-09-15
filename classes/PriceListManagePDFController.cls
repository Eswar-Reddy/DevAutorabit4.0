/*............................................................
Class             ::    PriceListManagePDFController
Requester         ::    Robert Smith
PR                ::    PR-02829
Appirio Offshore  ::    Appirio Offshore (Prakash Gyamlani)
Last Modified By :- Jitendra Appirio
Purpose:- No changes done. deployed only for updating the last modified by on this class 
..............................................................*/
public class PriceListManagePDFController {
    //PriceList ID
    private String priceListID{get;set;}
    //Price List Object
    public Price_List__c priceList{get;set;}
    //Variable for Date Filter only
    public Price_List_Item__c objectForDate{get;set;}
    //Ala-carta Item Lists
    public List<Price_List_Item__c> alaCartaList{get;set;}
    //smartpack list items
    public List<Price_List_Item__c> smartPackItems{get;set;}
    //Check is Error Occur
    public boolean isErrorOccur{get;set;}
    //RecordTypeName as Public
    public String recType{get;set;}
    //This variable use for date Separating for e.g. day~month~year
    //date parameter is sent from PriceListManagePage in above format
    private String dateSeparator = '~';
        
    /** Constructor PriceListManagePDFController.
     *  @param ApexPages.standardController
     */  
    public  PriceListManagePDFController(ApexPages.StandardController ctrl){    
        String dateString = ApexPages.currentPage().getParameters().get('date');
        Date dateParam;    
        if(dateString != null){         
            dateParam = date.newInstance(Integer.valueOf(dateString.split(dateSeparator)[2]), Integer.valueOf(dateString.split(dateSeparator)[1]), Integer.valueOf(dateString.split(dateSeparator)[0]));
        }
        objectForDate = new Price_List_Item__c();
        objectForDate.Effective_Start_Date__c = dateParam;
        //filterDate = Date.Today();
        priceList = (Price_List__c)ctrl.getRecord();
        if(priceList == null || priceList.Id == null){
            if(ApexPages.currentPage().getParameters().get('ID') != null){
                priceListID =   ApexPages.currentPage().getParameters().get('ID');
            }
        }else{
            priceListID = priceList.Id;
        }
        //If Invalid request
        if(priceListID == null) return;
        alaCartaList = new  List<Price_List_Item__c>();
        smartPackItems = new List<Price_List_Item__c>();
        setPriceList(objectForDate.Effective_Start_Date__c);
    }
    
   /** Function to set the pricelist object.
    *  @param filterDate
    */
    private void setPriceList(Date filterDate){
        //else proceeding forward
        priceList = new Price_List__c();        
        for(Price_List__c p:[Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordType.DeveloperName, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.LastModifiedDate, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode, (Select Id, Name, RecordTypeId, RecordType.Name,Price_List__c, Item_Description__c, Effective_End_Date__c, Effective_Start_Date__c,  Pricing_1__c, Pricing_2__c, Quantity_1__c, Quantity_2__c, Type_1__c, Type_2__c, Pricing_3__c, Product_Unique_ID__c, Currency_Code__c, Type_3_Criteria__c,Item_ID__c,Item_ID__r.Name From Price_List_Items__r where Effective_Start_Date__c <= :filterDate and Effective_End_Date__c >=  :filterDate and Is_Active__c = 'true') From Price_List__c p where id =:priceListID Limit 1]){
            priceList = p;
            recType =p.RecordType.DeveloperName;
            if(p.Price_List_Items__r != null && p.Price_List_Items__r.size() > 0)
                setPriceListItems(p.Price_List_Items__r);                           
        }
    } 
    
   /** Function to set the PriceListItems .
    *  @param filterDate
    */
    private void setPriceListItems(List<Price_List_Item__c> pList){
        alaCartaList.clear();
        smartPackItems.clear();     
        for(Price_List_Item__c pLItem: pList){
            if(pLItem.Type_1__c != null && pLItem.Type_1__c =='Ala Carte'){
                alaCartaList.add(pLItem);
            }else if(pLItem.Type_1__c != null &&  pLItem.Type_1__c =='Smart Pack'){
                smartPackItems.add(pLItem);
            }//else if ends         
        }//for ends for(Price_List_Item__c pLI
    }//function ends
    
   /** Function to fetch PriceListItems as per date.
    */
    /*public void filterItemsByDate(){
        Date filterDate = objectForDate.Effective_Start_Date__c;
        //Note:: -(For test code coverage for this) PriceList object must be exist before calling this function.
        setPriceListItems([Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordType.DeveloperName, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.LastModifiedDate, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode, (Select Id, Name, RecordTypeId, RecordType.Name,Price_List__c, Item_Description__c, Effective_End_Date__c, Effective_Start_Date__c, Pricing_1__c, Pricing_2__c, Quantity_1__c, Quantity_2__c, Type_1__c, Type_2__c, Pricing_3__c, Product_Unique_ID__c, Currency_Code__c, Type_3_Criteria__c,Item_ID__c,Item_ID__r.Name From Price_List_Items__r where Effective_Start_Date__c <= :filterDate and Effective_End_Date__c >=  :filterDate and Is_Active__c = 'true') From Price_List__c p where id =:priceListID Limit 1][0].Price_List_Items__r);
        return;
    }*/
}//class ends