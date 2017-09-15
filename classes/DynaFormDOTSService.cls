@RestResource(urlMapping='/DynaFormDOTS')
global class DynaFormDOTSService
{
	public static final String CALLBACK_KEY = 'callback';
	public static final String DOTS_ENDPOINT = DynaformDOTSSettings__c.getInstance().Endpoint__c;
	public static final String DOTS_LICENSE = DynaformDOTSSettings__c.getInstance().License_Key__c;
	public static final String DOTS_TESTTYPE = DynaformDOTSSettings__c.getInstance().Test_Type__c;

	public static final String ELOQUA_COUNTRY_FIELD = 'Country';
	public static final Set<String> DOTS_VALIDATION_COUNTRIES = new Set<String>{ 'US', 'United States' };

	@HttpGet
	global static void getDOTSValidation()
	{
		String callbackName = RestContext.request.params.get( CALLBACK_KEY );
		Map<String, String> requestBodyMap = new Map<String, String>();
		String responseString = JSON.serialize( new Map<String, String>{ 'OverallQuality' => 'Review' } );

		if( RestContext.request.params.containsKey( ELOQUA_COUNTRY_FIELD )
			&& DOTS_VALIDATION_COUNTRIES.contains( RestContext.request.params.get( ELOQUA_COUNTRY_FIELD ) ) )
		{
			Map<String, Dynaform_DOTS_Fields__c> eloquaFieldToSetting = Dynaform_DOTS_Fields__c.getAll();
			for( String eloquaKey : eloquaFieldToSetting.keySet() )
			{
				if( RestContext.request.params.containsKey( eloquaKey ) )
				{
					String dotsKey = eloquaFieldToSetting.get( eloquaKey ).DOTS_Field__c;
					requestBodyMap.put( dotsKey, RestContext.request.params.get( eloquaKey ) );
				}
			}

			requestBodyMap.put('Name', RestContext.request.params.get('FirstName') + ' ' + RestContext.request.params.get('LastName'));
			requestBodyMap.put('TestType', DOTS_TESTTYPE);
			requestBodyMap.put('LicenseKey', DOTS_LICENSE);
			requestBodyMap.put('IP', RestContext.request.headers.get('X-Salesforce-SIP'));

			HttpRequest request = new HttpRequest();
			request.setEndpoint(DOTS_ENDPOINT);
			request.setHeader('Content-Type', 'application/JSON');
			request.setMethod('POST');
			String requestBodyString = JSON.serialize(requestBodyMap);
			request.setBody( requestBodyString );

			Http sender = new Http();
			HttpResponse response = sender.send(request);
			responseString = response.getBody();
		}

		RestContext.response.addHeader('Content-Type', 'application/JSON');
		RestContext.response.statusCode = 200;
		RestContext.response.responseBody = prepareResponse(responseString, callbackName);
	}

	private static Blob prepareResponse( String responseBody, String callbackName )
	{
		String response = responseBody;
		if( !String.isBlank( callbackName ) )
		{
			response = callbackName + '(' + responseBody + ')';
		}
		return Blob.valueOf( response );
	}
}