/*
This controller override the New case button when go though the Case tab.
If case's record type is Feedback then Contact selected should be 'unIdetified'
*/
public class NewCaseIntermediateController{
	public boolean isFeedbackCase{get;set;}
	public String contactID{get;set;}
	public String accountID{get;set;}
	public String actualContactID{get;set;}
	public String actualAccountID{get;set;}
	public String recordTypeID{get;set;}
	public String confirmToken{get;set;}
	public String newUrl {get;set;}
	public String newU {get;set;}
	//for case # 00045421
	public static Id euInspectionCaseRecTypeId;
	public static Id partnerAccRecTypeId;
	public static Id resAccRecTypeId;
	public static Map<String, Schema.RecordTypeInfo> nameToAccountRecordTypeInfoMap;
	
	static {    
        euInspectionCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('New Inspections').getRecordTypeId();
        nameToAccountRecordTypeInfoMap = Schema.SObjectType.Account.getRecordTypeInfosByName();
        if(nameToAccountRecordTypeInfoMap.get('Partner')!=null)
        	partnerAccRecTypeId = nameToAccountRecordTypeInfoMap.get('Partner').getRecordTypeId();
        if(nameToAccountRecordTypeInfoMap.get('Residential Customer')!=null)
        	resAccRecTypeId = nameToAccountRecordTypeInfoMap.get('Residential Customer').getRecordTypeId();
    }    
    //for case # 00045421
	public NewCaseIntermediateController(ApexPages.standardController std){  
	    isFeedbackCase =  false;
	    actualContactID = '';
	    actualAccountID = '';
	  
	    Case cs= (Case)std.getRecord();     
	    String Url = ApexPages.currentPage().getURL();  
	    if(Url == null){
	    	return;
	    }
	    newU = url.replace('/apex/NewCaseIntermediatePage?','/500/e?');
	    newU = newU.replace('sfdc.override','nooverride');
	    newUrl = newU.replace('&save_new=1','');   
	     //Get the ID of the case record type 'Feedback'
	    List<RecordType> lstRecordType  = new List<RecordType>([Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType ='Case' and Name = 'Feedback']);
	    recordTypeID = ApexPages.currentPage().getParameters().get('RecordType');
	    confirmToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
	    //Set the isFeedbackCase variable true if recordtype is feedback and UnIdentified Contact exists and New button is clicked from tab, not from related list
	    if(ApexPages.currentPage().getParameters().get('RecordType')!=null && lstRecordType.size()>0 && ApexPages.currentPage().getParameters().get('def_contact_id')==null && ApexPages.currentPage().getParameters().get('def_account_id')==null){
	        if(ApexPages.currentPage().getParameters().get('RecordType') == lstRecordType[0].ID){            
	            List<Contact> con = new List<Contact>([Select id,accountID from Contact where name='UnIdentified']);
	            if(con.size()>0){
	                isFeedbackCase =  true;
	                contactID = con[0].ID;
	                accountID = con[0].accountID; 
	            }
	            
	        }
	    }
	    if(isFeedbackCase){
	      newUrl = newUrl + '&def_contact_id='+ contactID + '&def_account_id='+ accountID;	
	    }
	    //for case # 00045421
	    else if(recordTypeID == euInspectionCaseRecTypeId){
	    	String accountId = ApexPages.currentPage().getParameters().get('def_account_id');
	    	String contactId = ApexPages.currentPage().getParameters().get('def_contact_id');
	    	if(accountId!=null){
		    	List<Account> accList = [Select Id, Name, RecordTypeId, Oracle_Operating_Unit__c, Type from Account where Id = :accountId];
		    	Account acc;
		    	if(accList.size()>0)
		    		acc = accList.get(0);
		    	if(contactId == null){
		    		if(partnerAccRecTypeId == acc.RecordTypeId){
		    			newUrl = removeParameter(newUrl, 'def_account_id');	    			
		    			newUrl = newUrl + '&CF00N80000004HKR4=' + acc.Name;
		    			newUrl = newUrl + '&00N80000003bQkI=' + acc.Oracle_Operating_Unit__c;
		    			newUrl = newUrl + '&00NS0000000oWVu=' + acc.Type;	    			
		    		}else if(resAccRecTypeId == acc.RecordTypeId){
		    			
		    		}
		    	}else{
		    		List<Contact> contactList = [Select Id, Name from Contact where Id = :contactId];
		    		Contact con;
		    		if(contactList.size()>0)
		    			con = contactList.get(0);
		    		newUrl = removeParameter(newUrl, 'def_account_id');
		    		newUrl = removeParameter(newUrl, 'def_contact_id');
		    		if(partnerAccRecTypeId == acc.RecordTypeId){
			    		newUrl = newUrl + '&CF00N80000004HKR4=' + acc.Name;
			    		newUrl = newUrl + '&00N80000003bQkI=' + acc.Oracle_Operating_Unit__c;
			    		newUrl = newUrl + '&00NS0000000oWVu=' + acc.Type;
			    		newUrl = newUrl + '&CF00NS0000000ogHO=' + con.Name;
		    		}else if(resAccRecTypeId == acc.RecordTypeId){
		    			
		    		}
		    	}
		    }
	    }
	    //for case # 00045421 
	}    
	//for case # 00045421
	public String removeParameter(String url, String parameter){
		Integer indexOfParameter = url.indexOf(parameter);
		//System.debug(loggingLevel.INFO, 'indexOfParameter-> ' + indexOfParameter); 
		String firstPart = url.substring(0, indexOfParameter);
		//System.debug(loggingLevel.INFO, 'firstPart-> ' + firstPart);
		String secondPart = url.substring(indexOfParameter);
		//System.debug(loggingLevel.INFO, 'secondPart-> ' + secondPart);
		secondPart = secondPart.substring(secondPart.indexOf('&')+1);
		//System.debug(loggingLevel.INFO, 'secondPart-> ' + secondPart);
		return firstPart + secondPart;		 
	}
	//for case # 00045421
}