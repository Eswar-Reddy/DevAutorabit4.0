public class simulationSunpowercorpCom_Helper{

    //simulationSunpowercorpCom.SalesforceRegistrationSoap PVSIMRegService;
    
    public void simulationSunpowercorpCom_Helper(){
        //simulationSunpowercorpCom.SalesforceRegistrationSoap PVSIMRegService = new simulationSunpowercorpCom.SalesforceRegistrationSoap();
    }
    
    public simulationSunpowercorpCom.SFUserRegistrationResponse PVSIM_RegisterUser(simulationSunpowercorpCom.SFUserRegistrationRequest resgistrationRequest, boolean isInvokedFromTestMethod, boolean isSuccess){
        simulationSunpowercorpCom.SalesforceRegistrationSoap PVSIMRegService = new simulationSunpowercorpCom.SalesforceRegistrationSoap();
        Map<String, PVSim_Endpoint__c> pvSimEndpoint = PVSim_Endpoint__c.getAll();
        
        PVSIMRegService.endpoint_x = pvSimEndpoint.get('PVSim_Registration').endpoint__c;
         
        simulationSunpowercorpCom.SFUserRegistrationResponse resgistrationResponse = new simulationSunpowercorpCom.SFUserRegistrationResponse();

        system.debug('######CaLLING Helper class method... ########');  
        
        if(isInvokedFromTestMethod){
            resgistrationResponse = PVSIMRegService.RegisterUser(resgistrationRequest, true, isSuccess);            
        }else{
            resgistrationResponse = PVSIMRegService.RegisterUser(resgistrationRequest, false, true);
        }  
                
        return resgistrationResponse; 
    }
    
    public simulationSunpowercorpCom.OperationResponse PVSIM_validateUser(simulationSunpowercorpCom.SFUserConfirmationRequest validationRequest, boolean isInvokedFromTestMethod, boolean isSuccess){
        simulationSunpowercorpCom.SalesforceRegistrationSoap PVSIMRegService = new simulationSunpowercorpCom.SalesforceRegistrationSoap();
        simulationSunpowercorpCom.OperationResponse validationResponse = new simulationSunpowercorpCom.OperationResponse();
        
        Map<String, PVSim_Endpoint__c> pvSimEndpoint = PVSim_Endpoint__c.getAll();
        PVSIMRegService.endpoint_x = pvSimEndpoint.get('PVSim_Registration').endpoint__c;
        
        try{   
        
            if(isInvokedFromTestMethod){
                validationResponse = PVSIMRegService.ConfirmRegistration(validationRequest, true, isSuccess);
            }else{
                validationResponse = PVSIMRegService.ConfirmRegistration(validationRequest, false, true);
            }         
        
            return validationResponse; 
        
        }catch(CalloutException ce){
            return validationResponse;
        }catch(Exception ex){
            return validationResponse;
        }
    }
    
    
}