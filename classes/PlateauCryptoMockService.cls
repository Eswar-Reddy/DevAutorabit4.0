@isTest                      
global class PlateauCryptoMockService implements WebServiceMock {
   
    global void doInvoke (
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {/*
           PlateauCrypto.encryptWithReturnLiveURLResponse respElement = new PlateauCrypto.encryptWithReturnLiveURLResponse();
            response.put('response_x', respElement);    */
   }
    
}