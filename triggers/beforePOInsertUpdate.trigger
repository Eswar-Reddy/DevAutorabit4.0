trigger beforePOInsertUpdate on Purchase_Order__c (before update, before insert) {
  /* Shree Prashant */
  if(Test.isRunningTest() && Lease_2_1_PO_Creation__c.getInstance('Lease_2_1_Bypass').Lease_2_1_Test_Method_Bypass__c)
   return;
       
  if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
  {
    return;
  }

  purchaseOrderManagement.beforeInsertUpdate(Trigger.New);
}