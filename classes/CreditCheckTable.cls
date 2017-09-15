public with sharing class CreditCheckTable
{
  public Id objectParentId;
  public List<Credit_Check_Request__c> creditCheck{get;set;}

  public ID getObjectParentId()
    {
      return objectParentId;
    }

    public void setObjectParentId(ID s)
    {
        objectParentId = s;
        getCreditChecks();
    }

  public void getCreditChecks()
  {
    System.debug('**** objectParentId: '+objectParentId);
    creditCheck = [select Id,Name,Application_Type__c,Credit_Beureu__c,Credit_Check_Submission_Date__c,Status__c,Credit_Check_Approval_Date__c from Credit_Check_Request__c where Contact__c =: objectParentId];
    System.debug('**** creditCheck: '+creditCheck);
    if(creditCheck == null)
      creditCheck = new List<Credit_Check_Request__c>();
  }
}