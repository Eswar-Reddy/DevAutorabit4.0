@isTest
global class TestDynaFormVerificationControllerExt
{
	static final String BASE_HTML = '<html>' +
										'<head>' +
											'<script type="text/javascript" src="{0}"></script>' +
											'<script type="text/javascript">for( var i < 4 )</script>' +
										'</head>' +
										'<body>' +
											'<form {1}>' +
											'</form>' +
										'</body>' +
									'</html>';

	global class MockPositiveDynaformVerification implements HttpCalloutMock
	{
		public HTTPResponse respond( HTTPRequest request )
		{
			HttpResponse response = new HttpResponse();
			response.setHeader( 'Content-Type', 'text/html');
			response.setStatusCode( 200 );
			response.setBody( String.format( BASE_HTML, new List<String>{ DynaFormVerificationControllerExt.SCRIPT_PATH,
																			DynaFormVerificationControllerExt.FORM_ATTRIBUTE + '="001000123123123"' } ) );
			return response;
		}
	}

	global class MockMissingFormDynaformVerification implements HttpCalloutMock
	{
		public HTTPResponse respond( HTTPRequest request )
		{
			HttpResponse response = new HttpResponse();
			response.setHeader( 'Content-Type', 'text/html');
			response.setStatusCode( 200 );
			response.setBody( String.format( BASE_HTML, new List<String>{ DynaFormVerificationControllerExt.SCRIPT_PATH,
																			'fakeForm="001123123123123"' } ) );
			return response;
		}
	}

	global class MockInvalidIdDynaformVerification implements HttpCalloutMock
	{
		public HTTPResponse respond( HTTPRequest request )
		{
			HttpResponse response = new HttpResponse();
			response.setHeader( 'Content-Type', 'text/html');
			response.setStatusCode( 200 );
			response.setBody( String.format( BASE_HTML, new List<String>{ DynaFormVerificationControllerExt.SCRIPT_PATH,
																			DynaFormVerificationControllerExt.FORM_ATTRIBUTE + '="001"' } ) );
			return response;
		}
	}

	global class MockMissingJavascriptDynaformVerification implements HttpCalloutMock
	{
		public HTTPResponse respond( HTTPRequest request )
		{
			HttpResponse response = new HttpResponse();
			response.setHeader( 'Content-Type', 'text/html');
			response.setStatusCode( 200 );
			response.setBody( String.format( BASE_HTML, new List<String>{ 'http://code.jquery.com/jquery-latest.min.js',
																			'data-dyanform-id="001123123123123"' } ) );
			return response;
		}
	}

	static Dynaform__c testForm;
	static DynaFormVerificationControllerExt customController;

	static TestMethod void setup()
	{
    	testForm = new Dynaform__c( Name = 'A Form' );
    	testForm.Form_URL__c = 'http://www.fakesite.com';
    	insert testForm;

		ApexPages.StandardController standardCont = new ApexPages.StandardController( testForm );
    	customController = new DynaFormVerificationControllerExt( standardCont );
	}

    static testMethod void verifyJSIncludeTest()
    {
		setup();

		Test.startTest();

			Test.setMock( HttpCalloutMock.class, new MockPositiveDynaformVerification() );
			String htmlNode = customController.getPageContents();
			Boolean javascriptVerified = customController.confirmScriptTagPresent( htmlNode );

		Test.stopTest();

		System.assert( javascriptVerified, 'When the custom javascript is found, it should be considered verified' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.ERROR ), 'There should be no errors on the page' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.WARNING ), 'There should be no warnings on the page' );
		System.assert( pageMessagesHas( DynaFormVerificationControllerExt.SCRIPT_FOUND ), 'A confirm message should be shown' );
    }

	static testMethod void verifyJSIncludeTest_JSMissing()
	{
		setup();

		Test.startTest();

			Test.setMock( HttpCalloutMock.class, new MockMissingJavascriptDynaformVerification() );
			String htmlNode = customController.getPageContents();
			Boolean javascriptVerified = customController.confirmScriptTagPresent( htmlNode );

		Test.stopTest();

		System.assert( !javascriptVerified, 'When the custom javascript is not found, it should not be considered verified' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.CONFIRM ), 'There should be no confirms on the page' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.WARNING ), 'There should be no warnings on the page' );
		System.assert( pageMessagesHas( DynaFormVerificationControllerExt.SCRIPT_NOT_FOUND ), 'An error message should be shown' );
	}

	static testMethod void verifyFormIncludeTest()
	{
		setup();

		Test.startTest();

			Test.setMock( HttpCalloutMock.class, new MockPositiveDynaformVerification() );
			String htmlNode = customController.getPageContents();
			Boolean formVerified = customController.confirmFormPresent( htmlNode );

		Test.stopTest();

		System.assert( formVerified, 'When a form with a valid id is found, it should be considered verified' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.ERROR ), 'There should be no errors on the page' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.WARNING ), 'There should be no warnings on the page' );
		System.assert( pageMessagesHas( DynaFormVerificationControllerExt.FORM_FOUND ), 'A confirm message should be shown when a form has a proper attribute and value' );
	}

	static testMethod void verifyFormMissingForm()
	{
		setup();

		Test.startTest();

			Test.setMock( HttpCalloutMock.class, new MockMissingFormDynaformVerification() );
			String htmlNode = customController.getPageContents();
			Boolean formVerified = customController.confirmFormPresent( htmlNode );

		Test.stopTest();

		System.assert( !formVerified, 'When the landing page is missing a form tag, it should not be considered verified' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.CONFIRM ), 'There should be no confirms on the page' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.WARNING ), 'There should be no warnings on the page' );
		System.assert( pageMessagesHas( DynaFormVerificationControllerExt.FORM_NOT_FOUND ), 'An error message should be shown when the form tag is missing' );
	}

	static testMethod void verifyFormInvalidId()
	{
		setup();

		Test.startTest();

			Test.setMock( HttpCalloutMock.class, new MockInvalidIdDynaformVerification() );
			String htmlNode = customController.getPageContents();
			Boolean formVerified = customController.confirmFormPresent( htmlNode );

		Test.stopTest();

		System.assert( formVerified, 'When the form is missing a valid Id, the page should be verified, but there will be a message regarding the id' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.WARNING ), 'There should be no warnings on the page' );
		System.assert( pageMessagesHas( DynaFormVerificationControllerExt.FORM_FOUND ), 'A confirm message should be shown when a form tag exists' );
		System.assert( pageMessagesHas( DynaFormVerificationControllerExt.FORM_ID_INCORRECT ), 'An error message should be shown when a form has an invalid salesforce id' );
	}

	static testMethod void verifyFormURL()
	{
		setup();

		Test.startTest();

			Test.setMock( HttpCalloutMock.class, new MockPositiveDynaformVerification() );
			customController.verifyFormURL();

		Test.stopTest();

		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.ERROR ), 'There should be no errors on the page' );
		System.assertEquals( false, ApexPages.hasMessages( ApexPages.Severity.WARNING ), 'There should be no warnings on the page' );
		System.assert( pageMessagesHas( DynaFormVerificationControllerExt.SCRIPT_FOUND ), 'A confirm message should be shown' );
		System.assert( pageMessagesHas( DynaFormVerificationControllerExt.FORM_FOUND ), 'A confirm message should be shown when a form has a proper attribute and value' );

		Dynaform__c updatedDynaform = [ SELECT Id, Verified__c FROM Dynaform__c ];
		System.assert( updatedDynaform.Verified__c, 'When both the Script and a Form are found on the Landing page, the Dyanform should be marked as verified' );
	}

    static Boolean pageMessagesHas( String message )
    {
    	Boolean messageFound = false;
    	for( ApexPages.Message aMessage : ApexPages.getMessages() )
    	{
    		messageFound = messageFound || aMessage.getSummary() == message;
    	}
    	return messageFound;
    }
}