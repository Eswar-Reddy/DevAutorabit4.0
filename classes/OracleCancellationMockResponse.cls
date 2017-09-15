@isTest(SeeAllData = false)
global class OracleCancellationMockResponse implements HttpCalloutMock {
       global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        system.debug('--Mock EndPoint---' + req.getEndpoint());
        system.debug('--Mock Method-----'+req.getMethod());
        if(req.getMethod() == 'POST'){
            res.setStatusCode(200);
        // Successful hold mock response
            res.setBody('{"process_oracle_hold_response":{"status_message":"Hold AppliedSuccessfully","oracle_hold_response":"          ","status":"S"}}');
            return res;
        }
        if(req.getMethod() == 'PUT'){
             res.setStatusCode(200);
            // successful Cancel Mock response.
             res.setBody('{"process_order_response":{"sales_order_response_collection":{"sales_order_response":{"status_message":"SuccessfullyProcessed","sales_order_response_lines":{"sales_order_line":[{"ordered_quantity":"6","line_number":"11","order_line_id":"5098076","line_status":"","ordered_item":"513977"},{"ordered_quantity":"24","line_number":"12","order_line_id":"5098077","line_status":"","ordered_item":"514850"},{"ordered_quantity":"20","line_number":"5","order_line_id":"5098070","line_status":"","ordered_item":"513800"},{"ordered_quantity":"1","line_number":"6","order_line_id":"5098071","line_status":"","ordered_item":"513402"},{"ordered_quantity":"14","line_number":"7","order_line_id":"5098072","line_status":"","ordered_item":"511171"},{"ordered_quantity":"40","line_number":"8","order_line_id":"5098073","line_status":"","ordered_item":"506608"},{"ordered_quantity":"24","line_number":"9","order_line_id":"5098074","line_status":"","ordered_item":"511505"},{"ordered_quantity":"12","line_number":"10","order_line_id":"5098075","line_status":"","ordered_item":"510088"}]},"sales_order_response_header":{"sold_to_org_id":"","order_header_id":"6544767","order_type_id":"","order_number":"11277939","request_date":"","ok_to_ship_status":"","ship_to_org_id":"","bill_to_site_id":"","schedule_arrival_date":"","cust_po_number":"1015115","ship_to_site_id":""},"status":"S"}}}}');
             return res;
        }
      // Error response . Infomatica in not availble.
        res.setStatusCode(502);
        res.setBody('{ "type": "api_error", "code": "502", "error": "Informatica SA is not available" }');
        return res;
    }

}