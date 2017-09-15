public class AlaCarteController extends ComponentControllerBase{
    
    public void setJSON(){
        selProductItemsJSON = JSON.serialize(selProductItems);
    }
    
    
    //select options, etc.
    public User currentUser {get;set;}
    public final static string NONESELECT = '--None--';
    public Integer PAGINATION_COUNTER {get;set;}
    public List<Price_List_Item__c> products {get;set;}
    public String changedQty {get;set;}  
    public String hdnDelProdLineId {get;set;}
    public boolean showQuantityMessage {get;set;}
    public boolean showErrorBlock {get;set;}
    public String prodDescFilter {get;set;}
    //quantity of a line items
    public String inputQuantity {get;set;}
    //For Product Items Wrapper,which show in Page
    public List<PriceItemWrapper> selProductItems {get;set;}
    public String selProductItemsJSON {get;set;}

    //Ship to state - used for state specific item selection
    public String shippingState {get;set;}     
    
    //Quantity validations
    Map<Id,List<Order_Discount__c>> orderDiscountMap = new Map<Id,List<Order_Discount__c>>();
    
    //counter variable
    public ApexPages.StandardSetController setCon{get;set;}
    
    public Date currentDate = Date.today();
    public String opunit {get;set;}
    public String qry = 'Select p.Disc_Item_ID__c, p.Disc_Item_Description__c, p.Disc_Item_ID__r.Name, p.CurrencyIsoCode, p.Type_2__c, p.Type_1__c, p.Quantity_2__c, ' +
        'p.Quantity_1__c, p.Pricing_2__c,p.Pricing_3__c, p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, ' +
        'p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Item_Id__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c ' +
        'From Price_List_Item__c p where p.category__c != null ' +
        'and (p.Price_List__r.Oracle_Operating_Unit__c =: opunit OR (p.Price_List__r.State__C != null AND p.Price_List__r.State__c =: shippingState)) ' +
        'and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate ' +
        'and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\' ';
    public Map<String, List<Price_List_Item__c>> categoryItemsListMap = new Map<String, List<Price_List_Item__c>>();
    
    public string selectedCategoryKey {get;set;}

    public AlacarteController() {
        
        currentUser = [Select Id, Name, Profile.Name, Contact.Account.Oracle_Operating_Unit__c, Contact.Account.BillingCountry,
                       Contact.Account.Online_Order_Access__c, CurrencyISOCode, Contact.Account.Theater__c
                       From User Where Id =: UserInfo.getUserId()];
        
        opunit = currentUser.Contact.Account.Oracle_Operating_Unit__c;
        
        List<Price_List_Item__c> temp = Database.query(qry);
        for(Price_List_Item__c pli : temp) {
            if(categoryItemsListMap.containsKey(pli.Category__c)) {
                categoryItemsListMap.get(pli.Category__c).add(pli);
            }
            else {
                categoryItemsListMap.put(pli.Category__c, new List<Price_List_Item__c>());
                categoryItemsListMap.get(pli.Category__c).add(pli);
            }
        }
        showQuantityMessage = false;
        showErrorBlock = false;
        
        //defaulting selected category to All.
        selectedCategoryKey = 'All';
        updateProductLineItemList();
        List<Order_Discount__c> dealerTierDiscounts = new List<Order_Discount__c>([SELECT Minimum_Quantity__c, Maximum_Quantity__c, Oracle_Item_ID__c, Effective_Date__c, 
                                                                                            Discontinue_Date__c, Bundle_Quantity__c
                                                                                    FROM Order_Discount__c 
                                                                                    WHERE Effective_Date__c <= TODAY 
                                                                                    AND (Discontinue_Date__c > TODAY OR Discontinue_Date__c = NULL) 
                                                                                    AND Theatre__c =: currentUser.Contact.Account.Theater__c 
                                                                                    AND Country__c INCLUDES(: currentUser.Contact.Account.BillingCountry)]);   
        
        for(Order_Discount__c od : dealerTierDiscounts){
            if(!orderDiscountMap.containskey(od.Oracle_Item_Id__c))
                orderDiscountMap.put(od.Oracle_Item_Id__c,new List<Order_Discount__c>());
            
            orderDiscountMap.get(od.Oracle_Item_Id__c).add(od);
        }
        getProductsList();        
    }
    
    
    public List<SelectOption> getCategoryKeys() {
        List<SelectOption> options = new List<SelectOption>();
        for(String s : categoryItemsListMap.keySet()) {
            options.add(new SelectOption(s,s));
        }
        options.add(new SelectOption('All','All'));
        return options;
    }
    
    /** This getter function is to get the records from standard set controller 
    *  and set them to list of price list items.
    *  @return  List<Price_List_Item__c>
    */
    public void getProductsList() {
        if(setCon == null){ 
            initilizeSetCon();  
        }
        if(setCon != null) {
            if(setCon.getResultSize() != 0){
                
                products = (List<Price_List_Item__c>) setCon.getRecords();
            }
            else
                products = new List<Price_List_Item__c>();
        }
    }
    
    /** This function initializes standard set controller of price list items.
    *  
    */
    private void initilizeSetCon(){
        PAGINATION_COUNTER= Integer.valueof(System.Label.PAGE_DISPLAY_SIZE);
        
        List<Price_List_Item__c> items = new List<Price_List_Item__c>();
        if(setCon == null){                                   
            for(Price_List_Item__c pli : [Select p.Item_Description__c,p.Disc_Item_ID__r.Name, p.Type_2__c, p.Name,
                                                 p.Item_ID__c, p.Item_ID__r.Item_Id__c, p.Item_ID__r.Name,p.Category__c 
                                          From Price_List_Item__c p 
                                          WHERE (p.Price_List__r.Oracle_Operating_Unit__c =: opunit 
                                                OR (p.Price_List__r.State__c =: shippingState 
                                                AND p.Price_List__r.State__c != null))
                                          AND p.category__c = :selectedCategoryKey  
                                          AND p.Effective_Start_Date__c <=:currentDate 
                                          AND p.Effective_End_Date__c >=:currentDate 
                                          AND p.Is_Active__c = 'true' 
                                          AND p.Type_1__c ='Ala Carte'
                                          ORDER BY p.Item_Description__c]) {
                items.add(pli);
            }
            setCon = new ApexPages.StandardSetController(items);
            setCon.setPageSize(PAGINATION_COUNTER);
            
        }else if(setCon != null && setCon.getResultSize() != 0){      
            setCon.setPageSize(PAGINATION_COUNTER);
            products = (List<Price_List_Item__c>) setCon.getRecords();
        }else{
            products = new List<Price_List_Item__c>();
        }
    }
    
    
    
    /** This function is responsible to filter the price list items according to selected Category.
    *  @return  PageReference
    */
    public PageReference updateProductLineItemList(){       
        if(selectedCategoryKey != null){
            PAGINATION_COUNTER=Integer.valueof(System.Label.PAGE_DISPLAY_SIZE);
            List<Price_List_Item__c> items = new List<Price_List_Item__c>();

            if(selectedCategoryKey != 'All')
            for(Price_List_Item__c pli : [Select p.Item_Description__c,p.Disc_Item_ID__r.Name, p.Type_2__c, p.Name,
                                                 p.Item_ID__c, p.Item_ID__r.Item_Id__c, p.Item_ID__r.Name,p.Category__c 
                                          From Price_List_Item__c p 
                                          WHERE (p.Price_List__r.Oracle_Operating_Unit__c =: opunit 
                                                OR (p.Price_List__r.State__c =: shippingState 
                                                AND p.Price_List__r.State__c != null))
                                          AND p.category__c = :selectedCategoryKey  
                                          AND p.Effective_Start_Date__c <=:currentDate 
                                          AND p.Effective_End_Date__c >=:currentDate 
                                          AND p.Is_Active__c = 'true' 
                                          AND p.Type_1__c ='Ala Carte'
                                          ORDER BY p.Item_Description__c]) {
                items.add(pli);
            }
            else{
            
                for(Price_List_Item__c pli : [Select p.Item_Description__c,p.Disc_Item_ID__r.Name, p.Type_2__c, p.Name,
                                                 p.Item_ID__c, p.Item_ID__r.Item_Id__c, p.Item_ID__r.Name,p.Category__c 
                                          From Price_List_Item__c p 
                                          WHERE (p.Price_List__r.Oracle_Operating_Unit__c =: opunit 
                                                OR (p.Price_List__r.State__c =: shippingState 
                                                AND p.Price_List__r.State__c != null)) 
                                          AND p.Effective_Start_Date__c <=:currentDate 
                                          AND p.Effective_End_Date__c >=:currentDate 
                                          AND p.Is_Active__c = 'true' 
                                          AND p.Type_1__c ='Ala Carte'
                                          ORDER BY p.Item_Description__c]) {
                    items.add(pli);
                }
            
            
            }
            setCon = new ApexPages.StandardSetController(items);
            
            if(setCon != null){
                if(setCon.getResultSize() != 0){
                    setCon.setPageSize(PAGINATION_COUNTER);
                    products = (List<Price_List_Item__c>) setCon.getRecords();
                }
            }
        }else{          
            initilizeSetCon();
        }
        return null; 
    }
    
    
    /*Section For Products List starts Here */
    public String singleAddedprodId{get;set;}
    
    
    /** This function takes the list of price lite items .
    *  @return  PageReference
    */
    public void addItemToList(){

        changedQty='';
        inputQuantity='1';
        if(singleAddedprodId == null || singleAddedprodId=='' )
            return ;
           
        for(Price_List_Item__c prod:products){
            try{
                if(prod.ID == singleAddedprodId){
                    addProductItemToList(prod); 
                }
            }catch(Exception e){
                
            }
        }
    }
    
    
    /** This function adds a price list item to the list of selected price list items.
    *  @param  Price_List_Item__c
    */
    private void addProductItemToList(Price_List_Item__c prod){        
        if (prod ==null) return;
        PriceItemWrapper productWrapper = new PriceItemWrapper();
        //Removing Below condition for Case-00872916, Now EU and NA should see Product Name only not description for ALA CARTE and Selected Item List
       /* if(currentUser.Contact.Account.Theater__c != 'Europe')
            productWrapper = new PriceItemWrapper(prod.ID, prod.Item_Description__c, prod.Type_2__c, String.valueof(inputQuantity));  
        else*/ 
            productWrapper = new PriceItemWrapper(prod.ID, prod.Name, prod.Type_2__c, String.valueof(inputQuantity));                              
        productWrapper.oracleItemIDRef = prod.Item_ID__c;  
        productWrapper.itemID = prod.Item_ID__r.Item_ID__c;      
        
        if(selProductItems != null && selProductItems.size()>0){
            boolean isAdded =false;
            for(PriceItemWrapper prodWrapper :selProductItems){
                if(prodWrapper.ID == prod.ID){                      
                    isAdded =true;
                    break;
                }  
            }
            if(!isAdded){
                selProductItems.add(0,productWrapper);                              
            }
            
        }else{                  
            if(selProductItems == null) {            
                selProductItems = new List<PriceItemWrapper>();               
            }                                        
            if(selProductItems.size() == 0){
                selProductItems.add(productWrapper);          
            }else{
                selProductItems.add(0,productWrapper);                   
            }
        }
        Boolean showQtyMessage = checkChangedQuantity(productWrapper, '1');
    }
    
    /** This function is to synchronize the quantity values of price list items.
    * 
    */
    
    @TestVisible
    private Boolean checkChangedQuantity(AlaCarteController.PriceItemWrapper wrapper, String newVal) {
        wrapper.error = null;
        if(!orderDiscountMap.containsKey(wrapper.oracleItemIDRef))
            return true;
        for(Order_Discount__c od : orderDiscountMap.get(wrapper.oracleItemIDRef)){
            if(Double.valueOf(newVal) >= od.Minimum_Quantity__c && Double.valueOf(newVal) <= od.Maximum_Quantity__c){
                wrapper.bundleSize = od.Bundle_Quantity__c;

                if(wrapper.bundleSize == null || (Math.mod(Integer.valueOf(newVal),wrapper.bundleSize.intValue()) == 0)){
                    return true;
                }
                else{
                    wrapper.error = '(' + wrapper.bundleSize.intValue() + ')';
                    return false;
                }
            }
        }
        return wrapper.error == null;
    }
    
    /** This function deletes a price list item from the list of PriceItemWrapper.
    *  
    */
    public PageReference delItemFromList() {
        changedQty='';
        if(hdnDelProdLineId == null || hdnDelProdLineId =='')
            return null;
        //Delete Item Product Wrap Here
        deleteFromProductWrapperList(hdnDelProdLineId);

        return null;    
    }
    
    /** This function deletes a price list item from the list of PriceItemWrapper.
    *  @param id 
    */
    private void deleteFromProductWrapperList(String id){
        
        if(selProductItems == null || selProductItems.size()==0) return;
        List<PriceItemWrapper> tempProdList = new List<PriceItemWrapper>();  
        
        for(PriceItemWrapper wrapProd:selProductItems){
            
            if(wrapProd.ID != id ){
                tempProdList.add(wrapProd);                          
            }
        }
        selProductItems.clear();      
        
        selProductItems.addAll(tempProdList);
    }
    
    public PageReference updateQuantity() {

        for(AlaCarteController.PriceItemWrapper prodWrapper :selProductItems){

            if(prodWrapper.ID == singleAddedprodId){
                if(checkChangedQuantity(prodWrapper, changedQty)) {
                    prodWrapper.Qty = changedQty ;
                    break;
                }
            }           
        }
        return null;
    }
    
    public void getQunatityMessage(){
        if(showQuantityMessage){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.POQuantityErrorMessage);
            ApexPages.addMessage(errorMsg);
            showErrorBlock = true;
        }
        else{
            showErrorBlock = false;
        }
    }
    
    /** This function is responsible to filter the price list items according to type.
    *  @return  PageReference
    */
    public PageReference moveAccordingToFilter(){       
        if(selectedCategoryKey != null){
            PAGINATION_COUNTER=Integer.valueof(System.Label.PAGE_DISPLAY_SIZE);
            setCon = getPriceListFilterByDesc(selectedCategoryKey,prodDescFilter);
            if(setCon != null){
                if(setCon.getResultSize() != 0){
                    setCon.setPageSize(PAGINATION_COUNTER);
                    products = (List<Price_List_Item__c>) setCon.getRecords();
                }
            }
        }else{          
            initilizeSetCon();
        }
        return null; 
    }
    
    /** This function fetches price list items of selected category for selected dealer account. 
    *  @return ApexPages.Standardsetcontroller
    */
    private ApexPages.Standardsetcontroller getPriceListFilterByDesc(String selectedCategory,String productDescFilter)
    {
        
        List<Price_List_Item__c> priceList = null; 
        String prodFilter='';
        if(productDescFilter != null && productDescFilter !=''){
            String reg = '^[0-9]{6}$';
            Pattern pat = Pattern.compile(reg);  
            Matcher pm = pat.matcher(productDescFilter);
            if(pm.find())          
                prodFilter = ' and p.Item_ID__r.Item_Id__c like \'%' + productDescFilter + '%\'';
            else
                prodFilter = ' and p.Item_ID__r.Description__c like \'%' + productDescFilter + '%\'';
        }  
        

        Date currentDate = Date.today();
        String qry = null;                      
        
        if(selectedCategory != 'All' && selectedCategory != null && selectedCategory != System.Label.POWizardNonePicklistValue){
            selectedCategory = selectedCategory.trim();
            qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Price_List__r.Oracle_Operating_Unit__c, p.Item_ID__c, p.Item_ID__r.Item_Id__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where (p.Price_List__r.Oracle_Operating_Unit__c =: opunit OR (p.Price_List__r.State__C != null AND p.Price_List__r.State__c =: shippingState)) and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\' and p.Category__c = \''+selectedCategory +'\'' + prodFilter;
        }
        else{
            qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Price_List__r.Oracle_Operating_Unit__c, p.Item_ID__c, p.Item_ID__r.Item_Id__c, p.Item_ID__r.Name,p.Item_ID__r.Item_Displayable_Description__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where (p.Price_List__r.Oracle_Operating_Unit__c =: opunit OR (p.Price_List__r.State__C != null AND p.Price_List__r.State__c =: shippingState)) and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\'' + prodFilter ;
        }
        qry += ' order by p.Item_Description__c';
        ApexPages.Standardsetcontroller fliterSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));        
        return fliterSetCon ;      
    }   
    
    /**
    * Begin of PAGINATION METHODS
    *
    */
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
    
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
    // returns the first page of records
    public void first() {
        setCon.first();
        products = (List<Price_List_Item__c>) setCon.getRecords();
    }
    
    // returns the last page of records
    public void last() {
        setCon.last();
        products = (List<Price_List_Item__c>) setCon.getRecords();
    }
    
    // returns the previous page of records
    public void previous() {
        setCon.previous();
        products = (List<Price_List_Item__c>) setCon.getRecords();
    }
    
    // returns the next page of records
    public void next() {
        setCon.next();
        products = (List<Price_List_Item__c>) setCon.getRecords();
    }
    
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        setCon.cancel();
    }
    
    
    
    /** Inner class PriceItemWrapper.
    *  
    */
    public class PriceItemWrapper {
        public String ID {get;set;}
        public String Name {get;set;}
        public String prodType {get;set;}
        public String Qty {
            get{
                if(Qty!=null && Qty!=''){
                    Integer result =Qty.indexOf('.');
                    if(result != -1){
                        Qty= Qty.substring(0,result);
                    }
                }
                return Qty;
            }
            set;
        }
        public String itemID {get;set;}
        public ID oracleItemIDRef {get;set;}
        public Boolean isExisting {get;set;}
        public String error {get;set;}
        public Decimal bundleSize {get;set;}
        public Purchase_Order_Line__c pOrderLine {get;set;}
        public PriceItemWrapper() {
            pOrderLine = new Purchase_Order_Line__c();
            isExisting =false;
        }
        // new constructor having Qty and prodType.
        public PriceItemWrapper(String ID, String Name, String prodType, String Qty){                     
            this.pOrderLine = new Purchase_Order_Line__c();
            isExisting = false;
            this.ID = ID;   
            this.Name=Name;
            this.prodType = prodType;
            this.Qty = Qty;
        }
    }

}