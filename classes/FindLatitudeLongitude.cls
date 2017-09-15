global class FindLatitudeLongitude {
  /*webservice static String[] getLatitudeLongitude(String AccId){
  Account myAccount = [select name,Country__c,City__c,State_Province__c,Address_Line_1__c  from Account where id=:AccId]; 
  String url = 'http://maps.google.com/maps/geo?';
      url += 'q=' +EncodingUtil.urlEncode(myAccount.City__c  != null ? myAccount.City__c : '','UTF-8');
      url += ',' + EncodingUtil.urlEncode(myAccount.State_Province__c != null ? myAccount.State_Province__c : '','UTF-8');
      url +=  ',' + EncodingUtil.urlEncode(myAccount.Country__c != null ? myAccount.Country__c : '','UTF-8');
      url += '&output=csv&key=ABQIAAAAhC6OJ1YpP4iUTmXGVsELvBST0mNpJvtWvmgvEdrgGXs5szHHahTxbwG_fk8LpXCk2_8h6LRu46O2nw';
      Http h = new Http();
      HttpRequest req = new HttpRequest();
      req.setHeader('Content-type', 'application/x-www-form-urlencoded');
      req.setHeader('Content-length', '0');
      req.setEndpoint(url);
      req.setMethod('POST');
      HttpResponse res = h.send(req);
      String responseBody =  res.getBody();
      String[] cor = responseBody.split(',',0);
      return cor;
  }
  */
  webservice static String[] getLatitudeLongitude(String referId,String referName){
  Account myAccount = null;
  if(referId != null && referId != 'null' && referId != '')
    myAccount = [select name,BillingCountry,BillingCity,BillingState,BillingStreet from Account where id =:referId];
  else if(referName != null && referName != 'null' && referName !='')
    myAccount = [select name,BillingCountry,BillingCity,BillingState,BillingStreet  from Account where Name =:referName];
  String url = 'http://maps.google.com/maps/geo?';
      //url += 'q=' +EncodingUtil.urlEncode(myAccount.BillingCity  != null ? myAccount.BillingCity : '','UTF-8');
      url += 'q=' + EncodingUtil.urlEncode(myAccount.BillingStreet != null ? myAccount.BillingStreet : '','UTF-8');
      url += ',' + EncodingUtil.urlEncode(myAccount.BillingCity  != null ? myAccount.BillingCity : '','UTF-8');
      url += ',' + EncodingUtil.urlEncode(myAccount.BillingState != null ? myAccount.BillingState : '','UTF-8');
      url +=  ',' + EncodingUtil.urlEncode(myAccount.BillingCountry != null ? myAccount.BillingCountry : '','UTF-8');
      url += '&output=csv&key=ABQIAAAAhC6OJ1YpP4iUTmXGVsELvBST0mNpJvtWvmgvEdrgGXs5szHHahTxbwG_fk8LpXCk2_8h6LRu46O2nw';
      Http h = new Http();
      HttpRequest req = new HttpRequest();
      req.setHeader('Content-type', 'application/x-www-form-urlencoded');
      req.setHeader('Content-length', '0');
      req.setEndpoint(url);
      req.setMethod('POST');
      HttpResponse res = h.send(req);
      String responseBody =  res.getBody();
      String[] cor = responseBody.split(',',0);
      return cor;
  }
  webservice static String[] getLatitudeLongitudeOfAddress(String Country,String State,String City,String Street){
    String url = 'http://maps.google.com/maps/geo?';
      url += 'q=' + EncodingUtil.urlEncode(Street != null ? Street : '','UTF-8');
      url += ',' + EncodingUtil.urlEncode(City  != null ? City : '','UTF-8');
      url +=  ',' + EncodingUtil.urlEncode(State  != null ? State : '', 'UTF-8');
      url +=  ',' + EncodingUtil.urlEncode(Country  != null ? Country : '', 'UTF-8');
      url += '&output=csv&key=ABQIAAAAhC6OJ1YpP4iUTmXGVsELvBST0mNpJvtWvmgvEdrgGXs5szHHahTxbwG_fk8LpXCk2_8h6LRu46O2nw';
      Http h = new Http();
      System.debug('url:' + url);
      HttpRequest req = new HttpRequest();
      req.setHeader('Content-type', 'application/x-www-form-urlencoded');
      req.setHeader('Content-length', '0');
      req.setEndpoint(url);
      req.setMethod('POST');
      HttpResponse res = h.send(req);
      String responseBody =  res.getBody();
      String[] cor = responseBody.split(',',0);
      return cor;
  }
}