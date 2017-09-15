public with sharing class GreenlightWebService {

	private static final String ENDPOINT_URL =  GreenlightConstants__c.getInstance('ENDPOINT_URL').Value__c;
	private static final String USERNAME =  GreenlightConstants__c.getInstance('USERNAME').Value__c;
	private static final String KEY =  GreenlightConstants__c.getInstance('KEY').Value__c;
	private static final String PASSWORD =  GreenlightConstants__c.getInstance('PASSWORD').Value__c;
	
	private static final String CREDENTIALS_URL_PARAMS = '&apikey=' + KEY + '&username=' + USERNAME + '&password=' + PASSWORD;
	public static final String NEW_CREDIT_REQUEST_URL = ENDPOINT_URL + '/sunpowerresidential-create-and-invite-homeowner?getdata=create+and+invite+homeowner';
	public static final String RESUBMIT_CREDIT_REQUEST_URL =ENDPOINT_URL + '/sunpowerresidential-resend-homeowner-invite?getdata=Resend+Homeowner+Invite';
	
	public static final String INFORM_ADMIN_MSG = 'Please inform your Salesforce administrator.';
	public static final String GREENLIGHT_EXCEPTION = 'There was an issue with Greenlight.  '+INFORM_ADMIN_MSG;
							
	class FailedGreenlightException extends Exception { } 							
							
	public static void testCallout( String accountId ) 
	{
		//String pingurl = ENDPOINT_URL+ '/ping?getdata=ping';
		//String pingurl = 'https://solarcorp.leasedimensions.com/apirest/ping?getdata=ping';
		String pingurl = NEW_CREDIT_REQUEST_URL + CREDENTIALS_URL_PARAMS;
		Credit_Check_Request__c creditRequest = [SELECT Id, Successful_Invite__c, Contact__c, Email__c, First_Name__c, Last_Name__c, Account__c, Status__c
															 FROM Credit_Check_Request__c WHERE Account__c = : accountId];
		
		pingurl += getNewCreditRequestParameters( creditRequest, '001v000000772vc', 'test@salespersonemail.com' );
													
	    
		HttpRequest request = setWebRequestHeaders( pingurl, 'GET' );
	    HTTPResponse response;
	    try 
	    {
		    System.debug( request );
		    Http http = new Http();
		    response = http.send( request );
		    
		    System.debug( response.getBody() );
	    }
	    catch ( Exception ex ) 
	    {
		    System.debug( ex.getMessage() );
	    }
	    
	}
	
	public static String getNewCreditRequestParameters( Credit_Check_Request__c creditRequest, String installerId, String salesPersonEmail )	
	{
		String newCreditRequestParams = '&homeowner_first_name='+ EncodingUtil.urlEncode( creditRequest.First_Name__c, 'UTF-8' );
		newCreditRequestParams += '&homeowner_last_name='+ EncodingUtil.urlEncode( creditRequest.Last_Name__c, 'UTF-8' );
		newCreditRequestParams += '&homeowner_email=' + EncodingUtil.urlEncode( creditRequest.Email__c, 'UTF-8' );
		newCreditRequestParams += '&account_id=' + EncodingUtil.urlEncode( creditRequest.Account__c, 'UTF-8' );
		newCreditRequestParams += '&credit_request_id=' + EncodingUtil.urlEncode( creditRequest.Id, 'UTF-8' );
		newCreditRequestParams += '&installer_id=' + EncodingUtil.urlEncode( installerId, 'UTF-8' );
		newCreditRequestParams += '&salesperson_reference_id=' + EncodingUtil.urlEncode( salesPersonEmail, 'UTF-8' );
		newCreditRequestParams += '&selected_fund_product_code=MONTHLY_LEASE';
		
		return newCreditRequestParams;
		
	}
	
	public static HttpRequest setWebRequestHeaders( String url, String method ) 
	{
		HttpRequest request = new HttpRequest();
		
	    request.setEndpoint( url );
	    request.setMethod( method );
		request.setTimeout( 60000 );
	    
	    return request;
	}
	
	public static String gl_newCreditCheckRequest( Credit_Check_Request__c creditRequest, String installerId, String salesPersonEmail )
	{
		String newRequestUrl = NEW_CREDIT_REQUEST_URL + CREDENTIALS_URL_PARAMS;
		newRequestUrl += getNewCreditRequestParameters( creditRequest, installerId, salesPersonEmail );
	    
	    HttpRequest request = setWebRequestHeaders( newRequestUrl, 'GET' );
	    
	    HTTPResponse response;
	    try 
	    {
		    Http http = new Http();
		    response = http.send( request );
	    }
	    catch ( Exception ex ) 
	    {
		    throw new FailedGreenlightException( ex.getMessage() + '    ' + GREENLIGHT_EXCEPTION );
	    }

	    System.debug( response.getBody() );
	    
	    String responseString = parseResponse( response.getBody() );
	    
	    return responseString;
		
	}
	
	public static String gl_resubmitCreditCheckRequest( Credit_Check_Request__c creditCheckRequest )
	{
		String url = RESUBMIT_CREDIT_REQUEST_URL + CREDENTIALS_URL_PARAMS;
		url += '&credit_request_id=' + creditCheckRequest.Id;
	    
	    HttpRequest request = setWebRequestHeaders( url, 'GET' );
	    
	    HttpResponse response;
	    try {
		    
		    Http http = new Http();
		    response = http.send( request );
	    }
	    catch ( Exception ex ) 
	    {
			throw new FailedGreenlightException( ex.getMessage() + '    ' + GREENLIGHT_EXCEPTION );
	    }
		    
	    System.debug( response.getBody() );
	    
	    String responseString = parseResponse( response.getBody() );
	    
	    return responseString;
		
	}

	public static String parseResponse( String responseBody ) 
	{
		TG_XmlDom dom = new TG_XmlDom( responseBody );
		
	    TG_XmlNode root = dom.root;
	    String rootname = root.nodeName;

	    String responseString = '';
	    
    	TG_XmlNode responseNode = root.getElementByTagName('error_description');
    	
	    if ( responseNode != null )
	    {
	    	String responseValue = '';
	    	
	    	if ( root.getElementByTagName('error_code') != null && root.getElementByTagName('error_code').nodeValue == '103' )
	    	{	
	    		responseValue += 'error_code - 103; ';
	    		for (TG_XmlNode childNode : responseNode.childNodes )
	    		{
	    			System.debug( childNode );
	    			responseValue += childNode.nodeName + ' - ' + childNode.textContent + ';  ';
	    		}
	    	}
	    	else
	    	{
	    		responseValue = responseNode.nodeValue;
	    	}
	    	responseString = GREENLIGHT_EXCEPTION + '   ' + responseValue;
	    	
	    	throw new FailedGreenlightException( responseString );
	    }

	    return responseString;
	}
	
}