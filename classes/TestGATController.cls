/*********************************************************************
    Name  : TestGATController
    Date  : July 20,2011
    Description:This is a Test Class For Class "GATController".
*********************************************************************/

@isTest
private class TestGATController {

    static testMethod void gatTest() {
        
        Test.startTest();   
        User currentUser = null;
        List<User> userList = [select user.contact.account.type, user.contact.account.Oracle_Operating_Unit__c, user.contact.account.Oracle_Account_Number__c, user.country 
                                from User where id = :UserInfo.getUserId()]; 
        if(userList.size() > 0 ){
            currentUser = userList[0];
            
            GATController gat = new GATController();
            if(currentUser.contact != null){
                System.assertEquals(currentUser.contact.account.type , gat.tier);
                System.assertEquals(currentUser.contact.account.Oracle_Account_Number__c , gat.account );
                System.assertEquals(currentUser.contact.account.Oracle_Operating_Unit__c , gat.country);
            }else{
                System.assertEquals('SUNPOWER' , gat.account);
                System.assertEquals(currentUser.country , gat.country);
            }
        }
       Test.stopTest();
    }
}