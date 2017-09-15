@isTest
private class TestDynaFormWebService
{
	static void setup()
	{
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
	}

	static testMethod void testGetQualification_NoFormId()
	{
		setup();

		Test.startTest();

			DynaFormWebService.getQualification();

		Test.stopTest();

		String response = RestContext.response.responseBody.toString();
		DynaFormWebService.Error deserializeError = (DynaFormWebService.Error)JSON.deserialize( response, DynaFormWebService.Error.class );
		System.assertEquals( DynaFormWebService.ERROR_TYPE.MISSING_FORM_ID.ordinal(), deserializeError.code, 'The code should be for a missing form Id' );
	}

	static testMethod void testGetQualification_InvalidFormId()
	{
		setup();
		RestContext.request.params.put( DynaFormWebService.FORM_KEY, '123' );

		Test.startTest();

			DynaFormWebService.getQualification();

		Test.stopTest();

		String response = RestContext.response.responseBody.toString();
		DynaFormWebService.Error deserializeError = (DynaFormWebService.Error)JSON.deserialize( response, DynaFormWebService.Error.class );
		System.assertEquals( DynaFormWebService.ERROR_TYPE.INVALID_FORM_ID.ordinal(), deserializeError.code, 'The code should be for an invalid form Id' );
	}

	static testMethod void testGetQualification_ValidFormId()
	{
		setup();
		RestContext.request.params.put( DynaFormWebService.FORM_KEY, UserInfo.getUserId() );

		Test.startTest();

			DynaFormWebService.getQualification();

		Test.stopTest();

		System.assertEquals( 200, RestContext.response.statusCode, 'The code should be a success code' );
	}

	static testMethod void testGetQualification()
	{
		setup();

		Qualification__c USQualification = new Qualification__c(Name='US',Rule_Advance_Logic__c='1 and 2');
		insert USQualification;

		Qualification_Rule__c qr = new Qualification_Rule__c();
		qr.Qualification__c = USQualification.Id;
		qr.Field_API_Name__c = 'Roof_Orientation__c';
		qr.Accepted_Values__c = 'East|West|North|South';
		qr.Field_Type__c = QualificationServices.TEXT_RULE_TYPE;
		qr.Eloqua_Field_Name__c = 'roofOrientation';
		
		
		insert qr;

		Dynaform__c form = new Dynaform__c(Name='Basic test landing page');
		form.Qualification__c = USQualification.Id;
		insert form;

		RestContext.request.params.put( DynaFormWebService.FORM_KEY, form.Id );

		Test.startTest();

			DynaFormWebService.getQualification();

		Test.stopTest();

		System.assertEquals( 200, RestContext.response.statusCode, 'The code should be a success code' );

		String response = RestContext.response.responseBody.toString();
		DynaFormWebService.Qualification returnedQualification =
			 (DynaFormWebService.Qualification)JSON.deserialize( response, DynaFormWebService.Qualification.class );

		System.assertEquals( 1, returnedQualification.fields.size(), 'The returned qualification should have one field');

		DynaFormWebService.QualificationField field = returnedQualification.fields[0];
		System.assertEquals( qr.Eloqua_Field_Name__c, field.Name, 'The field name should match the Qualification Rule field name');
		System.assertEquals( 4, field.acceptedValues.size(), 'The Qualification Rule should have all accepted values');
		Set<String> returnedAcceptedValues = new Set<String>(field.acceptedValues);
		for( String anAcceptedValue : qr.Accepted_Values__c.split(DynaFormWebService.DELIMITER) )
		{
			System.assert( returnedAcceptedValues.contains( anAcceptedValue ), 'Every accepted value should be found' );
		}
	}

	static testMethod void testGetQualification_RuleWithBoolean()
	{
		setup();

		Qualification__c aQualification = new Qualification__c( Name = 'A Qual',Rule_Advance_Logic__c='1 and 2' );
		insert aQualification;

		Qualification_Rule__c aRule = new Qualification_Rule__c();
		aRule.Qualification__c = aQualification.Id;
		aRule.Field_API_Name__c = 'DoNotCall';
		aRule.Accepted_Values__c = 'False';
		aRule.Field_Type__c = QualificationServices.BOOLEAN_RULE_TYPE;
		insert aRule;

		Dynaform__c aForm = new Dynaform__c( Name = 'A Form' );
		aForm.Qualification__c = aQualification.Id;
		insert aForm;

		RestContext.request.params.put( DynaFormWebService.FORM_KEY, aForm.Id );

		Test.startTest();

			DynaFormWebService.getQualification();

		Test.stopTest();

		System.assertEquals( 200, RestContext.response.statusCode, 'The request should have been successful' );
		String response = RestContext.response.responseBody.toString();
		DynaFormWebService.Qualification returnedQualification = (DynaFormWebService.Qualification)JSON.deserialize( response, DynaFormWebService.Qualification.class );

		System.assertEquals( 1, returnedQualification.fields.size(), 'There should be only one field rule for the Qualification' );
		System.assertEquals( 1, returnedQualification.fields[0].acceptedValues.size(), 'There should only be one accepted value for the field' );
		System.assertEquals( aRule.Accepted_Values__c, returnedQualification.fields[0].acceptedValues[0], 'The accepted value should be the value specified in the rule' );
	}


	static testMethod void testGetQualification_WithCallback()
	{
		final String CALLBACK_NAME = 'someCallback';
		setup();

		Qualification__c aQualification = new Qualification__c( Name = 'A Qual' ,Rule_Advance_Logic__c='1 and 2');
		insert aQualification;

		Dynaform__c aForm = new Dynaform__c( Name = 'A Form' );
		aForm.Qualification__c = aQualification.Id;
		insert aForm;

		RestContext.request.params.put( DynaFormWebService.FORM_KEY, aForm.Id );
		RestContext.request.params.put( DynaFormWebService.CALLBACK_KEY, CALLBACK_NAME );

		Test.startTest();

			DynaFormWebService.getQualification();

		Test.stopTest();

		System.assertEquals( 200, RestContext.response.statusCode, 'The call should have been successful' );
		String wrappedResponse = RestContext.response.responseBody.toString();
		Matcher theMatcher = Pattern.compile(CALLBACK_NAME+'\\((.*)\\)').matcher( wrappedResponse );
		System.assert( theMatcher.matches(), 'The callback should be found in the response' );
		String qualificationResponse = theMatcher.group(1);
		DynaFormWebService.Qualification returnedQualification = (DynaFormWebService.Qualification)JSON.deserialize( qualificationResponse, DynaFormWebService.Qualification.class );
		System.assertEquals( 0, returnedQualification.fields.size(), 'The response should not have returned any valid rules when none are specified' );
	}
    
    static testMethod void testGetQualification_DealersFound_OptedIn(){
        
        setup();
        
        Account a = new Account();
        a.Name                                      = 'Really Bright Solar';
        a.Type                                      = 'Premier-Partner-Residential'; //PartnerRecordTypeAccount .Id;
        a.Dealer_Score_Total__c                 = 78;
        a.Dealer_Locator_Phone__c           = '888-888-8888';
        a.Phone                                     = '888-888-8888';
        a.BillingStreet                             = '150 Corona St';
        a.BillingCity                               = 'Denver';
        a.BillingState                              = 'CO';
        a.BillingCountry                            = 'USA';
        a.BillingPostalCode                         = '80218';
        a.website                                   = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c      = '123';
        a.Description                               = 'None';
        a.Partner_Facts__c                      = 'None';
        a.Status__c                                 = 'Active';
        a.Dealer_Locator_Opt_Out__c         = false;
        a.Lead_Flow_Opt_Out__c              = false;
        a.Alliance_Program_Partner__c       = true;
        insert a;
        
        //2. Insert CoverageArea__c
        CoverageArea__c ca = new CoverageArea__c();
        ca.Account__c                       = a.id;
        ca.Geolocation__Latitude__s     = 39.718887;
        ca.Geolocation__Longitude__s    = -104.974036;
        ca.Radius__c                            = 1000;
        insert ca;
        
        Business_Registration__c br = new Business_Registration__c();
        br.Name                 = a.billingstate;
        br.Account__c       = a.id;
        //br.Expires_On__c  = a.Contractors_Lic_Expiry__c;
        br.License_Number__c = '000000';
        br.Country__c           = a.billingCountry;
        br.State__c             = a.billingstate;
        insert br;
        
        Qualification__c USQualification = new Qualification__c(Name='US',Rule_Advance_Logic__c='1 and 2');
        insert USQualification;
        
        Qualification_Rule__c qr = new Qualification_Rule__c();
        qr.Qualification__c = USQualification.Id;
        qr.Field_API_Name__c = 'Roof_Orientation__c';
        qr.Accepted_Values__c = 'East|West|North|South';
        qr.Field_Type__c = QualificationServices.TEXT_RULE_TYPE;
        qr.Eloqua_Field_Name__c = 'roofOrientation';
        
        
        insert qr;
        
        Dynaform__c form = new Dynaform__c(Name='Basic test landing page');
        form.Qualification__c = USQualification.Id;
        insert form;
        
        RestContext.request.params.put( DynaFormWebService.FORM_KEY, form.Id );
        RestContext.request.params.put( DynaFormWebService.STREET_KEY, a.BillingStreet );
        RestContext.request.params.put( DynaFormWebService.CITY_KEY, a.BillingCity );
        RestContext.request.params.put( DynaFormWebService.STATE_KEY, a.BillingState );
        RestContext.request.params.put( DynaFormWebService.ZIP_KEY, a.BillingPostalCode );
        RestContext.request.params.put( DynaFormWebService.COUNTRY_KEY, a.BillingCountry );
        
        Test.startTest();
        DynaFormWebService.getQualification();
        Test.stopTest();
    }
    
    static testMethod void testGetQualification_DealersFound_OptedOut(){
        
        setup();
        
        Account a = new Account();
        a.Name                                      = 'Really Bright Solar';
        a.Type                                      = 'Premier-Partner-Residential'; //PartnerRecordTypeAccount .Id;
        a.Dealer_Score_Total__c                 = 78;
        a.Dealer_Locator_Phone__c           = '888-888-8888';
        a.Phone                                     = '888-888-8888';
        a.BillingStreet                             = '150 Corona St';
        a.BillingCity                               = 'Denver';
        a.BillingState                              = 'CO';
        a.BillingCountry                            = 'USA';
        a.BillingPostalCode                         = '80218';
        a.website                                   = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c      = '123';
        a.Description                               = 'None';
        a.Partner_Facts__c                      = 'None';
        a.Status__c                                 = 'Active';
        a.Dealer_Locator_Opt_Out__c         = false;
        a.Lead_Flow_Opt_Out__c              = true;
        a.Alliance_Program_Partner__c       = true;
        insert a;
        
        //2. Insert CoverageArea__c
        CoverageArea__c ca = new CoverageArea__c();
        ca.Account__c                       = a.id;
        ca.Geolocation__Latitude__s     = 39.718887;
        ca.Geolocation__Longitude__s    = -104.974036;
        ca.Radius__c                            = 1000;
        insert ca;
        
        Business_Registration__c br = new Business_Registration__c();
        br.Name                 = a.billingstate;
        br.Account__c       = a.id;
        //br.Expires_On__c  = a.Contractors_Lic_Expiry__c;
        br.License_Number__c = '000000';
        br.Country__c           = a.billingCountry;
        br.State__c             = a.billingstate;
        insert br;
        
        Qualification__c USQualification = new Qualification__c(Name='US',Rule_Advance_Logic__c='1 and 2');
        insert USQualification;
        
        Qualification_Rule__c qr = new Qualification_Rule__c();
        qr.Qualification__c = USQualification.Id;
        qr.Field_API_Name__c = 'Roof_Orientation__c';
        qr.Accepted_Values__c = 'East|West|North|South';
        qr.Field_Type__c = QualificationServices.TEXT_RULE_TYPE;
        qr.Eloqua_Field_Name__c = 'roofOrientation';
        
        
        insert qr;
        
        Dynaform__c form = new Dynaform__c(Name='Basic test landing page');
        form.Qualification__c = USQualification.Id;
        insert form;
        
        RestContext.request.params.put( DynaFormWebService.FORM_KEY, form.Id );
        RestContext.request.params.put( DynaFormWebService.STREET_KEY, a.BillingStreet );
        RestContext.request.params.put( DynaFormWebService.CITY_KEY, a.BillingCity );
        RestContext.request.params.put( DynaFormWebService.STATE_KEY, a.BillingState );
        RestContext.request.params.put( DynaFormWebService.ZIP_KEY, a.BillingPostalCode );
        RestContext.request.params.put( DynaFormWebService.COUNTRY_KEY, a.BillingCountry );
        
        Test.startTest();
        DynaFormWebService.getQualification();
        Test.stopTest();
    }
}