/*
* EMEA AlaCarte Controller - controller for cash based ordering system. EMEA Specific
* SFDC Release - https://na29.salesforce.com/a5B34000000xp2Y
*/

global without sharing class EMEAAlaCarteController extends PageControllerBase {

    //Component controller sharing
    public ShippingSiteComponentController shippingSiteController {set;
        get{
        //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
                ShippingSiteComponentController sscc;
                sscc = (ShippingSiteComponentController )getComponentControllerMap().get('shippingComponent');
                if(sscc!= null)
                    return sscc;
            }
            //just in case something goes wrong return something...this can be handled better
            return new ShippingSiteComponentController();
        }
    }

    public AlaCarteController alacarteController {set;
        get{
        //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
                AlaCarteController acc;
                acc = (AlaCarteController )getComponentControllerMap().get('alacarteComponent');
                if(acc!= null)
                    return acc;
            }
            //just in case something goes wrong return something...this can be handled better
            return new AlaCarteController();
        }
    }



    //constants
    private final Date todayDate = Date.Today();
    private final String alaCarte = 'Ala Carte';
    private final Integer systemCount = 0;
    private final Boolean rackingOptOut = true;
    private final Boolean monitoringOptOut = true;
    //private final String rackingOptOut = 'Y';
    //private final String monitoringOptOut = 'Y';

    //variables, collections, etc
    public Boolean isCalloutError {get;set;}
    public String errorFromORC {get;set;}
    public Purchase_Order__c purchaseOrder {get;set;}
    private List<Purchase_Order_Line__c> disconnectLines {get;set;}
    public String poID {get;set;}
    public Price_List__c cashPriceList { get; private set; }
    public String oppId {get; set;}
    public Opportunity opp {get; set;}
    public User currentUser {get; set;}
    public static Id partnerAccountId {get;set;}

    public List<Purchase_Order_Line__c> orderLines {get;set;}
    public List<ReturnItem> returnLines {get;set;}
    public Bill_To_Site__c bts {get;set;}
    public Ship_To_Site__c sts {get;set;}
    public Contact shipContact {get;set;} //updated per specification of Pivitol Tracker ID #114709951
    public String TOCDocId {get;set;}

    private Map<Id, Module_Configuration__c> configurators;

    //Callout items
    public Decimal totalPrice {get; set;}
    public String totalPriceFormatted {get; set;}
    public Double totalDiscount {get;set;}
    public String jsonHeader {get;set;}
    public String earliestDate {get;set;}
    public String earliestYear {get;set;}
    public String earliestMonth {get;set;}
    public String earliestDay {get;set;}
    public List<String> exceptionList {get;set;}
    public String leadTime {get;set;}
    public Id PDFAttachmentId {get;set;}
    public String crd{get;set;}

    public String language{get;set;}


    //constructor
    private ApexPages.StandardController sc;
    global EMEAAlaCarteController(ApexPages.StandardController standardController) {
        sc = standardController;

        currentUser = [Select Id, Name, Profile.Name, UserType, Contact.Country_Domain__c, Contact.Account.RSM__c,
                ContactId, Contact.AccountID, Contact.Authorized_to_Order__c, Contact.Account.Primary_PSR__c,
                Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c,
                Contact.Account.AccountNumber, Contact.Account.Name, Contact.Account.Phone, Contact.Account.Special_Programs__c ,
                Contact.Account.Oracle_Account_Number__c, CurrencyISOCode, Contact.Account.ShippingState
            From User Where Id =: UserInfo.getUserId()];
        language = currentUser.Contact.Country_Domain__c.substringAfterLast('-').toLowerCase();
        partnerAccountId = currentUser.Contact.AccountId;

        purchaseOrder = (Purchase_Order__c)sc.getRecord();
        purchaseOrder.Dealer_Account__c = currentUser.Contact.AccountId;
        //purchaseOrder.Ship_To_Contact__c = currentUser.ContactId;

        try {
            cashPriceList = [SELECT Id, Name, Shipping_Codes__c, DSR_PO_Group_Email__c
                             FROM Price_List__c
                             WHERE Oracle_Operating_Unit__c != null
                             AND Oracle_Operating_Unit__c =: currentUser.Contact.Account.Oracle_Operating_Unit__c
                             LIMIT 1];
        } catch(Exception e) {

        }
        poID = ApexPages.currentPage().getParameters().get('POID');
        if(poID != null) {
            purchaseOrder = [SELECT Id, Name, Order_Type__c, Number_Of_Systems__c, Bill_to_Site__c, Ship_To_Site__c, Dealer_Account__c,
                                    Module_Quantity__c, Module_Type__c, Racking_Type__c, Racking_Opt_Out__c, Assigned_DSR__c,
                                    Racking_Quantity__c, Monitoring_Quantity__c, Accept_Terms__c, Order_Status__c, Assigned_RSM__c,
                                    Opportunity__r.Name, System_Size__c, Shipping_Method__c, Special_Instructions__c, Ok_To_Ship__c,
                                    Requested_Delivery_Date__c, Ship_To_Contact__c, Ship_To_Contact__r.Name, Ship_To_contact__r.Phone, Is_Taxible_Order__c,
                                    Monitoring_Opt_Out__c, Dealer_Account__r.Name, Storage__c, Storage_Quantity__c, Truck_Type__c,
                                    Pallet_Jack__c, Liftgate__c
                             FROM Purchase_Order__c
                             WHERE Id =: poID];
            if(String.isNotBlank(purchaseOrder.Opportunity__c)){
                opp = [Select Id, Name, PartnerAccount.Name, Primary_Contact__c, Primary_Phone__c, Account.Phone, AccountId
                       From Opportunity Where id = :purchaseOrder.Opportunity__c];
            }

            if(purchaseOrder.Bill_to_Site__c == null) {
                try {
                    bts = [SELECT Id, Address1__c, City__c, State__c, Country__c, Zip__c FROM Bill_To_Site__c
                           WHERE Dealer_Account__c =: currentUser.Contact.AccountId
                           AND Oracle_Operating_Unit_Code__c =: currentUser.Contact.Account.Oracle_Operating_Unit__c
                           Order By LastModifiedDate DESC LIMIT 1];
                    purchaseOrder.Bill_to_Site__c = bts.Id;
                }  catch(Exception e) {
                    System.debug('BTS ERROR: ' + e.getMessage());
                    bts = new Bill_to_site__c();
                }
            }
            //Reset
            purchaseOrder.Order_Type__c = alaCarte;
        }

        else {
            //Defaults
            purchaseOrder.Order_Type__c = alaCarte;

            if(currentUser.Contact.Account.Primary_PSR__c != null)
                purchaseOrder.Assigned_DSR__c = currentUser.Contact.Account.Primary_PSR__c;
            if(currentUser.Contact.Account.RSM__c != null)
                purchaseOrder.Assigned_RSM__c = currentUser.Contact.Account.RSM__c;
            if(cashPriceList != null) {
                purchaseOrder.DSR_PO_Group_Email__c = cashPriceList.DSR_PO_Group_Email__c;
            }

            try {
                bts = [SELECT Id, Address1__c, City__c, State__c, Country__c, Zip__c FROM Bill_To_Site__c
                       WHERE Dealer_Account__c =: currentUser.Contact.AccountId
                       AND Oracle_Operating_Unit_Code__c =: currentUser.Contact.Account.Oracle_Operating_Unit__c
                       Order By LastModifiedDate DESC LIMIT 1];
                purchaseOrder.Bill_to_Site__c = bts.Id;
            }  catch(Exception e) {
                System.debug('BTS ERROR: ' + e.getMessage());
                bts = new Bill_to_site__c();
            }
        }

        try {
            String folderName='Terms and Conditions';
            String opName = currentUser.Contact.Account.Oracle_Operating_Unit__c;
            if(opName.length() > 4) opName = opName.substring(0, 4);
            for(Document d :[select id,DeveloperName,name from Document where DeveloperName =: opName and Folder.Name =: folderName Limit 1]){
                TOCDocId = d.id;
            }

        } catch(Exception e) {
            TOCDocId = '';
        }

        orderLines = new List<Purchase_Order_Line__c>();
    }

    private void buildDisconnects() {
        //
        if(disconnectLines != null && !disconnectLines.isEmpty())
            disconnectLines.clear();

        Set<String> items = new Set<String>();

        if(orderLines != null && !orderLines.isEmpty()) {
            for(Purchase_Order_Line__c line : orderLines) {
                if(line.Item_ID__c != null)
                    items.add(line.Item_Id__c);
            }
        }

        if(alacarteController != null && alacarteController.selProductItems != null && alacarteController.selProductItems.size() > 0) {
            for(AlaCarteController.PriceItemWrapper w : alacarteController.selProductItems) {
                if(w.itemID != null) {
                    items.add(w.itemID);
                }
            }
        }
        if(items.isEmpty()) return;

        Map<String, String> disconnects = new Map<String, String>();
        for(Item__c i : [SELECT Item_Id__c, Disconnect_Item_Id__c FROM Item__c WHERE Disconnect_Item_Id__c != null AND Item_Id__c IN: items]) {
            disconnects.put(i.Item_Id__c, i.Disconnect_Item_Id__c);
        }

        if(disconnects.isEmpty()) return;

        disconnectLines = new List<Purchase_Order_Line__c>();
        if(orderLines != null) {
            for(Purchase_Order_Line__c l : orderLines) {
                if(disconnects.containsKey(l.Item_ID__c) && disconnects.get(l.Item_ID__c) != null) {
                    disconnectLines.add(new Purchase_Order_Line__c(Item_Id__c=disconnects.get(l.Item_ID__c), Quantity__c=l.Quantity__c));
                }
            }
        }
        if(alacarteController != null && alacarteController.selProductItems != null) {
            for(AlaCarteController.PriceItemWrapper w : alacarteController.selProductItems) {
                if(disconnects.containsKey(w.ItemId) && disconnects.get(w.ItemId) != null) {
                    disconnectLines.add(new Purchase_Order_Line__c(Item_Id__c=disconnects.get(w.ItemId), Quantity__c=Decimal.valueOf(w.Qty), Item_Type__c='Ala Carte'));
                }
            }
        }

    }



    /* PageReference methods
     * ToOpportunitySelect()
     * ToShipping()
     * ToShippingWithoutOpp()
     * ToSystemsConfig()
     * ToOrderType()
     */
    public PageReference ToOpportunitySelect(){
        return Page.EMEAOrderOpportunitySelection;
    }

    public PageReference ToShipping(){
        if(String.isNotBlank(purchaseOrder.Opportunity__c)){
            opp = [Select Id, Name, PartnerAccount.Name, Primary_Contact__c, Account.Phone, AccountId, Primary_Phone__c From Opportunity Where id = :purchaseOrder.Opportunity__c];
            purchaseOrder.Ship_To_Contact__c = opp.Primary_Contact__c;
            purchaseOrder.On_Site_Contact_Phone__c = opp.Primary_Phone__c;
        }
        else{
            purchaseOrder.Opportunity__c = null;
            opp = null;
        }
        return Page.EMEAOrderShipping;
    }

    public PageReference ToSystemsConfig() {
        return Page.EMEAAlaCartePage;
    }

    public PageReference ToOrderType(){
        return Page.order_details;
    }

    public PageReference callComponent1ControllerMethod() {
        return shippingSiteController.compControllerTest2();
    }

    public PageReference setAlaCarteOrderItems(){
        alacarteController.setJSON();
        return null;
    }

    /* RemoteActions and other queries
     * getOpportunities() - opportunity selection list
     * getShippingContacts() - ship to contacts for partner account
     * getDealerWarehouses() - shipping sites for the partner account - only 1 opportunity, all dealer warehouses, and installation sites
     *
     *
     *
     */
    @RemoteAction
    global static ResultMessage getOpportunities() {
        System.debug('Fetching Opportunities');
        Id oppRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.sObjectType).get('Home_Owner');
        Id partnerAcctId = [SELECT Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;
        List<String> oppStageFilter = Label.Cash_Orders_Opportunity_Filter.split(';');
        System.debug('Opportunty Record Type Id: '+opprecTypeId);
        System.debug('Partner Account Id: '+partnerAcctId);
        ResultMessage result = new ResultMessage();
        result.success = true;
        List<Opportunity> oList = new List<Opportunity>();
        try{
            oList = [Select Id, Name, StageName, CloseDate, Amount From Opportunity
                            WHERE Partner_Account_Id__c =: partnerAcctId
                            AND CreatedDate = LAST_N_DAYS:365
                            AND RecordTypeId =: oppRecTypeId
                            AND StageName NOT IN: oppStageFilter
                            ORDER BY LastModifiedDate DESC];
            result.payloadMap.put('queriedRecords', oList);
        }catch (Exception e) {
            result.success = false;
            result.payload.add(e);
        }
        System.debug('Get Opportunities Results: '+result);
        return result;
    }

    @RemoteAction
    global static ResultMessage getShippingContacts() {
        Id accId = [SELECT Contact.AccountId From User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;

        ResultMessage result = new ResultMessage();
        result.success = true;
        List<Contact> conList = new List<Contact>();
        try {
            conList = [SELECT Id, Name, Phone
                       FROM Contact
                       WHERE AccountId =: accId AND Terminated__c = FALSE AND RecordType.Name = 'Partner' AND ((Oracle_Contact_id__c != null AND Oracle_Contact_Status__c = 'Active') OR  Oracle_Contact_id__c = null OR  Oracle_Contact_id__c = '') ORDER BY Name ASC]; //#126078665 changed where clause
             result.payloadMap.put('queriedRecords', conList);
        } catch(Exception e) {
            result.success = false;
            result.payload.add(e);
        }
        return result;
    }

    @RemoteAction
    global static ResultMessage getDealerWarehouses(String accId) {
        Id partnerId;
        String operatingUnit;
        for(User u : [SELECT Contact.AccountId, Contact.Account.Oracle_Operating_Unit__c From User WHERE Id =: UserInfo.getUserId()]) {
            partnerId = u.Contact.AccountId;
            operatingUnit = u.Contact.Account.Oracle_Operating_Unit__c;
        }

        ResultMessage result = new ResultMessage();
        result.success = true;
        List<Ship_To_Site__c> warehouses = new List<Ship_To_Site__c>();
        try {
            warehouses = [SELECT Id, Type__c, Address1__c, Address2__c, Address3__c, Address__c, City__c, Zip__c, State__c, Country__c,
                            RecordType.Name, Dealer_Account__c, Contact_Email__c, Contact_First_Name__c, Contact_Last_Name__c, Contact_Phone__c
                          FROM Ship_To_Site__c
                          WHERE (Dealer_Account__c = :accId AND RecordType.DeveloperName = 'Opportunity')
                                                 OR (Dealer_Account__c =: partnerId AND SiteID__c > '0' AND Status__c = 'Active' AND Oracle_Operating_Unit__c = :operatingUnit
                                                    AND (RecordType.DeveloperName = 'Installation_Site'
                                                        OR (RecordType.DeveloperName = 'Dealer_Warehouse' AND (Residential_Customer_Account__c = '' OR Residential_Customer_Account__c = null))))
                          ORDER BY LastModifiedDate DESC]; //#126076059 changed where clause

            result.payloadMap.put('queriedRecords', warehouses);
        } catch(Exception e) {
            result.success = false;
            result.payload.add(e);
        }
        return result;
    }


    /* DML & Utility Methods
     * initOrderLines() - create blank order line for configuration table
     * saveFromShipping() - upsert purchase order record and transition from shipping to config page
     * saveFromOrderConfig() - upsert purchase order record and transition from config page to final confirmation
     * submitOrder()
     */

    public Boolean validateAlaCarteQuantities() {
        Boolean isError = false;
        if(alacarteController != null && alacarteController.selProductItems != null && alacarteController.selProductItems.size() > 0) {
            for(AlaCarteController.PriceItemWrapper w : alacarteController.selProductItems) {
                if(w.error != null) {
                   isError = true;
                   ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.A_La_Carte_Qty_Validation);
                   ApexPages.addMessage(errorMsg);
                    break;
                }
            }
        }
        else
            return isError;
        return isError;
    }

    public PageReference saveFromShipping() {

        if(purchaseOrder.Name == null) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.POWizardValidationErrorRequiredPONumber);
            ApexPages.addMessage(errorMsg);
        }
        if(!String.isBlank(crd)){
            String[] crdSplit = crd.split('/');
            Date inputDate = Date.newInstance(Integer.valueOf(crdSplit[2]),Integer.valueOf(crdSplit[1]),Integer.valueOf(crdSplit[0]));
            purchaseOrder.Requested_Delivery_Date__c = inputDate;
        }
        if(purchaseOrder.Requested_Delivery_Date__c == null) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.POWizardValidationErrorRequiredDeliveryDate);
            ApexPages.addMessage(errorMsg);
        }
        if(ApexPages.hasMessages()) return null;

        try {

            //R.Alega - Case 00675662 - Restrict duplicate PO Number for current Partner logged in only and not across all PO.
            for(Purchase_Order__c po : [SELECT Name FROM Purchase_Order__c
                                        WHERE Name != null AND Name =: purchaseOrder.Name
                                        AND Id !=: purchaseOrder.Id
                                        AND Dealer_Account__c =: currentUser.Contact.AccountId]) {
                if(po.Name == purchaseOrder.Name) {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.POWizardDuplicatePONumber);
                    ApexPages.addMessage(errorMsg);
                    break;
                }
            }
            if(ApexPages.hasMessages()) return null;

            if(purchaseOrder.Order_Status__c == null)
                purchaseOrder.Order_Status__c = 'New';
            if(bts != null && purchaseOrder.Bill_to_Site__c == null)
                purchaseOrder.Bill_to_Site__c = bts.Id;

            //set the sts to the sts attached to the record, used when creating new site record
            //clone if opportunity site, attach to partner, record type installation site - fix for failing opp sites in oracle
            try {
                Id installationSiteId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_to_Site__c.sobjectType).get('Installation_Site');
                Id opportunitySiteId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_to_Site__c.sObjectType).get('Opportunity');
                if(purchaseOrder.Ship_to_Site__c != null) {
                    sts = [SELECT Id, RecordTypeId, Address__c, Address1__c, Address2__c, Address3__c, City__c,
                                  State__c, Country__c, Zip__c, Oracle_County__c, Dealer_Account__c, IsDuplicate__c, IsDuplicateId__c
                           FROM Ship_To_Site__c
                           WHERE Id =: purchaseOrder.Ship_To_Site__c];

                    if(sts.RecordTypeId == opportunitySiteId) {
                        Ship_to_Site__c newInstallSite = sts.clone(false, true, false, false);
                        newInstallSite.Dealer_Account__c = currentUser.Contact.AccountId;
                        newInstallSite.RecordTypeId = installationSiteId;
                        Database.SaveResult res = Database.insert(newInstallSite);
                        Id newStsId = res.getId();
                        purchaseOrder.Ship_to_Site__c = newStsId;
                        sts = [SELECT Id, Address__c, Address1__c, City__c, State__c, Country__c, Zip__c, IsDuplicate__c, IsDuplicateId__c FROM Ship_To_Site__c WHERE Id =: purchaseOrder.Ship_to_Site__c];
                        // #127348167
                        OrderAppUtility.saveShippingSiteToOracle(String.valueOf(newStsId));
                    }
                    // make sure sts isn't a duplicate
                    if(sts.IsDuplicate__c) {
                        fixDuplicateSTS();
                    }
                }

            } catch(Exception e) { }

            //upsert record - insert on first pass, but update/upsert if page is revisited
            upsert purchaseOrder;
            saveShippingOptions(sts.Id, purchaseOrder.Alternate_Contact__c, purchaseOrder.Alternate_Contact_Phone__c, purchaseOrder.Liftgate__c, purchaseOrder.Pallet_Jack__c, purchaseOrder.Truck_Type__c);
            if(String.isNotBlank(purchaseOrder.Ship_To_Contact__c)) {
                try {
                    // #114709951
                    // shipContactName = [SELECT Name FROM Contact WHERE Id =: purchaseOrder.Ship_To_Contact__c].Name;
                   shipContact = [SELECT Name, Phone FROM Contact WHERE Id =: purchaseOrder.Ship_To_Contact__c];
                   System.debug('CONTACT : ' + shipContact);
                } catch(Exception e2) {
                    System.debug('CONTACT NAME ERROR: ' + e2.getMessage());
                }
            }
            if(purchaseOrder.Order_Type__c == alaCarte) {
                return Page.EMEAOrderFinalConfirmation;
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
            //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            //ApexPages.addMessage(errorMsg);
        }
        return null;
    }

    public PageReference saveFromOrderConfig() {

        if(returnLines == null || returnLines.isEmpty()) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Priced_Item_Validation);
            ApexPages.addMessage(errorMsg);
        }
        if(ApexPages.hasMessages()) return null;

        try {
            if(String.isNotBlank(purchaseOrder.Ship_to_Site__c)) {
                try {
                    sts = [Select Id, Address__c, Address1__c, City__c, State__c, Country__c, Zip__c, IsDuplicate__c, IsDuplicateId__c FROM Ship_To_Site__c WHERE Id =: purchaseOrder.Ship_to_Site__c];
                    bts = [SELECT Id, Address1__c, City__c, State__c, Country__c, Zip__c FROM Bill_To_Site__c WHERE Id =: purchaseOrder.Bill_to_Site__c];
                    // make sure sts isn't a duplicate
                    if(sts.IsDuplicate__c) {
                        fixDuplicateSTS();
                    }
                } catch(Exception e) {
                    System.debug('STS ERROR: ' + e.getMessage());
                }
            }
            if(String.isNotBlank(purchaseOrder.Ship_To_Contact__c)) {
                try {
                    // #114709951
                    // shipContactName = [SELECT Name FROM Contact WHERE Id =: purchaseOrder.Ship_To_Contact__c].Name;
                   shipContact = [SELECT Name, Phone FROM Contact WHERE Id =: purchaseOrder.Ship_To_Contact__c];
                } catch(Exception e2) {
                    System.debug('CONTACT NAME ERROR: ' + e2.getMessage());
                }
            }
            return Page.EMEAOrderOpportunitySelection;
        } catch(Exception e) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMsg);
        }
        return null;
    }


    //Submit the order - final page
    public PageReference submitOrder() {
        if(purchaseOrder.Bill_to_Site__c != null && purchaseOrder.Ship_to_Site__c != null &&  purchaseOrder.Dealer_Account__c != null && purchaseOrder.Accept_Terms__c) {

            if(purchaseOrder.Order_Status__c != null && purchaseOrder.Order_Status__c == 'New')
                purchaseOrder.PO_Submit_Date__c = Datetime.valueOfGMT(string.valueof(Datetime.now()));

            //Updating Interface Status to New and Order Status to submitted to kick off SOA integration when the order is Submitted.
           // purchaseOrder.OK_To_Ship__c = okToShipSelection;      //#121852503 - Remove Ok to Ship
            purchaseOrder.Order_Status__c = 'Submitted';
            purchaseOrder.Interface_Status__c = 'New';
            purchaseOrder.Order_Wizard_Step__c='Step 4';

            try {
                List<Purchase_Order_Line__c> linesToMake = new List<Purchase_Order_Line__c>();
                Integer i=1;

                Set<String> orcItems = new Set<String>();
                if(returnLines != null && returnLines.size() > 0) {
                    for(ReturnItem itm : returnLines) {
                        orcItems.add(itm.ordered_item);
                    }

                    Map<String, Id> orcIdMap = new Map<String, Id>();
                    for(Item__c item : [SELECT Id, Item_Id__c FROM Item__c WHERE Item_Id__c IN: orcItems]) {
                        orcIdMap.put(item.Item_Id__c, item.Id);
                    }

                    for(ReturnItem itemWrap : returnLines){
                        Purchase_Order_Line__c l = new Purchase_Order_Line__c();
                        l.Purchase_Order__c = purchaseOrder.Id;
                        l.Order_Line_Number__c = String.valueof(i++);
                        l.Item_Description__c = itemWrap.item_description;
                        l.Item_ID__c = itemWrap.ordered_item;
                        l.Oracle_Item_ID__c = orcIdMap.get(itemWrap.ordered_item);//sangita added for OrderIntegration service
                        l.Quantity__c = Integer.valueOf(itemWrap.ordered_quantity);
                        l.smartpack_item__c= itemwrap.product_line_type=='Bundle'?true:false;//sangita added


                        linesToMake.add(l);
                    }
                }
                insert linesToMake;
            } catch(Exception le) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, le.getMessage());
                ApexPages.addMessage(errorMsg);
            }

            try {
            //upsert record - insert on first pass, but update/upsert if page is revisited
                if(shipContact != null){
                    purchaseOrder.Special_Instructions__c = OrderAppUtility.createSpecialInstructionString(shipContact.Name, shipContact.Phone, currentUser.Contact.Account.Name, currentUser.Contact.Account.Phone, purchaseOrder.Truck_Type__c, purchaseOrder.Liftgate__c, 'No', purchaseOrder.Pallet_Jack__c, purchaseOrder.Special_Instructions__c);
                }
                else{
                    purchaseOrder.Special_Instructions__c = OrderAppUtility.createSpecialInstructionString('', '', currentUser.Contact.Account.Name, currentUser.Contact.Account.Phone, purchaseOrder.Truck_Type__c, purchaseOrder.Liftgate__c, 'No', purchaseOrder.Pallet_Jack__c, purchaseOrder.Special_Instructions__c);
                }
                purchaseOrder.OK_To_Ship__c = 'HOLD';

                sts = [SELECT Id, State__c, IsDuplicate__c, IsDuplicateId__c FROM Ship_To_Site__c WHERE Id =: purchaseOrder.Ship_to_Site__c];
                // make sure sts isn't a duplicate
                if(sts.IsDuplicate__c) {
                    fixDuplicateSTS();
                }

                upsert purchaseOrder;
                PageReference pg = new PageReference('/apex/EMEAOrderSubmissionDetails?POID='+purchaseOrder.Id);
                return pg.setRedirect(true);
            } catch(exception e) {
                System.debug('po submit error: ' + e.getMessage());
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
                ApexPages.addMessage(errorMsg);
            }
            return null;
        } else {
            if(purchaseOrder.Dealer_Account__c == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredDealerAcc);
                ApexPages.addMessage(errorMsg);
            }
            if(purchaseOrder.Name == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredPONumber);
                ApexPages.addMessage(errorMsg);
            }
            //if(purchaseOrder.Shipping_Method__c ==null || purchaseOrder.Shipping_Method__c =='' || purchaseOrder.Shipping_Method__c == '--None--'){
            //    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationRequiredShippingMethod);
            //    ApexPages.addMessage(errorMsg);
            //}
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
            purchaseOrder.Order_Wizard_Step__c='Step 4';
            return null;
        }
    }

    /* Callout methods
     * generateLogging(String service, String outboundReq, String inboundRes) - Spectrum logging of callouts
     * doCallout() - the callout
     * buildRepsonseList(String resultString) - parse response
     * getPayloadJSON() - build the callout string
     * ReturnItem - custom response wrapper class
     */


    private void generateLogging(String service, String outboundReq, String inboundRes) {
        try {
            Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
            log.JSON_Payload__c = outboundReq.length() > 131072 ? outboundReq.left(131071) : outboundReq;
            log.Response__c = inboundRes.length() > 131072 ? inboundRes.left(131071) : inboundRes;
            log.Service__c = service;
            log.Purchase_Order__c = purchaseOrder.Id;

            insert log;
        } catch (Exception e) {}
    }

    public PageReference doCallout(){
        //Do systems validation before calling out
        Boolean isError = false;

        //validate ala carte quantities for all order types
        if(validateAlaCarteQuantities() == true) return null;

        //build disconnect items for items in list being priced
        buildDisconnects();

        //TODO: error handling
        System.debug('calling out!');
        String url = 'callout:EMEAPricingAPI';
        String reqBody = getPayloadJSON();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setTimeout(110000);
        req.setBody(reqBody);
        try {
            HttpResponse res = h.send(req);
            //System.debug('Pricing API Response Status: '+ res);
            //System.debug('Pricing API Response Body: '+ res.getBody());
            try {
                generateLogging('Pricing API', (String.valueOf(req) + req.getBody()), (String.valueOf(res) + res.getBody()));
            } catch (Exception e) {}
            System.debug('Callout Status Code: '+res.getStatusCode());
            if(res.getStatusCode() != 200) {
                String temp = res.getBody().length() > 32000 ? res.getBody().substring(0, 32000) : res.getBody();
                generateExceptionLog(res.getStatusCode() + res.getStatus(), temp);
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_API_Connection_Error);//TODO replace
                ApexPages.addMessage(errorMsg);
            }
            else {
                buildRepsonseList(res.getBody());
            }

        }
        catch(CalloutException ce) {
            generateExceptionLog(ce.getMessage(), ce.getStackTraceString());
            if(isCalloutError != null && isCalloutError == true) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorFromORC);//TODO: replace
                ApexPages.addMessage(errorMsg);
            } else {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_API_Connection_Error);
                ApexPages.addMessage(errorMsg);
            }
        }

        catch(Exception e) {
            generateExceptionLog(e.getMessage(), e.getStackTraceString());
            if(isCalloutError != null && isCalloutError == true) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorFromORC);
                ApexPages.addMessage(errorMsg);
            } else {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_General_Exception);
                ApexPages.addMessage(errorMsg);
            }
        }
        return null;
    }

    public void doDocGenCallout(){
        //Do systems validation before calling out
        Boolean isError = false;

        //TODO: error handling
        System.debug('DocGen!');
        String url = 'callout:DocGen';
        String reqBody = getDocGenPayloadJSON();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setTimeout(110000);
        req.setBody(reqBody);
        try {
            HttpResponse res = h.send(req);

            try {
                generateLogging('DocGen API', (String.valueOf(req) + req.getBody()), (String.valueOf(res) + res.getBody()));
            } catch (Exception e) {}
            System.debug('Callout Status Code: '+res.getStatusCode());
            if(res.getStatusCode() != 200) {
                String temp = res.getBody().length() > 32000 ? res.getBody().substring(0, 32000) : res.getBody();
                generateExceptionLog(res.getStatusCode() + res.getStatus(), temp);
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_API_Connection_Error);//TODO replace
                ApexPages.addMessage(errorMsg);
            }
            else {
                System.debug('Received DocGen Response');
                String responseString = res.getBody();
                //System.debug('Response: '+responseString);
                Blob responseBlob = res.getBodyAsBlob();
                Attachment DataFile = new Attachment();
                DataFile.Name = purchaseOrder.Name+'.pdf';
                DataFile.ParentId = purchaseOrder.Id;
                DataFile.body = responseBlob;
                System.debug('Preparing to Insert Attachment: '+DataFile.Name);
                insert DataFile;
                System.debug('Inserted Attachment: '+DataFile.Name);
                System.debug('Inserted Attachment: '+DataFile.Id);
                PDFAttachmentId = DataFile.Id;
            }

        }
        catch(CalloutException ce) {
            generateExceptionLog(ce.getMessage(), ce.getStackTraceString());
            if(isCalloutError != null && isCalloutError == true) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorFromORC);//TODO: replace
                ApexPages.addMessage(errorMsg);
            } else {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_API_Connection_Error);
                ApexPages.addMessage(errorMsg);
            }
        }

        catch(Exception e) {
            generateExceptionLog(e.getMessage(), e.getStackTraceString());
            if(isCalloutError != null && isCalloutError == true) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorFromORC);
                ApexPages.addMessage(errorMsg);
            } else {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_General_Exception);
                ApexPages.addMessage(errorMsg);
            }
        }
        return;
    }

    public void generateExceptionLog(String message, String stackTrace) {
        try {
            Exception_Log__c exLog = new Exception_Log__c();
            exLog.Purchase_Order__c = purchaseOrder.Id;
            exLog.Stack_Trace__c = stackTrace;
            exLog.Error_Message__c = message;
            insert exLog;

        } catch (Exception e) { System.debug('Exception logging failure!'); }
    }

    public void buildRepsonseList(String resultString){
        //TODO: error handling
        isCalloutError = false;
        errorFromORC = '';
        returnLines = new List<ReturnItem>();
        JSONParser statusParser = JSON.createParser(resultString);
        while(statusParser.nextToken() != null){
            if(statusParser.getCurrentName() == 'sales_order') {
                while(statusParser.nextToken() != null) {
                    if(statusParser.getCurrentName() == 'status') {
                        System.debug(statusParser.getText());
                        //if(statusParser.getText() == 'E') {
                        if(statusParser.getText() == 'E' || statusParser.getText() == '' || statusParser.getText() == null) {
                            isCalloutError = true;
                        }
                    }
                    if(statusParser.getCurrentName() == 'status_message') {
                        JSONToken nextToken = statusParser.nextToken();
                        System.debug('next: ' + nextToken);
                        errorFromORC = statusParser.getText();
                        if(errorFromORC == null || String.isBlank(errorFromORC))
                            errorFromOrc = Label.Cash_Orders_API_Connection_Error;
                        System.debug('ORC ERROR: ' + errorFromORC);
                        if(isCalloutError == true) Integer x = 1/0;
                    }
                }
            }
        }

        JSONParser parser = JSON.createParser(resultString);
        while(parser.nextToken() != null){
            if(parser.getCurrentName() == 'order_line' && parser.getCurrentToken() == JSONToken.FIELD_NAME){

                JSONToken nextToken = parser.nextToken();
                System.debug(nextToken);
                if(nextToken == JSONToken.START_ARRAY){
                    System.debug('MORE THAN ONE ITEM');
                    returnLines = (List<ReturnItem>) parser.readValueAs(List<ReturnItem>.class);
                    System.debug(returnLines);
                }else if(nextToken == JSONToken.START_OBJECT){
                    System.debug('ONLY ONE ITEM');
                    ReturnItem item = (ReturnItem) parser.readValueAs(ReturnItem.class);
                    returnLines.add(item);
                    System.debug(item);
                }
            }else if(parser.getCurrentName() == 'order_total' && parser.getCurrentToken() == JSONToken.FIELD_NAME){
                parser.nextToken();
                totalPriceFormatted = getFormatted(parser.getText());
            }
        }
        //Set proper decimal value for prices
        for(ReturnItem i: returnLines){
            i.unit_priceFORMATTED = getFormatted(i.adjusted_unit_price);
            i.extended_priceFORMATTED = getFormatted(i.extended_price);
            i.internal_unit_priceFORMATTED = getFormatted(i.internal_unit_price);
            i.extended_list_priceFORMATTED = getFormatted(i.extended_list_price);
        }
    }

    //this will cause some issues with input strings with more than 2 decimal places.  Dealing with currency so hopefully not an issue
    public String getFormatted(STring str){
        Decimal d = (str == '' ? 0.00 : Decimal.valueOf(str));
        String s;
        if(d < 0){
            s = (d - 0.001).format();
        }else{
            s = (d + 0.001).format();
        }
        return s.substring(0, s.length()-1);
    }

    public class ReturnItem {
        public String lineNumber {get; set;}
        public String item_description {get; set;}
        public String ordered_item {get; set;}
        public String ordered_quantity {get; set;}
        public String adjusted_unit_price {get; set;}
        public String unit_price {get;set;}
        public String unit_priceFORMATTED {get; set;}
        public String extended_price {get; set;}
        public String extended_priceFORMATTED {get; set;}
        public Decimal unit_priceDEC {get; set;}
        public Decimal extended_priceDEC {get; set;}
        public String product_line_type {get;set;}
        public String discount_percent {get;set;}
        public String internal_unit_price {get;set;}
        public String internal_unit_priceFORMATTED {get;set;}
        public String extended_list_price {get;set;}
        public String extended_list_priceFORMATTED {get;set;}

        public Decimal getdiscount_total(){
            return (Decimal.valueOf(this.unit_price) - Decimal.valueOf(adjusted_unit_price)) * Decimal.valueOf(ordered_quantity);
        }
    }

    public String getDocGenPayloadJSON(){

        System.debug('building DocGen Payload');

        String transactionUUID = purchaseOrder.Id == null ? OrderAppUtility.generateGUID() : purchaseOrder.Id;

        String orderLinesString = '';

        //disconnect items
        if(disconnectLines != null && !disconnectLines.isEmpty()) {
            String lineType = 'Bundle';

            for(Purchase_Order_Line__c dcLine : disconnectLines) {
                if(dcLine.Item_Type__c == 'Ala Carte')
                    lineType = 'A La Carte';
                orderLinesString += '{"ordered_item":"'+dcLine.Item_ID__c+'","ordered_quantity":"'+dcLine.Quantity__c+'","product_line_type":"' + lineType+ '"},';
            }
        }

        //ala carte items
        if(alacarteController != null && alacarteController.selProductItems != null && alacarteController.selProductItems.size() > 0) {
            for(AlaCarteController.PriceItemWrapper itemWrap: alacarteController.selProductItems){
                orderLinesString += '{"ordered_item":"'+itemWrap.itemID+'","ordered_quantity":"'+itemWrap.Qty+'","product_line_type":"A La Carte"},';
            }
        }

        String finalString = orderLinesString.removeEnd(',');

        String payload =  '{"apiKey" : "DC97-20AF-567E",';
        payload +=        '"documentType" : null,';
        payload +=        '"sector" : null,';
        payload +=        '"templateName" : "",';
        payload +=        '"watermark" : "off",';
        payload +=        '"nameValuePairs" : [';
        payload +=        '{"name" : "Country_Domain", "value" : "'+currentUser.Contact.Country_Domain__c.substringAfterLast('-').toUpperCase()+'"},';
        payload +=        '{"name" : "Partner_Account", "value" : "'+currentUser.Contact.Account.Name+'"},';
        payload +=        '{"name" : "Partner_PO_Number", "value" : "'+purchaseOrder.Name+'"},';

        if(opp==null)
                payload +=        '{"name" : "Opportunity", "value" : ""},';
        else
            payload +=        '{"name" : "Opportunity", "value" : "'+opp.Name+'"},';

        payload +=        '{"name" : "System_Size_kw", "value" : "0"},';
        payload +=        '{"name" : "Order_Total", "value" : "'+totalPriceFormatted+'"},';
        payload +=        '{"name" : "Order_Currency", "value" : "'+currentUser.CurrencyISOCode+'"},';
        if(shipContact != null){
            payload +=        '{"name" : "Shipping_Contact_Full_Name", "value" : "'+shipContact.Name+'"},';
        }
        else
            payload +=        '{"name" : "Shipping_Contact_Full_Name", "value" : ""},';
        payload +=        '{"name" : "Shipping_Street", "value" : "'+sts.Address1__c.replace('\r\n', ' ')+'"},';
        payload +=        '{"name" : "Shipping_City", "value" : "'+sts.City__c+'"},';
        payload +=        '{"name" : "Shipping_County", "value" : ""},';
        payload +=        '{"name" : "Shipping_State_Prov", "value" : "'+sts.State__c+'"},';
        payload +=        '{"name" : "Shipping_Country", "value" : "'+sts.Country__c+'"},';
        payload +=        '{"name" : "Shipping_Postal_Code", "value" : "'+sts.Zip__c+'"},';
        //payload +=        '{"name" : "CRD", "value" : "'+purchaseOrder.Requested_Delivery_Date__c+'"},';
        Date dateTemp = Date.newInstance(purchaseOrder.Requested_Delivery_Date__c.year(),purchaseOrder.Requested_Delivery_Date__c.month(),purchaseOrder.Requested_Delivery_Date__c.day());
        String crdFinal = dateTemp.format();
        payload +=        '{"name" : "CRD", "value" : "'+crdFinal+'"},';
        payload +=        '{"name" : "Special_Instructions", "value" : "'+purchaseOrder.Special_Instructions__c+'"},';
        if(!String.isBlank(bts.Address1__c))
            payload +=        '{"name" : "Billing_Street", "value" : "'+bts.Address1__c.replace('\r\n', ' ')+'"},';
        else
            payload +=        '{"name" : "Billing_Street", "value" : ""},';
        if(!String.isBlank(bts.City__c))
            payload +=        '{"name" : "Billing_City", "value" : "'+bts.City__c+'"},';
        else
            payload +=        '{"name" : "Billing_City", "value" : ""},';
        payload +=        '{"name" : "Billing_County", "value" : ""},';
        if(!String.isBlank(bts.State__c))
            payload +=        '{"name" : "Billing_State_Prov", "value" : "'+bts.State__c+'"},';
        else
            payload +=        '{"name" : "Billing_State_Prov", "value" : ""},';
        if(!String.isBlank(bts.Country__c))
            payload +=        '{"name" : "Billing_Country", "value" : "'+bts.Country__c+'"},';
        else
            payload +=        '{"name" : "Billing_Country", "value" : "'+bts.Country__c+'"},';
        if(!String.isBlank(bts.Zip__c))
            payload +=        '{"name" : "Billing_Postal_Code", "value" : "'+bts.Zip__c+'"}';
        else
            payload +=        '{"name" : "Billing_Postal_Code", "value" : ""}';
        if(returnLines != null && !returnLines.isEmpty()) {
            Integer lineNumber = 1;
            for(Integer i = 0; i < 15; i++){
                if(i < returnLines.size()){
                    payload +=        ',{"name" : "Line'+lineNumber+'_Descr", "value" : "'+returnLines[i].item_description+'"},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Item_ID", "value" : "'+returnLines[i].ordered_item+'"},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Qty", "value" : "'+returnLines[i].ordered_quantity+'"},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Unit_Price", "value" : "'+returnLines[i].unit_priceFORMATTED+'"},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Ext_Price", "value" : "'+returnLines[i].extended_priceFORMATTED+'"},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Line_Type", "value" : "A La Carte"}';
                }
                else{
                    payload +=        ',{"name" : "Line'+lineNumber+'_Descr", "value" : ""},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Item_ID", "value" : ""},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Qty", "value" : ""},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Unit_Price", "value" : ""},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Ext_Price", "value" : ""},';
                    payload +=        '{"name" : "Line'+lineNumber+'_Line_Type", "value" : ""}';
                }
                lineNumber++;
            }
        }
        payload +=        ',{"name" : "Doc_Generated_Timestamp", "value" : "'+DateTime.Now()+'"}';
        payload +=        '],';
        payload +=        '"dynamicImages" : [],';
        payload +=        '"staticImages" : []}';

        System.debug('DocGen Payload: '+ payload);
        return payload;
    }

    public String getPayloadJSON(){


        String transactionUUID = purchaseOrder.Id == null ? OrderAppUtility.generateGUID() : purchaseOrder.Id;

        String orderLinesString = '';

        //disconnect items
        if(disconnectLines != null && !disconnectLines.isEmpty()) {
            String lineType = 'Bundle';

            for(Purchase_Order_Line__c dcLine : disconnectLines) {
                if(dcLine.Item_Type__c == 'Ala Carte')
                    lineType = 'A La Carte';
                orderLinesString += '{"ordered_item":"'+dcLine.Item_ID__c+'","ordered_quantity":"'+dcLine.Quantity__c+'","product_line_type":"' + lineType+ '"},';
            }
        }

        //ala carte items
        if(alacarteController != null && alacarteController.selProductItems != null && alacarteController.selProductItems.size() > 0) {
            for(AlaCarteController.PriceItemWrapper itemWrap: alacarteController.selProductItems){
                orderLinesString += '{"ordered_item":"'+itemWrap.itemID+'","ordered_quantity":"'+itemWrap.Qty+'","product_line_type":"A La Carte"},';
            }
        }

        String finalString = orderLinesString.removeEnd(',');

        String payload = '{"pricing_order_request":{';
        payload +=          '"message_header":{"source_system_id":"SFDC","transaction_id":"' + transactionUUID + '"},';//transaction id replace with po name
        payload +=          '"sales_order":{';
        payload +=              '"order_header":{';
        payload +=                  '"cust_account_number":"' + currentUser.Contact.Account.Oracle_Account_Number__c + '",';//replace with orc acct # from user/contact/account
        if (currentUser.Contact.Country_Domain__c.substringAfterLast('-').toUpperCase() == 'UK')
            payload +=                  '"country":"GB",';
        else
            payload +=                  '"country":"' + currentUser.Contact.Country_Domain__c.substringAfterLast('-').toUpperCase() + '",';//substring user/contact/account country domain
        payload +=                  '"sales_type":"PURCHASE",';
        payload +=                  '"channel_type":"RVAR",';
        payload +=                  '"system_count":"'+systemCount+'",';
        payload +=                  '"racking_opt_out":"'+rackingOptOut+'",';//needs to be dynamic
        payload +=                  '"monitoring_opt_out":"'+monitoringOptOut+'"';//needs to be dynamic
        payload +=              '},';
        payload +=              '"order_lines":{"order_line":['+finalString+']}}}}';
        System.debug('Pricing Payload: '+ payload);
        return payload;
    }

    //Method added per specification of Pivitol Tracker ID# ##114754041
    public PageReference savePDF() {

        PageReference pdf = Page.SystemsOrderPDF;
        Blob body;

        try {
            //body = pdf.getContent();
            body = pdf.getContentAsPDF();
        } catch(Exception e) {
            body = Blob.valueOf('PDF Generation Error');
        }

        return pdf;
    }

    public void doCRDCallout(){
        //Do systems validation before calling out
        //Boolean isError = false;

        //TODO: error handling
        System.debug('CRD API: calling out!');
        String url = getCRDURL();

        //String reqBody = getPayloadJSON();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        //req.setHeader('content-type', 'application/json');
        req.setTimeout(110000);
        //req.setBody(reqBody);
        try {
            HttpResponse res = h.send(req);
            System.debug('CRD API Response Status: '+ res);
            System.debug('CRD API Response Body: '+ res.getBody());
            System.debug('CRD API: Callout Status Code: '+res.getStatusCode());
            if(res.getStatusCode() != 200) {
                System.debug('CRD API: Status Code Error: '+res.getStatusCode());
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_API_Connection_Error);//TODO replace
                ApexPages.addMessage(errorMsg);
            }
            else {
                setCRDDates(res.getBody());
                return;
            }

        }
        catch(CalloutException ce) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_API_Connection_Error);
            ApexPages.addMessage(errorMsg);
        }

        catch(Exception e) {
            System.debug('CRD API: General exception');
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_General_Exception);
            ApexPages.addMessage(errorMsg);
        }
        System.debug('Return null');
        return;
    }

    public String getCRDURL(){
        //System.debug('Ship to Site: '+purchaseOrder.Ship_to_Site__c);
        System.debug(purchaseOrder.ship_to_site__c);
        sts = [SELECT Id, RecordTypeId, Address__c, Address1__c, Address2__c, Address3__c, City__c,
                      State__c, Country__c, Zip__c, Oracle_County__c, Dealer_Account__c
               FROM Ship_To_Site__c
               WHERE Id =: purchaseOrder.ship_to_site__c];
        //System.debug(sts.Country__c);
        //Ship_to_Site sts = purchaseOrder.Ship_to_Site__r;

        String url = 'callout:CRD_API';
        url += '?sales_type=PURCHASE&';
        url += 'channel_type=RVAR&';
        if(currentUser.Contact.Country_Domain__c.substringAfterLast('-').toUpperCase() == 'UK')
            url += 'country=GB&';
        else
            url += 'country='+currentUser.Contact.Country_Domain__c.substringAfterLast('-').toUpperCase()+'&';

        url += 'zipcode='+sts.Zip__c.deleteWhiteSpace();
        System.debug(url);
        return url;
    }

    public void setCRDDates(String body){
        //System.debug('Retrieving dates from Oracle');
        //body = '{"query_order_response": {"exception_dates": ["2016-09-05", "2016-11-24", "2016-11-25", "2016-12-23", "2016-12-26", "2016-12-30", "2017-01-01"], "status": "S", "lead_time": "", "status_message": "", "earliest_crd_date": "2016-08-23"} } ';
        exceptionList = new List<String>();
        JSONParser statusParser = JSON.createParser(body);
        System.debug('Created JSONParser');
        try{
            while(statusParser.nextToken() != null){
                if(statusParser.getCurrentName() == 'query_order_response') {
                    while(statusParser.nextToken() != null) {
                        System.debug('Current Token: '+statusParser.getCurrentName());
                        if(statusParser.getCurrentName() == 'exception_dates') {
                            while(statusParser.nextToken() != null) {
                                System.debug('Get Text: '+statusParser.getText());
                                if(statusParser.getText() == ']' || statusParser.getText() == 'status'){
                                    System.debug('Exitting Exceptions: Get Text: '+statusParser.getText());
                                    break;
                                }
                                else if(statusParser.getText() != '[' && statusParser.getText() != ']' && statusParser.getText() != 'exception_dates'){
                                    System.debug('ExceptionDate: '+statusParser.getText());
                                    exceptionList.add(statusParser.getText());
                                }

                            }
                        }
                        if(statusParser.getCurrentName() == 'lead_time'){
                            statusParser.nextToken();

                            if(statusParser.getText() != ''){
                                System.debug('Lead Time: '+statusParser.getText());
                                leadTime = statusParser.getText();
                            }else{
                                System.debug('Lead Time set to 0');
                                leadTime = '0';
                            }
                        }
                        if(statusParser.getCurrentName() == 'earliest_crd_date'){
                            statusParser.nextToken();
                            System.debug('EarliestDate: '+statusParser.getText());
                            earliestDate = statusParser.getText();
                            String[] earliestDateSplit = earliestDate.split('-');
                            earliestYear = earliestDateSplit[0];
                            earliestMonth = earliestDateSplit[1];
                            earliestDay = earliestDateSplit[2];
                            break;
                        }
                    }
                 }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        System.debug(exceptionList);
        return;
    }

    Set<Id> masterIds {get;set;}
    @TestVisible
    private void initModules() {
        if(sts == null || sts.State__c == null)
            return;

        masterIds = ProductConfigurationUtility.fetchMasterIds(sts.State__c, currentUser.Contact.Account.Oracle_Operating_Unit__c, 'Cash', 'Order', 'Residential', 'Indirect', currentUser.Contact.AccountId);

        System.debug('masterIds: ' + masterIds);

        //Collect modules based on the sales config records
        configurators = ProductConfigurationUtility.fetchModules(masterIds);
    }

    public PageReference fixDuplicateSTS() {
        purchaseOrder.Ship_to_Site__c = sts.IsDuplicateId__c;
        // delete the duplicate site
        delete sts;
        // reset sts var
        sts = [SELECT Id, RecordTypeId, Address1__c, Address2__c, Address3__c, City__c, State__c, Country__c, Zip__c,
                    Oracle_County__c, Dealer_Account__c, IsDuplicate__c, IsDuplicateId__c
               FROM Ship_To_Site__c
               WHERE Id =: purchaseOrder.Ship_To_Site__c];
        return null;
    }
    //#132991039 - Save shipping options on the Site record during order creation - EMEA
    @future
    public static void saveShippingOptions(Id stsId, String altContact, String altContactPhone, String liftgate, String palletJack, String truckType){
        Ship_To_Site__c sts = [SELECT Id, EMEA_Alternate_Contact__c, EMEA_Alternate_Contact_Phone__c, EMEA_Liftgate__c, EMEA_Pallet_Jack__c, EMEA_Truck_Type__c
                               FROM Ship_To_Site__c
                               WHERE Id =: stsId];
                               
        sts.EMEA_Alternate_Contact__c = altContact;
        sts.EMEA_Alternate_Contact_Phone__c = altContactPhone;
        sts.EMEA_Liftgate__c = liftgate;
        sts.EMEA_Pallet_Jack__c = palletJack;
        sts.EMEA_Truck_Type__c = truckType;
        update sts;
        return;
    }
    public void setShippingOptions(){
        Id stsId = Apexpages.currentPage().getParameters().get('stsId');
        Ship_To_Site__c sts = [SELECT Id, EMEA_Alternate_Contact__c, EMEA_Alternate_Contact_Phone__c, EMEA_Liftgate__c, EMEA_Pallet_Jack__c, EMEA_Truck_Type__c
                           FROM Ship_To_Site__c
                           WHERE Id =: stsId];
        purchaseOrder.Alternate_Contact__c = sts.EMEA_Alternate_Contact__c;
        purchaseOrder.Alternate_Contact_Phone__c = sts.EMEA_Alternate_Contact_Phone__c;
        purchaseOrder.Liftgate__c = sts.EMEA_Liftgate__c;
        purchaseOrder.Pallet_Jack__c = sts.EMEA_Pallet_Jack__c;
        purchaseOrder.Truck_Type__c = sts.EMEA_Truck_Type__c;                           
    }
}