/**
 * Created by cdevarapalli on 3/7/17.
 * Class to make Genability API Calls
 */

public class GenabilityAPICallHandler {

    public static Loan_Callout_Settings__c genCS = Loan_Callout_Settings__c.getInstance('Genability');
    public static List<SpectrumDebugUtility.debugLog> spExLogsList = new List<SpectrumDebugUtility.debugLog>();

    //-------------------------------------------Create Account in Genability-----------------------------------------//
    public static GenabilityAccount CreateAccount(Account acc){

        GenabilityAccount ga = new GenabilityAccount();
        Http http = new Http();
        HttpRequest request = prepHttpReq();
        HttpResponse response = new HttpResponse();

        if(acc.Genability_Account_Id__c!=null){
            ga.genabilityAccountId = acc.Genability_Account_Id__c;
            return ga;
        }

        try{

            request.setHeader('Content-Type', 'application/json');
            request.setMethod('POST');
            request.setEndpoint(genCS.Endpoint_URL__c+'/rest/v1/accounts');

            GenabilityAccountJSON.Address accAddress = new GenabilityAccountJSON.Address(
                    null, //addressString
                    null, //addressName;
                    acc.BillingStreet != null ? acc.BillingStreet : null, //address1;
                    null, //address2
                    acc.BillingCity != null ? acc.BillingCity : null, //city
                    acc.BillingState != null? acc.BillingState : null, //state
                    acc.BillingPostalCode != null ? acc.BillingPostalCode :null, //zip
                    acc.BillingCountry != null ? (acc.BillingCountry.toUpperCase() == 'UNITED STATES' ? 'US': acc.BillingCountry)  : null, //country
                    null, //lon
                    null  //lat
            );

            GenabilityPropertyJSON.Property gaProperty =  new GenabilityPropertyJSON.Property('customerClass',null,null,
                                                                                                '1',null);
            Map<String,GenabilityPropertyJSON.Property> gapropertyMap = new Map<String,GenabilityPropertyJSON.Property>
                                                                                        {'customerClass' => gaProperty};
            GenabilityPropertyJSON gp = new GenabilityPropertyJSON(gapropertyMap);
                
            GenabilityAccountJSON.Account gAccount = new GenabilityAccountJSON.Account( acc.Id,
                    																	acc.Name,
                    																	accAddress,
                    																	gp.properties
            																		  );

            GenabilityAccountJSON genResp = new GenabilityAccountJSON();
            GenabilityErrorJSON genErrResp = new GenabilityErrorJSON();

            String gAccountJSONString = JSON.serializePretty(gAccount,true);
            System.debug('gAccountJSONString----->'+gAccountJSONString);
            request.setBody(gAccountJSONString);

            response = http.send(request);

            System.debug('response Status Code----->' + response.getStatusCode());
            System.debug('response body----->' + response.getBody());

            if (response.getStatusCode() == 200) {
                ga.callSuccess = true;
                genResp = (GenabilityAccountJSON) System.JSON.deserialize(response.getBody(), GenabilityAccountJSON.class);
                System.debug('genResp----->' + genResp);

                if(genResp.results[0].accountId != null){
                    ga.genabilityAccountId = genResp.results[0].accountId;
                    //Account newAcc = new Account( Id = acc.Id, Genability_Account_Id__c = ga.genabilityAccountId);
                    //update newAcc;
                }
                response = null;
            } else {
                genErrResp = (GenabilityErrorJSON) System.JSON.deserialize(response.getBody(), GenabilityErrorJSON.class);
                ga.errorMessage = getErrorMessage(genErrResp.results[0]);
                response = null;
            }

        }catch(Exception e){
            ga.errorMessage = e.getMessage();
            spExLogsList.add(prepDebugLog(acc.Id,'Genability CreateAccount',request,response));
        }
        return ga;
    }


    //--------------------------------------Get Tarriffs for a given ZipCode------------------------------------------//
    public static GenabilityTariff GetTariffsforaZipCode(Account acc, String customerClasses,
                                                            boolean populateProperties){
        GenabilityTariff gt = new GenabilityTariff();

        Http http = new Http();
        HttpRequest request = prepHttpReq();
        HttpResponse response = new HttpResponse();

        try{
            request.setMethod('GET');
            String todayDate = toDate().replace('_','');
            System.debug('todayDate----->'+todayDate);
            String requeString = genCS.Endpoint_URL__c + '/rest/public/tariffs?zipCode='+acc.BillingPostalCode
                    +'&populateProperties='+populateProperties+'&customerClasses='+customerClasses
                    +'&pageCount=100&pageStart=0&effectiveOn='+todayDate+'&openOn='+todayDate
                    +'&tariffTypes=DEFAULT,ALTERNATIVE&serviceTypes=ELECTRICITY&sortOn=customerLikelihood,tariffType&sortOrder=DESC,ASC';

            request.setEndpoint(requeString);
            System.debug('requeString----->'+requeString);
            response = http.send(request);

            System.debug('response Status Code----->' + response.getStatusCode());
            System.debug('----->' + response.getBody());

            GenabilityErrorJSON genErrResp = new GenabilityErrorJSON();

            if (response.getStatusCode() == 200) {
                gt.callSuccess = true;
                gt.genResp = (GenabilityTariffJSON) System.JSON.deserialize(response.getBody(), GenabilityTariffJSON.class);
                response = null;
            } else{
                genErrResp = (GenabilityErrorJSON) System.JSON.deserialize(response.getBody(), GenabilityErrorJSON.class);
                gt.errorMessage = getErrorMessage(genErrResp.results[0]);
                response = null;
            }

        }catch(Exception e){
            gt.errorMessage = e.getMessage();
            spExLogsList.add(prepDebugLog(acc.Id,'Genability GetTariffsforaZipCode',request,response));
        }


        return gt;
    }

    //-------------------------------------------Set Genability Account Propety---------------------------------------//
    public static GenabilityProperty SetProperty(Account acc, String keyName, String dataValue, Integer accuracy){
        GenabilityProperty gp = new GenabilityProperty();
        Http http = new Http();
        HttpRequest request = prepHttpReq();
        HttpResponse response = new HttpResponse();

        try {

            request.setHeader('Content-Type', 'application/json');
            request.setMethod('PUT');
            request.setEndpoint(genCS.Endpoint_URL__c + '/rest/v1/accounts/pid/'+acc.Id+'/properties');

            GenabilityPropertyJSON.Property gpp = new GenabilityPropertyJSON.Property(keyName,null,null,dataValue,100.00);

            String gppJSONString = JSON.serializePretty(gpp,true);
            System.debug('gppJSONString----->'+gppJSONString);
            request.setBody(gppJSONString);

            response = http.send(request);

            System.debug('response Status Code----->' + response.getStatusCode());
            System.debug('response body----->' + response.getBody());

            GenabilityErrorJSON genErrResp = new GenabilityErrorJSON();

            if(response.getStatusCode() == 200) {
                gp.callSuccess = true;
                response = null;
            }
            else{
                genErrResp = (GenabilityErrorJSON) System.JSON.deserialize(response.getBody(), GenabilityErrorJSON.class);
                gp.errorMessage = getErrorMessage(genErrResp.results[0]);
                response = null;
            }

        }catch(Exception e){
            gp.errorMessage = e.getMessage();
            spExLogsList.add(prepDebugLog(acc.Id,'Genability SetProperty',request,response));
        }

        return gp;
    }

    //--------------------------------------GetkWhValue for a given Dollar Amount-------------------------------------//
    public static GenabilityAccount GetkWhValue(Account acc, String dollarAmount){
        GenabilityAccount ga = new GenabilityAccount();
        Http http = new Http();
        HttpRequest request = prepHttpReq();
        HttpResponse response = new HttpResponse();

        try{

            request.setHeader('Content-Type', 'application/json');
            request.setMethod('POST');
            request.setEndpoint(genCS.Endpoint_URL__c + '/rest/v1/calculate');

            List<GenabilityAccountJSON.TariffInput> gaTariffInputsList = new List<GenabilityAccountJSON.TariffInput>();
            gaTariffInputsList.add(new GenabilityAccountJSON.TariffInput( fromDate(), toDate(),'total',dollarAmount,
                                                                            'cost'));
            gaTariffInputsList.add(new GenabilityAccountJSON.TariffInput( fromDate(), toDate(),'baselineType',
                                                                            'typicalElectricity',null));

            GenabilityAccountJSON.GetDollarAmount gaDollarAmount = new GenabilityAccountJSON.GetDollarAmount(acc.Id,
                                                                    fromDate(),toDate(), 'true', 'CHARGE_TYPE', gaTariffInputsList);

            String gaDollarAmountJSONString = JSON.serializePretty(gaDollarAmount,true);
            System.debug('gaDollarAmountJSONString----->'+gaDollarAmountJSONString);
            request.setBody(gaDollarAmountJSONString);
            System.debug('Heap Size ----->'+Limits.getHeapsize());
            response = http.send(request);

            System.debug('response Status Code----->' + response.getStatusCode());
            System.debug('Heap Size ----->'+Limits.getHeapsize());
            System.debug('response body----->' + response.getBody());
            GenabilityErrorJSON genErrResp = new GenabilityErrorJSON();

            if(response.getStatusCode() == 200){
                ga.callSuccess = true;

                GenabilitykWhJSON gkWhJSON = (GenabilitykWhJSON)System.JSON.deserialize(response.getBody(), GenabilitykWhJSON.class);
                ga.kWhValue = Integer.valueOf(gkWhJSON.results[0].summary.kWh);
                response = null;
            }
            else{
                genErrResp = (GenabilityErrorJSON) System.JSON.deserialize(response.getBody(), GenabilityErrorJSON.class);
                ga.errorMessage = getErrorMessage(genErrResp.results[0]);
                response = null;
            }

        }catch(Exception e){
            ga.errorMessage = e.getMessage();
            spExLogsList.add(prepDebugLog(acc.Id,'Genability GetkWhValue',request,response));
        }

        return ga;
    }

    //Upsert Usage profile
    public static GenabilityUsageProfile UpsertUsageProfile(Account acc, Electric_Rate_Usage_Input__c erui,
                                                            List<GenabilityUsageProfileJSON.ReadingData> gupRDList,
                                                            String serviceTypes, String sourceId){
        GenabilityUsageProfile gup = new GenabilityUsageProfile();
        Http http = new Http();
        HttpRequest request = prepHttpReq();
        HttpResponse response = new HttpResponse();

        try {
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('PUT');
            request.setEndpoint(genCS.Endpoint_URL__c + '/rest/v1/profiles');

            GenabilityUsageProfileJSON.UsageProfile gupUP = new GenabilityUsageProfileJSON.UsageProfile();
            gupUP.providerAccountId = acc.Id;
            gupUP.providerProfileId = erui.Id;
            gupUP.profileName = acc.Id;
            gupUP.description = acc.Name;
            gupUP.isDefault = true;
            gupUP.serviceTypes = serviceTypes;
            gupUP.sourceId = sourceId;
            gupUP.readingData = gupRDList;

            String gupJSONString = JSON.serializePretty(gupUP, true);
            System.debug('gupJSONString -----> ' + gupJSONString);
            request.setBody(gupJSONString);
            response = http.send(request);
            System.debug('response Status Code----->' + response.getStatusCode());
            System.debug('response body----->' + response.getBody());

            GenabilityErrorJSON genErrResp = new GenabilityErrorJSON();
            if(response.getStatusCode() == 200){
                GenabilityUsageProfileJSON gupJSON = (GenabilityUsageProfileJSON)System.JSON.deserialize(response.getBody(), GenabilityUsageProfileJSON.class);
                if(gupJSON.results[0].profileId != null)
                    gup.profileId = gupJSON.results[0].profileId;
            }
            else{
                genErrResp = (GenabilityErrorJSON) System.JSON.deserialize(response.getBody(), GenabilityErrorJSON.class);
                gup.errorMessage = getErrorMessage(genErrResp.results[0]);
                response = null;
            }
        }catch(Exception e){
            gup.errorMessage = e.getMessage();
            spExLogsList.add(prepDebugLog(acc.Id,'Genability UpsertUsageProfile',request,response));
        }
        return gup;
    }

    //-------------------------------------------Delete a Genability Propety---------------------------------------//
    public static GenabilityProperty DeleteGenabilityProperty(Account acc, String sprofileId){
        GenabilityProperty gp = new GenabilityProperty();
        Http http = new Http();
        HttpRequest request = prepHttpReq();
        HttpResponse response = new HttpResponse();

        try {

            request.setHeader('Content-Type', 'application/json');
            request.setMethod('DELETE');
            request.setEndpoint(genCS.Endpoint_URL__c + '/rest/v1/profiles/'+sprofileId);

            response = http.send(request);

            System.debug('response Status Code----->' + response.getStatusCode());
            System.debug('response body----->' + response.getBody());

            GenabilityErrorJSON genErrResp = new GenabilityErrorJSON();

            if(response.getStatusCode() == 200) {
                gp.callSuccess = true;
                response = null;
            }
            else{
                genErrResp = (GenabilityErrorJSON) System.JSON.deserialize(response.getBody(), GenabilityErrorJSON.class);
                gp.errorMessage = getErrorMessage(genErrResp.results[0]);
                response = null;
            }

        }catch(Exception e){
            gp.errorMessage = e.getMessage();
            spExLogsList.add(prepDebugLog(acc.Id,'Genability SetProperty',request,response));
        }

        return gp;
    }

    //Method to prepare httpreuest with authorization to be used in all the callouts
    public static HttpRequest prepHttpReq(){
        String appIdappKey = genCS.Client_Id__c + ':' + genCS.Key__c;
		String base64appIdappKey = EncodingUtil.base64Encode(Blob.valueOf(appIdappKey));
        Httprequest request = new HttpRequest();
        request.setHeader('Authorization', 'Basic '+base64appIdappKey);
        return request;
    }

    
    public class GenabilityAccount{
        public String genabilityAccountId = null;
        public boolean callSuccess = false;
        public String errorMessage = null;
        public Integer kWhValue = null;
    }

    public class GenabilityTariff{
        public GenabilityTariffJSON genResp = null;
        public boolean callSuccess = false;
        public String errorMessage = null;
    }

    public class GenabilityProperty{
        public boolean callSuccess = false;
        public String errorMessage = null;
    }

    public class GenabilityUsageProfile{
        public String profileId = null;
        public String errorMessage = null;
    }

    //Method to get Current Time Stamp in format required by Aurora
    public static String fromDate(){
        return datetime.Now().AddYears(-1).addDays(-1).format('yyyy-MM-dd');
    }

    public static String toDate(){
        return datetime.now().format('yyyy-MM-dd');
    }

    public static String getErrorMessage(GenabilityErrorJSON.Error geJSONError){
        String errorString = null;
        if(geJSONError==null)
            return null;
        else{
            errorString = String.valueOf(geJSONError);
        }
        return errorString;
    }

    //prepare debug log
    public static SpectrumDebugUtility.debugLog prepDebugLog(Id accountId,
                                                                String serviceName,
                                                                Httprequest request,
                                                                Httpresponse response){
        //build log of ob msg and response
        SpectrumDebugUtility.debugLog spExLog = new SpectrumDebugUtility.debugLog();
        spExlog.AccountId = accountId;
        spExLog.Service = serviceName;
        spExLog.Response = response.getBody();
        spExLog.responseCode = response.getStatusCode();
        spExLog.JSONPayload = request.getBody();
        return spExLog;
    }
}