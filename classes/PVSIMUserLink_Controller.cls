global class PVSIMUserLink_Controller{

    public boolean isUserValid{get; set;}
    public static FINAL String IS_REGISTRATION_OK = 'ok';
    public static FINAL String IS_REGISTRATION_FAIL = 'fail';
    public static FINAL String IS_INVALID_PARAMETERS = 'InvalidParameters';
    public static FINAL String IS_VALIDATION_SUCCESS = 'success';
    public static FINAL String IS_VALIDATION_FAIL = 'fail';
    public static FINAL String IS_USER_ALREADY_CONFIRMED = 'SF user is already confirmed';
    public String pvSimLoginUrl{get; set;}
    public boolean userRedirectSuccess{get; set;}
    global boolean isInvokedFromTestMethod = false;
        
    public User loggedInUser;
    
    
    public PVSIMUserLink_Controller(){
        isUserValid = false;
        loggedInUser = [select id, name, email, firstName, LastName, Profile.Name, CompanyName, Title, Phone, Portal_User_Type__c, contact.Account.Country_Domain__c, PVSIM_Access_Key__c, Contact.Account.Type, Contact.Account.Name from User where ID =: UserInfo.getUserId() limit 1];
        system.debug('########## isUserValid1 ' + isUserValid);
    }    
    
    public void RedirectUser(){
        //Map<String, Account_Types__c> accountTypes = new Map<String, Account_Types__c>();
        Map<String, Account_Country_Domains__c> countryDomains = Account_Country_Domains__c.getAll();
        Map<String, Account_Types__c> accountType = Account_Types__c.getAll();
        
        system.debug('########## isUserValid2 ' + isUserValid);
                
        if(countryDomains.keySet().size() ==  0){
            system.debug('############## checking countryDomains.keySet().size()...');
            isUserValid = false;
        }
                               
        if(loggedInUser.contact.Account.Country_Domain__c != null && loggedInUser.contact.Account.type != null){
            if((countryDomains.get(loggedInUser.contact.Account.Country_Domain__c) != null && accountType.get(loggedInUser.contact.Account.type) != null) && accountType.get(loggedInUser.contact.Account.type).is_valid__c.equalsIgnoreCase('y') && countryDomains.get(loggedInUser.contact.Account.Country_Domain__c).is_valid__c.equalsIgnoreCase('y')){
                system.debug('############## checking countryDomains exists');
                isUserValid = true;        
            }else{
                system.debug('############## checking countryDomains does not exists');
                isUserValid = false;
                
            }    
        }  
        system.debug('#####################isUserValid3 ' + isUserValid );
    }
        
    public void checkUserForAccessKey(){                       
        system.debug('######loggedInUser.PVSIM_Access_Key__c ');       
        if(loggedInUser.PVSIM_Access_Key__c != null){
            // redirect user to the PVSIM's Login Link - call the method to redirect
            RedirectUserToPVSIMLogin(loggedInUser.Id, loggedInUser.PVSIM_Access_Key__c);
            system.debug('######### pvSimLoginUrl ' + pvSimLoginUrl);
        }else{
            // call the method to register for the PVSIM Service, update the user record and then Redirect the user to PVSIM's login
            RegisterUserForPVSIMService();
        }             
    }
    
    public void RedirectUserToPVSIMLogin(String sfdcUserId, String accessKey){

        simulationSunpowercorpCom_Helper pvsimHelper = new simulationSunpowercorpCom_Helper();
        simulationSunpowercorpCom.OperationResponse validationResponse = new simulationSunpowercorpCom.OperationResponse();
        simulationSunpowercorpCom.SFUserConfirmationRequest validationRequest = new simulationSunpowercorpCom.SFUserConfirmationRequest();
        
        validationRequest.SFUserId = sfdcUserId;
        validationRequest.AccessKey = accessKey;
        
        validationResponse = pvsimHelper.PVSIM_validateUser(validationRequest, isInvokedFromTestMethod, true);
        system.debug('############ validationResponse : ' + validationResponse);
        simulationSunpowercorpCom.ArrayOfString err_Msgs = validationResponse.Messages; 
        
        if(validationResponse.Status.equalsIgnoreCase(IS_VALIDATION_FAIL)  && err_Msgs.string_x[0].equalsIgnoreCase(IS_USER_ALREADY_CONFIRMED)){
            
            userRedirectSuccess = true;
            pvSimLoginUrl = 'https://pvsim.sunpowercorp.com/pvsim/SFLogin.aspx?userId=' + sfdcUserId + '&accessKey=' + accessKey; 

        }else if(validationResponse.Status.equalsIgnoreCase(IS_VALIDATION_FAIL)){
            //redirect the user to the error page
            userRedirectSuccess = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'We are sorry, your attempt to access SunPower PVSim has failed. Please try again later. If you continue to experience this issue, please contact your system administrator.');
            ApexPages.addmessage(myMsg);
            
        }else if(validationResponse.Status.equalsIgnoreCase(IS_VALIDATION_SUCCESS)){
            //redirect the user to PVSIM Login link
            userRedirectSuccess = true;
            pvSimLoginUrl = 'https://pvsim.sunpowercorp.com/pvsim/SFLogin.aspx?userId=' + sfdcUserId + '&accessKey=' + accessKey; 
            
        }else{
            userRedirectSuccess = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'We are sorry, your attempt to access SunPower PVSim has failed. Please try again later. If you continue to experience this issue, please contact your system administrator.');
            ApexPages.addmessage(myMsg);
        }

    }
    
    public void RegisterUserForPVSIMService(){
        //this method calls the PVSIM web-service and update the User object with the access key.
        simulationSunpowercorpCom_Helper pvsimHelper = new simulationSunpowercorpCom_Helper();
        simulationSunpowercorpCom.SFUserRegistrationResponse resgistrationResponse = new simulationSunpowercorpCom.SFUserRegistrationResponse();
        simulationSunpowercorpCom.SFUserRegistrationRequest resgistrationRequest = new simulationSunpowercorpCom.SFUserRegistrationRequest();
        simulationSunpowercorpCom.ArrayOfString regions = new simulationSunpowercorpCom.ArrayOfString();
        regions.string_x = new List<String>{loggedInUser.contact.Account.Country_Domain__c};
        
        resgistrationRequest.SFUserId = loggedInUser.Id;
        resgistrationRequest.Email = loggedInUser.Email;
        resgistrationRequest.FirstName = loggedInUser.FirstName != null ? loggedInUser.FirstName : loggedInUser.LastName ;
        resgistrationRequest.LastName = loggedInUser.LastName;
        resgistrationRequest.Organization = loggedInUser.Contact.Account.Name;
        resgistrationRequest.Title = loggedInUser.Profile.Name;
        resgistrationRequest.PhoneNumber = loggedInUser.Phone;
        resgistrationRequest.UserType = loggedInUser.Contact.Account.Type;
        resgistrationRequest.Regions= regions;
        
        try{
            resgistrationResponse = pvsimHelper.PVSIM_RegisterUser(resgistrationRequest, isInvokedFromTestMethod, true);
            system.debug('#################### resgistrationRequest : ' + resgistrationRequest );
            system.debug('#################### resgistrationResponse : ' + resgistrationResponse );
            if(resgistrationResponse != null && (resgistrationResponse.OperationResult.equalsIgnoreCase(IS_REGISTRATION_FAIL) || resgistrationResponse.OperationResult.equalsIgnoreCase(IS_INVALID_PARAMETERS))){
                //Redirect to error page or send an email
                system.debug('##########After getting resgistrationResponse: ');
                userRedirectSuccess = false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'We are sorry, your attempt to access SunPower PVSim has failed. Please try again later. If you continue to experience this issue, please contact your system administrator.');
                ApexPages.addmessage(myMsg); 
            }else if(resgistrationResponse.OperationResult.equalsIgnoreCase(IS_REGISTRATION_OK)){               
                // if the userobject is updated, redirect the user to PVSIM's login service - call the RedirectUserToPVSIMLogin method
                RedirectUserToPVSIMLogin(loggedInUser.Id, resgistrationResponse.AccessKey);
                
                //update the loggedInUser with the accessKey received
                updateLoggedInUser(loggedInUser.Id, resgistrationResponse.AccessKey);
            }
        }catch(Exception e){
            userRedirectSuccess = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'We are sorry, your attempt to access SunPower PVSim has failed. Please try again later. If you continue to experience this issue, please contact your system administrator.');
            ApexPages.addmessage(myMsg);
        }  
    }
   
    @future
    public static void updateLoggedInUser(String userId, String accessKey){
        User userToUpdate = [select id, PVSIM_Access_Key__c from User where ID =: userId];
        
        if(userToUpdate != null){
            userToUpdate.PVSIM_Access_Key__c = accessKey;
            update userToUpdate;
        }    
    }   
}