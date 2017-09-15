/**
 * Created by cdevarapalli on 3/17/17.
 */

@IsTest
private class GenabilityUsageController_TEST {

    public static Account customerAccount;
    public static Account customerAccountERUI;
    public static GenabilityUsageController guCtrl;
    public static Contact customerContact;
    public static Opportunity customerOpportunity;
    public static Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
    public static HttpCalloutMock multiCalloutMock;

    @testSetup
    static void setup() {
        insert new List<Loan_Callout_Settings__c>{
                new Loan_Callout_Settings__c(Name ='Genability', Client_ID__c = 'clientID', Key__c = 'key', Endpoint_URL__c = 'https://api.genability.com')
        };


    }

    static{
        customerAccount = TestFactory_StandardObjects.createResidentialCustomerAccount();
        customerAccount.BillingState = 'CA';
        customerAccount.BillingStreet = '76 Rio Robles';
        customerAccount.BillingPostalCode = '95134';
        customerAccount.BillingCountry = 'US';
        customerAccount.BillingCity = 'San Jose';
        insert customerAccount;

        customerContact = TestFactory_StandardObjects.createCustomerContact(customerAccount.Id);
        insert customerContact;

        customerOpportunity = TestUtils.createOpportunities(1, customerAccount.id, customerContact.Id, true).get(0);

        insert new List<Credit_Check_Request__c>{
                new Credit_Check_Request__c(Account__c = customerContact.AccountId, Application_Type__c = 'LOAN', Application_Id__c = String.valueOf(customerOpportunity.Id), Contact__c = customerContact.Id, Credit_Beureu__c = 'Mosaic', First_Name__c = customerContact.FirstName, Last_Name__c = customerContact.LastName, Status__c = 'Submitted', Email__c = customerContact.Email, Credit_Check_Submission_Date__c = Date.today()),
                new Credit_Check_Request__c(Account__c = customerContact.AccountId, Application_Type__c = 'LEASE', Contact__c = customerContact.Id, Credit_Beureu__c = 'LoanPath', First_Name__c = customerContact.FirstName, Last_Name__c = customerContact.LastName, Status__c = 'Submitted', Email__c = customerContact.Email, Credit_Check_Submission_Date__c = Date.today())
        };

        //Account Creation
        String accountJSONString = '{"status":"success","count":1,"type":"Account","results":[{"accountId":"86253a92-28c2-431d-86c1-2414945f2283","providerAccountId":"001M000000xQB9oIAG","accountName":"Roof Test","customerOrgId":null,"customerOrgName":null,"address":{"addressString":null,"address1":"457 Walsh Rd","city":"Atherton","state":"CA","zip":"94027","country":"US","lon":-122.2226493,"lat":37.4273484},"status":"ACTIVE","type":null,"accountManager":null,"assignee":null,"contacts":null,"properties":{"customerClass":{"keyName":"customerClass","dataType":"CHOICE","dataValue":"1"},"lseId":{"keyName":"lseId","displayName":"Pacific Gas & Electric Co","dataType":"INTEGER","dataValue":"734","accuracy":57.49000000},"territoryId":{"keyName":"territoryId","dataType":"INTEGER","dataValue":"3541","accuracy":100.00000000}},"tariffs":[{"masterTariffId":522,"tariffCode":"E-1","tariffName":"Residential","lseId":734,"lseName":"Pacific Gas & Electric Co","customerClass":null,"customerLikelihood":57.49000000,"endDate":null,"timeZone":"US/Pacific","billingPeriod":"MONTHLY","currency":"USD"}],"projects":null}]}';
        TestHttpCalloutMock accountCreationSuccessResponse = new TestHttpCalloutMock(200, 'success', accountJSONString, null);
        String endpointURL = 'https://api.genability.com/rest/v1/accounts';
        endpoint2TestResp.put(endpointURL, accountCreationSuccessResponse);


        customerAccountERUI = new Account();
        customerAccountERUI.FirstName = 'customerAccountERUI';
        customerAccountERUI.LastName = 'TestGUC_Test2';
        customerAccountERUI.BillingState = 'CA';
        customerAccountERUI.BillingStreet = '77 Rio Robles';
        customerAccountERUI.BillingPostalCode = '95134';
        customerAccountERUI.BillingCountry = 'US';
        customerAccountERUI.BillingCity = 'San Jose';
        //customerAccountERUI.Genability_Account_Id__c = 'testcustomerAccountERUIGenabilityAccountId';
        insert customerAccountERUI;

        insert new Electric_Rate_Usage_Input__c(Account__c = customerAccountERUI.Id,
                                                Current_Rate__c = '523',
                                                Current_rate_code__c = 'CurrentRateCode',
                                                Proposed_rate__c = '523',
                                                Proposed_rate_code__c = 'ProposedRateCode',
                                                Monthly_Jan__c = 350.00,
                                                Monthly_Feb__c = 350.00,
                                                Monthly_Mar__c = 350.00,
                                                Monthly_Apr__c = 350.00,
                                                Monthly_May__c = 350.00,
                                                Monthly_Jun__c = 350.00,
                                                Monthly_Jul__c = 350.00,
                                                Monthly_Aug__c = 350.00,
                                                Monthly_Sep__c = 350.00,
                                                Monthly_Oct__c = 350.00,
                                                Monthly_Nov__c = 350.00,
                                                Monthly_Dec__c = 350.00,
                                                Genability_Profile_Id__c = 'genabilityProfileId');

        //Get Tariffs
        String todayDate = datetime.now().format('yyyy-MM-dd').replace('_','');
        //String tariffsJSONString = '{"status": "success","count": 49,"type": "Tariff","results": [    {        "tariffId": 3278543,        "masterTariffId": 522,        "tariffCode": "E-1",        "tariffName": "Residential",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270769,        "tariffType": "DEFAULT",        "customerClass": "RESIDENTIAL",        "customerCount": 3321385,        "customerLikelihood": 58.46,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": false,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true,    "properties": [{    "keyName": "isNEM2",    "quantityKey": null,    "displayName": "Is NEM2 Tariff",    "family": "billing",    "keyspace": "electricity",    "description": "Is this a California NEM 2.0 tariff.  True is a NEM 2.0 tariff, false is NOT a NEM 2.0 tariff.",    "dataType": "BOOLEAN",    "propertyTypes": "APPLICABILITY",    "operator": "=",    "propertyValue": "false",    "isDefault": true},{    "keyName": "solarPvEligible",    "quantityKey": null,    "displayName": "Solar PV Eligible",    "family": "system",    "keyspace": "solarPV",    "description": "Whether a tariff can be selected if solar PV is installed.  ",    "dataType": "BOOLEAN",    "propertyTypes": "APPLICABILITY",    "operator": "=",    "propertyValue": "false",    "isDefault": true} ]    },    {        "tariffId": 3278540,        "masterTariffId": 3154331,        "tariffCode": "E-1-CARE",        "tariffName": "Residential - CARE",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270772,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 1213974,        "customerLikelihood": 21.37,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": false,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true,   "properties": [{    "keyName": "isNEM2",    "quantityKey": null,    "displayName": "Is NEM2 Tariff",    "family": "billing",    "keyspace": "electricity",    "description": "Is this a California NEM 2.0 tariff.  True is a NEM 2.0 tariff, false is NOT a NEM 2.0 tariff.",    "dataType": "BOOLEAN",    "propertyTypes": "APPLICABILITY",    "operator": "=",    "propertyValue": "false",    "isDefault": true},{    "keyName": "solarPvEligible",    "quantityKey": null,    "displayName": "Solar PV Eligible",    "family": "system",    "keyspace": "solarPV",    "description": "Whether a tariff can be selected if solar PV is installed.  ",    "dataType": "BOOLEAN",    "propertyTypes": "APPLICABILITY",    "operator": "=",    "propertyValue": "true",    "isDefault": true} ]    },    {        "tariffId": 3278542,        "masterTariffId": 521,        "tariffCode": "E-1-EH",        "tariffName": "Residential - Electric Heat",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270770,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 1078966,        "customerLikelihood": 18.99,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": false,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278541,        "masterTariffId": 3153890,        "tariffCode": "E-1-FERA",        "tariffName": "Residential - FERA",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270771,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 65487,        "customerLikelihood": 1.15,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": false,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278520,        "masterTariffId": 3250619,        "tariffCode": "E-TOU-A-NEM2",        "tariffName": "Residential - Time of Use - Rate A (NEM 2.0)",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270907,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 1000,        "customerLikelihood": 0.02,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "HOURLY",        "hasTimeOfUseRates": true,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278518,        "masterTariffId": 3250692,        "tariffCode": "E-TOU-B-NEM2",        "tariffName": "Residential - Time of Use - Rate B (NEM 2.0)",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270909,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 345,        "customerLikelihood": 0.01,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "HOURLY",        "hasTimeOfUseRates": true,        "hasTieredRates": false,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278523,        "masterTariffId": 3251054,        "tariffCode": "E-TOU-A",        "tariffName": "Residential - Time of Use",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270905,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 125,        "customerLikelihood": 0,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": true,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278519,        "masterTariffId": 3251052,        "tariffCode": "E-TOU-B",        "tariffName": "Residential - Time of Use - Rate B",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270910,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 85,        "customerLikelihood": 0,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": true,        "hasTieredRates": false,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    }        ],"pageStart": 0,"pageCount": 100}';
        String tariffsJSONString = '{"status": "success","count": 49,"type": "Tariff","results": [    {        "tariffId": 3278543,        "masterTariffId": 522,        "tariffCode": "E-1",        "tariffName": "Residential",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270769,        "tariffType": "DEFAULT",        "customerClass": "RESIDENTIAL",        "customerCount": 3321385,        "customerLikelihood": 58.46,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": false,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,     "isActive": true,	"properties": [ {    "keyName": "isNEM2",    "quantityKey": null,    "displayName": "Is NEM2 Tariff",    "family": "billing",    "keyspace": "electricity",    "description": "Is this a California NEM 2.0 tariff.  True is a NEM 2.0 tariff, false is NOT a NEM 2.0 tariff.",    "dataType": "BOOLEAN",    "propertyTypes": "APPLICABILITY",    "operator": "=",    "propertyValue": "false",    "isDefault": true},{    "keyName": "solarPvEligible",    "quantityKey": null,    "displayName": "Solar PV Eligible",    "family": "system",    "keyspace": "solarPV",    "description": "Whether a tariff can be selected if solar PV is installed.  ",    "dataType": "BOOLEAN",    "propertyTypes": "APPLICABILITY",    "operator": "=",    "propertyValue": "false",    "isDefault": true} ]    },    {        "tariffId": 3278540,        "masterTariffId": 3154331,        "tariffCode": "E-1-CARE",        "tariffName": "Residential - CARE",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270772,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 1213974,        "customerLikelihood": 21.37,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": false,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278542,        "masterTariffId": 521,        "tariffCode": "E-1-EH",        "tariffName": "Residential - Electric Heat",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270770,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 1078966,        "customerLikelihood": 18.99,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": false,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278541,        "masterTariffId": 3153890,        "tariffCode": "E-1-FERA",        "tariffName": "Residential - FERA",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270771,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 65487,        "customerLikelihood": 1.15,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": false,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278520,        "masterTariffId": 3250619,        "tariffCode": "E-TOU-A-NEM2",        "tariffName": "Residential - Time of Use - Rate A (NEM 2.0)",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270907,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 1000,        "customerLikelihood": 0.02,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "HOURLY",        "hasTimeOfUseRates": true,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278518,        "masterTariffId": 3250692,        "tariffCode": "E-TOU-B-NEM2",        "tariffName": "Residential - Time of Use - Rate B (NEM 2.0)",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270909,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 345,        "customerLikelihood": 0.01,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "HOURLY",        "hasTimeOfUseRates": true,        "hasTieredRates": false,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278523,        "masterTariffId": 3251054,        "tariffCode": "E-TOU-A",        "tariffName": "Residential - Time of Use",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270905,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 125,        "customerLikelihood": 0,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": true,        "hasTieredRates": true,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    },    {        "tariffId": 3278519,        "masterTariffId": 3251052,        "tariffCode": "E-TOU-B",        "tariffName": "Residential - Time of Use - Rate B",        "lseId": 734,        "lseName": "Pacific Gas & Electric Co",        "priorTariffId": 3270910,        "tariffType": "ALTERNATIVE",        "customerClass": "RESIDENTIAL",        "customerCount": 85,        "customerLikelihood": 0,        "territoryId": 807,        "effectiveDate": "2017-03-01",        "endDate": null,        "timeZone": "US/Pacific",        "billingPeriod": "MONTHLY",        "currency": "USD",        "chargeTypes": "FIXED_PRICE,CONSUMPTION_BASED,QUANTITY,MINIMUM",        "chargePeriod": "DAILY",        "hasTimeOfUseRates": true,        "hasTieredRates": false,        "hasContractedRates": false,        "hasRateApplicability": true,        "isActive": true    }        ],"pageStart": 0,"pageCount": 100}';
        TestHttpCalloutMock getTariffsSuccessResponse = new TestHttpCalloutMock(200, 'success', tariffsJSONString, null);
        endpointURL = 'https://api.genability.com/rest/public/tariffs?zipCode='+customerAccount.BillingPostalCode +'&populateProperties=true&customerClasses=Residential&pageCount=100&pageStart=0&effectiveOn='+todayDate+'&openOn='+todayDate+
                      '&tariffTypes=DEFAULT,ALTERNATIVE&serviceTypes=ELECTRICITY&sortOn=customerLikelihood,tariffType&sortOrder=DESC,ASC';
        endpoint2TestResp.put(endpointURL, getTariffsSuccessResponse);

        //Set Tariff on Genability Account
        String setPropertyJSONString = '{"status": "success", "count": 1, "type": "PropertyData", "results": [{"keyName": "masterTariffId", "dataValue": "522", "accuracy": 100}]}';
        TestHttpCalloutMock setPropertySuccessResponse = new TestHttpCalloutMock(200, 'success', setPropertyJSONString, null);
        endpointURL = 'https://api.genability.com/rest/v1/accounts/pid/'+customerAccountERUI.Id+'/properties';
        endpoint2TestResp.put(endpointURL, setPropertySuccessResponse);


        //Get kWh Value
        String getkWhValueSuccessSONString = '{    "status": "success",    "count": 1,    "type": "CalculatedCost",    "results": [        {            "masterTariffId": 3155765,            "tariffName": "MultiFamily",            "totalCost": 1195.82,            "fromDateTime": "2016-03-15T00:00:00-07:00",            "toDateTime": "2017-03-14T00:00:00-07:00",            "currency": "USD",            "summary": {                "subTotalCost": 1195.82,                "taxCost": 0,                "totalCost": 1195.82,                "adjustedTotalCost": 1141.12,                "kWh": 5467.63,                "kW": 1.61            },            "accuracy": 0        }    ]}';
        TestHttpCalloutMock getKWHSuccessResponse = new TestHttpCalloutMock(200, 'success', getkWhValueSuccessSONString, null);
        endpointURL = 'https://api.genability.com/rest/v1/calculate';
        endpoint2TestResp.put(endpointURL, getKWHSuccessResponse);


        //Upsert Usage Profile
        String upsertUPSuccessJSONString = '{"status":"success","count":1,"type":"UsageProfile","results":[{"profileId":"58ffb9b25f9dcc9dc1eec415","providerProfileId":"a3TK0000000ncUyMAI","profileName":"0013400001QyUwbAAF","accountId":"62a65918-0047-4c17-ad6e-a18d355af2a6","description":"Aaron Compiotti","serviceTypes":"ELECTRICITY","source":{"sourceId":"ReadingEntry","name":"Readings","type":"Reading","sourceVersion":null},"isDefault":true,"dataStatus":2,"properties":null,"readingDataSummaries":[{"quantityUnit":"kWh","fromDateTime":"2016-04-23T23:00:00+00:00","toDateTime":"2017-04-24T23:00:00+00:00","numberOfReadings":1}],"baselineMeasures":null}]}';
        TestHttpCalloutMock upsertUPSuccessResponse = new TestHttpCalloutMock(200, 'success', upsertUPSuccessJSONString, null);
        endpointURL = 'https://api.genability.com/rest/v1/profiles';
        endpoint2TestResp.put(endpointURL, upsertUPSuccessResponse);

        //Delete Usage Profile
        String deleteUPSuccessJSONString = '{"status": "success","count": 0,"type": "UsageProfile","results": null}';
        TestHttpCalloutMock deleteUPSuccessResponse = new TestHttpCalloutMock(200,'success', deleteUPSuccessJSONString, null);
        endpointURL = 'https://api.genability.com/rest/v1/profiles/genabilityProfileId';
        endpoint2TestResp.put(endpointURL, deleteUPSuccessResponse);

        multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    }


    //No ElectricRateUsageInput
    static testMethod void testGenabilityUsageNoElectricRateUsageInput() {
        test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccount);
        Test.setCurrentPageReference(Page.GenabilityUsage);
        guCtrl = new GenabilityUsageController(sc);
        guCtrl.checkandCreateAccountinGenability();
        guCtrl.getElectricUsageRate();
        guCtrl.getElectricPropsedRate();
        test.stopTest();
    }


    //Testing Account with Electric Usage Input and Bill is monthly Average
    static testMethod void testGenabilityUsageWithElectricRateUsageInput1() {

        test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccountERUI);
        Test.setCurrentPageReference(Page.GenabilityUsage);
        guCtrl = new GenabilityUsageController(sc);
        guCtrl.checkandCreateElectricUsage();
        guCtrl.electricratecurrentselected = '523';
        guCtrl.electricrateproposedselected = '523';
        guCtrl.getElectricUsageRate();
        guCtrl.getElectricPropsedRate();
        guCtrl.editRates();
        guCtrl.billType = 'monthlyAverage';
        guCtrl.billAmount = 40.00;
        guCtrl.saveEU();
        test.stopTest();
    }

    //Testing Account with Electric Usage Input and Usage is MONTHLY ENERGY USAGE
    static testMethod void testGenabilityUsageWithElectricRateUsageInput2() {

        test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccountERUI);
        Test.setCurrentPageReference(Page.GenabilityUsage);
        guCtrl = new GenabilityUsageController(sc);
        guCtrl.checkandCreateElectricUsage();
        guCtrl.usage = 'MONTHLY ENERGY USAGE';
        guCtrl.electricratecurrentselected = '523';
        guCtrl.electricrateproposedselected = '523';
        guCtrl.saveEU();
        test.stopTest();
    }


    //Test Bad Responses
    static testMethod void testGenabilityUsageBadResponses() {

        //Get Tariffs Error Response
        String todayDate = datetime.now().format('yyyy-MM-dd').replace('_','');
        String tariffsJSONString = '{"status": "error","count": 1,"type": "Error","results": [{"code": "typeMismatch", "message": null,"objectName": "getTariffsRestRequest","propertyName": "customerClasses"}]}';
        TestHttpCalloutMock getTariffsSuccessResponse = new TestHttpCalloutMock(400, 'error', tariffsJSONString, null);
        String endpointURL = 'https://api.genability.com/rest/public/tariffs?zipCode='+customerAccountERUI.BillingPostalCode+'&populateProperties=true&customerClasses=Residential&pageCount=100&pageStart=0&effectiveOn='+todayDate+'&openOn='+todayDate+
                             '&tariffTypes=DEFAULT,ALTERNATIVE&serviceTypes=ELECTRICITY&sortOn=customerLikelihood,tariffType&sortOrder=DESC,ASC';
        endpoint2TestResp.put(endpointURL, getTariffsSuccessResponse);

        //Set Tariff on Genability Account Error Response
        String setPropertyJSONString = '{"status": "error","count": 1,"type": "Error","results": [{"code": "typeMismatch", "message": null,"objectName": "getTariffsRestRequest","propertyName": "customerClasses"}]}';
        TestHttpCalloutMock setPropertySuccessResponse = new TestHttpCalloutMock(400, 'error', setPropertyJSONString, null);
        endpointURL = 'https://api.genability.com/rest/v1/accounts/pid/'+customerAccountERUI.Id+'/properties';
        endpoint2TestResp.put(endpointURL, setPropertySuccessResponse);


        //Get kWh Value
        String getkWhValueSuccessSONString = '{"status": "error","count": 1,"type": "Error","results": [{"code": "typeMismatch", "message": null,"objectName": "getTariffsRestRequest","propertyName": "customerClasses"}]}';
        TestHttpCalloutMock getKWHSuccessResponse = new TestHttpCalloutMock(400, 'error', getkWhValueSuccessSONString, null);
        endpointURL = 'https://api.genability.com/rest/v1/calculate';
        endpoint2TestResp.put(endpointURL, getKWHSuccessResponse);

        //Upsert Usage Profile
        String upsertUPSuccessJSONString = '{"status": "error","count": 1,"type": "Error","results": [{"code": "typeMismatch", "message": null,"objectName": "getTariffsRestRequest","propertyName": "customerClasses"}]}';
        TestHttpCalloutMock upsertUPSuccessResponse = new TestHttpCalloutMock(400, 'success', upsertUPSuccessJSONString, null);
        endpointURL = 'https://api.genability.com/rest/v1/profiles';
        endpoint2TestResp.put(endpointURL, upsertUPSuccessResponse);

        //Delete Usage Profile
        String deleteUPSuccessJSONString = '{"status": "error","count": 1,"type": "Error","results": [{"code": "ObjectNotFound","message": "Requested resource is not available","objectName": "UsageProfile"}]}';
        TestHttpCalloutMock deleteUPSuccessResponse = new TestHttpCalloutMock(200,'success', deleteUPSuccessJSONString, null);
        endpointURL = 'https://api.genability.com/rest/v1/profiles/genabilityProfileId';
        endpoint2TestResp.put(endpointURL, deleteUPSuccessResponse);

        test.startTest();

        multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccountERUI);
        Test.setCurrentPageReference(Page.GenabilityUsage);
        guCtrl = new GenabilityUsageController(sc);
        guCtrl.checkandCreateElectricUsage();
        guCtrl.electricratecurrentselected = '5223';
        guCtrl.electricrateproposedselected = '5223';
        guCtrl.billType = 'totalYearly';
        guCtrl.billAmount = 400.00;
        guCtrl.editRates();
        guCtrl.saveEU();
        GenabilityAPICallHandler.GenabilityAccount gaga = GenabilityAPICallHandler.GetkWhValue(CustomerAccountERUI,String.valueOf(1200.00));
        guCtrl.upsertUsageProfile('BILL');
        test.stopTest();
    }

    //Test Bad Responses
    static testMethod void testGenabilityUsageBadResponsesAccountCreation() {

        //Account Creation Error Response
        String accountJSONString = '{"status": "error","count": 1,"type": "Error","results": [{"code": "typeMismatch", "message": null,"objectName": "getTariffsRestRequest","propertyName": "customerClasses"}]}';
        TestHttpCalloutMock accountCreationSuccessResponse = new TestHttpCalloutMock(400, 'error', accountJSONString, null);
        String endpointURL = 'https://api.genability.com/rest/v1/accounts';
        endpoint2TestResp.put(endpointURL, accountCreationSuccessResponse);

        test.startTest();

        multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        ApexPages.StandardController sc = new ApexPages.StandardController(CustomerAccount);
        Test.setCurrentPageReference(Page.GenabilityUsage);
        guCtrl = new GenabilityUsageController(sc);
        guCtrl.checkandCreateAccountinGenability();
        test.stopTest();
    }

}