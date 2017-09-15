/**************************************************************************************************************
** PR-02084
**Created By- Kapil Goutam (Appirio)
**Created On- June 29, 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Controller class for page My_Subscriptions. The page will show user.Subscription__c picklist field value, 
and provide functionality to change user Subscription.
**************************************************************************************************************/
public class My_SubscriptionsController {
    public String errorMessage{get;set;}
    private User currentUser;
    public User getCurrentUser(){
    	if(currentUser == null){
    		List<User> listUser = new List<User>([Select Contact.Subscription__c, ContactId from User where Id =:Userinfo.getUserId()]);
    		if(listUser.Size()>0){
    			currentUser = listUser.get(0);
    		} 
    	}
    	return currentUser;
    }	
    
    //constructor
    public My_SubscriptionsController(ApexPages.StandardController controller){
    	
    	
    }
    
    public PageReference save(){
    	try{
    		
    		if(currentUser != null && currentUser.ContactId != null){
    			List<Contact> listContact = new List<Contact>([Select Id from Contact where id=:currentUser.ContactId]);
    			if(listContact.Size()>0){
    				Contact con = new Contact(id=listContact.get(0).Id);
    				con.Subscription__c = currentUser.Contact.Subscription__c;
	    			update con;	
    			}
    			
    		}
    		errorMessage = 'SUCCESS';
    	}catch(Exception ex){
    		errorMessage = ex.getMessage();
    	}	
    	return null;
    }

}