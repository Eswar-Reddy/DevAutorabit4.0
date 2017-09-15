public class OpportunityValuesController {
    
  public String oppID {get; set;}
  public String oppPer {get; set;}
  public Decimal OppLineSystemSize {get; set;}
  public String prodName {get;set;}
  public String systemAnalyst {get;set;}
  public String projectManager {get;set;}
  public String proposalDesigner {get;set;}
  public String projectDesigner {get;set;}
  public String structuredFinance {get;set;}
 // public Decimal sysSizeKwp {get;set;}
  
  public Opportunity OppObj {
    get {
      System.debug('Debug: oppId ' + oppId);
      
      if (OppObj != null) {
        return OppObj;
      }
      
      if (oppId != null && oppId != '') {
        OppObj = [Select Owner.Name,Name, CloseDate, Expected_Commercial_Operation_Date__c, ASP_New_del__c,
                        BOS_s_w__c , PV_s_w__c , Other_Cost_W__c, System_Size_KwP__c, System_Size__c,
                        Installation_Date__c, Probability,System_SizePV__c, System_SizeBOS__c, Contract_Type__c, NextStep, StageName,
                        Business_Unit__c, Sales_Analyst__r.Name, Project_Manager__c, Account.Name,
                        PV_Cost_Sys__c, Gross_Margin__c, Gross_Margin_percent__c ,Lead_Analyst__c
                        From Opportunity Where Id = :oppId];
       
        prodName= '';
       // sysSizeKwp = 0;
        OppLineSystemSize = 0;
        //EAL_03082016: additional line
        //Case 00670323 - exclude Total Price (Excluding O&M)
        List<string> excluded = new List<string>(); 
        for(OppItemtoExcludeinEmailTemplate__c excl: OppItemtoExcludeinEmailTemplate__c.getAll().values()){
            excluded.add(excl.Opp_Line_Item_Product_ID__c);
        }   
        //Case 00670323: additional condition on where clause; 
        List<OpportunityLineItem> lstOppLineItem = [Select PricebookEntry.Product2.Name, System_Size__c, Product_Type__c, Product_Family__c, Estimate__r.System_Size_kWp__c, Id From OpportunityLineItem  where OpportunityId = :oppId AND PricebookEntry.Product2.Id NOT IN:excluded];
        
            if (lstOppLineItem.size() > 0) {
                
                for( OpportunityLineItem ol :lstOppLineItem ) {
                    
                    // Case 00043292 - Changed from "Product Type" to "Product Name"
                    if (prodName != '' )
                       prodName +=  ', ' + ol.PricebookEntry.Product2.Name ;
                    else
                       prodName += ol.PricebookEntry.Product2.Name ;
                    
                    if (ol.Product_Type__c == 'PV Module')
                       OppLineSystemSize = ol.System_Size__c;
                       
                    
                }
            }
        systemAnalyst = '';
        projectManager = '';
        proposalDesigner = '';
        projectDesigner = '';
        structuredFinance = '';
        List<OpportunityTeamMember> oppTeamMem = [Select id, User.Name, TeamMemberRole , OpportunityId from OpportunityTeamMember 
                                                        where OpportunityId = :oppId and TeamMemberRole in ('Project Manager','Sales Analyst','Proposal Designer','Project Designer','Structured Finance') ];
       if (oppTeamMem.size() > 0) {
        
        for (OpportunityTeamMember oppTeam :oppTeamMem  ) {
            
            if (oppTeam.TeamMemberRole == 'Project Manager' ) {
                if (projectManager != '')
                  projectManager += ', ' + oppTeam.User.Name;
                else
                    projectManager += oppTeam.User.Name ;
            }
            else if (oppTeam.TeamMemberRole == 'Sales Analyst' ) {
                if (systemAnalyst != '')
                    systemAnalyst += ', ' + oppTeam.User.Name;
                else
                    systemAnalyst += oppTeam.User.Name ;
            }
            else if (oppTeam.TeamMemberRole == 'Proposal Designer' ) {
                if (proposalDesigner != '')
                    proposalDesigner += ', ' + oppTeam.User.Name;
                else
                    proposalDesigner += oppTeam.User.Name ;
            }
            else if (oppTeam.TeamMemberRole == 'Project Designer' ) {
                if (projectDesigner != '')
                    projectDesigner += ', ' + oppTeam.User.Name;
                else
                    projectDesigner += oppTeam.User.Name ;
            }
            else {
                if (structuredFinance != '')
                    structuredFinance += ', ' + oppTeam.User.Name;
                else
                    structuredFinance += oppTeam.User.Name ;
            }
        }
       } 
      }
      
      return OppObj;
    }
    set;
  }

}