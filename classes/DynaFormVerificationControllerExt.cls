public with sharing class DynaFormVerificationControllerExt
{
	public static final String SCRIPT_NOT_FOUND = 'The Dynaform script was not found on the page.';
	public static final String SCRIPT_FOUND = 'The Dynaform script is properly configured on the page.';
	public static final String SCRIPT_PATH = '/DynaForm/resource/DynaformJS';

	public static final String FORM_FOUND = 'There is a form properly configured with Dynaform functionality.';
	public static final String FORM_NOT_FOUND = 'There is no configured form present.';
	public static final String FORM_ID_INCORRECT = 'The configured form does not have a valid Salesforce Id.';
	public static final String FORM_ATTRIBUTE = 'data-dynaform-id';

	public Dynaform__c theForm { get; set; }

	public DynaFormVerificationControllerExt(ApexPages.StandardController sc)
	{
		this.theForm = (Dynaform__c)sc.getRecord();
	}

	/**
	*	@returns None - adds ApexPages.Messages to the page depending on what verifications will pass or fail
	*
	*	This method will run through the entire suite of tests to determine if there are
	*	elements necessary for Dynaform functionality missing
	*/
	public void verifyFormURL()
	{
		try
		{
			String htmlString = this.getPageContents();
			Boolean scriptFound = this.confirmScriptTagPresent( htmlString );
			Boolean formFound = this.confirmFormPresent( htmlString );
			this.theForm.Verified__c = scriptFound && formFound;
			update this.theForm;
		}
		catch( System.Exception ex )
		{
			ApexPages.addMessages(ex);
		}
	}

	/**
	*	@throws System.Calloutexception - source: sender.send - Thrown when callout fails (timeout or invalid endpoint)
	*	@throws System.Xmlexception - source: pageBody.load - Thrown when response returns invalid XML markup
	*
	*	@returns String - String that represents the HTML tag of the page markup
	*/
	public String getPageContents()
	{
		HttpRequest request = new HttpRequest();
		request.setEndpoint( this.theForm.Form_URL__c );
		request.setMethod( 'GET' );

		Http sender = new Http();
		HttpResponse response = sender.send( request );

		return response.getBody();
	}

	/**
	*	@param String - string that represents the HTML to parse for any matching javascript
	*	@return Boolean - whether the script was found. ApexPages.Messages will be added to the page depending on the result
	*
	*	looks through the HTML to determine whether there is a SCRIPT tag whose
	*	SRC attribute is the Dynaform Static Resource
	*/
	public Boolean confirmScriptTagPresent( String htmlString )
	{
		Boolean scriptFound = false;
		Pattern scriptPattern = Pattern.compile( '(?s)<script[^>]*>((?!</script>).)*</script>' );
		Matcher scriptMatcher = scriptPattern.matcher( htmlString );
		while( scriptMatcher.find() && !scriptFound )
		{
			String scriptTag = scriptMatcher.group();
			scriptFound = scriptFound || Pattern.compile( '(?i)src=[\'"]\\S*' + SCRIPT_PATH + '[\'"]' ).matcher( scriptTag ).find();
		}
		if( !scriptFound )
		{
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, SCRIPT_NOT_FOUND ) );
		}
		else
		{
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, SCRIPT_FOUND ) );
		}
		return scriptFound;
	}

	/**
	*	@param String - string that represents the HTML to scrape for any matching forms
	*	@return Boolean - whether the form was found. ApexPages.Messages will be added to the page depending on the result
	*
	*	looks through the HTML to determine whether there is a FORM tag whose
	*	DATA-DYNAFORM-ID attribute is present and a valid SFDC Id
	*/
	public Boolean confirmFormPresent( String htmlString )
	{
		Boolean formFound = false;
		Pattern formPattern = Pattern.compile( '(?s)<form[^>]*>((?!</form>).)*</form>' );
		Matcher formMatcher = formPattern.matcher( htmlString );
		while( formMatcher.find() && !formFound )
		{
			String formTag = formMatcher.group();
			Matcher formTagMatcher = Pattern.compile( '(?i)<form.*' + FORM_ATTRIBUTE + '=[\'"]([^\'"]+)[\'"].*>' ).matcher( formTag );
			formFound = formTagMatcher.find();
			if( formFound && !(formTagMatcher.group(1) instanceof Id) )
			{
				ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, FORM_ID_INCORRECT ) );
			}
		}
		if( !formFound )
		{
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, FORM_NOT_FOUND ) );
		}
		else
		{
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, FORM_FOUND ) );
		}
		return formFound;
	}
}