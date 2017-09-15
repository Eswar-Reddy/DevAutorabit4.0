/***********************************
** Created By - Kapil Goutam
** Created on- May 8 2009
** Last Modified by- Prakash Gyamlani
** Last Modified on- May 28 2009
** Description- Controller class form SendContract Page
** Version - 1.3
*************************************/
public class SendContractController{
   public string contractId{get;set;}
  public string contactId{get;set;}
  public Account acc{get;set;}
  public Contract contract{get;set;} 
  public List<SelectOption> optionsRecipientWithRole{get;set;}
  public string recipient1{get;set;}
  public string recipient2{get;set;}
  public string recipient3{get;set;}
  //public string Territory_SunPower{get;set;}
  //public string Territory_SunPower_Executive_Email{get;set;}
  //public string SunPower_Executive_Email_Updated{get;set;}
  public string message{get;set;}
  public Contract_Reference__c tempContract {get;set;}

  
  public SendContractController() {
       if(ApexPages.CurrentPage().getParameters().get('cid') != null){
           contractId = ApexPages.CurrentPage().getParameters().get('cid');
           tempContract= new Contract_Reference__c();
           populate();
               
       }
  }

  public void populate(){
       List<Contract> contractLst = [Select Id, AccountId,  Contract_Type__c , ContractNumber from Contract where Id=:contractId limit 1];
       if(contractLst != null && contractLst.size()>0)
           contract = contractLst[0];
       if(contract != null) {
           if(contract.Contract_Type__c != null) {
                List<Contract_Reference__c> contractRef = [Select e_Signature_Message__c,SunPower_Executive__c from Contract_Reference__c where Name=:contract.Contract_Type__c LIMIT 1];
                if(contractRef != null && contractRef.size()>0) {
                    message = contractRef[0].e_Signature_Message__c;
                    //Territory_SunPower = contractRef[0].SunPower_Executive__c;
                    //Territory_SunPower_Executive_Email = contractRef[0].SunPower_Executive_Email__c;
                      tempContract.SunPower_Executive__c = contractRef[0].SunPower_Executive__c;
                }   
           }     
           
           List<Account> accLst = [Select Name From Account where Id=:contract.AccountId LIMIT 1];
           if(accLst != null && accLst.size()>0)
               acc = accLst[0];
        }
        if(acc != null){
            populateSelectOption();
        }//if end   
  }//Function ends
  

  //function to populate select option as name + contact role name
  public void populateSelectOption(){
     contactRoles cr;
     String conname;
     List<AccountContactRole> acRole;
     //Set<String> contactIdSet = null;//for case # 00059875     
     List<contactRoles> listContactRoles = new List<contactRoles>();
     //start for case # 00059875
     Set<String> acRolesList = null;
     //List<Contact> contactsList = new List<Contact>([Select Id, LastName, FirstName from Contact where AccountId =:contract.AccountId]);
     Map<Id, Contact> contactsMap = new  Map<Id, Contact>([Select Id, LastName, FirstName from Contact where AccountId =:contract.AccountId order by Name asc]);
     Map<Id, AccountContactRole> acRolesMap = new Map<Id, AccountContactRole>([Select Role, Id, AccountId, ContactId, Contact.Name From AccountContactRole where ContactId=:contactsMap.keySet() order by Contact.Name asc]);
     Map<Id, Set<String>> acContactRolesMap = new Map<Id, Set<String>>();
     for(AccountContactRole acr : acRolesMap.values()){
     	//system.debug(loggingLevel.Info, 'contact:' + acr.Contact.Name);
     	//system.debug(loggingLevel.Info, 'acRole:' + acr.Role);     	
	     if(acContactRolesMap.containsKey(acr.ContactId)){
	       	if(acr.Role!=null){
	       		acRolesList = acContactRolesMap.get(acr.ContactId);
	       		acRolesList.add(acr.Role);
	       	}
	       	//system.debug(loggingLevel.Info, 'if acRolesList:' + acRolesList);	        	
	       	if(acRolesList.size()>0)  
	     		acContactRolesMap.put(acr.ContactId,acRolesList);
	 	 }else{	 	 		        
	        acRolesList =  new Set<String>();
	        if(acr.Role!=null)
	       		acRolesList.add(acr.Role);
	       	//system.debug(loggingLevel.Info, 'else acRolesList:' + acRolesList);	  
	        if(acRolesList.size()>0)  
	     		acContactRolesMap.put(acr.ContactId,acRolesList);
	    }
     }
     //system.debug('con list:' + contactsList);
     //system.debug(loggingLevel.Info, 'acContactRolesMap map:' + acContactRolesMap);     
     //if(contactsList.Size()>0){
     if(contactsMap.Size()>0){
        //for(Contact c:contactsList){
        for(Contact c:contactsMap.values()){
        	//contactIdSet = new Set<String>();
        	//end for case # 00059875
            
            cr = new contactRoles();
            cr.contactId = c.id;
            if(c.FirstName != null)
                cr.contactName = c.FirstName + ' '+ c.LastName;
            else
                cr.contactName = c.LastName;    
            //start for case # 00059875
            //acRole = new List<AccountContactRole>([Select a.Role, a.Id, a.AccountId  From AccountContactRole a where ContactId=:c.id]);
            acRolesList = acContactRolesMap.get(c.Id);
            //system.debug('acRole list:' + acRole);
            //system.debug(loggingLevel.Info, 'acRole list:' + acRolesList);
            /*if(acRole.Size()>0){
                for(AccountContactRole acroleTemp:acRole){
                    cr.roleNameList.add(acroleTemp.Role);       
                }
            }*/
            if(acRolesList!=null && acRolesList.Size()>0){
                cr.roleNameList.addAll(acRolesList);  
            }
            //end for case # 00059875
            listContactRoles.add(cr);
           
        }//for end
         optionsRecipientWithRole = new List<SelectOption>();
         conname = '--None--';
         optionsRecipientWithRole.add(new SelectOption(conname, conname));
         for(contactRoles cr2:listContactRoles){
             if(cr2.roleNameList != null && cr2.roleNameList.Size()>0){
                for(String str:cr2.roleNameList){
                    conname =  cr2.contactName + ' (' + str + ')';
                    optionsRecipientWithRole.add(new SelectOption(cr2.contactId, conname));
                }
             }   
            else {
                conname =  cr2.contactName; 
                optionsRecipientWithRole.add(new SelectOption(cr2.contactId, conname));
            }   
         }//for end  

     }//if end
  }//function ends
  
  
  public PageReference proceed(){
    string val = '--None--';
    PageReference pr = null;         
    try{
        if(recipient1 == null || recipient1 == val) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'At least 1 recipient is required.');
            ApexPages.addMessage(msg);
            return null;
        }
        echosign_dev1__SIGN_Agreement__c aggrementNew = new echosign_dev1__SIGN_Agreement__c();
        aggrementNew.Name = contract.Contract_Type__c;
        aggrementNew.echosign_dev1__Recipient__c = recipient1;
        if(recipient2 != null && recipient2 != val) 
            aggrementNew.echosign_dev1__Recipient2__c = recipient2;
        if(recipient3 != null && recipient3 != val) 
            aggrementNew.echosign_dev1__Recipient3__c = recipient3;
       /*     
        if(SunPower_Executive_Email_Updated != null && SunPower_Executive_Email_Updated != '') {
           if(isValidEmail(SunPower_Executive_Email_Updated)) {   
                aggrementNew.echosign_dev1__More_Recipients__c = SunPower_Executive_Email_Updated;
           }else {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid executive email address.');
                ApexPages.addMessage(msg);
                return null;
           }                
        }
        else {
            aggrementNew.echosign_dev1__More_Recipients__c = Territory_SunPower_Executive_Email;
        }           
       */
 
       if(tempContract.SunPower_Executive__c == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Sun Power Executive must not be blank');
            ApexPages.addMessage(msg);
            return null;
       }else{
        List<User> usersList = [select ID,username,Email from User where id = :tempContract.SunPower_Executive__c LIMIT 1];
        if(usersList != null || usersList.size()>0){
            aggrementNew.echosign_dev1__More_Recipients__c = usersList[0].Email; 
        }
       }
        aggrementNew.echosign_dev1__Message__c = message;
        aggrementNew.echosign_dev1__Contract__c = contractId;
        insert aggrementNew;
    /* Going to Update Contract starts here */
        List<Contract> conList =[select Id,CompanySignedID,CustomerSignedID from Contract where Id = :contractId];
        if(conList != null && conList.size()>0){
            conList[0].CompanySignedID  = tempContract.SunPower_Executive__c;
            conList[0].CustomerSignedID = recipient1;
            upsert conList[0];
        }
    /* Going to Update Contract ends here */                
        pr = new PageReference('/'+ aggrementNew.Id);
    }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
            return null;

    }   
    return pr;
  }

  public PageReference cancel() {
     PageReference pr = new PageReference('/'+contractId);
     return pr;
  }
  
 //function to check e mail validation
  public boolean isValidEmail(String str){
    if (str.indexOf('.') > 2 && str.indexOf('@') > 0)
        return true;
    return false;
  }
  
  
  ///class which is used to popualate select option as name + contact role name
  public class contactRoles{
     public String contactId{get;set;}
     public String contactName{get;set;}
     public List<String> roleNameList{get;set;}
     public contactRoles(){
        roleNameList = new List<String>();
     }
     
  }
  
}