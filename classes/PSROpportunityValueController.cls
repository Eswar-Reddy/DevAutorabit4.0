public class PSROpportunityValueController{
    
  public String PSRId {get; set;}
  public String oppPer {get; set;}
  public String systemAnalyst {get;set;}
 
 // public Decimal sysSizeKwp {get;set;}
  
  public PSR__c PSRObj {
    get {
   
      
      if (PSRObj != null) {
        return PSRObj ;
      }
      
      if (PSRId != null && PSRId != '') {
        PSRObj = [Select Opportunity__c, Opportunity__r.Owner.Name, Opportunity_Name__c, New_Matter_or_Continued_Assistance__c, Approved_by_Regional_Leader__c, Expense_in_approved_project_budget__c, Expense_in_general_OpEx__c, Amount_Budgeted_Quarter__c, CapEx_or_OpEx_Check_w_Sales_Ops_FP_A__c, Scope_Summary__c, First_Deadline__c, First_Deadline_Scope__c, Second_Deadline__c, Second_Deadline_Scope__c, Third_Deadline__c, Third_Deadline_Scope_i_e_bid_due__c From PSR__c where Id = :PSRId ];
  
       
        systemAnalyst = '';
      
        List<OpportunityTeamMember> oppTeamMem = [Select id, User.Name, TeamMemberRole , OpportunityId from OpportunityTeamMember 
                                                        where OpportunityId = :PSRObj.Opportunity__r.Id and TeamMemberRole in ('Sales Analyst') ];
       if (oppTeamMem.size() > 0) {
        
        for (OpportunityTeamMember oppTeam :oppTeamMem  ) {
            
            if (oppTeam.TeamMemberRole == 'Sales Analyst' ) {
                if (systemAnalyst != '')
                    systemAnalyst += ', ' + oppTeam.User.Name;
                else
                    systemAnalyst += oppTeam.User.Name ;
            }
           
            
        }
       } 
      }
      
      return PSRObj;
    }
    set;
  }

}