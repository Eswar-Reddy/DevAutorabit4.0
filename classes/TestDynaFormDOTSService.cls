@isTest
private class TestDynaFormDOTSService
{
	public static final String RESPONSE_CONTENT = '{ "someJSON" : "someValue" }';

	static void setup()
	{
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
	}

	public class MockDOTSCallout implements HttpCalloutMock
	{
		public HttpResponse respond( HttpRequest request )
		{
			HttpResponse response = new HttpResponse();
			response.setBody( RESPONSE_CONTENT );
			return response;
		}
	}

	static testMethod void testGetDOTSValidation()
	{
		final String CALLBACK_NAME = 'somecalloutString';

		setup();

		DynaformDOTSSettings__c newSettings = new DynaformDOTSSettings__c();
		newSettings.Endpoint__c = 'www.someendpoint.com';
		newSettings.License_Key__c = 'some-license';
		newSettings.Test_Type__c = 'SomeTest';
		System.runAs( TestUtils.ADMIN_USER )
		{
			insert newSettings;
		}

		RestContext.request.params.put( DynaFormDOTSService.CALLBACK_KEY, CALLBACK_NAME );
		RestContext.request.params.put( DynaFormDOTSService.ELOQUA_COUNTRY_FIELD, 'US' );

		Test.startTest();

			Test.setMock( HttpCalloutMock.class, new MockDOTSCallout() );
			DynaFormDOTSService.getDOTSValidation();

		Test.stopTest();

		System.assertEquals( 200, RestContext.response.statusCode, 'The code should be a success code' );
		String requestBody = RestContext.response.responseBody.toString();
		System.assert( requestBody.startsWith( CALLBACK_NAME ), 'The callout response should be wrapped with the specified callout: ' + requestBody );

		Matcher bodyMatcher = Pattern.compile('\\((.+)\\)').matcher(requestBody);
		bodyMatcher.find();
		System.assertEquals( RESPONSE_CONTENT, bodyMatcher.group(1), 'The response should be contained within the callback' );
	}
}