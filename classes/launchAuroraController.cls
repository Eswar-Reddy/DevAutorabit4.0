public class launchAuroraController {
    
    private final Id accountId{get;set;}
    private final Id roofDesignId{get;set;}
    private final String action{get;set;}

    public Boolean isPartnerUser {
        get {
            return SPCommunityUtility.isPartnerUser();
        }
    }
    
    public launchAuroraController() {
        roofDesignId = apexpages.currentpage().getparameters().get('roofDesignId');
        accountId = apexpages.currentpage().getparameters().get('accountId');
        action  = apexpages.currentpage().getparameters().get('action');
        System.debug('roofDesignId----->'+roofDesignId);
        System.debug('accountId----->'+accountId);
        System.debug('action----->'+action);
    }
    
    public PageReference forwardtoAurora(){
        System.debug('roofDesignId----->'+roofDesignId);
        System.debug('accountId----->'+accountId);
        System.debug('action----->'+action);
        String	auroraDesignId;
        String	auroraProjectId;
        Loan_Callout_Settings__c acs = Loan_Callout_Settings__c.getInstance('Aurora');
        System.debug('roofDesignId----->'+roofDesignId);
        
        if(action!=null && action=='CreateProject'){
            auroraProjectId = AuroraAPICallHandler.CreateProjectfromAccount(accountId,action);
            if(auroraProjectId==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AuroraAPICallHandler.errorMessage));
                return null;
            }
        }
        else if(action!=null && action=='CreateDesign'){

            Roof_Design__c rd = [SELECT Id,
                                    Name,
                                    Account_Name__c,
                                    Account_Name__r.Name,
                                    Account_Name__r.Design_ProjectId__c,
                                    Account_Name__r.External_Design_ProjectId__c,
                                    Design_DesignId__c
                                    FROM Roof_Design__c
                                    WHERE Id = :roofDesignId];

            if(Userinfo.getUserType() != 'Standard'){
                auroraProjectId = rd.Account_Name__r.External_Design_ProjectId__c;
            }
            else{
                auroraProjectId = rd.Account_Name__r.Design_ProjectId__c;
            }
            System.debug('auroraProjectId----->'+auroraProjectId);
            auroraDesignId = AuroraAPICallHandler.CreateDesign(rd, auroraProjectId);
            if(auroraDesignId==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AuroraAPICallHandler.errorMessage));
                return null;
            }
        }
        
        if(auroraProjectId!=null){
            String auroraAuthURL = '';
            String auroraRedirectURI = '';
            string userType = acs.UserType_Internal__c;
            if(Userinfo.getUserType()!='Standard')
                userType=acs.UserType_Partner__c;
            if(Userinfo.getOrganizationId()==Label.Production_Org_Id){
                auroraAuthURL = acs.AuthURL_Production__c ;
                auroraRedirectURI = acs.Redirect_URI_Production__c;
            } 
            else{
                auroraAuthURL = acs.AuthURL_Sandbox__c;
                auroraRedirectURI = acs.Redirect_URI_Sandbox__c;
            }
            
            PageReference pageRef = new PageReference(auroraAuthURL+'/'+userType+auroraRedirectURI+'projects\\'+auroraProjectId);
			System.debug('pageRef= '+pageRef);
            return pageRef;
        }
        else{
            
            return null;
        }
            
    }
    
}