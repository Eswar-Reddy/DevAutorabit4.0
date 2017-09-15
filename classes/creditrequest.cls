public with sharing class creditrequest 
{
/***** VARIABLE *****/
    private boolean bError = false;
    private String result_status;
    private String result_status_error; 
    private final Opportunity opp;
    public string PartnerUrl;
    private Opportunity oppInContext = new Opportunity();
    private String strActParam = '';
/*** END VARIABLE ***/

/***** PROPERTY *****/
    public boolean propError { get { return bError; } set { bError = value; } }
    public String  propErrorString { get { return result_status_error; } set { result_status_error = value; } }
    public opportunity propOpp { get { return oppInContext; } set { oppInContext = value; } }
    
    public integer propMockVal { get; set; } //Variable only to be used for test execution in TestMehtod, as Webservice class can not be covered in testMethod, the result need to be morphed
 /*** END PROPERTY ***/

/***** CONSTRUCTOR *****/
    public creditrequest(ApexPages.StandardController controller) 
    {  
        this.opp = (Opportunity)controller.getRecord();
        strActParam = ApexPages.currentPage().getParameters().get('act');
        PartnerUrl = 'https://' + 
                     (ApexPages.currentPage().getHeaders().get('Host') != null ? ApexPages.currentPage().getHeaders().get('Host') : 'login.salesforce.com') +
                     '/services/Soap/u/22.0/' + 
                     UserInfo.getOrganizationId();
    }
/*** END CONSTRUCTOR ***/

/***** FUNCTION *****/
    public PageReference redirect() 
    {
        //House keeping
        bError = false;
        result_status = '';
        result_status_error = '';
        oppInContext = new Opportunity();
        PageReference pr = null;
        oppInContext = [SELECT id, AccountId, Account.Name      
                        FROM Opportunity 
                        WHERE id =: opp.Id];
        //sangita Added for TPO Australia - Loanpath Integration
        User user = [SELECT id, country_domain__c, name FROM User WHERE id=:UserInfo.getUserId()];

        //Process request
        if(oppInContext != null)
        {
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
            result_status = TPSSF.TPConnectorService.SubmitExt(
                                               'Opportunity',
                                                opp.Id,
                                                 '' ,
                                                 '' ,
                                                'save',
                                                '' ,
                                                '',
                                                UserInfo.getUserId(),
                                                UserInfo.getSessionId(),
                                                PartnerUrl, 
                                                UserInfo.getUserName(), 
                                                (strActParam == 'ncr' ? 'CreateRequest' : 'ReSendEmail'),
                                                user.country_domain__c.substring(user.country_domain__c.indexOf('-')+1),
                                                '');//replace au with country
                                               
                                                
              /*  result_status = TPSSF.TPConnectorService.Submit('Opportunity', 
                                                                opp.Id, 
                                                                '' ,
                                                                '' ,
                                                                'save',
                                                                '' ,
                                                                '',
                                                                UserInfo.getUserId(),
                                                                UserInfo.getSessionId(),
                                                                PartnerUrl, 
                                                                UserInfo.getUserName(), 
                                                                (strActParam == 'ncr' ? 'CreateRequest' : 'ReSendEmail'));
                                                                */
                                                                
            }

SYSTEM.DEBUG('>>>' + 
            '\nopp.Id: ' + opp.Id + 
            '\nUserInfo.getUserId(): ' + UserInfo.getUserId() + 
            '\nUserInfo.getSessionId(): ' + UserInfo.getSessionId() + 
            '\nPartnerUrl: ' + PartnerUrl + 
            '\nUserInfo.getUserName(): ' + UserInfo.getUserName() + 
            '\nresult_status: ' + result_status);
            
            if(String.isNotBlank(result_status) && result_status.startsWithIgnoreCase('success:'))
            {
                pr = new PageReference('/' + oppInContext.AccountId);          
                pr.setredirect(true);          
            }
            else if(String.isBlank(result_status) || (String.isNotBlank(result_status) && result_status.startsWithIgnoreCase('error:')))
            {
                String result_status_message = '';
                if(String.isBlank(result_status)){
                    result_status = '';
                    result_status_message = ('Error: No response received from \'Loan Path\' system').toLowerCase();
                    result_status_error = result_status_message;
                }
                else
                {
                    result_status_message = result_status;
                    result_status_error = result_status_message; 
                    result_status = '';                                       
                }
                Opportunity opp = new Opportunity(id= opp.Id, Credit_Application_Status_Message__c= result_status_message); //Credit_Application_Status__c= result_status,
                update opp; 
                
                bError = true;
            }
        }         
        return pr;
    }
/*** END FUNCTION ***/    
}//End Class creditrequest