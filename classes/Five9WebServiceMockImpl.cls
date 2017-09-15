@isTest                      
global class Five9WebServiceMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           Five9ComWSDL2Apex.addRecordToListSimpleResponse respElement = 
               new Five9ComWSDL2Apex.addRecordToListSimpleResponse();
           response.put('response_x', respElement); 
   }
}