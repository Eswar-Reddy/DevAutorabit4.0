public class skedGoogleMapServiceApi {
    
    static public skedGoogleData.distanceMatrixResult calculateMultiDistances(List<string> originList, string destination) {
        List<string> destinationList = new List<string>();
        destinationList.add(destination);
        return calculateMultiDistances(originList, destinationList);
    }
    
    static public skedGoogleData.distanceMatrixResult calculateMultiDistances(List<string> originList, List<string> destinationList) {
        skedGoogleData.distanceMatrixResult result = new skedGoogleData.distanceMatrixResult();
        
        string origins = string.join(originList, '|');
        string destinations = string.join(destinationList, '|');
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        string requestString = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=' + EncodingUtil.URLENCODE(origins, 'UTF-8')
            + '&destinations=' + EncodingUtil.URLENCODE(destinations, 'UTF-8');
        
        sked_Google_Api_Settings__c googleApiSetting = sked_Google_Api_Settings__c.getOrgDefaults();
        if (!string.isBlank(googleApiSetting.Server_Key__c)) {
            requestString += '&key=' + googleApiSetting.Server_Key__c;
        }
        system.debug('#requestString#' + requestString);
        req.setEndpoint(requestString);
        req.setMethod('GET');
        req.setTimeout(120000);
        try {
            HttpResponse res = h.send(req);
            string jsonResult = res.getBody();
            system.debug('#jsonResult#' + jsonResult);
            result = (skedGoogleData.distanceMatrixResult)(Json.deserialize(jsonResult, skedGoogleData.distanceMatrixResult.class));
            
            if (result.status != 'OK') {
                result.HasError = true;
                result.ErrorMessage = result.status;
            } else {
                result.HasError = false;
            }
        } catch (Exception e) {
            result.HasError = true;
            result.ErrorMessage = e.getMessage() + '\n' + e.getStackTraceString();
        }

        return result;
    }

    static public skedGoogleData.geocodeResult getGeocode(string address) {
        skedGoogleData.geocodeResult result = new skedGoogleData.geocodeResult();
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        string requestString = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.URLENCODE(address, 'UTF-8');
        sked_Google_Api_Settings__c googleApiSetting = sked_Google_Api_Settings__c.getOrgDefaults();
        if (!string.isBlank(googleApiSetting.Server_Key__c)) {
            requestString += '&key=' + googleApiSetting.Server_Key__c;
        }
        system.debug('#requestString#' + requestString);
        req.setEndpoint(requestString);
        req.setMethod('GET');
        req.setTimeout(120000);
        try {
            HttpResponse res = h.send(req);
            string jsonResult = res.getBody();
            system.debug('#jsonResult#' + jsonResult);
            result = (skedGoogleData.geocodeResult)(Json.deserialize(jsonResult, skedGoogleData.geocodeResult.class));
            if (result.status != 'OK') {
                result.HasError = true;
                result.ErrorMessage = result.status;
            } else {
                result.HasError = false;
            }
        } catch (Exception e) {
            result.HasError = true;
            result.ErrorMessage = e.getMessage() + '\n' + e.getStackTraceString();
        }

        return result;
    }
    
}