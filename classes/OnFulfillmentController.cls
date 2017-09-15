public class OnFulfillmentController{
public String url{get;set;}

//Constructor
public OnFulfillmentController(){
    String orgId = UserInfo.getOrganizationId();
    system.debug(orgId +'--orgId ---');
    String userId = UserInfo.getUserId();
    List<User> userSmartStoreId = [ Select u.SmartStore_ID__c, u.ID From User u where u.ID = :userId ];
    if(orgId.contains('00DS00000001BGxMAM')){
        url = 'http://www.pacificapps.com:8080/OnFulfillment/SunPowerMRC/autologin.aspx?'+'sso=1&s=sunpowermrc&v=348_2010108_43272';
              
    }else if (userSmartStoreId[0].SmartStore_ID__c != null) {
       url = 'http://www.onfulfillment.com/SunPowerMRC/autologin.aspx?sso=1&s=sunpowermrc&v=' + userSmartStoreId[0].SmartStore_ID__c;
    }   
}
}