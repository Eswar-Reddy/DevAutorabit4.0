/********************************************************************************************
Author : Birlasoft
Usage  : Test Class for GPPServicesCustomer Rest Resource Class
Edits  :    
        2014-03-12 : 
********************************************************************************************/

@isTest(SeeAllData=false)
public class GPPServicesCustomerTest
{
    static testMethod void TM1() 
    {
        SFDCSpecialUtilities.isRunningTest=true;
        //List<Quote> qots;
        //User userP= TestUtilsGPP.createPartnerInfoAU();
        //Contact pContact= [SELECT id, AccountId FROM Contact WHERE id=: userP.ContactId LIMIT 1];
        //Account acc= [SELECT id, (SELECT Id, OpportunityId, AccountFromId, AccountToId, Role, ReversePartnerId FROM PartnersFrom WHERE Role= 'Installer') From Account a WHERE id=: pContact.AccountId];
        //List<Partner> lstInstallers= acc.PartnersFrom;
//SYSTEM.DEBUG('##C## 0.1 ## ' + TestUtilsGPP.CreatedInstallerAccount1);        
        //List<Partner> lstInstallers= [SELECT id, AccountFromId, AccountToId, Role FROM Partner WHERE AccountFromId=: pContact.AccountId AND Role= 'Installer'];
        //Run the Test Code in Partner User Context                  
        if(1==1)//System.runAs(TestUtilsGPP.createPartnerInfoAU())
        {
                   
                Account customerAccount= TestUtilsGPP.createAccount('AUCustomer1' , 
                                                                    TestUtilsGPP.RECORDTYPE_ACCOUNT_RESIDENTIAL_CUSTOMER, 
                                                                    true); 
                                                                                 
                List<Contact> lstCustomerContact= TestUtilsGPP.createCustomerContacts(2, 
                                                                                      'AUC', 
                                                                                      customerAccount.Id, 
                                                                                      TestUtilsGPP.RECORDTYPE_CONTACT_CUSTOMER, 
                                                                                      true);
                                                                                                      
                List<Opportunity> lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                                                   customerAccount.Id,
                                                                                                   lstCustomerContact[0].Id,
                                                                                                   TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,
                                                                                                   true);
                                              
                List<Quote> qots=TestUtilsGPP.createCustomerQuotes(1,
                                                       customerAccount,
                                                       lstCustomerOpportunity[0],
                                                       lstCustomerContact[0],
                                                       TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                                       null,
                                                       true);
                                                                                   
            
SYSTEM.DEBUG('##C## 1.1 ## ' + qots);
            if(!qots.isEmpty()){ 
                 Test.startTest();    
                String sQuoteNumber= [SELECT Id, QuoteNumber FROM Quote WHERE id=: qots[0].Id].QuoteNumber;                                         
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();      
                req.requestURI = '/services/apexrest/GPPCustomerService/GetCustomerInfo?QuoteId='+ sQuoteNumber;  
                req.httpMethod = 'GET'; 
                req.addParameter('QuoteId', sQuoteNumber);     
                RestContext.request = req;
                RestContext.response = res;
                Test.setMock(HttpCalloutMock.class, new GPPServicesMockHttpResponse());
                GPPServicesCustomer.getCustomerInfo();
                GPPServicesCustomer.CustomerInstallerInformation objCII= new GPPServicesCustomer.CustomerInstallerInformation(customerAccount);
                Test.stopTest();
            }             
        }
    }//End Func TM1
    
}//End class GPPServicesCustomerTest