public without sharing class LeaseOrderWizardController {

    public static final String ORACLE_OPERATING_UNIT = 'SPEB OU';
    public static final String END_CUST_KEY = 'endCustId';
    public static final String LEASE_ORIGINATION = 'LEASE ORIGINATION';
    public static final Decimal LEASE_ORIGINATION_PERCENTAGE = .3;
    public static final String LEASE_INSTALLATION = 'LEASE INSTALLATION';
    public static final Decimal LEASE_INSTALLATION_PERCENTAGE = .6;
    public static final String LEASE_INTERCONNECT = 'LEASE INTERCONNECT';
    public static final Decimal LEASE_INTERCONNECT_PERCENTAGE = .1;
    //public static final String MATERIAL_REIMBURSEMENT = 'Material Reimbursement Cost';
    public static final String PERFORMANCE_GUARANTEE = 'PERFORMANCE GUARANTEE, 20-YEAR MONTHLY PLAN';
    public static final String ORDER_CONFIRMATION = 'orderConfirmation';

    public static final Set<String> AUTO_LINE_DESCRIPTIONS = new Set<String>{ LEASE_ORIGINATION,
                                                                                LEASE_INSTALLATION,
                                                                                LEASE_INTERCONNECT,
                                                                                PERFORMANCE_GUARANTEE };

    public Boolean showOrderConfirmation {get;set;}
    private Map<String, Item__c> itemDescriptionToItem;

    public String autolineItemIds { get; set; }
    //list of lease line items
    public List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selLeaseProductItems {get;set;}
    //used for finding correct line item in the list collection
    public Map<String, Integer> leaseLineNameToIndex {get;set;}

    public String serviceCreditSMSItemId {get; private set;}
    public String currentLocale {get;set;}
    public boolean isEUUser {get;set;}
    public boolean isInternalUser {get;set;}
    public boolean isStandardUser {get;set;} // Added to check if the logged user a partner user or a standard internal user.   
    public String orderUser{get;set;}
    public boolean isNAUser {get;set;}
    public boolean isCustBillShipSameAdd {get;set;}
    public String formattedCustShippingAdd{get;set;}
    public String formattedCustBillingAdd{get;set;}
    public Map<ID,Contact> currentDealersContactsMap {get;set;}
    public List<Contact>currentDealersContacts{get{
        if(currentDealersContactsMap != null) return currentDealersContactsMap.values();
        else
        return null;
    }
    }
    public Map<ID,Contact> currentOpportunityContactsMap {get;set;}
    public List<Contact>currentOpportunityContacts{get{
        if(currentOpportunityContactsMap != null) return currentOpportunityContactsMap.values();
        else
        return null;
    }
    }
    public String selectedShipToSiteConID{get;set;}
    //String constant for BoS Category of Price_List_Item
    public static final String CATEGORY_BOS = 'BoS';
    //selected category filter
      //for case: 00071299 begin
     public static final String CATEGORY_INVERTER = 'Inverter';
      //for case: 00071299 end
    public String selectedCategory {get;set;}
    public Price_List__c selectedPriceList{get;set;}
    public boolean showErrorBlock{get;set;}
    public boolean isPartnerUser{get;set;}
    //Order tab id ,has to be changed when deploy
    private final String ORDER_TAB_ID = '01r800000008htp';
    private final String RESIDENTIAL_INSTALLER = 'Residential Installer';
    //check if Dealer Account type is Residential Intaller or not
    public boolean isDealerResidential{get;set;}
    //check if the logged-in user is authorised to view/edit/create the purchase order
    public boolean isUserAuthorized{get;set;}
    
    // BIRLASOFT - for Financier field value display
    public List<SelectOption> financierOptions {get;set;}    
    public String Financier {get;set;}
    
    //This variable contains the Tab No, where the actual will Show.
    public Integer errorOnTab{get;set;}
    private String recordSep = ';';
    private String dataSep = '~';
    public boolean isShowCheckbox{get;set;}
    public String changedQty{get;set;}
    //As per the Current User Current Time
    public DateTime userCurrentTime{get;set;}
    //As per the Current User Current Hour
    public Integer userCurrentTimeHour{get;set;}
    //As per the Price List selected Fee for it
    public Double expediteFeeForPriceList {get;set;}
    //Set record type
    Map<String,ID> recTypes = new Map<String,ID>();
    //Hardcoded Design ID Field Name IFPO opens from Design
    private  final String DESIGN_ID_PARAM ='CF' + '00NT00000013NkP' +'_lkid';
    //PriceListItemType 2 This Value for use as filtering the Value
    public String prodType2Value {get;set;}
    //If New Order
    public Boolean isNewOrder{get;set;}
    //Created Purchase Order
    public Purchase_Order__c purchaseOrder {get;set;}
    //For Product Items Actually Saving,Purchase Order List Item values.Must be declared as private
    private List<Purchase_Order_Line__c> purchaseOrderList= null;
    //For Product Items Wrapper,which show in Page
    public List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems {get;set;}
    //Selected Design
    public SunPower_Design__c selectedDesign {get;set;}
    //Select Design ID
    public String designID{get;set;}
    //Selecetd Opportunity
    public Opportunity selectedOpportunity {get;set;}
    //All Customer Opportunities on List and Map
    public List<Opportunity> currentDealersOpportunity {get;set;}
    private Map<ID,Opportunity> currentDealersOpportunityMap {get;set;}
    //All Ids of Accunts of Ship To Sites Residential Customer__c
    private Set<String> customersAccountsIDs = new Set<String>();
    //Current Dealer Account
    public Account dealerAccount{get;set;}
    public Account endUserAccount{get;set;}
    //For Prrice List ITems on Page Step -1
    public Price_List_Item__c prod{get;set;}
    //Formatted ShipToSite Addres
    public String shipToSiteAddress{get;set;}
    //Formatted BillToSite Address
    public String billToSiteAddress{get;set;}
    //Seleted ShipToSite ID
    public String selectedShipToSiteID{get;set;}
    //Selected Dealer Account Shipping Address
    public String dealerAccountShippingAddress{get;set;}
    public Ship_to_Site__c shipSite{get;set;}
    public Boolean renderShipToBlock{get;set;}
    public Boolean isOrderSubmitted{get;set;}
    public String submitOrderLabel{get;set;}
    public String submitOrderTitle{get;set;}
    //quantity of a lin items
    public String inputQuantity {get;set;}
    //product line items
    public List<Price_List_Item__c> products;
    //counter variable
    Private Integer counter =1;
    public ApexPages.StandardSetController setCon{get;set;}
    public Map<ID,Ship_to_Site__c> dealerShiptoSiteMap{get;set;}
    public Map<ID,Ship_to_Site__c> customerShiptoSiteMap{get;set;}
    public String selectedCustomerOpportunity{get;set;}
    public boolean showQuantityMessage {get;set;}
    private Boolean isInvalidPartner {get;set;}
    public String hdnDelProdLineId{get;set;}
    public boolean isCustomerOppSelected{get;set;}
    public String termsDocID{get;set;}
    public Integer PAGINATION_COUNTER{get;set;}
    public Integer PAGINATION_COUNTERONPAGE{get;set;}
    public Integer PAGINATION_COUNTER_OPPLIST{get;set;}
    public Integer PAGINATION_COUNTERONPAGE_OPPLIST{get;set;}
    //public String prodNameFilter{get;set;}//removed for case # 00047707
    public String prodDescFilter{get;set;}// added for case # 00047707
    //private Boolean isDirectSalesUser {get;set;}//added for case # 00049102
    //start for case #00057947
    public boolean isSmartPack{get;set;}
    public boolean isUpdate{get;set;}
    //end for case #00057947
     //Case#00058280
    private Integer invertersAdded = 0;
    private Map<String,LeaseOrderWizardController.PriceListItemWrapper> mapPVItems = new Map<String,LeaseOrderWizardController.PriceListItemWrapper>();

    // Done for request to allow ‘EU Residential Installer’ profile to Order only Modulo and Inverter.
    public boolean isUserEUResidentialInstaller{get;set;}
    public static final String CATEGORY_MODULE = 'Module';
    // end.

    public String orderOwnerContactID{get{
        if(purchaseOrder != null && orderOwnerContactID == null && purchaseOrder.Id != null && purchaseOrder.OwnerId != null){
            for(user u :[select id,contactID from User where id =:purchaseOrder.OwnerId Limit 1])
                orderOwnerContactID = u.contactID;
        }
        return orderOwnerContactID;

    }set;
    }

    public String wizardStepNumber{
        get {
            if (wizardStepNumber == null ) {
              wizardStepNumber = '1';
            }
            return wizardStepNumber ;
        }
        set;
    }

    public Integer getWizardStepInt(){
        return Integer.valueOf(wizardStepNumber);
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

    public List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selectedProductsToShow
    {
        get
        {
            List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> items = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
            if( selLeaseProductItems != null && isOrderSubmitted != null && (!isOrderSubmitted || showOrderConfirmation) )
            {
                items.addAll( selLeaseProductItems );
            }
            if( selProductItems != null )
            {
                items.addAll( selProductItems );
            }
            return items;
        }
    }

    /** This function is to navigate to step-2 after updating the selected opportunity in purchase order.
     *  @return PageReference
     */
    public PageReference showStep2(){
        wizardStepNumber = '3';
        //Saving for Customer Opportunity
        if(selectedCustomerOpportunity != null && selectedCustomerOpportunity != ''){
            isCustomerOppSelected =true;
            //selectedOpportunity = currentDealersOpportunityMap.get(selectedCustomerOpportunity);
            selectedOpportunity = getCustOpportunity(selectedCustomerOpportunity);
            //[select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where ID =:selectedCustomerOpportunity Limit 1];
            purchaseOrder.Opportunity__c =selectedOpportunity.ID;
            purchaseOrder.Opportunity__r =selectedOpportunity;

            isCustBillShipSameAdd= PriceListItemUtilityLease.isBillingShippingAddressSame(selectedOpportunity);
            try{
                formattedCustShippingAdd = PriceListItemUtilityLease.getFormmatedOppShippingAddress(selectedOpportunity);
                if(!isCustBillShipSameAdd)
                    formattedCustBillingAdd = PriceListItemUtilityLease.getFormmatedOppBillingAddress(selectedOpportunity);
            currentOpportunityContactsMap = PriceListItemUtilityLease.getContactsInMap(selectedOpportunity.Account.ID);
            }catch(Exception e){
            }

            if(!isCustBillShipSameAdd)
                formattedCustBillingAdd = PriceListItemUtilityLease.getFormmatedOppBillingAddress(selectedOpportunity);
        }else{
            isCustomerOppSelected =false;
            selectedOpportunity = null;
            purchaseOrder.Opportunity__c =null;
            formattedCustShippingAdd = '';
            isCustBillShipSameAdd=false;
            formattedCustBillingAdd = '';
        }
        purchaseOrder.Order_Wizard_Step__c='Step 3';
        updatePOrder(false);
        return null;
    }
    //start for case # 00057947
    /** navigate to design page.
     */
    public PageReference showDesignPagebyButton(){
        showErrorBlock = false;
        String DESIGN_URL = '/apex/Design_Tools?tabName=SmartPack2&purchaseOrder='+ purchaseOrder.Id ;
        System.debug('Entered in showDesignPagebyButton->'+DESIGN_URL);
        calculateOrderPrice();
        updatePOrder(true);
        return new PageReference(DESIGN_URL);
    }
    //end for case # 00057947
    /** navigate to step-1.
     */
    public PageReference showPage1byButton(){
        showErrorBlock = false;
        wizardStepNumber = '1';
        updatePOrder(true);
        return null;
    }

    /**  navigate to step-3 from step-2.
     */
    public PageReference showPage3byButton(){
        showErrorBlock = false;
        if(selectedCustomerOpportunity != null && selectedCustomerOpportunity != ''&& !isCustomerOppSelected)
            isCustomerOppSelected = true;
        else
            isCustomerOppSelected = false;
        wizardStepNumber = '3';
        purchaseOrder.Order_Wizard_Step__c='Step 3';
        updatePOrder(true);
        return null;
    }

    /** navigate to step-2 from step-1.
     */
    public PageReference showPage2byButton(){
        showErrorBlock = false;
        synchQuantity();
        changedQty='';
        errorOnTab = 1;
        purchaseOrder.Financier__c = Financier;
        if(purchaseOrder.Name == null || purchaseOrder.Name == '' || String.valueOf(purchaseOrder.Name).length() > 50
            || selProductItems == null || selProductItems.size() < 1
            || purchaseOrder.Dealer_Fees__c == null
            || purchaseOrder.Projected_Install__c == null ){
            wizardStepNumber = '1';
            if(purchaseOrder.Name == null || purchaseOrder.Name == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredPONumber));
            //PR-02986 if character length of PO Name is greater than 50 show error
            }else if(String.valueOf(purchaseOrder.Name).length() > 50){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardPONumberLengthExceeds));
            }
            if(selProductItems == null || selProductItems.size() < 1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredLineItems));
            }
            if( purchaseOrder.Dealer_Fees__c == null ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LOWizardValidationErrorRequiredDealerFees));
            }
            if( purchaseOrder.Projected_Install__c == null ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LOWizardValidationErrorRequiredProjectedInstall));
            }
        }

        addLeaseItemsToList();
        if ( purchaseOrder.End_Customer_Account__c == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredEndCustomer));
        }
        else if( !ApexPages.hasMessages() ){
            //Start for Case#00078223
            if(purchaseOrder.Lease__c != null && purchaseOrder.Lease__c
                && (purchaseOrder.Lease_Number__c == null || purchaseOrder.Lease_Number__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredLeaseNumber));
            }else{
                if(purchaseOrder.Lease__c != null && !purchaseOrder.Lease__c)
                    purchaseOrder.Lease_Number__c = '';
            //End for Case#00078223
                String query ='';
                String poName = purchaseOrder.Name;//for Case#00072654
                poName = poName.replace('\'', '\\\'');//for Case#00072654
                if(purchaseOrder.ID == null){
                    query = 'Select p.Id from Purchase_Order__c p where p.Name like \''+poName+'\' AND p.Dealer_Account__c = \''+dealerAccount.ID+ '\'';//for Case#00072654
                }else{
                    query = 'Select p.Id from Purchase_Order__c p where p.Name like \''+poName+'\' AND p.Dealer_Account__c = \''+dealerAccount.ID +'\' AND p.Id != \''+ purchaseOrder.Id +  '\'';//for Case#00072654
                }
                System.debug('query string : '+query);
                List<Purchase_Order__c> poList = Database.query(query);
                if(poList != null && poList.size() > 0){
                    wizardStepNumber = '1';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardDuplicatePONumber));
                }else{
                    if(isDealerResidential){
                        wizardStepNumber = '3';
                        purchaseOrder.Order_Wizard_Step__c='Step 3';
                    }else{
                        wizardStepNumber = '2';
                        purchaseOrder.Order_Wizard_Step__c='Step 2';
                    }
                    //calculate total order price at step-1
                    calculateOrderPrice();
                    retrieveEndCustomerBillTo();
                    retrieveEndCustomerShipTo();
                    retrieveEndCustomerOpportunity();
                    updatePOrder(true);
                    //set Ship To Contact
                    List<Account> accounts = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id = :purchaseOrder.End_Customer_Account__c LIMIT 1 ];

                    System.debug( 'hey');
                     if ( !accounts.isEmpty() ) {
                        for ( Contact contact : accounts[0].Contacts ){
                            if ( contact.Name.toLowerCase() == accounts[0].Name.toLowerCase() ) {
                                System.debug( 'true hey');
                                purchaseOrder.Ship_To_Contact__c = contact.Id;
                                purchaseOrder.Ship_To_Contact__r = contact;
                                break;
                            }
                        }
                     }
                }
            }//for Case#00078223
        }
        if( ApexPages.hasMessages() )
        {
            return null;
        }
        return showPage3byButton();//is page 3 because we are skipping the page2 (removed opportunity tab)
    }

    //navigate to previous step that is from step-3  to step-2
    public PageReference showPage2byButtonFrom3(){
        showErrorBlock = false;
        if(isDealerResidential){
            wizardStepNumber = '1';
        }else{
             wizardStepNumber = '2';
        }
        updatePOrder(false);
        if( ApexPages.hasMessages() )
        {
            return null;
        }
        return showPage1byButton();
    }

     //navigate to next step that is from step-3  to step-4
     public PageReference showPage4byButtonFrom3(){
         showErrorBlock = false;
        Boolean hasError = false;
        if(shipToSiteAddress == null || shipToSiteAddress == ''){
                hasError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredShipsiteAddress));
        }
        if(purchaseOrder.Requested_Delivery_Date__c == null){
                hasError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredDeliveryDate));
        }
        if(purchaseOrder.Requested_Delivery_Date__c != null && purchaseOrder.Requested_Delivery_Date__c < Date.today()){
                hasError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POValidDeliveryDateMessage));
        }
        if(isShowCheckbox == true && purchaseOrder.Accept_Expedited_Delivery_Charges__c == false){
                hasError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationRequiredDeliveryCharges));
        }
         if(isNAUser && (purchaseOrder.Shipping_Method__c ==null || purchaseOrder.Shipping_Method__c =='' || purchaseOrder.Shipping_Method__c == '--None--')){
                hasError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationRequiredShippingMethod));
        }
        if(!hasError){
            wizardStepNumber = '4';
            purchaseOrder.Order_Wizard_Step__c='Step 4';
            updatePOrder(false);
            calculateOrderPrice();
        }else{
            wizardStepNumber = '3';
            errorOnTab = 3;
        }
        return null;
    }

     //go to previous step that is from step-4  to step-3
    public PageReference showPage3byButtonFrom4(){
        showErrorBlock = false;
        wizardStepNumber = '3';
        purchaseOrder.Order_Wizard_Step__c='Step 3';
        updatePOrder(false);
        return null;
    }
    //Start for Case#00078223--//commented for Case#00080427
    /*public String updatePoName(String val, String leaseNumber){
        String leaseSuffix =  '-L' + leaseNumber;
        if(val.length() < leaseNumber.length() + 2){
            return val + leaseSuffix;
        }
        String poLeaseSuffix = val.substring(val.length()- 2 - leaseNumber.length(), val.length());
        if(poLeaseSuffix != leaseSuffix)
            return val + leaseSuffix;
        else
            return val;
    }*/
    //End for Case#00078223 --//commented for Case#00080427
     //finally submit the purchase order to sunpower
    public PageReference submitOrder(){
        showErrorBlock = false;
        if(selectedProductsToShow!= null && selectedProductsToShow.size() > 0 && purchaseOrder.Bill_to_Site__c != null && purchaseOrder.Ship_to_Site__c != null &&  purchaseOrder.Dealer_Account__c != null && !(isShowCheckbox == true && purchaseOrder.Accept_Expedited_Delivery_Charges__c == false) && (isPartnerUser || purchaseOrder.Order_Status__c=='Error')){ //&& !(isShowCheckbox == true && purchaseOrder.Accept_Expedited_Delivery_Charges__c == false) new for pr 03721
            // if Order status is going from 'New' To 'Submitted',update the PO_Submit_Date__c
            // PR-03205
            if(purchaseOrder.Order_Status__c != null && purchaseOrder.Order_Status__c == 'New')
                purchaseOrder.PO_Submit_Date__c = Datetime.valueOfGMT(string.valueof(Datetime.now()));
            //Start for Case#00078223--//commented for Case#00080427
            /*if(purchaseOrder.Lease__c != null && purchaseOrder.Lease__c
                && (purchaseOrder.Lease_Number__c != null && purchaseOrder.Lease_Number__c != '')){
                purchaseOrder.Name = updatePoName(purchaseOrder.Name, purchaseOrder.Lease_Number__c);
            }*/
            //End for Case#00078223  --//commented for Case#00080427
            purchaseOrder.Order_Status__c = 'Submitted';
            if(purchaseOrder.Ship_To_Contact__c != null){
                if(purchaseOrder.Special_Instructions__c == null || purchaseOrder.Special_Instructions__c == 'null' || purchaseOrder.Special_Instructions__c =='')
                    purchaseOrder.Special_Instructions__c = ' ***';
                purchaseOrder.Special_Instructions__c += ' Contact:'+ purchaseOrder.Ship_To_Contact__r.Name+' *** ';
            }
            if(purchaseOrder.Special_Instructions__c != null && purchaseOrder.Special_Instructions__c.indexOf('null')>0)
                purchaseOrder.Special_Instructions__c =purchaseOrder.Special_Instructions__c.replaceAll('null','');
            //for Case#00058280
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper :selectedProductsToShow){
                prodWrapper.itemCategory = null;
            }
            //for Case#00058280
            purchaseOrder.Order_Wizard_Step__c='Step 4';
            System.SavePoint sp = Database.setSavepoint();
            try
            {
                updatePOrder(true);
                if( purchaseOrder.End_Customer_Account__c != null )
                {
                    Account endUserAccountToUpdate = new Account( Id = purchaseOrder.End_Customer_Account__c );
                    endUserAccountToUpdate.Lease_Customer__c = true;
                    endUserAccountToUpdate.Lease_Order_Placed__c = true;
                    update endUserAccountToUpdate;
                }
            }
            catch( System.DmlException ex )
            {
                Database.rollback( sp );
                ApexPages.addMessages( ex );
                return null;
            }
            PageReference pg = new PageReference('/apex/LeaseOrderWizard?POID='+purchaseOrder.Id+'&'+ORDER_CONFIRMATION+'=true');
            return pg.setRedirect(true);
        } else {
            errorOnTab = 4;
            if(purchaseOrder.Dealer_Account__c == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredDealerAcc);
                ApexPages.addMessage(errorMsg);
            }
            if(purchaseOrder.Name == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredPONumber);
                ApexPages.addMessage(errorMsg);
            }
            //case-00011848
            //if(!isEUUser){commented by shailendra for pr 03721
                //commented below code because delivery charges field has been commented on the po wizard page
                /* uncommented by shailendra for pr 03721*/
                if(isShowCheckbox == true && purchaseOrder.Accept_Expedited_Delivery_Charges__c == false){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationRequiredDeliveryCharges);
                    ApexPages.addMessage(errorMsg);
                }/**/
            //}
            if(isNAUser && (purchaseOrder.Shipping_Method__c ==null || purchaseOrder.Shipping_Method__c =='' || purchaseOrder.Shipping_Method__c == '--None--')){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationRequiredShippingMethod);
                    ApexPages.addMessage(errorMsg);
            }

            if(selectedProductsToShow == null || selectedProductsToShow.size() < 0){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredLineItems);
                ApexPages.addMessage(errorMsg);
            }

            if(purchaseOrder.Bill_to_Site__c == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredBillToSite);
                ApexPages.addMessage(errorMsg);
            }

            if(purchaseOrder.Ship_to_Site__c == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredShipsiteAddress);
                ApexPages.addMessage(errorMsg);
            }
            wizardStepNumber = '4';
            purchaseOrder.Order_Wizard_Step__c='Step 4';
            return null;
        }

    }
    /** updates purchase order and list of price list items.
     */
    public void updatePOrder(boolean updateList){
        //BW TODO: update po w/ oracle vendor number and oracle vendor site code
        if(purchaseOrder.ID == null) {            
            List<Account> partnerAccount = [SELECT Id, Oracle_Vendor_Number__c, Oracle_Vendor_Site_Code__c, Oracle_Operating_Unit__c FROM Account WHERE Id = :dealerAccount.Id];
            if ( !partnerAccount.isEmpty() ) {
                purchaseOrder.Oracle_Vendor_Number__c = partnerAccount[0].Oracle_Vendor_Number__c;
                purchaseOrder.Oracle_Vendor_Site_Code__c = partnerAccount[0].Oracle_Vendor_Site_Code__c;
            }
            insert  purchaseOrder;
        }
        if(purchaseOrder.ID != null) {            
            update  purchaseOrder;
        }
        if(updateList){  
            reInitlizeProductItems();
            //for Calculating Total order price
            calculateOrderPrice();
        }
    }

    // This function re-initializes the list of price list items of purchase order
    private void reInitlizeProductItems(){        
        if(purchaseOrderList != null && purchaseOrderList.size()>0){
            try{
                Database.delete(purchaseOrderList,true);
            }catch(Exception e){
            }
        }else {
            purchaseOrderList = new List<Purchase_Order_Line__c>();
            }
        purchaseOrderList.clear();
        if(selectedProductsToShow != null && selectedProductsToShow.size()>0){
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper : selectedProductsToShow){
                Purchase_Order_Line__c p= new Purchase_Order_Line__c();
                if(prodWrapper.Qty != null && prodWrapper.Qty != '')
                    p.Quantity__c =  Double.valueOf(prodWrapper.Qty);
                p.Purchase_Order__c = purchaseOrder.Id;
                p.Order_Line_Number__c = prodWrapper.lineNumber;
                p.Oracle_Item_Id__c = prodWrapper.oracleItemIDRef;

                //Case#00058280
                //p.SmartPack_Item__c = prodWrapper.isSmartPack;
                p.Item_Source__c = prodWrapper.itemSource;//for Case# 00077093
                if(prodWrapper.itemType != null && prodWrapper.itemType == PriceListItemUtilityLease.PVINVERTER_POITEMTYPE)
                    p.Item_Type__c = prodWrapper.itemType;//done by Jitendra for Case#00058280
                else//done by Jitendra for Case#00058280
                    p.Item_Type__c = prodWrapper.isSmartPack ? PriceListItemUtilityLease.SMARTPACK_POITEMTYPE : PriceListItemUtilityLease.ALACARTE_POITEMTYPE;
                p.Category__c = prodWrapper.itemCategory;//done by Jitendra for Case#00058280
                p.Unit_Price__c = (prodWrapper.perUnitPrice != null)? prodWrapper.perUnitPrice :0.0;
                p.Price__c =  (prodWrapper.totalPrice != null) ? prodWrapper.totalPrice :0.0;
                p.Quantity__c = (prodWrapper.Qty != null) ? Double.ValueOf(prodWrapper.Qty) :0.0;
                p.CurrencyIsoCode = prodWrapper.currencyCode;
                if(prodWrapper.childID !=null)
                    p.Child_ID__c = prodWrapper.childID;
                purchaseOrderList.add(p);
            }
            if(purchaseOrderList != null && purchaseOrderList.size()>0){
                insertListAndUpdateWrapper();
            }
        }
    }

    /** Action function called on cancel button from apex page.
     */
    public PageReference cancel(){
        if(isNewOrder != null && isNewOrder && purchaseOrder != null && selectedDesign == null && designID != null && designID != ''){
            List<SunPower_Design__c> sDesign =[select id from SunPower_Design__c where id =:designID LIMIT 1];
            if(sDesign != null && sDesign.size()>0)
                return (new PageReference('/'+sDesign[0].ID));
        }else if(dealerAccount == null && !isPartnerUser && designID != null && designID != ''){
            List<SunPower_Design__c> sDesign =[select id from SunPower_Design__c where id =:designID LIMIT 1];
            if(sDesign != null && sDesign.size()>0)
                return (new PageReference('/'+sDesign[0].ID));
        }
        return (new PageReference('/apex/Order_Details?sfdc.tabName='+ORDER_TAB_ID));
    }

    /**check whether the current logged-in user is authorised
     *  to view/edit/create a purchase order or not , if not then display error block.
     */
    private void checkUserAuthorization(String userID){
        //start for case # 00049102 - onhold
        for(User u :[select id, Name,profile.name, UserType, contactId, Contact.AccountID, Contact.Authorized_to_Order__c, Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c, Contact.Account.AccountNumber, Contact.Account.Name, Contact.Account.ShippingStreet, Contact.Account.ShippingState, Contact.Account.ShippingCity, Contact.Account.ShippingCountry, Contact.Account.ShippingPostalCode, Contact.Account.Theater__c,Contact.Account.Type,Contact.Account.Oracle_Account_Number__c from User where id = :userID and ContactID != null LIMIT 1]){
        /*isDirectSalesUser = false;
        for(User u :[select id, Name,Profile.Name, UserType, contactId, Contact.AccountID, Contact.Authorized_to_Order__c, Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c, Contact.Account.AccountNumber, Contact.Account.Name, Contact.Account.ShippingStreet, Contact.Account.ShippingState, Contact.Account.ShippingCity, Contact.Account.ShippingCountry, Contact.Account.ShippingPostalCode, Contact.Account.Theater__c,Contact.Account.Type,Contact.Account.Oracle_Account_Number__c from User where id = :userID LIMIT 1]){
            if(u.Profile.Name == 'SunPower Direct Sales RLC')
                isDirectSalesUser = true;*/
            //end for case # 00049102
            if(isInvalidPartner(u)){
                isInvalidPartner = true;
                errorOnTab = 0;
                isUserAuthorized =false;
                isPartnerUser = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.POWizardViewNotAllowed));
                return;
            }

            String accType=null;
            if(u != null && u.Contact != null && u.Contact.Account != null){
                accType=u.Contact.Account.Type;
                //check whether the user is partner or non-partner
                if(u.UserType == 'PowerPartner'){
                    //oracle account number check start:
                    //check whether the Oracle_Account_Number__c of his account has some value or not

                    //oracle account number check ends:
                    isPartnerUser = true;
                    if(u.Contact.Authorized_to_Order__c && u.Contact.Account.Online_Order_Access__c){
                        isUserAuthorized = true;
                    }
                }else{
                    isPartnerUser = false;
                }
            }
            //start for case # 00049102 - on hold
            /*if(isDirectSalesUser)
                isUserAuthorized = true;*/
            //start for case # 00049102
            //Check if EU partner user
            isEUUser = false;

            if(u.Contact != null && u.Contact.Account != null && u.UserType == 'PowerPartner'){
                if(u.profile.name.startsWith('EU'))
                    isEUUser = true;
                else if(accType != null && PriceListItemUtilityLease.getValidNAAccountType().contains(acctype) && u.Contact.Account.Theater__c != null && u.Contact.Account.Theater__c =='North America' )
                    isNAUser =true;
            }

            //check if user profile is 'EU Residential Installer' and going to create an Ala-Carte Order
            if(u.profile.name == 'EU Residential Installer' && u.UserType == 'PowerPartner'){

                /* // if POID or ID  is in URL parameter then edit an order, Allowed
                // if DID  or  DESIGN_ID_PARAM is coming in URL parameter then create an order with design, Allowed
                // if no parameter is coming in URL means create an order with Ala-Carte Items then don't allow him and display error message
                if(ApexPages.currentPage().getParameters().get('POID') == null &&
                        ApexPages.currentPage().getParameters().get('id') == null &&
                            ApexPages.currentPage().getParameters().get('DID') == null &&
                                ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM) == null){
                    errorOnTab = 0;
                    isPartnerUser = true;
                    isUserAuthorized = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardAccessErrorEUResi));
                    return;
                }*/
                // Done for request to allow ‘EU Residential Installer’ profile to Order Ala carte but only two categories Modulo and Inverter.
              isUserEUResidentialInstaller = true;

              /*// if POID or ID  is in URL parameter then edit an order, Allowed
                // if DID  or  DESIGN_ID_PARAM is coming in URL parameter means create an order with design, then don't allow him and display error message
                // if no parameter is coming in URL means create an order with Ala-Carte Items, then allow only two categories Modulo and Inverter to order.
              if(ApexPages.currentPage().getParameters().get('DID') != null ||
                  ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM) != null){
                    errorOnTab = 0;
                    isPartnerUser = true;
                    isUserAuthorized = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardAccessErrorEUResi));
                    return;
              }*/
            }
        }
        if(!isUserAuthorized && isPartnerUser){
            errorOnTab = 0;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardAccessPermissionsErrorMsg);
            ApexPages.addMessage(errorMsg);
        }
    }
    /*
        This method check whether the Partner User is Authorized to view the Order or not
        As per PR-03075, if any Partner User view the order of any another Partner, it will show the error.
    */
    private boolean isInvalidPartner(User u){
        //has to be code here
        boolean isInvalid =false;
        if(ApexPages.currentPage().getParameters().get('POID') != null || ApexPages.currentPage().getParameters().get('id') != null ){
            String purID =  ApexPages.currentPage().getParameters().get('POID');
            if(purID == null)
                purID = ApexPages.currentPage().getParameters().get('id');
            if(purID != null){
                for(Purchase_Order__c p :[select id,dealer_Account__c from Purchase_Order__c where id =:purID Limit 1]){
                    if(p.dealer_Account__c != null && p.dealer_Account__c != u.Contact.AccountID)
                        isInvalid=true;
                }
            }
        }
        return isInvalid;
    }

    /** Constructor LeaseOrderWizardController.
     *  @param ApexPages.standardController
     */
    public LeaseOrderWizardController(ApexPages.standardController control){
        System.debug('Enter in LeaseOrderWizardController');
        String userID = UserInfo.getUserID();
        PAGINATION_COUNTER =5;
        PAGINATION_COUNTERONPAGE=0;
        PAGINATION_COUNTER_OPPLIST = 5;
        PAGINATION_COUNTERONPAGE_OPPLIST=0;
        isInternalUser =false;
        
        // START - Added to check if the user is a partner user or a standard internal user
        isStandardUser =false; 
        if(UserInfo.getUserType() == 'Standard'){
        isStandardUser = true;
        }
        // END - Added to check if the user is a partner user or a standard internal user
        isSmartPack = false;//for case # 00057947
        isNAUser =false;
        orderUser ='';
        isEUUser =false;
        isCustBillShipSameAdd=false;
        isInvalidPartner =false;
        showErrorBlock = false;
        showQuantityMessage = false;
        isPartnerUser = false;
        isUserAuthorized = false;
        currentLocale = userinfo.getLocale();
        // Done for request to allow ‘EU Residential Installer’ profile to Order only Modulo and Inverter.
        isUserEUResidentialInstaller = false;
        itemDescriptionToItem = new Map<String, Item__c>();
        selLeaseProductItems = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
        leaseLineNameToIndex = new Map<String, Integer>();
        autolineItemIds = '';
        showOrderConfirmation = false;

        checkUserAuthorization(userID);
        // if user parther user and authorized to access po then can view/edit/create po
        // if user partner user and not authorized to access po then can not view/edit/create po
        // if user non-partner then can view the po
        if((isUserAuthorized || !isPartnerUser) && (!isInvalidPartner) ){
            inputQuantity='1';
            shipToSiteAddress='';
            isShowCheckbox =false;
            billToSiteAddress='';
            shipSite = new Ship_to_Site__c();
            renderShipToBlock = false;
            isOrderSubmitted = false;
            // Custom Label for Submit Order
            submitOrderLabel = System.Label.POWizardSubmitOrderLabel ;
            // Custom Label for New Order Wizard
            submitOrderTitle = System.Label.POWizardNewOrderWizardTitle;
            isDealerResidential = false;
            errorOnTab = 0;
            prod = new Price_List_Item__c();
            // Current Time as Per UserTime Zone
            userCurrentTime = Datetime.valueOfGMT(string.valueof(Datetime.now()));
            userCurrentTimeHour = userCurrentTime.hourGmt();
            System.debug('Here the Time value is::'+userCurrentTimeHour);
            //Parameters
            //String userID = UserInfo.getUserID();
            //For Testing
            //userID='00580000002iAWA';
            //Initlizing Products
            for (RecordType rec : [Select id,name,developerName from RecordType where sObjectType='Ship_To_Site__C']){
                recTypes.put(rec.developerName,rec.ID);
            }
            purchaseOrder = new Purchase_Order__c(Order_Status__c ='New', Name='Test' + System.now().getTime());
            purchaseOrder.OwnerId = UserInfo.getUserId();
            
            //START - COde for Financier display picklist field
            financierOptions = new List<SelectOption>();
            Schema.DescribeFieldResult financierFieldDescription = Purchase_Order__c.Financier__c.getDescribe();
            for(Schema.Picklistentry picklistEntry : financierFieldDescription.getPicklistValues()){    
                financierOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));    
                if (picklistEntry.defaultValue){                
                    purchaseOrder.Financier__c = pickListEntry.getValue();        
                }  
            }
            //END - COde for Financier display picklist field

            // get auto line items
            List<Item__c> items = [ SELECT Id, Name, Description__c FROM Item__c
                                    WHERE Description__c = :LEASE_ORIGINATION
                                        OR Description__c = :LEASE_INSTALLATION
                                        OR Description__c = :LEASE_INTERCONNECT
                                        //OR Description__c = :MATERIAL_REIMBURSEMENT
                                        OR Description__c = :PERFORMANCE_GUARANTEE ];

            for( Item__c autoLineItem : items )
            {
                autolineItemIds += autoLineItem.Name + ';';
                itemDescriptionToItem.put( autoLineItem.Description__c, autoLineItem );
            }

            //added to default the Owner (it will be overridden if the PO already exists)
            //IF EXISTING ORDER
            if(ApexPages.currentPage().getParameters().get('POID') != null || ApexPages.currentPage().getParameters().get('id') != null ){
                isNewOrder =false;
                String prodID = ApexPages.currentPage().getParameters().get('POID');
                if(prodID == null)
                    prodID = ApexPages.currentPage().getParameters().get('id');
                if(prodID != null){
                    //Case#00058280
                    for(Purchase_Order__c p:[Select Id, Accept_Terms__c, Dealer_Fees__c, Lease__c, Lease_Number__c, //Material_Cost_Reimbursement__c,
                                                SmartMount__c, OwnerID,Ship_To_Contact__c, Ship_To_Contact__r.Name, Is_Taxible_Order__c, Financier__c,
                                                CurrencyIsoCode, SmartPack_Mounting_Type__c, SmartPack_Inverter_Type__c,
                                                Accept_Partial_Shipment__c, DSR_PO_Group_Email__c, Assigned_DSR__c, Assigned_RSM__c,
                                                Order_Status_Interface_Message__c, Oracle_Order_Number__c, Owner.Name, Owner.Profile.Name,
                                                CreatedDate, LastModifiedDate,Notes__c, Accept_Expedited_Delivery_Charges__c,
                                                Delivery_Charges__c, Dealer_Account__c, Dealer_Account__r.Oracle_Operating_Unit__c,
                                                Dealer_Account__r.Name, Order_Wizard_Step__c, Opportunity__r.Name, Opportunity__r.Id,
                                                Opportunity__r.AccountID, Opportunity__r.Account.BillingStreet,
                                                Opportunity__r.Account.BillingCity, Opportunity__r.Account.BillingState,
                                                Opportunity__r.Account.BillingCountry, Opportunity__r.Account.BillingPostalCode,
                                                Opportunity__r.Account.ShippingStreet, Opportunity__r.Account.ShippingCity,
                                                Opportunity__r.Account.ShippingState, Opportunity__r.Account.ShippingCountry,
                                                Opportunity__r.Account.ShippingPostalCode, SunPower_Design__r.ID,
                                                SunPower_Design__r.Name, System_Size__c, SunPower_Design__c,
                                                SunPower_Design__r.EU_Inverter_Type__c, SunPower_Design__r.EU_Mounting_Type__c,
                                                SunPower_Design__r.System_Source__c, SunPower_Design__r.SMS_KIT__c, Special_Instructions__c,
                                                Shipping_Method__c, Ship_to_Site__c, Ship_to_Site__r.Zip__c, Ship_to_Site__r.Type__c,
                                                Ship_to_Site__r.State__c, Ship_to_Site__r.Oracle_Account_Number__c, Ship_to_Site__r.Country__c,
                                                Ship_to_Site__r.City__c, Ship_to_Site__r.Address3__c, Ship_to_Site__r.Address2__c,
                                                Ship_to_Site__r.Address1__c, Ship_to_Site__r.Contact_Email__c,
                                                Ship_to_Site__r.Contact_First_Name__c, Ship_to_Site__r.Contact_Last_Name__c,
                                                Ship_to_Site__r.Contact_Phone__c, Requested_Delivery_Date__c, Order_Total__c,
                                                Order_Status__c, Oracle_Order_Status__c, Opportunity__c, Name, Contact_ID__c,
                                                Bill_to_Site__c, Bill_to_Site__r.Zip__c, Bill_to_Site__r.State__c, Bill_to_Site__r.Country__c,
                                                Bill_to_Site__r.City__c, Bill_to_Site__r.Address3__c, Bill_to_Site__r.Address2__c,
                                                Bill_to_Site__r.Address1__c, End_Customer_Account__c, End_Customer_Account__r.Name , Projected_Install__c,
                                                (Select Child_ID__c,Id, Name, Order_Line_Number__c, Item_Description__c, Quantity__c,
                                                    Unit_of_Measure__c, Unit_Price__c, Quantity_per_Box__c, Price__c, Item_ID__c,
                                                    Item_Number__c, CurrencyIsoCode, Purchase_Order__c, Item_Type__c, Oracle_Item_Id__c,
                                                    Oracle_Item_Id__r.Name, Oracle_Item_Id__r.Line_Type__c, Oracle_Item_Id__r.Description__c,
                                                    Oracle_Item_Id__r.Long_Description__c, Purchase_Order__r.SmartPack_Mounting_Type__c,
                                                    Purchase_Order__r.SmartPack_Inverter_Type__c, Item_Source__c, Category__c, Oracle_Warehouse__c
                                                    From Purchase_Order_Lines__r order by Item_Type__c)
                                                From Purchase_Order__c where Id =:prodID Limit 1]){
                        purchaseOrder =p;
                        /* Check here is came from Clone starts */
                            if(ApexPages.currentPage().getParameters().get('cln')!=null && p.Name != null && p.Name.startsWith(Purchase_Order__c.SObjectType.getDescribe().getKeyPrefix())){
                                p.Name='';
                            }
                        /* Check here is came from Clone ends */
                        if(p.Owner.Profile.Name.startsWith('EU'))
                            orderUser='EU';
                        else
                            orderUser='NA';
                        
                        // BIRLASOFT - START - assign Financier value to variable
                        Financier = purchaseOrder.Financier__c;
                        // BIRLASOFT - END - assign Financier value to variable
                        
                        if(purchaseOrder.Order_Wizard_Step__c != null) {
                            wizardStepNumber = (purchaseOrder.Order_Wizard_Step__c =='Step 1'?'1':(purchaseOrder.Order_Wizard_Step__c =='Step 2'?'2':(purchaseOrder.Order_Wizard_Step__c =='Step 3'?'3':'4')));
                            String orderConfirmation = ApexPages.currentPage().getParameters().get(ORDER_CONFIRMATION);
                            if ( orderConfirmation != null && orderConfirmation == 'true' ) {
                                showOrderConfirmation = true;
                            }

                        }
                        if(purchaseOrder.Dealer_Account__c != null)
                            for(Account a: [select ShippingStreet ,ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity, id, Name, AccountNumber, Type, Primary_PSR__c, RSM__c,Oracle_Operating_Unit__c, Oracle_Warehouse__c from Account where id =:purchaseOrder.Dealer_Account__c LIMIT 1])
                                dealerAccount = a;
                        selectedDesign = p.SunPower_Design__r;
                        //start for case # 00057947
                        if(selectedDesign != null && p.Order_Status__c == 'New')
                            isSmartPack = true;
                        if(isSmartPack != null && isSmartPack && ApexPages.currentPage().getParameters().get('isUpdate')!=null && ApexPages.currentPage().getParameters().get('isUpdate')=='1')
                            isUpdate = true;
                        else
                            isUpdate = false;
                        //end for case # 00057947
                        isShowCheckbox= p.Accept_Expedited_Delivery_Charges__c;
                        selectedCustomerOpportunity = p.Opportunity__c;
                        if(selectedCustomerOpportunity != null && selectedCustomerOpportunity != ''){
                            try{
                            selectedOpportunity = p.Opportunity__r;
                            isCustomerOppSelected =true;
                            isCustBillShipSameAdd= PriceListItemUtilityLease.isBillingShippingAddressSame(selectedOpportunity);
                            formattedCustShippingAdd = PriceListItemUtilityLease.getFormmatedOppShippingAddress(selectedOpportunity);
                            if(!isCustBillShipSameAdd)
                                formattedCustBillingAdd = PriceListItemUtilityLease.getFormmatedOppBillingAddress(selectedOpportunity);
                            currentOpportunityContactsMap = PriceListItemUtilityLease.getContactsInMap(p.Opportunity__r.Account.ID);
                            }catch(Exception e){
                            }
                        }
                        if(purchaseOrderList == null)
                            purchaseOrderList= p.Purchase_Order_Lines__r;
                        
                        //if the order status is in error then
                        //1)if user is partner then show error message saying 'There is an error with this order. Please contact your SunPower DSR for more information.'
                        //2)if user is non partner then show error message saying There is an error with this order. The error is: " & display ->[Order_Status_Interface_Message__c]
                        if(p.Order_Status__c == 'Error'){
                            showErrorBlock = true;
                            errorOnTab = 0;
                            isOrderSubmitted = true;
                            submitOrderLabel = System.Label.POWizardViewOrderTitle; //'View Order'
                            submitOrderTitle = '';
                            if(isPartnerUser){
                                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizadErrorMsgForErrorStatusPartners);
                                //ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizadErrorMsgForErrorStatusNonPartners+'\n'+purchaseOrder.Order_Status_Interface_Message__c);
                                ApexPages.addMessage(errMsg);
                            }else{
                                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizadErrorMsgForErrorStatusNonPartners+'\n'+purchaseOrder.Order_Status_Interface_Message__c );
                                ApexPages.addMessage(errMsg);
                            }
                        }
                        // if the order is already submitted then display a message and hide all the tabs except tab4
                        else if(p.Order_Status__c == 'Submitted'){
                            isOrderSubmitted = true;
                            // custom label for View Order
                            submitOrderLabel = System.Label.POWizardViewOrderTitle;
                            submitOrderTitle = '';
                            errorOnTab = 4;
                            ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, System.Label.POWizardInfoMsgForSubmittedOrder);
                            ApexPages.addMessage(infoMsg);
                        // if the order status is processed
                        }else if(p.Order_Status__c == 'Processed'){
                            showErrorBlock = true;
                            errorOnTab = 0;
                            isOrderSubmitted = true;
                            // custom label for View Order
                            submitOrderLabel = System.Label.POWizardViewOrderTitle;
                            submitOrderTitle = '';
                            //ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, System.Label.POWizardInfoMsgForProcessedStatus+'\n'+purchaseOrder.Order_Status_Interface_Message__c);
                            ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, System.Label.POWizardInfoMsgForProcessedStatus+'\n'+purchaseOrder.Oracle_Order_Number__c);
                            ApexPages.addMessage(infoMsg);
                       // if the order status is In Process
                        }else if(p.Order_Status__c == 'In Process'){
                            errorOnTab = 0;
                            showErrorBlock = true;
                            isOrderSubmitted = true;
                            // custom label for View Order
                            submitOrderLabel = System.Label.POWizardViewOrderTitle;
                            submitOrderTitle = '';
                            ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, System.Label.POWizardInfoMsgForInProcessStatus);
                            ApexPages.addMessage(infoMsg);
                        }
                    }
                    if(purchaseOrder == null){
                        isUserAuthorized = false;
                        errorOnTab = 0;
                        return;
                    }
                    setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
                    setFormatedBillToSiteAddress(purchaseOrder);
                }
            }
            //IF NEW ORDER
            // only partner user can create a new Purchase Order
            else if (isPartnerUser){
                isNewOrder =true;
                wizardStepNumber='1';

                isCustomerOppSelected =false;
                // a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity
                //Contact.Account.Bill_To_Site__c,Contact.Account.Bill_To_Site__r.Address1__c,Contact.Account.Bill_To_Site__r.Address2__c,Contact.Account.Bill_To_Site__r.Address3__c,Contact.Account.Bill_To_Site__r.City__c,Contact.Account.Bill_To_Site__r.State__c,Contact.Account.Bill_To_Site__r.Country__c,Contact.Account.Bill_To_Site__r.Zip__c,
                for(User u :[select id,Name,contactId,Contact.AccountID, Contact.Authorized_to_Order__c,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c,Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode, Contact.Account.Type, Contact.Account.Primary_PSR__c, Contact.Account.RSM__c, Contact.Account.Oracle_Warehouse__c from User where id = :userID and ContactID != null LIMIT 1])
                    dealerAccount = u.Contact.Account;
                if(dealerAccount != null){
                    purchaseOrder.Dealer_Account__r = dealerAccount;
                    purchaseOrder.Dealer_Account__c = dealerAccount.ID;
                }
                setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
                setFormatedBillToSiteAddress(purchaseOrder);
            }else{        // non-partner users can not create a new order they will see error message
                /* Added by Prakash For Back Button Issue When for Non-Partner Users and from Design starts */
                if(ApexPages.currentPage().getParameters().get('DID') != null || ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM) != null){
                designID =ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM);
                if(designID == null || designID =='')
                    designID =ApexPages.currentPage().getParameters().get('DID');
                }
                /* Added by Prakash For Back Button Issue When for Non-Partner Users and from Design ends */
                showErrorBlock = true;
                errorOnTab = 0;
                isNewOrder = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardErrorMsgPOCreationForNonPartners);
                ApexPages.addMessage(errorMsg);
                return;
            }

            if(dealerAccount == null && !isPartnerUser){
                //Not a PArtner return
                showErrorBlock = true;
                errorOnTab = 0;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardErrorMsgPOCreationOrInvalidID);
                ApexPages.addMessage(errorMsg);
                return;
            }
            else{
                //checking Dealer Account type
                if(dealerAccount.Type == RESIDENTIAL_INSTALLER){
                    isDealerResidential = true;
                }
                //Initlizing Products
                initilizeSetCon();
                currentDealersContactsMap = PriceListItemUtilityLease.getContactsInMap(dealerAccount.ID);
                // Done for case # 00061873 - Commented for Case#00078223
                retrieveEndCustomerBillTo();
                //for(Opportunity opp: [Select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where Owner.Contact.AccountID = :dealerAccount.ID lIMIT 1000]){
                    if(currentDealersOpportunity == null) currentDealersOpportunity = new List<Opportunity>();
                    if(currentDealersOpportunityMap == null) currentDealersOpportunityMap = new Map<ID,Opportunity>();
                //}
                setDealerAndCustomerShipToSites();
                if(purchaseOrder.Ship_to_Site__c != null){
                    if(dealerShiptoSiteMap != null && dealerShiptoSiteMap.get(purchaseOrder.Ship_to_Site__c) != null)
                        setFormatedShipToSiteAddress(dealerShiptoSiteMap.get(purchaseOrder.Ship_to_Site__c));
                    else if(customerShiptoSiteMap != null && customerShiptoSiteMap.get(purchaseOrder.Ship_to_Site__c) != null)
                        setFormatedShipToSiteAddress(customerShiptoSiteMap.get(purchaseOrder.Ship_to_Site__c));
                }else{
                }
                //Setting Dealer Shipping Address
               setDealerShippingAddress();
            }
            //Initilizing selected Design Items
            InitilizeDesignProdItems();
            // fetch expediteFee from selected price list
            selectedPriceList = PriceListItemUtilityLease.getExpediteFeeForPriceListLease(ORACLE_OPERATING_UNIT);
            if(selectedPriceList != null && selectedPriceList.Expedite_Fee__c != null)
                expediteFeeForPriceList = selectedPriceList.Expedite_Fee__c;
            // for a new purchase order
            // 1)assign selectedPriceList.DSR_PO_Group_Email__c to purchaseOrder.DSR_PO_Group_Email__c
            // 2)assign dealerAccount.Primary_PSR__c to purchaseOrder.Assigned_DSR__c
            // 3)assign dealerAccount.RSM__c to purchaseOrder.Assigned_RSM__c
            if(isNewOrder){
                if(selectedPriceList != null && selectedPriceList.DSR_PO_Group_Email__c != null)
                    purchaseOrder.DSR_PO_Group_Email__c = selectedPriceList.DSR_PO_Group_Email__c;
                if(dealerAccount != null){
                    if(dealerAccount.Primary_PSR__c != null)
                        purchaseOrder.Assigned_DSR__c = dealerAccount.Primary_PSR__c;
                    if(dealerAccount.RSM__c != null)
                        purchaseOrder.Assigned_RSM__c = dealerAccount.RSM__c;
                }
            }
            //if(isNewOrder) updatePOrder(true);
            System.debug('In Constructor Going to set List from  dealerShiptoSiteMap::'+dealerShiptoSiteMap);
            if(dealerShiptoSiteMap != null && dealerShiptoSiteMap.values().size()>0){
                System.debug('In Constructor Going to set List from resetDealersShipValues::');
                resetDealersShipValues();
            }
        }
        else
        {
            isUserAuthorized = false;
            errorOnTab = 0;
            return;
        }

        String endCustomerId = ApexPages.currentPage().getParameters().get(END_CUST_KEY);
        if( endCustomerId != null ) {
            purchaseOrder.End_Customer_Account__c = endCustomerId;
        }

        purchaseOrder.Lease__c = true;
    }// function ends

    public void retrieveEndCustomerBillTo() {
        if ( purchaseOrder.End_Customer_Account__c != null ) {
            List<Bill_To_Site__c> bTo = [Select b.Zip__c, b.State__c, b.Country__c, b.Site_ID__c, b.Oracle_Operating_Unit__c, b.Name, b.Id, b.Dealer_Account__c, b.City__c, b.Address3__c, b.Address2__c, b.Address1__c From Bill_To_Site__c b where b.Dealer_Account__c = :purchaseOrder.End_Customer_Account__c order by LastModifiedDate desc LIMIT 1];
            if ( !bTo.isEmpty() ) {
                purchaseOrder.Bill_to_Site__r = bTo[0];
                purchaseOrder.Bill_to_Site__c = bTo[0].ID;
                setFormatedBillToSiteAddress(purchaseOrder);
            }
        }
    }

    public void retrieveEndCustomerShipTo() {

        if ( purchaseOrder.End_Customer_Account__c != null ) {

            List<Ship_to_Site__c> listShipSites = [Select Type__c,RecordType.DeveloperName,Residential_Customer_Account__c,Zip__c, ID,State__c, Dealer_Account__c, Country__c, City__c, Address3__c, Address2__c, Address1__c, Contact_Email__c, Contact_First_Name__c, Contact_Last_Name__c, Contact_Phone__c From Ship_to_Site__c where Dealer_Account__c =:purchaseOrder.End_Customer_Account__c order by LastModifiedDate desc LIMIT 1];

            if(listShipSites != null && listShipSites.size() > 0){
                if(purchaseOrder.Ship_to_Site__c==null){
                    purchaseOrder.Ship_to_Site__c =  listShipSites[0].ID;
                    purchaseOrder.Ship_to_Site__r = listShipSites[0];
                }
                setFormatedShipToSiteAddress( purchaseOrder.Ship_to_Site__r );
            }
        }
    }

    public void retrieveEndCustomerOpportunity()
    {
        if( purchaseOrder.End_Customer_Account__c != null )
        {
            List<Opportunity> endCustomerOpportunities = [ SELECT Id, Name FROM Opportunity WHERE AccountId = :purchaseOrder.End_Customer_Account__c AND Partner_Portal_Registration__c = TRUE LIMIT 1 ];

            if( !endCustomerOpportunities.isEmpty() )
            {
                selectedOpportunity = endCustomerOpportunities[0];
                purchaseOrder.Opportunity__c = selectedOpportunity.Id;
                purchaseOrder.Opportunity__r = selectedOpportunity;
            }
        }
    }

    /** This function initializes price list items from design.
     */
    public void InitilizeDesignProdItems(){
        //For NEW When Design is there
        if(isNewOrder && isPartnerUser){
            if(ApexPages.currentPage().getParameters().get('DID') != null || ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM) != null){
                boolean isItemAdded =false;
                designID =ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM);
                if(designID == null || designID =='')
                    designID =ApexPages.currentPage().getParameters().get('DID');
                //start for case #00057947
                if(designID!=null)
                    isSmartPack = true;
                //end for case #00057947
                if(selProductItems == null)
                    selProductItems = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
                selProductItems.clear();

                selectedDesign = PriceListItemUtilityLease.setDesignItemswithPrice(designID, dealerAccount.ID, selProductItems, purchaseOrder, ORACLE_OPERATING_UNIT, isNAUser);

                serviceCreditSMSItemId = PriceListItemUtilityLease.serviceCreditSMSItemId;
                addLeaseItemsToList();
            }
        }
        //For Existing Purchase Order
        else if(!isNewOrder){
            if(purchaseOrderList != null && purchaseOrderList.size()>0){
                purchaseOrderList = getSortedList(purchaseOrderList);
                if(selProductItems == null)
                    selProductItems = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
                selProductItems.clear();
                
                /***KANE MACASPAC, 08-04-2015 09:47PM PDT
                    added for case 00450897, to resolve issue where PO Line Items duplicate each time the PO is viewed ***/
                if(selLeaseProductItems == null)
                    selLeaseProductItems = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
                selLeaseProductItems.clear();
                
                //done by Jitendra for Case# 00058280
                Set<String> itemIds = new Set<String>();
                invertersAdded = 0;
                mapPVItems.clear();
                //done by Jitendra for Case# 00058280
                Map<String,LeaseOrderWizardController.PurchaseOrderLineItemWrapper> childParentMap = new Map<String,LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
                for(Purchase_Order_Line__c item:purchaseOrderList){
                    if (item.Oracle_Item_Id__r.Line_Type__c == 'Credit Only') {
                        serviceCreditSMSItemId = item.Oracle_Item_Id__r.Name;
                    }
                    System.debug('Jitendra Test->'+item);
                    LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper();
                    pWrap.pOrderLine = item;
                    copyItemToWrapper(item,pWrap);

                    if(pWrap.itemCategory!=null && pWrap.itemCategory.equalsIgnoreCase('Inverter')){
                        invertersAdded++;
                    }else if(pWrap.itemCategory!=null && pWrap.itemCategory.equalsIgnoreCase('Module') && !mapPVItems.containsKey(pWrap.ItemID)){
                        mapPVItems.put(pWrap.ItemID,new LeaseOrderWizardController.PriceListItemWrapper(pWrap.perUnitPrice));
                        if(item.Item_Type__c == PriceListItemUtilityLease.PVINVERTER_POITEMTYPE)
                            itemIds.add(pWrap.ItemID);
                    }
                    if(pWrap.childID != null)
                        childParentMap.put(pWrap.childID,pWrap);
                    if(AUTO_LINE_DESCRIPTIONS.contains(item.Oracle_Item_Id__r.Description__c))
                    {
                        selLeaseProductItems.add( pWrap );
                        leaseLineNameToIndex.put( item.Oracle_Item_Id__r.Description__c, selLeaseProductItems.size() - 1);
                    }
                    else
                    {                        
                        selProductItems.add(pWrap);
                    }
                }
                //done by Jitendra for Case# 00058280
                String operatingUnit = dealerAccount.Oracle_Operating_Unit__c;
                String pvInverter = PriceListItemUtilityLease.ALACARTE_POITEMTYPE;
                List<Price_List_Item__c> lst = new  List<Price_List_Item__c>();
                if(operatingUnit != null && itemIds.size() > 0){
                    Date currentDate = Date.today();
                    String qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =:pvInverter and Item_ID__r.Name IN :itemIds ';
                    lst = database.query(qry);
                }
                for(Price_List_Item__c item : lst){
                    mapPVItems.get(item.Item_ID__r.Name).pvInverter = mapPVItems.get(item.Item_ID__r.Name).alaCarte;
                    mapPVItems.get(item.Item_ID__r.Name).alaCarte = item.Pricing_1__c;
                }
                System.debug('Jitendra Test->'+mapPVItems);
                //done by Jitendra for Case# 00058280
                /*...................Code added for ................*/
                if(childParentMap != null && childParentMap.values().size() >0){
                for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap:selProductItems){
                    if(childParentMap.get(pWrap.ID) != null){
                        pWrap.isChild=true;
                        pWrap.parentID = childParentMap.get(pWrap.ID).ID;
                    }
                }
            }

        /*...................Code added for ................*/
                //showProductList();
                fillWrapperRestFields(selProductItems);
            }
        }
    }

    /** This function checks the po line items if they are still active/inactive, valid/invalid and price changed,
     *  And accordingly change the prices of po line items.
     *  @return boolean
     */
    public Boolean updatePOLineItems(){
        Boolean isError = false;
        System.debug('Entered in updatePOLineItems LeaseOrderWizard');
        if(purchaseOrder.Order_Status__c == 'New'){
            if(purchaseOrderList == null || purchaseOrderList.size()==0)
                return isError;
            System.debug('Entered in updatePOLineItems in New');
            List<String> errMsgList;
            String errors = '';
            Date currentDate = Date.today();
            Date lastModifiedDate = date.newInstance((purchaseOrder.LastModifiedDate).year(), (purchaseOrder.LastModifiedDate).month(),(purchaseOrder.LastModifiedDate).day());
            // If the difference between current date and last modified date of purchase order
            // is greater than 1 day then update the po line items otherwise not
            if(currentDate >= lastModifiedDate.addDays(1) || isUpdate){
            //if(currentDate >= lastModifiedDate.addDays(1)){//for case # 00057947
                if(selProductItems == null){
                    selProductItems = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
                    }
                selProductItems.clear();
                //Step 1 make Wizard Step 1 if older than one day
                purchaseOrder.Order_Wizard_Step__c ='Step 1';
                wizardStepNumber ='1';
                for(Purchase_Order_Line__c poLine :purchaseOrderList){
                    System.debug('Here the item::'+poLine.Unit_Price__c);
                }
                //Check price and
                boolean isSmartPack =false;
                if(purchaseOrder.SunPower_Design__c != null)
                     isSmartPack =true;
                //Start for case # 00047219 - closed by customer
                errMsgList = PriceListItemUtilityLease.updatePOLineItems(purchaseOrderList,dealerAccount.Oracle_Operating_Unit__c,isSmartPack,purchaseOrder,isNAUser);
                //errMsgList = PriceListItemUtilityLease.updatePOLineItems(purchaseOrderList,dealerAccount.Oracle_Operating_Unit__c,isSmartPack,purchaseOrder,isNAUser, isEUUser);
                //End for case # 00047219 - closed by customer

                for(Purchase_Order_Line__c poLine :purchaseOrderList){
                    System.debug('Here the item List after Saving Prakash::'+poLine.Unit_Price__c);
                }
                if(errMsgList!= null && errMsgList.size() > 0 && errMsgList.get(0).indexof('PRICECHANGED:') >= 0){
                    //wizardStepNumber = '1';
                    errMsgList.clear();
                }else if(errMsgList!= null && errMsgList.size() > 0){
                    //selProductItems.clear();
                    isError = true;
                    for(String error : errMsgList){
                        if(error != null && (error.indexOf('PRICECHANGED:') >=0 || error.indexOf('NOITEMFOUND:')>=0)){
                            errors = errors + ' Purchase Order line items not found';
                            continue;
                        }
                        errors = errors + error;
                    }
                    errorOnTab = 1;
                    purchaseOrder.Order_Status__c = 'Error';
                    purchaseOrder.Order_Status_Interface_Message__c = errors;
                    showMessages(errMsgList);
                 }
                    InitilizeDesignProdItems();
                    updatePOrder(true);

                    calculateOrderPrice();
                    updatePOrder(false);
            }
        }
        if(isError) selProductItems.clear();
        return isError;
    }//function ends

    /** This function adds the error messages in apex page error,
     *  regarding the updatePOLineItems
     */
    private void showMessages(List<String> messages){
        for(String s :messages){
            if(s != null && s.indexOf('ERROR:')>=0){
                String[] split = s.split('\\:');
                if(split.size()>=2){
                    if(split[1].indexOf('ERROR:') >=0)
                        split[1] =split[1].replaceAll('ERROR:','\n');
                    else
                    split[1] = split[1] + '\n';
                }
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,split[1]);
                System.debug(split[1]);
                ApexPages.addMessage(errorMsg);
                //if(!isErrorFound) isErrorFound =true;
            }
        }
    }

    /** This function copy a price list item to wrapper object.
     *  @param Purchase_Order_Line__c
     *  @param LeaseOrderWizardController.PurchaseOrderLineItemWrapper
     */
    private void copyItemToWrapper(Purchase_Order_Line__c pLine, LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap){
        PriceListItemUtilityLease.copyItemToWrapper(purchaseOrder,pLine,pWrap);
    }

     /** This function deletes a price list item from the list of LeaseOrderWizardController.PurchaseOrderLineItemWrapper.
     *
     */
    public PageReference delItemFromList(){
        synchQuantity();
        changedQty='';
        if(hdnDelProdLineId == null || hdnDelProdLineId =='')
            return null;
        //Delete Item Product Wrap Here
            deleteFromProductWrapperList(hdnDelProdLineId);
        return null;
    }

    /** This function deletes a price list item from the list of LeaseOrderWizardController.PurchaseOrderLineItemWrapper.
     *  @param id
     */
    private void deleteFromProductWrapperList(String id){
        Integer kitItemCount=0;// For case 00057686
        if(selProductItems == null || selProductItems.size()==0) return;
        List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> tempProdList = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
        boolean removePromoDiscount=false; // For case 00057686

        for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrapProd:selProductItems){// For case 00057686
            if(wrapProd.itemID=='114556'){
                kitItemCount=kitItemCount+PriceListItemUtilityLease.covertStringToInt(wrapProd.Qty);
            }
        }
        for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrapProd:selProductItems){
            if(kitItemCount==1){
                removePromoDiscount=true;   // For case 00057686
            }

            if(wrapProd.ID != id && wrapProd.parentID != id){
                if(wrapProd.itemID=='135176' && removePromoDiscount){  // For case 00057686
                    continue;
                }else{
                    tempProdList.add(wrapProd);
                }
            }
            //Case#00058280
            else if(wrapProd.ID == id && wrapProd.itemCategory != null && wrapProd.itemCategory.equalsIgnoreCase('Inverter')){
                    invertersAdded--;
            }
        }
        selProductItems.clear();

        selProductItems.addAll(tempProdList);

        //Case#00058280
        PriceListItemUtilityLease.reEvaluatePVInverterPrice(dealerAccount.Oracle_Operating_Unit__c , selProductItems,invertersAdded,mapPVItems);
    }



    /*Section For Products List starts Here */
    public String singleAddedprodId{get;set;}

    public PageReference updateQuantity(){
        synchQuantity();
        changedQty='';
        return null;
    }

    /** This function takes the list of price lite items .
     *  @return  PageReference
     */
    public PageReference addItemToList(){
        synchQuantity();
        changedQty='';
        if(singleAddedprodId == null || singleAddedprodId=='' )
            return null;
        for(Price_List_Item__c prod:products){
            try{
                if(prod.ID == singleAddedprodId){
                    addProductItemToList(prod);
                }
            }catch(Exception e){

            }
        }
        return null;
    }

    /** This function adds a price list item to the list of selected price list items.
     *  @param  Price_List_Item__c
     */
    private void addProductItemToList(Price_List_Item__c prod){
        if (prod ==null) return;
        // to be changed for item-id
        String ChangeChildID='';
        String parentID ='';
        String localChangeQuantity='0.0';
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper productWrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper(prod.ID,'0.0',prod.Item_Description__c,prod.Type_2__c,String.valueof(inputQuantity),prod.CurrencyIsoCode,0.0,0.0,false,false);
        productWrapper.pOrderLine.Oracle_Warehouse__c = dealerAccount.Oracle_Warehouse__c;
        /* Newly added for disconnect Item starts*/
        if(prod.Disc_Item_ID__c !=null){
            productWrapper.childID=prod.Disc_Item_ID__c;
            productWrapper.childDescription = prod.Disc_Item_Description__c;
            productWrapper.childName=prod.Disc_Item_ID__r.Name;

        }
        /* Newly added for disconnect Item ends*/
        productWrapper.oracleItemIDRef = prod.Item_ID__c;
        productWrapper.itemID = prod.Item_ID__r.Name;
        if(selProductItems != null && selProductItems.size()>0){
            boolean isAdded =false;
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
                if(prodWrapper.ID == prod.ID){
                    prodWrapper.qty = String.valueOf(Integer.valueOf(prodWrapper.Qty) + Integer.valueOf(inputQuantity));
                    prodWrapper.totalPrice = calculateTotalPrice(prodWrapper.perUnitPrice, Integer.valueOf(prodWrapper.qty));
                    prodWrapper.pOrderLine.Price__c = calculateTotalPrice(prodWrapper.perUnitPrice, Integer.valueOf(prodWrapper.qty));
                    if(prodWrapper.childID != null && prodWrapper.childID != ''){
                        ChangeChildID= prodWrapper.childID;
                        localChangeQuantity =prodWrapper.qty;
                        parentID = prodWrapper.ID;
                    }

                    isAdded =true;
                    break;
                }
            }
            if(!isAdded){
                //LeaseOrderWizardController.PurchaseOrderLineItemWrapper(String ID,String lineNumber,String Name,String prodType,String Qty,Boolean isSmartPack,Boolean isFromDesign)
                counter++;
                if(productWrapper.childID != null && productWrapper.childID != '')
                    selProductItems.add(0,PriceListItemUtilityLease.addNewDisconnectItem(productWrapper));
                selProductItems.add(0,productWrapper);

                //Case#00058280
                productWrapper.itemCategory = prod.Category__c;
                if(prod.Category__c.equalsIgnoreCase('Inverter')){
                    invertersAdded++;
                }else if(prod.Category__c.equalsIgnoreCase('Module') && !mapPVItems.containsKey(prod.Item_ID__r.Name)){
                    mapPVItems.put(prod.Item_ID__r.Name,new LeaseOrderWizardController.PriceListItemWrapper(prod.Pricing_1__c));
                }

            }else if(ChangeChildID != null && ChangeChildID != '') {
                for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
                    if(prodWrapper.ID == ChangeChildID && parentID == prodWrapper.parentID ){
                        prodWrapper.Qty= localChangeQuantity;
                    }

                }
            }

        }else{
            if(selProductItems == null) {
                selProductItems = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
            }
            if(selProductItems.size() == 0){
                if(productWrapper.childID != null && productWrapper.childID != ''){
                    selProductItems.add(PriceListItemUtilityLease.addNewDisconnectItem(productWrapper));
                    selProductItems.add(0,productWrapper);
                }else
                    selProductItems.add(productWrapper);
            }else{
                if(productWrapper.childID != null && productWrapper.childID != '')
                    selProductItems.add(0,PriceListItemUtilityLease.addNewDisconnectItem(productWrapper));
                    selProductItems.add(0,productWrapper);
            }

            //Case#00058280
            productWrapper.itemCategory = prod.Category__c;

            if(prod.Category__c.equalsIgnoreCase('Inverter')){
                invertersAdded++;
            }else if(prod.Category__c.equalsIgnoreCase('Module') && !mapPVItems.containsKey(prod.Item_ID__r.Name)){
                mapPVItems.put(prod.Item_ID__r.Name,new LeaseOrderWizardController.PriceListItemWrapper(prod.Pricing_1__c));
            }
        }
        productWrapper.itemSource = 'Ala Carte';//for Case# 00077093
         //Case#00058280
        // PriceListItemUtilityLease.reEvaluatePVInverterPrice(dealerAccount.Oracle_Operating_Unit__c , selProductItems,invertersAdded,mapPVItems);

        if(productWrapper.itemID=='114556'){
            PriceListItemUtilityLease.addPromotionalDiscount(selProductItems,prod.Item_ID__r.Name);
        }
    }//Funtion ends

    public Decimal calculateTotalPrice(decimal unitPrice, integer qty){
        if(unitPrice != null)
            return unitPrice*qty;
        else
            return 0;
    }

    /**
    *   looks at material reimbursement cost and dealer fees list to create relevant line items
    */
    public void addLeaseItemsToList(){
        selLeaseProductItems.clear();
        leaseLineNameToIndex.clear();

        LeaseOrderSettings__c setting = LeaseOrderSettings__c.getInstance();
        String warehouseValue = '';
        if( setting != null )
        {
            warehouseValue = setting.Warehouse_Id__c;
        }

        System.debug( itemDescriptionToItem );
        //create Perf. Guar.
        if ( !leaseLineNameToIndex.containsKey( PERFORMANCE_GUARANTEE ) ) {
            LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper(
                                                                                                PERFORMANCE_GUARANTEE,'0.0',PERFORMANCE_GUARANTEE,'','1',
                                                                                                'USD', 1, 0, false, false);
            wrapper.pOrderLine.Oracle_Warehouse__c = warehouseValue;
            if( itemDescriptionToItem.containsKey( PERFORMANCE_GUARANTEE ) )
            {
                wrapper.pOrderLine.Oracle_Item_ID__c = itemDescriptionToItem.get( PERFORMANCE_GUARANTEE ).Id;
                wrapper.oracleItemIDRef = itemDescriptionToItem.get( PERFORMANCE_GUARANTEE ).Id;
                wrapper.itemID = itemDescriptionToItem.get( PERFORMANCE_GUARANTEE ).Name;
            }
            selLeaseProductItems.add( wrapper );
            leaseLineNameToIndex.put( PERFORMANCE_GUARANTEE, selLeaseProductItems.size() - 1);
        }

        /*if ( purchaseOrder.Material_Cost_Reimbursement__c != null ) {
            LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper(
                                                                                            MATERIAL_REIMBURSEMENT,'0.0',MATERIAL_REIMBURSEMENT,'',String.valueOf(purchaseOrder.Material_Cost_Reimbursement__c),
                                                                                            'USD', 1, purchaseOrder.Material_Cost_Reimbursement__c, false, false);
            wrapper.pOrderLine.Oracle_Warehouse__c = warehouseValue;
            if( itemDescriptionToItem.containsKey( MATERIAL_REIMBURSEMENT ) )
            {
                wrapper.pOrderLine.Oracle_Item_ID__c = itemDescriptionToItem.get( MATERIAL_REIMBURSEMENT ).Id;
                wrapper.itemID = itemDescriptionToItem.get( MATERIAL_REIMBURSEMENT ).Name;
            }
            selLeaseProductItems.add( wrapper );
            leaseLineNameToIndex.put( MATERIAL_REIMBURSEMENT, selLeaseProductItems.size() - 1);
        }*/

        if ( purchaseOrder.Dealer_Fees__c != null ) {

            Decimal origFee = LEASE_ORIGINATION_PERCENTAGE * purchaseOrder.Dealer_Fees__c;
            origFee = origFee.setScale( 0, System.RoundingMode.HALF_UP );

            LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper(
                                                                                            LEASE_ORIGINATION,'0.0',LEASE_ORIGINATION,'',String.valueOf(origFee),
                                                                                            'USD', 1, origFee, false, false);
            wrapper.pOrderLine.Oracle_Warehouse__c = warehouseValue;
            if( itemDescriptionToItem.containsKey( LEASE_ORIGINATION ) )
            {
                wrapper.pOrderLine.Oracle_Item_ID__c = itemDescriptionToItem.get( LEASE_ORIGINATION ).Id;
                wrapper.oracleItemIDRef = itemDescriptionToItem.get( LEASE_ORIGINATION ).Id;
                wrapper.itemID = itemDescriptionToItem.get( LEASE_ORIGINATION ).Name;
            }
            selLeaseProductItems.add( wrapper );
            leaseLineNameToIndex.put( LEASE_ORIGINATION, selLeaseProductItems.size() - 1);


            /***********************/
            Decimal constructFee = LEASE_INSTALLATION_PERCENTAGE * purchaseOrder.Dealer_Fees__c;
            constructFee = constructFee.setScale( 0, System.RoundingMode.HALF_UP );

            wrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper( LEASE_INSTALLATION,'0.0',LEASE_INSTALLATION,'',String.valueOf(constructFee),
                                                                                        'USD', 1, constructFee, false, false);
            wrapper.pOrderLine.Oracle_Warehouse__c = warehouseValue;
            if( itemDescriptionToItem.containsKey( LEASE_INSTALLATION ) )
            {
                wrapper.pOrderLine.Oracle_Item_ID__c = itemDescriptionToItem.get( LEASE_INSTALLATION ).Id;
                wrapper.oracleItemIDRef = itemDescriptionToItem.get( LEASE_INSTALLATION ).Id;
                wrapper.itemID = itemDescriptionToItem.get( LEASE_INSTALLATION ).Name;
            }
            selLeaseProductItems.add( wrapper );
            leaseLineNameToIndex.put( LEASE_INSTALLATION, selLeaseProductItems.size() - 1);


            /***********************/
            Decimal connectFee = purchaseOrder.Dealer_Fees__c - origFee - constructFee;

            wrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper( LEASE_INTERCONNECT,'0.0',LEASE_INTERCONNECT,'',String.valueOf(connectFee),
                                                                                        'USD', 1, connectFee, false, false);
            wrapper.pOrderLine.Oracle_Warehouse__c = warehouseValue;
            if( itemDescriptionToItem.containsKey( LEASE_INTERCONNECT ) )
            {
                wrapper.pOrderLine.Oracle_Item_ID__c = itemDescriptionToItem.get( LEASE_INTERCONNECT ).Id;
                wrapper.oracleItemIDRef = itemDescriptionToItem.get( LEASE_INTERCONNECT ).Id;
                wrapper.itemID = itemDescriptionToItem.get( LEASE_INTERCONNECT ).Name;
            }
            selLeaseProductItems.add( wrapper );
            leaseLineNameToIndex.put( LEASE_INTERCONNECT, selLeaseProductItems.size() - 1);
        }
    }

    /** This function initializes standard set controller of price list items.
     *
     */
    private void initilizeSetCon(){
        PAGINATION_COUNTER=5;
        PAGINATION_COUNTERONPAGE=0;
        if(dealerAccount != null){
             // for purchase order having design id fetch only BOS Category products otherwise all
             if(ApexPages.currentPage().getParameters().get('DID') == null && purchaseOrder.SunPower_Design__c == null){
                // to be changed for item-id
                setCon = PriceListItemUtilityLease.getPriceListForDealer2AlaCarteLease(ORACLE_OPERATING_UNIT);
             }else{
                // to be changed for item-id
                setCon = PriceListItemUtilityLease.getPriceListForDealer2AlaCarteAndBOSLease(ORACLE_OPERATING_UNIT);
             }
            if(setCon != null && setCon.getResultSize() != 0){
                if(setCon.getResultSize() < (PAGINATION_COUNTERONPAGE+PAGINATION_COUNTER)){
                    PAGINATION_COUNTERONPAGE = setCon.getResultSize() - PAGINATION_COUNTER;
                }
                else
                    PAGINATION_COUNTERONPAGE = PAGINATION_COUNTER;
                setCon.setPageSize(PAGINATION_COUNTER);
                products = (List<Price_List_Item__c>) setCon.getRecords();
            }else{
                products = new List<Price_List_Item__c>();
            }
        }
    }

    public PageReference moveProductsShowLink(){
        PAGINATION_COUNTER = PAGINATION_COUNTER + PAGINATION_COUNTERONPAGE;
        if(selectedCategory != null){
            //setCon = PriceListItemUtilityLease.getPriceListForDealer2_FilterType2AlaCarte(dealerAccount.id,selectedCategory,prodNameFilter);//removed for case # 00047707
            setCon = PriceListItemUtilityLease.getPriceListForDealer2_FilterType2AlaCarteLease(ORACLE_OPERATING_UNIT,selectedCategory,prodDescFilter);//added for case # 00047707
            if(setCon != null){
                if(setCon.getResultSize() != 0){
                    if(setCon.getResultSize() <= (PAGINATION_COUNTERONPAGE+PAGINATION_COUNTER))
                        PAGINATION_COUNTERONPAGE = setCon.getResultSize() - PAGINATION_COUNTER;
                    else
                        PAGINATION_COUNTERONPAGE = PAGINATION_COUNTER;
                    setCon.setPageSize(PAGINATION_COUNTER);
                }
            }
        }else{
            initilizeSetCon();
        }
        return null;
    }

    /** This function is responsible to filter the price list items according to type.
     *  @return  PageReference
     */
    public PageReference moveAccordingToFilter(){
        if(selectedCategory != null){
            PAGINATION_COUNTER=5;
            PAGINATION_COUNTERONPAGE = 5;
            //setCon = PriceListItemUtilityLease.getPriceListForDealer2_FilterType2AlaCarte(dealerAccount.id,selectedCategory,prodNameFilter);//removed for case # 00047707
            setCon = PriceListItemUtilityLease.getPriceListForDealer2_FilterType2AlaCarteLease(ORACLE_OPERATING_UNIT,selectedCategory,prodDescFilter);//added for case # 00047707
            if(setCon != null){
                if(setCon.getResultSize() != 0){
                    if(setCon.getResultSize() <= (PAGINATION_COUNTERONPAGE+PAGINATION_COUNTER))
                        PAGINATION_COUNTERONPAGE = setCon.getResultSize() - PAGINATION_COUNTER;
                    else
                        PAGINATION_COUNTERONPAGE = PAGINATION_COUNTER;
                   setCon.setPageSize(PAGINATION_COUNTER);
                }
            }
        }else{
            initilizeSetCon();
        }
        return null;
    }

    /** This getter function is to get the records from standard set controller
     *  and set them to list of price list items.
     *  @return  List<Price_List_Item__c>
     */
    public List<Price_List_Item__c> getProducts(){
        if(setCon == null){
            initilizeSetCon();
        }
        if(setCon != null) {
            if(setCon.getResultSize() != 0){

                products = (List<Price_List_Item__c>) setCon.getRecords();
            }
            else
                products = new List<Price_List_Item__c>();
            return products;
        }
        return null;
    }

    /** This function is responsible to navigate to next set of records in pagination.
     *  @return  PageReference
     */
    public PageReference moveNext(){
        if(setCon != null)
            setCon.next();
        return null;
    }

    /** This function is responsible to navigate to previous set of records in pagination.
     *  @return  PageReference
     */
    public PageReference movePrevious(){
        if(setCon != null)
            setCon.previous();
        return null;
    }

    /** Formatting the ShipToSiteAddress in proper way.
     *  @param  Ship_to_Site__c
     */
    private void setFormatedShipToSiteAddress(Ship_to_Site__c shipSite ){
        if(shipSite != null){
            shipToSiteAddress='';
            if(shipSite.Contact_Email__c == null && shipSite.Contact_First_Name__c == null
                    && shipSite.Contact_Last_Name__c == null && shipSite.Contact_Phone__c == null ){
                renderShipToBlock = false;
            }else{
                renderShipToBlock = true;
            }
            this.shipSite = shipSite;
            if(shipSite.Address1__c != null){
                shipToSiteAddress+=shipSite.Address1__c + ' ';
            }if(shipSite.Address2__c != null){
                shipToSiteAddress+=shipSite.Address2__c + ' ';
            }if(shipSite.Address3__c != null){
                shipToSiteAddress+=shipSite.Address3__c + ' ';
            }
            if(shipSite.City__c != null)
                shipToSiteAddress+=shipSite.City__c +', ';
            if(shipSite.State__c != null)
                shipToSiteAddress+=shipSite.State__c +', ';
            if(shipSite.Zip__c != null)
                shipToSiteAddress+=shipSite.Zip__c +', ';
            if(shipSite.Country__c != null)
                shipToSiteAddress+=shipSite.Country__c +' ';
        selectedShipToSiteID= shipSite.ID;
        }
        //shipToSiteAddress
    }

    /** Formatting the BillToSiteAddress in proper way.
     *  @param Purchase_Order__c
     */
    private void setFormatedBillToSiteAddress(Purchase_Order__c pOrder ){
        if(pOrder != null){
            if(pOrder.Bill_to_Site__c != null){
                billToSiteAddress='';
                if(pOrder.Bill_to_Site__r.Address1__c != null){
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Address1__c + ' ';
                }if(pOrder.Bill_to_Site__r.Address2__c != null){
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Address2__c + ' ';
                }if(pOrder.Bill_to_Site__r.Address3__c != null){
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Address3__c + ' ';
                }
                if(pOrder.Bill_to_Site__r.City__c != null)
                    billToSiteAddress+=pOrder.Bill_to_Site__r.City__c +', ';
                if(pOrder.Bill_to_Site__r.State__c != null)
                    billToSiteAddress+=pOrder.Bill_to_Site__r.State__c +', ';
                if(pOrder.Bill_to_Site__r.Zip__c != null)
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Zip__c +', ';
                if(pOrder.Bill_to_Site__r.Country__c != null)
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Country__c +' ';
            }
        }
    }

    /** This function set shipToSite for dealer and customer opportunities.
     *  @return PageReference
     */
    private void setDealerAndCustomerShipToSites(){
        String qry = '';
        if(dealerAccount != null){
            qry+= 'Select s.Type__c, s.RecordType.DeveloperName,s.Residential_Customer_Account__c,s.Zip__c, s.ID,s.State__c, s.Dealer_Account__c, s.Country__c, s.City__c, s.Address3__c, s.Address2__c, s.Address1__c, s.Contact_Email__c, s.Contact_First_Name__c, s.Contact_Last_Name__c, s.Contact_Phone__c From Ship_to_Site__c s where s.Dealer_Account__c = \''+dealerAccount.id +'\'';
            //qry+= 'Select s.Type__c, s.RecordType.DeveloperName,s.Residential_Customer_Account__c,s.Zip__c, s.ID,s.State__c, s.Dealer_Account__c, s.City__c, s.Address3__c, s.Address2__c, s.Address1__c, s.Contact_Email__c, s.Contact_First_Name__c, s.Contact_Last_Name__c, s.Contact_Phone__c From Ship_to_Site__c s where s.Dealer_Account__c = \''+dealerAccount.id +'\'';
            for(Ship_To_Site__c sh:Database.query(qry)){
                if(sh.Residential_Customer_Account__c != null && customersAccountsIDs.contains(sh.Residential_Customer_Account__c) && sh.Dealer_Account__c != null && sh.Dealer_Account__c == dealerAccount.ID){
                    if(customerShiptoSiteMap == null) customerShiptoSiteMap = new Map<ID,Ship_To_Site__c>();
                    customerShiptoSiteMap.put(sh.ID,sh);
                }
                //else
                if(sh.Dealer_Account__c != null && sh.Dealer_Account__c == dealerAccount.ID){
                    if(dealerShiptoSiteMap == null) dealerShiptoSiteMap = new Map<ID,Ship_To_Site__c>();
                    dealerShiptoSiteMap.put(sh.ID,sh);
                }
            }
        }
    }

    /** set dealer shipping address.
     */
    private void setDealerShippingAddress(){
        if(dealerAccount != null){
            dealerAccountShippingAddress = getAddressFromAccount( dealerAccount );
        }
    }

    private String getAddressFromAccount( Account account )
    {
        String addressString = '';

        if(account.ShippingStreet != null)
            addressString += account.ShippingStreet + ', ';
        if(account.ShippingCity!= null)
            addressString += account.ShippingCity + ', ';
        if(account.ShippingState != null)
            addressString += account.ShippingState + ', ';
        if(account.ShippingPostalCode != null)
            addressString += account.ShippingPostalCode + ', ';
        if(account.ShippingCountry != null)
            addressString += account.ShippingCountry;

        return addressString;
    }

    /**set the Dealer Address in shipToSite Object.
     */
    public PageReference setDealerAddressToShipToSite(){
        if(dealerAccount != null){
            Ship_to_Site__c shipSiteNew;
            String uniqueAddressKey='';
            uniqueAddressKey = dealerAccount.ShippingStreet == null ?  '' :dealerAccount.ShippingStreet;
            uniqueAddressKey = uniqueAddressKey + (dealerAccount.ShippingCity == null ? '' : dealerAccount.ShippingCity);
            uniqueAddressKey = uniqueAddressKey + (dealerAccount.ShippingState == null ? '' : dealerAccount.ShippingState);
            uniqueAddressKey = uniqueAddressKey + (dealerAccount.ShippingPostalCode == null ? '' : dealerAccount.ShippingPostalCode);
            uniqueAddressKey = uniqueAddressKey + (dealerAccount.ShippingCountry == null ? '' : dealerAccount.ShippingCountry);
            List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c,Country__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID  LIMIT 1];
            //List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID  LIMIT 1];
            if(listShipSites != null && listShipSites.size() > 0){
                purchaseOrder.Ship_to_Site__c =  listShipSites.get(0).ID;
                purchaseOrder.Ship_to_Site__r = listShipSites.get(0);
            }else{
                shipSiteNew = new  Ship_to_Site__c();
                shipSiteNew.Address1__c=dealerAccount.ShippingStreet;
                shipSiteNew.State__c=dealerAccount.ShippingState;
                shipSiteNew.Country__c = dealerAccount.ShippingCountry;
                shipSiteNew.Zip__c = dealerAccount.ShippingPostalCode;
                shipSiteNew.City__c = dealerAccount.ShippingCity;
                shipSiteNew.Dealer_Account__c = dealerAccount.ID;
                //Start for case#00078901
                if(dealerAccount.ShippingCountry == null || dealerAccount.ShippingCountry == ''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardCountryRequiredMssg));
                    errorOnTab=3;
                    return null;
                }
                //End for case#00078901
                if((dealerAccount.ShippingState =='' || dealerAccount.ShippingState==null) && (dealerAccount.ShippingCountry == 'United States' || dealerAccount.ShippingCountry =='US' || dealerAccount.ShippingCountry == 'USA' || dealerAccount.ShippingCountry == 'United States of America' )){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardStateRequiredMssg));
                    errorOnTab=3;
                    return null;
                }
                insert shipSiteNew;
                purchaseOrder.Ship_to_Site__c = shipSiteNew.ID;
                purchaseOrder.Ship_to_Site__r = shipSiteNew;
            }
            update purchaseOrder;
            setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
        }
        return null;
    }

    public PageReference setEndUserAddressToShipToSite(){
        if(endUserAccount != null){
            Ship_to_Site__c shipSiteNew;
            String uniqueAddressKey='';
            uniqueAddressKey = endUserAccount.ShippingStreet == null ?  '' :endUserAccount.ShippingStreet;
            uniqueAddressKey = uniqueAddressKey + (endUserAccount.ShippingCity == null ? '' : endUserAccount.ShippingCity);
            uniqueAddressKey = uniqueAddressKey + (endUserAccount.ShippingState == null ? '' : endUserAccount.ShippingState);
            uniqueAddressKey = uniqueAddressKey + (endUserAccount.ShippingPostalCode == null ? '' : endUserAccount.ShippingPostalCode);
            uniqueAddressKey = uniqueAddressKey + (endUserAccount.ShippingCountry == null ? '' : endUserAccount.ShippingCountry);
            List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c,Country__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:endUserAccount.ID  LIMIT 1];
            if(listShipSites != null && listShipSites.size() > 0){
                purchaseOrder.Ship_to_Site__c =  listShipSites.get(0).ID;
                purchaseOrder.Ship_to_Site__r = listShipSites.get(0);
            }else{
                shipSiteNew = new  Ship_to_Site__c();
                shipSiteNew.Address1__c=endUserAccount.ShippingStreet;
                shipSiteNew.State__c=endUserAccount.ShippingState;
                shipSiteNew.Country__c = endUserAccount.ShippingCountry;
                shipSiteNew.Zip__c = endUserAccount.ShippingPostalCode;
                shipSiteNew.City__c = endUserAccount.ShippingCity;
                shipSiteNew.Dealer_Account__c = endUserAccount.ID;
                //Start for case#00078901
                if(endUserAccount.ShippingCountry == null || endUserAccount.ShippingCountry == ''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardCountryRequiredMssg));
                    errorOnTab=3;
                    return null;
                }
                //End for case#00078901
                if((endUserAccount.ShippingState =='' || endUserAccount.ShippingState==null)
                    && (endUserAccount.ShippingCountry == 'United States'
                        || endUserAccount.ShippingCountry =='US'
                        || endUserAccount.ShippingCountry == 'USA'
                        || endUserAccount.ShippingCountry == 'United States of America' ) ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardStateRequiredMssg));
                    errorOnTab=3;
                    return null;
                }
                insert shipSiteNew;
                purchaseOrder.Ship_to_Site__c = shipSiteNew.ID;
                purchaseOrder.Ship_to_Site__r = shipSiteNew;
            }
            update purchaseOrder;
            setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
        }
        return null;
    }

     public PageReference setOppBillingAddressToShipToSite(){
        Account acc = getCustOpportunity(selectedCustomerOpportunity).Account;

        if(dealerAccount != null && acc!=null){
            Ship_to_Site__c shipSiteNew;
            String uniqueAddressKey='';
            uniqueAddressKey = acc.BillingStreet == null ?  '' :acc.BillingStreet;
            uniqueAddressKey = uniqueAddressKey + (acc.BillingCity == null ? '' : acc.BillingCity);
            uniqueAddressKey = uniqueAddressKey + (acc.BillingState == null ? '' : acc.BillingState);
            uniqueAddressKey = uniqueAddressKey + (acc.BillingPostalCode == null ? '' : acc.BillingPostalCode);
            uniqueAddressKey = uniqueAddressKey + (acc.BillingCountry == null ? '' : acc.BillingCountry);
            List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c,Country__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID and Residential_Customer_Account__c =:acc.ID  LIMIT 1];
            //List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID and Residential_Customer_Account__c =:acc.ID  LIMIT 1];
            if(listShipSites != null && listShipSites.size() > 0){
                purchaseOrder.Ship_to_Site__c =  listShipSites.get(0).ID;
                purchaseOrder.Ship_to_Site__r = listShipSites.get(0);
            }else{
                shipSiteNew = new  Ship_to_Site__c();
                shipSiteNew.Address1__c=acc.BillingStreet;
                shipSiteNew.State__c=acc.BillingState;
                shipSiteNew.Country__c = acc.BillingCountry;
                shipSiteNew.Zip__c = acc.BillingPostalCode;
                shipSiteNew.City__c = acc.BillingCity;
                shipSiteNew.Dealer_Account__c = dealerAccount.ID;
                shipSiteNew.Residential_Customer_Account__c = acc.ID;
                shipSiteNew.RecordTypeId =recTypes.get('Opportunity');
                //Start for case#00078901
                if(acc.BillingCountry == null || acc.BillingCountry == ''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardBCountryRequiredMssg));
                    errorOnTab=3;
                    return null;
                }
                if((acc.BillingState =='' || acc.BillingState==null) && (acc.BillingCountry == 'United States' || acc.BillingCountry =='US' || acc.BillingCountry == 'USA' || acc.BillingCountry == 'United States of America' )){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardBStateRequiredMssg));
                    errorOnTab=3;
                    return null;
                }
                //End for case#00078901
                insert shipSiteNew;
                purchaseOrder.Ship_to_Site__c = shipSiteNew.ID;
                purchaseOrder.Ship_to_Site__r = shipSiteNew;
            }
            update purchaseOrder;
            setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
        }
        return null;
    }

     public PageReference setOppShippingAddressToShipToSite(){
        Account acc = getCustOpportunity(selectedCustomerOpportunity).Account;
        if(dealerAccount != null && acc !=null){
            Ship_to_Site__c shipSiteNew;
            String uniqueAddressKey='';
            uniqueAddressKey = acc.ShippingStreet == null ?  '' :acc.ShippingStreet;
            uniqueAddressKey = uniqueAddressKey + (acc.ShippingCity == null ? '' : acc.ShippingCity);
            uniqueAddressKey = uniqueAddressKey + (acc.ShippingState == null ? '' : acc.ShippingState);
            uniqueAddressKey = uniqueAddressKey + (acc.ShippingPostalCode == null ? '' : acc.ShippingPostalCode);
            uniqueAddressKey = uniqueAddressKey + (acc.ShippingCountry == null ? '' : acc.ShippingCountry);
            // Changes
            List<Ship_to_Site__c> listShipSites = [Select Id, Contact_First_Name__c, Contact_Last_Name__c, Contact_Phone__c, Address1__c,Address2__c,Address3__c, Contact_Email__c, City__c,State__c,Zip__c,Country__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID and Residential_Customer_Account__c =:acc.ID  LIMIT 1];
            if(listShipSites != null && listShipSites.size() > 0){
                purchaseOrder.Ship_to_Site__c =  listShipSites.get(0).ID;
                purchaseOrder.Ship_to_Site__r = listShipSites.get(0);
            }else{
                shipSiteNew = new  Ship_to_Site__c();
                shipSiteNew.Address1__c=acc.ShippingStreet;
                shipSiteNew.State__c=acc.ShippingState;
                shipSiteNew.Country__c = acc.ShippingCountry;
                shipSiteNew.Zip__c = acc.ShippingPostalCode;
                shipSiteNew.City__c = acc.ShippingCity;
                shipSiteNew.Dealer_Account__c = dealerAccount.ID;
                shipSiteNew.Residential_Customer_Account__c = acc.ID;
                shipSiteNew.RecordTypeId =recTypes.get('Opportunity');
                //Start for case#00078901
                if(acc.ShippingCountry == null || acc.ShippingCountry == ''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardCountryRequiredMssg));
                    errorOnTab=3;
                    return null;
                }
                //End for case#00078901
                if((acc.ShippingState =='' || acc.ShippingState==null) && (acc.ShippingCountry == 'United States' || acc.ShippingCountry =='US' || acc.ShippingCountry == 'USA' || acc.ShippingCountry == 'United States of America' )){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardStateRequiredMssg));
                    errorOnTab=3;
                    return null;
                }
                insert shipSiteNew;
                purchaseOrder.Ship_to_Site__c = shipSiteNew.ID;
                purchaseOrder.Ship_to_Site__r = shipSiteNew;
            }
            update purchaseOrder;
            setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
        }
        return null;
    }

    public List<Ship_To_Site__c> dealerWAREShipToSiteValues{get;set;}
    public List<Ship_To_Site__c> dealerRESIShipToSiteValues{get;set;}

    /** This function set the ship to site for purchase order.
     */
    public PageReference setPOShipToSite(){
        if(selectedShipToSiteID == null || selectedShipToSiteID =='')
            return null;
        Ship_to_Site__c localShipSite = null;

        if(dealerShiptoSiteMap != null && dealerShiptoSiteMap.size()>0)
            localShipSite = dealerShiptoSiteMap.get(selectedShipToSiteID);
        else{
            dealerShiptoSiteMap = new Map<ID,Ship_to_Site__c>();
            dealerWAREShipToSiteValues = new List<Ship_to_Site__c>();
            dealerRESIShipToSiteValues  = new List<Ship_to_Site__c>();
        }

        if(localShipSite != null){
            purchaseOrder.Ship_to_Site__c = localShipSite.ID;
            update purchaseOrder;
            setFormatedShipToSiteAddress(localShipSite);
        }else{
            for(Ship_to_Site__c site:[Select s.Type__c,s.RecordType.DeveloperName,s.Residential_Customer_Account__c,s.Zip__c, s.ID,s.State__c, s.Dealer_Account__c, s.Country__c, s.City__c, s.Address3__c, s.Address2__c, s.Address1__c, s.Contact_Email__c, s.Contact_First_Name__c, s.Contact_Last_Name__c, s.Contact_Phone__c From Ship_to_Site__c s where id =:selectedShipToSiteID LIMIT 1]){
            //for(Ship_to_Site__c site:[Select s.Type__c,s.RecordType.DeveloperName,s.Residential_Customer_Account__c,s.Zip__c, s.ID,s.State__c, s.Dealer_Account__c,s.City__c, s.Address3__c, s.Address2__c, s.Address1__c, s.Contact_Email__c, s.Contact_First_Name__c, s.Contact_Last_Name__c, s.Contact_Phone__c From Ship_to_Site__c s where id =:selectedShipToSiteID LIMIT 1]){
                purchaseOrder.Ship_to_Site__c=site.ID;
                dealerShiptoSiteMap.put(site.ID,site);
                resetDealersShipValues();
                setFormatedShipToSiteAddress(site);
            }
        }
        errorOnTab=0;
        return null;
    }

    public PageReference setPOShipToSiteContact(){
         if(selectedShipToSiteConID == null || selectedShipToSiteConID =='')
            return null;
         Contact con =null;
         if(currentOpportunityContactsMap != null)
            con =currentOpportunityContactsMap.get(selectedShipToSiteConID);
         if(con ==null && currentDealersContactsMap!= null)
            con = currentDealersContactsMap.get(selectedShipToSiteConID);
         if(con ==null){
            for(Contact c :[select id,firstname,LastName,email from Contact where id =:selectedShipToSiteConID Limit 1])
                con=c;
            currentDealersContactsMap = PriceListItemUtilityLease.getContactsInMap(dealerAccount.ID);
            if(selectedOpportunity != null)
                currentOpportunityContactsMap = PriceListItemUtilityLease.getContactsInMap(selectedOpportunity.Account.ID);
         }
         if(con !=null){
            purchaseOrder.Ship_To_Contact__c =con.ID;
            purchaseOrder.Ship_To_Contact__r = con;
            update purchaseOrder;
         }
     return null;
    }

    /** on Page Load when Page open with contating Design ID.
     */
    public PageReference updatePOOnAction(){
        // START - Check added for redirecting on basis of Partner or Standard user
        // If internal user then redirect to VF page "LeaseOrderWizardInt".
        // IF condition is added here and the existing logic has been put in related ELSE
        if(isStandardUser && purchaseOrder.ID != null){
        PageReference pgint = new PageReference('/apex/LeaseOrderWizardInternal?id='+purchaseOrder.Id);
        return pgint.setRedirect(true);
        }
        else{
        if(isUserAuthorized && isPartnerUser){
            if(isNewOrder && purchaseOrder != null && selectedDesign == null && designID != null){
                showErrorBlock = true;
                errorOnTab = 0;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardErrorMsgDesignItemInActive);
                ApexPages.addMessage(errorMsg);
            }else if(isNewOrder && purchaseOrder != null){
                purchaseOrder.Order_Wizard_Step__c ='Step 1';
                updatePOrder(true);
            }else if(purchaseOrder != null && !isNewOrder){

                Boolean isError = updatePOLineItems();
                if(isError)  {
                    PageReference pg = new PageReference('/apex/PurchaseOrderWizard?POID='+purchaseOrder.Id);
                    return pg.setRedirect(true);
                }
            }
        }else if(!isPartnerUser){
            //Come here when Non PArtner User came for creating a new order
            if(purchaseOrder == null || purchaseOrder.ID == null){
                showErrorBlock = true;
                errorOnTab = 0;
                isNewOrder = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardErrorMsgPOCreationOrInvalidID);
                ApexPages.addMessage(errorMsg);
            }else if(purchaseOrder.Order_Status__c != null && purchaseOrder.Order_Status__c !='Error'){
                isOrderSubmitted = true;
                //custom label for View Order
                submitOrderLabel = System.Label.POWizardViewOrderTitle;
                submitOrderTitle = '';
            }else if(purchaseOrder.Order_Status__c != null && purchaseOrder.Order_Status__c =='Error'){
                //Do as normal done by Partner User
            }
        }
        if(isNAUser || isEUUser || !isPartnerUser)
            termsDocID = PriceListItemUtilityLease.getTermsDocumentsID(dealerAccount);
        return null;
        }
    }

    /** This function resets the Dealer ship to site values .
     */
    private void resetDealersShipValues(){
        if(dealerWAREShipToSiteValues != null) dealerWAREShipToSiteValues.clear();
        if(dealerRESIShipToSiteValues != null) dealerRESIShipToSiteValues.clear();
        if(dealerShiptoSiteMap  != null && dealerShiptoSiteMap.values().size()>0){
            if(dealerWAREShipToSiteValues == null) dealerWAREShipToSiteValues = new List<Ship_to_Site__c>();
            if(dealerRESIShipToSiteValues == null) dealerRESIShipToSiteValues = new List<Ship_to_Site__c>();
            for(Ship_to_Site__c s:dealerShiptoSiteMap.values()){
                if(s.Type__c != null && s.Type__c.indexOf('Residential')>=0 && s.RecordType.developerName =='Installation_Site')
                    dealerRESIShipToSiteValues.add(s);
                else if(s.RecordType.developerName =='Dealer_Warehouse')
                    dealerWAREShipToSiteValues.add(s);
            }
        }
   }//function ends

   //This Function calculate Day Difference
    /** This function calculates day diference.
     */
    public void calcDayDifference(){
        /*This code added temnporarily becasue code going to push on PRoduction and some changed done regarding accept Delivery Charges*/
        //start
        if(isEUUser){
            isShowCheckbox =false;
            return;
        }
        //end
        if(userCurrentTime != null && purchaseOrder != null && purchaseOrder.Requested_Delivery_Date__c !=null){
            System.debug('In Calc Difference:::userCurrentTimeHour:::::::'+userCurrentTimeHour);
            Date dateToCheck = Date.newInstance(userCurrentTime.yearGMT(),userCurrentTime.monthGMT() ,userCurrentTime.dayGMT());
            Date userCurrentDate = Date.newInstance(userCurrentTime.yearGMT(),userCurrentTime.monthGMT() ,userCurrentTime.dayGMT());
            Integer checkHours = 13;//
            checkHours=(isEUUser)?13 : 14; //

            if(userCurrentTimeHour < checkHours){//
                //dateToCheck = dateToCheck.addDays(2); //3 Commented by Praksh for 3 days PR-03873
                dateToCheck = PriceListItemUtilityLease.getNextWorkingDate(dateToCheck,2);
            }else{
                //dateToCheck = dateToCheck.addDays(3); //4 Commented by Praksh for 4 days PR-03873
                dateToCheck = PriceListItemUtilityLease.getNextWorkingDate(dateToCheck,3);
            }

            if(dateToCheck >= purchaseOrder.Requested_Delivery_Date__c && purchaseOrder.Requested_Delivery_Date__c >= Date.Today()){
                isShowCheckbox =true;
                purchaseOrder.Delivery_Charges__c = expediteFeeForPriceList;
            }else{
                isShowCheckbox =false;
                purchaseOrder.Accept_Expedited_Delivery_Charges__c =false;
                purchaseOrder.Delivery_Charges__c = 0.0;
            }
        }
    }

     /** This function is to synchronize the quantity values of price list items.
     */
     private void synchQuantity(){
        PriceListItemUtilityLease.synchQuantity(selProductItems, changedQty, recordSep, dataSep);
     }

    private void updateLineNumbersForOrder(){
        PriceListItemUtilityLease.updateLineNumbersForOrder(purchaseOrderList);
    }

    /** This function insert Purchase Order Line Items and Update the Wrapper List accordingly.
     */
    private  void insertListAndUpdateWrapper(){
        PriceListItemUtilityLease.insertListAndUpdateWrapper(purchaseOrder, purchaseOrderList, selectedProductsToShow);
    }

    private void calculateOrderPrice(){
        PriceListItemUtilityLease.calculateOrderPrice(purchaseOrder, selectedProductsToShow, serviceCreditSMSItemId);
    }

    private List<Purchase_Order_Line__c> getSortedList(List<Purchase_Order_Line__c> purLines){
        return PriceListItemUtilityLease.getSortedList(purLines);
    }

     public List<SelectOption> getShippingMethods(){
       return PriceListItemUtilityLease.getShippingMethods(selectedPriceList);
   }

    public List<SelectOption> getCategories(){
      // Done for request to allow ‘EU Residential Installer’ profile to Order only Modulo and Inverter.
        // return PriceListItemUtilityLease.getCategories(purchaseOrder,ApexPages.currentPage().getParameters());
        List<SelectOption> categories = PriceListItemUtilityLease.getCategories(purchaseOrder,ApexPages.currentPage().getParameters(), isUserEUResidentialInstaller);
        List<SelectOption> parsedCategories = new List<SelectOption>();
        for (SelectOption category : categories) {
            if (category.getLabel() != 'BoS') {
                parsedCategories.add(category);
            }
        }
        return parsedCategories;
   }

   private void fillWrapperRestFields(List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems){
        PriceListItemUtilityLease.fillWrapperRestFields(selProductItems);
   }

   private static Opportunity getCustOpportunity(String id){
        Opportunity opp =null;
        for(Opportunity o:[select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where id = :id Limit 1])
            opp=o;
        return opp;
   }

   //Case#00058280
     /** Inner class PriceListItemWrapper.
     *
     */
    public class PriceListItemWrapper{
        public Decimal alaCarte {get;set;}
        public Decimal pvInverter {get;set;}

        public PriceListItemWrapper(Decimal alaCarte){
            this.alaCarte = alaCarte;
        }

        public Decimal getItem(Boolean isAlaCarte){
            return isAlaCarte? alaCarte : pvInverter;
        }
    }
    //Case#00058280

    /** Inner class PurchaseOrderLineItemWrapper.
     *
     */
    public class PurchaseOrderLineItemWrapper{
        public String ID {get;set;}
        public String lineNumber {get;set;}
        public String Name{get;set;}
        public String prodType{get;set;}
        public String Qty{get{
            if(Qty!=null && Qty!=''){
                Integer result =Qty.indexOf('.');
                if(result!= -1){
                    Qty= Qty.substring(0,result);
                }
            }
            return Qty;
        }
            set;}
        public boolean isSmartPack{get;set;}
        public boolean isFromDesign{get;set;}
        public boolean isChild{get;set;}
        public String itemID{get;set;}
        public ID oracleItemIDRef{get;set;}
        public Boolean isExisting{get;set;}
        public String currencyCode{get;set;}
        public decimal perUnitPrice{get;set;}
        public decimal totalPrice{get;set;}
        public Purchase_Order_Line__c pOrderLine {get;set;}
        public String type1{get;set;}
        public String type2{get;set;}
        public String type3{get;set;}
        public String childID{get;set;}
        public String childDescription{get;set;}
        public String childName{get;set;}
        public String parentID{get;set;}
        public String itemSource{get;set;}//for Case# 00077093
        public String itemDescription{get;set;}//BY BIRLASOFT - for Item Description

        //Case#00058280
        public String itemCategory{get;set;}
        public String itemType{get;set;}//done by Jitendra for Case#00058280

        public PurchaseOrderLineItemWrapper(){
            pOrderLine = new Purchase_Order_Line__c();
            isExisting =false;
        }
       public PurchaseOrderLineItemWrapper(String ID,String lineNumber,String Name,String prodType,String Qty,Boolean isSmartPack,Boolean isFromDesign){
            isExisting =false;
            isChild =false;
            this.pOrderLine = new Purchase_Order_Line__c();
            this.ID = ID;
            this.lineNumber = lineNumber;
            this.Name=Name;
            this.prodType=prodType;
            this.Qty=Qty;
            this.isSmartPack=isSmartPack;
            this.isFromDesign=isFromDesign;
        }
        // new constructor having per unit price and total price
        public PurchaseOrderLineItemWrapper(String ID,String lineNumber,String Name,String prodType,String Qty,String currencyCode,decimal perUnitPrice,decimal totalPrice,Boolean isSmartPack,Boolean isFromDesign){
            this.pOrderLine = new Purchase_Order_Line__c();
            isChild =false;
            isExisting = false;
            this.ID = ID;
            this.lineNumber = lineNumber;
            this.Name=Name;
            this.prodType = prodType;
            this.Qty = Qty;
            this.currencyCode = currencyCode;
            this.perUnitPrice = perUnitPrice;
            this.totalPrice = totalPrice;
            this.pOrderLine.Unit_Price__c = perUnitPrice;
            this.pOrderLine.Price__c = totalPrice;

            this.isSmartPack = isSmartPack;
            this.isFromDesign = isFromDesign;
        }

        //new Constructor having Type1,Type2,Type3
        public PurchaseOrderLineItemWrapper(String ID,String lineNumber,String Name,String prodType,String Qty,Boolean isSmartPack,Boolean isFromDesign,String type1,String type2,String type3){
            isExisting =false;
            this.pOrderLine = new Purchase_Order_Line__c();
            this.ID = ID;
            this.lineNumber = lineNumber;
            this.Name=Name;
            this.prodType=prodType;
            this.Qty=Qty;
            this.perUnitPrice = 0.0;
            this.totalPrice = 0.0;
            this.isSmartPack=isSmartPack;
            this.isFromDesign=isFromDesign;
            this.type1 = type1;
            this.type2 = type2;
            this.type3 = type3;
        }
    }
}//class ends