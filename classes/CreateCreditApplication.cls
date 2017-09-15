/*************************************************************************
Name     : CreateCreditApplication
Author   : Aslam Bari
Date     : May 01, 2009
Usage    : This class called from Create Credit Application button, which is
           available at Credit Application related list section of the
           Account Page. It creates a new Credit_Application__c record.
**************************************************************************/

public class CreateCreditApplication{
    
    public string accountId {get;set;}
    public Account accountObj {get;set;}
    public Boolean isError {get;set;}

    public CreateCreditApplication(){
        accountId = ApexPages.currentPage().getParameters().get('id');
        if(accountId != null && accountId.trim().length() > 0){
            List<Account> lstAccount = [select id, name, BillingStreet, BillingState, 
                          BillingPostalCode,BillingCountry, BillingCity,
                          ShippingStreet, ShippingState, ShippingPostalCode,
                          ShippingCountry, ShippingCity, NumberOfEmployees, Phone
                          FROM Account WHERE id=:accountId];
            if(lstAccount != null && lstAccount.size() > 0){
                accountObj = lstAccount.get(0);
            }
                          
        }
    }
    
    public PageReference saveCreditApplication()
    {
        if(accountObj == null)
        {
            isError = true;
            String errorStr = 'Invalid Account ID Given';
            if(SPCommunityUtility.isPartnerUser())
            {
                System.debug('**** error: '+errorStr);
                PageReference pr = Page.CreateCreditApplicationPartnerError;
                pr.getParameters().put('message', errorStr);
                pr.setRedirect(true);
                return pr;
            }
            else
            {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, errorStr);
                ApexPages.addMessage(errorMsg);
                return null;
            }
        }
         
        try
        {
            Credit_Application__c creditApplication = new Credit_Application__c();
            creditApplication.Legal_Company_Name__c = accountObj.Name;             
            creditApplication.Number_of_Employees__c = accountObj.NumberOfEmployees;
            creditApplication.Bill_To_Phone__c = accountObj.Phone;
            creditApplication.Bill_To_Zip__c = accountObj.BillingPostalCode;
            creditApplication.Bill_To_State__c = accountObj.BillingState;
            creditApplication.Bill_To_Country__c = accountObj.BillingCountry;
            creditApplication.Bill_To_City__c = accountObj.BillingCity;
            creditApplication.Bill_To_Address__c = accountObj.BillingStreet;
            creditApplication.Ship_To_Zip__c = accountObj.ShippingPostalCode;
            creditApplication.Ship_To_State__c = accountObj.ShippingState;
            creditApplication.Ship_To_Country__c = accountObj.ShippingCountry;
            creditApplication.Ship_To_City__c = accountObj.ShippingCity;
            creditApplication.Ship_To_Address__c = accountObj.ShippingStreet;
            creditApplication.Account__c = accountObj.id;
            creditApplication.Credit_Limit_Requested__c = 0;
             
            insert creditApplication;
             
            PageReference creditEditPage = new PageReference('/'+creditApplication.id +'/e?retURL=%2F'+accountObj.id);
            creditEditPage.setRedirect(true);
            return creditEditPage;

        }
        catch(Exception ex)
        {
            isError = true;
            if(SPCommunityUtility.isPartnerUser())
            {
                System.debug('**** error: '+ex.getMessage());
                PageReference pr = Page.CreateCreditApplicationPartnerError;
                pr.getParameters().put('message', ex.getMessage());
                pr.setRedirect(true);
                return pr;
            }
            else
            {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
                ApexPages.addMessage(errorMsg);
                return null;
            }
        }
    }
    
}