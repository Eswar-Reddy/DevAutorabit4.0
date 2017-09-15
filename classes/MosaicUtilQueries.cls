public with sharing class MosaicUtilQueries{
    
    public MosaicUtilQueries(){
    }
	
    
    public static Contact getContact(String accId){
        List<Contact> conList = [select id,MailingStreet,MailingCity,MailingState,MailingPostalCode,FirstName,LastName,Email,Phone from Contact where AccountId = :accId and Primary__c=true limit 1];
        if(conList != null && !conList.isEmpty())
          return conList.get(0);
        else 
          return null;  
    }

    public static Quote_Summary__c getQuoteSummary(String quoteId){
        List<Quote_Summary__c> qtSummary = [select id,Module1_AC_rating__c,Module2_AC_rating__c,Module3_AC_rating__c,Module4_AC_rating__c from Quote_Summary__c where Locked_Scenario__c = :quoteId limit 1];
        if(qtSummary != null && !qtSummary.isEmpty())
          return qtSummary.get(0);
        else 
          return null;
    }

    public static Credit_Check_Request__c getCreditCheckApplication(String accId){
        List<Credit_Check_Request__c> creditCheckApplication = [select id, Application_Id__c, First_Name__c, Last_Name__c, Email__c, Phone__c, Street__c, Street2__c, City__c, State__c, Zip__c from Credit_Check_Request__c where Account__c = :accId AND Application_Type__c = 'Loan' limit 1];
        if(creditCheckApplication != null && !creditCheckApplication.isEmpty())
          return creditCheckApplication.get(0);
        else 
          return null;
    }

    public static Credit_Product__c getCreditProduct(Id creditCheckAppId, String loanTerm){
        if(loanTerm != null){
            Integer loanMonths = Integer.valueOf(loanTerm) * 12;
            List<Credit_Product__c> creditProduct = [select id,Product_Name__c,Product_Display_Name__c  from Credit_Product__c where CreditApplication__c = :creditCheckAppId AND Loan_Month__c = :loanMonths limit 1];
            if(creditProduct != null && !creditProduct.isEmpty())
              return creditProduct.get(0);
            else 
              return null;
        }    
        return null;
    }



}