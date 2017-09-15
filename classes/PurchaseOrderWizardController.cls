/****
-------------------
VERSION INFORMATION
-------------------

Version: KCM_01102016
Author: Kane Chelster Macaspac
Last Modified Date/Time: 01-21-2016 7:50 PM Pacific
Details:
-use the version name/number above as a search string to find the modifications specific to this version.
-addresses an issue reported in case 00628230 where EU (Italy, Germany, Netherlands) POs have a default shipping
 method of 'McCollister-Truck-DTW' when the expected value is null/blank because PSRs will manually fulfill this
 in Oracle.

#116570665 - Sales Order for cash sales (TPS) - Oracle integration


****/

public without sharing class PurchaseOrderWizardController {
	public String poDeltaURL {get; private set;}
    public String serviceCreditSMSItemId {get; private set;}
    // Get healthy Spring 2017 public String currentLocale {get;set;}
    public boolean isEUUser {get;set;}
    public boolean isInternalUser {get;set;}
    public String orderUser{get;set;}
    public boolean isNAUser {get;set;}
    public Account partnerAcc{get;set;} //Ok To Ship
    public boolean isEUPartnerUser {get;set;}
    public boolean isCustBillShipSameAdd {get;set;}
    public String formattedCustShippingAdd{get;set;}
    public String formattedCustBillingAdd{get;set;}
    // Get healthy Spring 2017
    //public Map<ID,Contact> currentDealersContactsMap {get;set;}
    //public List<Contact>currentDealersContacts { get{
    //    if(currentDealersContactsMap != null)
    //        return currentDealersContactsMap.values();
    //    else
    //        return null;
    //    }
    //}

    // Get healthy Spring 2017
    //public Map<ID,Contact> currentOpportunityContactsMap {get;set;}
    //public List<Contact>currentOpportunityContacts{get{
    //    if(currentOpportunityContactsMap != null) return currentOpportunityContactsMap.values();
    //    else
    //        return null;
    //}
    //}
    // Get healthy Spring 2017 public String selectedShipToSiteConID{get;set;}
    //String constant for BoS Category of Price_List_Item
    public static final String CATEGORY_BOS = 'BoS';
    //selected category filter
    //Start 92260
    //public static final String CATEGORY_INVERTER = 'Inverter';
    //End 92260
    // Get healthy Spring 2017 public String selectedCategory {get;set;}
    // Get healthy Spring 2017 public Price_List__c selectedPriceList{get;set;}
    // Get healthy Spring 2017 public boolean showErrorBlock{get;set;}
    //Start 00118354
    // Get healthy Spring 2017 public boolean invalidOpportunity{get;set;}
    //End 00118354
    public boolean isPartnerUser{get;set;}
    public Boolean isCommunitiesPartnerUser{get;set;}
    //Order tab id ,has to be changed when deploy
    // Get healthy Spring 2017 private final String ORDER_TAB_ID = '01r800000008htp';
    // Get healthy Spring 2017 private final String RESIDENTIAL_INSTALLER = 'Residential Installer';
    //check if Dealer Account type is Residential Intaller or not
    // Get healthy Spring 2017 public boolean isDealerResidential{get;set;}
    //check if the logged-in user is authorised to view/edit/create the purchase order
    public boolean isUserAuthorized{get;set;}
    //This variable contains the Tab No, where the actual will Show.
    // Get healthy Spring 2017 public Integer errorOnTab{get;set;}
    // Get healthy Spring 2017 private String recordSep = ';';
    // Get healthy Spring 2017 private String dataSep = '~';
    public boolean isShowCheckbox{get;set;}
    // Get healthy Spring 2017 public String changedQty{get;set;}
    //As per the Current User Current Time
    public DateTime userCurrentTime{get;set;}
    //As per the Current User Current Hour
    public Integer userCurrentTimeHour{get;set;}
    //As per the Price List selected Fee for it
    public Double expediteFeeForPriceList {get;set;}
    //Set record type
    // Get healthy Spring 2017 Map<String,ID> recTypes = new Map<String,ID>();
    //Hardcoded Design ID Field Name IFPO opens from Design
    // Get healthy Spring 2017 private  final String DESIGN_ID_PARAM ='CF' + '00NT00000013NkP' +'_lkid';
    //PriceListItemType 2 This Value for use as filtering the Value
    // Get healthy Spring 2017 public String prodType2Value {get;set;}
    //If New Order
    public Boolean isNewOrder{get;set;}
    //Created Purchase Order
    public Purchase_Order__c purchaseOrder {get;set;}
    //For Product Items Actually Saving,Purchase Order List Item values.Must be declared as private
    private List<Purchase_Order_Line__c> purchaseOrderList= null;
    //For Product Items Wrapper,which show in Page
    public List<PurchaseOrderLineItemWrapper> selProductItems {get;set;}
    //Selected Design
    // Get healthy Spring 2017 public SunPower_Design__c selectedDesign {get;set;}
    //Select Design ID
    // Get healthy Spring 2017 public String designID{get;set;}
    //Selecetd Opportunity
    public Opportunity selectedOpportunity {get;set;}
    //All Customer Opportunities on List and Map
    // Get healthy Spring 2017 public List<Opportunity> currentDealersOpportunity {get;set;}
    // Get healthy Spring 2017 private Map<ID,Opportunity> currentDealersOpportunityMap {get;set;}
    //All Ids of Accunts of Ship To Sites Residential Customer__c
    // Get healthy Spring 2017 private Set<String> customersAccountsIDs = new Set<String>();
    //Current Dealer Account
    public Account dealerAccount{get;set;}
    //For Prrice List ITems on Page Step -1
    // Get healthy Spring 2017 public Price_List_Item__c prod {get;set;}
    //Formatted ShipToSite Addres
    public String shipToSiteAddress {get;set;}
    //Formatted BillToSite Address
    public String billToSiteAddress {get;set;}
    //Seleted ShipToSite ID
    public String selectedShipToSiteID {get;set;}
    //Selected Dealer Account Shipping Address
    // Get healthy Spring 2017 public String dealerAccountShippingAddress {get;set;}
    public Ship_to_Site__c shipSite {get;set;}
    public Boolean renderShipToBlock {get;set;}
    public Boolean isOrderSubmitted {get;set;}
    public String submitOrderLabel {get;set;}
    public String submitOrderTitle {get;set;}
    //quantity of a lin items
    // Get healthy Spring 2017 public String inputQuantity {get;set;}
    //product line items
    // Get healthy Spring 2017 public List<Price_List_Item__c> products;
    //counter variable
    // Get healthy Spring 2017 Private Integer counter =1;
    // Get healthy Spring 2017 public ApexPages.StandardSetController setCon {get;set;}
    // Get healthy Spring 2017 public Map<ID,Ship_to_Site__c> dealerShiptoSiteMap {get;set;}
    // Get healthy Spring 2017 public Map<ID,Ship_to_Site__c> customerShiptoSiteMap {get;set;}
    public String selectedCustomerOpportunity {get;set;}
    // Get healthy Spring 2017 public boolean showQuantityMessage {get;set;}
    private Boolean isInvalidPartner {get;set;}
    // Get healthy Spring 2017 public String hdnDelProdLineId {get;set;}
    public boolean isCustomerOppSelected {get;set;}
    // Get healthy Spring 2017 public String termsDocID {get;set;}
    // Get healthy Spring 2017 public Integer PAGINATION_COUNTER{get;set;}
    // Get healthy Spring 2017 public Integer PAGINATION_COUNTERONPAGE{get;set;}
    // Get healthy Spring 2017 public Integer PAGINATION_COUNTER_OPPLIST{get;set;}
    // Get healthy Spring 2017 public Integer PAGINATION_COUNTERONPAGE_OPPLIST{get;set;}

    // #116570665
    public Boolean isTPSCashOrder {get; private set;}
   // #137640873
    public boolean isNewHomesCash {get;private set;}
    public boolean showSubmitButton {get;private set;}

    //public String prodNameFilter{get;set;}//removed for case # 00047707
    // Get healthy Spring 2017 public String prodDescFilter {get;set;}// added for case # 00047707
    //private Boolean isDirectSalesUser {get;set;}//added for case # 00049102
    //Start 88825
    // Get healthy Spring 2017 public static String setErrorAlaCarteItems;
    //End 88825
    //Start 00106510
    // Done for request to allow ‘EU Residential Installer’ profile to Order only Modulo and Inverter.
    // Get healthy Spring 2017 public boolean isUserEUResidentialInstaller {get;set;}
    //End 00106510
    public static final String CATEGORY_MODULE = 'Module';
    // end.
    // Get healthy Spring 2017
    //public String orderOwnerContactID {get{
    //    if(purchaseOrder != null && orderOwnerContactID == null && purchaseOrder.Id != null && purchaseOrder.OwnerId != null){
    //        for(user u :[select id,contactID from User where id =:purchaseOrder.OwnerId Limit 1])
    //            orderOwnerContactID = u.contactID;
    //    }
    //    return orderOwnerContactID;

    //}set;}

    // Get healthy Spring 2017
    //public String wizardStepNumber{
    //    get {
    //        if (wizardStepNumber == null ) {
    //            wizardStepNumber = '1';
    //        }
    //        return wizardStepNumber ;
    //    }
    //    set;
    //}

    // Get healthy Spring 2017
    //public Integer getWizardStepInt(){
    //    return Integer.valueOf(wizardStepNumber);
    //}
    public Set<String> SSDwithin3DaysTheaterSet = new Set<String>();

    // Get healthy Spring 2017
    //public void getQunatityMessage(){
    //    // Get healthy Spring 2017
    //    //if(showQuantityMessage){
    //    //    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.POQuantityErrorMessage);
    //    //    ApexPages.addMessage(errorMsg);
    //    //    // Get healthy Spring 2017 showErrorBlock = true;
    //    //}
    //    //else{
    //    //    showErrorBlock = false;
    //    //}
    //}

    /** This function is to navigate to step-2 after updating the selected opportunity in purchase order.
    *  @return PageReference
    */
    // Get healthy Spring 2017
    //public PageReference showStep2(){
    //    wizardStepNumber = '3';
    //    //Saving for Customer Opportunity
    //    if(selectedCustomerOpportunity != null && selectedCustomerOpportunity != ''){
    //        isCustomerOppSelected =true;
    //        //selectedOpportunity = currentDealersOpportunityMap.get(selectedCustomerOpportunity);
    //        selectedOpportunity = getCustOpportunity(selectedCustomerOpportunity);
    //        //[select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where ID =:selectedCustomerOpportunity Limit 1];
    //        purchaseOrder.Opportunity__c =selectedOpportunity.ID;
    //        purchaseOrder.Opportunity__r =selectedOpportunity;

    //        isCustBillShipSameAdd= PriceListItemUtility.isBillingShippingAddressSame(selectedOpportunity);
    //        try{
    //            formattedCustShippingAdd = PriceListItemUtility.getFormmatedOppShippingAddress(selectedOpportunity);
    //            if(!isCustBillShipSameAdd)
    //                formattedCustBillingAdd = PriceListItemUtility.getFormmatedOppBillingAddress(selectedOpportunity);
    //            currentOpportunityContactsMap = PriceListItemUtility.getContactsInMap(selectedOpportunity.Account.ID);
    //        }catch(Exception e){
    //        }

    //        if(!isCustBillShipSameAdd)
    //            formattedCustBillingAdd = PriceListItemUtility.getFormmatedOppBillingAddress(selectedOpportunity);
    //    }else{
    //        isCustomerOppSelected =false;
    //        selectedOpportunity = null;
    //        purchaseOrder.Opportunity__c =null;
    //        formattedCustShippingAdd = '';
    //        isCustBillShipSameAdd=false;
    //        formattedCustBillingAdd = '';
    //    }
    //    purchaseOrder.Order_Wizard_Step__c='Step 3';
    //    updatePOrder(false);
    //    return null;
    //}

    /** navigate to step-1.
    */
    // Get healthy Spring 2017
    //public PageReference showPage1byButton(){
    //    showErrorBlock = false;
    //    wizardStepNumber = '1';
    //    updatePOrder(true);
    //    return null;
    //}

    /**  navigate to step-3 from step-2.
    */
    // Get healthy Spring 2017
    //public PageReference showPage3byButton(){
    //    showErrorBlock = false;
    //    if(selectedCustomerOpportunity != null && selectedCustomerOpportunity != ''&& !isCustomerOppSelected)
    //        isCustomerOppSelected = true;
    //    else
    //        isCustomerOppSelected = false;
    //    wizardStepNumber = '3';
    //    purchaseOrder.Order_Wizard_Step__c='Step 3';
    //    updatePOrder(true);
    //    return null;
    //}

    /** navigate to step-2 from step-1.
    */
    // Get healthy Spring 2017
    //public PageReference showPage2byButton(){
    //    showErrorBlock = false;
    //    synchQuantity();
    //    calculateDiscount();
    //    changedQty='';
    //    errorOnTab = 1;

    //    if (selProductItems != null){
    //        for(PurchaseOrderWizardController.PurchaseOrderLineItemWrapper wrapper: selProductItems){
    //            if(wrapper.error != null){
    //                return null;
    //            }
    //        }
    //    }
    //    if(purchaseOrder.Name == null || purchaseOrder.Name == '' || String.valueOf(purchaseOrder.Name).length() > 50 || selProductItems == null || selProductItems.size() < 1 ){
    //        wizardStepNumber = '1';
    //        if(purchaseOrder.Name == null || purchaseOrder.Name == ''){
    //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredPONumber));
    //            //PR-02986 if character length of PO Name is greater than 50 show error
    //        }else if(String.valueOf(purchaseOrder.Name).length() > 50){
    //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardPONumberLengthExceeds));
    //        }

    //        if(selProductItems == null || selProductItems.size() < 1){
    //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredLineItems));
    //        }

    //    }else{
    //        String query ='';
    //        String poName = purchaseOrder.Name;//for Case#00072654
    //        poName = poName.replace('\'', '\\\'');//for Case#00072654
    //        if(purchaseOrder.ID == null){
    //            query = 'Select p.Id from Purchase_Order__c p where p.Name like \''+poName+'\' AND p.Dealer_Account__c = \''+dealerAccount.ID+ '\'';//for Case#00072654
    //        }else{
    //            query = 'Select p.Id from Purchase_Order__c p where p.Name like \''+poName+'\' AND p.Dealer_Account__c = \''+dealerAccount.ID +'\' AND p.Id != \''+ purchaseOrder.Id +  '\'';//for Case#00072654
    //        }
    //        System.debug('query string : '+query);
    //        List<Purchase_Order__c> poList = Database.query(query);
    //        System.debug('polist : '+poList);
    //        if(poList != null && poList.size() > 0){
    //            wizardStepNumber = '1';
    //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardDuplicatePONumber));
    //        }else{
    //            if(isDealerResidential){
    //                wizardStepNumber = '3';
    //                purchaseOrder.Order_Wizard_Step__c='Step 3';
    //            }else{
    //                wizardStepNumber = '2';
    //                purchaseOrder.Order_Wizard_Step__c='Step 2';
    //            }
    //            //calculate total order price at step-1
    //            calculateOrderPrice();
    //            updatePOrder(true);
    //        }

    //    }
    //    return null;
    //}

    //navigate to previous step that is from step-3  to step-2
    // Get healthy Spring 2017
    //public PageReference showPage2byButtonFrom3(){
    //    showErrorBlock = false;
    //    if(isDealerResidential){
    //        wizardStepNumber = '1';
    //    }else{
    //        wizardStepNumber = '2';
    //    }
    //    updatePOrder(false);
    //    return null;
    //}

    //navigate to next step that is from step-3  to step-4
    // Get healthy Spring 2017
    //public PageReference showPage4byButtonFrom3(){
    //    showErrorBlock = false;
    //    Boolean hasError = false;
    //    if(shipToSiteAddress == null || shipToSiteAddress == ''){
    //        hasError = true;
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredShipsiteAddress));
    //    }
    //    if(purchaseOrder.Requested_Delivery_Date__c == null){
    //        hasError = true;
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredDeliveryDate));
    //    }
    //    if(purchaseOrder.Requested_Delivery_Date__c != null && purchaseOrder.Requested_Delivery_Date__c < Date.today()){
    //        hasError = true;
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POValidDeliveryDateMessage));
    //    }
    //    if(purchaseOrder.Requested_Delivery_Date__c != null) {
    //        if(isEUUser) {
    //            System.debug('isEUUser: ' + isEUUser);
    //            if(purchaseOrder.Requested_Delivery_Date__c <= PriceListItemUtilityLease.getNextWorkingDate(Date.Today(),4) && SSDwithin3DaysTheaterSet.contains(purchaseOrder.Dealer_Account__r.Theater__c) ){
    //                hasError = true;
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.DeliveryDatewith3daysofToday_ERROR));
    //            }
    //        } else {
    //            if(purchaseOrder.Requested_Delivery_Date__c <= PriceListItemUtilityLease.getNextWorkingDate(Date.Today(),3) && SSDwithin3DaysTheaterSet.contains(purchaseOrder.Dealer_Account__r.Theater__c) ){
    //                hasError = true;
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.DeliveryDatewith3daysofToday_ERROR));
    //            }
    //        }

    //    }
    //    if(isNAUser && (purchaseOrder.Ship_To_Contact__r.Name == null || purchaseOrder.Ship_To_Contact__r.Name == '')){
    //        hasError = true;
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POShipToContact));
    //    }
    //    /** START -This CRD date validation was overridden by Case # 00187883
    //// START - Case # 00175673 - Requested by clarissa.rodriguez@sunpowercorp.com
    //if(purchaseOrder.Requested_Delivery_Date__c < Date.today() + 14){
    //hasError = true;
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.PO_Valid_Delivery_Date_Message_2));
    //}
    ////END - Case # 00175673 - Requested by clarissa.rodriguez@sunpowercorp.com
    ////END -This CRD date validation was overridden by Case # 00187883
    //*/
    //    if(isShowCheckbox == true && purchaseOrder.Accept_Expedited_Delivery_Charges__c == false){
    //        hasError = true;
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationRequiredDeliveryCharges));
    //    }
    //    if(isNAUser && (purchaseOrder.Shipping_Method__c ==null || purchaseOrder.Shipping_Method__c =='' || purchaseOrder.Shipping_Method__c == '--None--')){
    //        hasError = true;
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationRequiredShippingMethod));
    //    }
    //    //Start 94300
    //    if(purchaseOrder.Notes__c != null && String.valueOf(purchaseOrder.Notes__c).length() > 255){
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardNotesLengthExceeds));
    //        hasError = true;
    //    }
    //    //End 94300
    //    if(!hasError){
    //        wizardStepNumber = '4';
    //        purchaseOrder.Order_Wizard_Step__c='Step 4';
    //        updatePOrder(false);
    //        calculateOrderPrice();
    //    }else{
    //        wizardStepNumber = '3';
    //        errorOnTab = 3;
    //    }
    //    return null;
    //}

    //go to previous step that is from step-4  to step-3
    // Get healthy Spring 2017
    //public PageReference showPage3byButtonFrom4(){
    //    showErrorBlock = false;
    //    wizardStepNumber = '3';
    //    purchaseOrder.Order_Wizard_Step__c='Step 3';
    //    updatePOrder(false);
    //    return null;
    //}

    //finally submit the purchase order to sunpower
    public PageReference submitOrder(){
        // Get healthy Spring 2017 showErrorBlock = false;

        if(selProductItems!= null && selProductItems.size() > 0 && purchaseOrder.Bill_to_Site__c != null && purchaseOrder.Ship_to_Site__c != null &&  purchaseOrder.Dealer_Account__c != null && !(isShowCheckbox == true && purchaseOrder.Accept_Expedited_Delivery_Charges__c == false) && ((!isPartnerUser && (isTPSCashOrder || isNewHomesCash) && purchaseOrder.Order_Status__c == 'New') || (!isPartnerUser && purchaseOrder.Order_Status__c == 'Error') || (isEUUser && purchaseOrder.Accept_Terms__c) || (isNAUser && purchaseOrder.Accept_Terms__c))){ //&& !(isShowCheckbox == true && purchaseOrder.Accept_Expedited_Delivery_Charges__c == false) new for pr 03721
            // if Order status is going from 'New' To 'Submitted',update the PO_Submit_Date__c
            // PR-03205
            // System.debug(LoggingLevel.ERROR, 'In Submit Order');
            if(purchaseOrder.Order_Status__c != null && purchaseOrder.Order_Status__c == 'New')
                purchaseOrder.PO_Submit_Date__c = Datetime.valueOfGMT(string.valueof(Datetime.now()));

            purchaseOrder.Order_Status__c = 'Submitted';
            //Updating Interface Status to New when the order is Submitted.
            purchaseOrder.Interface_Status__c = 'New';
            if(purchaseOrder.Ship_To_Contact__c != null){
                if(purchaseOrder.Special_Instructions__c == null || purchaseOrder.Special_Instructions__c == 'null' || purchaseOrder.Special_Instructions__c =='')
                    purchaseOrder.Special_Instructions__c = ' ***';
                purchaseOrder.Special_Instructions__c += ' Contact:'+ purchaseOrder.Ship_To_Contact__r.Name+' *** ';
            }
            if(purchaseOrder.Special_Instructions__c != null && purchaseOrder.Special_Instructions__c.indexOf('null')>0)
                purchaseOrder.Special_Instructions__c =purchaseOrder.Special_Instructions__c.replaceAll('null','');
            purchaseOrder.Order_Wizard_Step__c='Step 4';

            if(isEUUser)
                purchaseOrder.Ok_To_Ship__c = 'HOLD';

            updatePOrder(true);
            PageReference pg = new PageReference('/apex/PurchaseOrderWizard?POID='+purchaseOrder.Id);
            return pg.setRedirect(true);
        } else {
            // Get healthy Spring 2017 errorOnTab = 4;
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

            if(selProductItems == null || selProductItems.size() < 0){
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
            if(!purchaseOrder.Accept_Terms__c){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardTnC);
                ApexPages.addMessage(errorMsg);
            }
            // Get healthy Spring 2017 wizardStepNumber = '4';
            // Get healthy Spring 2017 purchaseOrder.Order_Wizard_Step__c='Step 4';
            return null;
        }

    }
    /** updates purchase order and list of price list items.
    */
    private void updatePOrder(boolean updateList){
        if(purchaseOrder.ID == null) {
            insert  purchaseOrder;
        }
        if(purchaseOrder.ID != null) {
            update  purchaseOrder;
        }
        // Get healthy Spring 2017
        //if(updateList){
        //    //reInitlizeProductItems();
        //    //for Calculating Total order price
        //    //calculateOrderPrice();
        //}
    }

    // This function re-initializes the list of price list items of purchase order
    // Get healthy Spring 2017
    //private void reInitlizeProductItems(){
    //    if(purchaseOrderList != null && purchaseOrderList.size()>0){
    //        try{
    //            Database.delete(purchaseOrderList,true);
    //        }catch(Exception e){}
    //    }else
    //        purchaseOrderList = new List<Purchase_Order_Line__c>();
    //    purchaseOrderList.clear();
    //    if(selProductItems != null && selProductItems.size()>0){
    //        for(PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
    //            Purchase_Order_Line__c p= new Purchase_Order_Line__c();
    //            if(prodWrapper.Qty != null && prodWrapper.Qty != '')
    //                p.Quantity__c =  Double.valueOf(prodWrapper.Qty);
    //            p.Purchase_Order__c = purchaseOrder.Id;
    //            p.Order_Line_Number__c = prodWrapper.lineNumber;
    //            p.Oracle_Item_Id__c = prodWrapper.oracleItemIDRef;
    //            p.SmartPack_Item__c = prodWrapper.isSmartPack;
    //            p.Item_Source__c = prodWrapper.itemSource;//for Case# 00077093
    //            p.Unit_Price__c = (prodWrapper.perUnitPrice != null)? prodWrapper.perUnitPrice :0.0;
    //            p.Price__c =  (prodWrapper.totalPrice != null) ? prodWrapper.totalPrice :0.0;
    //            p.Quantity__c = (prodWrapper.Qty != null) ? Double.ValueOf(prodWrapper.Qty) :0.0;
    //            p.Discount_Amount__c = (prodWrapper.discountAmount != null) ? prodWrapper.discountAmount : null;
    //            p.Discount_Percent__c = (prodWrapper.discountPercent != null) ? Double.valueOf(prodWrapper.discountPercent.replace('%','')) : null;
    //            p.Service_Fee__c = (prodWrapper.shippingCharges != null) ? prodWrapper.shippingCharges : null;
    //            p.CurrencyIsoCode = prodWrapper.currencyCode;
    //            if(prodWrapper.childID !=null)
    //                p.Child_ID__c = prodWrapper.childID;
    //            purchaseOrderList.add(p);
    //        }
    //        if(purchaseOrderList != null && purchaseOrderList.size()>0){
    //            insertListAndUpdateWrapper();
    //        }
    //    }
    //}

    /** Action function called on cancel button from apex page.
    */
    // Get healthy Spring 2017
    //public PageReference cancel(){
    //    if(isNewOrder != null && isNewOrder && purchaseOrder != null && selectedDesign == null && designID != null && designID != ''){
    //        List<SunPower_Design__c> sDesign =[select id from SunPower_Design__c where id =:designID LIMIT 1];
    //        if(sDesign != null && sDesign.size()>0)
    //            return (new PageReference('/'+sDesign[0].ID));
    //    }else if(dealerAccount == null && !isPartnerUser && designID != null && designID != ''){
    //        List<SunPower_Design__c> sDesign =[select id from SunPower_Design__c where id =:designID LIMIT 1];
    //        if(sDesign != null && sDesign.size()>0)
    //            return (new PageReference('/'+sDesign[0].ID));
    //    }
    //    return (new PageReference('/apex/Order_Details?sfdc.tabName='+ORDER_TAB_ID));
    //}

    /**check whether the current logged-in user is authorised
    *  to view/edit/create a purchase order or not , if not then display error block.
    */
    // Get healthy Spring 2017
    //private void checkUserAuthorization(String userID){
    //    //start for case # 00049102 - onhold
    //    for(User u :[select id, Name,profile.name, UserType, contactId, Contact.AccountID, Contact.Authorized_to_Order__c, Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c, Contact.Account.AccountNumber, Contact.Account.Name, Contact.Account.ShippingStreet, Contact.Account.ShippingState, Contact.Account.ShippingCity, Contact.Account.ShippingCountry, Contact.Account.ShippingPostalCode, Contact.Account.BillingCountry,Contact.Account.Theater__c,Contact.Account.Type,Contact.Account.Oracle_Account_Number__c from User where id = :userID and ContactID != null LIMIT 1]){
    //        /*isDirectSalesUser = false;
    //for(User u :[select id, Name,Profile.Name, UserType, contactId, Contact.AccountID, Contact.Authorized_to_Order__c, Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c, Contact.Account.AccountNumber, Contact.Account.Name, Contact.Account.ShippingStreet, Contact.Account.ShippingState, Contact.Account.ShippingCity, Contact.Account.ShippingCountry, Contact.Account.ShippingPostalCode, Contact.Account.Theater__c,Contact.Account.Type,Contact.Account.Oracle_Account_Number__c from User where id = :userID LIMIT 1]){
    //if(u.Profile.Name == 'SunPower Direct Sales RLC')
    //isDirectSalesUser = true;*/
    //        //end for case # 00049102
    //        if(isInvalidPartner(u)){
    //            isInvalidPartner = true;
    //            errorOnTab = 0;
    //            isUserAuthorized =false;
    //            isPartnerUser = true;
    //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.POWizardViewNotAllowed));
    //            return;
    //        }

    //        String accType=null;
    //        if(u != null && u.Contact != null && u.Contact.Account != null){
    //            accType=u.Contact.Account.Type;
    //            //check whether the user is partner or non-partner
    //            if(u.UserType == 'PowerPartner'){
    //                //oracle account number check start:
    //                //check whether the Oracle_Account_Number__c of his account has some value or not

    //                //oracle account number check ends:
    //                isPartnerUser = true;
    //                if(u.Contact.Authorized_to_Order__c && u.Contact.Account.Online_Order_Access__c){
    //                    isUserAuthorized = true;
    //                }
    //            }else{
    //                isPartnerUser = false;
    //            }
    //        }
    //        //start for case # 00049102 - on hold
    //        /*if(isDirectSalesUser)
    //isUserAuthorized = true;*/
    //        //start for case # 00049102
    //        //Check if EU partner user
    //        isEUUser = false;

    //        if(u.Contact != null && u.Contact.Account != null && u.UserType == 'PowerPartner'){
    //            if(u.profile.name.startsWith('EU'))
    //                isEUUser = true;
    //            //Case# 00156204: In next 'else if' statement, theatre 'Central America and the Caribbean' has beed added with NAUsers. This will allow users from 'Central America and the Caribbean' to create the Purchase Order.
    //            else if(accType != null && PriceListItemUtility.getValidNAAccountType().contains(acctype) && u.Contact.Account.Theater__c != null && (u.Contact.Account.Theater__c =='North America' || u.Contact.Account.Theater__c =='Central America and the Caribbean'))
    //                isNAUser =true;
    //        }

    //        //check if user profile is 'EU Residential Installer' and going to create an Ala-Carte Order
    //        if(u.profile.name == 'EU Residential Installer' && u.UserType == 'PowerPartner'){
    //            //Start 00106510
    //            /*// if POID or ID  is in URL parameter then edit an order, Allowed
    //// if DID  or  DESIGN_ID_PARAM is coming in URL parameter then create an order with design, Allowed
    //// if no parameter is coming in URL means create an order with Ala-Carte Items then don't allow him and display error message
    //if(ApexPages.currentPage().getParameters().get('POID') == null &&
    //ApexPages.currentPage().getParameters().get('id') == null &&
    //ApexPages.currentPage().getParameters().get('DID') == null &&
    //ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM) == null){
    //errorOnTab = 0;
    //isPartnerUser = true;
    //isUserAuthorized = false;
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardAccessErrorEUResi));
    //return;
    //}*/
    //            isUserEUResidentialInstaller = true;
    //            //End 00106510
    //        }
    //    }
    //    if(!isUserAuthorized && isPartnerUser){
    //        errorOnTab = 0;
    //        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardAccessPermissionsErrorMsg);
    //        ApexPages.addMessage(errorMsg);
    //    }
    //}
    /*
    This method check whether the Partner User is Authorized to view the Order or not
    As per PR-03075, if any Partner User view the order of any another Partner, it will show the error.
    */
    // Get healthy Spring 2017
    //private boolean isInvalidPartner(User u){
    //    //has to be code here
    //    boolean isInvalid =false;
    //    if(ApexPages.currentPage().getParameters().get('POID') != null || ApexPages.currentPage().getParameters().get('id') != null ){
    //        String purID =  ApexPages.currentPage().getParameters().get('POID');
    //        if(purID == null)
    //            purID = ApexPages.currentPage().getParameters().get('id');
    //        if(purID != null){
    //            for(Purchase_Order__c p :[select id,dealer_Account__c from Purchase_Order__c where id =:purID Limit 1]){
    //                if(p.dealer_Account__c != null && p.dealer_Account__c != u.Contact.AccountID)
    //                    isInvalid=true;
    //            }
    //        }
    //    }
    //    return isInvalid;
    //}

    /** Constructor PurchaseOrderWizardController.
    *  @param ApexPages.standardController
    */
    public PurchaseOrderWizardController(ApexPages.standardController control){
        if(Label.ThreedayswithinSSDRegions!=null){
            List<String> ThreedayswithinSSDList = Label.ThreedayswithinSSDRegions.split(',');
            // System.debug('ThreedayswithinSSDList ----->'+ThreedayswithinSSDList);
            SSDwithin3DaysTheaterSet.addAll(ThreedayswithinSSDList);
        }
        // System.debug('Enter in PurchaseOrderWizardController');
        String userID = UserInfo.getUserID();
        // Get healthy Spring 2017 PAGINATION_COUNTER =5;
        // Get healthy Spring 2017 PAGINATION_COUNTERONPAGE=0;
        // Get healthy Spring 2017 PAGINATION_COUNTER_OPPLIST = 5;
        // Get healthy Spring 2017 PAGINATION_COUNTERONPAGE_OPPLIST=0;
        isInternalUser =false;
        isNAUser =false;
        orderUser ='';
        isEUUser =false;
        isCustBillShipSameAdd=false;
        isInvalidPartner =false;
        // Get healthy Spring 2017 showErrorBlock = false;
        // Get healthy Spring 2017 showQuantityMessage = false;
        isPartnerUser = false;
        isCommunitiesPartnerUser = SPCommunityUtility.isPartnerUser();
        isUserAuthorized = false;
        // Get healthy Spring 2017 currentLocale = userinfo.getLocale();
        //NEW CASE 12-22-2014 EU Pricing
        // Get healthy Spring 2017 showDiscountColumns = false;
        // Get healthy Spring 2017 showBundleSize = false;
        // Get healthy Spring 2017 showErrors = false;
        //Start 00118354
        // Get healthy Spring 2017 invalidOpportunity = false;
        //End 00118354
        //Start 00106510
        // Done for request to allow ‘EU Residential Installer’ profile to Order only Modulo and Inverter.
        // Get healthy Spring 2017 isUserEUResidentialInstaller = false;
        //End 00106510

        // #116570665
        isTPSCashOrder = false;
        showSubmitbutton = true;
        isNewHomesCash = false;

        User userObj;
        userObj = [SELECT Country_Domain__c, Id,
                   User.Profile.Name
                   FROM User
                   WHERE Id = :UserInfo.getUserId()];

        if(userObj.profile.name.startsWith('EU'))
        {
            isEUPartnerUser = true;
        }
        else
        {
            isEUPartnerUser = false;
        }


        //Ok To Ship
        User usr=[select ContactId from User WHERE Id = :UserInfo.getUserId()];
        if(usr.ContactId!=null){
            Id AccId  = [Select AccountID from Contact where id =: usr.ContactId].AccountId;
            partnerAcc = [select Country_Domain__c,Partner_Opt_Out_Ok_To_Ship__c,Default_Dealer_Warehouse_Shipping_Site__c from Account where Id=:AccId];
        }

        //checkUserAuthorization(userID);
        // if user parther user and authorized to access po then can view/edit/create po
        // if user partner user and not authorized to access po then can not view/edit/create po
        // if user non-partner then can view the po
        if((isUserAuthorized || !isPartnerUser) && (!isInvalidPartner) ){
            // Get healthy Spring 2017 inputQuantity='1';
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
            // Get healthy Spring 2017 isDealerResidential = false;
            // Get healthy Spring 2017 errorOnTab = 0;
            // Get healthy Spring 2017 prod = new Price_List_Item__c();
            // Current Time as Per UserTime Zone
            userCurrentTime = Datetime.valueOfGMT(string.valueof(Datetime.now()));
            userCurrentTimeHour = userCurrentTime.hourGmt();
            // System.debug('Here the Time value is::'+userCurrentTimeHour);
            //Parameters
            //String userID = UserInfo.getUserID();
            //For Testing
            //userID='00580000002iAWA';
            //Initlizing Products
            // Get healthy Spring 2017
            //for (RecordType rec : [Select id,name,developerName from RecordType where sObjectType='Ship_To_Site__C']){
            //    recTypes.put(rec.developerName,rec.ID);
            //}

            //IF EXISTING ORDER
            if(ApexPages.currentPage().getParameters().get('POID') != null || ApexPages.currentPage().getParameters().get('id') != null ){
                isNewOrder =false;
                String prodID = ApexPages.currentPage().getParameters().get('POID');
                if(prodID == null)
                    prodID = ApexPages.currentPage().getParameters().get('id');
                if(prodID != null){
                    for(Purchase_Order__c p:[Select p.Lease__c, p.Lease_Number__c, p.Accept_Terms__c,p.SmartMount__c,p.OwnerID,p.Ship_To_Contact__c,p.Ship_To_Contact__r.Name,p.Is_Taxible_Order__c,p.CurrencyIsoCode, p.SmartPack_Mounting_Type__c, p.SmartPack_Inverter_Type__c, p.Accept_Partial_Shipment__c, p.DSR_PO_Group_Email__c, p.Assigned_DSR__c, p.Assigned_RSM__c, p.Order_Status_Interface_Message__c,p.Oracle_Order_Number__c,p.Owner.Name,p.Owner.Profile.Name,p.CreatedDate,p.LastModifiedDate,p.Notes__c, p.Accept_Expedited_Delivery_Charges__c,p.Delivery_Charges__c,p.Dealer_Account__c,p.Dealer_Account__r.Oracle_Operating_Unit__c, p.Dealer_Account__r.Name,p.Order_Wizard_Step__c, p.Opportunity__r.Name,p.Opportunity__r.Id,p.Opportunity__r.AccountID,p.Opportunity__r.Account.BillingStreet,p.Opportunity__r.Account.BillingCity,p.Opportunity__r.Account.BillingState,p.Opportunity__r.Account.BillingCountry,p.Opportunity__r.Account.BillingPostalCode,p.Opportunity__r.Account.ShippingStreet,p.Opportunity__r.Account.ShippingCity,p.Opportunity__r.Account.ShippingState,p.Opportunity__r.Account.ShippingCountry,p.Opportunity__r.Account.ShippingPostalCode,p.SunPower_Design__r.ID,p.SunPower_Design__r.Name,p.System_Size__c, p.SunPower_Design__c,p.SunPower_Design__r.EU_Inverter_Type__c,p.SunPower_Design__r.EU_Mounting_Type__c, SunPower_Design__r.System_Source__c,SunPower_Design__r.SMS_KIT__c, p.Special_Instructions__c, p.Shipping_Method__c, p.Ship_to_Site__c, p.Ship_to_Site__r.Zip__c,p.Ship_to_Site__r.Type__c,p.Ship_to_Site__r.State__c, p.Ship_to_Site__r.Oracle_Account_Number__c, p.Ship_to_Site__r.Country__c, p.Ship_to_Site__r.City__c, p.Ship_to_Site__r.Address3__c, p.Ship_to_Site__r.Address2__c, p.Ship_to_Site__r.Address1__c,p.Ship_to_Site__r.Contact_Email__c, p.Ship_to_Site__r.Contact_First_Name__c, p.Ship_to_Site__r.Contact_Last_Name__c, p.Ship_to_Site__r.Contact_Phone__c,p.Requested_Delivery_Date__c, p.Order_Total__c, p.Order_Status__c, p.Oracle_Order_Status__c, p.Opportunity__c, p.Name, p.Id, p.Contact_ID__c, p.Bill_to_Site__c, p.Bill_to_Site__r.Zip__c, p.Bill_to_Site__r.State__c, p.Bill_to_Site__r.Country__c, p.Bill_to_Site__r.City__c, p.Bill_to_Site__r.Address3__c, p.Bill_to_Site__r.Address2__c, p.Bill_to_Site__r.Address1__c,p.Ok_To_Ship__c,p.Dealer_Account__r.Theater__c, p.Sales_Type__c, p.Dealer_Account__r.NH_SSE_Type__c, (Select Child_ID__c,Id, Name, Order_Line_Number__c, Item_Description__c, Quantity__c, Unit_of_Measure__c,Unit_Price__c, Quantity_per_Box__c, Price__c, Item_ID__c, Item_Number__c,CurrencyIsoCode,Purchase_Order__c,SmartPack_Item__c,Oracle_Item_Id__c,Oracle_Item_Id__r.Name,Oracle_Item_Id__r.Line_Type__c,Oracle_Item_Id__r.Description__c,Oracle_Item_Id__r.Item_Displayable_Description__c,Oracle_Item_Id__r.Long_Description__c,Purchase_Order__r.SmartPack_Mounting_Type__c,Purchase_Order__r.SmartPack_Inverter_Type__c, Item_Source__c,Discount_Amount__c,Discount_Percent__c,Service_Fee__c From Purchase_Order_Lines__r order by SmartPack_Item__c),p.Quote__r.QuoteType__c,p.Quote__r.Sector__c, Quote__r.Amended_Lease__c From Purchase_Order__c p where p.Id =:prodID Limit 1]){//for Case# 00078223
                        //for(Purchase_Order__c p:[Select p.Lease__c, p.Lease_Number__c, p.Accept_Terms__c,p.SmartMount__c,p.OwnerID,p.Ship_To_Contact__c,p.Ship_To_Contact__r.Name,p.Is_Taxible_Order__c,p.CurrencyIsoCode, p.SmartPack_Mounting_Type__c, p.SmartPack_Inverter_Type__c, p.Accept_Partial_Shipment__c, p.DSR_PO_Group_Email__c, p.Assigned_DSR__c, p.Assigned_RSM__c, p.Order_Status_Interface_Message__c,p.Oracle_Order_Number__c,p.Owner.Name,p.Owner.Profile.Name,p.CreatedDate,p.LastModifiedDate,p.Notes__c, p.Accept_Expedited_Delivery_Charges__c,p.Delivery_Charges__c,p.Dealer_Account__c,p.Dealer_Account__r.Oracle_Operating_Unit__c, p.Dealer_Account__r.Name,p.Order_Wizard_Step__c, p.Opportunity__r.Name,p.Opportunity__r.Id,p.Opportunity__r.AccountID,p.Opportunity__r.Account.BillingStreet,p.Opportunity__r.Account.BillingCity,p.Opportunity__r.Account.BillingState,p.Opportunity__r.Account.BillingCountry,p.Opportunity__r.Account.BillingPostalCode,p.Opportunity__r.Account.ShippingStreet,p.Opportunity__r.Account.ShippingCity,p.Opportunity__r.Account.ShippingState,p.Opportunity__r.Account.ShippingCountry,p.Opportunity__r.Account.ShippingPostalCode,p.SunPower_Design__r.ID,p.SunPower_Design__r.Name,p.System_Size__c, p.SunPower_Design__c,p.SunPower_Design__r.EU_Inverter_Type__c,p.SunPower_Design__r.EU_Mounting_Type__c, p.Special_Instructions__c, p.Shipping_Method__c, p.Ship_to_Site__c, p.Ship_to_Site__r.Zip__c,p.Ship_to_Site__r.Type__c,p.Ship_to_Site__r.State__c, p.Ship_to_Site__r.Oracle_Account_Number__c, p.Ship_to_Site__r.City__c, p.Ship_to_Site__r.Address3__c, p.Ship_to_Site__r.Address2__c, p.Ship_to_Site__r.Address1__c,p.Ship_to_Site__r.Contact_Email__c, p.Ship_to_Site__r.Contact_First_Name__c, p.Ship_to_Site__r.Contact_Last_Name__c, p.Ship_to_Site__r.Contact_Phone__c,p.Requested_Delivery_Date__c, p.Order_Total__c, p.Order_Status__c, p.Oracle_Order_Status__c, p.Opportunity__c, p.Name, p.Id, p.Contact_ID__c, p.Bill_to_Site__c, p.Bill_to_Site__r.Zip__c, p.Bill_to_Site__r.State__c, p.Bill_to_Site__r.Country__c, p.Bill_to_Site__r.City__c, p.Bill_to_Site__r.Address3__c, p.Bill_to_Site__r.Address2__c, p.Bill_to_Site__r.Address1__c, (Select Child_ID__c,Id, Name, Order_Line_Number__c, Item_Description__c, Quantity__c, Unit_of_Measure__c,Unit_Price__c, Quantity_per_Box__c, Price__c, Item_ID__c, Item_Number__c,CurrencyIsoCode,Purchase_Order__c,SmartPack_Item__c,Oracle_Item_Id__c,Oracle_Item_Id__r.Name,Oracle_Item_Id__r.Description__c,Oracle_Item_Id__r.Long_Description__c,Purchase_Order__r.SmartPack_Mounting_Type__c,Purchase_Order__r.SmartPack_Inverter_Type__c From Purchase_Order_Lines__r order by SmartPack_Item__c) From Purchase_Order__c p where p.Id =:prodID Limit 1]){
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
                        // Get healthy Spring 2017
                        //if(purchaseOrder.Order_Wizard_Step__c != null)
                        //    wizardStepNumber = (purchaseOrder.Order_Wizard_Step__c =='Step 1'?'1':(purchaseOrder.Order_Wizard_Step__c =='Step 2'?'2':(purchaseOrder.Order_Wizard_Step__c =='Step 3'?'3':'4')));
                        if(purchaseOrder.Dealer_Account__c != null)
                            for(Account a: [select ShippingStreet ,ShippingState, ShippingPostalCode, ShippingCountry,BillingCountry, ShippingCity, id, Name, AccountNumber, Type, Primary_PSR__c, RSM__c,Oracle_Operating_Unit__c,Theater__c,Dealer_Tier__c from Account where id =:purchaseOrder.Dealer_Account__c LIMIT 1])
                            dealerAccount = a;
                        // Get healthy Spring 2017
                        // selectedDesign = p.SunPower_Design__r;
                        isShowCheckbox= p.Accept_Expedited_Delivery_Charges__c;
                        selectedCustomerOpportunity = p.Opportunity__c;
                        if(selectedCustomerOpportunity != null && selectedCustomerOpportunity != ''){
                            try{
                                selectedOpportunity = p.Opportunity__r;
                                isCustomerOppSelected =true;
                                //isCustBillShipSameAdd= PriceListItemUtility.isBillingShippingAddressSame(selectedOpportunity);
                                //formattedCustShippingAdd = PriceListItemUtility.getFormmatedOppShippingAddress(selectedOpportunity);
                                if(!isCustBillShipSameAdd)
                                    formattedCustBillingAdd = PriceListItemUtility.getFormmatedOppBillingAddress(selectedOpportunity);
                                // Get healthy Spring 2017 currentOpportunityContactsMap = PriceListItemUtility.getContactsInMap(p.Opportunity__r.Account.ID);
                            }catch(Exception e){
                            }
                        }
                        if(purchaseOrderList == null)
                            purchaseOrderList= p.Purchase_Order_Lines__r;
                        //if the order status is in error then
                        //1)if user is partner then show error message saying 'There is an error with this order. Please contact your SunPower DSR for more information.'
                        //2)if user is non partner then show error message saying There is an error with this order. The error is: " & display ->[Order_Status_Interface_Message__c]
                        if(p.Order_Status__c == 'Error'){
                            // Get healthy Spring 2017 showErrorBlock = true;
                            // Get healthy Spring 2017 errorOnTab = 0;
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
                            // Get healthy Spring 2017 errorOnTab = 4;
                            ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, System.Label.POWizardInfoMsgForSubmittedOrder);
                            ApexPages.addMessage(infoMsg);
                            // if the order status is processed
                        }else if(p.Order_Status__c == 'Processed'){
                            // Get healthy Spring 2017 showErrorBlock = true;
                            // Get healthy Spring 2017 errorOnTab = 0;
                            isOrderSubmitted = true;
                            // custom label for View Order
                            submitOrderLabel = System.Label.POWizardViewOrderTitle;
                            submitOrderTitle = '';
                            //ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, System.Label.POWizardInfoMsgForProcessedStatus+'\n'+purchaseOrder.Order_Status_Interface_Message__c);
                            ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, System.Label.POWizardInfoMsgForProcessedStatus+'\n'+purchaseOrder.Oracle_Order_Number__c);
                            ApexPages.addMessage(infoMsg);
                            // if the order status is In Process
                        }else if(p.Order_Status__c == 'In Process'){
                            // Get healthy Spring 2017 errorOnTab = 0;
                            // Get healthy Spring 2017 showErrorBlock = true;
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
                        // Get healthy Spring 2017 errorOnTab = 0;
                        return;
                    } else {
                        // change order phase II - add button to compare po's
                        Id amendedQuoteId = purchaseOrder.Quote__r.Amended_Lease__c;
                        poDeltaURL = PurchaseOrderUtility.getPODeltaURL(prodID, amendedQuoteId);
                    }
                    setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
                    setFormatedBillToSiteAddress(purchaseOrder);

                    // #116570665

                    if((purchaseOrder.Sales_Type__c == 'Cash' || purchaseOrder.Sales_Type__c == 'SPD') && purchaseOrder.Dealer_Account__r.NH_SSE_Type__c != null && purchaseOrder.Dealer_Account__r.NH_SSE_Type__c.contains('TPS')) {
                        showSubmitButton = true;
                        isTPSCashOrder = true;
                    }
                    if(purchaseOrder.Quote__r.QuoteType__c == 'Cash' && purchaseOrder.Quote__r.sector__c == 'New Homes'){
                         showSubmitButton = true;
                         isNewHomesCash = true;
                    }
                   if(purchaseOrderManagement.fIsPurchaseOrderExistNewHomes(Id.valueof(purchaseOrder.Id))){
                      showSubmitButton   = false;
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.Purchase_Order_Already_Exist));
                   }
                }
            }
            //IF NEW ORDER
            // only partner user can create a new Purchase Order
            else if (isPartnerUser){
                isNewOrder =true;
                // Get healthy Spring 2017 wizardStepNumber='1';
                purchaseOrder = new Purchase_Order__c(Order_Status__c ='New');
                isCustomerOppSelected =false;
                // a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity
                //Contact.Account.Bill_To_Site__c,Contact.Account.Bill_To_Site__r.Address1__c,Contact.Account.Bill_To_Site__r.Address2__c,Contact.Account.Bill_To_Site__r.Address3__c,Contact.Account.Bill_To_Site__r.City__c,Contact.Account.Bill_To_Site__r.State__c,Contact.Account.Bill_To_Site__r.Country__c,Contact.Account.Bill_To_Site__r.Zip__c,
                for(User u :[select id,Name,contactId,Contact.AccountID, Contact.Authorized_to_Order__c,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c,Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.BillingCountry,Contact.Account.ShippingPostalCode, Contact.Account.Type, Contact.Account.Primary_PSR__c, Contact.Account.RSM__c,Contact.Account.Theater__c,Contact.Account.Dealer_Tier__c from User where id = :userID and ContactID != null LIMIT 1])
                    dealerAccount = u.Contact.Account;
                if(dealerAccount != null){
                    purchaseOrder.Dealer_Account__r = dealerAccount;
                    purchaseOrder.Dealer_Account__c = dealerAccount.ID;
                }
                setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
                setFormatedBillToSiteAddress(purchaseOrder);
            }else{        // non-partner users can not create a new order they will see error message
                /* Added by Prakash For Back Button Issue When for Non-Partner Users and from Design starts */
                // Get healthy Spring 2017
                //if(ApexPages.currentPage().getParameters().get('DID') != null || ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM) != null){
                //    designID =ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM);
                //    if(designID == null || designID =='')
                //        designID =ApexPages.currentPage().getParameters().get('DID');
                //}
                /* Added by Prakash For Back Button Issue When for Non-Partner Users and from Design ends */
                // Get healthy Spring 2017 showErrorBlock = true;
                // Get healthy Spring 2017 errorOnTab = 0;
                isNewOrder = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardErrorMsgPOCreationForNonPartners);
                ApexPages.addMessage(errorMsg);
                return;
            }

            if(dealerAccount == null && !isPartnerUser){
                //Not a PArtner return
                // Get healthy Spring 2017 showErrorBlock = true;
                // Get healthy Spring 2017 errorOnTab = 0;

                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardErrorMsgPOCreationOrInvalidID);
                ApexPages.addMessage(errorMsg);
                return;
            }
            else{
                //checking Dealer Account type
                // Get healthy Spring 2017
                //if(dealerAccount.Type == RESIDENTIAL_INSTALLER){
                //    isDealerResidential = true;
                //}
                //Initlizing Products
                //initilizeSetCon();
                // Get healthy Spring 2017 currentDealersContactsMap = PriceListItemUtility.getContactsInMap(dealerAccount.ID);
                for(Bill_To_Site__c bTo : [Select b.Zip__c, b.State__c, b.Country__c, b.Site_ID__c, b.Oracle_Operating_Unit__c, b.Name, b.Id, b.Dealer_Account__c, b.City__c, b.Address3__c, b.Address2__c, b.Address1__c From Bill_To_Site__c b where b.Dealer_Account__c = :dealerAccount.Id order by LastModifiedDate desc LIMIT 1]){
                    //purchaseOrder.Bill_to_Site__r = bTo;
                    //purchaseOrder.Bill_to_Site__c = bTo.ID;
                    setFormatedBillToSiteAddress(purchaseOrder);
                }
                //initiLizeOppsList();
                //Start 96593
                // Get healthy Spring 2017
                //if(ApexPages.currentPage().getParameters().get('CF00N80000004Gzgd') != null || ApexPages.currentPage().getParameters().get('CF00N80000004Gzgd') == ''){
                //    oppNameFilter = ApexPages.currentPage().getParameters().get('CF00N80000004Gzgd');
                //    oppId = ApexPages.currentPage().getParameters().get('CF00N80000004Gzgd_lkid');
                //}
                //End 96593
                //for(Opportunity opp: [Select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where Owner.Contact.AccountID = :dealerAccount.ID lIMIT 1000]){
                // Get healthy Spring 2017
                //if(currentDealersOpportunity == null) currentDealersOpportunity = new List<Opportunity>();
                //if(currentDealersOpportunityMap == null) currentDealersOpportunityMap = new Map<ID,Opportunity>();
                //}
                //setDealerAndCustomerShipToSites();
                // Get healthy Spring 2017
                //if(purchaseOrder.Ship_to_Site__c != null){
                //    //if(dealerShiptoSiteMap != null && dealerShiptoSiteMap.get(purchaseOrder.Ship_to_Site__c) != null)
                //    //    setFormatedShipToSiteAddress(dealerShiptoSiteMap.get(purchaseOrder.Ship_to_Site__c));
                //    //else if(customerShiptoSiteMap != null && customerShiptoSiteMap.get(purchaseOrder.Ship_to_Site__c) != null)
                //    //    setFormatedShipToSiteAddress(customerShiptoSiteMap.get(purchaseOrder.Ship_to_Site__c));
                //}else{
                //}
                //Setting Dealer Shipping Address
                //setDealerShippingAddress();
            }
            //Initilizing selected Design Items
            InitilizeDesignProdItems();

            //Check if discounts exist for order
            //checkDiscounts();

            // fetch expediteFee from selected price list
            // Get healthy Spring 2017
            //selectedPriceList = PriceListItemUtility.getExpediteFeeForPriceList(dealerAccount.ID);
            //if(selectedPriceList != null && selectedPriceList.Expedite_Fee__c != null)
            //    expediteFeeForPriceList = selectedPriceList.Expedite_Fee__c;
            //// for a new purchase order
            //// 1)assign selectedPriceList.DSR_PO_Group_Email__c to purchaseOrder.DSR_PO_Group_Email__c
            //// 2)assign dealerAccount.Primary_PSR__c to purchaseOrder.Assigned_DSR__c
            //// 3)assign dealerAccount.RSM__c to purchaseOrder.Assigned_RSM__c
            //if(isNewOrder){
            //    if(selectedPriceList != null && selectedPriceList.DSR_PO_Group_Email__c != null)
            //        purchaseOrder.DSR_PO_Group_Email__c = selectedPriceList.DSR_PO_Group_Email__c;
            //    if(dealerAccount != null){
            //        if(dealerAccount.Primary_PSR__c != null)
            //            purchaseOrder.Assigned_DSR__c = dealerAccount.Primary_PSR__c;
            //        if(dealerAccount.RSM__c != null)
            //            purchaseOrder.Assigned_RSM__c = dealerAccount.RSM__c;
            //    }
            //}
            //if(isNewOrder) updatePOrder(true);
            // Get healthy Spring 2017
            //System.debug('In Constructor Going to set List from  dealerShiptoSiteMap::'+dealerShiptoSiteMap);
            //if(dealerShiptoSiteMap != null && dealerShiptoSiteMap.values().size()>0){
            //    System.debug('In Constructor Going to set List from resetDealersShipValues::');
            //    //resetDealersShipValues();
            //}

        }
    }//Check of isAuthorize
    /*        System.debug('Debug: End of Controller');
    if (selProductItems != null) {
    for(PurchaseOrderLineItemWrapper polw : selProductItems) {
    System.debug('Debug: End of Controller->'+polw.Name +'----'+polw.ID);
    }
    }




    */   // function ends
    //Start 96593
    // Get healthy Spring 2017
    //public String updateOpportunityStage(String oppId){
    //    Opportunity opp = getCustOpportunity(oppId);
    //    String oldStatus = opp.StageName;
    //    opp.StageName = 'Contract Signed';
    //    if(oldStatus != opp.StageName)
    //        update opp;
    //    moveAccordingToFilterOppsList();
    //    return oldStatus;
    //}
    //End 96593
    /** This function initializes price list items from design.
    */
    public void InitilizeDesignProdItems(){
        //For NEW When Design is there
        if(isNewOrder && isPartnerUser){
            // Get healthy Spring 2017
            //if(ApexPages.currentPage().getParameters().get('DID') != null || ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM) != null){
            //    boolean isItemAdded =false;
            //    designID =ApexPages.currentPage().getParameters().get(DESIGN_ID_PARAM);
            //    if(designID == null || designID =='')
            //        designID =ApexPages.currentPage().getParameters().get('DID');
            //    if(selProductItems == null)
            //        selProductItems = new List<PurchaseOrderLineItemWrapper>();
            //    selProductItems.clear();
            //    // to be changed for item-id
            //    //Start added for case # 00047219 - closed by customer
            //    //selectedDesign = PriceListItemUtility.setDesignItemswithPrice(designID, dealerAccount.ID, selProductItems, purchaseOrder, dealerAccount, isNAUser, isEUUser);
            //    selectedDesign = PriceListItemUtility.setDesignItemswithPrice(designID, dealerAccount.ID, selProductItems, purchaseOrder, dealerAccount, isNAUser);
            //    //End added for case # 00047219
            //    setErrorAlaCarteItems = PriceListItemUtility.setErrorAlaCarteItems;//for Case# 00088825
            //    //showProductList();
            //    serviceCreditSMSItemId = PriceListItemUtility.serviceCreditSMSItemId;
            //}
        }
        //For Existing Purchase Order
        else if(!isNewOrder){
            if(purchaseOrderList != null && purchaseOrderList.size()>0){
                purchaseOrderList = getSortedList(purchaseOrderList);
                if(selProductItems == null)
                    selProductItems = new List<PurchaseOrderLineItemWrapper>();
                selProductItems.clear();
                Map<String,PurchaseOrderWizardController.PurchaseOrderLineItemWrapper> childParentMap = new Map<String,PurchaseOrderWizardController.PurchaseOrderLineItemWrapper>();
                for(Purchase_Order_Line__c item:purchaseOrderList){
                    if (item.Oracle_Item_Id__r.Line_Type__c == 'Credit Only') {
                        serviceCreditSMSItemId = item.Oracle_Item_Id__r.Name;
                    }

                    PurchaseOrderLineItemWrapper pWrap = new PurchaseOrderLineItemWrapper();
                    copyItemToWrapper(item,pWrap);
                    selProductItems.add(pWrap);
                    if(pWrap.childID != null)
                        childParentMap.put(pWrap.childID,pWrap);
                }
                /*...................Code added for ................*/
                if(childParentMap != null && childParentMap.values().size() >0){
                    for(PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap:selProductItems){
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
    // Get healthy Spring 2017
    //public Boolean updatePOLineItems(){
    //    Boolean isError = false;
    //    System.debug('Entered in updatePOLineItems ');
    //    if(purchaseOrder.Order_Status__c == 'New'){
    //        if(purchaseOrderList == null || purchaseOrderList.size()==0)
    //            return isError;
    //        System.debug('Entered in updatePOLineItems in New');
    //        List<String> errMsgList;
    //        String errors = '';
    //        Date currentDate = Date.today();
    //        Date lastModifiedDate = date.newInstance((purchaseOrder.LastModifiedDate).year(), (purchaseOrder.LastModifiedDate).month(),(purchaseOrder.LastModifiedDate).day());
    //        // If the difference between current date and last modified date of purchase order
    //        // is greater than 1 day then update the po line items otherwise not
    //        if(currentDate >= lastModifiedDate.addDays(1)){
    //            if(selProductItems == null)
    //                selProductItems = new List<PurchaseOrderWizardController.PurchaseOrderLineItemWrapper>();
    //            selProductItems.clear();
    //            //Step 1 make Wizard Step 1 if older than one day
    //            purchaseOrder.Order_Wizard_Step__c ='Step 1';
    //            wizardStepNumber ='1';
    //            for(Purchase_Order_Line__c poLine :purchaseOrderList){
    //                System.debug('Here the item::'+poLine.Unit_Price__c);
    //            }
    //            //Check price and
    //            boolean isSmartPack =false;
    //            if(purchaseOrder.SunPower_Design__c != null)
    //                isSmartPack =true;
    //            //Start for case # 00047219 - closed by customer
    //            errMsgList = PriceListItemUtility.updatePOLineItems(purchaseOrderList,dealerAccount.Oracle_Operating_Unit__c,isSmartPack,purchaseOrder,isNAUser);
    //            //errMsgList = PriceListItemUtility.updatePOLineItems(purchaseOrderList,dealerAccount.Oracle_Operating_Unit__c,isSmartPack,purchaseOrder,isNAUser, isEUUser);
    //            //End for case # 00047219 - closed by customer

    //            for(Purchase_Order_Line__c poLine :purchaseOrderList){
    //                System.debug('Here the item List after Saving Prakash::'+poLine.Unit_Price__c);
    //            }
    //            if(errMsgList!= null && errMsgList.size() > 0 && errMsgList.get(0).indexof('PRICECHANGED:') >= 0){
    //                //wizardStepNumber = '1';
    //                errMsgList.clear();
    //            }else if(errMsgList!= null && errMsgList.size() > 0){
    //                //selProductItems.clear();
    //                isError = true;
    //                for(String error : errMsgList){
    //                    if(error != null && (error.indexOf('PRICECHANGED:') >=0 || error.indexOf('NOITEMFOUND:')>=0)){
    //                        errors = errors + ' Purchase Order line items not found';
    //                        continue;
    //                    }
    //                    errors = errors + error;
    //                }
    //                errorOnTab = 1;
    //                purchaseOrder.Order_Status__c = 'Error';
    //                purchaseOrder.Order_Status_Interface_Message__c = errors;
    //                showMessages(errMsgList);
    //            }
    //            InitilizeDesignProdItems();
    //            updatePOrder(true);

    //            if(selProductItems != null){
    //                for(PurchaseOrderLineItemWrapper pWrap:selProductItems ){
    //                    System.debug(pWrap.oracleItemIDRef);
    //                    System.debug(pWrap.lineNumber);
    //                    System.debug(pWrap.Qty);
    //                    System.debug('\n::::::::::::::::::::::::::::\n');
    //                }
    //            }

    //            //calculateOrderPrice();
    //            updatePOrder(false);
    //        }
    //    }
    //    if(isError) selProductItems.clear();
    //    return isError;
    //}//function ends

    /** This function adds the error messages in apex page error,
    *  regarding the updatePOLineItems
    */
    // Get healthy Spring 2017
    //private void showMessages(List<String> messages){
    //    for(String s :messages){
    //        if(s != null && s.indexOf('ERROR:')>=0){
    //            String[] split = s.split('\\:');
    //            if(split.size()>=2){
    //                if(split[1].indexOf('ERROR:') >=0)
    //                    split[1] =split[1].replaceAll('ERROR:','\n');
    //                else
    //                    split[1] = split[1] + '\n';
    //            }
    //            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,split[1]);
    //            System.debug(split[1]);
    //            ApexPages.addMessage(errorMsg);
    //            //if(!isErrorFound) isErrorFound =true;
    //        }
    //    }
    //}

    /** This function copy a price list item to wrapper object.
    *  @param Purchase_Order_Line__c
    *  @param PurchaseOrderLineItemWrapper
    */
    private void copyItemToWrapper(Purchase_Order_Line__c pLine, PurchaseOrderLineItemWrapper pWrap){
        PriceListItemUtility.copyItemToWrapper(purchaseOrder,pLine,pWrap);
    }

    /** This function deletes a price list item from the list of PurchaseOrderLineItemWrapper.
    *
    */
    // Get healthy Spring 2017
    //public PageReference delItemFromList(){
    //    synchQuantity();
    //    changedQty='';
    //    if(hdnDelProdLineId == null || hdnDelProdLineId =='')
    //        return null;
    //    //Delete Item Product Wrap Here
    //    deleteFromProductWrapperList(hdnDelProdLineId);
    //    //calculateDiscount();
    //    return null;
    //}

    /** This function deletes a price list item from the list of PurchaseOrderLineItemWrapper.
    *  @param id
    */
    // Get healthy Spring 2017
    //private void deleteFromProductWrapperList(String id){
    //    Integer kitItemCount=0;// For case 00057686
    //    if(selProductItems == null || selProductItems.size()==0) return;
    //    List<PurchaseOrderLineItemWrapper> tempProdList = new List<PurchaseOrderLineItemWrapper>();
    //    boolean removePromoDiscount=false; // For case 00057686

    //    for(PurchaseOrderLineItemWrapper wrapProd:selProductItems){// For case 00057686
    //        if(wrapProd.itemID=='114556'){
    //            kitItemCount=kitItemCount+PriceListItemUtility.covertStringToInt(wrapProd.Qty);
    //        }
    //    }
    //    for(PurchaseOrderLineItemWrapper wrapProd:selProductItems){
    //        if(kitItemCount==1){
    //            removePromoDiscount=true;   // For case 00057686
    //        }

    //        if(wrapProd.ID != id && wrapProd.parentID != id){
    //            if(wrapProd.itemID=='135176' && removePromoDiscount){  // For case 00057686
    //                continue;
    //            }else{
    //                tempProdList.add(wrapProd);
    //            }
    //        }
    //    }
    //    selProductItems.clear();

    //    selProductItems.addAll(tempProdList);
    //}

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
        public Decimal discountAmount {get;set;}
        public String discountPercent {get;set;}
        public Decimal shippingCharges {get;set;}
        public Decimal bundleSize {get;set;}
        public String error {get;set;}
        public Purchase_Order_Line__c pOrderLine {get;set;}
        public String type1{get;set;}
        public String type2{get;set;}
        public String type3{get;set;}
        public String childID{get;set;}
        public String childDescription{get;set;}
        public String childName{get;set;}
        public String parentID{get;set;}
        public String itemSource{get;set;}//for Case# 00077093
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

    /*Section For Products List starts Here */
    // Get healthy Spring 2017 public String singleAddedprodId {get;set;}
    // Get healthy Spring 2017
    //public PageReference updateQuantity(){
    //    System.debug('Changed Quantity:' + changedQty);
    //    System.debug('Items Before:' + selProductItems);
    //    synchQuantity();
    //    System.debug('Items After Quantity Update:' + selProductItems);
    //    changedQty='';
    //    //calculateDiscount();

    //    System.debug('Items After Discount:' + selProductItems);
    //    return null;
    //}

    /** This function takes the list of price lite items .
    *  @return  PageReference
    */
    // Get healthy Spring 2017
    //public PageReference addItemToList(){
    //    synchQuantity();
    //    changedQty='';
    //    if(singleAddedprodId == null || singleAddedprodId=='' )
    //        return null;
    //    for(Price_List_Item__c prod:products){
    //        try{
    //            if(prod.ID == singleAddedprodId){
    //                addProductItemToList(prod);
    //            }
    //        }catch(Exception e){

    //        }
    //    }
    //    //calculateDiscount();
    //    return null;
    //}

    /** This function adds a price list item to the list of selected price list items.
    *  @param  Price_List_Item__c
    */
    // Get healthy Spring 2017
    //private void addProductItemToList(Price_List_Item__c prod){
    //    if (prod ==null) return;
    //    // to be changed for item-id
    //    String ChangeChildID='';
    //    String parentID ='';
    //    String localChangeQuantity='0.0';
    //    PurchaseOrderLineItemWrapper productWrapper = new PurchaseOrderLineItemWrapper(prod.ID,'0.0',prod.Item_Description__c,prod.Type_2__c,String.valueof(inputQuantity),prod.CurrencyIsoCode,prod.Pricing_1__c,calculateTotalPrice(prod.Pricing_1__c, Integer.valueOf(inputQuantity)),false,false);

    //    /* Newly added for disconnect Item starts*/
    //    if(prod.Disc_Item_ID__c !=null){
    //        productWrapper.childID=prod.Disc_Item_ID__c;
    //        productWrapper.childDescription = prod.Disc_Item_Description__c;
    //        productWrapper.childName=prod.Disc_Item_ID__r.Name;

    //    }
    //    /* Newly added for disconnect Item ends*/
    //    productWrapper.oracleItemIDRef = prod.Item_ID__c;
    //    productWrapper.itemID = prod.item_description__c;

    //    if(selProductItems != null && selProductItems.size()>0){
    //        boolean isAdded =false;
    //        for(PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
    //            if(prodWrapper.ID == prod.ID){
    //                prodWrapper.qty = String.valueOf(Integer.valueOf(prodWrapper.Qty) + Integer.valueOf(inputQuantity));
    //                prodWrapper.totalPrice = calculateTotalPrice(prodWrapper.perUnitPrice, Integer.valueOf(prodWrapper.qty));
    //                prodWrapper.pOrderLine.Price__c = calculateTotalPrice(prodWrapper.perUnitPrice, Integer.valueOf(prodWrapper.qty));
    //                if(prodWrapper.childID != null && prodWrapper.childID != ''){
    //                    ChangeChildID= prodWrapper.childID;
    //                    localChangeQuantity =prodWrapper.qty;
    //                    parentID = prodWrapper.ID;
    //                }

    //                isAdded =true;
    //                break;
    //            }
    //        }
    //        if(!isAdded){
    //            //PurchaseOrderLineItemWrapper(String ID,String lineNumber,String Name,String prodType,String Qty,Boolean isSmartPack,Boolean isFromDesign)
    //            counter++;
    //            if(productWrapper.childID != null && productWrapper.childID != '')
    //                selProductItems.add(0,PriceListItemUtility.addNewDisconnectItem(productWrapper));
    //            selProductItems.add(0,productWrapper);
    //        }else if(ChangeChildID != null && ChangeChildID != '') {
    //            for(PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
    //                if(prodWrapper.ID == ChangeChildID && parentID == prodWrapper.parentID ){
    //                    prodWrapper.Qty= localChangeQuantity;
    //                }

    //            }
    //        }

    //    }else{
    //        if(selProductItems == null) {
    //            selProductItems = new List<PurchaseOrderLineItemWrapper>();
    //        }
    //        if(selProductItems.size() == 0){
    //            if(productWrapper.childID != null && productWrapper.childID != ''){
    //                selProductItems.add(PriceListItemUtility.addNewDisconnectItem(productWrapper));
    //                selProductItems.add(0,productWrapper);
    //            }else
    //                selProductItems.add(productWrapper);
    //        }else{
    //            if(productWrapper.childID != null && productWrapper.childID != '')
    //                selProductItems.add(0,PriceListItemUtility.addNewDisconnectItem(productWrapper));
    //            selProductItems.add(0,productWrapper);
    //        }

    //    }
    //    productWrapper.itemSource = 'Ala Carte';//for Case# 00077093
    //    if(productWrapper.itemID=='114556'){
    //        PriceListItemUtility.addPromotionalDiscount(selProductItems,prod.Item_ID__r.Name);
    //    }
    //    //calculateDiscount();
    //}//Funtion ends

    // Get healthy Spring 2017
    //public Decimal calculateTotalPrice(decimal unitPrice, integer qty){
    //    if(unitPrice != null)
    //        return unitPrice*qty;
    //    else
    //        return 0;
    //}

    /** This function initializes standard set controller of price list items.
    *
    */
    // Get healthy Spring 2017
    //private void initilizeSetCon(){
    //    PAGINATION_COUNTER=5;
    //    PAGINATION_COUNTERONPAGE=0;
    //    if(dealerAccount != null){
    //        // for purchase order having design id fetch only BOS Category products otherwise all
    //        if(ApexPages.currentPage().getParameters().get('DID') == null && purchaseOrder.SunPower_Design__c == null){
    //            // to be changed for item-id
    //            setCon = PriceListItemUtility.getPriceListForDealer2AlaCarte(dealerAccount.id);
    //        }else{
    //            // to be changed for item-id
    //            setCon = PriceListItemUtility.getPriceListForDealer2AlaCarteAndBOS(dealerAccount.id);
    //        }
    //        if(setCon != null && setCon.getResultSize() != 0){
    //            if(setCon.getResultSize() < (PAGINATION_COUNTERONPAGE+PAGINATION_COUNTER)){
    //                PAGINATION_COUNTERONPAGE = setCon.getResultSize() - PAGINATION_COUNTER;
    //            }
    //            else
    //                PAGINATION_COUNTERONPAGE = PAGINATION_COUNTER;
    //            setCon.setPageSize(PAGINATION_COUNTER);
    //            products = (List<Price_List_Item__c>) setCon.getRecords();
    //        }else{
    //            products = new List<Price_List_Item__c>();
    //        }
    //    }
    //}

    // Get healthy Spring 2017
    //public PageReference moveOppsShowLink(){
    //    PAGINATION_COUNTER_OPPLIST = PAGINATION_COUNTER_OPPLIST + PAGINATION_COUNTERONPAGE_OPPLIST;
    //    Map<String,Integer> retArgs = paginator.getOppListSearched(acctID, oppNameFilter,isNAUser,PAGINATION_COUNTER_OPPLIST,PAGINATION_COUNTERONPAGE_OPPLIST);
    //    InitilizePaginatorValues(retArgs);
    //    return null;
    //}

    // Get healthy Spring 2017
    //public PageReference moveProductsShowLink(){
    //    PAGINATION_COUNTER = PAGINATION_COUNTER + PAGINATION_COUNTERONPAGE;
    //    if(selectedCategory != null){
    //        //setCon = PriceListItemUtility.getPriceListForDealer2_FilterType2AlaCarte(dealerAccount.id,selectedCategory,prodNameFilter);//removed for case # 00047707
    //        setCon = PriceListItemUtility.getPriceListForDealer2_FilterType2AlaCarte(dealerAccount.id,selectedCategory,prodDescFilter);//added for case # 00047707
    //        if(setCon != null){
    //            if(setCon.getResultSize() != 0){
    //                if(setCon.getResultSize() <= (PAGINATION_COUNTERONPAGE+PAGINATION_COUNTER))
    //                    PAGINATION_COUNTERONPAGE = setCon.getResultSize() - PAGINATION_COUNTER;
    //                else
    //                    PAGINATION_COUNTERONPAGE = PAGINATION_COUNTER;
    //                setCon.setPageSize(PAGINATION_COUNTER);
    //            }
    //        }
    //    }else{
    //        //initilizeSetCon();
    //    }
    //    return null;
    //}

    /** This function is responsible to filter the price list items according to type.
    *  @return  PageReference
    */
    // Get healthy Spring 2017
    //public PageReference moveAccordingToFilter(){
    //    if(selectedCategory != null){
    //        PAGINATION_COUNTER=5;
    //        PAGINATION_COUNTERONPAGE = 5;
    //        //setCon = PriceListItemUtility.getPriceListForDealer2_FilterType2AlaCarte(dealerAccount.id,selectedCategory,prodNameFilter);//removed for case # 00047707
    //        setCon = PriceListItemUtility.getPriceListForDealer2_FilterType2AlaCarte(dealerAccount.id,selectedCategory,prodDescFilter);//added for case # 00047707
    //        if(setCon != null){
    //            if(setCon.getResultSize() != 0){
    //                if(setCon.getResultSize() <= (PAGINATION_COUNTERONPAGE+PAGINATION_COUNTER))
    //                    PAGINATION_COUNTERONPAGE = setCon.getResultSize() - PAGINATION_COUNTER;
    //                else
    //                    PAGINATION_COUNTERONPAGE = PAGINATION_COUNTER;
    //                setCon.setPageSize(PAGINATION_COUNTER);
    //            }
    //        }
    //    }else{
    //        //initilizeSetCon();
    //    }
    //    return null;
    //}

    /** This getter function is to get the records from standard set controller
    *  and set them to list of price list items.
    *  @return  List<Price_List_Item__c>
    */
    // Get healthy Spring 2017
    //public List<Price_List_Item__c> getProducts(){
    //    if(setCon == null){
    //        //initilizeSetCon();
    //    }
    //    if(setCon != null) {
    //        if(setCon.getResultSize() != 0){

    //            products = (List<Price_List_Item__c>) setCon.getRecords();
    //        }
    //        else
    //            products = new List<Price_List_Item__c>();
    //        return products;
    //    }
    //    return null;
    //}

    /** This function is responsible to navigate to next set of records in pagination.
    *  @return  PageReference
    */
    // Get healthy Spring 2017
    //public PageReference moveNext(){
    //    if(setCon != null)
    //        setCon.next();
    //    return null;
    //}

    /** This function is responsible to navigate to previous set of records in pagination.
    *  @return  PageReference
    */
    // Get healthy Spring 2017
    //public PageReference movePrevious(){
    //    if(setCon != null)
    //        setCon.previous();
    //    return null;
    //}

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
                shipToSiteAddress+=shipSite.Address1__c;
            }if(shipSite.Address2__c != null){
                shipToSiteAddress+=' ' + shipSite.Address2__c;
            }if(shipSite.Address3__c != null){
                shipToSiteAddress+=' ' + shipSite.Address3__c;
            }
            shipToSiteAddress+=' ';
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
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Address1__c;
                }if(pOrder.Bill_to_Site__r.Address2__c != null){
                    billToSiteAddress+=' ' + pOrder.Bill_to_Site__r.Address2__c;
                }if(pOrder.Bill_to_Site__r.Address3__c != null){
                    billToSiteAddress+=' ' + pOrder.Bill_to_Site__r.Address3__c;
                }
                billToSiteAddress+=' ';
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
    // Get healthy Spring 2017
    //private void setDealerAndCustomerShipToSites(){
    //    String qry = '';
    //    if(dealerAccount != null){
    //        qry+= 'Select s.Type__c, s.RecordType.DeveloperName,s.Residential_Customer_Account__c,s.Zip__c, s.ID,s.State__c, s.Dealer_Account__c, s.Country__c, s.City__c, s.Address3__c, s.Address2__c, s.Address1__c, s.Contact_Email__c, s.Contact_First_Name__c, s.Contact_Last_Name__c, s.Contact_Phone__c From Ship_to_Site__c s where s.Dealer_Account__c = \''+dealerAccount.id +'\'';
    //        //qry+= 'Select s.Type__c, s.RecordType.DeveloperName,s.Residential_Customer_Account__c,s.Zip__c, s.ID,s.State__c, s.Dealer_Account__c, s.City__c, s.Address3__c, s.Address2__c, s.Address1__c, s.Contact_Email__c, s.Contact_First_Name__c, s.Contact_Last_Name__c, s.Contact_Phone__c From Ship_to_Site__c s where s.Dealer_Account__c = \''+dealerAccount.id +'\'';
    //        for(Ship_To_Site__c sh:Database.query(qry)){
    //            if(sh.Residential_Customer_Account__c != null && customersAccountsIDs.contains(sh.Residential_Customer_Account__c) && sh.Dealer_Account__c != null && sh.Dealer_Account__c == dealerAccount.ID){
    //                if(customerShiptoSiteMap == null) customerShiptoSiteMap = new Map<ID,Ship_To_Site__c>();
    //                customerShiptoSiteMap.put(sh.ID,sh);
    //            }
    //            //else
    //            if(sh.Dealer_Account__c != null && sh.Dealer_Account__c == dealerAccount.ID){
    //                if(dealerShiptoSiteMap == null) dealerShiptoSiteMap = new Map<ID,Ship_To_Site__c>();
    //                dealerShiptoSiteMap.put(sh.ID,sh);
    //            }
    //        }
    //    }
    //}

    /** set dealer shipping address.
    */
    // Get healthy Spring 2017
    //private void setDealerShippingAddress(){
    //    if(dealerAccount != null){
    //        dealerAccountShippingAddress='';
    //        if(dealerAccount.ShippingStreet != null)
    //            dealerAccountShippingAddress+=dealerAccount.ShippingStreet +', ';
    //        if(dealerAccount.ShippingCity!= null)
    //            dealerAccountShippingAddress+=dealerAccount.ShippingCity +', ';
    //        if(dealerAccount.ShippingState != null)
    //            dealerAccountShippingAddress+=dealerAccount.ShippingState +', ';
    //        if(dealerAccount.ShippingPostalCode != null)
    //            dealerAccountShippingAddress+=dealerAccount.ShippingPostalCode +' ,';
    //        if(dealerAccount.ShippingCountry != null)
    //            dealerAccountShippingAddress+=dealerAccount.ShippingCountry;
    //    }
    //}

    /**set the Dealer Address in shipToSite Object.
    */
    // Get healthy Spring 2017
    //public PageReference setDealerAddressToShipToSite(){
    //    if(dealerAccount != null){
    //        Ship_to_Site__c shipSiteNew;
    //        String uniqueAddressKey='';
    //        uniqueAddressKey = dealerAccount.ShippingStreet == null ?  '' :dealerAccount.ShippingStreet;
    //        uniqueAddressKey = uniqueAddressKey + (dealerAccount.ShippingCity == null ? '' : dealerAccount.ShippingCity);
    //        uniqueAddressKey = uniqueAddressKey + (dealerAccount.ShippingState == null ? '' : dealerAccount.ShippingState);
    //        uniqueAddressKey = uniqueAddressKey + (dealerAccount.ShippingPostalCode == null ? '' : dealerAccount.ShippingPostalCode);
    //        uniqueAddressKey = uniqueAddressKey + (dealerAccount.ShippingCountry == null ? '' : dealerAccount.ShippingCountry);
    //        List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c,Country__c,contact_email__c,contact_first_name__c,contact_last_name__c,contact_phone__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID  LIMIT 1];
    //        //List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID  LIMIT 1];
    //        if(listShipSites != null && listShipSites.size() > 0){
    //            purchaseOrder.Ship_to_Site__c =  listShipSites.get(0).ID;
    //            purchaseOrder.Ship_to_Site__r = listShipSites.get(0);
    //        }else{
    //            shipSiteNew = new  Ship_to_Site__c();
    //            shipSiteNew.Address1__c=dealerAccount.ShippingStreet;
    //            shipSiteNew.State__c=dealerAccount.ShippingState;
    //            shipSiteNew.Country__c = dealerAccount.ShippingCountry;
    //            shipSiteNew.Zip__c = dealerAccount.ShippingPostalCode;
    //            shipSiteNew.City__c = dealerAccount.ShippingCity;
    //            shipSiteNew.Dealer_Account__c = dealerAccount.ID;
    //            //Start for case#00078901
    //            if(dealerAccount.ShippingCountry == null || dealerAccount.ShippingCountry == ''){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardCountryRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            //End for case#00078901
    //            if((dealerAccount.ShippingState =='' || dealerAccount.ShippingState==null) && (dealerAccount.ShippingCountry == 'United States' || dealerAccount.ShippingCountry =='US' || dealerAccount.ShippingCountry == 'USA' || dealerAccount.ShippingCountry == 'United States of America' )){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardStateRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            //Start for Case# 00085118
    //            if(dealerAccount.ShippingStreet == null || dealerAccount.ShippingStreet == ''){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardStreetRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            //End for Case# 00085118
    //            insert shipSiteNew;
    //            purchaseOrder.Ship_to_Site__c = shipSiteNew.ID;
    //            purchaseOrder.Ship_to_Site__r = shipSiteNew;
    //        }
    //        //Start 94300
    //        if(purchaseOrder.Notes__c != null && String.valueOf(purchaseOrder.Notes__c).length() > 255){
    //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardNotesLengthExceeds));
    //            errorOnTab = 3;
    //            return null;
    //        }
    //        //End 94300
    //        update purchaseOrder;
    //        setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
    //    }
    //    return null;
    //}

    // Get healthy Spring 2017
    //public PageReference setOppBillingAddressToShipToSite(){
    //    Account acc = getCustOpportunity(selectedCustomerOpportunity).Account;

    //    if(dealerAccount != null && acc!=null){
    //        Ship_to_Site__c shipSiteNew;
    //        String uniqueAddressKey='';
    //        uniqueAddressKey = acc.BillingStreet == null ?  '' :acc.BillingStreet;
    //        uniqueAddressKey = uniqueAddressKey + (acc.BillingCity == null ? '' : acc.BillingCity);
    //        uniqueAddressKey = uniqueAddressKey + (acc.BillingState == null ? '' : acc.BillingState);
    //        uniqueAddressKey = uniqueAddressKey + (acc.BillingPostalCode == null ? '' : acc.BillingPostalCode);
    //        uniqueAddressKey = uniqueAddressKey + (acc.BillingCountry == null ? '' : acc.BillingCountry);
    //        List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c,Country__c,contact_email__c,contact_first_name__c,contact_last_name__c,contact_phone__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID and Residential_Customer_Account__c =:acc.ID  LIMIT 1];
    //        //List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID and Residential_Customer_Account__c =:acc.ID  LIMIT 1];
    //        if(listShipSites != null && listShipSites.size() > 0){
    //            purchaseOrder.Ship_to_Site__c =  listShipSites.get(0).ID;
    //            purchaseOrder.Ship_to_Site__r = listShipSites.get(0);
    //        }else{
    //            shipSiteNew = new  Ship_to_Site__c();
    //            shipSiteNew.Address1__c=acc.BillingStreet;
    //            shipSiteNew.State__c=acc.BillingState;
    //            shipSiteNew.Country__c = acc.BillingCountry;
    //            shipSiteNew.Zip__c = acc.BillingPostalCode;
    //            shipSiteNew.City__c = acc.BillingCity;
    //            shipSiteNew.Dealer_Account__c = dealerAccount.ID;
    //            shipSiteNew.Residential_Customer_Account__c = acc.ID;
    //            shipSiteNew.RecordTypeId =recTypes.get('Opportunity');
    //            //Start for case#00078901
    //            if(acc.BillingCountry == null || acc.BillingCountry == ''){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardBCountryRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            if((acc.BillingState =='' || acc.BillingState==null) && (acc.BillingCountry == 'United States' || acc.BillingCountry =='US' || acc.BillingCountry == 'USA' || acc.BillingCountry == 'United States of America' )){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardBStateRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            //End for case#00078901
    //            //Start for Case# 00085118
    //            if(acc.BillingState == null || acc.BillingState == ''){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardBStreetRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            //End for Case# 00085118
    //            insert shipSiteNew;
    //            purchaseOrder.Ship_to_Site__c = shipSiteNew.ID;
    //            purchaseOrder.Ship_to_Site__r = shipSiteNew;
    //        }
    //        //Start 94300
    //        if(purchaseOrder.Notes__c != null && String.valueOf(purchaseOrder.Notes__c).length() > 255){
    //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardNotesLengthExceeds));
    //            errorOnTab = 3;
    //            return null;
    //        }
    //        //End 94300
    //        update purchaseOrder;
    //        setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
    //    }
    //    return null;
    //}

    // Get healthy Spring 2017
    //public PageReference setOppShippingAddressToShipToSite(){
    //    Account acc = getCustOpportunity(selectedCustomerOpportunity).Account;
    //    if(dealerAccount != null && acc !=null){
    //        Ship_to_Site__c shipSiteNew;
    //        String uniqueAddressKey='';
    //        uniqueAddressKey = acc.ShippingStreet == null ?  '' :acc.ShippingStreet;
    //        uniqueAddressKey = uniqueAddressKey + (acc.ShippingCity == null ? '' : acc.ShippingCity);
    //        uniqueAddressKey = uniqueAddressKey + (acc.ShippingState == null ? '' : acc.ShippingState);
    //        uniqueAddressKey = uniqueAddressKey + (acc.ShippingPostalCode == null ? '' : acc.ShippingPostalCode);
    //        uniqueAddressKey = uniqueAddressKey + (acc.ShippingCountry == null ? '' : acc.ShippingCountry);
    //        List<Ship_to_Site__c> listShipSites = [Select Id,Address1__c,Address2__c,Address3__c,City__c,State__c,Zip__c,Country__c,contact_email__c,contact_first_name__c,contact_last_name__c,contact_phone__c from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey AND Dealer_Account__c =:dealerAccount.ID and Residential_Customer_Account__c =:acc.ID  LIMIT 1];
    //        if(listShipSites != null && listShipSites.size() > 0){
    //            purchaseOrder.Ship_to_Site__c =  listShipSites.get(0).ID;
    //            purchaseOrder.Ship_to_Site__r = listShipSites.get(0);
    //        }else{
    //            shipSiteNew = new  Ship_to_Site__c();
    //            shipSiteNew.Address1__c=acc.ShippingStreet;
    //            shipSiteNew.State__c=acc.ShippingState;
    //            shipSiteNew.Country__c = acc.ShippingCountry;
    //            shipSiteNew.Zip__c = acc.ShippingPostalCode;
    //            shipSiteNew.City__c = acc.ShippingCity;
    //            shipSiteNew.Dealer_Account__c = dealerAccount.ID;
    //            shipSiteNew.Residential_Customer_Account__c = acc.ID;
    //            shipSiteNew.RecordTypeId =recTypes.get('Opportunity');
    //            //Start for case#00078901
    //            if(acc.ShippingCountry == null || acc.ShippingCountry == ''){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardCountryRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            //End for case#00078901
    //            if((acc.ShippingState =='' || acc.ShippingState==null) && (acc.ShippingCountry == 'United States' || acc.ShippingCountry =='US' || acc.ShippingCountry == 'USA' || acc.ShippingCountry == 'United States of America' )){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardStateRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            //Start for Case# 00085118
    //            if(acc.ShippingStreet == null || acc.ShippingStreet == ''){
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardStreetRequiredMssg));
    //                errorOnTab=3;
    //                return null;
    //            }
    //            //End for Case# 00085118
    //            insert shipSiteNew;
    //            purchaseOrder.Ship_to_Site__c = shipSiteNew.ID;
    //            purchaseOrder.Ship_to_Site__r = shipSiteNew;
    //        }
    //        //Start 94300
    //        if(purchaseOrder.Notes__c != null && String.valueOf(purchaseOrder.Notes__c).length() > 255){
    //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardNotesLengthExceeds));
    //            errorOnTab = 3;
    //            return null;
    //        }
    //        //End 94300
    //        update purchaseOrder;
    //        setFormatedShipToSiteAddress(purchaseOrder.Ship_to_Site__r);
    //    }
    //    return null;
    //}

    // Get healthy Spring 2017 public List<Ship_To_Site__c> dealerWAREShipToSiteValues {get;set;}
    // Get healthy Spring 2017 public List<Ship_To_Site__c> dealerRESIShipToSiteValues {get;set;}

    /** This function set the ship to site for purchase order.
    */
    // Get healthy Spring 2017
    //public PageReference setPOShipToSite(){
    //    if(selectedShipToSiteID == null || selectedShipToSiteID =='')
    //        return null;
    //    Ship_to_Site__c localShipSite = null;

    //    if(dealerShiptoSiteMap != null && dealerShiptoSiteMap.size()>0)
    //        localShipSite = dealerShiptoSiteMap.get(selectedShipToSiteID);
    //    else{
    //        dealerShiptoSiteMap = new Map<ID,Ship_to_Site__c>();
    //        dealerWAREShipToSiteValues = new List<Ship_to_Site__c>();
    //        dealerRESIShipToSiteValues  = new List<Ship_to_Site__c>();
    //    }

    //    if(localShipSite != null){
    //        purchaseOrder.Ship_to_Site__c = localShipSite.ID;
    //        upsert purchaseOrder;
    //        setFormatedShipToSiteAddress(localShipSite);
    //    }else{
    //        for(Ship_to_Site__c site:[Select s.Type__c,s.RecordType.DeveloperName,s.Residential_Customer_Account__c,s.Zip__c, s.ID,s.State__c, s.Dealer_Account__c, s.Country__c, s.City__c, s.Address3__c, s.Address2__c, s.Address1__c, s.Contact_Email__c, s.Contact_First_Name__c, s.Contact_Last_Name__c, s.Contact_Phone__c From Ship_to_Site__c s where id =:selectedShipToSiteID LIMIT 1]){
    //            //for(Ship_to_Site__c site:[Select s.Type__c,s.RecordType.DeveloperName,s.Residential_Customer_Account__c,s.Zip__c, s.ID,s.State__c, s.Dealer_Account__c,s.City__c, s.Address3__c, s.Address2__c, s.Address1__c, s.Contact_Email__c, s.Contact_First_Name__c, s.Contact_Last_Name__c, s.Contact_Phone__c From Ship_to_Site__c s where id =:selectedShipToSiteID LIMIT 1]){
    //            purchaseOrder.Ship_to_Site__c=site.ID;
    //            dealerShiptoSiteMap.put(site.ID,site);
    //            resetDealersShipValues();
    //            setFormatedShipToSiteAddress(site);
    //        }
    //    }
    //    errorOnTab=0;
    //    return null;
    //}

    // Get healthy Spring 2017
    //public PageReference setPOShipToSiteContact(){
    //    if(selectedShipToSiteConID == null || selectedShipToSiteConID =='')
    //        return null;
    //    Contact con =null;
    //    if(currentOpportunityContactsMap != null)
    //        con =currentOpportunityContactsMap.get(selectedShipToSiteConID);
    //    if(con ==null && currentDealersContactsMap!= null)
    //        con = currentDealersContactsMap.get(selectedShipToSiteConID);
    //    if(con ==null){
    //        for(Contact c :[select id,firstname,LastName,email from Contact where id =:selectedShipToSiteConID Limit 1])
    //            con=c;
    //        currentDealersContactsMap = PriceListItemUtility.getContactsInMap(dealerAccount.ID);
    //        if(selectedOpportunity != null)
    //            currentOpportunityContactsMap = PriceListItemUtility.getContactsInMap(selectedOpportunity.Account.ID);
    //    }
    //    if(con !=null){
    //        purchaseOrder.Ship_To_Contact__c =con.ID;
    //        purchaseOrder.Ship_To_Contact__r = con;
    //        update purchaseOrder;
    //    }
    //    return null;
    //}

    //method to default Shipping Method and Shiping to Address
    public void defaultShipping(){
        //KCM_01102016: the shipping method should only get a default value if the region is not EU
        if (!isEUUser) {
            if(purchaseOrder.Shipping_Method__c ==null || purchaseOrder.Shipping_Method__c==''){
                purchaseOrder.Shipping_Method__c=Label.PurchaseOrderDefaultShippingMethod;
            }
        }

        if(purchaseOrder.Ship_to_Site__c==null){
            if(selectedShipToSiteID==null){
                if(partnerAcc.Default_Dealer_Warehouse_Shipping_Site__c!=null){
                    selectedShipToSiteID=partnerAcc.Default_Dealer_Warehouse_Shipping_Site__c;
                    //System.debug('selectedShipToSiteID-----'+selectedShipToSiteID);
                    //System.debug('Calling-----SetPOShipToSite');
                    //setPOShipToSite();
                }
            }
        }
    }

    /** on Page Load when Page open with contating Design ID.
    */
    public PageReference updatePOOnAction(){
        if(isUserAuthorized && isPartnerUser){
            //Start 00118354
            // Get healthy Spring 2017
            //if(isNewOrder && oppId!=null && oppId!=''){
            //    Opportunity opp = getCustOpportunity(oppId);
            //    if(opp!=null && opp.stageName == 'Installation Completed'){
            //        // Get healthy Spring 2017 showErrorBlock = true;
            //        errorOnTab = 0;
            //        invalidOpportunity = true;
            //        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POOpportunityRestriction);
            //        ApexPages.addMessage(errorMsg);
            //        return null;
            //    }
            //}
            //End 00118354
            // Get healthy Spring 2017
            //if(isNewOrder && purchaseOrder != null && selectedDesign == null && designID != null){
            //    // Get healthy Spring 2017 showErrorBlock = true;
            //    // Get healthy Spring 2017 errorOnTab = 0;
            //    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardErrorMsgDesignItemInActive);
            //    ApexPages.addMessage(errorMsg);
            //    //Start for Case# 00088825
            //    if(setErrorAlaCarteItems != null){
            //        errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, setErrorAlaCarteItems);
            //        ApexPages.addMessage(errorMsg);
            //    }
            //    //End for Case# 00088825
            //}else
            if(isNewOrder && purchaseOrder != null){
                // Get healthy Spring 2017 purchaseOrder.Order_Wizard_Step__c ='Step 1';
                //Start 96593
                // Get healthy Spring 2017
                //if(oppId != null){
                //    //purchaseOrder.lastOppStatus__c = updateOpportunityStage(oppId);
                //}
                //End 96593
                defaultShipping();
                updatePOrder(true);
            }else if(purchaseOrder != null && !isNewOrder){

                Boolean isError = false; //updatePOLineItems();
                if(isError)  {
                    PageReference pg = new PageReference('/apex/PurchaseOrderWizard?POID='+purchaseOrder.Id);
                    return pg.setRedirect(true);
                }
            }
        }else if(!isPartnerUser){
            //Come here when Non PArtner User came for creating a new order
            if(purchaseOrder == null || purchaseOrder.ID == null){
                // Get healthy Spring 2017 showErrorBlock = true;
                // Get healthy Spring 2017 errorOnTab = 0;
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
        // Get healthy Spring 2017
        //if(isNAUser || isEUUser || !isPartnerUser)
        //    termsDocID = PriceListItemUtility.getTermsDocumentsID(dealerAccount);
        return null;
    }

    /** This function resets the Dealer ship to site values .
    */
    // Get healthy Spring 2017
    //private void resetDealersShipValues(){
    //    if(dealerWAREShipToSiteValues != null) dealerWAREShipToSiteValues.clear();
    //    if(dealerRESIShipToSiteValues != null) dealerRESIShipToSiteValues.clear();
    //    if(dealerShiptoSiteMap  != null && dealerShiptoSiteMap.values().size()>0){
    //        if(dealerWAREShipToSiteValues == null) dealerWAREShipToSiteValues = new List<Ship_to_Site__c>();
    //        if(dealerRESIShipToSiteValues == null) dealerRESIShipToSiteValues = new List<Ship_to_Site__c>();
    //        for(Ship_to_Site__c s:dealerShiptoSiteMap.values()){
    //            if(s.Type__c != null && s.Type__c.indexOf('Residential')>=0 && s.RecordType.developerName =='Installation_Site')
    //                dealerRESIShipToSiteValues.add(s);
    //            else if(s.RecordType.developerName =='Dealer_Warehouse')
    //                dealerWAREShipToSiteValues.add(s);
    //        }
    //    }
    //}//function ends

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
            // System.debug('In Calc Difference:::userCurrentTimeHour:::::::'+userCurrentTimeHour);
            Date dateToCheck = Date.newInstance(userCurrentTime.yearGMT(),userCurrentTime.monthGMT() ,userCurrentTime.dayGMT());
            Date userCurrentDate = Date.newInstance(userCurrentTime.yearGMT(),userCurrentTime.monthGMT() ,userCurrentTime.dayGMT());
            Integer checkHours = 13;//
            checkHours=(isEUUser)?13 : 14; //

            if(userCurrentTimeHour < checkHours){//
                //dateToCheck = dateToCheck.addDays(2); //3 Commented by Praksh for 3 days PR-03873
                dateToCheck = PriceListItemUtility.getNextWorkingDate(dateToCheck,2);
            }else{
                //dateToCheck = dateToCheck.addDays(3); //4 Commented by Praksh for 4 days PR-03873
                dateToCheck = PriceListItemUtility.getNextWorkingDate(dateToCheck,3);
            }

            if(dateToCheck >= purchaseOrder.Requested_Delivery_Date__c && purchaseOrder.Requested_Delivery_Date__c >= Date.Today() && !SSDwithin3DaysTheaterSet.contains(purchaseOrder.Dealer_Account__r.Theater__c)){
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
    // Get healthy Spring 2017
    //private void synchQuantity(){
    //    PriceListItemUtility.synchQuantity(selProductItems, changedQty, recordSep, dataSep);
    //    //calculateDiscount();
    //}

    // Get healthy Spring 2017
    //private void updateLineNumbersForOrder(){
    //    PriceListItemUtility.updateLineNumbersForOrder(purchaseOrderList);
    //}

    /** This function insert Purchase Order Line Items and Update the Wrapper List accordingly.
    */
    // Get healthy Spring 2017
    //private  void insertListAndUpdateWrapper(){
    //    PriceListItemUtility.insertListAndUpdateWrapper(purchaseOrder, purchaseOrderList, selProductItems);
    //}

    // Get healthy Spring 2017
    //private void calculateOrderPrice(){
    //    PriceListItemUtility.calculateOrderPrice(purchaseOrder, selProductItems, serviceCreditSMSItemId);
    //    calculateDiscount();
    //}

    //NEW ADDED FOR Price List Item Discount
    // Get healthy Spring 2017 public Boolean showDiscountColumns {get;set;}
    // Get healthy Spring 2017 public Boolean showBundleSize {get;set;}
    // Get healthy Spring 2017 public Boolean showErrors {get;set;}
    // Get healthy Spring 2017
    //private void calculateDiscount(){
    //    if(selProductItems == null)
    //        return;
    //    showDiscountColumns = false;
    //    try{
    //        showDiscountColumns = PriceListItemUtility.calculateDiscounts(selProductItems,dealerAccount);
    //    }
    //    catch(Exception e){
    //        System.debug(e);
    //    }

    //    showBundleSize = false;
    //    checkDiscounts();

    //}

    // Get healthy Spring 2017
    //private void checkDiscounts(){
    //    if(selProductItems == null)
    //        return;
    //    for(PurchaseOrderWizardController.PurchaseOrderLineItemWrapper wrapper: selProductItems){
    //        if(wrapper.bundleSize != null)
    //            showBundleSize = true;
    //        if(wrapper.error != null)
    //            showErrors = true;
    //        if((wrapper.discountAmount != null && wrapper.discountAmount != 0) || (wrapper.shippingCharges != null && wrapper.shippingCharges > 0))
    //            showDiscountColumns = true;
    //    }
    //}

    private List<Purchase_Order_Line__c> getSortedList(List<Purchase_Order_Line__c> purLines){
        return PriceListItemUtility.getSortedList(purLines);
    }

    // Get healthy Spring 2017
    //public List<SelectOption> getShippingMethods(){
    //    return PriceListItemUtility.getShippingMethods(selectedPriceList);
    //}

    // Get healthy Spring 2017
    //public List<SelectOption> getCategories(){
    //    //Start 00106510
    //    // Done for request to allow ‘EU Residential Installer’ profile to Order only Modulo and Inverter.
    //    //return PriceListItemUtility.getCategories(purchaseOrder,ApexPages.currentPage().getParameters());
    //    return PriceListItemUtility.getCategories(purchaseOrder,ApexPages.currentPage().getParameters(), isUserEUResidentialInstaller);
    //    //End 00106510
    //}

    private void fillWrapperRestFields(List<PurchaseOrderLineItemWrapper> selProductItems){
        PriceListItemUtility.fillWrapperRestFields(selProductItems);
    }

    // Get healthy Spring 2017
    //private static Opportunity getCustOpportunity(String id){
    //    Opportunity opp =null;
    //    for(Opportunity o:[select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where id = :id Limit 1])
    //        opp=o;
    //    return opp;
    //}

    /*Paginator starts */

    // Get healthy Spring 2017 public String oppNameFilter {get;set;}
    //Start 96593
    // Get healthy Spring 2017 public String oppId {get;set;}
    //End 96593
    // Get healthy Spring 2017 public POWizardPaginationHelper paginator {get;set;}
    // Get healthy Spring 2017 private String acctID {get;set;}
    // Get healthy Spring 2017
    //public boolean getHasNext(){
    //    if(paginator != null && paginator.setCon != null)
    //        return paginator.setCon.gethasNext();
    //    return false;
    //}
    // Get healthy Spring 2017
    //public boolean getHasPrevious(){
    //    if(paginator != null && paginator.setCon != null)
    //        return paginator.setCon.gethasPrevious();
    //    return false;
    //}

    // Get healthy Spring 2017
    //public void initiLizeOppsList(){
    //    paginator = new POWizardPaginationHelper();
    //    if(dealerAccount != null)
    //        acctID = dealerAccount.ID;
    //    if(purchaseOrder!= null && (purchaseOrder.Order_Status__c == null || purchaseOrder.Order_Status__c == '' || purchaseOrder.Order_Status__c =='New') && (isNAUser || isEUUser)){
    //        Integer cnt = paginator.getOppCount(acctID);
    //        if(cnt > 1000){
    //            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , 'Records are more than 1000, please use filter to search.'));
    //        }
    //    }
    //    if(acctID != null && (isNAUser || isEUUser)){
    //        Map<String,Integer> retArgs = paginator.getOppList(acctID,isNAUser,PAGINATION_COUNTER_OPPLIST,PAGINATION_COUNTERONPAGE_OPPLIST);
    //        InitilizePaginatorValues(retArgs);
    //    }
    //}

    // Get healthy Spring 2017
    //public PageReference moveAccordingToFilterOppsList(){
    //    PAGINATION_COUNTER_OPPLIST =5;
    //    PAGINATION_COUNTERONPAGE_OPPLIST=0;
    //    Map<String,Integer> retArgs = paginator.getOppListSearched(acctID, oppNameFilter,isNAUser,PAGINATION_COUNTER_OPPLIST,PAGINATION_COUNTERONPAGE_OPPLIST);
    //    InitilizePaginatorValues(retArgs);
    //    return null;
    //}

    // Get healthy Spring 2017
    //public void InitilizePaginatorValues(Map<String,Integer> retArgs){
    //    if(retArgs != null){
    //        if(reTArgs.get('PAGINATION_COUNTER_OPPLIST')!=null)
    //            PAGINATION_COUNTER_OPPLIST = reTArgs.get('PAGINATION_COUNTER_OPPLIST');
    //        if(reTArgs.get('PAGINATION_COUNTERONPAGE_OPPLIST')!=null)
    //            PAGINATION_COUNTERONPAGE_OPPLIST = reTArgs.get('PAGINATION_COUNTERONPAGE_OPPLIST');
    //    }
    //}

    // Get healthy Spring 2017
    //public PageReference moveFirstOppsList(){
    //    paginator.moveFirst();
    //    return null;
    //}

    // Get healthy Spring 2017
    //public PageReference moveLastOppsList(){
    //    paginator.moveLast();
    //    return null;
    //}

    // Get healthy Spring 2017
    //public PageReference moveNextOppsList(){
    //    paginator.moveNext();
    //    return null;
    //}

    // Get healthy Spring 2017
    //public PageReference movePreviousOppsList(){
    //    paginator.movePrevious() ;
    //    return null;
    //}

    // Get healthy Spring 2017
    //public List<Opportunity> getOpportunityList(){
    //    if(paginator != null)
    //        return paginator.getOpportunityList();
    //    return null;
    //}

    /*Added for Opportunity List Paginator ends */

    public PageReference comparePOs() {
        PageReference pr = new PageReference(poDeltaURL);
        pr.setRedirect(true);
        return pr;
    }
}//class ends