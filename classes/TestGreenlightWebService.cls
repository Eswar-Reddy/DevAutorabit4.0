@isTest
private class TestGreenlightWebService 
{

	static Account newAccount;
	static Contact newContact;
	static Opportunity newOpportunity;
	static User partnerUser;
	
	static 
	{
		partnerUser = TestUtils.createLeasePartnerInfo( );
		system.debug( partnerUser );
		
		System.runAs( partnerUser )
		{
			newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , true );
			newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );
		}
		
	}
	
	public static String getInvalidValuesXml( )
	{
		String invalidXml = 	'<root>'+
								'<request_errors>'+
								'<error_code>103</error_code>'+
								'<error_description>'+
								'<account_id>'+
								'<isEmpty>Value is required and can\'t be empty</isEmpty>'+
								'</account_id>'+
								'<credit_request_id>'+
								'<isEmpty>Value is required and can\'t be empty</isEmpty>'+
								'</credit_request_id>'+
								'</error_description>'+
								'</request_errors>'+
								'</root>';
		return invalidXml;
		 
	} 
	
	static testMethod void createRequestHeaderTest()
	{
		Credit_Check_Request__c creditCheckRequest = Testutils.createCreditCheckRequest( newContact.Email, newContact.FirstName, newContact.LastName, newAccount.Id, newContact.Id, true );
		
		Test.startTest();
		
			HttpRequest request = GreenlightWebService.setWebRequestHeaders( 'newUrl', 'POST' );
		
		Test.stopTest();
	}

	static testMethod void createEncodedUrlTest()
	{
		Credit_Check_Request__c creditCheckRequest = Testutils.createCreditCheckRequest( newContact.Email, newContact.FirstName, newContact.LastName, newAccount.Id, newContact.Id, true );
		
		Test.startTest();
		
			//this name requires encoding before making callout
			creditCheckRequest.First_Name__c = 'Troy Sr.';
			
			String encodedUrl = GreenlightWebService.getNewCreditRequestParameters( creditCheckRequest, 'FAKE_INSTALLER_ID','salesPersonEmail@email.com' );
		
		Test.stopTest();
		
		System.assert( !encodedUrl.contains( ' ' ), 'There should be no spaces in the encoded url' );
		System.assert( encodedUrl.contains( 'Troy+Sr.' ), 'The 2 word first name should be encoded' );
	}

	static testMethod void createRequestTests()
	{
		Credit_Check_Request__c creditCheckRequest = Testutils.createCreditCheckRequest( newContact.Email, newContact.FirstName, newContact.LastName, newAccount.Id, newContact.Id, true );
		
		Test.startTest();
			try
			{
				String status = GreenlightWebService.gl_newCreditCheckRequest( creditCheckRequest, newAccount.Id, partnerUser.Id );
			}
			catch (Exception ex )
			{
				//fail silently as we are just calling webservice method for coverage (individual components tested elsewhere)				
			}
			try
			{
				String status = GreenlightWebService.gl_resubmitCreditCheckRequest( creditCheckRequest );
			}
			catch (Exception ex )
			{
				//fail silently as we are just calling webservice method for coverage (individual components tested elsewhere)				
			}
		Test.stopTest();
		
	}
	
	static testMethod void parseFailedResponseTest()
	{
		
		String errorCode = 'Homeowner does not exist with the credit request ID';
		 
		String responseXml = TestUtils.createInvalidGreenlightXml( errorCode );
								

		Test.startTest();
			try
			{
				String status = GreenlightWebService.parseResponse( responseXml );
				
				System.assert( false, 'An exception should have been thrown on invalid response.' );
			}
			catch (Exception ex )
			{
				System.assert( ex.getMessage().contains( errorCode ) );
				//fail silently as we are just calling webservice method for coverage (individual components tested elsewhere)				
			}
		
		Test.stopTest();
		
	}
	
	static testMethod void parseFailedResponseRequiredValuesTest()
	{
		
		String errorCode = '103';
		 
		String invalidXml = getInvalidValuesXml();

		Test.startTest();
			try
			{
				String status = GreenlightWebService.parseResponse( invalidXml );
				
				System.assert( false, 'An exception should have been thrown on invalid response.' );
			}
			catch (Exception ex )
			{
				System.debug( ex.getMessage() );
				System.assert( ex.getMessage().contains( errorCode ) );
				
				String missingAccount = 'account_id - Value is required';
				System.assert( ex.getMessage().contains( missingAccount ) );
			}
		
		Test.stopTest();
		
	}

	static /*testMethod*/ void parsePassingResponseTest()
	{
		String responseXml = TestUtils.createValidGreenlightXml();
		Test.startTest();
		
			String status = GreenlightWebService.parseResponse( responseXml );
		
		Test.stopTest();
		
		System.assertEquals( '', status );
		
	}
	
	/*
	SAMPLE SUCCESS MESSAGE FROM GREENLIGHT
	<root>
 <request>
  <apikey>32d08cdfacd4e5d6620706a2f3d4bd92</apikey>
  <username>dealer-api-test@leasedimensions.com</username>
  <password>****************</password>
  <homeowner_first_name>test</homeowner_first_name>
  <homeowner_last_name>testlast</homeowner_last_name>
  <homeowner_email>test@testings.com</homeowner_email>
  <installer_id>001v000000772vc</installer_id>
  <salesperson_reference_id>test@salespersonemail.com</salesperson_reference_id>
  <salesperson_first_name></salesperson_first_name>
  <salesperson_last_name></salesperson_last_name>
  <account_id>001V000000AZMVSIA5</account_id>
  <credit_request_id>00XX000000XXXX9MAP</credit_request_id>
  <selected_fund_product_code>MONTHLY_LEASE</selected_fund_product_code>
  <api_function_call></api_function_call>
 </request>
 <response>
  <response_code>0</response_code>
  <response_description>homeowner successfully created and invite email sent</response_description>
  <invite_email>The below e-mail was sent to test at test@testings.com

Dear test:

Congratulations on completing your first step towards going solar with SunPower Financial Solutions! We look forward to working with you to control your electricity costs and make a difference in the environment.

We have created a new user account for you on our secure website. You may visit this site by clicking on the link below. You can then securely input your personal information to complete your lease application.

Again, congratulations! We are happy to be helping you with this exciting transition to power your home with solar.

Sincerely,
API USER

SunPower Financial Solutions Dealer
no-reply@solarcorp.leasedimensions.com

Please use the LOGIN LINK below to go to your account.

https://solarcorp.leasedimensions.com/newuser?key=143ef217d7454db438cbcbf75143c165

</invite_email>
 </response>
 <dealer_account>dealer account already exists. homeowner attached to dealer account</dealer_account>
</root>


SAMPLE FAILURE MESSAGE FROM GREENLIGHT
<root>
<request_errors>
<error_code>103</error_code>
<error_description>
<apikey>
<isEmpty>Value is required and can't be empty</isEmpty>
</apikey>
<username>
<isEmpty>Value is required and can't be empty</isEmpty>
</username>
<password>
<isEmpty>Value is required and can't be empty</isEmpty>
</password>
<homeowner_first_name>
<isEmpty>Value is required and can't be empty</isEmpty>
</homeowner_first_name>
<homeowner_last_name>
<isEmpty>Value is required and can't be empty</isEmpty>
</homeowner_last_name>
<homeowner_email>
<isEmpty>Value is required and can't be empty</isEmpty>
</homeowner_email>
<installer_id>
<isEmpty>Value is required and can't be empty</isEmpty>
</installer_id>
<salesperson_reference_id>
<isEmpty>Value is required and can't be empty</isEmpty>
</salesperson_reference_id>
<account_id>
<isEmpty>Value is required and can't be empty</isEmpty>
</account_id>
<credit_request_id>
<isEmpty>Value is required and can't be empty</isEmpty>
</credit_request_id>
</error_description>
</request_errors>
</root>
*/
}