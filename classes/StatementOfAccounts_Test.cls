@isTest
private class StatementOfAccounts_Test  {
	
	static TestMethod void testGetAccountSummary() {

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockSOAResponse(false, true));

		String response = StatementOfAccounts.getAccountSummary('12345');
		System.debug('response: ' + response);

		Test.stopTest();		
	}

	static TestMethod void testGetAccountSummaryNegative() {
		
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockSOAResponse(true, true));

		String response = StatementOfAccounts.getAccountSummary('12345');
		System.debug('response2: ' + response);

		Test.stopTest();

	}
	
	static TestMethod void testQueryTrxNoFilter() {

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockSOAResponse(false, false));

		String response = StatementOfAccounts.queryTrxDetails('12345', '01-01-2016', '12-31-2020', '');
		System.debug('response3: ' + response);

		Test.stopTest();

	}

	static TestMethod void testQueryTrxNoFilter_Neg() {

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockSOAResponse(true, false));

		String response = StatementOfAccounts.queryTrxDetails('12345', '01-01-2016', '12-31-2020', '');
		System.debug('response4: ' + response);

		Test.stopTest();

	}

	static TestMethod void testQueryTrxWithFilter() {

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockSOAResponse(false, false));

		String response = StatementOfAccounts.queryTrxDetails('12345', '01-01-2016', '12-31-2020', 'OP');
		System.debug('response5: ' + response);

		Test.stopTest();

	}

	static TestMethod void testQueryTrxWithFilter_Neg() {

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockSOAResponse(true, false));

		String response = StatementOfAccounts.queryTrxDetails('12345', '01-01-2016', '12-31-2020', 'OP');
		System.debug('response6: ' + response);

		Test.stopTest();

	}

	static TestMethod void testConstructor() {
		
		Test.startTest();
		
		StatementOfAccounts soa = new StatementOfAccounts();
		System.assertEquals(soa.userType, UserInfo.getUserType());
		System.assertEquals(soa.locale, UserInfo.getLanguage());

		Test.stopTest();

	}


	public class MockSOAResponse implements HttpCalloutMock {

		Boolean isNegativeTest {get;set;}
		Boolean isAcctSummary {get;set;}

		public MockSOAResponse(Boolean isNegativeTest, Boolean isAcctSummary) {
			this.isNegativeTest = isNegativeTest;
			this.isAcctSummary = isAcctSummary;
		}
    
	    public HttpResponse respond(HttpRequest rqst) {
	        HttpResponse hResp = new HttpResponse();
	        
	        if(this.isNegativeTest) {
	        	throw new REST_QuoteException('Read Timed Out');	            
	        } else {
	            hResp.setStatusCode(200);
	            hResp.setStatus('OK');
	            if(isAcctSummary)
	            	hResp.setBody(' {"query_soa_response":{"account_summary":{"amount_paid":"-250","credit_limit":"750000","customer_name":"Smart Energy Solar, Inc.","open_balance":"480125.84","amount_past_due":"148003.88","available_credit":"269874.16"}}}');
	            else
	            	hResp.setBody('{"query_soa_response":{"account_statement_collection":[{"amount":"12549.44","amount_open":"9400.44","amount_paid":"","paid_date":"","payment_ref":"","trx_number":"189350","sales_order":"12169604","trx_type":"Invoice","trx_date":"2015-11-12T08:00:00Z","due_date":"2015-12-27T08:00:00Z","transaction_currency_code":"USD","currency_code":"USD","purchase_order":"Unreturned Mat\'l Lease 724909 H.O Robert Smith"}]}}');
	        }
	        return hResp;
	    }
	}
	
}