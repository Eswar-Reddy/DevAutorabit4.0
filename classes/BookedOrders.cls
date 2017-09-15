/*
* ID #130249379 - Structured Shipping Data in order creation (NA)
*
*
*
*
*
*
*
*/

global with sharing class BookedOrders {
    public static final String TIME_OUT_MESSAGE = '{"time_out_error":"A timeout occurred while communicating with Informatica. Please contact the SunPower Administrator if this error persists."}';
    public String locale {get; private set;}
    public String language {get; private set;}
    public String userType {get; private set;}
    public String dealerType {get; private set;}
    public String stsRecordTypeId {get; private set;}
    public String operatingUnit {get; private set;}


    public BookedOrders() {
        locale = Userinfo.getLocale();
        language = Userinfo.getLanguage();
        userType = UserInfo.getUserType();
        stsRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_to_Site__c.sobjectType).get('Installation_Site');

        for(User u : [SELECT Country_Domain__c, Contact.Account.Oracle_Operating_Unit__c From User WHERE Id =: UserInfo.getUserId()]) {
            dealerType = u.Country_Domain__c;
            operatingUnit = u.Contact.Account.Oracle_Operating_Unit__c;
        }
    }

    @RemoteAction
    global static String getOrders(String partnerId, String searchQuery) {
        if(String.isNotBlank(partnerId)) {
            String url;

            if(partnerId == 'internal') {
                url = 'callout:InformaticaOracleOrders?' + searchQuery + '&rowsize=1000&sort=order_date:desc';
            } else url = 'callout:InformaticaOracleOrders?customer_account_number=' + partnerId + searchQuery + '&rowsize=1000&sort=order_date:desc';

            // setup the request
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setTimeout(45000);

            try {
                // send the request, and return a response
                HttpResponse res = h.send(req);
                if(res.getStatusCode() == 200) {
                    // setup logging
                    try {
                        generateLogging('SO Get Orders', (String.valueOf(req) + req.getBody()), (String.valueOf(res) + res.getBody()));
                    }
                    catch (Exception e) {}

                    return res.getBody();
                } else return TIME_OUT_MESSAGE;
            }
            catch (Exception e) {
                return TIME_OUT_MESSAGE;
            }
        } else return null;
    }

    @RemoteAction
    global static String updateOrders(String updateRequest, String sfAccountId) {
        if(String.isNotBlank(updateRequest)) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            //set the endpoint
            string url = 'callout:InformaticaOracleOrders';
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            req.setBody(updateRequest);
            req.setMethod('PUT');
            req.setTimeout(90000);

            try {
                // Send the request, and return a response
                HttpResponse res = h.send(req);
                if(res.getStatusCode() == 200) {
                    // setup logging
                    try {
                        generateLogging('SO Update Orders', (String.valueOf(req) + req.getBody()), (String.valueOf(res) + res.getBody()), sfAccountId);
                    }
                    catch (Exception e) {}

                    return res.getBody();
                } else return TIME_OUT_MESSAGE;
            }
            catch (Exception e) {
                return TIME_OUT_MESSAGE;
            }
        } else return null;
    }

    @RemoteAction
    global static String getOrderDetails(String searchQuery) {
        if(String.isNotBlank(searchQuery)) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            //set the endpoint
            string url = 'callout:InformaticaOracleOrders/' + searchQuery;
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setTimeout(45000);

            try {
                // Send the request, and return a response
                HttpResponse res = h.send(req);
                if(res.getStatusCode() == 200) {
                    // setup logging
                    try {
                        generateLogging('SO Get Order Details', (String.valueOf(req) + req.getBody()), (String.valueOf(res) + res.getBody()));
                    } catch (Exception e) {}

                    return res.getBody();
                } else return TIME_OUT_MESSAGE;
            }
            catch (Exception e) {
                return TIME_OUT_MESSAGE;
            }
        } else return null;
    }

    @RemoteAction
    global static String updateAddress(String updateRequest, String sfAccountId) {
        if(String.isNotBlank(updateRequest)) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            //set the endpoint
            string url = 'callout:InformaticaOracleOrders';
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            req.setBody(updateRequest);
            req.setMethod('PUT');
            req.setTimeout(45000);

            try {
                // Send the request, and return a response
                HttpResponse res = h.send(req);
                if(res.getStatusCode() == 200) {
                    // setup logging
                    try {
                        generateLogging('SO Update Address', (String.valueOf(req) + req.getBody()), (String.valueOf(res) + res.getBody()), sfAccountId);
                    } catch (Exception e) {}

                    return res.getBody();
                } else return TIME_OUT_MESSAGE;
            }
            catch (Exception e) {
                return TIME_OUT_MESSAGE;
            }
        } else return null;
    }

    @RemoteAction
    global static ResultMessage getPartnerInfo() {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('Partner', [Select Contact.Account.Oracle_Account_Number__c, Contact.Account.Partner_Opt_Out_Ok_To_Ship__c, Country_Domain__c FROM User Where ID =: UserInfo.getUserId() LIMIT 1]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getPartnerShipTo(String sfAccountId, String operatingUnit) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('PartnerShipTo', [SELECT Address1__c, Address2__c, Address3__c, City__c, State__c, Zip__c, Country__c, Oracle_County__c, Address__c, SiteID__c, LastModifiedDate, DeliverySiteType__c, DeliveryTimeEnd__c, DeliveryTimeStart__c, DriverAssist__c, DropTrailer__c, LiftGatePalletJack__c, SpecialEquipment__c, EMEA_Alternate_Contact__c, EMEA_Alternate_Contact_Phone__c, EMEA_Liftgate__c, EMEA_Pallet_Jack__c, EMEA_Truck_Type__c, EMEA_Special_Instructions__c, Dealer_Account__r.Name, Dealer_Account__r.Phone FROM Ship_To_Site__c WHERE Dealer_Account__c =:sfAccountId AND SiteID__c > '0' AND RecordType.Name = 'Dealer Warehouse' AND Status__c = 'Active' AND Oracle_Operating_Unit__c = :operatingUnit AND (Residential_Customer_Account__c = '' OR Residential_Customer_Account__c = null) ORDER BY LastModifiedDate DESC]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getCurrentShipTo(String siteId) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('CurrentShipTo', [SELECT Address1__c, Address2__c, Address3__c, City__c, State__c, Zip__c, Country__c, Oracle_County__c, Address__c, SiteID__c, LastModifiedDate FROM Ship_To_Site__c WHERE SiteID__c =:siteId]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getPartners() {
        try {
            Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('Partners', [SELECT Oracle_Account_Number__c, Name, BillingCity, BillingState, BillingCountry, Oracle_Operating_Unit__c FROM Account WHERE RecordTypeId =:recTypeId ORDER BY Name, BillingCountry, BillingState, BillingCity]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    // for internal users
    @RemoteAction
    global static ResultMessage getSalesforceAccountId(String oracleAccountNumber) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            String id;
            for(Account a : [SELECT Id FROM Account WHERE Oracle_Account_Number__c =:oracleAccountNumber LIMIT 1]) {
                id = a.Id;
            }
            result.payloadMap.put('AccountId', id);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    // for internal users
    @RemoteAction
    global static ResultMessage getDealerAccountInfo(String oracleAccountNumber) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('DealerInfo', [SELECT Id, Oracle_Operating_Unit__c FROM Account WHERE Oracle_Account_Number__c =:oracleAccountNumber LIMIT 1]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    private static void generateLogging(String service, String outboundReq, String inboundRes, String sfAccountId) {
        try {
            Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
            log.JSON_Payload__c = outboundReq.length() > 131072 ? outboundReq.left(131071) : outboundReq;
            log.Response__c = inboundRes.length() > 131072 ? inboundRes.left(131071) : inboundRes;
            log.Service__c = service;
            if(String.isNotBlank(sfAccountId))
                log.Partner_Account__c = sfAccountId;

            insert log;
        }
        catch (Exception e) {}
    }

    private static void generateLogging(String service, String outboundReq, String inboundRes) {
        try {
            Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
            log.JSON_Payload__c = outboundReq.length() > 131072 ? outboundReq.left(131071) : outboundReq;
            log.Response__c = inboundRes.length() > 131072 ? inboundRes.left(131071) : inboundRes;
            log.Service__c = service;

            insert log;
        }
        catch (Exception e) {}
    }

    @RemoteAction
    global static ResultMessage insertShipTo(String jsonString) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            Ship_TO_Site__c sts = new Ship_To_Site__c();
            sts = (Ship_To_Site__c)JSON.deserializeStrict(jsonString, Ship_To_Site__c.class);
            System.debug(sts);
            try {
                Database.SaveResult sr = Database.insert(sts);
                if(sr.isSuccess()) {
                    result.payloadMap.put('AddressInserted', 'true');
                    return result;
                }
                else {
                    String error;
                    for(Database.Error err : sr.getErrors()) {
                        error = error + '  error inserting new ship to site - ' + err.getStatusCode() + ': ' + err.getMessage();
                        System.debug('  error inserting new ship to site - ' + err.getStatusCode() + ': ' + err.getMessage());
                    }
                    result.payloadMap.put('AddressInserted', error);
                    return result;
                }
            }
            catch(Exception e) {
                try {
                    sts.Dealer_Account__c = sts.Residential_Customer_Account__c;
                    Database.SaveResult sr2 = Database.insert(sts);
                    if(sr2.isSuccess()) {
                        result.payloadMap.put('AddressInserted', 'true');
                        return result;
                    }
                    else {
                        String error;
                        for(Database.Error err : sr2.getErrors()) {
                            error = error + '  error inserting new ship to site - ' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug('  error inserting new ship to site - ' + err.getStatusCode() + ': ' + err.getMessage());
                        }
                        result.payloadMap.put('AddressInserted', error);
                        return result;
                    }
                }
                catch(Exception e2) {
                    return new ResultMessage(false, e2.getMessage() + ' ' + e2.getStackTraceString());
                }
            }
        }
        catch(Exception e3) {
            return new ResultMessage(false, e3.getMessage() + ' ' + e3.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage checkSiteId(String siteId) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('SiteIdCount', [SELECT count() FROM Ship_To_Site__c WHERE SiteID__c =:siteId]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getOracleOperatingUnits() {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            List<String> oou = new List<String>();
            // get the field
            Schema.DescribeFieldResult fr = Account.Oracle_Operating_Unit__c.getDescribe();
            List<Schema.PicklistEntry> ple = fr.getPicklistValues();
            for(Schema.PicklistEntry e : fr.getPicklistValues()) {
                oou.add(e.getValue());
            }

            result.payloadMap.put('OracleOperatingUnits', oou);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getFlashData(String orderNum) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            Id soId;
            // get the sales order Id
            for(WR_ORACLE_SalesOrder__c so : [SELECT Id FROM WR_ORACLE_SalesOrder__c WHERE Sales_Order__c =: orderNum LIMIT 1]) {
                soId = so.Id;
            }

            // get the flash data from the sales order products
            if(String.isNotBlank(soId)) {
                List<WR_FDS_Product__c> prod = new List<WR_FDS_Product__c>();

                for(WR_FDS_Product__c p : [SELECT Dealer_Name__c, FF__c, Flash_Test_Date__c, ImpMod__c, IscMod__c, Packing_Slip__c, PickUpDate__c, Power__c, Product_Name__c, Product_Type__c, Serial_Number__c, VmpMod__c, VocMod__c FROM WR_FDS_Product__c WHERE WR_ORACLE_SalesOrder__c =: soId AND Flash_Test_Date__c != null]) {

                    prod.add(p);
                }
                if(!prod.isEmpty()) {
                    result.payloadMap.put('FlashData', prod);
                    return result;
                } else {
                    return new ResultMessage(false, 'NoFlashData');
                }

            } else {
                return new ResultMessage(false, 'SalesOrderNotFound');
            }
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    public static Map<String, String> getCountryCodes() {
        Map<String, String> result = new Map<String, String>();
        try {
            for(SelectOption s : OrderAppUtility.getCountryCodes()) {
                result.put(s.getValue(), s.getLabel());
            }
        }
        catch(Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Get CountryCodes Error');
        }
        return result;
    }

    @RemoteAction
    global static Map<String,String> downloadFlashTestDataDocGen(String jsonString) {
        if(String.isNotBlank(jsonString)) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            //set the endpoint
            string url = 'callout:DocGen';
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            req.setBody(jsonString);
            req.setMethod('POST');
            req.setTimeout(110000);

            try {
                // Send the request, and return a response
                HttpResponse res = h.send(req);
                //System.debug(res.getBody());

                // setup logging
                try {
                    //generateLogging('Flash Test Data: DocGen', (String.valueOf(req) + req.getBody()), (String.valueOf(res) + res.getBody()));
                } catch (Exception e) {}

                Blob responseBlob = res.getBodyAsBlob();
                Map<String,String> result = new Map<String,String>();
                result.put('true', EncodingUtil.base64Encode(responseBlob));
                System.debug('ResponseBlobSuccess');
                return result;
            } catch (Exception e) {
                Map<String,String> result = new Map<String,String>();
                System.debug('ResponseBlobFail_Inner');
                result.put('false', null);
                return result;
            }
        }
        Map<String,String> result = new Map<String,String>();
        result.put('false', null);
        System.debug('ResponseBlobFail_Outer');
        return result;
    }

    // start #130249379
    @RemoteAction
    public static Map<String, List<String>> getDeliveryServicesSelectOptions() {
        return OrderAppUtility.getDeliveryServicesSelectOptions();
    }

    @RemoteAction
    global static ResultMessage getDeliveryDetails(String siteId) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('DeliveryDetails', [SELECT Id, SiteID__c, DeliverySiteType__c, DeliveryTimeEnd__c, DeliveryTimeStart__c, DriverAssist__c, DropTrailer__c, LiftGatePalletJack__c, SpecialEquipment__c FROM Ship_To_Site__c WHERE SiteID__c =:siteId]);
            return result;
        }
        catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Get Delivery Details Error');
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getDeliveryDetailsEMEA(String siteId) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('DeliveryDetails', [SELECT Id, SiteID__c, EMEA_Alternate_Contact__c, EMEA_Alternate_Contact_Phone__c, EMEA_Liftgate__c, EMEA_Pallet_Jack__c, EMEA_Truck_Type__c, EMEA_Special_Instructions__c, Dealer_Account__r.Name, Dealer_Account__r.Phone FROM Ship_To_Site__c WHERE SiteID__c =:siteId]);
            return result;
        }
        catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Get EMEA Delivery Details Error');
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    public static Boolean updateDeliveryDetails(String recordString) {
        Boolean result = false;
        try {
            Ship_To_Site__c sts = (Ship_To_Site__c)JSON.deserialize(recordString, Ship_To_Site__c.class);
            update sts;
            result = true;
        }
        catch(Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Update Delivery Details Error');
        }
        return result;
    }
    // end #130249379

    @RemoteAction
    global static ResultMessage getShippingContacts(String accountId) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('ShippingContacts', [SELECT Id, Name, Phone, FirstName, LastName, Email, MobilePhone, Primary__c, Oracle_Contact_id__c, Account.Oracle_Account_Number__c FROM Contact WHERE AccountId =:accountId AND Terminated__c = FALSE AND RecordType.Name = 'Partner' AND ((Oracle_Contact_id__c != null AND Oracle_Contact_Status__c = 'Active') OR  Oracle_Contact_id__c = null OR  Oracle_Contact_id__c = '') ORDER BY Name ASC]);
            return result;
        }
        catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Get EMEA Delivery Details Error');
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getCurrentShipToContact(String contactId) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('CurrentShipTo', [SELECT Id, Name, Phone, Oracle_Contact_id__c FROM Contact WHERE Oracle_Contact_id__c =:contactId]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage createOracleContact(String contact, String conType) {
        try {
            return OracleOrderUtility.createOracleContact(contact, conType);
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }
    @RemoteAction
    public static OracleOrderUtility.CRDDatesResponse getCRDDates(string zipCode){
        return OracleOrderUtility.CRDCalloutRequest('US',zipCode);
    }    
}