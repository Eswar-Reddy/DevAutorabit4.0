public class StageNegotiateContractVFController {
  public String oppID {get; set;}
  public String systemAnalyst {get;set;}
  public String projectManager {get;set;}
  public String producttype {get;set;}
  public String Moduletype {get;set;}
 public String taskUrl {get;set;}

  
  public Opportunity OppObj {
    get {
      System.debug('Debug: oppId ' + oppId);
      
      if (OppObj != null) {
        return OppObj;
      }
      
      if (oppId != null && oppId != '') {
        OppObj = [Select Id,  Name, Opportunity_Number_New__c, Probability_Text__c, Probability, Business_Unit__c, SPWR_Deal_Type_text__c, StageName 
                        From Opportunity Where Id = :oppID];


        producttype = '';
        Moduletype = '';
        List<OpportunityLineItem> lstOppLineItem = [Select PricebookEntry.Product2.Name,PricebookEntry.Product2.Family, Product_Type__c , Id From OpportunityLineItem  where OpportunityId = :oppId];
            if (lstOppLineItem.size() > 0) {
                
                for( OpportunityLineItem ol :lstOppLineItem ) {
                    
                    //Case No - 00117187 
                     if ((ol.Product_Type__c == 'Balance of System') && (ol.PricebookEntry.Product2.Family == 'Mounting Systems - Ground' || ol.PricebookEntry.Product2.Family == 'Mounting Systems - Parking' || ol.PricebookEntry.Product2.Family == 'Mounting Systems - Roof')){
                    if (producttype != '' )
                       producttype +=  ', ' + ol.PricebookEntry.Product2.Name ;
                    else
                       producttype += ol.PricebookEntry.Product2.Name ;
                     }
                    if (ol.Product_Type__c == 'PV Module'){
                    if (Moduletype != '' )
                       Moduletype +=  ', ' + ol.PricebookEntry.Product2.Name ;
                    else
                       Moduletype += ol.PricebookEntry.Product2.Name ;
                     }
                     
                    
                }
            }
        systemAnalyst = '';
        projectManager = '';
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
        }
       } 
       
        String PORTAL_PROD_URL = 'https://login.salesforce.com/'+oppId;
        String PORTAL_SB_URL = 'https://test.salesforce.com/'+oppId;
        taskUrl  = '';
        /*
        if(SalesforceOrgUtils.isProductionOrg()){ 
            taskUrl = PORTAL_PROD_URL;
        }else{
            taskUrl = PORTAL_SB_URL;
        }*/
        taskUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        
       
      }
      
      return OppObj;
    }
    set;
  }
            
}