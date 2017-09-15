global with sharing class StatementOfAccounts {
	public String locale {get; private set;}
    public String language {get; private set;}
    public String userType {get; private set;}
    public static final String TIME_OUT_MESSAGE = '{"error":"Time Out Error"}';

	public StatementOfAccounts() {
		locale = Userinfo.getLocale();
        language = Userinfo.getLanguage();
        userType = UserInfo.getUserType();
	}

    @RemoteAction
    global static String getAccountSummary(String acctNo) {

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        string url = 'callout:AccountSummary' + '?customer_account_number=' + acctNo;
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(110000);

        try {
            // Send the request, and return a response
            HttpResponse res = h.send(req);

            // setup logging
            try {
                AngularUtilities.generateLogging('SoA Acct Summary', (String.valueOf(req) + ' ' + req.getBody()), (String.valueOf(res) + ' ' + res.getBody()));
            } catch (Exception e) {}

            return res.getBody();
        } catch (Exception e) {
            return TIME_OUT_MESSAGE;
        }
    }

    @RemoteAction
    global static String queryTrxDetails(String acctNo, String startDate, String endDate, String qryFilter) {

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        //set the endpoint
        String urlHeader = 'callout:StatementOfAccounts' + '?customer_account_number=' + acctNo;
        String queryTypeFilter = String.isBlank(qryFilter) ? '' : ('&status=' + qryFilter);
        String dateFilters = '&start_transaction_date=' + startDate + '&end_transaction_date=' + endDate;
        String url = urlHeader + queryTypeFilter + dateFilters;
        System.debug(url);

        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(110000);

        try {
            // Send the request, and return a response
            HttpResponse res = h.send(req);

            // setup logging
            try {
                AngularUtilities.generateLogging('SoA Request', (String.valueOf(req) + ' ' + req.getBody()), (String.valueOf(res) + ' ' + res.getBody()));
            } catch (Exception e) {}

            return res.getBody();
        } catch (Exception e) {
            return TIME_OUT_MESSAGE;
        }
    }
}