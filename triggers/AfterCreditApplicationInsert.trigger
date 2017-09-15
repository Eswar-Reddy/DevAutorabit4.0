trigger AfterCreditApplicationInsert on Credit_Application__c (After insert) {    

    if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
    {
        return;
    }
    CreditApplicationManagement.afterCreditApplicationInsert(Trigger.newMap,Trigger.new,null);
    
    
}