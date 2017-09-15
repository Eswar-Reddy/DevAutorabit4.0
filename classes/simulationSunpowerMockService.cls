@isTest                      
global class simulationSunpowerMockService implements WebServiceMock {
   
    global void doInvoke (
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
           simulationSunpowercorpCom.RegisterUserResponse_element respElement = new simulationSunpowercorpCom.RegisterUserResponse_element();
            response.put('response_x', respElement);                     
   }
    
}