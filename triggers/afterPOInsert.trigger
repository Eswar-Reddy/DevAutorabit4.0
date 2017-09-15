/*****************************
**Created By- Aashish Mathur 
**Created On- Jan 21, 2011 
**Desciption- Trigger for Purchase_Order__c afterInsert
**Case Number- 00053239
*******************************/
trigger afterPOInsert on Purchase_Order__c (after insert) {
  /* Shree Prashant*/
  if(Test.isRunningTest() && Lease_2_1_PO_Creation__c.getInstance('Lease_2_1_Bypass').Lease_2_1_Test_Method_Bypass__c)
   return;
   
    purchaseOrderManagement.afterInsert(trigger.new);
// Calling agreement notification after PO Inserted for amended quote
  if(Trigger.IsInsert && Trigger.IsAfter) 
    purchaseOrderManagement.sendAmendedQuoteNotification(trigger.new);  
}