//Case#00075466

public class LeadNewController {
public String newUrl {get; set;}  

//Constructor
public LeadNewController (ApexPages.StandardController controller){    
    newUrl = ApexPages.currentPage().getURL();                             
}

//URL to redirect
public PageReference redirect(){       
    newUrl = newUrl.replace('/apex/LeadNew?','/00Q/e?');
    newUrl = newUrl.replace('sfdc.override','nooverride');
    newUrl = newUrl.replace('&save_new=1','');
    
    PageReference returnURL = new PageReference(newUrl);
    system.debug('----------'+returnURL);
             
    //Case#00075466
    //Populate Lead fields from Account/Contact if Lead is being created from Account/Contact    
    String conID = ApexPages.currentPage().getParameters().get('CF'+System.Label.LeadContactFieldID+'_lkid');
    String accID = ApexPages.currentPage().getParameters().get('CF'+System.Label.LeadAccountFieldID+'_lkid');
    
    //if from Contact
    if(conID !=null){
        //Get Contact detail
        List<Contact> lstCon = new List<Contact>([Select id,AccountID,Account.Name,phone,Department,salutation,FirstName,
                                      LastName,Title,Phone_Direct__c,Email,Account.BillingCity,
                                      Account.BillingCountry,Account.BillingPostalCode,Account.BillingState,
                                      Account.BillingStreet from Contact where ID = :conID]);
        Contact con = new Contact();
        if(lstCon.size()>0){
            con = lstCon[0];
        }
        //Set Lead information
        returnURL.getParameters().put('CF'+System.Label.LeadAccountFieldID+'_lkid', con.AccountID);
        returnURL.getParameters().put('CF'+System.Label.LeadAccountFieldID, con.Account.Name);
        returnURL.getParameters().put('lea8', con.phone);
        returnURL.getParameters().put(System.Label.LeadDepartmentFieldID, con.Department);
        returnURL.getParameters().put('name_salutationlea2', con.salutation);
        returnURL.getParameters().put('name_firstlea2', con.FirstName);
        returnURL.getParameters().put('name_lastlea2', con.LastName);
        returnURL.getParameters().put('lea4', con.Title);
        returnURL.getParameters().put(System.Label.LeadPhoneDirectFieldID, con.Phone_Direct__c);
        returnURL.getParameters().put('lea11', con.Email);
        setAddress(con.Account,returnURL);
    } 
    
    //if from Account
    if(accID !=null){
        List<Account> lstAcc = new List<Account>([Select id,Name,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet from Account where ID = :accID]);
        Account acc = new Account();
        if(lstAcc.size()>0){
            acc = lstAcc[0];
        }
        setAddress(acc,returnURL);
    }  
    
    return returnURL;      
}


Private void setAddress(Account acc,PageReference ref){        
        ref.getParameters().put('lea3', acc.Name);        
        ref.getParameters().put('lea16city', acc.BillingCity);
        ref.getParameters().put('lea16country', acc.BillingCountry);
        ref.getParameters().put('lea16zip', acc.BillingPostalCode);
        ref.getParameters().put('lea16state', acc.BillingState);
        ref.getParameters().put('lea16street', acc.BillingStreet);
}

}