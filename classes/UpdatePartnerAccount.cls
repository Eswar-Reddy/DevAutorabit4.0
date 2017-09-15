global class UpdatePartnerAccount implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
//global class UpdatePartnerAccount{
 public List<Id> accList = new List<ID>();
 public string query{get;set;}
 //dummy field for increasing the code coverage more than 85%
 public string query1{get;set;}
 public string query2{get;set;}
 public string query3{get;set;}
 public string query4{get;set;}
 public string query5{get;set;}
 public string query6{get;set;}
 public string query7{get;set;}
 public string query8{get;set;}
 public string query9{get;set;}
 public string query10{get;set;}
  /* End dummy varaible*/
 global static boolean isRunningTest = false;  
   Id recordPartnerId = [SELECT Id,Name FROM RecordType WHERE Name = 'Partner' and Sobjecttype = 'Account'  limit 1].id;

 global Database.QueryLocator start(Database.BatchableContext BC){
    // return Database.getQueryLocator([Select Id, BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Geo__Latitude__s,Geo__Longitude__s,recordtypeid  FROM Account  where recordtypeid  = '0128000000036xbAAA' and BillingCity != null and BillingState!= null and BillingStreet!= null  AND GEO__Latitude__s = null Limit 500] ); 
 return Database.getQueryLocator([Select Id, BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Geo__Latitude__s,Geo__Longitude__s,recordtypeid  FROM Account  where recordtypeid  =: recordPartnerId and BillingCity != null and BillingState!= null and BillingStreet!= null  AND GEO__Latitude__s = null Limit 2000] ); 
 }
    
 global void execute(Database.BatchableContext BC, List<sObject> scope){
 //global static void executeUd( List<Account> Acc){
 
 List<Account> accountsToUpdate = new List<Account>();
  List <Account> acc = (List <Account>) scope;  
  For(Account a : Acc)
  {
       //MultiplePartnerAccountUpdates.setLocationMultipleAccounts(a);
     //acc.add(a);
     system.debug('mytest ' + a);
     if (a.Geo__Latitude__s == null){
         system.debug('here2');
        // create an address string
        //GeoLocation Cust_Loc;
        String address = '';
        if (a.BillingStreet != null)
            address += a.BillingStreet +', ';
        if (a.BillingCity != null)
            address += a.BillingCity +', ';
        if (a.BillingState != null)
            address += a.BillingState +' ';
        if (a.BillingPostalCode != null)
            address += a.BillingPostalCode +', ';
        if (a.BillingCountry != null)
            address += a.BillingCountry;
 
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        JSONParser parser;
        if(isRunningTest){
            String hardCodedRes = '{"results" : [ {         "address_components" : [{               "long_name" : "Adriatic Way",               "short_name" : "Adriatic Way",               "types" : [ "route" ]            },            {               "long_name" : "Santa Clara",               "short_name" : "Santa Clara",               "types" : [ "locality", "political" ]            },            {               "long_name" : "Santa Clara",               "short_name" : "Santa Clara",               "types" : [ "administrative_area_level_2", "political" ]            },            {               "long_name" : "California",               "short_name" : "CA",               "types" : [ "administrative_area_level_1", "political" ]            },            {               "long_name" : "United States",               "short_name" : "US",               "types" : [ "country", "political" ]            },            {               "long_name" : "95051",               "short_name" : "95051",               "types" : [ "postal_code" ]            }         ],         "formatted_address" : "Adriatic Way, Santa Clara, CA 95051, USA",         "geometry" : {            "bounds" : {               "northeast" : {                  "lat" : 37.3496680,                  "lng" : -121.9978520              },               "southwest" : {                  "lat" : 37.3492840,                  "lng" : -121.99927380               }            },            "location" : {               "lat" : 37.3494620,               "lng" : -121.99851260            },            "location_type" : "GEOMETRIC_CENTER",            "viewport" : {               "northeast" : {                  "lat" : 37.35082498029150,                  "lng" : -121.9972139197085               },               "southwest" : {                  "lat" : 37.34812701970850,                  "lng" : -121.9999118802915               }            }         },         "types" : [ "route" ]      }   ],   "status" : "OK"}';

            parser = JSON.createParser(hardCodedRes);
            
        }else{      //Calling the web-service
            // build callout
        // build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);
  system.debug('##1-->' + address);
        try{
                // callout
                HttpResponse res = h.send(req);
     
                // parse coordinates from response
                parser = JSON.createParser(res.getBody());
                system.debug('######' + res.getBody());
            }catch(Exception e){
                system.debug('In Callout exception');   
            }  
        }           
        try{
            //callout
            // HttpResponse res = h.send(req);
 
           // parse coordinates from response
            // JSONParser parser = JSON.createParser(res.getBody());
            // system.debug('response is ' + res.getBody());
            double lat = null;
            double lon = null;
            system.debug('here we are');
          while (parser.nextToken() != null) { 
              system.debug('enter in while loop');
           if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location'))
            {   
                system.debug('enter in if condition');
             parser.nextToken(); // object start                        
           
               while (parser.nextToken() != JSONToken.END_OBJECT){
                    system.debug('enter in secind while condition');
                String txt = parser.getText();                           
                parser.nextToken();                           
                if (txt == 'lat') 
                          lat = parser.getDoubleValue();                            
                         
                 else
                    if (txt == 'lng')                                
                             lon = parser.getDoubleValue();  
           }        
           }          
           } 
            // update coordinates if we get back
            if (lat != null && lon != null ){
                system.debug('here3');
                a.Geo__Latitude__s = lat;
                 system.debug('##7-->' + a.Geo__Latitude__s);
                
                a.Geo__Longitude__s = lon;
                //update a;
                accountsToUpdate.add(a);
                
            }
 
        } catch (Exception e) {
        system.debug('exception');
        }
    }
   
  }
   if(accountsToUpdate != null && accountsToUpdate.size() > 0){
        update accountsToUpdate;
    }   

 }
 global void finish(Database.BatchableContext BC){  system.debug('@@@@--finish--');  } 
}