public with sharing class GeocodeAsyncHandler 
{
    
    private static String geoCalloutMsg {get;set;}//spectrum log json payload
    private static string calloutResponse {get;set;}//response body get as string
    
    @future (callout=true)
    public static void futureGeoCode(String cleanAddress, Id objId, String locationFieldName)
    {
         //system.debug('@@@@@futureGeoCode cleanAddress: ' + cleanAddress );    
        geoCode(cleanAddress, objId, locationFieldName); 
         //system.debug('@@@@@futureGeoCode cleanAddress: ' + cleanAddress );        
    }

    //Sarbello - Added 10.8.13 
    public static GeoInfo  GeoCodeWithZipCodeFilter(String cleanAddress, String ZipCode)
    {
        return getLatLon(cleanAddress, ZipCode);
    }
    
    //Sarbello - Added 9.6.13 
    public static GeoInfo  GeoCode(String cleanAddress)
    {
        return getLatLon(cleanAddress, '');
    }
    
    //Sarbello - Modified 9.6.13 (Original is below). Factored out call to Google to method getLatLon
    public static void geoCode(String cleanAddress, Id objId, String locationFieldName)
    {
            //map<string, double> mapLatLon =  getLatLon(cleanAddress);
            GeoInfo info =  getLatLon(cleanAddress, '');
                     
            string oType = objId.getSObjectType().getDescribe().getName();
            SObject s = Schema.getGlobalDescribe().get(oType).newSObject();
            
            if (oType.equals('Account')) s.put('IsAddressUpdated__c', false); 
            
            s.put('Id', objId);
            
            system.debug('@@@@@GeocodeAsyncHandler.geoCode Id:' + objId + ' lon:' + info.lon +  + ' lat:' + info.lat);
            
            if (info.lat != null)
            {                
                s.put(locationFieldName.replace('__c', '__Longitude__s'), info.lon);
                s.put(locationFieldName.replace('__c', '__Latitude__s'), info.lat);                                        
            }
            
            try
            {
                //We need to make sure that it updates or at least does raise an exception because a failure will roolback the flag 
                //which will cause the batch to keep picking this up.
                update s;
            }
            catch (Exception e) 
            {
                System.debug('@@@@@GeocodeAsyncHandler.geoCode had an Exception: ' + e.getMessage() + ', ' + e.getStackTraceString());
            }
 
    }   
    
    private static string GenerateSignature(String url, String privateKey) {
        //string url = '/maps/api/geocode/json?address=ADDRESS&sensor=false&client=CLIENTID';
        
        url = url.remove('https://maps.googleapis.com');
        url = url.remove('http://maps.googleapis.com');
        
        system.debug('@@@@@GenerateSignature: url ' + url);
        
        if (!Test.isRunningTest()) {
            privateKey = privateKey.replace('-', '+');
            privateKey = privateKey.replace('_', '/');
        }
        else {
            privateKey = 'test';
        }
        
        Blob privateKeyBlob = EncodingUtil.base64Decode(privateKey);
        Blob urlBlob = Blob.valueOf(url);
        Blob signatureBlob = Crypto.generateMac('hmacSHA1', urlBlob, privateKeyBlob);
        
        String signature = EncodingUtil.base64Encode(signatureBlob);
        
        signature = signature.replace('+', '-');
        signature = signature.replace('/', '_');
        
        system.debug('@@@@@GenerateSignature: ' + signature);
        return signature;
    }
     
    //Sarbello - Added 9.6.13  
    private static String getGeoResponse(string cleanAddress, string ZipCodeForFilter) {
            String googleState;
            String URLComplete;
            String signature;
            
            String URLBase              = 'https://maps.googleapis.com';
            String GeoCodeEndpoint  = '/maps/api/geocode/json';
            
            DealerGeneral__c c = DealerGeneral__c.getInstance();
 
             //system.debug('@@@@@getLatLon cleanAddress: ' + cleanAddress );
            cleanAddress = Encodingutil.urlEncode(cleanAddress, 'UTF-8');
             //system.debug('@@@@@getLatLon cleanAddress: ' + cleanAddress );           
 
            //===============================================================================================
            //Special Notes regarding the use of a Google Business API Key
            //Google provides a clientId and private key. The clientId needs to be added to the URL and that string needs to be used to generate the signature
            //We then include the signature on the final url.
            //1. Create the URL including the Address, Sensor, and ClientId
            //2. Take the url and strip the http:/ or https:/ leaving only a leading /
            //3. Using the private key, sign (base64Decode,Blob,Crypto.generateMac,base64Encode) this string. Note there are some Pre and Post processing steps on the Key and generated signature
            //4. Append the signature to the url and make the call
            //Example (sample keys):
            //URL:                      http://maps.googleapis.com/maps/api/geocode/json?address=New+York&sensor=false&client=clientID
            //Private Key:          vNIXE0xscrmjlyV-12Nj_BvUPaw=
            //URL Portion to Sign:  /maps/api/geocode/json?address=New+York&sensor=false&client=clientID
            //Signature:                KrU1TzVQM7Ur0i8i7K3huiw3MsA=
            //Full Signed URL:      http://maps.googleapis.com/maps/api/geocode/json?address=New+York&sensor=false&client=clientID&signature=KrU1TzVQM7Ur0i8i7K3huiw3MsA=           
            //===============================================================================================
            
            //Step 1. Build the partial URL that we will be signing. This is the same string that Google will attempt to sign to validate us
            URLComplete = GeoCodeEndpoint + '?address='+cleanAddress+'&sensor=false&client='+c.Google_Client_Id_Maps__c;
            
            //Step 1a: If we've been asked to include a further filter on the results then do it
            if (ZipCodeForFilter != '')
                URLComplete = GeoCodeEndpoint + '?address='+cleanAddress+'&components=postal_code:' + ZipCodeForFilter + '&sensor=false&client='+c.Google_Client_Id_Maps__c;
            
            //Step 2. Generate a signature
            signature = GenerateSignature(URLComplete, c.Google_Private_Key_Maps__c);
            
            //Step 3. Construct complete URL including Base, endpoint, and signature
            URLComplete = URLBase + URLComplete + '&signature=' + signature;
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
        
            //req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address='+cleanAddress);
            req.setEndpoint(URLComplete);
            req.setMethod('GET');
            req.setTimeout(90000);
                        
            HttpResponse res = new httpResponse();   
            system.debug('@@@@@ CALLING GEOCODE SERVICE ' + URLComplete);
            
            if (!test.isRunningTest())
            {
                geoCalloutMsg = req.toString();
                System.debug(LoggingLevel.ERROR, 'GEOCALLOUT MSG: ' + geoCalloutMsg);
                res = h.send(req);
                calloutResponse = res.getBody();
                
                System.debug(LoggingLevel.ERROR, 'GEOCALLOUT Response: ' + geoCalloutMsg);
            } else {                
                res.setBody('{"results" : [{"address_components" : [{"long_name" : "2905","short_name" : "2905","types" : [ "street_number" ]},{"long_name" : "Inca Street","short_name" : "Inca St","types" : [ "route" ]},{"long_name" : "Five Points","short_name" : "Five Points","types" : [ "neighborhood", "political" ]},{"long_name" : "Denver","short_name" : "Denver","types" : [ "locality", "political" ]},{"long_name" : "Denver","short_name" : "Denver","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "Colorado","short_name" : "CO","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "80202","short_name" : "80202","types" : [ "postal_code" ]}],"formatted_address" : "2905 Inca Street, Denver, CO 80202, USA","geometry" : {"location" : {"lat" : 39.759543,"lng" : -104.999113},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 39.7608919802915,"lng" : -104.9977640197085},"southwest" : {"lat" : 39.7581940197085,"lng" : -105.0004619802915}}},"types" : [ "street_address" ]}],"status" : "OK"}');
            }     
            
            //12.3.13 Did Google have an issue with our Signed call? If so lets attempt the free version
            if (res.getBody().startsWith('Unable')) {
                system.debug('@@@@@ getLatLon USING Google Maps Backup');
                if (ZipCodeForFilter != '')
                    req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+cleanAddress+'&components=postal_code:' + ZipCodeForFilter + '&sensor=false');
                else
                    req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address='+cleanAddress);
                geoCalloutMsg = req.toString();
                res = h.send(req);
                calloutResponse = res.getBody();
            }
            
            system.debug('@@@@@ getLatLon results:' + res.getBody());
            
            return res.getBody();

    }

    //Sarbello - Added 9.6.13  
    private static GeoInfo getLatLon(string cleanAddress, string ZipCodeForFilter) {

            String geoJson = getGeoResponse(cleanAddress, ZipCodeForFilter);

            //This is the return object
            GeoInfo info            = new GeoInfo();
            info.AddressFound   = false;
            info.ZeroResults = false;
        	info.sentMsg = geoCalloutMsg;
        	info.calloutRes = calloutResponse;
            
            if (geoJson.contains('ZERO_RESULTS')) info.ZeroResults = true;
            
            //This is the internal object to help parse the results
            GeoResult geo = new GeoResult();
            
            //Load it
            geo = GeoResult.parse(geoJson); 
            
            //FOR TESTING geo = GeoResult.parse('Unable to authenticate the request');
            
            //Do we have results
            if (geo.results != null) {
                if (geo.results.size() > 0) {
                  
                   if (geo.results[0].address_components != null) {     
                        if (geo.results[0].address_components[0] != null) {
                            //The GeoResult class knows how to get the information
                            info.State              = geo.getState(geo.results[0].address_components);
                            info.County              = geo.getCounty(geo.results[0].address_components);
                            info.Lat                    = geo.getLatitude(geo.results[0].Geometry);
                            info.Lon                = geo.getLongitude(geo.results[0].Geometry);
                            info.AddressFound   = true;
                            info.fAddress = geo.results[0].formatted_address;
                        }
                   }
                        
                 }
            }
            
            system.debug('@@@@@ getLatLon results:' + info);
            return info;
    }


    public static string cleanAddress(String Street, String City, String State, String PostalCode, String Country)
    {
        system.debug('@@@@@GeocodeAsyncHandler.cleanAddress:' + street + ';' + city +  + ';' + state + ';' + PostalCode +  + ';' + Country);
        string address = '';
        
        // 01/07/14
        //if (Street != null && Street != '') Street = EncodingUtil.urlEncode(Street, 'UTF-8');
        //if (City != null && City != '') City = EncodingUtil.urlEncode(City, 'UTF-8');
        //system.debug('@@@@@GeocodeAsyncHandler.cleanAddress UTF-8 Street:' + Street );
        //system.debug('@@@@@GeocodeAsyncHandler.cleanAddress UTF-8 City:' + City);
        
        // 01/07/14
        if (Street != null && Street != '') {if (address != null && address != '') address += ', ' + Street; else address = Street;}
        //if (Street != null && Street != '') {if (address != null && address != '') address += ', ' + EncodingUtil.urlEncode(Street, 'UTF-8'); else address = EncodingUtil.urlEncode(Street, 'UTF-8');}
        //system.debug('@@@@@GeocodeAsyncHandler.cleanAddress:' + address );
        
        if (City != null && City != '') {if (address != null && address != '') address += ', ' + City; else address = City;}
        //if (City != null && City != '') {if (address != null && address != '') address += ', ' + EncodingUtil.urlEncode(City, 'UTF-8'); else address = EncodingUtil.urlEncode(City, 'UTF-8');}
        //system.debug('@@@@@GeocodeAsyncHandler.cleanAddress:' + address );
         
        if (State != null && State != '') {if (address != null && address != '') address += ', ' + State; else address = State;}
        //system.debug('@@@@@GeocodeAsyncHandler.cleanAddress:' + address );
        
        if (PostalCode != null && PostalCode != '') {if (address != null && address != '') address += ', ' + PostalCode; else address = PostalCode;}
        //system.debug('@@@@@GeocodeAsyncHandler.cleanAddress:' + address );
        
        if (Country != null && Country != '') {if (address != null && address != '') address += ', ' + Country; else address = Country;}
        //system.debug('@@@@@GeocodeAsyncHandler.cleanAddress:' + address );
        
        try {
            //01/07/14 
            //address = address.replaceAll('[^a-zA-Z0-9\\,\\-]',' ');
              address = address.replaceAll('[^a-zA-Z0-9\\,\\-]%',' ');
        } catch (system.Nullpointerexception e) { system.debug('@@@@@ cleanAddress exception: ' + e.getMessage()); }
        return address;
    }
    
    public static boolean scheduleBatch = false;
   
    public static void setToTrue() { scheduleBatch = true; }
    
    public class GeoInfo {
        public double Lat { get; set; }
        public double Lon { get; set; }
        public string State { get; set; }
        public boolean AddressFound { get; set; }
        public boolean ZeroResults { get; set; }        
        public string County { get; set; }
        public String fAddress { get; set; }
        public String sentMsg {get;set;}
        public String calloutRes {get;set;}
        //public string State1 { get; set; }
        //public string State2 { get; set; }
        //public string State3 { get; set; }
        //public string State4 { get; set; }
    }
                
   
                    
}