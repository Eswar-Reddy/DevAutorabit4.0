/*
    Utility class for all things related to real time ordering via Informatica/Oracle

    created: September 2016

    This utility was started by the cash ordering team and is meant to be eventually used by ALL financial offerings.

    The classes for submitting new orders and ship to sites are generic and will handle all order types. This will enable the serialization & deserialization of payloads without issue.

    EACH TYPE OF FINANCIAL OFFERING (CASH, LEASE, LOAN, NEW HOMES, ETC…) WILL HAVE A SEPARATE METHOD TO CONSTRUCT THE REQUEST




*/
public without sharing class OracleOrderUtility {

    public static ResultMessage sendNewCashOrder(Id poId, String siteId) {
        ResultMessage result = new ResultMessage(false, 'initializing');
        if(String.isNotBlank(poId) && String.isNotBlank(siteId)) {
            // create order request
            InformaticaCreateOrderRequest ord = new InformaticaCreateOrderRequest();
            // get order info
            for(Purchase_Order__c po : [SELECT Id, Bill_to_Site__r.Site_ID__c, Monitoring_Opt_Out__c, Name, Number_of_Systems__c, Order_Type__c, Racking_Opt_Out__c, Dealer_Account__r.Oracle_Account_Number__c, Dealer_Account__r.Line_of_Business__c, Primary_PSR_Email__c, Requested_Delivery_Date__c, Ship_to_Site__r.SiteID__c, Ship_To_Contact__r.Oracle_Contact_id__c, Special_Instructions__c, Dealer_Account__r.Partner_Opt_Out_Ok_To_Ship__c FROM Purchase_Order__c WHERE Id = :poId]) {

                // figure out the channel type
                String channelType = 'RVAR';
                if(String.isNotBlank(po.Dealer_Account__r.Line_of_Business__c)) {
                    if(po.Dealer_Account__r.Line_of_Business__c.toUpperCase() == 'COMBO') {
                        channelType = 'RVAR';
                    } else {
                        channelType = po.Dealer_Account__r.Line_of_Business__c.toUpperCase();
                    }
                }

                // check opt out ok to ship
                String okToShip = 'HOLD';
                if(po.Dealer_Account__r.Partner_Opt_Out_Ok_To_Ship__c) {
                    okToShip = 'RELEASE';
                }

				// fix true/false for Oracle y/n
                String rackingOptOut = 'N';
                String monitoringOptOut = 'N';
                if(po.Racking_Opt_Out__c) {
                    rackingOptOut = 'Y';
                }
                if(po.Monitoring_Opt_Out__c) {
                    monitoringOptOut = 'Y';
                }
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.crm_id = po.Id;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.psr_email_id = po.Primary_PSR_Email__c;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.cust_acct_number = po.Dealer_Account__r.Oracle_Account_Number__c;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.bill_to_site_id = po.Bill_to_Site__r.Site_ID__c;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.ship_to_site_id = siteId;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.ship_to_contact_id = po.Ship_To_Contact__r.Oracle_Contact_id__c;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.operation = 'CREATE';
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.sales_type = 'PURCHASE';
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.channel_type = channelType;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.cust_po_number = po.Name;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.request_date = String.valueOf(po.Requested_Delivery_Date__c);
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.special_instructions = po.Special_Instructions__c;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.ok_to_ship_flag = okToShip;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.racking_opt_out = rackingOptOut;
                ord.process_order_request.sales_order_collection.sales_order.sales_order_header.monitoring_opt_out = monitoringOptOut;
				
                for(Purchase_Order_Line__c poLine : [SELECT Id, Oracle_Line_Type__c, Item_ID__c, Order_Line_Number__c, Quantity__c, SmartPack_Item__c FROM Purchase_Order_Line__c WHERE Purchase_Order__c = :poId]) {
                    InformaticaOrderLines line = new InformaticaOrderLines();
                    line.sales_order_line.operation = 'CREATE';
                    line.sales_order_line.crm_id = po.Id;
                    line.sales_order_line.order_line_type = poLine.Oracle_Line_Type__c;
					
                    String pt = 'Bundle';
                    if(!poLine.SmartPack_Item__c) {
                        pt = 'A La Carte';
                    }
                    line.sales_order_line.product_type = pt;
                    line.sales_order_line.request_date = String.valueOf(po.Requested_Delivery_Date__c);
                    line.sales_order_line.ordered_item = poLine.Item_ID__c;
                    line.sales_order_line.line_number = poLine.Order_Line_Number__c;
                    line.sales_order_line.ordered_quantity = String.valueOf(poLine.Quantity__c);

                    ord.process_order_request.sales_order_collection.sales_order.sales_order_lines.add(line);
                }
            }

            result = OracleOrderService.saveOrderToOracle(ord, poId);
        } else {
            result.message = 'PO and/or Ship to Site Id was invalid - PO: ' + poId + ' Site Id: ' + siteId;
        }
		return result;
	}

    public static ResultMessage SendNewResidentialProjectOrder(Id poId, Id projectId) {
        ResultMessage result = new ResultMessage(false, 'initializing');
        try {
            if(String.isNotBlank(poId) && String.isNotBlank(projectId)) {
                // get the project
                Residential_Project__c rp = [SELECT Region__c, Lot_Number__c, Customer_Street_text__c, Customer_State_formula__c, Customer_City__c, Customer_Zip__c  FROM Residential_Project__c WHERE Id = :projectId];
                // create order request
                InformaticaCreateOrderRequest ord = new InformaticaCreateOrderRequest();
                // new ship to site for SPEB OU
                ResultMessage stsResult;
                // get order info
                for(Purchase_Order__c po : [SELECT Id, Bill_to_Site__r.Site_ID__c, Monitoring_Opt_Out__c, Name, Racking_Opt_Out__c, Dealer_Account__r.Oracle_Account_Number__c, Dealer_Account__r.Line_of_Business__c, Primary_PSR_Email__c, Requested_Delivery_Date__c, Ship_to_Site__r.Oracle_Operating_Unit__c, Ship_to_Site__r.SiteID__c, Ship_To_Contact__r.Oracle_Contact_id__c, Special_Instructions__c, Dealer_Account__r.Partner_Opt_Out_Ok_To_Ship__c, Installer__r.Oracle_Account_Number__c, Installer__r.Oracle_Vendor_Number__c, Installer__r.Oracle_Vendor_Site_Code__c FROM Purchase_Order__c WHERE Id = :poId]) {

                    // figure out the channel type
                    String channelType = 'RVAR';
                    if(String.isNotBlank(po.Dealer_Account__r.Line_of_Business__c)) {
                        if(po.Dealer_Account__r.Line_of_Business__c.toUpperCase() == 'COMBO') {
                            channelType = 'RVAR';
                        } else {
                            channelType = po.Dealer_Account__r.Line_of_Business__c.toUpperCase();
                        }
                    }
                    // check opt out ok to ship
                    String okToShip = 'HOLD';
                    if(po.Dealer_Account__r.Partner_Opt_Out_Ok_To_Ship__c) {
                        okToShip = 'RELEASE';
                    }
                    // fix true/false for Oracle y/n
                    String rackingOptOut = 'N';
                    String monitoringOptOut = 'N';
                    if(po.Racking_Opt_Out__c) {
                        rackingOptOut = 'Y';
                    }
                    if(po.Monitoring_Opt_Out__c) {
                        monitoringOptOut = 'Y';
                    }
                    // check the operating unit on the ship to site
                    String stsId = po.Ship_to_Site__r.SiteID__c;
                    if(po.Ship_to_Site__r.Oracle_Operating_Unit__c != 'SPEB OU') {
                        // get the current ship to site and send to oracle
                        for(Ship_to_Site__c sts : [SELECT Address1__c, Address2__c, City__c, Country__c, Oracle_County__c, State__c, Zip__c FROM Ship_To_Site__c WHERE Id = :po.Ship_To_Site__c]) {
                            // send new site to oracle
                            stsResult = OracleOrderService.saveShippingSiteToOracle(sts, po.Installer__r.Oracle_Account_Number__c, 'NH SPEC', channelType);

                            if(stsResult.success) {
                                // deserialize response
                                InformaticaShipToSiteResponse informaticaResponse = (InformaticaShipToSiteResponse)JSON.deserialize(stsResult.message, InformaticaShipToSiteResponse.class);
                                // set site id
                                stsId = informaticaResponse.process_customer_response.ship_to_sites.ship_to_site.cust_acct_site_id;
                            }
                        }
                    }

                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.crm_id = po.Id;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.psr_email_id = po.Primary_PSR_Email__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.cust_acct_number = po.Dealer_Account__r.Oracle_Account_Number__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.bill_to_site_id = po.Bill_to_Site__r.Site_ID__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.ship_to_site_id = stsId;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.ship_to_contact_id = po.Ship_To_Contact__r.Oracle_Contact_id__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.operation = 'CREATE';
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.sales_type = 'NH SPEC';
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.channel_type = channelType;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.cust_po_number = po.Name;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.request_date = String.valueOf(po.Requested_Delivery_Date__c);
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.special_instructions = po.Special_Instructions__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.ok_to_ship_flag = okToShip;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.racking_opt_out = rackingOptOut;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.monitoring_opt_out = monitoringOptOut;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute1 = 'task number';
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute2 = po.Installer__r.Oracle_Account_Number__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute3 = rp.Lot_Number__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute4 = rp.Customer_Street_text__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute5 = po.Installer__r.Oracle_Vendor_Site_Code__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute6 = rp.Region__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute7 = rp.Customer_Street_text__c + ' ' + rp.Customer_City__c + ' ' + rp.Customer_State_formula__c + ', ' + rp.Customer_Zip__c;
                    ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute8 = po.Installer__r.Oracle_Vendor_Number__c;

                    for(Purchase_Order_Line__c poLine : [SELECT Id, Oracle_Line_Type__c, Item_ID__c, Order_Line_Number__c, Quantity__c, SmartPack_Item__c FROM Purchase_Order_Line__c WHERE Purchase_Order__c = :poId]) {
                        InformaticaOrderLines line = new InformaticaOrderLines();
                        line.sales_order_line.operation = 'CREATE';
                        line.sales_order_line.crm_id = po.Id;
                        line.sales_order_line.order_line_type = poLine.Oracle_Line_Type__c;
                        line.sales_order_line.request_date = String.valueOf(po.Requested_Delivery_Date__c);
                        line.sales_order_line.ordered_item = poLine.Item_ID__c;
                        line.sales_order_line.line_number = poLine.Order_Line_Number__c;
                        line.sales_order_line.ordered_quantity = String.valueOf(poLine.Quantity__c);

                        ord.process_order_request.sales_order_collection.sales_order.sales_order_lines.add(line);
						
						// check to see if this is a supply & services order
                        if(poLine.Item_ID__c == '141654') {
                            ord.process_order_request.sales_order_collection.sales_order.sales_order_header.attribute20 = 'SUPPLY_SERVICES';
                        }
                    }
                }
                result = OracleOrderService.saveOrderToOracle(ord, poId);
                // insert logs
                if(!result.logs.isEmpty()) {
                    SpectrumDebugUtility.generateDebugLog(result.logs);
                }
                if(stsResult != null && !stsResult.logs.isEmpty()) {
                    SpectrumDebugUtility.generateDebugLog(stsResult.logs);
                }
            } else {
                result.message = 'PO or Project Id was invalid - PO: ' + poId + ' Project: ' + projectId;
            }
        } catch (Exception e) {
            result.message = e.getMessage() + ' - ' + e.getStackTraceString();
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Create Residential Project Order');
        }
        return result;
    }

    public static void checkNewShipToSite(String response, Id stsId) {
        try {
            // deserialize response
            InformaticaShipToSiteResponse informaticaResponse = (InformaticaShipToSiteResponse)JSON.deserialize(response, InformaticaShipToSiteResponse.class);
            // get site id
            String newStsId = informaticaResponse.process_customer_response.ship_to_sites.ship_to_site.cust_acct_site_id;
            // check response
            if(informaticaResponse.process_customer_response.status == 'S' && String.isNotBlank(newStsId)) {
                // check to see if site id is already in sf
                Boolean isDuplicate = false;
                Id sfstsId;
                for(Ship_To_Site__c s : [SELECT Id FROM Ship_To_Site__c WHERE SiteID__c = :newStsId]) {
                    isDuplicate = true;
                    sfstsId = s.Id;
                }

	            // update new site w/orcale site info
	            if(!isDuplicate) {
	                Ship_To_Site__c s = new Ship_To_Site__c();
	                s.Id = stsId;
	                s.SiteID__c = newStsId;
	                s.Status__c = 'Active';
                    s.Oracle_Operating_Unit__c = informaticaResponse.process_customer_response.ship_to_sites.ship_to_site.ou_code;
	                update s;
	            }
	            // site is a duplicate so update po w/correct ship to site and flag the dup
	            else if(stsId != sfstsId) {
                    // flag the duplicate site
                    Ship_To_Site__c s = new Ship_To_Site__c();
                    s.Id = stsId;
                    s.IsDuplicate__c = true;
                    s.IsDuplicateId__c = sfstsId;
                    update s;

	                // update po w/correct site
	                Purchase_Order__c po = new Purchase_Order__c();
	                for(Purchase_Order__c p : [SELECT Id FROM Purchase_Order__c WHERE Ship_to_Site__c = :stsId LIMIT 1]) {
	                    po.Id = p.Id;
	                }

	                // make sure we have a valid po
	                if(String.isNotBlank(po.Id)) {
	                    po.Ship_to_Site__c = sfstsId;
	                    update po;
	                }
	            }
	        }
	    } catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Create Oracle Address Error');
	    }
	}

    @future(callout=true)
    public static void createOracleContact(String c, String conType, String poId) {
        try {
            // deserialize the incoming contact
            Contact con = (Contact)JSON.deserialize(c, Contact.class);

            // send to oracle
            ResultMessage result = OracleOrderService.saveContactToOracle(createContactRequest(con, conType), poId);
            // insert logs
            if(!result.logs.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(result.logs);
            }
            // check result
            if(result.success) {
                // deserialize result messagge
                OracleCreateContactResponse res = (OracleCreateContactResponse)JSON.deserialize(result.message, OracleCreateContactResponse.class);
                // get oracle contact id
                if(String.isNotBlank(res.process_customer_contact_response.contact_response.contact_id)) {
                    // update contact w/new oracle id
                    Contact oc = new Contact();
                    oc.Id = con.Id;
					oc.Oracle_Contact_Status__c = 'Active';
                    oc.Oracle_Contact_id__c = res.process_customer_contact_response.contact_response.contact_id;
                    update oc;
                }
            } else {
                SpectrumDebugUtility.createExceptionLog('Oracle Error', result.message, 'SO Create Oracle Contact Error', poId);
            }
        } catch(Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Create Oracle Contact Error', poId);
        }
    }

    // create contact real time not future method
    public static ResultMessage createOracleContact(String c, String conType) {
        try {
            ResultMessage r = new ResultMessage(true, 'intializing');

            // deserialize the incoming contact
            Contact con = (Contact)JSON.deserialize(c, Contact.class);

            // send to oracle
            ResultMessage result = OracleOrderService.saveContactToOracle(createContactRequest(con, conType), null);
            // insert logs
            if(!result.logs.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(result.logs);
            }
            // check result
            if(result.success) {
                // deserialize result messagge
                OracleCreateContactResponse res = (OracleCreateContactResponse)JSON.deserialize(result.message, OracleCreateContactResponse.class);
                // get oracle contact id
                if(String.isNotBlank(res.process_customer_contact_response.contact_response.contact_id)) {
                    // update contact w/new oracle id
                    Contact oc = new Contact();
                    oc.Id = con.Id;
                    oc.Oracle_Contact_Status__c = 'Active';
                    oc.Oracle_Contact_id__c = res.process_customer_contact_response.contact_response.contact_id;
                    update oc;
                }
                r.message = JSON.serialize(res);
                return r;
            } else {
                SpectrumDebugUtility.createExceptionLog('Oracle Error', result.message, 'SO Create Oracle Contact Error');
                return new ResultMessage(false, result.message);
            }
        } catch(Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Create Oracle Contact Error');
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }

    }

    // general methods
    private static OracleCreateContactRequest createContactRequest(Contact con, String conType) {
        // setup request payload
        OracleCreateContactRequest ccr = new OracleCreateContactRequest();
        ccr.process_customer_contact_request.message_header.source_system_id = 'SFDC';
        ccr.process_customer_contact_request.message_header.transaction_id = generateGUID();
        ccr.process_customer_contact_request.contact_request.account_number = con.Account.Oracle_Account_Number__c;
        ccr.process_customer_contact_request.contact_request.person_first_name = con.FirstName;
        ccr.process_customer_contact_request.contact_request.person_last_name = con.LastName;
        ccr.process_customer_contact_request.contact_request.email_address = con.Email;
        ccr.process_customer_contact_request.contact_request.phone_number = con.Phone;
        ccr.process_customer_contact_request.contact_request.mobile_no = con.MobilePhone;
        ccr.process_customer_contact_request.contact_request.contact_type = conType;

        return ccr;
    }

    // general methods
	public static String generateGUID() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }


    // classes for the Informatica create new order request
    public class InformaticaCreateOrderRequest {
        public InformaticaOrderRequest process_order_request;

        public InformaticaCreateOrderRequest() {
            process_order_request = new InformaticaOrderRequest();
        }
    }

    public class InformaticaOrderRequest {
        public InformaticaOrderMessage message_header;
        public InformaticaOrderCollection sales_order_collection;

        public InformaticaOrderRequest() {
            message_header = new InformaticaOrderMessage();
            sales_order_collection = new InformaticaOrderCollection();
        }
    }

    public class InformaticaOrderMessage {
        public String source_system_id;
        public String transaction_id;

        public InformaticaOrderMessage() {
            source_system_id = 'SFDC';
            transaction_id = generateGUID();
        }
    }

    public class InformaticaOrderCollection {
        public InformaticaOrder sales_order;

        public InformaticaOrderCollection() {
            sales_order = new InformaticaOrder();
        }
    }

    public class InformaticaOrder {
        public InformaticaOrderHeader sales_order_header;
        public List<InformaticaOrderLines> sales_order_lines;

        public InformaticaOrder() {
            sales_order_header = new InformaticaOrderHeader();
            sales_order_lines = new List<InformaticaOrderLines>();
        }
    }

    public class InformaticaOrderHeader {
        public String crm_id;
        public String psr_email_id;
        public String oracle_user_id;
        public String cust_acct_number;
        public String bill_to_site_id;
        public String ship_to_site_id;
        public String shipping_method;
        public String special_instructions;
        public String smartpack_flag;
        public String interface_message;
        public String new_order_class;
        public String inverter_type;
        public String vendor_number;
        public String vendor_site_code;
        public String partner_acc_number;
        public String tax_identifier;
        public String sales_type;
        public String channel_type;
        public String bill_to_contact_id;
        public String data_source;
        public String return_flag;
        public String accounting_rule_id;
        public String party_type;
        public String order_type_name;
        public String warehouse_org_id;
        public String financier;
        public String cancelled_flag;
        public String cust_po_number;
        public String freight_terms_code;
        public String header_id;
        public String invoice_to_contact_id;
        public String invoice_to_org_id;
        public String order_number;
        public String order_source_id;
        public String order_type_id;
        public String payment_term_id;
        public String price_list_id;
        public String request_date;
        public String salesrep_id;
        public String sales_channel_code;
        public String shipping_method_code;
        public String ship_from_org_id ;
        public String ship_to_contact_id;
        public String ship_to_org_id;
        public String sold_from_org_id;
        public String sold_to_org_id;
        public String transactional_curr_code;
        public String return_status;
        public String operation;
        public String change_reason;
        public String change_comments;
        public String ship_to_address1;
        public String ship_to_address2;
        public String ship_to_address3;
        public String ship_to_address4;
        public String ship_to_city;
        public String ship_to_postal_code;
        public String ship_to_state;
        public String ship_to_county;
        public String ship_to_country;
        public String bill_to_address1 ;
        public String bill_to_address2 ;
        public String bill_to_address3 ;
        public String bill_to_address4 ;
        public String bill_to_city;
        public String bill_to_postal_code;
        public String bill_to_state;
        public String bill_to_county;
        public String bill_to_country;
        public String bill_to_contact;
        public String ship_to_contact;
        public String country;
        public String partner_name;
        public String psr_name;
        public String ok_to_ship_flag;
        public String change_requester;
        public String racking_opt_out;
        public String monitoring_opt_out;
        public String attribute1;
        public String attribute2;
        public String attribute3;
        public String attribute4;
        public String attribute5;
        public String attribute6;
        public String attribute7;
        public String attribute8;
        public String attribute9;
        public String attribute10;
        public String attribute11;
        public String attribute12;
        public String attribute13;
        public String attribute14;
        public String attribute15;
        public String attribute16;
        public String attribute17;
        public String attribute18;
        public String attribute19;
        public String attribute20;

        public InformaticaOrderHeader() {
            data_source = 'SFDC';
            // check user type
            String ut = UserInfo.getUserType();
            if(ut.contains('Partner')) {
                ut = 'EXTERNAL';
            } else ut = 'INTERNAL';
            change_requester = ut;
        }
    }

    public class InformaticaOrderLines {
        public InformaticaOrderLine sales_order_line;

        public InformaticaOrderLines() {
            sales_order_line = new InformaticaOrderLine();
        }
    }

    public class InformaticaOrderLine {
        public String crm_id;
        public String order_line_type;
        public String product_type;
        public String wattage_type;
        public String item_type;
        public String crm_order_line_id;
        public String vendor_number;
        public String vendor_site_code;
        public String accounting_rule_id;
        public String party_type;
        public String bill_to_site_id;
        public String ship_to_site_id;
        public String shipping_method;
        public String return_flag;
        public String actual_arrival_date;
        public String actual_shipment_date;
        public String agreement_id;
        public String arrival_set_id;
        public String booked_flag;
        public String cancelled_flag;
        public String cancelled_quantity;
        public String context;
        public String created_by;
        public String header_id;
        public String inventory_item_id;
        public String invoice_to_contact_id;
        public String invoice_to_org_id;
        public String ordered_item;
        public String line_id;
        public String line_number;
        public String line_type_id;
        public String ordered_quantity;
        public String order_quantity_uom;
        public String org_id;
        public String request_date;
        public String return_reason_code;
        public String schedule_arrival_date;
        public String schedule_ship_date;
        public String shipping_method_code;
        public String ship_from_org_id;
        public String ship_to_contact_id;
        public String ship_to_org_id;
        public String unit_selling_price;
        public String return_status;
        public String operation;
        public String change_reason;
        public String change_comments;
        public String calculate_price_flag;
        public String flow_status_code;
        public String ship_to_address1;
        public String ship_to_address2;
        public String ship_to_address3;
        public String ship_to_address4;
        public String ship_to_city;
        public String ship_to_postal_code;
        public String ship_to_state;
        public String ship_to_county;
        public String ship_to_country;
    }

    public class InformaticaCreateOrderResponse {
        public Sales_order_response sales_order_response;

        InformaticaCreateOrderResponse() {
            sales_order_response = new Sales_order_response();
        }
    }

    public class Sales_order_response {
        public String status;
        public String status_message;
        public Sales_order_response_header sales_order_response_header;

        Sales_order_response() {
            sales_order_response_header = new Sales_order_response_header();
        }
    }

    public class Sales_order_response_header {
        public String header_id;
        public String order_number;
    }
    // end classes for the Informatica create new order request

    // classes for the Informatica create ship to site request
    public class InformaticaShipToSiteCreateRequest {
        public InformaticaShipToSiteCustomerRequest process_customer_request;

        public InformaticaShipToSiteCreateRequest() {
            process_customer_request = new InformaticaShipToSiteCustomerRequest();
        }
    }

    public class InformaticaShipToSiteCustomerRequest {
        public InformaticaShipToSiteMessage message_header;
        public InformaticaShipToSiteCustomer customer;
        public List<InformaticaShipToSiteSite> ship_to_sites;

        public InformaticaShipToSiteCustomerRequest() {
            message_header = new InformaticaShipToSiteMessage();
            customer = new InformaticaShipToSiteCustomer();
            InformaticaShipToSiteSite ship_to_site = new InformaticaShipToSiteSite();
            ship_to_sites = new List<InformaticaShipToSiteSite>();
            ship_to_sites.add(ship_to_site);
        }
    }

    public class InformaticaShipToSiteMessage {
        public String source_system;
        public String transaction_id;

        public InformaticaShipToSiteMessage() {
            source_system = 'SFDC';
            transaction_id = generateGUID();
        }
    }

    public class InformaticaShipToSiteCustomer {
        public String sales_type;
        public String channel_type;
        public String account_number;

        public InformaticaShipToSiteCustomer() {
        }
    }

    public class InformaticaShipToSiteSite {
        public InformaticaShipToSiteSiteDetail ship_to_site;

        public InformaticaShipToSiteSite() {
            ship_to_site = new InformaticaShipToSiteSiteDetail();
        }
    }

    public class InformaticaShipToSiteSiteDetail {
        public String bill_to_flag;
        public String ship_to_flag;
        public String address1;
		public String address2;
        public String city;
        public String state;
        public String postal_code;
        public String country;
        public String county;

        public InformaticaShipToSiteSiteDetail() {
            bill_to_flag = 'N';
            ship_to_flag = 'Y';
        }
    }

    public class InformaticaShipToSiteResponse {
        public Process_customer_response process_customer_response;

        InformaticaShipToSiteResponse() {
            process_customer_response = new Process_customer_response();
        }
    }

    public class Process_customer_response {
        public Ship_to_sites ship_to_sites;
        public String status;
        public String status_message;
        public Customer customer;

        Process_customer_response() {
            ship_to_sites = new Ship_to_sites();
            customer = new Customer();
        }
    }

    public class Ship_to_sites {
        public Ship_to_site ship_to_site;

        Ship_to_sites() {
            ship_to_site = new Ship_to_site();
        }
    }

    public class Ship_to_site {
        public String cust_acct_site_error_message;
        public String cust_site_use_return_status;
        public String cust_acct_site_id;
        public String site_use_code;
        public String ou_code;
    }

    public class Customer {
        public String cust_account_id;
    }
    // end classes for the Informatica create ship to site request

    // start classes for the Informatica create contact request
    // request
    public class OracleCreateContactRequest {
        Process_customer_contact_request process_customer_contact_request;

        OracleCreateContactRequest() {
            process_customer_contact_request = new Process_customer_contact_request();
        }
    }

    public class Process_customer_contact_request {
        public Message_header message_header;
        public Contact_Request contact_request;

        Process_customer_contact_request() {
            message_header = new Message_header();
            contact_request = new Contact_Request();
        }
    }

    public class Message_header {
        public String source_system_id;
        public String transaction_id;
    }

    public class Contact_Request {
        public String account_number;
        public String person_first_name;
        public String person_middle_name;
        public String person_last_name;
        public String role_type;
        public String email_address;
        public String phone_area_code;
        public String phone_country_code;
        public String phone_number;
        public String primary_flag;
        public String fax_no;
        public String mobile_no;
        public String contact_type;
    }

    // response
    public class OracleCreateContactResponse {
        Process_customer_contact_response process_customer_contact_response;

        OracleCreateContactResponse() {
            process_customer_contact_response = new Process_customer_contact_response();
        }
    }

    public class Process_customer_contact_response {
        public String status;
        public String status_message;
        public Contact_Response contact_response;

        Process_customer_contact_response() {
            contact_response = new Contact_Response();
        }
    }

    public class Contact_Response {
        public String account_number;
        public String contact_id;
    }
    // end classes for the Informatica create contact request
     public class cls_query_order_response {
        public String status_message;
        public String earliest_crd_date;
        public String lead_time;
        public List<String> exception_dates;
        public String status;
    }

    public class CRDDatesResponse{
       public cls_query_order_response  query_order_response;
       public CRDDatesResponse(){
          query_order_response = new cls_query_order_response();
       }
    }


    public static CRDDatesResponse CRDCalloutRequest(string countryCode,string zipCode){

        String url = 'callout:CRD_API';
        url += '?sales_type=PURCHASE&';
        url += 'channel_type=RVAR&';
        url += 'country=' + countryCode + '&';
        url += 'zipcode=' + zipCode.deleteWhiteSpace();
        System.debug('-----CRD--URL-----' + url);

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(110000);
        try {
            HttpResponse res = h.send(req);
            system.debug(LoggingLevel.ERROR, '---------' + res);
            system.debug(LoggingLevel.ERROR, '-----getStatusCode----' + res.getStatusCode());
            system.debug(LoggingLevel.ERROR, '-----getBody()----' + res.getBody());
            if(res.getStatusCode() == 200) {
               CRDDatesResponse  crdResponse = (CRDDatesResponse) JSON.deserialize(res.getBody(), CRDDatesResponse.Class);
               system.debug('---crdResponse----' + crdResponse);
               return crdResponse;
            }
           else
             return null;
         }
        catch (Exception e) {
             SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'CRD Request Error');
             return null;
           }
     }
}