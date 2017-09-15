global class PartnerPortalSiteLoginController {

    public PartnerPortalSiteLoginController(){}
    
    public PageReference authCurrentUser() {

            String startURL = ApexPages.currentPage().getParameters().get('startURL'); //Removing reliance on Community Endpoint
            String communityURL = [select ID, Name, URL__c from Community_EndPoint__c where Name = 'SPWRCommunity' limit 1].URL__c;

            PageReference pr = new PageReference(communityURL);
            
            if(startURL!=null){
                pr.getParameters().put('startURL',startURL);
            }  
            return pr;
            
    }
}