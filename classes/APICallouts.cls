global class APICallouts 
{    
    global static boolean isRunningTest = false;    
   
    @future (callout=true)
    webservice static void setLocation(id accountId,id leadId)
    {
        List<Account> a = new List<Account>();
        List<Lead> l = new List<lead>();
        List<Account> accGeo = new List<Account>();
        List<Lead> lGeo = new List<Lead>();
        String recordId = '';       
        String address = '';
        if(accountId !=null || leadId != null)
        {
            a = [SELECT BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Geo__Latitude__s,Geo__Longitude__s FROM Account WHERE id =: accountId];
            if(a.size()>0)
            {
                if(a[0].BillingStreet != null)
                    address += a[0].BillingStreet +',';
                if(a[0].BillingCity != null)
                    address += a[0].BillingCity +',';
                if(a[0].BillingState != null)
                    address += a[0].BillingState +',';
                if(a[0].BillingPostalCode != null)
                    address += a[0].BillingPostalCode +',';
                if(a[0].BillingCountry != null)
                    address += a[0].BillingCountry;
                
                recordId = String.valueOf(a[0].Id);    
            }
            else
            {
                l = [SELECT Id, City, Country, PostalCode, State, Street, lat__c, log__c FROM Lead WHERE Id =: leadId];
                if(l.size()>0)
                {
                    if(l[0].Street != null)
                        address += l[0].Street +', ';
                    if(l[0].City != null)
                        address += l[0].City +', ';
                    if(l[0].State != null)
                        address += l[0].State +' ';
                    if(l[0].PostalCode != null)
                        address += l[0].PostalCode +', ';
                    if(l[0].Country != null)
                        address += l[0].Country ;
                        
                    recordId = String.valueof(l[0].Id);                        
                }
            }
        }
        
 
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        JSONParser parser;
        
        if(isRunningTest)
        {
            String hardCodedRes = '{"results" :[ { "address_components" : [{"long_name" : "Acoma Avenue", "short_name" : "Acoma Ave", "types" : [ "route" ]},{ "long_name" : "Clairemont Mesa East","short_name" : "Clairemont Mesa East","types" :[ "neighborhood", "political" ]},{ "long_name" : "San Diego","short_name" : "San Diego","types" : [ "locality", "political" ]},{ "long_name" : "San Diego","short_name" : "San Diego","types" : [ "administrative_area_level_2", "political" ]},{ "long_name" : "California","short_name" : "CA","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "92117","short_name" : "92117","types" : [ "postal_code" ]}],"formatted_address" : "Acoma Avenue, San Diego, CA 92117, USA","geometry" : {"bounds" : {"northeast" : {"lat" : 32.8316410,"lng" : -117.19226050},"southwest" : {"lat" : 32.8307590,"lng" : -117.1941680}},"location" : {"lat" : 32.83142240,"lng" : -117.19318260},"location_type" : "GEOMETRIC_CENTER","viewport" : {"northeast" : {"lat" : 32.83254898029150,"lng" : -117.1918652697085},"southwest" : {"lat" : 32.82985101970850,"lng" : -117.1945632302915 } }},"types" : [ "route" ] }],"status" : "OK"}}';

            parser = JSON.createParser(hardCodedRes);        
        }
        else
        {      
            //Calling the web-service
            // build callout
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&sensor=false');
            req.setMethod('GET');
            req.setTimeout(60000);
SYSTEM.DEBUG('\n####request####->' + req);

            try
            {
                // callout
                HttpResponse res = h.send(req);
                // parse coordinates from response
                parser = JSON.createParser(res.getBody());
SYSTEM.DEBUG('\n####callout result####->' + res.getBody()); 

                GoogleAPIAuditLogger.Register(recordId, Userinfo.getUsername(), DateTime.now());//Register the API Call Out for Audit
            }
            catch(Exception e){
                system.debug('In Callout exception');   
            }   
        }
        try{
            double lat = null;
            double lon = null;
            system.debug('before loop');
           
            while (parser.nextToken() != null) { 
              system.debug('insode');
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location'))
                {   
                    system.debug('in if');
                    parser.nextToken(); // object start                        
               
                   while (parser.nextToken() != JSONToken.END_OBJECT){
                        system.debug('again loop');
                        String txt = parser.getText();
                        system.debug(txt);                           
                        parser.nextToken();                           
                        if(txt == 'lat'){
                            lat = parser.getDoubleValue();   
                            system.debug('>>>>>>>>lat'+lat);
                        }else{
                            if(txt == 'lng') 
                            {                       
                                lon = parser.getDoubleValue();  
                                system.debug('>>>>>>>>lon'+lon);
                            }
                        }
                       if(lat != null && lon != null ){
                            system.debug('here3');
                             if(leadId!=null){
                                 system.debug('here34');
                                l[0].lat__c = lat;
                                l[0].log__c = lon;
                                system.debug(l + 'bbbbbbbbbbbbbbbbbbbb');
                                update l;
                             }else
                             {
                                a[0].Geo__Latitude__s = lat;   
                                a[0].Geo__Longitude__s = lon;
                                system.debug(a + 'bbbbbbbbbbbbbbbbbbbb');
                                update a;
                             }
                        }     
                    }        
                }  
                        
            }
        } 
        catch (Exception e) {        
            system.debug('in exception');
        }   
    }
}