/*

Generic class for creation of test objects for SunPower

Class:              TestClassFactory
Date:               06/18/2014
Version:            1
Last Updated:       06/18/2014
*   Stubbed


version: KCM_02142016
date/time modified: 02/14/2016 6:22PM Pacific
author: Kane Chelster Macaspac
details:
1. updated code to reference NH Community's Community_Name_text__c field instead of Community_Name__c
2. please use the version name as a search term to jump to the specific lines of code related to this version
3. please refer to case 00643246 for specific information with regard to this change
////////////////////////////////////////////////////////////////////////////////
*/

@isTest
public with sharing class TestClassFactory
{
    // -------- Constants --------
    // None

    // -------- Constructor --------
    // None

    // -------- Variables --------
    // For storing instance schema when retrieveRecordTypeID or users are created
    private static Map<String, Schema.sObjectType> sObjectSchema;
    private static Profile userProfile;

    // Used when getting fake ids in a test running context
    private static Integer startingNumber = 1;

    // -------- Properties --------
    // None

    // -------- Methods --------
    // Return test objects

    public static Lead testLead(String lastName, String company, String email)
    {
        Lead result = new Lead();

        result.LastName = lastname;
        result.Company = company;
        result.LeadSource = 'Web';
        result.Email = email;

        return result;
    }

    public static Account testAccount(String name, String recordTypeID)
    {
        Account result = new Account();
        result.Name = name;
        result.RecordTypeID = recordTypeID;
        result.BillingCity = result.ShippingCity = 'Denver';
        result.BillingCountry = result.ShippingCountry = 'USA';
        result.BillingStreet = result.ShippingStreet = '12345 Main St';
        result.BillingPostalCode = result.ShippingPostalCode = '80000';
        result.BillingState = result.ShippingState = 'CO';

        return result;
    }

    public static Contact testContact(String lastName, String email, String recordTypeID)
    {
        Contact result = new Contact();
        result.LastName = lastName;
        result.RecordTypeId = recordTypeID;
        result.Email = email;
        result.FirstName = 'Test';

        return result;
    }

    public static Opportunity testOpportunity(String name, String stage, Date closeDate, String recordTypeID)
    {
        Opportunity result = new Opportunity();
        result.Name = name;
        result.StageName = stage;
        result.CloseDate = closeDate;
        result.RecordTypeID = recordTypeID;
        result.Credit_Application_Status_Message__c = 'In Progress';
        result.Average_Monthly_Electricity_Bill__c = 'TestAvgBill';
        result.Shading__c = 'TestShading';
        result.Amount = 100.00;
        result.Reason_Won_Lost__c = 'TestRWL';
        result.Installation_Completed_Date__c = date.today();
        result.Referred_By_First_Name__c = 'TestRFN';
        result.Referred_By_Last_Name__c = 'TRLN';
        result.Referral_Program_Status__c = 'TestRPS';
        result.Description = 'TestDescription';
        result.Best_Time_To_Call__c = 'TestBTTC';
        result.Alliance_Program_Lead__c = false;
        result.LeadSource = 'TestLeadSource';
        result.Lead_Manufacturer__c = 'TestLeadManufactor';

        return result;
    }

    public static DealerGeneral__c testDealerGeneralSetting()
    {
        DealerGeneral__c result = new DealerGeneral__c();
        result.Default_Owner_of_Opportunities_Id__c = UserInfo.getUserId();
        result.Enable_ALR_Dealer_Scoring__c = TRUE;
        result.Enable_ALR_Process__c = TRUE;
        return result;
    }

    public static ALR_Theaters__c testALRTheaterSetting()
    {
        ALR_Theaters__c result = new ALR_Theaters__c();
        result.Name = 'North America';
        return result;
    }

    public static Campaign testCampaign(String name)
    {
        Campaign result = new Campaign();
        result.Name = name;
        return result;
    }

    //Partner Type is partner type field on campaign partner object: Standard, Appointment Setting, Warm Transfer; Standard is default
    public static Campaign_Partner__c testCampaignPartner(String name, Id campaignId, Id accountId, Boolean enabled, String partnerType)
    {
        Campaign_Partner__c result = new Campaign_Partner__c();
        result.Campaign__c = campaignId;
        result.Partner__c = accountId;
        result.Enabled__c = enabled;
        result.Partner_Type__c = partnerType;
        return result;
    }

    public static User testUser(String profileName, String emailName, String nickName)
    {
        User result = new User();

        if(userProfile == null || userProfile.name.toLowerCase() != profileName.toLowerCase())
        {
            userProfile = [SELECT ID, Name FROM Profile WHERE Name =: profileName];
        }

        result = new User(alias = nickName, email = emailName,
                          emailencodingkey='UTF-8', lastname='Testing',
                          languagelocalekey='en_US', localesidkey='en_US',
                          profileid = userProfile.Id,  country='United States',
                          communityNickName = nickName, timezonesidkey='America/Los_Angeles',
                          username=string.valueOf(math.random())+'u1@testorg.com');
        result.Case_Number__c = '123455';
        return result;
    }

    // Specific for a portal user creation
    public static User testAndInsertPortalUser(String emailName, String nickName, ID portalAccountID)
    {
        User result = new User();

        Contact portalContact = testContact('PortalContact', 'portalcontact@testportalcontact.com', retrieveRecordTypeID('Contact', 'Partner'));
        portalContact.AccountID = portalAccountID;
        insert portalContact;

        result = testUser('Partner Executive', emailName, nickName);
        result.ContactID = portalContact.ID;

        return result;
    }

    //Mock SIC
    public static SIC__c testSIC() {
        SIC__c result = new SIC__c();
        result.First_Level__c = '1';
        result.Second_Level__c = '2';
        result.Third_Level__c = '3';
        result.SIC_Code__c = '11111';
        result.SPWR_Industry_Type__c = 'Other';
        return result;
    }

    //Five9 Call Task for Lead Record
    public static Task testF9CallTask(Id leadId) {

        Task testTask = new Task();
        testTask.WhoId = leadId;
        testTask.RecordTypeId = retrieveRecordTypeID('Task', 'Task visible to SunPower only');
        testTask.Subject = 'Call';

        return testTask;
    }

    //create Lead Status Custom Settings
    public static List<F9CallDispositions__c> createCallDispositionSettings() {
        List<F9CallDispositions__c> settings = new List<F9CallDispositions__c>();
        settings.add(new F9CallDispositions__c(name='Appointment Confirmed',Disposition__c='Appointment Confirmed', Lead_Status__c='Appointment Confirmed'));
        settings.add(new F9CallDispositions__c(name='Assign New Dealer',Disposition__c='Assign New Dealer', Lead_Status__c='Disqualified', Reason__c='Assign New Dealer'));
        settings.add(new F9CallDispositions__c(name='Attempt Day 1',Disposition__c='Attempt Day 1', Lead_Status__c='Sales Accepted'));
        settings.add(new F9CallDispositions__c(name='Attempt Day 2',Disposition__c='Attempt Day 2', Lead_Status__c='Sales Accepted'));
        settings.add(new F9CallDispositions__c(name='Attempt Day 4',Disposition__c='Attempt Day 4', Lead_Status__c='Sales Accepted'));
        settings.add(new F9CallDispositions__c(name='Attempt Day 6',Disposition__c='Attempt Day 6', Lead_Status__c='Sales Accepted'));
        settings.add(new F9CallDispositions__c(name='Attempt Day 7',Disposition__c='Attempt Day 7', Lead_Status__c='Sales Accepted', Trigger_Eloqua_Follow_Up__c=TRUE));
        settings.add(new F9CallDispositions__c(name='Attempt Day 12',Disposition__c='Attempt Day 12', Lead_Status__c='Sales Accepted', Trigger_No_Contact_Activities__c=TRUE));
        settings.add(new F9CallDispositions__c(name='Customer Service', Lead_Status__c='Disqualified', Reason__c='Customer Service'));
        settings.add(new F9CallDispositions__c(name='DQ - Low Elec Bill', Disposition__c='Lost - Not Solar Candidate - Low Electric Bill', Lead_Status__c='Disqualified',Reason__C='Lost - Not Solar Candidate - Low Electric Bill'));
        settings.add(new F9CallDispositions__c(name='Dormant Lead (Redial in 60 days)',Disposition__c='Dormant Lead (Redial in 60 days)', Lead_Status__c='Sales Accepted'));
        settings.add(new F9CallDispositions__c(name='Lost - Already Working With Dealer',Disposition__c='Lost - Already Working With Dealer', Lead_Status__c='Disqualified', Reason__c='Lost - Already Working with Dealer'));
        settings.add(new F9CallDispositions__c(name='Lost - Commercial Lead',Disposition__c='Lost - Commercial Lead', Lead_Status__c='Disqualified', Reason__c='Lost - Commercial Lead'));
        settings.add(new F9CallDispositions__c(name='Lost - Did not want to be contacted',Disposition__c='Lost - Did not want to be contacted', Lead_Status__c='Disqualified', Reason__c='Lead did not want to be contacted'));
        settings.add(new F9CallDispositions__c(name='Lost - Duplicate Account',Disposition__c='Lost - Duplicate Account', Lead_Status__c='Disqualified', Reason__c='Lost - Duplicate Account'));
        settings.add(new F9CallDispositions__c(name='Lost - Incorrect Contact Info',Disposition__c='Lost - Incorrect Contact Info', Lead_Status__c='Disqualified', Reason__c='Invalid contact information'));
        settings.add(new F9CallDispositions__c(name='Lost - No Dealer in Area',Disposition__c='Lost - No Dealer in Area', Lead_Status__c='Disqualified', Reason__c='Outside of coverage area'));
        settings.add(new F9CallDispositions__c(name='Lost - Not Price Competitive',Disposition__c='Lost - Not Price Competitive', Lead_Status__c='Disqualified', Reason__c='Lost to Competitor'));
        settings.add(new F9CallDispositions__c(name='Lost - Not Solar Candidate - Credit',Disposition__c='Lost - Not Solar Candidate - Credit', Lead_Status__c='Disqualified', Reason__c='Not candidate for Solar - Credit'));
        settings.add(new F9CallDispositions__c(name='Lost - Not Solar Candidate - Roof Type',Disposition__c='Lost - Not Solar Candidate - Roof Type', Lead_Status__c='Disqualified', Reason__c='Unsuitable structure/roof'));
        settings.add(new F9CallDispositions__c(name='Lost - Not Solar Candidate - Shading',Disposition__c='Lost - Not Solar Candidate - Shading', Lead_Status__c='Disqualified', Reason__c='Shading'));
        settings.add(new F9CallDispositions__c(name='Lost - To Competition',Disposition__c='Lost - To Competition', Lead_Status__c='Disqualified', Reason__c='Lost to Competitor'));
        settings.add(new F9CallDispositions__c(name='Nurture - Waiting for Refoof',Disposition__c='Nurture - Waiting for Refoof', Lead_Status__c='Nurture'));
        settings.add(new F9CallDispositions__c(name='Nurture - Interested but not now',Disposition__c='Nurture - Interested but not now', Lead_Status__c='Nurture'));
        settings.add(new F9CallDispositions__c(name='Other - Misc or Test Leads',Disposition__c='Other - Misc or Test Leads', Lead_Status__c='Disqualified', Reason__c='Other - Misc or Test Leads'));
        settings.add(new F9CallDispositions__c(name='customer cancellation',Disposition__c='customer cancellation', Lead_Status__c='Opportunity Lost', Reason__c='Lead did not want to be contacted'));
        settings.add(new F9CallDispositions__c(name='d2d_customer cancellation',Disposition__c='d2d_customer cancellation', Lead_Status__c='Opportunity Lost', Reason__c='Lead did not want to be contacted'));
        return settings;
    }

    // REST createUpdateLead service record
    public static REST_LeadModification.LeadRecord testLeadModificationRecord(String lastName, String email)
    {
        REST_LeadModification.LeadRecord result = testLeadModificationRecordBare(lastName);
        result.email = email;
        result.firstName = 'Test';
        result.shippingAddress = '12345 Main St.';
        result.shippingCity = 'Denver';
        result.shippingState = 'Colorado';
        result.shippingZipCode = '80000';
        result.shippingCountry = 'USA';
        result.opportunityName = 'TestOppName';
        result.creditCheckStatus = 'TestCCS';
        result.averageMonthlyElectricBill = 'Greater than $300';
        result.shading = 'No Shade';
        result.amount = 100.00;
        result.stageName = 'Contract Signed';
        result.reasonWonLost = 'Best Price';
        result.installationCompletedDate = date.today();
        result.referredByFirstName = 'TestRFN';
        result.referredByLastName = 'TestRLN';
        result.referralProgramStatus = 'TestRPS';
        result.description = 'TestOppDescription';
        result.bestTimeToCall = 'Not the weekend.';

        return result;
    }

    // Create a bare minimum data record
    public static REST_LeadModification.LeadRecord testLeadModificationRecordBare(String lastName)
    {
        REST_LeadModification.LeadRecord result = new REST_LeadModification.LeadRecord();
        result.lastName = lastName;
        result.phone = '3035558888';
        result.billingAddress = '12345 Main St.';
        result.billingCity = 'Denver';
        result.billingState = 'Colorado';
        result.billingZipCode = '80000';
        result.billingCountry = 'USA';
        result.closeDate = date.today();

        return result;
    }


    public static Account CreateDealer(String dealerName, String theater)
    {
        Account a = new Account();
        a.Name = DealerName; //'Really Bright Solar';
        a.Type = 'Premier-Partner-Residential'; //PartnerRecordTypeAccount .Id;
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        a.Dealer_Score_Total__c = 78;
        a.Dealer_Locator_Phone__c = '888-888-8888';
        a.Phone = '888-888-8888';
        a.BillingStreet = '150 Corona St';
        a.BillingCity = 'Denver';
        a.BillingState = 'CO';
        a.BillingCountry = 'United States';
        a.BillingPostalCode = '80218';
        a.Website = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c = '123';
        a.Description = 'None';
        a.Partner_Facts__c = 'None';
        a.Status__c = 'Active';
        a.Dealer_Locator_Opt_Out__c = false;
        a.Lead_Flow_Opt_Out__c = false;
        a.Alliance_Program_Partner__c = true;
        a.Geolocation__Latitude__s = 39.718887;
        a.Geolocation__Longitude__s = -104.974036;
        a.Theater__c = theater;
        a.Primary_PSR__c = UserInfo.getUserId();
        a.RSM__c = UserInfo.getUserId();
        a.Special_Programs__c = 'Storage - Hawaii';
        a.Country_Domain__c = 'combo-us';

        //added operating unit
        a.Oracle_Operating_Unit__c = 'SPNA OU';
        insert a;

        Dealer_Assignment_Audit__c leadAssignment = DealerUtility.ConfigureDealerAssignmentAudit('Test2', a.Id, null, 'test', 'none');
        system.assert(leadAssignment != null);

        //2. Insert CoverageArea__c
        CoverageArea__c ca = new CoverageArea__c();
        ca.Account__c = a.id;
        ca.Geolocation__Latitude__s = 39.718887;
        ca.Geolocation__Longitude__s = -104.974036;
        ca.Radius__c = 1000;
        insert ca;

/*        Business_Registration__c br = new Business_Registration__c();
        br.Name = a.billingstate;
        br.Account__c = a.id;
        br.License_Number__c = '000000';
        br.Country__c = a.billingCountry;
        br.State__c = a.billingstate;
        insert br;
*/
        return a;
    }

    //Test Quote basic template
    public static Quote createTestQuote(Account testAccount, Opportunity testOpp)
    {
        Quote testQuote = new Quote();
        testQuote.Name = 'testQuote123_' + Date.today();
        testQuote.OpportunityId = testOpp.Id;
        testQuote.Account__c = testAccount.Id;
        testQuote.BillingCity = testAccount.BillingCity;
        testQuote.BillingStreet = testAccount.BillingStreet;
        testQuote.BillingState = testAccount.BillingState;
        testQuote.BillingCountry = testAccount.BillingCountry;
        testQuote.First_Monthly_Payment_Base_Amount__c = 100.00;
        testQuote.InstallDate__c = 'July 2015';
        testQuote.RecordTypeId = retrieveRecordTypeId('Quote', 'Proposal Quote');
        testQuote.Sales_Tax__c = 0.0;
        testQuote.Lease_Annual_Escalation__c = 2.0;
        testQuote.System_Production_Year_1__c = 6197.06;
        testQuote.Customer_Electric_Utility__c = 'Pacific Gas and Electric Company (PG&E)';
        testQuote.Customer_Rate_Name__c = 'CA_PGE_E1_x_B';
        testQuote.Lessor__c = 'SunPower Capital, LLC';
        testQuote.Total_Energy__c = 6197;
        testQuote.QuoteType__c = 'Lease';
        testQuote.System_Cost__c = 30000;
        testQuote.Dealer_Fees__c = 16397.00;
        testQuote.Description = 'Quote Description';
        testQuote.Quote_type__c = 'Residential Lease Quotation';

        return testQuote;
    }

    public static NH_Community__c testNHCommunity(Id installerId) {
        NH_Community__c result = new NH_Community__c();
            result.Builder_Name__c = 'KB Homes';
            result.Community_Name_text__c = 'Solaire'; //KCM_02142016
            result.Region__c = 'CAL-Bay Area';
            result.Installer__c = installerId;

        return result;
    }

    // Retrieving a record type ID using object describes
    public static ID retrieveRecordTypeID(String objectName, String recordTypeName) {

        ID result = null;
        Map<String, Schema.RecordTypeInfo> recordTypeInfo;

        if((objectName != null && objectName != '') ||
           (recordTypeName != null && recordTypeName != ''))
        {
            if(sObjectSchema == null)
            {
                sObjectSchema = Schema.getGlobalDescribe();
            }

            if(sObjectSchema!= null && sObjectSchema.containsKey(objectName))
            {
                Schema.SObjectType sObjType = sObjectSchema.get(objectName);
                Schema.DescribeSObjectResult description =
                    sObjType.getDescribe();
                recordTypeInfo = description.getRecordTypeInfosByName();

                if(recordTypeInfo != null &&
                   recordTypeInfo.containsKey(recordTypeName))
                {
                    result = recordTypeInfo.get(
                        recordTypeName).getRecordTypeId();
                }
            }
        }

        return result;
    }

    public static void createAndInsertLeaseAgreementSettings() {

        Lease_2_1_PO_Creation__c counterSignatureSettings = new Lease_2_1_PO_Creation__c();
        counterSignatureSettings.Lien_Waiver_Id__c = retrieveRecordtypeId('echosign_dev1__SIGN_Agreement__c', 'Lien Waiver');
        counterSignatureSettings.Lease_Contract_Id__c = retrieveRecordTypeId('echosign_dev1__SIGN_Agreement__c', 'Lease Contract');
        counterSignatureSettings.Amendment_Id__c = retrieveRecordTypeId('echosign_dev1__SIGN_Agreement__c', 'Amendement Contract');
        counterSignatureSettings.Partner_Id__c = retrieveRecordTypeId('echosign_dev1__SIGN_Agreement__c', 'Partner Agreement');
        counterSignatureSettings.Draft_Lease_Contract_Id__c = retrieveRecordTypeId('echosign_dev1__SIGN_Agreement__c', 'Draft Lease Contract');
        counterSignatureSettings.Termination_Id__c = retrieveRecordTypeId('echosign_dev1__SIGN_Agreement__c', 'Termination Agreement');
        counterSignatureSettings.Name = 'Counter Signature Info';
        insert counterSignatureSettings;

        FR_Record_Type__c frRecTypeSettings = new FR_Record_Type__c();
        frRecTypeSettings.Name = 'FR RecordType Id';
        frRecTypeSettings.FR_Agreement_RT_Id__c = retrieveRecordTypeId('echosign_dev1__SIGN_Agreement__c', 'FR Agreement');
        insert frRecTypeSettings;

    }

    // Retrieve a fake salesforce id for associated objects without needing to
    // insert the associated object
    public static String getFakeId(Schema.SObjectType objectType)
    {
        String result = String.valueOf(startingNumber++);

        return objectType.getDescribe().getKeyPrefix() +
            '0'.repeat(12-result.length()) + result;
    }

    public static List<SpectrumQuoteSettings__c> buildSpectrumQuoteServiceSettings(){
        List<SpectrumQuoteSettings__c> settings = new List<SpectrumQuoteSettings__c>();
        settings.add(new SpectrumQuoteSettings__c(Name='averageGuaranteedEnergyPriceperKWH',JSON_Name__c='averageGuaranteedEnergyPriceperKWH',sObject_Name__c='Quote',Field_API_Name__c='Averge_Payback_Rate_Per_kWH__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='earlyBuyOutDate',JSON_Name__c='earlyBuyOutDate',sObject_Name__c='Quote',Field_API_Name__c='Early_Buyout_Option_Date__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_May',JSON_Name__c='SolarAccessMay',sObject_Name__c='Roof_Details__c',Field_API_Name__c='May__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualFees',JSON_Name__c='AnnualFees',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Annual_Fees__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RoofHeight',JSON_Name__c='RoofHeight',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Height__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='dealerFeesTotal',JSON_Name__c='dealerFeesTotal',sObject_Name__c='Quote',Field_API_Name__c='Dealer_Fees__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='siteLatitude',JSON_Name__c='siteLatitude',sObject_Name__c='Quote',Field_API_Name__c='SiteLatitude__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_June',JSON_Name__c='SolarAccessJune',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Jun__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_August',JSON_Name__c='SolarAccessAugust',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Aug__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RoofPitch',JSON_Name__c='RoofPitch',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Pitch__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='sitePostCode',JSON_Name__c='sitePostCode',sObject_Name__c='Quote',Field_API_Name__c='Site_PostalCode__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='weatherDataFile',JSON_Name__c='weatherDataFile',sObject_Name__c='Quote',Field_API_Name__c='Weather_Data_File__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='totalMonthlyPaymentTaxFees',JSON_Name__c='totalMonthlyPaymentTaxFees',sObject_Name__c='Quote',Field_API_Name__c='Total_Monthly_Payment_Tax_Fees__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_September',JSON_Name__c='SolarAccessSeptember',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Sep__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_July',JSON_Name__c='SolarAccessJuly',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Jul__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_April',JSON_Name__c='SolarAccessApril',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Apr__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='primarySignatory',JSON_Name__c='primarySignatory',sObject_Name__c='Quote',Field_API_Name__c='Temp_Contact_1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='secondarySignatory',JSON_Name__c='secondarySignatory',sObject_Name__c='Quote',Field_API_Name__c='Temp_Contact_2__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='financingTerm',JSON_Name__c='financingTerm',sObject_Name__c='Quote',Field_API_Name__c='Term_Years__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='fullPrePaid',JSON_Name__c='fullPrePaid',sObject_Name__c='Quote',Field_API_Name__c='Full_Prepaid_Lease__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='lessor',JSON_Name__c='lessor',sObject_Name__c='Quote',Field_API_Name__c='Lessor__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='downPaymentBase',JSON_Name__c='downPaymentBase',sObject_Name__c='Quote',Field_API_Name__c='Down_Payment__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='contractCreatedDate',JSON_Name__c='contractCreatedDate',sObject_Name__c='Quote',Field_API_Name__c='Lease_doc_Created_Date__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualBase',JSON_Name__c='AnnualBase',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Annual_Base__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='totalMonthlyPaymentTax',JSON_Name__c='totalMonthlyPaymentTax',sObject_Name__c='Quote',Field_API_Name__c='Total_Monthly_Payment_Tax__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_November',JSON_Name__c='SolarAccessNovember',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Nov__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RackingName',JSON_Name__c='RackingName',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Racking_Name__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='contractSentOutForSignature',JSON_Name__c='contractSentOutForSignature',sObject_Name__c='Quote',Field_API_Name__c='Lease_doc_Sent_out_for_Signature__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='utilityDistributor',JSON_Name__c='utilityDistributor',sObject_Name__c='Quote',Field_API_Name__c='Utility_Distributor__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='monthlyPaymentBaseYear1',JSON_Name__c='monthlyPaymentBaseYear1',sObject_Name__c='Quote',Field_API_Name__c='Monthly_Payment_Base_Year_1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RoofType',JSON_Name__c='RoofType',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Roof_Type__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='systemPrice',JSON_Name__c='systemPrice',sObject_Name__c='Quote',Field_API_Name__c='System_Price__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='siteLongitude',JSON_Name__c='siteLongitude',sObject_Name__c='Quote',Field_API_Name__c='SiteLongitude__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='MonthlySalesTax',JSON_Name__c='MonthlySalesTax',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Monthly_Sales_Tax__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='siteState',JSON_Name__c='siteState',sObject_Name__c='Quote',Field_API_Name__c='Site_State__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='monthlyPaymentBaseYear1Alt',JSON_Name__c='monthlyPaymentBaseYear1',sObject_Name__c='Quote',Field_API_Name__c='First_Monthly_Payment_Base_Amount__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='dealerFeesSalesPartnerTotal',JSON_Name__c='dealerFeesSalesPartnerTotal',sObject_Name__c='Quote',Field_API_Name__c='Dealer_Fees_Sales_Partner_Total__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='moduleManufacturer',JSON_Name__c='moduleManufacturer',sObject_Name__c='Quote',Field_API_Name__c='Module_Brand__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='ModuleOraceItemNumber',JSON_Name__c='ModuleOraceItemNumber',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Module_Oracle_Item_Number__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='URL',JSON_Name__c='URL',sObject_Name__c='Document',Field_API_Name__c='URL__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='systemCost',JSON_Name__c='systemCost',sObject_Name__c='Quote',Field_API_Name__c='System_Cost__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='moduleName',JSON_Name__c='moduleName',sObject_Name__c='Quote',Field_API_Name__c='Module__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='NumberOfStringsMPP1',JSON_Name__c='NumberOfStringsMPP1',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Number_Of_Strings_MPP1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='MonthlyBasePlusTax',JSON_Name__c='MonthlyBasePlusTax',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Monthly_Base_Plus_Tax__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='annualSystemProductionYear1',JSON_Name__c='annualSystemProductionYear1',sObject_Name__c='Quote',Field_API_Name__c='System_Production_Year_1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='NumberOfStringsMPP2',JSON_Name__c='NumberOfStringsMPP2',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Number_Of_Strings_MPP2__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='fullPrePaidBase',JSON_Name__c='fullPrePaidBase',sObject_Name__c='Quote',Field_API_Name__c='Full_PrePayment_Amount_Base_Amount__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='isLocked',JSON_Name__c='isLocked',sObject_Name__c='Quote',Field_API_Name__c='Is_Locked__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='monthlyPaymentFeesYear1',JSON_Name__c='monthlyPaymentFeesYear1',sObject_Name__c='Quote',Field_API_Name__c='Monthly_Payment_Fees_Year_1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='contractSigned',JSON_Name__c='contractSigned',sObject_Name__c='Quote',Field_API_Name__c='Lease_Doc_Signed__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='utilityRateEscalation',JSON_Name__c='utilityRateEscalation',sObject_Name__c='Quote',Field_API_Name__c='Utility_Bill_Annual_Escalation__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RowNumber',JSON_Name__c='RowNumber',sObject_Name__c='Annual_Energy_Production__c',Field_API_Name__c='Row_Number__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RemainingLeaseValue',JSON_Name__c='RemainingLeaseValue',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Remaining_Lease_Value__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='monthlyPaymentTaxYear1',JSON_Name__c='monthlyPaymentTaxYear1',sObject_Name__c='Quote',Field_API_Name__c='Monthly_Payment_Tax_Year_1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_December',JSON_Name__c='SolarAccessDecember',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Dec__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='siteAddress1',JSON_Name__c='siteAddress1',sObject_Name__c='Quote',Field_API_Name__c='Site_Address_Line_1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='siteAddress2',JSON_Name__c='siteAddress2',sObject_Name__c='Quote',Field_API_Name__c='Site_Adress_Line_2__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='annualPaymentEscalator',JSON_Name__c='annualPaymentEscalator',sObject_Name__c='Quote',Field_API_Name__c='Lease_Annual_Escalation__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='financingType',JSON_Name__c='financingType',sObject_Name__c='Quote',Field_API_Name__c='QuoteType__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='salesTaxRate',JSON_Name__c='salesTaxRate',sObject_Name__c='Quote',Field_API_Name__c='Sales_Tax__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='documentType',JSON_Name__c='documentType',sObject_Name__c='Document',Field_API_Name__c='Type__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='totalMonthlyPaymentBase',JSON_Name__c='totalMonthlyPaymentBase',sObject_Name__c='Quote',Field_API_Name__c='Total_Monthly_Payment_Base__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='dealerFeesInstallationPartnerTotal',JSON_Name__c='dealerFeesInstallationPartnerTotal',sObject_Name__c='Quote',Field_API_Name__c='Dealer_Fee_Installation_Partner_Total__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='averagePayBackRatePerKWH',JSON_Name__c='averagePayBackRatePerKWH',sObject_Name__c='Quote',Field_API_Name__c='Averge_Payback_Rate_Per_kWH__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_January',JSON_Name__c='SolarAccessJanuary',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Jan__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='MonthlyBase',JSON_Name__c='MonthlyBase',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Monthly_Base__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='downPaymentTax',JSON_Name__c='downPaymentTax',sObject_Name__c='Quote',Field_API_Name__c='Down_Payment_Tax__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='Extension',JSON_Name__c='Extension',sObject_Name__c='Document',Field_API_Name__c='Extension__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='monthlyPaymentTaxFeesYear1',JSON_Name__c='monthlyPaymentTaxFeesYear1',sObject_Name__c='Quote',Field_API_Name__c='Monthly_Payment_Tax_Fees_Year_1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='utilityRetailer',JSON_Name__c='utilityRetailer',sObject_Name__c='Quote',Field_API_Name__c='Proposed_Electric_Utility__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='description',JSON_Name__c='description',sObject_Name__c='Quote',Field_API_Name__c='Description__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='quoteNumber',JSON_Name__c='quoteNumber',sObject_Name__c='Quote',Field_API_Name__c='Original_Lease_Number__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='solarRebate',JSON_Name__c='solarRebate',sObject_Name__c='Quote',Field_API_Name__c='Solar_Rebate_Amount__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='fullPrePaidTax',JSON_Name__c='fullPrePaidTax',sObject_Name__c='Quote',Field_API_Name__c='Full_PrePayment_Amount_Estimated_Tax_on__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualPayBackRatePerKWH',JSON_Name__c='AnnualPayBackRatePerKWH',sObject_Name__c='Quote',Field_API_Name__c='Averge_Payback_Rate_Per_kWH__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='monitoringSystem',JSON_Name__c='monitoringSystem',sObject_Name__c='Quote',Field_API_Name__c='Monitoring_System__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='contractSignedDate',JSON_Name__c='contractSignedDate',sObject_Name__c='Quote',Field_API_Name__c='Lease_doc_Signed_Date__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='CostofLeasePerkWh',JSON_Name__c='CostofLeasePerkWh',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Cost_Of_Lease_Per_KWH__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualProductionHigh',JSON_Name__c='AnnualProductionHigh',sObject_Name__c='Annual_Energy_Production__c',Field_API_Name__c='High__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualProductionLow',JSON_Name__c='AnnualProductionLow',sObject_Name__c='Annual_Energy_Production__c',Field_API_Name__c='Low__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='quoteId',JSON_Name__c='quoteId',sObject_Name__c='Quote',Field_API_Name__c='Id'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualProductionBase',JSON_Name__c='AnnualProductionBase',sObject_Name__c='Annual_Energy_Production__c',Field_API_Name__c='Base__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='NumberOfModulesMPP1',JSON_Name__c='NumberOfModulesMPP1',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Number_Of_Modules_MPP1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='siteCIty',JSON_Name__c='siteCIty',sObject_Name__c='Quote',Field_API_Name__c='Site_City__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='UnitPrice',JSON_Name__c='UnitPrice',sObject_Name__c='QuoteLineItem',Field_API_Name__c='Unit_Price__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='ModuleBrand',JSON_Name__c='ModuleBrand',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Module_Brand__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='NumberOfModulesMPP2',JSON_Name__c='NumberOfModulesMPP2',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Number_Of_Modules_MPP2__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='quoteCurrency',JSON_Name__c='quoteCurrency',sObject_Name__c='Quote',Field_API_Name__c='CurrencyISOCode'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualSystemProductionGuaranteeYear',JSON_Name__c='AnnualSystemProductionGuaranteeYear',sObject_Name__c='Annual_Energy_Production__c',Field_API_Name__c='Annual_SystemProduction_Guarantee_Year__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='quoteType',JSON_Name__c='quoteType',sObject_Name__c='Quote',Field_API_Name__c='Quote_Type__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RoofDescription',JSON_Name__c='RoofDescription',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Description__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RackingQuantity',JSON_Name__c='RackingQuantity',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Racking_Quantity__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualProductionRange',JSON_Name__c='AnnualProductionRange',sObject_Name__c='Annual_Energy_Production__c',Field_API_Name__c='Guaranteed_Range_of_Annual_Production__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='InverterBrand',JSON_Name__c='InverterBrand',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Inverter_Manufacturer__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='afguaranteedEnergyPriceperKWH',JSON_Name__c='guaranteedEnergyPriceperKWH',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Guaranteed_Energy_Price_per_KWH__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='InverterModel',JSON_Name__c='InverterModel',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Inverter_Model__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='totalProductionLow',JSON_Name__c='totalProductionLow',sObject_Name__c='Quote',Field_API_Name__c='Total_Production_Low__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='maximumRatedCapacityDC',JSON_Name__c='maximumRatedCapacityDC',sObject_Name__c='Quote',Field_API_Name__c='Maximum_Rated_Capacity_DC__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='TotalModuleCount',JSON_Name__c='TotalModuleCount',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Module_Quantity__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='ModuleOracleItemNumberQuote',JSON_Name__c='moduleOracleItemNumber',sObject_Name__c='Quote',Field_API_Name__c='Module_Oracle_Item_Number__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RowNumberFinancial',JSON_Name__c='rowNumber',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Row_Number__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_October',JSON_Name__c='SolarAccessOctober',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Oct__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualTerminationValue',JSON_Name__c='AnnualTerminationValue',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Annual_Termination_Amount__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='totalProductionBase',JSON_Name__c='totalProductionBase',sObject_Name__c='Quote',Field_API_Name__c='Total_Production_Base__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='AnnualSalesTax',JSON_Name__c='AnnualSalesTax',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Annual_Sales_Tax__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='mountingOption',JSON_Name__c='mountingOption',sObject_Name__c='Quote',Field_API_Name__c='Mounting_Option__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='OracleItemNumber',JSON_Name__c='OracleItemNumber',sObject_Name__c='QuoteLineItem',Field_API_Name__c='Item__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_February',JSON_Name__c='SolarAccessFebruary',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Feb__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='totalProductionRange',JSON_Name__c='totalProductionRange',sObject_Name__c='Quote',Field_API_Name__c='Total_Production_Range__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='weatherLongitude',JSON_Name__c='weatherLongitude',sObject_Name__c='Quote',Field_API_Name__c='WeatherFile_Longitude__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='opportunityId',JSON_Name__c='oppId',sObject_Name__c='Quote',Field_API_Name__c='OpportunityId'));
        settings.add(new SpectrumQuoteSettings__c(Name='quoteName',JSON_Name__c='quoteName',sObject_Name__c='Quote',Field_API_Name__c='Name'));
        settings.add(new SpectrumQuoteSettings__c(Name='Quantity',JSON_Name__c='Quantity',sObject_Name__c='QuoteLineItem',Field_API_Name__c='Quantity__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='RoofDirection',JSON_Name__c='RoofDirection',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Direction__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='totalMonthlyPaymentBasePlusTax',JSON_Name__c='totalMonthlyPaymentBasePlusTax',sObject_Name__c='Quote',Field_API_Name__c='TotalMonthlyPaymentBasePlusTax__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='siteCountry',JSON_Name__c='siteCountry',sObject_Name__c='Quote',Field_API_Name__c='Site_Country__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='rackingName',JSON_Name__c='rackingName',sObject_Name__c='Quote',Field_API_Name__c='Mounting_Description__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='monthlyBasePlusTaxYear1',JSON_Name__c='monthlyBasePlusTaxYear1',sObject_Name__c='Quote',Field_API_Name__c='Monthly_Payment_Base_Plus_Tax_Year_1__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='quoteAmendmentNumber',JSON_Name__c='quoteAmendmentNumber',sObject_Name__c='Quote',Field_API_Name__c='Lease_tobe_Amended__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='InverterQuantity',JSON_Name__c='InverterQuantity',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Inverter_Count__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='MonthlyFees',JSON_Name__c='MonthlyFees',sObject_Name__c='Annual_Financial__c',Field_API_Name__c='Monthly_Fees__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='ModuleName',JSON_Name__c='ModuleName',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Module__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='weatherLatitude',JSON_Name__c='weatherLatitude',sObject_Name__c='Quote',Field_API_Name__c='WeatherFile_Latitude__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='Name',JSON_Name__c='itemName',sObject_Name__c='QuoteLineItem',Field_API_Name__c='Name'));
        settings.add(new SpectrumQuoteSettings__c(Name='SolarAccess_March',JSON_Name__c='SolarAccessMarch',sObject_Name__c='Roof_Details__c',Field_API_Name__c='Mar__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='quoteInverterValues',JSON_Name__c='quoteInverterValues',sObject_Name__c='Quote',Field_API_Name__c='Quote_Inverter_Values__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='Document Name',JSON_Name__c='name',sObject_Name__c='Document',Field_API_Name__c='Name'));
        settings.add(new SpectrumQuoteSettings__c(Name='utilityRate',JSON_Name__c='utilityRate',sObject_Name__c='Quote',Field_API_Name__c='Proposed_Rate_Name__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='aepguaranteedEnergyPriceperKWH',JSON_Name__c='guaranteedEnergyPriceperKWH',sObject_Name__c='Annual_Energy_Production__c',Field_API_Name__c='Guaranteed_Energy_Price_per_KWH__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='moduleQuantity',JSON_Name__c='moduleQuantity',sObject_Name__c='Quote',Field_API_Name__c='Module_Quantity__c'));
        settings.add(new SpectrumQuoteSettings__c(Name='totalProductionHigh',JSON_Name__c='totalProductionHigh',sObject_Name__c='Quote',Field_API_Name__c='Total_Production_High__c'));

        //Updated added new settings for ChangeOrders API release Oct. 2015 - Crystal, RedPoint
        settings.add(new SpectrumQuoteSettings__c(sObject_Name__c = 'echosign_dev1__SIGN_Agreement__c', Field_API_Name__c = 'Spectrum_Contract_Id__c', Name='spectrumAgreementId', JSON_Name__c = 'spectrumAgreementId'));
        settings.add(new SpectrumQuoteSettings__c(sObject_Name__c = 'echosign_dev1__SIGN_Agreement__c', Field_API_Name__c = 'Counter_Signed_Date__c', Name='agreementCounterSignedDate', JSON_Name__c = 'agreementCounterSignedDate'));
        settings.add(new SpectrumQuoteSettings__c(sObject_Name__c = 'echosign_dev1__SIGN_Agreement__c', Field_API_Name__c = 'echosign_dev1__Status__c', Name='agreementStatus', JSON_Name__c = 'agreementStatus'));
        settings.add(new SpectrumQuoteSettings__c(sObject_Name__c = 'echosign_dev1__SIGN_Agreement__c', Field_API_Name__c = 'Cancellation_Reason__c', Name='terminationReason', JSON_Name__c = 'terminationReason'));
        settings.add(new SpectrumQuoteSettings__c(sObject_Name__c = 'echosign_dev1__SIGN_Agreement__c', Field_API_Name__c = 'echosign_dev1__DateSigned__c', Name='agreementTerminationDate', JSON_Name__c = 'agreementTerminationDate'));
        settings.add(new SpectrumQuoteSettings__c(sObject_Name__c = 'echosign_dev1__SIGN_Agreement__c', Field_API_Name__c = 'Amendment_Type__c', Name='documentSubType', JSON_Name__c = 'documentSubType'));
        settings.add(new SpectrumQuoteSettings__c(sObject_Name__c = 'echosign_dev1__SIGN_Agreement__c', Field_API_Name__c = 'Echosign_Link__c', Name='agreementEchosignLink', JSON_Name__c = 'agreementEchosignLink'));


        return settings;
    }

    public static List<SpectrumSettings__c> buildSpectrumOppServiceSettings(Boolean isInbound)
    {
        List<SpectrumSettings__c> result = new List<SpectrumSettings__c>();

        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Field_API_Name__c = 'Id',Name='oppId', JSON_Name__c = 'oppId', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Field_API_Name__c = 'StageName', Name='oppStage',JSON_Name__c = 'oppStage', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Outbound_Type__c = 'Date', Field_API_Name__c = 'CloseDate', Name='oppCloseDate', JSON_Name__c = 'oppCloseDate', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Field_API_Name__c = 'Average_Monthly_Electricity_Bill__c', Name='averageMonthlyElectricBill', JSON_Name__c = 'averageMonthlyElectricBill', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Outbound_Type__c = 'Boolean', Field_API_Name__c = 'Alliance_Program_Lead__c', Name='allianceProgramLead', JSON_Name__c = 'allianceProgramLead', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Outbound_Type__c = 'String', Field_API_Name__c = 'LeadSource', Name='leadSource', JSON_Name__c = 'leadSource', Is_Inbound__c = isInbound, Do_Not_Update_On_Update__c = true));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Outbound_Type__c = 'String', Field_API_Name__c = 'Motivation_for_Solar__c', Name='motivationForSolar', JSON_Name__c = 'motivationForSolar', Is_Inbound__c = isInbound, Do_Not_Update_On_Update__c = true));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Outbound_Type__c = 'String', Field_API_Name__c = 'Shading__c', Name='shading', JSON_Name__c = 'shading', Is_Inbound__c = isInbound,Do_Not_Update_On_Update__c=true));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Outbound_Type__c = 'String', Field_API_Name__c = 'Lead_Qualification_Notes__c', Name='oppQualificationNotes', JSON_Name__c = 'oppQualificationNotes', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Outbound_Type__c = 'String', Field_API_Name__c = 'Reason_Won_Lost__c', Name='oppReasonWonLost', JSON_Name__c = 'oppReasonWonLost', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Field_API_Name__c = 'Campaign.Name', Name='campName', JSON_Name__c = 'campName', Is_Inbound__c = isInbound, Do_Not_Update_On_Update__c = true));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Opportunity', Field_API_Name__c = 'CampaignID', Name='campID', JSON_Name__c = 'campID', Is_Inbound__c = isInbound, Do_Not_Update_On_Update__c = true));
        result.add(new SpectrumSettings__c(Do_Not_Update_On_Update__c=true,sObject_Name__c = 'Opportunity',Field_API_Name__c = 'Name',JSON_Name__c = 'oppName', Name = 'oppName'));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Outbound_Type__c = 'Integer', Field_API_Name__c = 'AnnualRevenue', JSON_Name__c = 'accAnnual', Name = 'accAnnual', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'Name', Name='companyName', JSON_Name__c = 'companyName', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'BillingStreet', Name='billingStreet', JSON_Name__c = 'billingStreet', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'BillingCity', Name='billingCity', JSON_Name__c = 'billingCity', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'BillingState', Name='billingState', JSON_Name__c = 'billingState', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'BillingPostalCode', Name='billingPostalCode', JSON_Name__c = 'billingPostalCode', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'BillingCountry', Name='billingCountry', JSON_Name__c = 'billingCountry', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'ShippingStreet', Name='shippingStreet', JSON_Name__c = 'shippingStreet', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'ShippingCity', Name='shippingCity', JSON_Name__c = 'shippingCity', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'ShippingState', Name='shippingState', JSON_Name__c = 'shippingState', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'ShippingPostalCode', Name='shippingPostalCode', JSON_Name__c = 'shippingPostalCode', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'ShippingCountry', Name='shippingCountry', JSON_Name__c = 'shippingCountry', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'Oracle_County__c', Name='accOracleCounty', JSON_Name__c = 'accOracleCounty', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'Oracle_Shipping_County__c', Name='accOracleShippingCounty', JSON_Name__c = 'accOracleShippingCounty', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Account', Field_API_Name__c = 'Phone', Name='conPhone', JSON_Name__c = 'conPhone', Is_Inbound__c = isInbound));

        result.add(new SpectrumSettings__c(sObject_Name__c = 'Contact', Field_API_Name__c = 'FirstName', Name='pconFirstName', JSON_Name__c = 'pconFirstName', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Contact', Field_API_Name__c = 'LastName', Name='pconLastName', JSON_Name__c = 'pconLastName', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Contact', Field_API_Name__c = 'Email', Name='conEmail', JSON_Name__c = 'conEmail', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'Contact', Field_API_Name__c = 'MobilePhone', Name='conMobilePhone', JSON_Name__c = 'conMobilePhone', Is_Inbound__c = isInbound));

        result.add(new SpectrumSettings__c(sObject_Name__c = 'ContactSecondary', Field_API_Name__c = 'FirstName', Name='sconFirstName', JSON_Name__c = 'sconFirstName', Is_Inbound__c = isInbound));
        result.add(new SpectrumSettings__c(sObject_Name__c = 'ContactSecondary', Field_API_Name__c = 'LastName', Name='sconLastName', JSON_Name__c = 'sconLastName', Is_Inbound__c = isInbound));

        return result;
    }

    public static Attachment testAttachment(ID parentID, String fileName, String contentType)
    {
        Attachment result = new Attachment();
        result.ContentType = contentType;
        result.Name = fileName;
        result.ParentID = parentID;
        result.Body = blob.valueOf('body');

        return result;
    }

    public static Price_List__c createPriceList() {

        List<Item__c> items = new List<Item__c>();

        //Price_List__c
        Price_List__c priceList = new Price_List__c();
        priceList.Name = 'SPNA Test Price List';
        priceList.Shipping_Codes__c = 'McCollister-Truck-DTH LiftGate; McCollister-Truck-DTW; Other; Transport Via Truck';
        priceList.DSR_PO_Group_Email__c = 'orders@sunpowercorp.com.test';
        priceList.Oracle_Operating_Unit__c = 'SPNA OU';
        insert priceList;

        //module item
        Item__c moduleItem = new Item__c();
        moduleItem.Description__c = 'PVM, SPR-E20-327, C2C AR-S1 M5 B1 YUK';
        moduleItem.Long_Description__c = 'Slim Fast ModuleTolerance: +5/-0%';
        moduleItem.Line_Type__c = 'Standard Line';
        moduleItem.Product_Type__c = 'FG MODULE';
        moduleItem.Item_Category_1__c = 'FG MODULE';
        moduleItem.Item_Category_2__c = 'WHT 96 CELL NE';
        moduleItem.Item_Category_3__c = '327';
        moduleItem.Active__c = true;
        moduleItem.Item_ID__c = 'test001';
        moduleItem.Module_Width__c = 42.02;
        items.add(moduleItem);

        //monitoring item
        Item__c monitoringItem = new Item__c();
        monitoringItem.Description__c = 'MONITORING SYSTEM, RESIDENTIAL, SMS2, 1A4, 10"X8"X4", PRE-BUILT, WITH PVS2';
        monitoringItem.Line_Type__c = 'Ala Carte';
        monitoringItem.Item_Category_1__c = 'BOS-MONITORING';
        monitoringItem.Item_Category_2__c = 'SMS V2X';
        monitoringItem.Item_Category_3__c = 'ENCLOSURE';
        monitoringItem.Active__c = true;
        monitoringItem.Item_ID__c = 'ACtest002';
        monitoringItem.Disconnect_Item_Id__c = 'dcitem001';
        items.add(monitoringItem);

        Item__c monitoringItem2 = new Item__c();
        monitoringItem2.Description__c = 'MONITORING SYSTEM, RESIDENTIAL, SMS2, 1A4, 10"X8"X4", PRE-BUILT, WITH PVS2';
        monitoringItem2.Line_Type__c = 'Standard Line';
        monitoringItem2.Item_Category_1__c = 'BOS-MONITORING';
        monitoringItem2.Item_Category_2__c = 'SMS V2X';
        monitoringItem2.Item_Category_3__c = 'ENCLOSURE';
        monitoringItem2.Active__c = true;
        monitoringItem2.Item_ID__c = 'test002';
        items.add(monitoringItem2);

        //inverter item
        Item__c inverterItem = new Item__c();
        inverterItem.Description__c = 'INVERTER, SMA, SUNNY BOY 7700TL-US-22 (SPR-7702m), AFCI, RS485, 10-YEAR WARRANTY';
        inverterItem.Line_Type__c = 'Standard Line';
        inverterItem.Product_Type__c = 'INVERTER-SMA';
        inverterItem.Item_Category_1__c = 'INVERTER-SMA';
        inverterItem.Item_Category_2__c = 'STRING-TL-AFCI';
        inverterItem.Item_Category_3__c = '7700';
        inverterItem.Active__c = true;
        inverterItem.Item_ID__c = 'test003';
        inverterItem.Disconnect_Item_Id__c = 'dcitem001';
        items.add(inverterItem);

        Item__c disconnectItem = new Item__c();
        disconnectItem.Item_Id__c = 'dcitem001';
        disconnectItem.Description__c = 'INVERTER ACCESSORY, SMA, SB TL-US-22, DC DISCONNECT (FOR SPR-X002M MODELS)';
        disconnectItem.Product_Type__c = 'INVERTER-SMA';
        disconnectItem.Item_Category_1__c = 'INVERTER-SMA';
        disconnectItem.Item_Category_2__c = 'ACCESSORY';
        disconnectItem.Item_Category_3__c = 'NA';
        disconnectItem.Active__c = true;
        items.add(disconnectItem);

        //Storage Items
        //inverter item
        Item__c inverterItem2 = new Item__c();
        inverterItem2.Description__c = 'SolarEdge 7.6KVA US Storage Ready';
        inverterItem2.Line_Type__c = 'Standard Line';
        inverterItem2.Product_Type__c = 'INVERTER-OTHER';
        inverterItem2.Item_Category_1__c = 'INVERTER-OTHER';
        inverterItem2.Item_Category_2__c = 'STRING-TL-AFCI';
        inverterItem2.Item_Category_3__c = '7600';
        inverterItem2.Active__c = true;
        inverterItem2.Item_ID__c = 'testSTORAGE';
        items.add(inverterItem2);

        //Storage Unit
        Item__c storageUnit = new Item__c();
        storageUnit.Item_ID__c = 'BATTERY PACK';
        storageUnit.Description__c = 'BATTERY STORAGE, TESLA POWERWALL, 7kWh';
        storageUnit.Line_Type__c = 'Standard Line';
        storageUnit.Item_Category_1__c = 'BOS-ENERGY STORAGE';
        storageUnit.Item_Category_2__c = 'BATTERY PACK';
        storageUnit.Item_Category_3__c = 'DEFAULT';
        storageUnit.Active__c = true;
        items.add(storageUnit);

        //Accessories
        Item__c meterItem = new Item__c();
        meterItem.Item_Id__c = 'meter001';
        meterItem.Description__c = 'METER, SOLAREDGE, 1PH, 240V, NEMA3R, 2X200A CT, 5-YEAR WARRANTY';
        meterItem.Product_Type__c = 'INVERTER-OTHER';
        meterItem.Item_Category_1__c = 'OTHER';
        meterItem.Item_Category_2__c = 'ACCESSORY';
        meterItem.Item_Category_3__c = 'NA';
        meterItem.Active__c = true;
        items.add(meterItem);

        Item__c transformerItem = new Item__c();
        transformerItem.Item_Id__c = 'trnsfrm001';
        transformerItem.Description__c = 'AUTO-TRANSFORMER, SOLAREDGE, 5KVA, 12-YEAR WARRANTY';
        transformerItem.Product_Type__c = 'INVERTER-OTHER';
        transformerItem.Item_Category_1__c = 'INVERTER-OTHER';
        transformerItem.Item_Category_2__c = 'ACCESSORY';
        transformerItem.Item_Category_3__c = 'TRANSFORMER';
        transformerItem.Active__c = true;
        items.add(transformerItem);

        //Invisimount racking
        Item__c invisimount = new Item__c();
        invisimount.Description__c = 'KIT, BULK, INVISIMOUNT RACKING, 2KW';
        invisimount.Line_Type__c = 'Standard Line';
        invisimount.Active__c = true;
        invisimount.Item_Category_1__c = 'BoS';
        invisimount.Item_ID__c = 'invTest01';
        items.add(invisimount);

        Item__c invisimount2 = new Item__c();
        invisimount2.Description__c = 'KIT, BULK, INVISIMOUNT RACKING, 10KW';
        invisimount2.Line_Type__c = 'Standard Line';
        invisimount2.Active__c = true;
        invisimount2.Item_Category_1__c = 'BoS';
        invisimount2.Item_ID__c = 'invTest02';
        items.add(invisimount2);

        //Unirac racking
        Item__c solarmount = new Item__c();
        solarmount.Description__c = 'KIT, BULK, UNIRAC, 1KW';
        solarmount.Line_Type__c = 'Standard Line';
        solarmount.Active__c = true;
        solarmount.Item_Category_1__c = 'BoS';
        solarmount.Item_ID__c = 'smTest01';
        solarmount.Module_Width__c = 41.2;
        items.add(solarmount);

        insert items;

        //monitoring configurations
        List<Monitoring_Configuration__c> monitoringConfigList = new List<Monitoring_Configuration__c>();
        Monitoring_Configuration__c monitoringConfiguration = new Monitoring_Configuration__c();
        monitoringConfiguration.Name = 'SMS Monitoring Kit';
        monitoringConfigList.add(monitoringConfiguration);

        Monitoring_Configuration__c monitoringConfiguration2 = new Monitoring_Configuration__c();
        monitoringConfiguration2.Name = 'PVS Monitoring Kit';
        monitoringConfigList.add(monitoringConfiguration2);
        insert monitoringConfigList;

        //monitoring item junctions
        List<Monitoring_Item_junction__c> monitoringJunctions = new List<Monitoring_Item_junction__c>();
        Monitoring_Item_junction__c monitoringItemJunction = new Monitoring_Item_junction__c();
        monitoringItemJunction.Monitoring_Configuration__c = monitoringConfiguration.id;
        monitoringItemJunction.Item__c = monitoringItem.id;
        monitoringJunctions.add(monitoringItemJunction);

        Monitoring_Item_Junction__c monitoringItemJunction2 = new Monitoring_Item_Junction__c();
        monitoringItemJunction2.Monitoring_Configuration__c = monitoringConfiguration2.Id;
        monitoringItemJunction2.Item__c = monitoringItem2.Id;
        monitoringJunctions.add(monitoringItemJunction2);
        insert monitoringJunctions;

        //module configurator
        List<Module_Configuration__c> configData = new List<Module_Configuration__c>();
        //module configurator for module & inverter
        Module_Configuration__c panelConfigurator = new Module_Configuration__c();
        panelConfigurator.Item__c = moduleItem.Id;
        panelConfigurator.Name = 'Test Panel';
        panelConfigurator.Current_Type__c = 'DC';
        configData.add(panelConfigurator);

        Module_Configuration__c acConfigurator = new Module_Configuration__c();
        acConfigurator.Item__c = moduleItem.Id;
        acConfigurator.Name = 'Test Panel';
        acConfigurator.Current_Type__c = 'AC';
        configData.add(acConfigurator);
        insert configData;

        List<Inverter_Configuration__c> inverterConfigs = new List<Inverter_Configuration__c>();
        Inverter_Configuration__c inverter1 = new Inverter_Configuration__c();
        inverter1.Item__c = inverterItem.Id;
        inverter1.Name = 'SMA Inverter1';
        inverter1.Inverter_Manufacturer__c = 'SMA';
        inverter1.Monitoring__c = monitoringConfiguration.Id;
        inverter1.Start_Date__c = Date.today().addDays(-1);
        inverter1.End_Date__c = Date.today().addDays(30);
        inverterConfigs.add(inverter1);

        Inverter_Configuration__c inverter2 = new Inverter_Configuration__c();
        inverter2.Item__c = inverterItem.Id;
        inverter2.Name = 'MicroInverter';
        inverter2.Inverter_Manufacturer__c = 'Microinverter';
        inverter2.Monitoring__c = monitoringConfiguration2.Id;
        inverter2.Start_Date__c = Date.today().addDays(-1);
        inverter2.End_Date__c = Date.today().addDays(30);
        inverterConfigs.add(inverter2);

        //Storage Ready Inverter - HI Storage additions
        Inverter_Configuration__c inverter3 = new Inverter_Configuration__c();
        inverter3.Item__c = inverterItem2.Id;
        inverter3.Name = 'SolarEdge Storage Inverter';
        inverter3.Inverter_Manufacturer__c = 'SolarEdge';
        inverter3.Monitoring__c = monitoringConfiguration2.Id;
        inverter3.Start_Date__c = Date.today().addDays(-1);
        inverter3.End_Date__c = Date.today().addDays(30);
        inverter3.Storage_Ready_Inverter__c = true;
        inverterConfigs.add(inverter3);
        insert inverterConfigs;

        //Storage Configs - HI Storage
        Storage_Configuration__c storageConfig = new Storage_Configuration__c();
        storageConfig.Item__c = storageUnit.Id;
        insert storageConfig;

        //Storage Accessories - HI Storage
        List<Storage_Item_Junction__c> storageAccessories = new List<Storage_Item_Junction__c>();
        Storage_Item_Junction__c sij1 = new Storage_Item_Junction__c();
        sij1.Item__c = meterItem.Id;
        sij1.Storage_Configuration__c = storageConfig.Id;
        storageAccessories.add(sij1);

        Storage_Item_Junction__c sij2 = new Storage_Item_Junction__c();
        sij2.Item__c = transformerItem.Id;
        sij2.Storage_Configuration__c = storageConfig.Id;
        storageAccessories.add(sij2);
        insert storageAccessories;

        //Storage/Inverter Junction
        Inverter_Storage_Junction__c isj = new Inverter_Storage_Junction__c();
        isj.Inverter_Configuration__c = inverter3.Id;
        isj.Storage_Configuration__c = storageConfig.Id;
        insert isj;

        List<ModuleInverterJunction__c> modInvJunctions = new List<ModuleInverterJunction__c>();
        ModuleInverterJunction__c mij1 = new ModuleInverterJunction__c();
        mij1.Module_Configuration__c = panelConfigurator.Id;
        mij1.Inverter_Configuration__c = inverter1.Id;
        modInvJunctions.add(mij1);

        ModuleInverterJunction__c mij2 = new ModuleInverterJunction__c();
        mij2.Module_Configuration__c = acConfigurator.Id;
        mij2.Inverter_Configuration__c = inverter2.Id;
        modInvJunctions.add(mij2);

        ModuleInverterJunction__c mij3 = new ModuleInverterJunction__c();
        mij3.Module_Configuration__c = panelConfigurator.Id;
        mij3.Inverter_Configuration__c = inverter3.Id;
        modInvJunctions.add(mij3);

        insert modInvJunctions;

        //Racking configurations
        List<Racking_Configuration__c> rackingConfigs = new List<Racking_Configuration__c>();
        Racking_Configuration__c racking = new Racking_Configuration__c();
        racking.Name = 'Invisimount';
        racking.Type__c = 'Invisimount';
        racking.Kit_size__c = 2;
        rackingConfigs.add(racking);

        Racking_Configuration__c racking2 = new Racking_Configuration__c();
        racking2.Name = 'InvisiMount 10kw';
        racking2.Type__c = 'InvisiMount';
        racking2.Kit_size__c = 10;
        rackingConfigs.add(racking2);

        Racking_Configuration__c SMracking = new Racking_Configuration__c();
        SMracking.Name = 'SolarMount';
        SMracking.Type__c = 'SolarMount';
        rackingConfigs.add(SMracking);

        insert rackingConfigs;

        List<Racking_Item_Junction__c> rijs = new List<Racking_Item_Junction__c>();
        Racking_Item_Junction__c rij1 = new Racking_Item_Junction__c();
        rij1.Name = 'Invisimount';
        rij1.Item__c = invisimount.Id;
        rij1.Racking_Configuration__c = racking.Id;
        rijs.add(rij1);

        Racking_Item_Junction__c rij2 = new Racking_Item_Junction__c();
        rij2.Name = 'SolarMount';
        rij2.Item__c = solarmount.Id;
        rij2.Racking_Configuration__c = SMracking.Id;
        rijs.add(rij2);

        Racking_Item_Junction__c rij3 = new Racking_Item_Junction__c();
        rij3.Name = 'Invisimount 10 kW';
        rij3.Item__c = invisimount2.id;
        rij3.Racking_Configuration__c = racking2.Id;
        rijs.add(rij3);

        insert rijs;

        List<ModuleRackingJunction__c> mrJunctions = new List<ModuleRackingJunction__c>();

        //Invisimount 2kW  -DC Module
        ModuleRackingJunction__c inv2KJunction = new ModuleRackingJunction__c();
        inv2KJunction.Module_Configuration__c = panelConfigurator.Id;
        inv2KJunction.Racking_Configuration__c = racking.Id;
        mrJunctions.add(inv2KJunction);

        //Invisimount 10kW - DC Module
        ModuleRackingJunction__c inv10kJunction = new ModuleRackingJunction__c();
        inv10kJunction.Module_Configuration__c = panelConfigurator.Id;
        inv10kJunction.Racking_Configuration__c = racking2.Id;
        mrJunctions.add(inv10kJunction);

        //SolarMount 1kW - DC Module
        ModuleRackingJunction__c SMrackingConfigJunction = new ModuleRackingJunction__c();
        SMrackingConfigJunction.Module_Configuration__c = panelConfigurator.Id;
        SMrackingConfigJunction.Racking_Configuration__c = SMracking.Id;
        mrJunctions.add(SMrackingConfigJunction);

        //Invisimount 2kW  -AC Module
        ModuleRackingJunction__c inv2KJunction2 = new ModuleRackingJunction__c();
        inv2KJunction2.Module_Configuration__c = acConfigurator.Id;
        inv2KJunction2.Racking_Configuration__c = racking.Id;
        mrJunctions.add(inv2KJunction2);

        //Invisimount 10kW - AC Module
        ModuleRackingJunction__c inv10kJunction2 = new ModuleRackingJunction__c();
        inv10kJunction2.Module_Configuration__c = acConfigurator.Id;
        inv10kJunction2.Racking_Configuration__c = racking2.Id;
        mrJunctions.add(inv10kJunction2);

        //SolarMount 1kW - AC Module
        ModuleRackingJunction__c SMrackingConfigJunction2 = new ModuleRackingJunction__c();
        SMrackingConfigJunction2.Module_Configuration__c = acConfigurator.Id;
        SMrackingConfigJunction2.Racking_Configuration__c = SMracking.Id;
        mrJunctions.add(SMrackingConfigJunction2);

        insert mrJunctions;

        //Master Collections
        List<Master_Configurator__c> masters = new List<Master_Configurator__c>();
        Master_Configurator__c master1 = new Master_Configurator__c();
        master1.Name = 'DC MASTER1';
        master1.Configuration_Model__c = 'DC';
        masters.add(master1);

        Master_Configurator__c master2 = new Master_Configurator__c();
        master2.Name = 'AC MASTER1';
        master2.Configuration_Model__c = 'AC';
        masters.add(master2);

        Master_Configurator__c master3 = new Master_Configurator__c();
        master3.Name = 'EQ MASTER1';
        master3.Configuration_Model__c = 'Equinox';
        masters.add(master3);
        insert masters;

        //Link masters to inverters
        List<MasterModuleInverterJunction__c> masterModInvList = new List<MasterModuleInverterJunction__c>();
        MasterModuleInverterJunction__c mmij1 = new MasterModuleInverterJunction__c();
        mmij1.Master_Configuration__c = master1.Id;
        mmij1.ModuleInverterJunction__c = mij1.Id;
        masterModInvList.add(mmij1);

        MasterModuleInverterJunction__c mmij2 = new MasterModuleInverterJunction__c();
        mmij2.Master_Configuration__c = master2.Id;
        mmij2.ModuleInverterJunction__c = mij2.Id;
        masterModInvList.add(mmij2);


        MasterModuleInverterJunction__c mmij3 = new MasterModuleInverterJunction__c();
        mmij3.Master_Configuration__c = master3.Id;
        mmij3.ModuleInverterJunction__c = mij2.Id;
        masterModInvList.add(mmij3);

        MasterModuleInverterJunction__c mmij4 = new MasterModuleInverterJunction__c();
        mmij4.Master_Configuration__c = master1.Id;
        mmij4.ModuleInverterJunction__c = mij3.Id;
        masterModInvList.add(mmij4);
        insert masterModInvList;

        //Link masters to racking
        List<MasterModuleRacking_Junction__c> masterModRackList = new List<MasterModuleRacking_Junction__c>();
        MasterModuleRacking_Junction__c mmrj1 = new MasterModuleRacking_Junction__c();
        mmrj1.Master_Configurator__c = master1.Id;
        mmrj1.ModuleRackingJunction__c = inv2KJunction.Id;
        masterModRackList.add(mmrj1);

        MasterModuleRacking_Junction__c mmrj2 = new MasterModuleRacking_Junction__c();
        mmrj2.Master_Configurator__c = master1.Id;
        mmrj2.ModuleRackingJunction__c = inv10KJunction.Id;
        masterModRackList.add(mmrj2);

        MasterModuleRacking_Junction__c mmrj3 = new MasterModuleRacking_Junction__c();
        mmrj3.Master_Configurator__c = master1.Id;
        mmrj3.ModuleRackingJunction__c = SMrackingConfigJunction.Id;
        masterModRackList.add(mmrj3);

        MasterModuleRacking_Junction__c mmrj4 = new MasterModuleRacking_Junction__c();
        mmrj4.Master_Configurator__c = master2.Id;
        mmrj4.ModuleRackingJunction__c = inv2KJunction.Id;
        masterModRackList.add(mmrj4);

        MasterModuleRacking_Junction__c mmrj5 = new MasterModuleRacking_Junction__c();
        mmrj5.Master_Configurator__c = master2.Id;
        mmrj5.ModuleRackingJunction__c = inv10KJunction.Id;
        masterModRackList.add(mmrj5);

        MasterModuleRacking_Junction__c mmrj6 = new MasterModuleRacking_Junction__c();
        mmrj6.Master_Configurator__c = master2.Id;
        mmrj6.ModuleRackingJunction__c = SMrackingConfigJunction.Id;
        masterModRackList.add(mmrj6);

        MasterModuleRacking_Junction__c mmrj7 = new MasterModuleRacking_Junction__c();
        mmrj7.Master_Configurator__c = master3.Id;
        mmrj7.ModuleRackingJunction__c = inv2KJunction.Id;
        masterModRackList.add(mmrj7);

        MasterModuleRacking_Junction__c mmrj8 = new MasterModuleRacking_Junction__c();
        mmrj8.Master_Configurator__c = master3.Id;
        mmrj8.ModuleRackingJunction__c = inv10KJunction.Id;
        masterModRackList.add(mmrj8);
        insert masterModRackList;

        //Sales specific configuration
        List<SalesConfiguration__c> salesConfigs = new List<SalesConfiguration__c>();
        SalesConfiguration__c salesConfig1 = new SalesConfiguration__c();
        salesConfig1.Active__c = true;
        salesConfig1.Channel__c = 'Indirect';
        salesConfig1.Financial_Offering__c = 'Cash';
        salesConfig1.Operating_Unit__c = 'SPNA OU';
        salesConfig1.SalesMethodology__c = 'Order';
        salesConfig1.Sector__c = 'Residential';
        salesConfig1.State__c = 'CO';
        salesConfig1.Configurator__c = master1.Id;
        salesConfigs.add(salesConfig1);

        SalesConfiguration__c salesConfig2 = new SalesConfiguration__c();
        salesConfig2.Active__c = true;
        salesConfig2.Channel__c = 'Indirect';
        salesConfig2.Financial_Offering__c = 'Cash';
        salesConfig2.Operating_Unit__c = 'SPNA OU';
        salesConfig2.SalesMethodology__c = 'Order';
        salesConfig2.Sector__c = 'Residential';
        salesConfig2.State__c = 'CO';
        salesConfig2.Configurator__c = master2.Id;
        salesConfigs.add(salesConfig2);

        SalesConfiguration__c salesConfig3 = new SalesConfiguration__c();
        salesConfig3.Active__c = true;
        salesConfig3.Channel__c = 'Indirect';
        salesConfig3.Financial_Offering__c = 'Cash';
        salesConfig3.Operating_Unit__c = 'SPNA OU';
        salesConfig3.SalesMethodology__c = 'Order';
        salesConfig3.Sector__c = 'Residential';
        salesConfig3.State__c = 'CO';
        salesConfig3.Configurator__c = master3.Id;
        salesConfigs.add(salesConfig3);
        
        SalesConfiguration__c salesConfig4 = new SalesConfiguration__c();
        salesConfig4.Active__c = true;
        salesConfig4.Channel__c = 'Indirect';
        salesConfig4.Financial_Offering__c = 'Cash';
        salesConfig4.Operating_Unit__c = 'SPNA OU';
        salesConfig4.SalesMethodology__c = 'Quote';
        salesConfig4.Sector__c = 'Residential';
        salesConfig4.State__c = 'CO';
        salesConfig4.Configurator__c = master3.Id;
        salesConfigs.add(salesConfig4);
        
        insert salesConfigs;

        return priceList;
    }

    public static void createModuleInverterRatios()
    {
        List<ModuleInverterRatio__c> mirs = new List<ModuleInverterRatio__c>();

        ModuleInverterRatio__c mir1 = new ModuleInverterRatio__c();
        mir1.Name = '1';
        mir1.InverterModule_Ratio__c = 1.2;
        mir1.Total_System_Size_Max__c = 7;
        mir1.Total_System_Size_Min__c = 0;
        mirs.add(mir1);

        ModuleInverterRatio__c mir2 = new ModuleInverterRatio__c();
        mir2.Name = '2';
        mir2.InverterModule_Ratio__c = 1.1;
        mir2.Total_System_Size_Max__c = 30;
        mir2.Total_System_Size_Min__c = 7;
        mirs.add(mir2);

        ModuleInverterRatio__c mir3 = new ModuleInverterRatio__c();
        mir3.Name = '3';
        mir3.InverterModule_Ratio__c = 1.0;
        mir3.Total_System_Size_Max__c = 1000000000;
        mir3.Total_System_Size_Min__c = 30;
        mirs.add(mir3);

        insert mirs;

        //HI Storage addition
        Storage_Inverter_Module_Ratio__c simr1 = new Storage_Inverter_Module_Ratio__c();
        simr1.Name = '1';
        simr1.Inverter_Module_Ratio__c = 1.52;
        simr1.Total_System_Size_Max__c = 1000000000;
        simr1.Total_System_Size_Min__c = 0;
        insert simr1;
    }


    /* - DO NOT REMOVE: this service is not deployed in production yet, hecne was not copied to this instance,
but will be used for tests -
public static List<RESTDocumentRequestSettings__c> buildDocumentSettings()
{
List<RESTDocumentRequestSettings__c> result = new List<RESTDocumentRequestSettings__c>();
result.add(new RESTDocumentRequestSettings__c(sObjectName__c = 'Attachment', Name='ID', FieldAPIName__c = 'ID', JSONName__c = 'attachmentID', OutboundType__c = 'String'));
result.add(new RESTDocumentRequestSettings__c(sObjectName__c = 'Attachment', Name='Body', FieldAPIName__c = 'Body', JSONName__c = 'body', OutboundType__c = 'Blob'));
result.add(new RESTDocumentRequestSettings__c(sObjectName__c = 'Attachment', Name='Content Type', FieldAPIName__c = 'ContentType', JSONName__c = 'contentType', OutboundType__c = 'String'));
result.add(new RESTDocumentRequestSettings__c(sObjectName__c = 'Attachment', Name='Name', FieldAPIName__c = 'Name', JSONName__c = 'fileName', OutboundType__c = 'String'));
result.add(new RESTDocumentRequestSettings__c(sObjectName__c = 'Attachment', Name='Parent ID', FieldAPIName__c = 'ParentID', JSONName__c = 'parentID', OutboundType__c = 'String'));

return result;
}
*/
}