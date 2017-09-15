/****************************************************************************
Class                   :   POWizardCreateContactController
Related Page            :   POWizardCreateContact
Created By              :   Appirio Offshore
Created On              :   Feb 19, 2010
Desciption              :   Controller apex class for vf page POWizardCreateContact.
Related PR              :   PR-03773
******************************************************************************/
public class POWizardCreateContactController{
public string acctid{get;set;}
public string fname{get;set;}
public string lname{get;set;}
public string phone{get;set;}
public Contact newcontact{get;set;}
public List<Contact> contactList{get;set;}
//For error messages
/*public string blankFNameErrorMsg{get;set;} 
public string blankLNameErrorMsg{get;set;} 
public string blankPhoneErrorMsg{get;set;} 
public string duplicateNameErrorMsg{get;set;} 
public string duplicatePhoneErrorMsg{get;set;} */
public Boolean isError{get;set;}
public Boolean isClose {get;set;}

    public POWizardCreateContactController(){
        newcontact = new Contact(); 
        isClose  = false;
        acctid = ApexPages.currentPage().getParameters().get('accid');
    }
    
    public PageReference Save(){
        isError = false;
         for(Contact con: [Select Id,FirstName,LastName,Phone from Contact where AccountId =: acctid and (FirstName = :newcontact.FirstName or LastName = :newcontact.LastName)]){
                if(con.FirstName == newcontact.FirstName && con.LastName == newcontact.LastName ){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Contact Name already Exist'));   
                   isError = true; 
                }else if(con.Phone == newcontact.phone){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Phone already exist.'));   
                   isError = true; 
                }
        }
        
        if(isError == true){
            return null;
        } else{         
             newcontact.AccountId = acctid;        
             insert newcontact;
             isClose  = true;
         }
        return null;
    }
    
    public PageReference Cancel(){
    return null;
    }
    
}