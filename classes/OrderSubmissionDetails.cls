/*
* OrderSubmissionDetails - controller for post-submit details from cash based ordering system
* SFDC Release - https://na29.salesforce.com/a5B34000000xp2Y
*
* Pivotal Tracker Updates:
* ID #114709951 - Add Contact Phone to the Order Submission Screen - 3/18/16
* ID #114738873 - Purchase Order Re-submission (SFDC) - 4/16/2016
* ID #121852503 - Remove Ok to Ship  - 6/23/2016
* ID #114921295 - Remove Shipping Method Selection - WW32
* ID #128988357 - Real time Oracle order creation via Informatica eliminating SOA
*
*
*
*/

global with sharing class OrderSubmissionDetails extends PageControllerBase {

    //variables etc...
    public Boolean isPartnerUser {get; set;}
    public Purchase_Order__c purchaseOrder {get; set;}
    public List<Purchase_Order_Line__c> orderLines {get; set;}
    public User currentUser {get; set;}
    public String oppId {get; set;}
    public Opportunity opp {get; set;}
    public Bill_To_Site__c bts {get; set;}
    public Ship_To_Site__c sts {get; set;}
    public String shipContactName {get; set;}
    public String poName {get; set;}
    public String OppName {get; set;}
    public String poID;
    public Integer retries {get; private set;}
    public Integer numLines {get; set;}
    public String specialInstructions {
        get {
            return purchaseOrder.Special_Instructions__c;
        }
        set;
    }

    //constructor
    // #121852503 - remove Ok to Ship
    // #114921295 - removed ship to method validation - 07/10/2016
    public OrderSubmissionDetails(ApexPages.StandardController controller) {
        retries = 0;
        poID = ApexPages.currentPage().getParameters().get('POID');

        if(poID != null){
            for(Purchase_Order__c p:[Select p.OwnerID, p.Ship_To_Contact__c, p.Ship_To_Contact__r.Name, p.Is_Taxible_Order__c,
                                            p.Opportunity__c, p.Opportunity__r.Name, p.Opportunity__r.Id,
                                            p.Special_Instructions__c, p.Name, p.Id, p.Contact_ID__c,
                                            p.Oracle_Order_Number__c, p.Order_Status_Interface_Message__c,p.Ship_To_Contact__r.Phone,
                                            p.Order_Total__c,p.Requested_Delivery_Date__c, p.Bill_to_site__c, p.Ship_to_site__c,
                                            p.Dealer_Account__r.Name, Order_Status__c, p.Accept_Terms__c, p.Interface_Status__c,
                                            p.Bill_To_Contact__r.Oracle_Contact_id__c, p.Ship_To_Contact__r.Oracle_Contact_id__c
                                     From Purchase_Order__c p
                                     where p.Id =:poID]){
                purchaseOrder = p;

                //bill to site
                try {
                    bts = [SELECT Id, Address1__c, City__c, State__c, Site_ID__c, Zip__c FROM Bill_To_Site__c WHERE id =: p.Bill_to_site__c];
                }  catch(Exception e) {
                    System.debug('BTS ERROR: ' + e.getMessage());
                }

                //ship to site
                try {
                    sts = [SELECT Id, Address__c, Address1__c, City__c, Country__c, Dealer_Account__c, Oracle_County__c, SiteID__c, State__c, Status__c, Zip__c FROM Ship_To_Site__c WHERE id =: p.Ship_to_site__c];
                }  catch(Exception e) {
                    System.debug('STS ERROR: ' + e.getMessage());
                }
            }
            try {
                orderLines = [SELECT Item_Description__c, Item_ID__c, Quantity__c FROM Purchase_Order_Line__c where Purchase_Order__c=:poID];
                numLines = orderLines.size();
            } catch(Exception e) {
                System.debug('orderLines error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
            }
        }

        currentUser = [Select Id, Name, Profile.Name, UserType, Contact.Country_Domain__c, Contact.Account.RSM__c,
                              ContactId, Contact.AccountID, Contact.Authorized_to_Order__c, Contact.Account.Primary_PSR__c,
                              Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c,
                              Contact.Account.AccountNumber, Contact.Account.Name,
                              Contact.Account.Oracle_Account_Number__c, CurrencyISOCode
                       From User Where Id =: UserInfo.getUserId()];

        isPartnerUser = SPCommunityUtility.isPartnerUser();
    } //end of constructor

    public PageReference init() {
        try {
            // #128988357
            // make sure this isn't a SOA order or already has an order number or has an error
            if(String.isBlank(purchaseOrder.Interface_Status__c) && String.isBlank(purchaseOrder.Oracle_Order_Number__c) && !purchaseOrder.Order_Status__c.contains('Error')) {
                ResultMessage stsResult;
                // #133369091
                // check to see if ship to contact has oracle id
                if(String.isNotBlank(purchaseOrder.Ship_To_Contact__c)) {
                    try {
                       Contact stcon = [SELECT Id, Phone, FirstName, LastName, Email, MobilePhone, Oracle_Contact_id__c, Account.Oracle_Account_Number__c FROM Contact WHERE Id =: purchaseOrder.Ship_To_Contact__c];

                        if(String.isBlank(stcon.Oracle_Contact_id__c)) {
                            String stc = JSON.serialize(stcon);
                            OracleOrderUtility.createOracleContact(stc, 'SHIP_TO', purchaseOrder.Id);
                        }
                    } catch(Exception e2) {
                        SpectrumDebugUtility.createExceptionLog(e2.getMessage(), e2.getStackTraceString(), 'SO Create Oracle Contact Error', purchaseOrder.Id);
                        System.debug('SO Create Oracle Contact Error ' + e2.getMessage() + ' ' + e2.getStackTraceString());
                    }
                }
                // check ship to site
                String siteId = sts.SiteID__c;
                Boolean isNewSite = false;
                // make sure we have a ship to site id that's active
                if(String.isBlank(siteId) || String.isNotBlank(siteId) && sts.Status__c != 'Active') {
                    isNewSite = true;
                    // get the account info for oracle
                    Account a = [SELECT Line_of_Business__c, Oracle_Account_Number__c FROM Account WHERE Id = :sts.Dealer_Account__c];
                    // check to see if it's a combo partner so site type in Oracle is set correctly
                    String channelType;
                    if(a.Line_of_Business__c.toUpperCase() == 'COMBO') {
                        channelType = 'RVAR';
                    } else {
                        channelType = a.Line_of_Business__c.toUpperCase();
                    }
                    // submit to the service for address creation
                    stsResult = OracleOrderService.saveShippingSiteToOracle(sts, a.Oracle_Account_Number__c, 'PURCHASE', channelType);
                    // check result
                    if(stsResult.success) {
                        // deserialize response
                        OracleOrderUtility.InformaticaShipToSiteResponse informaticaResponse = (OracleOrderUtility.InformaticaShipToSiteResponse)JSON.deserialize(stsResult.message, OracleOrderUtility.InformaticaShipToSiteResponse.class);
                        // get site id
                        String newStsId = informaticaResponse.process_customer_response.ship_to_sites.ship_to_site.cust_acct_site_id;
                        // check response
                        if(informaticaResponse.process_customer_response.status == 'S' && String.isNotBlank(newStsId)) {
                            // set the oracle site id
                            siteId = newStsId;
                            sts.SiteID__c = siteId;
                        }
                    }
                }
                // send the order to oracle
                ResultMessage orderResult = OracleOrderUtility.sendNewCashOrder(poID, siteId);
                // check the ship to site
                if(isNewSite) {
                    // log result
                    if(!stsResult.logs.isEmpty()) {
                        SpectrumDebugUtility.generateDebugLog(stsResult.logs);
                    }
                    // check site to make sure it's not a duplicate
                    OracleOrderUtility.checkNewShipToSite(stsResult.message, sts.Id);
                }
                // check the order result
                checkResult(orderResult);
            }
        } catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Oracle Order Error', purchaseOrder.Id);
            purchaseOrder.Order_Status__c = 'Error';
            purchaseOrder.Order_Status_Interface_Message__c = e.getMessage() + ' - ' + e.getStackTraceString();
            update purchaseOrder;
        }
        return null;
    }

    //#114738873
    public PageReference psrSubmitOrder() {
        if(currentUser.Contact.AccountId == null) {
            if(purchaseOrder.Accept_Terms__c && purchaseOrder.Bill_To_Site__c != null && purchaseOrder.Ship_to_Site__c != null) {
                purchaseOrder.Order_Status__c = 'Submitted';
                // #128988357 - get the interface status from the custom metadata object to turn on/off real time ordering (SOA will see this order if it's set to New)
                if(String.isBlank(purchaseOrder.Interface_Status__c)) {
                    purchaseOrder.Interface_Status__c = [SELECT Interface_Status__c FROM OracleRealTimeCashOrderOnOffSwitch__mdt WHERE DeveloperName = 'Default' LIMIT 1].Interface_Status__c;
                } else purchaseOrder.Interface_Status__c = 'New';

                try {
                    // #128988357
                    if(String.isBlank(purchaseOrder.Interface_Status__c) && String.isBlank(purchaseOrder.Oracle_Order_Number__c)) {
                        ResultMessage result = OracleOrderUtility.SendNewCashOrder(poID, sts.SiteID__c);
                        checkResult(result);
                    } else {
                        update purchaseOrder;
                        PageReference pg = new PageReference('/apex/OrderSubmissionDetails?POID='+purchaseOrder.Id);
                        return pg.setRedirect(true);
                    }
                } catch(Exception e) {
                    System.debug('EXCEPTION: ' + e);
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    ApexPages.addMessage(errorMsg);
                    return null;
                }
            }
        }
        return null;
    }

    public PageReference reSubmitOrder() {
        // check retries
        if(retries < 2) {
            retries++;
            ResultMessage result = OracleOrderUtility.sendNewCashOrder(poID, sts.SiteID__c);
            checkResult(result);
            if(String.isNotBlank(purchaseOrder.Oracle_Order_Number__c)) {
                PageReference pg = new PageReference('/apex/OrderSubmissionDetails?POID='+purchaseOrder.Id);
                return pg.setRedirect(true);
            }
        }
        return null;
    }

    public PageReference checkResult(ResultMessage result){
        //SAMPLE Result.message {"sales_order_response": {"status": "S", "status_message": "Successfully Processed", "sales_order_response_header": {"order_number": "12217702"}}}
        try{
			// insert logs
            if(!result.logs.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(result.logs);
            }
            // check result
            if(result.success) {
                // deserialize the message
                OracleOrderUtility.InformaticaCreateOrderResponse response = (OracleOrderUtility.InformaticaCreateOrderResponse)JSON.deserialize(result.message, OracleOrderUtility.InformaticaCreateOrderResponse.class);
                // set vars
                String status = response.sales_order_response.status;
                String statusMessage = response.sales_order_response.status_message;
                String orderNumber = response.sales_order_response.sales_order_response_header.order_number;
                String oracleId = response.sales_order_response.sales_order_response_header.header_id;
                // check the Oracle status
                if(status == 'S') {
                    // update purchase order
                    purchaseOrder.Oracle_Order_Number__c = orderNumber;
                    purchaseOrder.OracleOrderHeaderId__c = oracleId;
                    purchaseOrder.Order_Status__c = 'Processed';
                    purchaseOrder.Order_Status_Interface_Message__c = statusMessage;
                } else if(status == 'E' && String.isNotBlank(orderNumber)) {
                    // update purchase order
                    purchaseOrder.Oracle_Order_Number__c = orderNumber;
                    purchaseOrder.OracleOrderHeaderId__c = oracleId;
                    purchaseOrder.Order_Status__c = 'Processed';
                    purchaseOrder.Order_Status_Interface_Message__c = statusMessage;
                } else {
                    // Oracle error
                    purchaseOrder.Order_Status__c = 'Error';
                    purchaseOrder.Order_Status_Interface_Message__c = statusMessage;
                }
                // update the purchase order
                update purchaseOrder;

            } else {
                // check for timeout error
                if(result.message.containsIgnoreCase('timeout') || result.message.containsIgnoreCase('timed out')) {
                    purchaseOrder.Order_Status__c = 'Timeout Error';
                    purchaseOrder.Order_Status_Interface_Message__c = result.message;
                } else {
                    purchaseOrder.Order_Status__c = 'Error';
                    purchaseOrder.Order_Status_Interface_Message__c = result.message;
                }
                // update the purchase order
                update purchaseOrder;
            }
        }
        catch(Exception e){
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Oracle Order Error', purchaseOrder.Id);
            purchaseOrder.Order_Status__c = 'Error';
            purchaseOrder.Order_Status_Interface_Message__c = e.getMessage() + ' - ' + e.getStackTraceString();
            update purchaseOrder;
        }
        return null;
    }
}