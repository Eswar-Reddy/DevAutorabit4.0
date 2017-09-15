public class EstimatePVValueController {
  public String quoteIDVal {get; set;}
  public Decimal estimatePVVal {get; set;}
  public String mountingSystem {get;set;}
  public String pvModuleType {get;set;}
   public String systemAnalyst {get;set;}
  public String projectManager {get;set;}
  
  public Quote relatedTo {
    get {
      System.debug('Debug: quoteIDVal ' + quoteIDVal);
      
      if (quoteIDVal != null && quoteIDVal != '') {
      System.debug('Debug: quoteIDVal ' + quoteIDVal);
        relatedTo = [Select Id,CurrencyISOCode, TotalPrice,ASP1__c,Quote_Steps__c,ASP_Formula__c,BOS_w__c,PV_w__c,Other_Cost_W__c, QuoteCost__c, Direct_Margin__c, DirectMargin_per__c,Business_Unit__c,  
                        Mounting_System_Module__c, System_Size_kWp__c,Description,Opportunity_Number__c,System_Size__c,System_Size_BOS__c,System_Size_PV__c,
                        Total_O_M_Amount__c,Total_O_M_Cost__c,O_M_Direct_Project_Margin__c,O_M_Direct_Project_Margin1__c,
                        OpportunityId,  Opportunity.Owner.Name,Opportunity.Name,Opportunity.CloseDate,Opportunity.Expected_Commercial_Operation_Date__c,Opportunity.ASP_New_del__c,
                        Opportunity.BOS_s_w__c , Opportunity.PV_s_w__c , Opportunity.Other_Cost_W__c,Opportunity.System_Size_KwP__c,Opportunity.System_Size__c,
                        Opportunity.Installation_Date__c, Opportunity.Probability, Opportunity.Contract_Type__c, Opportunity.NextStep, Opportunity.StageName,
                        Opportunity.Sales_Analyst__r.Name, Opportunity.Project_Manager__c,Opportunity.System_SizePV__c,Opportunity.System_SizeBOS__c, 
                        PSR__r.Mounting_System__c, PSR__r.PV_Module_Type__c,
                        Opportunity.PV_Cost_Sys__c,Opportunity.Gross_Margin__c, Opportunity.Gross_Margin_percent__c, PSR__r.Estimate__r.PV__c
                        From Quote Where Id = :quoteIDVal];
        estimatePVVal = relatedTo.PSR__r.Estimate__r.PV__c;
       System.debug('Debug: estimatePVVal ' + estimatePVVal);
        
       systemAnalyst = '';
       projectManager = '';
       
             
       List<OpportunityTeamMember> oppTeamMem = [Select id, User.Name, TeamMemberRole , OpportunityId from OpportunityTeamMember where OpportunityId = :relatedTo.OpportunityId and TeamMemberRole in ('Project Manager','Sales Analyst') ];
       if (oppTeamMem.size() > 0) {
        
        for (OpportunityTeamMember oppTeam :oppTeamMem  ) {
            
            if (oppTeam.TeamMemberRole == 'Project Manager' ) {
                if (projectManager != '')
                  projectManager += ', ' + oppTeam.User.Name + ', ';
                else
                    projectManager += oppTeam.User.Name ;
            }
            else  {
                if (systemAnalyst != '')
                    systemAnalyst += ', ' + oppTeam.User.Name ;
                else
                    systemAnalyst += oppTeam.User.Name ;
            }
        }
       }
       
        mountingSystem= '';
        pvModuleType = '';
        List<QuoteLineItem> lstQuoteLineItem = [Select Id,Product_Family__c,Product__r.Name,Product_Type__c, PricebookEntry.Product2.Name from QuoteLineItem where Quoteid = :quoteIDVal];
            if (lstQuoteLineItem.size() > 0) {
                
                for( QuoteLineItem ql :lstQuoteLineItem  ) {
                    
                   if(ql.Product_Family__c != null) 
                    {
                    String prodFamily = ql.Product_Family__c;
                    System.debug('Debug: prodFamily ' + prodFamily);
                
                    if (prodFamily.startsWith('Mounting Systems') &&  ql.PricebookEntry.Product2.Name != null)
                    {
                      mountingSystem += ql.PricebookEntry.Product2.Name +', ';
                      System.debug('Debug: mountingSystem ' + mountingSystem);
                    }
                    if (prodFamily.startsWith('PV Module') &&  ql.PricebookEntry.Product2.Name != null)
                    {
                      pvModuleType += ql.PricebookEntry.Product2.Name +', ';
                      System.debug('Debug: pvModuleType ' + pvModuleType);
                    } 
                    } 
                    
                }
            }
            
        
      }
      
      return relatedTo;
    }
    set;
  }
}