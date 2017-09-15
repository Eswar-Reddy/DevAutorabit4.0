/***
    Created By: Ralph Alega 
    Company: Cloudsherpas
    Date: 02/01/2014
    Purpose: Controller Class for DealerComplianceCompletion Page. 
             Controls the details needed to be shown on Compliance Completion page and the DML operation to update the fields onclick of Submit button
***/

public class DealerComplianceCompletionCC {
        
    public Id DCRId;        //Dealer Compliance Requirements Id for update
    public Map<Id, Dealer_Compliance_Requirement__c> dealerComplianceReqToUpdate;   //Map of Dealer Compliance Requirement record to update
    
    public Dealer_Compliance_Requirement__c DCompReq {get; set;}    //Current Dealer Compliance Requirement record 
     
    private final Dealer_Compliance_Requirement__c DCRrecord;   //Get Record Dealer_Compliance_Requirement__c variable
     
    public Id parentOppId {get; set;}   //Parent Opportunity Id 
    
    public DealerComplianceCompletionCC(ApexPages.StandardController controller) {
        
        this.DCRrecord = (Dealer_Compliance_Requirement__c)controller.getRecord();
        
        getDCompReq();
                                                                                    
    }
     
    //Get values of the current Dealer Compliance Requirement record
    public void getDCompReq() {
            
        dealerComplianceReqToUpdate = new Map<Id, Dealer_Compliance_Requirement__c>();
        
        //Query on the Dealer Compliance Requirement object to get the current record to update     
        DCompReq = [SELECT Id, Opportunity__c, Dealer_Name__c, Opportunity_Owner__c, Opportunity__r.Name, Compliance_Description__c, 
                                Compliance_Completed__c, Status__c, Date_Completed__c, Completed_By__c
                         FROM Dealer_Compliance_Requirement__c 
                         WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
        
        dealerComplianceReqToUpdate.put(DCompReq.Id , DCompReq);                                                     
        DCRId = DCompReq.Id; 
        parentOppId = DCompReq.Opportunity__c;                                                                              

     }
     
     //Save Button Method (Redirect to Parent Opportunity when the process is complete)
     public pageReference saveBtn(){

        if(DCRId != null && dealerComplianceReqToUpdate.get(DCRId).Compliance_Completed__c == true){    //Set the fields to update if Compliance Completed field is equal to TRUE
                
            dealerComplianceReqToUpdate.get(DCRId).Compliance_Completed__c = true;   
            dealerComplianceReqToUpdate.get(DCRId).Status__c = 'Completed';  
            dealerComplianceReqToUpdate.get(DCRId).Date_Completed__c = date.Today();
            dealerComplianceReqToUpdate.get(DCRId).Completed_By__c = UserInfo.getUserId();

            update dealerComplianceReqToUpdate.get(DCRId);
            
        }else{  //Set the fields back to null if Compliance Completed field is equql to FALSE
            
            dealerComplianceReqToUpdate.get(DCRId).Compliance_Completed__c = false;
            dealerComplianceReqToUpdate.get(DCRId).Status__c = 'Open';
            dealerComplianceReqToUpdate.get(DCRId).Date_Completed__c = null;
            dealerComplianceReqToUpdate.get(DCRId).Completed_By__c = null;
            
            update dealerComplianceReqToUpdate.get(DCRId);
        }
        
        PageReference pageRef = new PageReference('/'+parentOppId);
        pageRef.setRedirect(true);
        return pageRef;
     }
     
     //Cancel Button Method (Redirect to Parent Opportunity when the process is complete)
     public pageReference cancelBtn(){
        PageReference pageRef = new PageReference('/'+parentOppId);
        pageRef.setRedirect(true);
        return pageRef;
     }
    
}