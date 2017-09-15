//cdevarapalli Loan Backend Phase 2
global class LendingAgreementUtil {

    //Method to Send Lending Agreement call to Mosaic
    webService static String sendLendingAgreement(Id agrmntId){
        
        String errorReason=null;
        echosign_dev1__SIGN_Agreement__c agrmnt = [select Id,Quote__r.Credit_Check_Application__r.Application_Id__c ,echosign_dev1__Status__c from echosign_dev1__SIGN_Agreement__c where Id=:agrmntId];
        List<SpectrumDebugUtility.debugLog> spExLogsList = new List<SpectrumDebugUtility.debugLog>();

        if(agrmnt.Quote__r.Credit_Check_Application__r.Application_Id__c != null){
            if(agrmnt.echosign_dev1__Status__c =='Out for Signature'){
                
                MosaicJSONUtil.MosaicResponse mosResp = Mosaic_API_CallHandler.mosaic_Send_Loan_Agreement(agrmnt.Quote__r.Credit_Check_Application__r.Application_Id__c);
                SpectrumDebugUtility.debugLog spExLog = MosaicIntegrationUtil.prepDebugLog(null,'Mosaic Send Loan Agreement', mosResp.request, mosResp.response);
                spExlog.agreementId = agrmnt.Id;
                spExLogsList.add(spExlog);

                try{
                    SpectrumDebugUtility.generateDebugLog(spExlogsList);
                }catch(Exception e){ExLog.log(e);}
                
                if(mosResp.successful==false){
                    errorReason = mosResp.responsebody;
                }
            }
            else{
                errorReason = 'Not Applicable for Agreement Status:'+agrmnt.echosign_dev1__Status__c;
            }
        }
        else{
            errorReason='No Quote or Credit Check Application found';
        }   
            
        return errorReason;
    }
}