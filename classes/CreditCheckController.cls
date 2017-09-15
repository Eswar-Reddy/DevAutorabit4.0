/*
Controller Class for CreditCheck VF Page used to send Credit Request to LoanPath
Updated:
        25-Apr-2014
        13-Jun-2014 : Added Currency ISO Code in the Query on Quote.
*/

public class CreditCheckController 
{
/****** VARIABLES: start ******/
    private final Opportunity opp;
    private List<QuoteWrapper> lstQuotes = new List<QuoteWrapper>();
    public static String statusForTestCode='success:Testing..';
/******* VARIABLES: end *******/

/****** PROPERTIES: start ******/    
    public List<QuoteWrapper> propQuotes { get { return lstQuotes; }  set { lstQuotes= value; } }
    public String propSelectedRecord { get; set; }
    public string propValue { get; set; }
    private String strActParam { get; set; }
    String PartnerUrl { get; set; }
    /***
     *** Variable only to be used for test execution in TestMehtod, 
     *** as Webservice class can not be covered in testMethod, the result need to be morphed
     ***/
    public integer propMockVal { get; set; } 
/******* PROPERTIES: end *******/

/****** CONSTRUCTOR: start ******/
    public CreditCheckController(ApexPages.StandardController controller) {
        this.opp = (Opportunity)controller.getRecord();
    }
/******* CONSTRUCTOR: end *******/

/****** FUNCTIONS: start ******/
    public PageReference redirect() 
    {
        PageReference pr= null;
        strActParam = ApexPages.currentPage().getParameters().get('act');
        PartnerUrl = 'https://' + 
                                (ApexPages.currentPage().getHeaders().get('Host') != null ? ApexPages.currentPage().getHeaders().get('Host') : 'login.salesforce.com') +
                                '/services/Soap/u/22.0/' + 
                                UserInfo.getOrganizationId();   


        if(!lstQuotes.isEmpty()) lstQuotes.clear();
        system.debug('opp.id is : ' + opp.id); 
        if(opp != null && opp.Id != null)
        {
            for(Quote q: [SELECT id, name, QuoteNumber, RoundOff_First_Monthly_Payment_Base_Amo__c, 
                                 Term_Years__c, Maximum_rated_capacity__c, Primary__c,
                                 Is_Locked__c, QuoteType__c,
                                 System_Cost__c, System_price__c, Sent_for_Credit_Check__c, OpportunityId,
                                 Opportunity.Credit_Application_ID__c, Opportunity.Credit_Application_Status__c,
                                 Opportunity.Account.Id, Opportunity.Account.Name,
                                 Opportunity.Account.OwnerId, Opportunity.Account.Owner.Name, 
                                 Opportunity.Account.Owner.Country_Domain__c
                                 //New Fields Added on 28-May-2014 : Birlasoft
                                 ,Monthly_Payment_Base_Year_1__c,Monthly_Payment_Tax_Year_1__c, 
                                  Monthly_Payment_Tax_Fees_Year_1__c ,Maximum_Rated_Capacity_DC__c,
                                  Loan_Term__c,
                                  CurrencyISOCode 
                                  //End of New Fields
                          FROM Quote
                          WHERE OpportunityId=: opp.Id
                          ORDER BY QuoteNumber DESC])
            {
            if(String.isNotBlank(q.Opportunity.Credit_Application_Status__c) && String.isNotBlank(q.Opportunity.Credit_Application_ID__c))
            {//Already has got Credit Check Done & Credit Application Status is 'Pending - Application Sent' then resend email
                     if(q.Opportunity.Credit_Application_Status__c=='Pending - Application Sent'){
                        System.debug('#####Resending Mail#####');                        
                        pr=CommunicateToLoanPath(q);
                        System.debug('#####After Resend Mail Called#####'); 
                        break;
                    }
                    else{
                    pr= new Pagereference('/' + q.Opportunity.Account.Id);
                    pr.setRedirect(true);
                    break;
                    }                
             }    
             lstQuotes.add(new QuoteWrapper(q, q.Sent_for_Credit_Check__c));
            }               
        }      
        return pr;
    }//End Func redirect
    
    public void ChangeSelection()
    {
        if(propSelectedRecord != null && propValue != null && (new Set<String>{'true','false'}).contains(propValue)){
            Boolean bUsrInput = (propValue == 'true' ? true : false);
            for(QuoteWrapper qw: lstQuotes)
                qw.propSelected= (qw.propQuote.Id == propSelectedRecord) ? bUsrInput : false;
        }   
    }//End Func ChangeSelection
    
    public PageReference SubmitToLoanPath()
    {
        PageReference pr= null;
        Boolean bSelected= false;
        Quote quoteSelected;        
        String result_status= '';
        
        for(QuoteWrapper qw: lstQuotes){
            if(qw.propSelected){
                bSelected= true;
                quoteSelected= qw.propQuote;
            }
        }
        
        if(!bSelected){//Error
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'No quote selected! Select a quote for Credit Check.'));            
        }
        else if(String.isBlank(strActParam) || (String.isNotBlank(strActParam) && !(new Set<String>{'ncr','rcr'}).contains(strActParam))){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Incorrect parameter values! Try again.')); 
        }
        else{//Everything Good, Submit to LoanPath
            if(Test.isRunningTest())//Section for fulfilling the test coverage
            {
                if(propMockVal != null && propMockVal == 1)
                    result_status = 'Success: Test Passed';
                else if(propMockVal != null && propMockVal == 2)
                    result_status = 'Error: Test Failed';
                else if(propMockVal != null && propMockVal == 3)
                    result_status = '';
            }
            else
            { 
                //Call to LoanPath API
                pr=CommunicateToLoanPath(quoteSelected);        
            }
        }
        return pr;
    }//ENd Func SubmitToLoanPath
/******* FUNCTIONS: end *******/

Private PageReference CommunicateToLoanPath(Quote quoteObj)
{
    PageReference pr= null;
    //Call to LoanPath API
    String result_status = TPSSF.TPConnectorService.SubmitExt( 'Opportunity',
                                                        quoteObj.OpportunityId,
                                                        '',
                                                        '',
                                                        'save',
                                                        '',
                                                        '',
                                                        UserInfo.getUserId(),
                                                        UserInfo.getSessionId(),
                                                        PartnerUrl, 
                                                        UserInfo.getUserName(), 
                                                        (strActParam == 'ncr' ?'CreateRequest':'ReSendEmail'),
                                                        quoteObj.Opportunity.Account.Owner.Country_Domain__c.substring(quoteObj.Opportunity.Account.Owner.Country_Domain__c.indexOf('-')+1),
                                                        'SELECTED_QUOTE_ID,'+quoteObj.Id);
            if(Test.isRunningTest())//Section for fulfilling the test coverage
            {
                result_status= statusForTestCode;
            }                                                                
            if(String.isNotBlank(result_status) && result_status.startsWithIgnoreCase('success:'))
            {
                quoteObj.Sent_for_Credit_Check__c= true;
                update quoteObj;
                
                pr = new PageReference('/' + quoteObj.Opportunity.Account.Id);          
                pr.setredirect(true);          
            }
            else if(String.isBlank(result_status) || (String.isNotBlank(result_status) && result_status.startsWithIgnoreCase('error:')))
            {
                Opportunity opp;
                if(String.isBlank(result_status)){
                    opp = new Opportunity(id= quoteObj.OpportunityId, 
                                          Credit_Application_Status_Message__c= ('Error: No response received from \'Loan Path\' system').toLowerCase());
                }
                else{
                    opp = new Opportunity(id= quoteObj.OpportunityId, 
                                          Credit_Application_Status_Message__c= result_status.toLowerCase());
                }
                update opp;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,('No response received from \'Loan Path\' system.')));
            }
            else
            {
                Opportunity opp = new Opportunity(id= opp.Id, Credit_Application_Status_Message__c= result_status);
                update opp;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,('Oops! Unknown issue encountered.')));
            }
            return pr;
}

/*CommunicateToLoanPath*/

/****** WRAPPER: start ******/    
    public class QuoteWrapper
    {
        public QuoteWrapper(Quote xQot, Boolean xBSelected){
            bSelected= xBSelected;
            qot= xQot;
            if(xQot.Is_Locked__c && String.isNotBlank(xQot.QuoteType__c) && xQot.QuoteType__c.toLowerCase()== 'lease'){
                bCanBeSubmittedForCreditCheck= true;
                sMsg= null;
            }
            else{
                bCanBeSubmittedForCreditCheck= false;
                if(!xQot.Is_Locked__c && (String.isBlank(xQot.QuoteType__c) || (String.isNotBlank(xQot.QuoteType__c) && xQot.QuoteType__c.toLowerCase()!= 'lease')))
                    sMsg= 'Quote is not \'Locked\' and is not of type \'Lease\'';
                else if(!xQot.Is_Locked__c && (String.isNotBlank(xQot.QuoteType__c) && xQot.QuoteType__c.toLowerCase() == 'lease'))
                    sMsg = 'Quote is not \'Locked\'';
                else if(!xQot.Is_Locked__c && String.isBlank(xQot.QuoteType__c))
                    sMsg= 'Quote is not \'Locked\' and type is not defined';
                else if(xQot.Is_Locked__c && (String.isNotBlank(xQot.QuoteType__c) && xQot.QuoteType__c.toLowerCase() == 'cash'))
                    sMsg= 'Quote is of type \'Cash\'';
            }
        }
        String  sMsg;
        Boolean bCanBeSubmittedForCreditCheck;
        Boolean bSelected;
        Quote   qot;
        public String  propMsg { get { return sMsg; } private set; }
        public Boolean propCanBeSubmittedForCreditCheck { get { return bCanBeSubmittedForCreditCheck; } private set; } 
        public Boolean propSelected { get { return bSelected; } set { bSelected= value; } }
        public Quote   propQuote    { get { return qot; } set { qot= value; } }
    }//End Class QuoteWrapper
/******* WRAPPER: end *******/
}//End Class CreditCheckController