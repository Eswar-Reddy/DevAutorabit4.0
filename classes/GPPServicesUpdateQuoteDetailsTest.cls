/********************************************************************************************
Author : Birlasoft
Usage  : Test Class for GPPServicesUpdateQuoteDetails Rest Resource Class
Edits  :    
        2014-05-13 : 
********************************************************************************************/

@isTest(SeeAllData=true)
Class GPPServicesUpdateQuoteDetailsTest
{ 
    static testMethod void TM1() 
    {        
        SFDCSpecialUtilities.isRunningTest=true;
        //Run the Test Code in Partner User Context                  
        //System.runAs(TestUtilsGPP.createPartnerInfoAU())
        //{
            Test.startTest();            
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
                String sQuoteNumber= '';              
                if(!qots.isEmpty())
                    sQuoteNumber= [SELECT Id, QuoteNumber FROM Quote WHERE id=: qots[0].Id].QuoteNumber;
                                    
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();      
                    req.requestURI = '/services/apexrest/SPWRQuote/UpdateQuoteDetails';  
                    req.httpMethod = 'POST';    
                GPPServicesUpdateQuoteDetailsMock fakeUQDResponse = new GPPServicesUpdateQuoteDetailsMock(sQuoteNumber);                                  
                Test.setMock(HttpCalloutMock.class, fakeUQDResponse);
                    String sJSON= fakeUQDResponse.sPayLoad; 
                    RestContext.request = req;
                    RestContext.response = res;
                    req.requestBody=Blob.valueOf(sJSON);                 
                GPPServicesUpdateQuoteDetails.WResponse gppUQDWResponse= GPPServicesUpdateQuoteDetails.UpdateQuote(); 
            Test.stopTest();   
           // }//End runAs
  }//End TM1
  
}//End Class GPPServicesUpdateQuoteDetailsTest