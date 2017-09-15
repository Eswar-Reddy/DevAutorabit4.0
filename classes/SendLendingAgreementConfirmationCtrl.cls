public with sharing class SendLendingAgreementConfirmationCtrl {
         public String quoteId{get;set;}
         public String accountId{get;set;}
  
  public SendLendingAgreementConfirmationCtrl(){
       quoteId = ApexPages.currentPage().getParameters().get('id');
       accountId = ApexPages.currentPage().getParameters().get('accId');
  }

}