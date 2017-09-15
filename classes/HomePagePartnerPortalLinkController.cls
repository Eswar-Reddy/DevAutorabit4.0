/**************************************************************************************************************
** PR-02022
**Created By- Kapil Goutam (Appirio)
**Created On- June 19, 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Controller class for HomePagePartnerPortalLink page. Page will redirect to account page if user logged in 
as portal user.
**************************************************************************************************************/
public class HomePagePartnerPortalLinkController {
   private String customerAccountId;
   public String getCustomerAccountId(){
   	  if(Apexpages.currentPage().getParameters().get('MDTF_Prog') != null){
   	  	if(customerAccountId == null){
   	  		User portalUser = [SELECT ContactId,Contact.Name, Contact.AccountId from User where id=:Userinfo.getUserId() LIMIT 1];
	  		customerAccountId ='apex/MDTF_Account?id='+ portalUser.Contact.AccountId;
   	  	}
   	  }
   	  else if(Apexpages.currentPage().getParameters().get('My_Accnt') != null){
   	  	if(customerAccountId == null){	
   	  		User portalUser = [SELECT ContactId,Contact.Name, Contact.AccountId from User where id=:Userinfo.getUserId() LIMIT 1];
	  		customerAccountId = portalUser.Contact.AccountId;
   	  	}	
   	  }
   	  
   	  return customerAccountId;	
	  
   }
   public HomePagePartnerPortalLinkController(ApexPages.StandardController controler){
   		
   	
   }	
 
}