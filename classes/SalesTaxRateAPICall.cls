public class SalesTaxRateAPICall {
 
    public static List<Sunpower_Spectrum_Debug_Log__c> spectrumDebugList = new List<Sunpower_Spectrum_Debug_Log__c>();
    public static List<Exception_Log__c> exceptionLogList = new List<Exception_Log__c>();
    public static Decimal retrieveSalesTax(String billingStreet,String billingCity,String billingState,String billingPostalCode,Id accId){
        try{
            Loan_Callout_Settings__c mcs = Loan_Callout_Settings__c.getInstance('ServiceObjects');
            String city = billingCity != null ? EncodingUtil.urlEncode(billingCity, 'UTF-8'):'';
            String state = billingState != null ? EncodingUtil.urlEncode(billingState, 'UTF-8'):'';
            String postalcode = billingPostalCode != null ? EncodingUtil.urlEncode(billingPostalCode, 'UTF-8'):'';
            String address = billingStreet != null ? EncodingUtil.urlEncode(billingStreet, 'UTF-8'):'';
            String taxType = 'sales';
            String LicenseKey = mcs.Client_Id__c;
            String url = mcs.Endpoint_URL__c + address + '&City=' + city +'&State=' + state + '&ZipCode=' + postalcode + '&TaxType=' + taxtype + '&LicenseKey=' + LicenseKey;
            String res = callSalesTaxAPI(url,mcs.NameSpace__c,accId);            
            if(res != null && Decimal.valueOf(res) < 1){
                return Decimal.valueOf(res)*100;
            }
            else if(res == '4'){
                 url = mcs.BackupUrl__c + address + '&City=' + city +'&State=' + state + '&ZipCode=' + postalcode + '&TaxType=' + taxtype + '&LicenseKey=' + LicenseKey;
                 res = callSalesTaxAPI(url,mcs.NameSpace__c,accId);
                 if(res != null && Decimal.valueOf(res) < 1){
                    return Decimal.valueOf(res)*100; 
                 }
                 else if(res == '2'){
                    url = mcs.ZipCodeUrl__c + postalcode + '&TaxType=' + taxtype + '&LicenseKey=' + LicenseKey;
                    res = callSalesTaxAPI(url,mcs.NameSpace__c,accId);
                    if(res != null && Decimal.valueOf(res) < 1){
                       return Decimal.valueOf(res)*100;   
                    }
                    else if(res == '4'){
                         url = mcs.BackupZipCodeUrl__c + postalcode + '&TaxType=' + taxtype + '&LicenseKey=' + LicenseKey;
                         res = callSalesTaxAPI(url,mcs.NameSpace__c,accId);
                         if(res != null && Decimal.valueOf(res) < 1){
                            return Decimal.valueOf(res)*100;
                         }
                    } 
                 } 
            }
            else if(res == '2'){
                    url = mcs.ZipCodeUrl__c + postalcode + '&TaxType=' + taxtype + '&LicenseKey=' + LicenseKey;
                    res = callSalesTaxAPI(url,mcs.NameSpace__c,accId);
                    if(res != null && Decimal.valueOf(res) < 1){
                       return Decimal.valueOf(res)*100;   
                    }
                    else if(res == '4'){
                         url = mcs.BackupZipCodeUrl__c + postalcode + '&TaxType=' + taxtype + '&LicenseKey=' + LicenseKey;
                         res = callSalesTaxAPI(url,mcs.NameSpace__c,accId);
                         if(res != null && Decimal.valueOf(res) < 1){
                            return Decimal.valueOf(res)*100;
                         }
                    }
            }    
        }
        catch(Exception e){
            Exception_Log__c exceptionLog = new Exception_Log__c();
            exceptionLog.Account__c = accId;
            exceptionLog.Error_Message__c = e.getMessage();
            exceptionLog.Stack_Trace__c = e.getStackTraceString();
            exceptionLog.Type__c = 'SalesTaxRateAPICall';
            exceptionLogList.add(exceptionLog);
            system.debug('Error is '+e.getMessage()+ ' and stack trace is '+e.getStackTraceString());
            return null;
        }
        return null;
    }
    
    public static String callSalesTaxAPI(String url,String nameSpace,Id accId){
        String response = null;
        HttpRequest request = new HttpRequest(); 
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/xml');
        request.setTimeout(60000);
        Http http1 = new Http();
        HttpResponse res = http1.send(request); 
        if(res != null && res.getStatusCode() == 200){
            String stringResponse = res.getBody();
            system.debug('response is '+stringResponse);
            Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode addressResponse = doc.getRootElement();
            Dom.XmlNode Error = addressResponse.getChildElement('Error', nameSpace);
            if(Error == null){
                if(stringResponse != null && stringResponse.contains('TotalTaxRate'))
                  response = stringResponse.subString(stringResponse.indexOf('<TotalTaxRate>')+14,stringResponse.indexOf('</TotalTaxRate>'));
            }
            else if(Error != null && Error.getChildElement('Number', nameSpace) != null){
                response = Error.getChildElement('Number', nameSpace).getText();
            }
        }
        
        Sunpower_Spectrum_Debug_Log__c debugLog = new Sunpower_Spectrum_Debug_Log__c();
        debugLog.JSON_Payload__c = url;
        debugLog.Account__c = accId;
        debugLog.Response__c = res != null ? res.getBody():null;
        debugLog.Response_Status_Code__c = res != null ? res.getStatusCode():null; 
        debugLog.Service__c = 'SalesTaxRateAPICall';
        spectrumDebugList.add(debugLog); 
        return response;
    }
}