public class partnerportallandingController {
    /*
	public String username{get;set;}
    public String password{get;set;}
    public String strtURL{get;set;}
    public string currentServer{get;set;}

    public partnerportallandingController(){
		currentServer='https://login.salesforce.com';
        if(UserInfo.getOrganizationId()!=Label.Production_Org_Id){
           currentServer='https://test.salesforce.com';
        }
		username = ApexPages.currentPage().getParameters().get('un');
        password = ApexPages.currentPage().getParameters().get('pw');	
        strtURL = ApexPages.currentPage().getParameters().get('startURL');
		system.debug('*********Landing****start Url*=='+strtURL);
	}
    
    public PageReference forwardToPartnerPortalHome() {
		id PermissionSet_Id = [SELECT Id,Label,name FROM PermissionSet where name='Partner_Community_Global' limit 1].id; //0PS34000000D5ftGAC
		id CommunityN_id = [SELECT Id,Name FROM Network where name= 'SPWRPartner Community' limit 1].id;       //0DB34000000Cdz7GAC
        string Community_URL = [select ID, Name, URL__c from Community_EndPoint__c where Name = 'SPWRCommunity' limit 1].URL__c;
		system.debug('================='+Community_URL);
        if(username!=null && username !='null' && password != null && password !='null'){
            list<PermissionSetAssignment> CommunityUserbyPS = [SELECT AssigneeId FROM PermissionSetAssignment where PermissionSetId =: PermissionSet_Id AND AssigneeId =: UserInfo.getUserId()];
            list<NetworkMemberGroup> CommunityUser = [SELECT Id,NetworkId,ParentId FROM NetworkMemberGroup where NetworkId =: CommunityN_id AND ParentId =: UserInfo.getProfileId()];
			
			if(CommunityUser.size()>0 || CommunityUserbyPS.size()>0){
				if(strtURL==null || strtURL==''){
            		return new PageReference(Community_URL+'/CommunityLogin?un='+username+'&pw='+password+'&comm=y');
            	}else{
                    return new PageReference(Community_URL+'/CommunityLogin?un='+username+'&pw='+password+'&comm=y&startURL='+strtURL);
                }
			}else{//portal split
		String portalLoginURL = currentServer +'/secur/login_portal.jsp';
        portalLoginURL += '?orgId='+UserInfo.getOrganizationId()+'&portalId='+Label.PartnerPortalId+'&loginType=3';
        portalLoginURL += '&startURL='+strtURL+'&loginURL=&useSecure=true';
        portalLoginURL += '&un=' + username;portalLoginURL += '&pw='+ password;
                	return new PageReference(portalLoginURL);
             }
		}
		return new PageReference('/home/home.jsp');
       }*/
}