public with sharing class CreateLeaseDocsVFController {
    
    ID idDraftContractRecordType;  //Draft Lease Contract recordtype id of Agreement object
    ID idLeaseContractRecordType;  //Lease Contract recordtype id of Agreement object
    ID idLendingAgreementRecordType; // LendingAgreement recordtype id of Agreement object
    ID idHICContractRecordType; // HIC Contract recordtype id of Agreement object
    Id spdCashContractRecordType;
    public Quote objQuote{get;set;}
    public Opportunity opp{get;set;}
    public Boolean errorOccured{get;set;}
    public Id attId{get;set;}
    public Boolean loanPath{get;set;}
    public String agreementName{get;set;}
    public List<sObject> sObjectList;
    public echosign_dev1__SIGN_Agreement__c newLendingAgreement;
    //for showing header/sidebar
    public Boolean inCommunity {get;set;}
    
    //Related to show PopUp functionality
    public String rScript {get; set;} //to show Jquery popup
    public List<Dealer_Compliance_Requirement__c>  dealerStatusCustomerId=new List<Dealer_Compliance_Requirement__c>();  //get corresponding dealer compliance for quote record
    public List<Dealer_Compliance_Requirement__c>  dealerStatusCustomerIdUpdate=new List<Dealer_Compliance_Requirement__c>();  //update corresponding dealer compliance for quote record
    String showPopUp;// to get Url param to check if need to show popup or not
    public String checkAgreementClick{get;set;} // Check if redirect being called from Agreement Button
    public CreateLeaseDocsVFController(){
        loanPath = true;
        agreementName = null;
        // querying the Quote to send details to either Mosaic or LP
        objQuote = [Select Account__r.Name,Consolidated_Lease_Number__c,Sector__c,Loan_Term__c,Inverter_Manufacturer_Roof1__c,Total_Contract_Price__c,OpportunityId,Inverter_Model__c,Account__c,Loan_Contract_Status__c,Account__r.Account_Name__c,Related_Account__c,Opportunity.Owner.CountryDomainText__c,Temp_Contact_1__c,Temp_Contact_2__c,Quote_type__c,QuoteType__c,id,Doc_out_for_signature__c,Contractors_License__c,Lease_Partner__c,Maximum_Rated_Capacity__c,Code_Expiration_Date__c,Is_Locked__c,Quote_Amount__c,Opportunity.Approved_Credit_Amount__c,Opportunity.id,Account__r.Country_Domain__c,Monthly_Power_Bill_Before_Solar__c,Monthly_Power_Bill_After_Solar__c,System_Production_Year_1__c,System_model__c,Quote_inverter_values__c,System_Cost__c, Financed_Amount__c,Account__r.BillingState from quote where id=:ApexPages.currentPage().getParameters().get('Id')];
        errorOccured = false;   
        checkAgreementClick='not Update'; //Assigning default value to avoid null pointer exception
        inCommunity = Network.getNetworkId() != null;//if there's a network id that means we're in the community
    }
    public PageReference redirect(){
        errorOccured = false;
        PageReference pageReference = null;
        Boolean isLoanPathCalled = false;
        Boolean isSPDCashContract = false; 
        System.debug('------------------TPConnectorServiceController'+ApexPages.currentPage().getParameters().get('Id'));
        // querying User to get country domaina and also if User is capable of creating Lease or Loan contracts   
        User user = [SELECT id, CounterSignature__c ,Acc_Name_Enc__c,country_domain__c,Lease_doc_creation_allowed__c,name FROM User WHERE id=:UserInfo.getUserId()];
        String PartnerUrl = 'https://' +(ApexPages.currentPage().getHeaders().get('Host') != null ? ApexPages.currentPage().getHeaders().get('Host') : 'login.salesforce.com') +
            '/services/Soap/u/22.0/'+UserInfo.getOrganizationId();
        // getting the various recordtype Id's of agreement object
        for(RecordType objectRecordType :util.getRecordTypeForobject('echosign_dev1__SIGN_Agreement__c')){
            if(objectRecordType.DeveloperName == 'Draft_Lease_Contract')
            {
              idDraftContractRecordType = objectRecordType.Id;
            }   
            else if (objectRecordType.DeveloperName == 'Lease_Contract')
            {
              idLeaseContractRecordType = objectRecordType.Id;             
            }
            else if(objectRecordType.DeveloperName == 'Lending_Agreement'){
              idLendingAgreementRecordType = objectRecordType.Id;
            }
            else if(objectRecordType.DeveloperName == 'HIC_Contract'){
              idHICContractRecordType = objectRecordType.Id;
            }
            else if(objectRecordType.DeveloperName == 'Cash_Contract'){
              spdCashContractRecordType = objectRecordType.Id;
            }
        }
        String result_status_LEASE;
        // checking if Quote is locked, type of QUote and if User is capable of creating contracts
        if(Test.isRunningTest() || objQuote.Is_Locked__c){
            String userDomain = user.country_domain__c.substring(user.country_domain__c.indexOf('-')+1) ;
            System.debug('-------------------------------objQuote.Opportunity.Owner.CountryDomainText__c'+objQuote.Opportunity.Owner.CountryDomainText__c);
            System.debug('--------userDomain ----' + userDomain );            
            String agreementID ='/';
            try{
               // calling all objects which should be sent as arguments to Updateopportunity call
                 Contact con = MosaicUtilQueries.getContact(objQuote.Account__c);
                 system.debug('contact is '+con);
                 Quote_Summary__c qtSummary = MosaicUtilQueries.getQuoteSummary(objQuote.Id);
                 system.debug('qtSummary is '+qtSummary);
                 Credit_Check_Request__c creditCheckApplication = MosaicUtilQueries.getCreditCheckApplication(objQuote.Account__c);
                 system.debug('creditCheckApplication is '+creditCheckApplication);
                 Credit_Product__c creditProduct = null;
                 system.debug('creditProduct is '+creditProduct); 
                 List<Credit_Check_Request__c> creditApplication = [select id,Application_Id__c,Status__c from Credit_Check_Request__c where Account__c = :objQuote.Account__c AND Application_Type__c = 'Lease' limit 1];
                 if(objQuote.QuoteType__c == 'Lease'){
                      agreementName = objQuote.Account__r.Name + '-Lease Document-' + objQuote.Consolidated_Lease_Number__c + '-' + String.valueOf(System.now()) + '.pdf';       
                      DocGenContractRequest nhcr = new DocGenContractRequest();
                      sObjectList = nhcr.sendDataToDocGen(Null,objQuote.Id,(creditApplication != null && !creditApplication.isEmpty() && (creditApplication.get(0).Status__c == 'Approved' || creditApplication.get(0).Status__c == 'Pending - Credit Review')) ? idLeaseContractRecordType : idDraftContractRecordType,(creditApplication != null && !creditApplication.isEmpty() && (creditApplication.get(0).Status__c == 'Approved' || creditApplication.get(0).Status__c == 'Pending - Credit Review')) ? 'No' : 'Yes',agreementName,System.Label.CounterSignatureEmailAddress,'','Agreement');
                      Sunpower_Spectrum_Debug_Log__c spectrumDebugLog = (Sunpower_Spectrum_Debug_Log__c)sObjectList.get(1);
                      if(spectrumDebugLog.Name != 'error'){
                          updateDealerComplianceObject(); // Function call to update ComplianceCheck Object Status
                          return new PageReference('/'+spectrumDebugLog.Name);
                      }
					  else if(Label.LoanPath_Available != 'Yes'){
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in making a call to DocGen'));    
                           rScript  = 'displaynone();'; 
                           return null; 
                      }
                      
                      // end of if contract source is docgen
                      else if(Label.LoanPath_Available == 'Yes'){
                           if(creditApplication != null && !creditApplication.isEmpty() && creditApplication.get(0).Status__c == 'Approved'){ // this statement should be modified as per new data model
                               system.debug('since credit is approved calling lease contract API call');
                               system.debug('idLeaseContractRecordType----->'+idLeaseContractRecordType);   
                               if(objQuote.Sector__c == 'Residential'){
                                    system.debug('residential is called');
                                    isLoanPathCalled = true;
                                    result_status_LEASE = TPSSF.TPConnectorService.SubmitExt('Quote',objQuote.Id, '' ,'' ,'generatecontract','leasecontract','',UserInfo.getUserId(),UserInfo.getSessionId(),PartnerUrl, UserInfo.getUserName(), '',userDomain,'type,leasecontract;recordTypeId,'+idLeaseContractRecordType);
                               }
                               else if(objQuote.Sector__c == 'New Homes'){
                                    system.debug('New Homes is called');
                                    isLoanPathCalled = true;
                                    result_status_LEASE = TPSSF.TPConnectorService.SubmitExt('Quote',objQuote.Id, '' ,'' ,'generatecontract','leasecontract','',UserInfo.getUserId(),UserInfo.getSessionId(),PartnerUrl, UserInfo.getUserName(), '',userDomain,'NewHome,true;recordTypeId,'+idLeaseContractRecordType);
                               }
                               system.debug('lease contract repsonse is '+result_status_LEASE);
                           }
                           else{
                                if(objQuote.Sector__c == 'Residential'){
                                    system.debug('residential draft is called');
                                    isLoanPathCalled = true;
                                    result_status_LEASE = TPSSF.TPConnectorService.SubmitExt('Quote',objQuote.Id, '' ,'' ,'generatecontract','leasecontract','',UserInfo.getUserId(),UserInfo.getSessionId(),PartnerUrl, UserInfo.getUserName(), '',userDomain,'type,draft;recordTypeId,'+idDraftContractRecordType);
                                }
                                else if(objQuote.Sector__c == 'New Homes'){
                                    system.debug('New Homes draft is called');
                                    isLoanPathCalled = true;
                                    result_status_LEASE = TPSSF.TPConnectorService.SubmitExt('Quote',objQuote.Id, '' ,'' ,'generatecontract','leasecontract','',UserInfo.getUserId(),UserInfo.getSessionId(),PartnerUrl, UserInfo.getUserName(), '',userDomain,'NewHome,draft;recordTypeId,'+idDraftContractRecordType);
                                }
                                system.debug('draft contract repsonse is '+result_status_LEASE); 
                           }
                        } // end of if contract source is LoanPath
               } // End of if QuoteType is Lease
               
               else if(objQuote.QuoteType__c == 'Loan'){
                   if(objQuote.Loan_Contract_Status__c == null){
                       
                          if(creditCheckApplication != null){
                            system.debug('querying credit product');
                            creditProduct = MosaicUtilQueries.getCreditproduct(creditCheckApplication.Id,objQuote.Loan_Term__c);
                          } 
                          system.debug('came to loan');
                          // since Quotetype is Loan and loan contract status is null, we need to make Create lending agreement call  to Mosaic, create a agreement record of type Lending agreement in SFDC and update the Loan Contract Status field on Quote
                          system.debug('came inside Loan Contract null');
                          // calling updateOpportunity on Mosaic to send Solaragreements
                          if(con != null && qtSummary != null && creditCheckApplication != null && creditProduct != null){ 
                                 system.debug('came inside lending agreement');
                                 MosaicJSONUtil.MosaicResponse updateOppResponse = Mosaic_API_CallHandler.mosaic_Update_Opportunity(creditCheckApplication,objQuote,qtSummary,creditProduct);
                                 if(updateOppResponse.successful == false){
                                    errorOccured = true; 
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in updating the Opportunity on Mosaic and the error is '+String.valueOf(updateOppResponse.responsebody)));
                                    rScript  = 'displaynone();';
                                    return null;
                                 }  
                                 MosaicJSONUtil.MosaicResponse createLAResponse = Mosaic_API_CallHandler.mosaic_Send_Loan_Agreement(creditCheckApplication.Application_Id__c);
                                 if(createLAResponse.successful == false){
                                    errorOccured = true;
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in making a call to Mosaic to create Lending Agreement on Mosaic and the error is '+String.valueOf(createLAResponse.responsebody)));
                                    rScript  = 'displaynone();';
                                     return null;
                                 } 
                                    
                                 // creating agreement of type Lending Agreement so that Mosaic can come and attach LA to this agreement record using Informatica
                                 newLendingAgreement = new echosign_dev1__SIGN_Agreement__c();
                                 newLendingAgreement.recordTypeId = idLendingAgreementRecordType;
                                 newLendingAgreement.Quote__c = objQuote.Id;
                                 newLendingAgreement.Account__c = objQuote.Account__c;
                                 newLendingAgreement.Name = objQuote.Account__r.Account_Name__c + ' Lending Agreement';
                                 newLendingAgreement.echosign_dev1__Status__c = 'Out for Signature';
                                 newLendingAgreement.echosign_dev1__Recipient__c = con.Id;
                                 newLendingAgreement.echosign_dev1__DateSent__c = System.Today();
                                 newLendingAgreement.Agreement_Name__c = objQuote.Account__r.Account_Name__c + ' Lending Agreement';
                                 //insert newLendingAgreement;
                                // if(newLendingAgreement != null){
                                 //    pageReference = new PageReference('/'+objQuote.Account__c);  
                                     opp = [select id,Contract_Status__c from Opportunity where Id = :objQuote.OpportunityId];
                                     objQuote.Loan_Contract_Status__c = 'Lending Agreement Created';
                                     opp.Contract_Status__c = 'Lending Agreement Created';
                                     //update objQuote;       
                                     //update opp;
                               //  }
                                 
                           }
                           else{
                                  errorOccured = true;
                                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'It looks like either Credit Check App or Credit Product is not available'));
                                  rScript  = 'displaynone();'; 
                                  return null;
                           }
                          
                   }
               
                   if(objQuote.Loan_Contract_Status__c == 'Lending Agreement Created'){
                       system.debug('about to call HIC api');
                       agreementName = objQuote.Account__r.Name + '-HIC Document-' + objQuote.Consolidated_Lease_Number__c + '-' + String.valueOf(System.now()) + '.pdf';       
                       DocGenContractRequest nhcr = new DocGenContractRequest();
                       sObjectList = nhcr.sendDataToDocGen(Null,objQuote.Id,idHICContractRecordType,(creditApplication != null && !creditApplication.isEmpty() && creditApplication.get(0).Status__c == 'Approved') ? 'No' : 'Yes',agreementName,System.Label.CounterSignatureEmailAddress,'','Agreement');
                       Sunpower_Spectrum_Debug_Log__c spectrumDebugLog = (Sunpower_Spectrum_Debug_Log__c)sObjectList.get(1);
                       if(spectrumDebugLog.Name != 'error'){
                          system.debug('docgen HIC is successful'); 
                          objQuote.Loan_Contract_Status__c = 'HIC Created';
                          update objQuote;
                          if(opp != null)
                           update opp; 
                          if(newLendingAgreement != null)
                              insert newLendingAgreement;
                              updateDealerComplianceObject(); // Function call to update ComplianceCheck Object Status
                              return new PageReference('/'+spectrumDebugLog.Name);
                       }
                       else if(Label.LoanPath_Available != 'Yes'){
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in making a call to DocGen'));    
                           rScript  = 'displaynone();'; 
                           return null; 
                      }
                         else if(Label.LoanPath_Available == 'Yes'){
                           system.debug('LoanPath called for HIC');
                           isLoanPathCalled = true;
                           result_status_LEASE = TPSSF.TPConnectorService.SubmitExt('Quote',objQuote.Id, '' ,'' ,'generatecontract','leasecontract','',UserInfo.getUserId(),UserInfo.getSessionId(),PartnerUrl, UserInfo.getUserName(), '',user.country_domain__c.substring(user.country_domain__c.indexOf('-')+1),'type,hic;recordTypeId,'+idHICContractRecordType);
                           if((!String.isBlank(result_status_LEASE) && result_status_LEASE.contains('SUCCESS'))){
                                 objQuote.Loan_Contract_Status__c = 'HIC Created';
                                 update objQuote;
                                 if(opp != null)
                                   update opp; 
                                 if(newLendingAgreement != null) 
                                   insert newLendingAgreement;  
                           }
                           else{
                                 update objQuote;
                                 if(opp != null)
                                   update opp; 
                                 if(newLendingAgreement != null) 
                                   insert newLendingAgreement; 
                                 errorOccured = true;
                                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'HIC Service is down please try later'));
                                 rScript  = 'displaynone();';   
                                 return null; 
                           }
                       }
                       
                  } // chekcing if loan contract status = lending agreement created ended
              } // checking if Loan ended
              // Cash Contract
              else if (objQuote.QuoteType__c == 'Cash'){
                      agreementName = objQuote.Account__r.Name + '-Cash Agreement-' + String.valueOf(System.now()) +'.pdf';         
                      DocGenContractRequest nhcr = new DocGenContractRequest();
                      sObjectList = nhcr.sendDataToDocGen(Null,objQuote.Id,spdCashContractRecordType,'No',agreementName,System.Label.CounterSignatureEmailAddress,'','Agreement');
                      Sunpower_Spectrum_Debug_Log__c spectrumDebugLog = (Sunpower_Spectrum_Debug_Log__c)sObjectList.get(1);
                      if(spectrumDebugLog.Name != 'error'){
                          updateDealerComplianceObject(); // Function call to update ComplianceCheck Object Status
                          return new PageReference('/'+spectrumDebugLog.Name);
                      }
                      else{
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in making a call to DocGen'));    
                           rScript  = 'displaynone();'; 
                           return null; 
                      } 
              } 
              
              // end of cash contract
              updateDealerComplianceObject(); // Function call to update ComplianceCheck Object Status
               Exception_Log__c exceptionLog = (Exception_Log__c)sObjectList.get(0);    
               Sunpower_Spectrum_Debug_Log__c spectrumDebugLog = (Sunpower_Spectrum_Debug_Log__c)sObjectList.get(1);
               if(exceptionLog != null){
                    insert exceptionLog;
               }
               else{
                    insert spectrumDebugLog;   
               }
  
         }   // end of try 
         catch(Exception ex) {
                System.debug('-------------------e'+ex.getMessage());
                system.debug('came to catch');
                errorOccured = true;
                Exception_Log__c exLog = new Exception_Log__c();
                exLog.Quote__c = objQuote.Id;
                exLog.Opportunity_Id__c = objQuote.OpportunityId;
                exLog.Account_Id__c = objQuote.Account__c;
                exLog.Stack_Trace__c = ex.getStackTraceString();
                exLog.Error_Message__c = ex.getMessage();
                exLog.Line_Number__c = ex.getLineNumber();
                insert exLog;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage() + 'line number is '+ex.getLineNumber() + ' and stack message is '+ex.getStackTraceString()));
                rScript  = 'displaynone();';
                return null;
         }
            
            //result_status_LEASE = 'SUCCESS: [00Alfklkfndkn]';
            // if loanpath is called, then if the call is success, it takes to the agreement created, otherwise, it shows the error message
            if(isLoanPathCalled){
                if(!String.isBlank(result_status_LEASE) && result_status_LEASE.contains('SUCCESS'))
                  pageReference = new pageReference('/'+result_status_LEASE.substring(result_status_LEASE.indexOf('SUCCESS: [')+10,result_status_LEASE.indexOf(']')));
                else{
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error from Loanpath: '+result_status_LEASE));
                      rScript  = 'displaynone();';   
                    pageReference = null;
                }
            } 
       }  // end of checking if Quote is locked
         System.debug('page referenece after method call :: '+pageReference);
         return pageReference;
    } // end of redirect method
    
    public PageReference customerPage(){
        PageReference pg = new PageReference('/'+objQuote.Account__c);
        return pg; 
    }
    
    public void pageCall(){
        
        //Starting Point For class Entrance
        
        // Code related to show popup functionality
        dealerStatusCustomerId=[SELECT Account__c,Compliance_Completed__c,Id,Status__c,Completed_By__c,Date_Completed__c FROM Dealer_Compliance_Requirement__c WHERE Name IN ('Verbally Notified Customer of Right to Cancel', 'Verified Customer’s ID') AND Account__c =:objQuote.Account__c   AND Opportunity__c = :objQuote.OpportunityId];
        showPopup='false'; //default value
        showPopup=ApexPages.currentPage().getParameters().get('show'); // to get Url Param
        boolean complianceCheck=true;
        if(dealerStatusCustomerId != null && dealerStatusCustomerId.size() > 0 && showPopup != null && showPopup.equalsIgnoreCase('true')){
            for (Dealer_Compliance_Requirement__c compliance : dealerStatusCustomerId){
                //to check status for both Name value in compliance record
                if(compliance.Status__c.equalsIgnoreCase('Open') || !compliance.Compliance_Completed__c){
                    complianceCheck=false;
                    checkAgreementClick='updateValue';
                    rScript  = 'openPopup();';   //call js method to open popup
                }
            }
            if(complianceCheck){
                
                checkAgreementClick='not Update';
                rScript  = 'redirectionMethodCall();'; 
                
            }
        }
        else{
            
            checkAgreementClick='not Update';
            rScript  = 'redirectionMethodCall();'; 
            
        }
        
    }


/*******************************************************************************************************************************************************************************
Method      : updateDealerComplianceObject
Parameters  : 
Return Type : 
Summary     : Function which update dealerCompliance Object after user check checkboxes for compliance check before navigating to Agreement Page
********************************************************************************************************************************************************************************/ 

public void updateDealerComplianceObject(){

      try {

       //Updating status for Object Dealer_Compliance_Requirement__c 
                     System.debug('before dealerupdate :: ');
                     System.debug('dealerStatusCustomerId :: '+dealerStatusCustomerId);
                     // Checking condition if method being called from Agreement button click then only update Compliance object  CAN REMOVE UPADTE VALUE with util class variable to avoid hard coding
                     if(checkAgreementClick.equalsIgnoreCase('updateValue')){
                           for (Dealer_Compliance_Requirement__c compliance : dealerStatusCustomerId){
                               compliance.Status__c='Completed';
                               compliance.Compliance_Completed__c=true;
                               compliance.Completed_By__c=UserInfo.getUserId();
                               compliance.Date_Completed__c= system.today();
                               dealerStatusCustomerIdUpdate.add(compliance);
                               showPopUp='false';
                               rScript  = 'displaynone();';
                           }
                          update dealerStatusCustomerIdUpdate;
                     }
         
      }  catch(Exception ex) {
                      System.debug('-------------------e'+ex.getMessage());
                      system.debug('came to catch');
                      errorOccured = true;
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage() + 'line number is '+ex.getLineNumber() + ' and stack message is '+ex.getStackTraceString()));
                      rScript  = 'displaynone();'; 
      } 


}
    



} // end of class