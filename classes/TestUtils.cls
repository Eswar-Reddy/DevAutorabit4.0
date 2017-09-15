@isTest
public class TestUtils {
    public static final Decimal ORACLE_VENDOR_ID = 123098123;
    public static final Decimal ORACLE_VENDOR_SITE_ID = 123098123;
    public static String CPR_SALESPERSON_ID = 'xxxxxx9999';
    public static final String TEST_PARTNER_PROFILE = 'Partner Executive';
    public static final String TEST_INTERNAL_PROFILE = 'SunPower Lease Payment Access'; //MAM 10/07/2014 - Renamed 'SunPower Lease Payment User - Advance' to 'SunPower Lease Payment Access'
    public static final String LIEN_WAIVER_RECORDTYPE_NAME = 'Lien_Waiver';
    public static final String SYSTEM_ADMIN_PROFILE = 'System Administrator';
    public static final String AGREEMENT_RECORD_TYPE_NAME = 'Lease_Contract';

    public static RecordType leaseContactRecordType {
        get {
            if(leaseContactRecordType == null) {
                leaseContactRecordType = [
                    SELECT Id
                    FROM RecordType
                    WHERE SobjectType = 'echosign_dev1__SIGN_Agreement__c'
                        AND DeveloperName = :AGREEMENT_RECORD_TYPE_NAME
                        AND IsActive = true
                ];
            }
            return leaseContactRecordType;
        }
        private set;
    }

    public static String LIEN_WAIVER_ID {
        get{
            if(LIEN_WAIVER_ID == null) {
                LIEN_WAIVER_ID = [ SELECT Id FROM RecordType WHERE DeveloperName = :LIEN_WAIVER_RECORDTYPE_NAME AND IsActive = true AND SObjectType = 'echosign_dev1__SIGN_Agreement__c'][0].Id;
            }
            return LIEN_WAIVER_ID;
        }
        private set;
    }
    public static User ADMIN_USER {
        get{
            if(ADMIN_USER == null) {
                ADMIN_USER = [ SELECT Id FROM User WHERE Profile.Name = :SYSTEM_ADMIN_PROFILE AND IsActive = TRUE LIMIT 1 ];
            }
            return ADMIN_USER;
        }
        private set;
    }

    public static void createLeaseCreationCustomSetting() {
        Lease_2_1_PO_Creation__c newCustomSetting = new Lease_2_1_PO_Creation__c();
        newCustomSetting.Lien_Waiver_Id__c = LIEN_WAIVER_ID;
        newCustomSetting.Name = 'Counter Signature Info';

        System.runAs(TestUtils.ADMIN_USER) {
            insert newCustomSetting;
        }
    }

    public static ReferralManagementEndpoint__c createReferralManagementCustomSetting(Boolean doInsert) {
        return (ReferralManagementEndpoint__c)adminIffyInsert(new ReferralManagementEndpoint__c
            ( Add_Friend__c = '/add_friend'
            , Update_Stage__c = '/update_stage'
            , Get_Users__c = '/get_users'
            , Site_Id__c = 'site_id'
            , Login_Token__c = 'login_token'
            ), doInsert);
    }

    public static void createReferralManagementOpportunityStages(List<String> stages) {
        List<Referral_Management_Opportunity_Stages__c> customSettings = new List<Referral_Management_Opportunity_Stages__c>();

        for(String stage : stages) {
            Referral_Management_Opportunity_Stages__c customSetting = new Referral_Management_Opportunity_Stages__c();
            customSetting.Name = stage;
            customSettings.add(customSetting);
        }

        System.runAs(TestUtils.ADMIN_USER) {
            insert customSettings;
        }
    }

    public static void createReferrralManagementLeadStatus(Set<String> statuses) {
        List<Referral_Management_Lead_Status__c> customSettings = new List<Referral_Management_Lead_Status__c>();

        for(String status : statuses) {
            customSettings.add(new Referral_Management_Lead_Status__c
                ( Name = status
                ));
        }

        System.runAs(TestUtils.ADMIN_USER) {
            insert customSettings;
        }
    }

    public static User createLeasePartnerInfo( ) {

        UserManagement.IS_TEST = true;
        
        //MAM 19.MAY.2015 Updates to the Names for createContact and createAccount start
        //Account partnerAccount = TestUtils.createAccount('TEST_BOOYAH', TestUtils.getPartnerRecordTypeId(), false); 
        Account partnerAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', TestUtils.getPartnerRecordTypeId(), false);
        
        //make lease enabled partner
        partnerAccount.Lease2_0_Program_Partner__c = true;
        partnerAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Warehouse__c  = 'WAR'+String.ValueOf(DateTime.Now().getTime()).substring(0, 5);
        insert partnerAccount;

        //Contact partnerContact = TestUtils.createContact( 'TEST_HEYAHH', partnerAccount.Id, true );
        Contact partnerContact = TestUtils.createContact( 'CPR TEST CONTACT 1', partnerAccount.Id, true );
        //set to partner recordtype
        partnerContact.RecordTypeID = util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
        update partnerContact;
        //MAM 19.MAY.2015 end
        
        User partnerUser;
        //create partner user
        partnerUser = TestUtils.createPartnerPortalUser( partnerContact, false );
        partnerUser.CPR_Salesperson_ID__c = CPR_SALESPERSON_ID;

        return partnerUser;

    }
    

    public static List<Lead> createLeads( Integer numLeads, Boolean doInsert )
    {
        List<Lead> testLeads = new List<Lead>();
        for( Integer index = 0; index < numLeads; index++ )
        {
            Lead newLead = new Lead();
            newLead.LastName = 'Test Lead' + index;
            newLead.Company = 'Test Company' + index;
            newLead.LeadSource = 'Somewhere';
            newLead.Email = 'testLead' + index + '@test.com.test';
            testLeads.add( newLead );
        }
        if( doInsert )
        {
            insert testLeads;
        }
        return testLeads;
    }

    public static List<Attachment> createAttachments(Integer size, String partialName, Boolean willInsert)
    {
        String ATT_BODY = 'This is a test body.';
        List<Attachment> toReturn = new List<Attachment>();

        for(Integer i = 0; i < size; i++)
        {
            Attachment att = new Attachment();
            Blob body = Blob.valueOf(ATT_BODY);
            att.Name = partialName + i + '.PDF';
            att.Body = body;

            toReturn.add(att);
        }

        if(willInsert)
        {
            insert toReturn;
        }

        return toReturn;
    }

    public static List<Invoice_Documents__c> createInvoiceDocuments(Integer size, Id leasePaymentId, String invoiceType, Boolean willInsert)
    {
        List<Invoice_Documents__c> toReturn = new List<Invoice_Documents__c>();

        for(Integer i = 0; i < size; i++)
        {
            Invoice_Documents__c invoiceDoc = new Invoice_Documents__c();
            invoiceDoc.Lease_Payment__c = leasePaymentId;
            invoiceDoc.Invoice_Type__c = invoiceType;
            invoiceDoc.Notes_to_Dealer__c = 'Test Note to dealer';

            toReturn.add(invoiceDoc);
        }

        if(willInsert)
        {
            insert toReturn;
        }

        return toReturn;
    }

    public static List<Origination_Document__c> createOriginationDocuments(Integer size, Id accountId, Boolean willInsert)
    {
        List<Origination_Document__c> toReturn = new List<Origination_Document__c>();

        for(Integer i = 0; i < size; i++)
        {
            Origination_Document__c originationDoc = new Origination_Document__c();
            originationDoc.Account__c = accountId;
            originationDoc.Invoice_Type__c = InvoiceDocumentServices.ORIGINATION_TYPE;

            toReturn.add(originationDoc);
        }

        if(willInsert)
        {
            insert toReturn;
        }

        return toReturn;
    }

    public static Credit_Check_Request__c createCreditCheckRequest( String email, String firstName, String lastName, Id accountId, Id contactId, Boolean willInsert ){

        Credit_Check_Request__c creditCheckRequest = new Credit_Check_Request__c();
        creditCheckRequest.Email__c = email;
        creditCheckRequest.First_Name__c = firstName;
        creditCheckRequest.Last_Name__c = lastName;
        creditCheckRequest.Contact__c = contactId;
        creditCheckRequest.Account__c = accountId;
        creditCheckRequest.Successful_Invite__c = false;

        if ( willInsert )
            insert creditCheckRequest;

        return creditCheckRequest;
    }

    public static List<Lease_Schedule__c> createLeaseSchedules( Id quoteId, Boolean willInsert ) {
        Integer numOfSchedules = 20;

        List<Lease_Schedule__c> leaseSchedules = new List<Lease_Schedule__c>();

        for ( Integer i=0; i < numOfSchedules; i++ ) {

            Lease_Schedule__c leaseSchedule = createLeaseSchedule( quoteId, 10000+i, String.valueOf(System.today().addYears( i ).year()), false );

            leaseSchedules.add( leaseSchedule );
        }

        if ( willInsert )
            insert leaseSchedules;

        return leaseSchedules;

    }

    public static Lease_Schedule__c createLeaseSchedule( Id quoteId, Decimal paymentAmount, String year, Boolean willInsert ) {

        Lease_Schedule__c leaseSchedule = new Lease_Schedule__c( Quote__c = quoteId );
        leaseSchedule.Annual_Lease_Payment__c = paymentAmount;
        leaseSchedule.Annual_Lease_Payments_Year__c = year;

        if ( willInsert )
            insert leaseSchedule;

        return leaseSchedule;

    }

    public static Lease_Schedule_Summary__c createLeaseScheduleSummary( Id quoteId, Id leasePaymentId, Boolean willInsert ) {

        Lease_Schedule_Summary__c leaseScheduleSummary = new Lease_Schedule_Summary__c( );
        leaseScheduleSummary.Quote__c = quoteId;
        leaseScheduleSummary.Lease_Payment__c = leasePaymentId;

        if ( willInsert ){

            insert leaseScheduleSummary;

        }

        return leaseScheduleSummary;

    }



    public static List<Quote> createQuotes( Integer numOfQuotes, String name, Id opportunityId, Boolean willInsert ) {

        List<Quote> testQuotes = new List<Quote>();

        for ( Integer i = 0; i < numOfQuotes; i++ ){

            Quote newQuote = new Quote();
            newQuote.Name = name;
            newQuote.OpportunityId = opportunityId;
            testQuotes.add( newQuote );

        }

        if ( willInsert )
            insert testQuotes;

        return testQuotes;

    }
    public static List<Quote_Summary__c> createQuoteSummaries( Integer numOfQuoteSums, String name, Id opportunityId, Id accountId, Boolean willInsert ) {

        List<Quote_Summary__c> testQuoteSums = new List<Quote_Summary__c>();

        for ( Integer i = 0; i < numOfQuoteSums; i++ ){

            Quote_Summary__c newQuote = new Quote_Summary__c();
            newQuote.Description__c = name;
            newQuote.Opportunity__c = opportunityId;
            newQuote.Account_Name__c = accountId;
            testQuoteSums.add( newQuote );

        }

        if ( willInsert )
            insert testQuoteSums;

        return testQuoteSums;

    }

    public static String createValidGreenlightXml( )
    {
        String validXml =   '<?xml version="1.0" encoding="UTF-8"?>'+
                                '<root>'+
                                '<request>'+
                                '<getdata>Resend Homeowner Invite</getdata>'+
                                '<apikey>32d08cdfacd4e5d6620706a2f3d4bd92</apikey>'+
                                '<username>dealer-api-test@leasedimensions.com</username>'+
                                '<password>****************</password>'+
                                '<homeowner_email>homeowner@leasedimensions.com</homeowner_email>'+
                                '<credit_request_id>123456789</credit_request_id>'+
                                '<api_function_call>Resend Homeowner Invite</api_function_call>'+
                                '</request>'+
                                '<response>'+
                                    '<response_code>0</response_code>'+
                                    '<response_description>homeowner successfully created and invite email sent</response_description>'+
                                '</response>'+
                                '</root>';
        return validXml;
    }
    public static String createInvalidGreenlightXml( String errorCode )
    {
        String invalidXml =     '<?xml version="1.0" encoding="UTF-8"?>'+
                                '<root>'+
                                '<request>'+
                                '<getdata>Resend Homeowner Invite</getdata>'+
                                '<apikey>32d08cdfacd4e5d6620706a2f3d4bd92</apikey>'+
                                '<username>dealer-api-test@leasedimensions.com</username>'+
                                '<password>****************</password>'+
                                '<homeowner_email>homeowner@leasedimensions.com</homeowner_email>'+
                                '<credit_request_id>123456789</credit_request_id>'+
                                '<api_function_call>Resend Homeowner Invite</api_function_call>'+
                                '</request>'+
                                '<request_errors>'+
                                '<error_code>502</error_code>'+
                                '<error_description>' + errorCode + '</error_description>'+
                                '</request_errors>'+
                                '</root>';
        return invalidXml;

    }

    public static Account createAccount( String name, Id recordTypeId, Boolean willInsert ){

        Account acct = new Account( Name = name, recordTypeID = recordTypeID );
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Durgapura';
        acct.ShippingCountry = 'USA';
        acct.ShippingState='TN';
        acct.ShippingPostalCode ='302018';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Durgapura';
        acct.BillingCountry = 'India';
        acct.BillingState='TN';
        acct.BillingPostalCode ='302018';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'BWGUY'+String.ValueOf(DateTime.Now().getTime())+Math.random();
        acct.Phone = (String.ValueOf(DateTime.Now().getTime())).substring(0, 10);

        if ( willInsert )
            insert acct;

        return acct;
    }

    public static List<Account> createAccounts( Integer numAccounts, Boolean willInsert) {
        String baseName = 'TestAccount';
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            accounts.add(createAccount('baseName' + i, false));
        }

        if(willInsert) {
            insert accounts;
        }

        return accounts;
    }

    public static List<echosign_dev1__SIGN_Agreement__c> createAgreements( Set<Id> accountIds, Boolean willInsert) {
        List<echosign_dev1__SIGN_Agreement__c> agreements = new List<echosign_dev1__SIGN_Agreement__c>();
        for(Id accountId : accountIds) {
            echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c();
            agreement.Account__c = accountId;
            agreements.add(agreement);
        }

        if(willInsert) {
            insert agreements;
        }

        return agreements;
    }

    public static Account createAccount( String name, Boolean willInsert ){

        Account acct = new Account( Name = name );
        acct.BillingCity = 'Bangkok';
        acct.BillingCountry = 'Thailand';
        acct.BillingState = 'Pak Chong';
        acct.BillingStreet = 'oak';
        acct.BillingPostalCode = '90210';

        if ( willInsert )
            insert acct;

        return acct;

    }

    public static List<Opportunity> createOpportunities( Integer numOfOpp, Id accountId, Id contactId, Boolean willInsert ) {

        List<Opportunity> testOpp = new List<Opportunity>();

        for ( Integer i = 0; i < numOfOpp; i++ ){

            Opportunity opp = new Opportunity ();

            opp.Name = 'test123' + i;
            opp.StageName = '12% Qualified Opportunity';
            opp.CloseDate = Date.today();
            opp.OwnerId = UserInfo.getUserId();
            opp.Amount = 100;
            opp.AccountId = accountId;
            opp.Primary_Contact__c = contactId;
            opp.Reason_Won_Lost__c = 'Best Economics';
            opp.System_Size_KwP__c = 100;
            opp.Location_of_Installation__c = 'Metal Roof';
            opp.Mounting_System__c = 'PV Only';
            opp.ARRA_Compliance__c = 'Non ARRA';
            opp.Sharer_Id__c = 'Share'+i;

            testOpp.add( opp );
        }

        if(willInsert){
            insert testOpp;
        }

        return testOpp;
    }

    public static User createPartnerPortalUser( Contact cont, Boolean willInsert){

        User user = new User(LastName = 'BWGUY'+String.ValueOf(DateTime.Now()) ,FirstName = 'NORMAN'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        String username ='testconbyPO2@worlds.comp';
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';

        List<Profile> lstProfile = [select Id from Profile where Name = :TEST_PARTNER_PROFILE];
        user.ProfileId = lstProfile[0].Id;

        if ( willInsert )
            insert user;

        return user;

    }

    public static LeasePayment__c createLeasePayment(String name, Id accountId, Id quoteId, Boolean doInsert){

        LeasePayment__c leasePayment = createLeasePayment( name, accountId, false );
        leasePayment.Quote__c = quoteId;

        if(doInsert){
            insert leasePayment;
        }

        return leasePayment;
    }

    public static LeasePayment__c createLeasePayment(String name, Id accountId, Boolean doInsert){

        LeasePayment__c testLeasePayment = new LeasePayment__c();
        testLeasePayment.Name= name;
        testLeasePayment.Account__c=accountId;
        testLeasePayment.End_Customer_Account__c = accountId;

        if(doInsert){
            insert testLeasePayment;
        }

        return testLeasePayment;
    }

    public static List<LeasePayment__c> createLeasePayments(Integer numPayments, Id accountId, Boolean doInsert)
    {
        List<LeasePayment__c> leasePayments = new List<LeasePayment__c>();
        for(Integer i = 0; i < numPayments; i++)
        {
            LeasePayment__c leasePayment = createLeasePayment('Test'+i, accountId, false);
            leasePayments.add(leasePayment);
        }

        if(doInsert)
        {
            insert leasePayments;
        }

        return leasePayments;
    }

    public static FMV_Rate__c createRate(Date startDate, Date endDate, String state, Double rate, Boolean doInsert)
    {
        FMV_Rate__c rateToReturn = new FMV_Rate__c(Start_Date__c = startDate,
                                End_Date__c = endDate,
                                State__c = state,
                                FMV_Rate__c = rate);

        if(doInsert)
        {
            insert rateToReturn;
        }

        return rateToReturn;
    }

    public static User createUser( String profileName, Boolean willInsert){

        User user = new User();
        user.FirstName = 'First' + System.now().getTime();
        user.LastName = 'Last' + System.now().getTime();
        user.Username = 'user' + System.now().getTime() + '@test.com.test';
        user.Email = user.Username;
        user.CommunityNickname = user.Username;
        user.Division = 'Test Division';
        user.Alias = user.Username.substring( 0, 8 );
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.Country = 'United States';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.SOX_Profile_was_approval_received__c  = true; //MAM 10/24/2014 code modification to bypass the SOX_Compliance_Profile_Added_to_New_User validation rule

        List<Profile> lstProfile = [select Id from Profile where Name = :profileName];
        user.ProfileId = lstProfile[0].Id;

        if ( willInsert )
            insert user;

        return user;

    }

    public static Contact createContact( String name, Id accountId, Boolean willInsert ){

        Contact cont = new Contact( AccountID = accountId, FirstName=name, LastName='testconbyPO2');
        cont.Email = System.now().getTime()+'te@test.com';
        cont.Phone = '999-888-6677';
        cont.MailingCity = 'San Francisco';
        cont.MailingStreet = '100 Spear St';
        cont.MailingCountry = 'USA';
        cont.MailingState='CA';
        cont.MailingPostalCode ='94105';
        cont.Authorized_to_Order__c = true;

        if ( willInsert )
            insert cont;

        return cont;
    }

    public static Id getPartnerRecordTypeId( ){

        Id partnerRTId = [select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1].Id;

        return partnerRTId;

    }

    public static Id getResidentialRecordTypeId( ){

        Id residentialRTId = [select id,Name from RecordType where sObjectType ='Account' and name ='Residential Customer' LIMIT 1].Id;

        return residentialRTId;

    }

    public static Tranche_Batch__c createTrancheBatch(String name, Boolean doInsert) {

        Tranche_Batch__c testTrancheBatch = new Tranche_Batch__c();
        testTrancheBatch.Name = name;

        if(doInsert){
            insert testTrancheBatch;
        }

        return testTrancheBatch;
    }

    public static Vertex_Address_Validation__c createValidation( String zipcode, Boolean willInsert ) {

        Vertex_Address_Validation__c validation = new Vertex_Address_Validation__c( Geo_Postal_Code__c = zipcode );
        validation.Geo_City__c = 'San Francisco';
        validation.Geo_State__c = 'CA';
        validation.Geo_County__c = 'San Francisco';

        if ( willInsert )
            insert validation;

        return validation;
    }

    public static Global_Dealer_Program__c createGDP(boolean willInsert ) {

      Global_Dealer_Program__c NewGlobal = new Global_Dealer_Program__c();
        NewGlobal.Performance_Period__c = 'P2';
        NewGlobal.Performance_Year__c = 2011;
        NewGlobal.First_Quarter_of_Performance_Period__c ='Q3';
        NewGlobal.Second_Quarter_of_Performance_Period__c = 'Q4';
        NewGlobal.Current_Performance_Period_Start_Date__c = date.parse('7/4/2011');
        NewGlobal.Current_Performance_Period_End_Date__c = date.parse('1/1/2012');
        NewGlobal.Account_Type__c = 'Authorized-Partner-Combo, Authorized-Partner-Residential';
        NewGlobal.Countries_Supported__c = 'France, Germany, Italy, Belgium, United Kingdom';
        NewGlobal.Country_Domain__c = '<>rvar-us, combo-us, cvar-us';
        NewGlobal.Data_Load_Identifier__c = 'GDP0.Test436326514319252';

      if ( willInsert )
        insert NewGlobal;

    return NewGlobal;

    }

    public static List<Qualification__c> createQualifications( Integer numQuals, Boolean doInsert )
    {
        List<Qualification__c> testQualifications = new List<Qualification__c>();
        for( Integer index = 0; index < numQuals; index++ )
        {
            Qualification__c newQual = new Qualification__c();
            newQual.Name = 'Test Qual ' + index;
            testQualifications.add( newQual );
        }
        if( doInsert )
        {
            insert testQualifications;
        }
        return testQualifications;
    }

    public static List<Qualification_Rule__c> createQualificationRules( Integer numRules, Id qualId, Boolean doInsert )
    {
        List<Qualification_Rule__c> testRules = new List<Qualification_Rule__c>();
        for( Integer index = 0; index < numRules; index++ )
        {
            Qualification_Rule__c aRule = new Qualification_Rule__c();
            aRule.Field_API_Name__c = 'some_field';
            aRule.Qualification__c = qualId;
            testRules.add( aRule );
        }
        if( doInsert )
        {
            insert testRules;
        }
        return testRules;
    }

    static Sobject adminIffyInsert(Sobject record, Boolean doInsert) {
        if(doInsert) {
            System.runAs(ADMIN_USER) {
                insert record;
            }
        }

        return record;
    }
    
    public static List<Invoice_Documents__c> createTPSInvoiceDocuments(Integer size, Id leasePaymentId, String invoiceType,String program,String eventType,String docOwner,String sharingType,String docUploadLocation,String sharedWith,Boolean willInsert){
        
        List<Invoice_Documents__c> toReturn = new List<Invoice_Documents__c>();

        for(Integer i = 0; i < size; i++){
            Invoice_Documents__c invoiceDoc = new Invoice_Documents__c();
            invoiceDoc.Lease_Payment__c = leasePaymentId;
            invoiceDoc.Invoice_Type__c = invoiceType;
            invoiceDoc.Notes_to_Dealer__c = 'Test Note to dealer';
            invoiceDoc.Document_Owner__c=docOwner;
            invoiceDoc.Location__c=docUploadLocation;
            invoiceDoc.Type__c=eventType;
            invoiceDoc.Program__c=program;
            invoiceDoc.Sharing_Type__c=sharingType;
            invoiceDoc.Shared_With__c=sharedWith;
            toReturn.add(invoiceDoc);
        }

        if(willInsert){
            insert toReturn;
        }

        return toReturn;
    }
    
    
    public static List<FPO_Order_Line__c> createFPOOrderLines (Integer size, Id leasePaymentId,string VendorType,Boolean willInsert){
        
        List<FPO_Order_Line__c> toReturn = new List<FPO_Order_Line__c>();

        for(Integer i = 0; i < size; i++){
            FPO_Order_Line__c FPOOrderLine = new FPO_Order_Line__c();
            FPOOrderLine.Lease_Payment__c = leasePaymentId;
            FPOOrderLine.Vendor_Type__c = VendorType;
            FPOOrderLine.Item_Number__c = 'Test' + 1;
            toReturn.add(FPOOrderLine);
        }

        if(willInsert){
            insert toReturn;
        }

        return toReturn;
    }
    
    public static Credit_Check_Request__c createCreditCheckApp(Id accountId, Id contactId, Boolean willInsert){
        Credit_Check_Request__c creditApp = new Credit_Check_Request__c();
        creditApp.Application_Id__c = '4563';
        creditApp.Account__c = accountId;
        creditApp.Contact__c = contactId;
		creditApp.First_Name__c='testFirstName';
        creditApp.Last_Name__c='testLastName';
        creditApp.Phone__c = '1234567890';
        creditApp.Email__c = 'testcca@test.com';
        creditApp.Street__c = 'testStreet';
        creditApp.City__c = 'testCity';
        creditApp.State__c = 'testState';
        creditApp.Zip__c = '645333';
        
        if(willInsert){
            insert creditApp;
        }

        return creditApp;
    }

    public static Credit_Product__c createCreditProduct(Id creditCheckId, Decimal maxLoanAmount, Decimal minLoanAmount, boolean willInsert){
        
        Credit_Product__c toReturn = new Credit_Product__c();
        
        toReturn.CreditApplication__c  = creditCheckId;
        toReturn.Max_Loan_Amount__c = maxLoanAmount;
        toReturn.Min_Loan_Amount__c = minLoanAmount;
        
        if(willInsert){
            insert toReturn;
        }
        
        return toReturn;
    }
    
    public static Roof_Design__c createRoofDesign(Id accountId,Id recordTypeId,String origin,String status,boolean willInsert){
        Roof_Design__c rd = new Roof_Design__c();
        rd.Account_Name__c = accountId;
        rd.Active__c = true;
        rd.Origin__c = origin;
        rd.Status__c = status;
        rd.RecordTypeId = recordTypeId;
        if(willInsert){
            insert rd;
        }
        return rd;
    }
}