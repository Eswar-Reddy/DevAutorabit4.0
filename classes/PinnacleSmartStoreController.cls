/*
	Last Modified By :- Jitendra Appirio
    Purpose:- No changes done. deployed only for updating the last modified by on this class
*/
public class PinnacleSmartStoreController{
public String url{get;set;}

    public PinnacleSmartStoreController(){
        String userId = UserInfo.getUserId();
         List<User> userSmartStoreId = [ Select u.SmartStore_ID__c, u.ID From User u where u.ID = :userId ];
         String baseUrl = 'https://store.printable.com/printone/ssoredirect.aspx?wstoken=B586FD9CBAF2D1E928F8D22A412E4431&uid=';
        
        String defaultUrl = 'https://store.printable.com/printone/login.aspx?uigroup_id=1708';
         if (userSmartStoreId[0].SmartStore_ID__c != null) {
             url = baseUrl + userSmartStoreId[0].SmartStore_ID__c;
         } else {
            url = defaultUrl;
         }
    }

}