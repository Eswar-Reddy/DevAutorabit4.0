@isTest
public class Test_SimulationSunpowercorpCom_Helper{

    //simulationSunpowercorpCom.SalesforceRegistrationSoap PVSIMRegService;
    
    @TestSetup
    public static void testDataSetup() {
        PVSim_Endpoint__c cs = new PVSim_Endpoint__c(name = 'PVSim_Registration', endpoint__c = 'https://test.pvsim.sunpowercorp.com/PVSim/WebServices/SalesforceRegistration.asmx');
        insert cs;
    }
    
    public static TestMethod void SimulationSunpowercorpComTest1(){       
        Test.startTest();
        
        simulationSunpowercorpCom.SFUserRegistrationResponse res = new simulationSunpowercorpCom.SFUserRegistrationResponse();
        simulationSunpowercorpCom.SFUserRegistrationRequest req = new simulationSunpowercorpCom.SFUserRegistrationRequest();
        
        req.SFUserId = '234234234234';
        req.Email = 'test@test.com';
        req.FirstName =  'asfasfasf' ;
        req.LastName = 'dsfsfafaf';
        req.Organization = 'sdfsdfsfsf';
        req.Title = 'sample title1';
        req.PhoneNumber = '13242345572';
        req.UserType = 'None';
               
        Test.setMock(WebServiceMock.class, new simulationSunpowerMockService());
        
        simulationSunpowercorpCom_Helper helper = new simulationSunpowercorpCom_Helper();
        
        res = helper.PVSIM_RegisterUser(req, false, true); 
        
        Test.stopTest();
    }
    
    public static TestMethod void SimulationSunpowercorpComTest2(){
        simulationSunpowercorpCom.OperationResponse res = new simulationSunpowercorpCom.OperationResponse();
        simulationSunpowercorpCom.SFUserConfirmationRequest req = new simulationSunpowercorpCom.SFUserConfirmationRequest();
        
        req.SFUserId = '000123123123';
        req.AccessKey = '123123-123123-123123-123123';
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new simulationSunpowerMockService());
        
        res = PVSIM_validateUser(req, false, true);
        
        Test.stopTest();
    }
    
    public static TestMethod void SimulationSunpowercorpComTest3() {
        //simulationSunpowercorpCom.OperationResponse PVSIM_validateUser(simulationSunpowercorpCom.SFUserConfirmationRequest validationRequest,
        // boolean isInvokedFromTestMethod, boolean isSuccess)
        simulationSunpowercorpCom.ExtensionDataObject extDataObj = new simulationSunpowercorpCom.ExtensionDataObject();
        
        simulationSunpowercorpCom.SFUserConfirmationRequest validationRequest = new simulationSunpowercorpCom.SFUserConfirmationRequest();
        validationRequest.SFUserId = UserInfo.getUserId();
        validationRequest.AccessKey = 'testtest';
        
        simulationSunpowercorpCom.OperationResponse res;
        simulationSunpowercorpCom.SFUserRegistrationResponse resU;
        simulationSunpowercorpCom.SFUserRegistrationRequest reqU = new simulationSunpowercorpCom.SFUserRegistrationRequest();
       
        Test.startTest();
        Test.setMock(WebServiceMock.class, new simulationSunpowerMockService());
        
        simulationSunpowercorpCom_Helper helper = new simulationSunpowercorpCom_Helper();
        res = helper.PVSIM_validateUser(validationRequest,false, false);
        resU = helper.PVSIM_RegisterUser(reqU, false, false);
        
        Test.stopTest();
        
    }
    
    public static simulationSunpowercorpCom.SFUserRegistrationResponse PVSIM_RegisterUser(simulationSunpowercorpCom.SFUserRegistrationRequest req, boolean isInvokedFromTestMethod, boolean isSuccess){
        simulationSunpowercorpCom.SalesforceRegistrationSoap PVSIMRegService = new simulationSunpowercorpCom.SalesforceRegistrationSoap();
        simulationSunpowercorpCom.SFUserRegistrationResponse resgistrationResponse = new simulationSunpowercorpCom.SFUserRegistrationResponse();

        if(isInvokedFromTestMethod){
            resgistrationResponse = PVSIMRegService.RegisterUser(req, true, isSuccess);            
        }else{
            resgistrationResponse = PVSIMRegService.RegisterUser(req, false, true);
        }  
                
        return resgistrationResponse; 
    }
    
    public static simulationSunpowercorpCom.OperationResponse PVSIM_validateUser(simulationSunpowercorpCom.SFUserConfirmationRequest validationRequest, boolean isInvokedFromTestMethod, boolean isSuccess){
        simulationSunpowercorpCom.SalesforceRegistrationSoap PVSIMRegService = new simulationSunpowercorpCom.SalesforceRegistrationSoap();
        simulationSunpowercorpCom.OperationResponse validationResponse = new simulationSunpowercorpCom.OperationResponse();
        
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