global class F9Web2Campaign implements Database.AllowsCallouts{
  
  private static String APIURL = Five9WebserviceCalloutSettings__c.getInstance(system.label.ALR_Five9).APIURL__c; //'https://api.five9.com/web2campaign/AddToList';
    public static Integer stCode {get;set;}
    public static String resBody {get;set;}
    public static String obmsg {get;set;}
        
    public F9Web2CampaignResult doPost(Map<string, string> lead){
        
        //Let PageReference class format our parameters for us.
        System.PageReference pageReference = new System.PageReference('');
        pageReference.getParameters().putAll(lead);
    
    system.debug('************ lead **************'+lead);
    String query = pageReference.getUrl().substring(1);//trim off the question mark
        system.debug('************ query **************'+query); 
        
        //collect outgoing messages and responses logged in debug logging object for APIs
        
        
        // Instantiate a new http object
        Http h = new Http();
    
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(APIURL);
        req.setBody(query);
        req.setMethod('POST');        
        req.setHeader('Accept', 'application/json');
        req.setTimeout(30000);
        //req.setCompressed(true); // otherwise we hit a limit of 32000, five9 api seems to choke on this...
        obmsg = req.toString() + ' ' + req.getBody();
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        string body = res.getBody();
        resBody = body;
        Integer statusCode = res.getStatusCode();
        stCode = statusCode;
        Integer errCode = -1;
        String errDesc = '';
        
        if(statusCode == 302)
        {
            String retURLstr = res.getHeader('Location').replace('http://localhost?', '');
            List<String> temp = retURLstr.split('&',0);
            Map<String, String> params = new Map<String, String>();
            for(String v: temp)
            {
                List<String> t2 = v.split('=', 2);
                if(t2.size() > 1)
                {
                    params.put(t2[0], t2[1]);
                }
            }

            if(params.get('F9errCode')!=null)
                errCode = Integer.valueOf(params.get('F9errCode'));
            if(params.get('F9errDesc')!=null)
                errDesc = params.get('F9errDesc');
          
          return new F9Web2CampaignResult(statusCode, 'Server returned error code: '+statusCode,'');

        }
        else if(statusCode == 200)// for Status OK : Get Responce from 
        {
          F9Web2CampaignResult objF9Web2CampaignResult = new F9Web2CampaignResult();
          objF9Web2CampaignResult.body = body;
          return new F9Web2CampaignResult(statusCode, 'Server returned error code: '+statusCode,'');
        }
        return new F9Web2CampaignResult(errCode, errDesc,'');
    }
  
  
  /*public static String ParseHtml(String source) {
        Pattern myPattern = Pattern.compile('name="salesforce_id" (.*?) size="18"');

    String temp = '<TD><INPUT readonly id="salesforce_id" name="salesforce_id" value="00Qn0000003lvP1EAI" size="18"></TD></TR><TR><TD>first_name:</TD>';
    
    Matcher m = myPattern.matcher(temp);
      while(m.find())
      {
        if(m.group(0) != null)
      {
          String value = 
      }
        system.debug('=============>'+m.group(0));
        system.debug('=============>'+m);
    }
    }*/
  
}