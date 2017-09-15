public with sharing class ProxySpectrum {
	
	//final String ifmSpectrumEndpoint {get;private set;}
	//final String credentials {get; private set;}
	//String sessionKey {get;private set;}
	//String serverUrl {get;private set;}
	//String informaticaError {get; private set;}
	
	//public ProxySpectrum(String endPoint){
		
	//	ifmSpectrumEndpoint = endPoint;//'';
		
	//	//spectrumLogin();
	//}
	
	//public enum RequestType{SPECTRUM}
	
	//public HTTPRequest buildRequest(String body){
		
	//	//check for session
	//	//if(sessionKey == null)
	//	//	spectrumLogin();
		
	//	HttpRequest request = new HttpRequest();
		
	//	//request.setEndpoint(serverUrl + 'someurlmappingheretocustomservice');
	//	request.setEndpoint(ifmSpectrumEndpoint);
	//	request.setMethod('POST');
	//	request.setHeader('Charset', 'UTF-8');
	//	request.setTimeout(60000);
	//	request.setBody('json=' + body);
	//	//request.setHeader('icSessionId',sessionKey);
		
		

		

	//	return request;
	//}
	
	//public HTTPResponse sendRequest(HTTPRequest request){
		
	//	Http h = new Http();
	//	HttpResponse response;
		
	//	try{
	//		if(Test.isRunningTest()){
	//			response = new HttpResponse();
	//			response.setStatusCode(200);
	//			String responseString = '{"responses":[';
				
	//			responseString += ']}';
	//			response.setBody('{"responses":[{"recordId":null,"result":"Created Spectrum Id 28712","accountId":null,"accountName":"SunPower Test LLC"}]}');
	//			return response;
	//		}
	//		response = h.send(request);
	//	}
	//	catch(CalloutException ce){
	//		SunPowerException.recordErrorService('ProxySpectrum','sendRequest','JSON Payload: ' + response.getBody() + ' EXCEPTION: ' + ce.getMessage(),'Outbound Lead Service Call');
	//	}
	//	catch(Exception e){
	//		SunPowerException.recordErrorService('ProxySpectrum','sendRequest','JSON Payload: ' + response.getBody() + ' EXCEPTION: ' + e.getMessage(),'Outbound Lead Service Call');
	//	}
		
	//	return response;
	//}
	
	///*private void spectrumLogin(){
	//	String userName = '';
 //       String password = '';
 //       HttpRequest req = new HttpRequest();
 //       HttpResponse res = new HttpResponse();
 //       Http http = new Http();     
  
 //       req.setEndPoint(ifmSpectrumEndpoint);
 //       req.setHeader('HTTP', '1.0');
 //       req.setHeader('Content-Type', 'application/xml');
 //       req.setHeader('Accept', 'application/xml');
 //       req.setBody('<login><username>' + userName + '</username><password>' + password + '</password></login>');                          
 //       req.setMethod('POST');
                 
 //       try {
 //           res = http.send(req);
 //           if(res.getBody().contains('<icSessionId>')){
 //               sessionKey = getValueFromXMLString(res.getBody(), 'icSessionId');
 //               serverUrl = getValueFromXMLString(res.getBody(), 'serverUrl');
 //           }else{
 //               informaticaError = res.getBody();
 //           }          
 //       } catch(Exception e) {
 //       	throw new InformaticaException('Error logging in to Informatica. Response: ' + res.toString(),e,'SF To Informatica. Login Error.');            
 //       }
	//}*/
 	
 //	private static String encodeUrl(String stringToEncode){
 //		stringToEncode = stringToEncode.replaceAll('%','%25');
 //		stringToEncode = stringToEncode.replaceAll('\\s','%20');
 //		stringToEncode = stringToEncode.replaceAll('"','%22');
 //		stringToEncode = stringToEncode.replaceAll('\\$','%24');
 //		stringToEncode = stringToEncode.replaceAll('&','%26');
 		
 //		return stringToEncode;
 //	}
	
}