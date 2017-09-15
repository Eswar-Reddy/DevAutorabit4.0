/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    public String strtURL{get;set;}
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
			if(strtURL==null || strtURL==''){
            	return Network.communitiesLanding();
            }else{
            	return new PageReference(strtURL);
            }
        
    }
    
    public PageReference forwardToS1Page() {
        return new PageReference('/one/one.app');
    }
    
    public CommunitiesLandingController() {
		strtURL = ApexPages.currentPage().getParameters().get('startURL');
	}
}