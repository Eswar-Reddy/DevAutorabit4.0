public class HelixPPAController {
    private final Quote quote;
    public Opportunity opportunity {get; private set;}
    public String newUIPage {get; set;}
    
    public HelixPPAController(ApexPages.StandardController stdController) {
        // init
        opportunity = new Opportunity();
        
        this.quote = (Quote)stdController.getRecord();
        String opptyId = ApexPages.currentPage().getParameters().get('opportunityId');
        opportunity = getOpportunity(opptyId);
        
        PageReference pr = Page.SPCommunityCustomer;
        pr.setAnchor('/account/commercial/'+opportunity.AccountId+'/opportunity/'+opportunity.Id+'/quotes');
        newUIPage = pr.getURL();
    }
    
    public PageReference closeDesign() {
        PageReference pr;
        if (opportunity.Id != null) {
            /*
            pr = Page.SPCommunityOpportunityDetails;
            pr.getParameters().put('id', opportunity.Id);
            */
            if (SPCommunityUtility.isNewUIUser(UserInfo.getUserId())) { 
                pr = Page.SPCommunityCustomer;
                pr.setAnchor('/account/commercial/'+opportunity.AccountId+'/opportunity/'+opportunity.Id+'/quotes');
            }
            else{
                pr = new PageReference('/' + opportunity.Id);
            }
            pr.setRedirect(true);
        }
        return pr;
    }
    //kcm
    public boolean isNewUIUser {
                                   get {
                                       boolean isNewUIUser = false;
                                    
                                       if (SPCommunityUtility.isNewUIUser(UserInfo.getUserId())) { 
                                           isNewUIUser = true;
                                       }     
                                       
                                       return isNewUIUser;   
                                   }
                                   set;
                              }

//-----------------------------------------------------------------------------------
// save PPA remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static HelixPPAUtil.SavePPAResponse savePPA(HelixPPAUtil.SavePPARequest request) {
        return HelixPPAUtil.savePPA(request);
    } 
       
//-----------------------------------------------------------------------------------
// private static methods
//-----------------------------------------------------------------------------------
    private static Opportunity getOpportunity(String opptyId) {
        Opportunity oppty = new Opportunity();
        if (String.IsNotBlank(opptyId)) {
            List <Opportunity> opptyList = [SELECT Id, Name, AccountId, Installation_Date__c FROM Opportunity WHERE Id = :opptyId]; //KCM_04062017: added Expected_Installation_Date__c temporarily: #141278683
            if (opptyList.size() > 0) {
                oppty = opptyList[0];
            }
        }
        return oppty;
    }
    
    public String quarter {
                              get {
                                  if (opportunity.Installation_Date__c != null) {
                                      integer q = (Math.floor(((opportunity.Installation_Date__c.Month()-1)/3)+1)).intValue(); 
                                      quarter = 'Q' + String.valueOf(q) + ' ' + String.valueOf(opportunity.Installation_Date__c).left(4);
                                  }
                                  return quarter;
                              }
                              set;
                          }
}