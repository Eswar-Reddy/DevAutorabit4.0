/**
 LeadConvertValidation
   
   
      Created date:4/23/10
      Created By: Accenture
      Last Updated Date: 4/28/10
      Last Updated By:Accenture
        
 ****** Version Control History  ******
 
   4/23/10 -Intial Design Framed for trigger-
   Creating initial version of code which has to be modified in order to follow 
        
   4/26/10 - Review comment given-
      Review comment for this suggests to add proper documentation, Follow proper naming Standrads, and clearly 
      depicts each and every method with an user friendly documentation
       
   4/28/10 - Incorporating those review comments
      All the review comments have been incorporated as suggested in the build review document.  

   4/28/10 - Creating Apex clases and calling trigger from that
      Based on the review comments, we are invoking the apex trigger form inside a trigger.  


*/


public class LeadConvertValidationCls{
    public static void beforeInsertUpdateLead(List<Lead> leadList){
        for(Lead objLead :leadList){
          
   
             //***********Update the Hidden Fields to Validate the Approval Process ***********
               
               objLead.HD_Business_Unit__c = objLead.Business_Unit__c;
               objLead.HD_Lead_Status__c = objLead.Status;
               
            
 
            
            
        }
    }
}