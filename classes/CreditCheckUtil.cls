//
public class CreditCheckUtil {
    
    //
    public static Set<String> getPartnerPermissions(){
        Set<String> permissions = new Set<String>();
        if(UserInfo.getUserType()!='Standard'){
            List<User> usrList = [select Id, Contact.Account.Business_Function__c, Business_Function__c, Contact.Account.Lease2_0_Program_Partner__c, Contact.Account.Loan_Partner__c,Contact.Account.Cash_Partner__c  from User WHERE ContactId <> null AND Id=:UserInfo.getUserId() AND isActive= true];
            System.debug('usrList----->'+usrList);
            if(!usrList.isEmpty()){
                if(string.isNotBlank(usrList[0].Business_Function__c)){
                    Set<String> sUsrBF = new Set<String>();
                    sUsrBF.addAll(usrList[0].Business_Function__c.split(';'));
                    if(usrList[0].Contact.Account.Lease2_0_Program_Partner__c == true && sUsrBF.contains('Create Lease Quote') == true ){
                        permissions.add('Lease');
                    }
                    if(usrList[0].Contact.Account.Loan_Partner__c == true && sUsrBF.contains('Create Loan Quote') == true ){
                        permissions.add('Loan');
                    }
                    if(usrList[0].Contact.Account.Cash_Partner__c == true && sUsrBF.contains('Create Cash Quote') == true ){
                        permissions.add('Cash');
                    }
                }    
            }   
        }
        else{
            permissions.add('Lease');
            permissions.add('Loan');
            permissions.add('Cash');
        }
        return permissions;
    }
    
    @future(callout=true)
    public static void SendCreditRequest_LoanPath(String ccrId,String partnerUrl,String sessionId,String strActParam,Boolean newHomes){
        System.debug('----->'+sessionId);
        System.debug('----->'+UserInfo.getUserId());
        System.debug('----->'+UserInfo.getUserName());
        //String nh = newHomes == TRUE ? 'NewHome,true' : 'NewHome,false';
        //String nh = 'NewHome,true';
        User user = [SELECT id, country_domain__c, name FROM User WHERE id=:UserInfo.getUserId()];
        system.debug('nh:'+newHomes);
        system.debug('ccrId:'+ccrId);
        system.debug('partnerUrl:'+partnerUrl);
        system.debug('sessionId:'+sessionId);
        system.debug('strActParam:'+strActParam);
        String result_status = '';
        if(newHomes){
            result_status = TPSSF.TPConnectorService.SubmitExt(
                                               'Credit_Check_Request__c',
                                                ccrId,
                                                 '' ,
                                                 '' ,
                                                'save',
                                                '' ,
                                                '',
                                                UserInfo.getUserId(),
                                                sessionId,
                                                PartnerUrl, 
                                                UserInfo.getUserName(), 
                                                (strActParam == 'ncr' ? 'CreateRequest' : 'ReSendEmail'),
                                                user.country_domain__c.substring(user.country_domain__c.indexOf('-')+1),
                                                'NewHome,true');
         }
         else{
             result_status = TPSSF.TPConnectorService.SubmitExt(
                                               'Credit_Check_Request__c',
                                                ccrId,
                                                 '' ,
                                                 '' ,
                                                'save',
                                                '' ,
                                                '',
                                                UserInfo.getUserId(),
                                                sessionId,
                                                PartnerUrl, 
                                                UserInfo.getUserName(), 
                                                (strActParam == 'ncr' ? 'CreateRequest' : 'ReSendEmail'),
                                                user.country_domain__c.substring(user.country_domain__c.indexOf('-')+1),
                                                'NewHome,false');
         }                                       
        system.debug('result_status:'+result_status);
        
        if((!String.isBlank(result_status) && !result_status.contains('SUCCESS'))){
            Credit_Check_Request__c ccr = new Credit_Check_Request__c(Id=ccrId,Send_Lease_Credit_Check_Failure_Email__c = true, Credit_Check_Message__c = result_status);
            update ccr;
        }
    }
}