/**************************************************
** Case - 00080946
**Created By- Jitendra Kothari
**Created On- Oct 07 2011
**Desciption- This controller class is load all contact records on the basis of Account in a Opportunity on a Component.
*****************************************************/
public class OpportunityContactInfoController {
    public List<Contact> contacts {get;set;}
    public boolean isRecordFound{get;set;}
    public Account account{get;set;}
    public String labelMessage {get;set;}
    public Boolean accountRendered {get;set;}
    public String oppId {get; set;} 
    //Start 00093615
    public String oppLink {
        get{            
           return URL.getSalesforceBaseUrl().toExternalForm();           
        } 
        
        set;
    } 
    //End 00093615
    
    public Opportunity opportunity{
        get{
            System.debug('Debug: oppId ' + oppId);
      
          if (opportunity != null) {
            return opportunity;
          }
          //Added Email__c field in query regarding task 93615
          //Added opportunity owner regarding case 00096365
          if (oppId != null && oppId != '') {                        
            opportunity = [select accountId, account.RecordType.Name, account.BillingStreet, account.BillingState, account.BillingPostalCode, 
                account.BillingCountry, account.BillingCity,account.Phone,account.Email__c,Address_URL__c, owner.Name, Name, Id from opportunity where Id =:oppId];
            List<String> accountIds = new List<String>();
            if(opportunity.accountId != null && 
                (opportunity.account.RecordType.Name.equals('Residential Customer')
                || opportunity.account.RecordType.Name.equals('Commercial Customer'))){
                accountIds.add(opportunity.accountId);
            }
          
                if(accountIds.size()>0){
                    account = opportunity.account;                  
                    accountRendered = true;
                    contacts = loadContacts(accountIds);
                    if(contacts!= null && contacts.size()>0)
                          isRecordFound = true;
                    else{
                        labelMessage = System.Label.DisplayContactNoRecordFound;
                    }
                }else{
                    labelMessage = System.Label.DisplayContactPartnerAccountMsg;
                }
            }
            return opportunity;
        }
        set;
    }
    
    public List<Contact> loadContacts(List<String> accountIdList){
        List<String> recordTypeList = new List<String>();
        recordTypeList.add('Residential Customer');
        recordTypeList.add('Commercial Customer') ;
        //Case#00106101 selected MobilePhone
        List<Contact> contactList = [select Id, Name, Title, Email, Phone, Best_Time_to_Call__c,mobilephone from Contact where accountId in :accountIdList and account.RecordType.Name  in :recordTypeList  limit 100];
        return contactList;
    }
}