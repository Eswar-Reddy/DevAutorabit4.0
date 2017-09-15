public without sharing class OracleOrderService {

    public static ResultMessage saveOrderToOracle(OracleOrderUtility.InformaticaCreateOrderRequest request, Id poId) {
        try {
            // serialize the Informatica request
            String order = JSON.serialize(request, false);

            // setup the request
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            //set the endpoint
            string url = 'callout:InformaticaOracleOrders';
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            req.setBody(order);
            req.setMethod('POST');
            req.setTimeout(60000);

            // send the request
            HttpResponse res = h.send(req);
            // set response
            ResultMessage result;
            if(res.getStatusCode() == 200) {
                result = new ResultMessage(true, res.getBody());
            } else {
                result = new ResultMessage(false, res.getBody());
            }
            // log response
            SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
            log.service = 'SO Create Oracle Order';
            log.jsonPayload = String.valueOf(req) + ' ' + req.getBody();
            log.response = String.valueOf(res) + ' ' + res.getBody();
            log.purchaseOrderId = poId;
            result.logs.add(log);
            return result;

        } catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Create Oracle Order Error', poId);
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

	public static ResultMessage saveShippingSiteToOracle(Ship_to_Site__c sts, String oracleAccountNumber, String orderType, String channelType) {
        try {
            // create new Informatica request
            OracleOrderUtility.InformaticaShipToSiteCreateRequest request = new OracleOrderUtility.InformaticaShipToSiteCreateRequest();
            // update request
            request.process_customer_request.customer.sales_type = orderType;
            request.process_customer_request.customer.channel_type = channelType;
            request.process_customer_request.customer.account_number = oracleAccountNumber;
            request.process_customer_request.ship_to_sites[0].ship_to_site.address1 = sts.Address1__c;
            request.process_customer_request.ship_to_sites[0].ship_to_site.address2 = sts.Address2__c;
            request.process_customer_request.ship_to_sites[0].ship_to_site.city = sts.City__c;
            request.process_customer_request.ship_to_sites[0].ship_to_site.state = sts.State__c;
            request.process_customer_request.ship_to_sites[0].ship_to_site.postal_code = sts.Zip__c;
            request.process_customer_request.ship_to_sites[0].ship_to_site.country = sts.Country__c;
            request.process_customer_request.ship_to_sites[0].ship_to_site.county = sts.Oracle_County__c;

            // serialize the Informatica request
            String adr = JSON.serialize(request, false);

            // setup the request
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            //set the endpoint
            string url = 'callout:InformaticaCustomerSite';
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            req.setBody(adr);
            req.setMethod('POST');
            req.setTimeout(40000);

            // send the request
            HttpResponse res = h.send(req);
            // set response
            ResultMessage result;
            if(res.getStatusCode() == 200) {
                result = new ResultMessage(true, res.getBody());
            } else {
                result = new ResultMessage(false, res.getBody());
            }
            // log response
            SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
            log.service = 'SO Create Oracle Address';
            log.jsonPayload = String.valueOf(req) + ' ' + req.getBody();
            log.response = String.valueOf(res) + ' ' + res.getBody();
            result.logs.add(log);
            return result;

        } catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Create Oracle Address Error');
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    public static ResultMessage saveContactToOracle(OracleOrderUtility.OracleCreateContactRequest ccr, String poId) {
        try {
            // serialze the request
            String body = JSON.serialize(ccr, false);

            // setup the request
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            //set the endpoint
            string url = 'callout:InformaticaCustomerContact';
            req.setEndpoint(url);
            req.setHeader('content-type', 'application/json');
            req.setBody(body);
            req.setMethod('POST');
            req.setTimeout(40000);

            // send the request
            HttpResponse res = h.send(req);
            // set response
            ResultMessage result;
            if(res.getStatusCode() == 200) {
                result = new ResultMessage(true, res.getBody());
            } else {
                result = new ResultMessage(false, res.getBody());
            }
            // log response
            SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
            log.service = 'SO Create Oracle Contact';
            log.jsonPayload = String.valueOf(req) + ' ' + req.getBody();
            log.response = String.valueOf(res) + ' ' + res.getBody();
            log.purchaseOrderId = poId;
            result.logs.add(log);
            return result;

        } catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Create Oracle Contact Error', poId);
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }
}