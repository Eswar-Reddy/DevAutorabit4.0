/* **************************************************************************************
* Class Name     : createPOUtil 
* Version        : 1.0 
* Created Date   : 13 Aug 2015
* Function       : Class to verify if it's ok to create PO and check Create PO checkbox

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Chaitanya Devarapalli       13 Aug 2015          Original Version
*************************************************************************************/
global class CreatePOUtil {
    
    webService static String checkPOCreation(Id qotId,String FinancialOffering){
        String errorReason=null;
        if(qotId!=null){
            
            Quote qot = [select OpportunityId,Create_TPS_PO__c,Opportunity.Account.Multiple_Meters__c,Quote_type__c,QuoteType__c,Installation_Model__c, Lease_Doc_Signed__c from Quote where Id = :qotId];
            if(qot.Installation_Model__c!=null){
                Installation_Model__c iModel = [select Roles__c,Type__c from Installation_Model__c where Id=:qot.Installation_Model__c];
                Opportunity opp = [select Id,Name,Account.Partner_Account__r.NH_SSE_Type__c,(select UserId,TeamMemberRole,OpportunityId from OpportunityTeamMembers) from Opportunity where Id=:qot.OpportunityId];
                Set<String> teamMemRoleSet = new Set<String>();
            
                for(OpportunityTeamMember otm:opp.OpportunityTeamMembers){
                    teamMemRoleSet.add(otm.TeamMemberRole);
                }
            
                if(qot.QuoteType__c=='Lease'){
                    String nP=PrepPOLineItems.findMissingRoles(opp.OpportunityTeamMembers,iModel);
                    if(nP==null){
                            List<echosign_dev1__SIGN_Agreement__c> agrmntList = new List<echosign_dev1__SIGN_Agreement__c>([select Id,Quote__c from echosign_dev1__SIGN_Agreement__c where echosign_dev1__Status__c ='Signed' and Quote__c=:qotId]);
                            List<LeasePayment__c> lpList = new List<LeasePayment__c>([select Id from LeasePayment__c where Opportunity__c=:opp.Id and Quote__c!=:qotId  and Status__c!='Terminated']);
                            System.debug('agrmntList ----->'+agrmntList);
                            System.debug('lpList ----->'+lpList);
                            if(!agrmntList.isEmpty()){
                                
                                if(qot.Lease_Doc_Signed__c==false){
                                    if(qot.Opportunity.Account.Multiple_Meters__c==true ||(qot.Opportunity.Account.Multiple_Meters__c==false && lpList.isEmpty())){
                                        qot.Lease_Doc_Signed__c=true;
                                        update qot;
                                    }
                                    else if(qot.Opportunity.Account.Multiple_Meters__c==false && !lpList.isEmpty()){
                                        errorReason = 'Please terminate the existing active lease';
                                    }
                                }
                                else{
                                    errorReason = 'Purchase Order Exists';
                                }
                            }
                            else
                                errorReason = 'Quote does not have a siged agreement';  
                    }
                    else{
                        errorReason = 'The following Opportunity Team Members are not setup: '+nP;
                    }
                }
                else if(qot.QuoteType__c=='Loan'){

                        if(iModel.Type__c=='Manual'){
                            List<String> imList = iModel.Roles__c.split(';');
                            String nP=PrepPOLineItems.findMissingRoles(opp.OpportunityTeamMembers,iModel);
                            
                            System.debug('nP----->'+nP);
                            if(nP!=null){
                                errorReason = 'The following Opportunity Team Members are not setup: '+nP;
                            }  
                            else{
                                if(qot.Lease_Doc_Signed__c==false){
                                    qot.Lease_Doc_Signed__c = true;
                                    update qot;
                                }
                                else{
                                    errorReason = 'Contract Already Signed. Purchase Order Exists';
                                }
                            }
                            
                            
                        }
                        else if(iModel.Type__c=='Auto'){
                            errorReason = 'Not Applicable for Auto type of Installation Model';
                        }
                    
                        
                }
                else{
                    errorReason = 'Not Applicable for this Quote type'+qot.QuoteType__c;
                }
            
            }
            else{
                errorReason = 'There is no Installation Model populated for this Quote';
            }
            return errorReason;
        }
        
        else
            return 'Error: Quote Id is null';
    }
}