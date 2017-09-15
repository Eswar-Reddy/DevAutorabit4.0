/**
 * Created by cdevarapalli on 3/22/17.
 * Test Methods for GenabilityAPICallHandler and Genability JSON Classes
 */

@isTest
private class GenabilityAPICallHandler_TEST {

    @testSetup
    static void setup() {
        insert new List<Loan_Callout_Settings__c>{
                new Loan_Callout_Settings__c(Name ='Genability', Client_ID__c = 'clientID', Key__c = 'key', Endpoint_URL__c = 'https://api.genability.com')
        };
    }

    //Coverage for GenabilityErrorJSON
    static testMethod void testGenabilityErrorJSONClass(){
        test.startTest();
        GenabilityErrorJSON.Error geJSONError = new GenabilityErrorJSON.Error();
        geJSONError.code = 'code';
        geJSONError.message = 'message';
        geJSONError.objectName = 'objectName';
        geJSONError.propertyName = 'propertyName';
        geJSONError.propertyValue = 'propertyValue';

        GenabilityErrorJSON genErrResp = new GenabilityErrorJSON();
        genErrResp.error = 'serror';
        genErrResp.count = 1;
        genErrResp.results = new List<GenabilityErrorJSON.Error>{geJSONError};
        test.stopTest();
    }

    //Coverage for CreateAccount and prepDebugLog
    static testMethod void testCreateGenabilityAccountandSpectrumDebugLog(){
        Account customerAccount = TestFactory_StandardObjects.createResidentialCustomerAccount();
        customerAccount.BillingPostalCode = '95134';
        customerAccount.Genability_Account_Id__c = 'testCGAGenabilityAccId';
        insert customerAccount;

        test.startTest();
        GenabilityAPICallHandler.CreateAccount(customerAccount);
        GenabilityAPICallHandler.prepDebugLog(customerAccount.Id, 'serviceName', new HttpRequest(), new HttpResponse());
        test.stopTest();

    }

    //Coverage for GenabilityTariffJSON
    static testMethod  void testGenabilityTariffJSONClass(){
        test.startTest();
        Datetime dtNow = System.now();
        GenabilityTariffJSON.TariffProperty gtTP = new GenabilityTariffJSON.TariffProperty();
        gtTP.keyName = 'isNEM2';
        gtTP.displayName = 'Is NEM2 Tariff';
        gtTP.family = 'billing';
        gtTP.keyspace = 'electricity';
        gtTP.description = 'Is this a California NEM 2.0 tariff. True is a NEM 2.0 tariff, false is NOT a NEM 2.0 tariff';
        gtTP.dataType = 'BOOLEAN';
        gtTP.propertyTypes = 'APPLICABILITY';
        gtTP.operator = '=';
        gtTP.propertyValue = 'false';
        gtTP.isDefault = true;
        gtTP.minValue = 'minValue';
        gtTP.maxValue = 'maxValue';
        gtTP.formulaDetail = 'formulaDetail';

        GenabilityTariffJSON.Tariff gtTariff = new GenabilityTariffJSON.Tariff();
        gtTariff.tariffId = 3278543;
        gtTariff.masterTariffId = 522;
        gtTariff.tariffCode = 'E-1';
        gtTariff.tariffName = 'Residential';
        gtTariff.lseId = 734;
        gtTariff.lseName = 'Pacific Gas & Electric Co';
        gtTariff.priorTariffId = 3270769;
        gtTariff.tariffType = 'DEFAULT';
        gtTariff.customerClass = 'RESIDENTIAL';
        gtTariff.customerCount = 3321385;
        gtTariff.customerLikelihood = 58.46;
        gtTariff.territoryId = '807';
        gtTariff.effectiveDate = dtNow;
        gtTariff.endDate = null;
        gtTariff.timeZone = 'US/Pacific';
        gtTariff.billingPeriod = 'MONTHLY';
        gtTariff.chargeTypes = 'FIXED_PRICE,CONSUMPTION_BASED,MINIMUM';
        gtTariff.chargePeriod = 'DAILY';
        gtTariff.hasTimeOfUseRates = false;
        gtTariff.hasTieredRates = true;
        gtTariff.hasContractedRates = false;
        gtTariff.hasRateApplicability = true;
        gtTariff.serviceType = 'serveType';
        gtTariff.distributionLseId = 876543;
        gtTariff.customerCountSource = 'customerCountSource';
        gtTariff.currency_x = 'currency_x';
        gtTariff.minMonthlyConsumption = 0.0;
        gtTariff.maxMonthlyConsumption = 0.0;
        gtTariff.minMonthlyDemand = 0.0;
        gtTariff.maxMonthlyDemand = 0.0;
        gtTariff.hasTariffApplicability = true;
        gtTariff.hasNetMetering = true;
        gtTariff.closedDate = System.now().Date();
        gtTariff.properties = new List<GenabilityTariffJSON.TariffProperty>{gtTP};

        GenabilityTariffJSON gtJSON = new GenabilityTariffJSON();
        gtJSON.status = 'status';
        gtJSON.count = 1;
        gtJSON.type = 'type';
        gtJSON.results = new List<GenabilityTariffJSON.Tariff>{gtTariff};

        test.stopTest();
    }

    //Coverage for GenabilityUsageProfileJSON
    static testMethod  void testGenabilityUsageProfileJSONClass(){
        test.startTest();
        List<GenabilityUsageProfileJSON.ReadingData> gupRDList = new List<GenabilityUsageProfileJSON.ReadingData>();

        gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(
                                                            'skeyName',
                                                            'dtfromDateTime',
                                                            'dttoDateTime',
                                                            'squantityUnit',
                                                             1200.00));

        GenabilityUsageProfileJSON.UsageProfile gupUP = new GenabilityUsageProfileJSON.UsageProfile();
        gupUP.providerAccountId = 'accId';
        gupUP.providerProfileId = 'eruiId';
        gupUP.profileId = 'profileId';
        gupUP.profileName = 'accId';
        gupUP.accountId = 'accountId';
        gupUP.description = 'accName';
        gupUP.isDefault = true;
        gupUP.serviceTypes = 'serviceTypes';
        gupUP.sourceId = 'sourceId';
        gupUP.dataStatus = 1;
        gupUP.readingData = gupRDList;

        GenabilityUsageProfileJSON gupJSON = new GenabilityUsageProfileJSON();
        gupJSON.status = 'status';
        gupJSON.count = 2;
        gupJSON.type = 'type';
        gupJSON.results = new List<GenabilityUsageProfileJSON.UsageProfile>{gupUP};

        test.stopTest();
    }
}