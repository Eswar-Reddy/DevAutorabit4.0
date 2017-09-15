@isTest
global class skedBookingGrid_MockTest implements HttpCalloutMock {
    
    public List<string> scripts;
    private integer scriptOrder = 0;

    public string calloutMethod {get;set;}
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string finalResult;
        
        this.calloutMethod = scripts.get(scriptOrder);
        
        if (this.calloutMethod == 'getGeocode') {
            finalResult = '{"status":"OK","results":[{"geometry":{"location":{"lng":-121.9466052,"lat":37.4050308}},"formatted_address":"77 Rio Robles, San Jose, CA 95134, USA","address_components":[{"types":["street_number"],"short_name":"77","long_name":"77"},{"types":["route"],"short_name":"Rio Robles","long_name":"Rio Robles"},{"types":["neighborhood","political"],"short_name":"North San Jose","long_name":"North San Jose"},{"types":["locality","political"],"short_name":"San Jose","long_name":"San Jose"},{"types":["administrative_area_level_2","political"],"short_name":"Santa Clara County","long_name":"Santa Clara County"},{"types":["administrative_area_level_1","political"],"short_name":"CA","long_name":"California"},{"types":["country","political"],"short_name":"US","long_name":"United States"},{"types":["postal_code"],"short_name":"95134","long_name":"95134"},{"types":["postal_code_suffix"],"short_name":"1859","long_name":"1859"}]}]}';
        }
        else if (this.calloutMethod == 'calculateMultiDistances') {
         	finalResult = '{"destination_addresses":["113-119 Rio Robles, San Jose, CA 95134, Hoa Kỳ"],"origin_addresses":["627-675 Betty Meltzer Memorial Hwy, Palo Alto, CA 94301, Hoa Kỳ"],"rows":[{"elements":[{"distance":{"text":"15,0 miles","value":24204},"duration":{"text":"24 minutes","value":1454},"status":"OK"}]}],"status":"OK"}';   
        }
        res.setBody(finalResult);
        res.setStatusCode(200);
        
        scriptOrder++;
        
        return res;
    }
    
}