/**************************************************
** Case - 00011814
**Created By- Kapil Goutam
**Created On- Nov 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- This controller class is load all contact records on the basis of Account in a opportunity.
*****************************************************/ 

public class DisplayContactsController{

public List<Contact> contacts {get;set;}
public boolean isRecordFound{get;set;}
public Account account{get;set;}
public String labelMessage {get;set;}
public Boolean accountRendered {get;set;}
public Boolean isPartner {get;set;}
public DisplayContactsController(){
    isRecordFound = false;
    accountRendered  = false;
    //Case#00087597
    isPartner = false;  
    if(userInfo.getUserType()== 'PowerPartner'){
        isPartner = true;
    }
    
    List<Opportunity> opportunities = [select accountId,account.IsPersonAccount,account.RecordType.Name, account.BillingStreet, account.BillingState, account.BillingPostalCode, account.BillingCountry, account.BillingCity,account.Phone from opportunity where Id =:ApexPages.currentPage().getParameters().get('Id')];
    List<String> accountIds = new List<String>();
    
    for(Opportunity opportunity : opportunities){
        if(opportunity .accountId != null&&(opportunity.account.RecordType.Name.equals('Residential Customer')||opportunity.account.RecordType.Name.equals('Commercial Customer'))){
            accountIds.add(opportunity.accountId);
        }
    }
    if(accountIds.size()>0){
        if(opportunities.size()>0){
            account = opportunities.get(0).account;
        }else{
            account = new Account();
        }
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

public DisplayContactsController(ApexPages.StandardController stdController){      
    isRecordFound = false;
    accountRendered  = false;    
    //Case#00087597
    isPartner = false;  
    if(userInfo.getUserType()== 'PowerPartner'){
        isPartner = true;
    }
    
    List<Opportunity> opportunities = [select accountId,account.IsPersonAccount,account.RecordType.Name, account.BillingStreet, account.BillingState, account.BillingPostalCode, account.BillingCountry, account.BillingCity,account.Phone from opportunity where Id =:ApexPages.currentPage().getParameters().get('Id')];
    List<String> accountIds = new List<String>();
    
    for(Opportunity opportunity : opportunities){
        if(opportunity .accountId != null&&(opportunity.account.RecordType.Name.equals('Residential Customer')||opportunity.account.RecordType.Name.equals('Commercial Customer'))){
            accountIds.add(opportunity.accountId);
        }
    }
    if(accountIds.size()>0){
        if(opportunities.size()>0){
            account = opportunities.get(0).account;
        }else{
            account = new Account();
        }
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


public List<Contact> loadContacts(List<String> accountIdList){
    List<String> recordTypeList = new List<String>();
    recordTypeList.add('Residential Customer');
    recordTypeList.add('Commercial Customer') ;
    //Added field mobilePhone for case 00100955
    List<Contact> contactList = [select Id,Name,Title,Email,Phone,Best_Time_to_Call__c,mobilePhone, Contact_Language__c from Contact where accountId in :accountIdList and account.RecordType.Name  in :recordTypeList  limit 100];
    return contactList;
}
}